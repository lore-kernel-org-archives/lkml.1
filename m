Return-Path: <linux-kernel-owner+w=401wt.eu-S933101AbXCAI1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101AbXCAI1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 03:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933097AbXCAI1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 03:27:11 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34025 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933014AbXCAI1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 03:27:09 -0500
Date: Thu, 1 Mar 2007 00:27:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 03/22] fix deadlock in balance_dirty_pages
Message-Id: <20070301002704.8fbbcda2.akpm@linux-foundation.org>
In-Reply-To: <E1HMfp2-0001fc-00@dorka.pomaz.szeredi.hu>
References: <20070227223809.684624012@szeredi.hu>
	<20070227223911.472192712@szeredi.hu>
	<20070228225853.8df5bdd0.akpm@linux-foundation.org>
	<E1HMfp2-0001fc-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Mar 2007 08:35:28 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:

> > > This deadlock happens, when dirty pages from one filesystem are
> > > written back through another filesystem.  It easiest to demonstrate
> > > with fuse although it could affect looback mounts as well (see
> > > following patches).
> > > 
> > > Let's call the filesystems A(bove) and B(elow).  Process Pr_a is
> > > writing to A, and process Pr_b is writing to B.
> > > 
> > > Pr_a is bash-shared-mapping.  Pr_b is the fuse filesystem daemon
> > > (fusexmp_fh), for simplicity let's assume that Pr_b is single
> > > threaded.
> > > 
> > > These are the simplified stack traces of these processes after the
> > > deadlock:
> > > 
> > > Pr_a (bash-shared-mapping):
> > > 
> > >   (block on queue)
> > >   fuse_writepage
> > >   generic_writepages
> > >   writeback_inodes
> > >   balance_dirty_pages
> > >   balance_dirty_pages_ratelimited_nr
> > >   set_page_dirty_mapping_balance
> > >   do_no_page
> > > 
> > > 
> > > Pr_b (fusexmp_fh):
> > > 
> > >   io_schedule_timeout
> > >   congestion_wait
> > >   balance_dirty_pages
> > >   balance_dirty_pages_ratelimited_nr
> > >   generic_file_buffered_write
> > >   generic_file_aio_write
> > >   ext3_file_write
> > >   do_sync_write
> > >   vfs_write
> > >   sys_pwrite64
> > > 
> > > 
> > > Thanks to the aggressive nature of Pr_a, it can happen, that
> > > 
> > >   nr_file_dirty > dirty_thresh + margin
> > > 
> > > This is due to both nr_dirty growing and dirty_thresh shrinking, which
> > > in turn is due to nr_file_mapped rapidly growing.  The exact size of
> > > the margin at which the deadlock happens is not known, but it's around
> > > 100 pages.
> > > 
> > > At this point Pr_a enters balance_dirty_pages and starts to write back
> > > some if it's dirty pages.  After submitting some requests, it blocks
> > > on the request queue.
> > > 
> > > The first write request will trigger Pr_b to perform a write()
> > > syscall.  This will submit a write request to the block device and
> > > then may enter balance_dirty_pages().
> > > 
> > > The condition for exiting balance_dirty_pages() is
> > > 
> > >  - either that write_chunk pages have been written
> > > 
> > >  - or nr_file_dirty + nr_writeback < dirty_thresh
> > > 
> > > It is entirely possible that less than write_chunk pages were written,
> > > in which case balance_dirty_pages() will not exit even after all the
> > > submitted requests have been succesfully completed.
> > > 
> > > Which means that the write() syscall does not return.
> > 
> > But the balance_dirty_pages() loop does more than just wait for those two
> > conditions.  It will also submit _more_ dirty pages for writeout.  ie: it
> > should be feeding more of file A's pages into writepage.
> > 
> > Why isn't that happening?
> 
> All of A's data is actually written by B.  So just submitting more
> pages to some queue doesn't help, it will just make the queue longer.
> 
> If the queue length were not limited, and B would have limitless
> threads, and the write() wouldn't exclude other writes to the same
> file (i_mutex), then there would be no deadlock.
> 
> But for fuse the first and the last condition isn't met.
> 
> For the loop device the second condition isn't met, loop is single
> threaded.

Sigh.  What's this about i_mutex?  That appears to be some critical
information which _still_ isn't being communicated.

