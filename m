Return-Path: <linux-kernel-owner+w=401wt.eu-S932722AbXCAG66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722AbXCAG66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 01:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932719AbXCAG65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 01:58:57 -0500
Received: from smtp.osdl.org ([65.172.181.24]:58105 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932706AbXCAG64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 01:58:56 -0500
Date: Wed, 28 Feb 2007 22:58:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 03/22] fix deadlock in balance_dirty_pages
Message-Id: <20070228225853.8df5bdd0.akpm@linux-foundation.org>
In-Reply-To: <20070227223911.472192712@szeredi.hu>
References: <20070227223809.684624012@szeredi.hu>
	<20070227223911.472192712@szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Feb 2007 23:38:12 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> This deadlock happens, when dirty pages from one filesystem are
> written back through another filesystem.  It easiest to demonstrate
> with fuse although it could affect looback mounts as well (see
> following patches).
> 
> Let's call the filesystems A(bove) and B(elow).  Process Pr_a is
> writing to A, and process Pr_b is writing to B.
> 
> Pr_a is bash-shared-mapping.  Pr_b is the fuse filesystem daemon
> (fusexmp_fh), for simplicity let's assume that Pr_b is single
> threaded.
> 
> These are the simplified stack traces of these processes after the
> deadlock:
> 
> Pr_a (bash-shared-mapping):
> 
>   (block on queue)
>   fuse_writepage
>   generic_writepages
>   writeback_inodes
>   balance_dirty_pages
>   balance_dirty_pages_ratelimited_nr
>   set_page_dirty_mapping_balance
>   do_no_page
> 
> 
> Pr_b (fusexmp_fh):
> 
>   io_schedule_timeout
>   congestion_wait
>   balance_dirty_pages
>   balance_dirty_pages_ratelimited_nr
>   generic_file_buffered_write
>   generic_file_aio_write
>   ext3_file_write
>   do_sync_write
>   vfs_write
>   sys_pwrite64
> 
> 
> Thanks to the aggressive nature of Pr_a, it can happen, that
> 
>   nr_file_dirty > dirty_thresh + margin
> 
> This is due to both nr_dirty growing and dirty_thresh shrinking, which
> in turn is due to nr_file_mapped rapidly growing.  The exact size of
> the margin at which the deadlock happens is not known, but it's around
> 100 pages.
> 
> At this point Pr_a enters balance_dirty_pages and starts to write back
> some if it's dirty pages.  After submitting some requests, it blocks
> on the request queue.
> 
> The first write request will trigger Pr_b to perform a write()
> syscall.  This will submit a write request to the block device and
> then may enter balance_dirty_pages().
> 
> The condition for exiting balance_dirty_pages() is
> 
>  - either that write_chunk pages have been written
> 
>  - or nr_file_dirty + nr_writeback < dirty_thresh
> 
> It is entirely possible that less than write_chunk pages were written,
> in which case balance_dirty_pages() will not exit even after all the
> submitted requests have been succesfully completed.
> 
> Which means that the write() syscall does not return.

But the balance_dirty_pages() loop does more than just wait for those two
conditions.  It will also submit _more_ dirty pages for writeout.  ie: it
should be feeding more of file A's pages into writepage.

Why isn't that happening?

> Which means, that no more dirty pages from A will be written back, and
> neither nr_writeback nor nr_file_dirty will decrease.
> 
> Which means, that balance_dirty_pages() will loop forever.
> 
> Q.E.D.
> 
> The solution is to exit balance_dirty_pages() on the condition, that
> there are only a few dirty + writeback pages for this backing dev.  This
> makes sure, that there is always some progress with this setup.
> 
> The number of outstanding dirty + written pages is limited to 8, which
> means that when over the threshold (dirty_exceeded == 1), each
> filesystem may only effectively pin a maximum of 16 (+8 because of
> ratelimiting) extra pages.
> 
> Note: a similar safety vent is always needed if there's a global limit
> for the dirty+writeback pages, even if in the future there will be
> some per-queue (or other) soft limit.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
> 
> Index: linux/mm/page-writeback.c
> ===================================================================
> --- linux.orig/mm/page-writeback.c	2007-02-27 14:41:07.000000000 +0100
> +++ linux/mm/page-writeback.c	2007-02-27 14:41:07.000000000 +0100
> @@ -201,6 +201,17 @@ static void balance_dirty_pages(struct a
>  		if (!dirty_exceeded)
>  			dirty_exceeded = 1;
>  
> +		/*
> +		 * Acquit producer of dirty pages if there's little or
> +		 * nothing to write back to this particular queue.
> +		 *
> +		 * Without this check a deadlock is possible for if
> +		 * one filesystem is writing data through another.
> +		 */
> +		if (atomic_long_read(&bdi->nr_dirty) +
> +		    atomic_long_read(&bdi->nr_writeback) < 8)
> +			break;
> +
>  		/* Note: nr_reclaimable denotes nr_dirty + nr_unstable.
>  		 * Unstable writes are a feature of certain networked
>  		 * filesystems (i.e. NFS) in which data may have been
> 
> --
