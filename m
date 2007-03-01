Return-Path: <linux-kernel-owner+w=401wt.eu-S933166AbXCAI7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166AbXCAI7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 03:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933159AbXCAI7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 03:59:18 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:51115 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933152AbXCAI7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 03:59:17 -0500
To: akpm@linux-foundation.org
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20070301004111.c56f4fd1.akpm@linux-foundation.org> (message from
	Andrew Morton on Thu, 1 Mar 2007 00:41:11 -0800)
Subject: Re: [patch 03/22] fix deadlock in balance_dirty_pages
References: <20070227223809.684624012@szeredi.hu>
	<20070227223911.472192712@szeredi.hu>
	<20070228225853.8df5bdd0.akpm@linux-foundation.org>
	<E1HMfp2-0001fc-00@dorka.pomaz.szeredi.hu>
	<20070301002704.8fbbcda2.akpm@linux-foundation.org>
	<E1HMgmg-0001mc-00@dorka.pomaz.szeredi.hu> <20070301004111.c56f4fd1.akpm@linux-foundation.org>
Message-Id: <E1HMh7n-0001qk-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 01 Mar 2007 09:58:55 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm just not going to apply weird hacks to work around a bug which
> I do not understand, and I have spent way too much time trying to understand
> this one.

I suggest you apply patch #5 "balance dirty pages from loop device"
and see for yourself the same deadlock with a simple loopback mount.

I beleive _not_ doing balance_dirty_pages() in loop is rather a bigger
hack, then mine ;)

> So let us persist.
> 
> Please fully describe the role of i_mutex in this hang.

OK.  Added description of the multithreaded case, with i_mutex's role:

+ What if Pr_b is multithreaded?  The first thread will enter
+ balance_dirty_pages() and loop there as shown above.  It will hold
+ i_mutex for the inode, taken in generic_file_aio_write().
+ 
+ The other theads now try to write back more data into the same file,
+ but will block on i_mutex.  So even with unlimited number of threads
+ no progress is made.

Thanks,
Miklos


From: Miklos Szeredi <mszeredi@suse.cz>

This deadlock happens, when dirty pages from one filesystem are
written back through another filesystem.  It easiest to demonstrate
with fuse although it could affect looback mounts as well (see
following patches).

Let's call the filesystems A(bove) and B(elow).  Process Pr_a is
writing to A, and process Pr_b is writing to B.

Pr_a is bash-shared-mapping.  Pr_b is the fuse filesystem daemon
(fusexmp_fh), for simplicity let's assume that Pr_b is single
threaded.

These are the simplified stack traces of these processes after the
deadlock:

Pr_a (bash-shared-mapping):

  (block on queue)
  fuse_writepage
  generic_writepages
  writeback_inodes
  balance_dirty_pages
  balance_dirty_pages_ratelimited_nr
  set_page_dirty_mapping_balance
  do_no_page


Pr_b (fusexmp_fh):

  io_schedule_timeout
  congestion_wait
  balance_dirty_pages
  balance_dirty_pages_ratelimited_nr
  generic_file_buffered_write
  generic_file_aio_write
  ext3_file_write
  do_sync_write
  vfs_write
  sys_pwrite64


Thanks to the aggressive nature of Pr_a, it can happen, that

  nr_file_dirty > dirty_thresh + margin

This is due to both nr_dirty growing and dirty_thresh shrinking, which
in turn is due to nr_file_mapped rapidly growing.  The exact size of
the margin at which the deadlock happens is not known, but it's around
100 pages.

At this point Pr_a enters balance_dirty_pages and starts to write back
some if it's dirty pages.  After submitting some requests, it blocks
on the request queue.

The first write request will trigger Pr_b to perform a write()
syscall.  This will submit a write request to the block device and
then may enter balance_dirty_pages().

The condition for exiting balance_dirty_pages() is

 - either that write_chunk pages have been written

 - or nr_file_dirty + nr_writeback < dirty_thresh

It is entirely possible that less than write_chunk pages were written,
in which case balance_dirty_pages() will not exit even after all the
submitted requests have been succesfully completed.

Which means that the write() syscall does not return.

Which means, that no more dirty pages from A will be written back, and
neither nr_writeback nor nr_file_dirty will decrease.

Which means, that balance_dirty_pages() will loop forever.

What if Pr_b is multithreaded?  The first thread will enter
balance_dirty_pages() and loop there as shown above.  It will hold
i_mutex for the inode, taken in generic_file_aio_write().

The other theads now try to write back more data into the same file,
but will block on i_mutex.  So even with unlimited number of threads
no progress is made.

Q.E.D.

The solution is to exit balance_dirty_pages() on the condition, that
there are only a few dirty + writeback pages for this backing dev.  This
makes sure, that there is always some progress with this setup.

The number of outstanding dirty + written pages is limited to 8, which
means that when over the threshold (dirty_exceeded == 1), each
filesystem may only effectively pin a maximum of 16 (+8 because of
ratelimiting) extra pages.

Note: a similar safety vent is always needed if there's a global limit
for the dirty+writeback pages, even if in the future there will be
some per-queue (or other) soft limit.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/mm/page-writeback.c
===================================================================
--- linux.orig/mm/page-writeback.c	2007-02-27 14:41:07.000000000 +0100
+++ linux/mm/page-writeback.c	2007-02-27 14:41:07.000000000 +0100
@@ -201,6 +201,17 @@ static void balance_dirty_pages(struct a
 		if (!dirty_exceeded)
 			dirty_exceeded = 1;
 
+		/*
+		 * Acquit producer of dirty pages if there's little or
+		 * nothing to write back to this particular queue.
+		 *
+		 * Without this check a deadlock is possible for if
+		 * one filesystem is writing data through another.
+		 */
+		if (atomic_long_read(&bdi->nr_dirty) +
+		    atomic_long_read(&bdi->nr_writeback) < 8)
+			break;
+
 		/* Note: nr_reclaimable denotes nr_dirty + nr_unstable.
 		 * Unstable writes are a feature of certain networked
 		 * filesystems (i.e. NFS) in which data may have been
