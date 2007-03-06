Return-Path: <linux-kernel-owner+w=401wt.eu-S965974AbXCFSGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965974AbXCFSGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965971AbXCFSGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:06:19 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:60851 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965447AbXCFSGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:06:13 -0500
Message-Id: <20070306180553.812182420@szeredi.hu>
References: <20070306180443.669036741@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 06 Mar 2007 19:04:48 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 5/8] fix deadlock in throttle_vm_writeout
Content-Disposition: inline; filename=throttle_vm_writeout_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

This deadlock is similar to the one in balance_dirty_pages, but
instead of waiting in balance_dirty_pages after submitting a write
request, it happens during a memory allocation for filesystem B before
submitting a write request.

It is easy to reproduce on a machine with not too much memory.
E.g. try this on 2.6.21-rc1 UML with 32MB (works on physical hw as
well):

  dd if=/dev/zero of=/tmp/tmp.img bs=1048576 count=40
  mke2fs -j -F /tmp/tmp.img
  mkdir /tmp/img
  mount -oloop /tmp/tmp.img /tmp/img
  bash-shared-mapping /tmp/img/foo 30000000

The deadlock doesn't happen immediately, sometimes only after a few
minutes.

Simplified stack trace for bash-shared-mapping after the deadlock:

  io_schedule_timeout
  congestion_wait
  balance_dirty_pages
  balance_dirty_pages_ratelimited_nr
  generic_file_buffered_write
  __generic_file_aio_write_nolock
  generic_file_aio_write
  ext3_file_write
  do_sync_write
  vfs_write
  sys_pwrite64

and for [loop0]:

  io_schedule_timeout
  congestion_wait
  throttle_vm_writeout
  shrink_zone
  shrink_zones
  try_to_free_pages
  __alloc_pages
  find_or_create_page
  do_lo_send_aops
  lo_send
  do_bio_filebacked
  loop_thread

The requirement for the deadlock is that

  nr_writeback > dirty_thresh * 1.1 + margin

Again margin seems to be in the 100 page range.

The task of throttle_vm_writeout is to limit the rate at which
under-writeback pages are created due to swapping.  There's no other
way direct reclaim can increase the nr_writeback + nr_file_dirty.

So when there are few or no under-swap pages, it is safe for this
function to return.  This ensures, that there's progress with writing
back dirty pages.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/include/linux/swap.h
===================================================================
--- linux.orig/include/linux/swap.h	2007-02-27 14:40:55.000000000 +0100
+++ linux/include/linux/swap.h	2007-02-27 14:41:08.000000000 +0100
@@ -279,10 +279,14 @@ static inline void disable_swap_token(vo
 	put_swap_token(swap_token_mm);
 }
 
+#define nr_swap_writeback \
+	atomic_long_read(&swapper_space.backing_dev_info->nr_writeback)
+
 #else /* CONFIG_SWAP */
 
 #define total_swap_pages			0
 #define total_swapcache_pages			0UL
+#define nr_swap_writeback			0UL
 
 #define si_swapinfo(val) \
 	do { (val)->freeswap = (val)->totalswap = 0; } while (0)
Index: linux/mm/page-writeback.c
===================================================================
--- linux.orig/mm/page-writeback.c	2007-02-27 14:41:07.000000000 +0100
+++ linux/mm/page-writeback.c	2007-02-27 14:41:08.000000000 +0100
@@ -33,6 +33,7 @@
 #include <linux/syscalls.h>
 #include <linux/buffer_head.h>
 #include <linux/pagevec.h>
+#include <linux/swap.h>
 
 /*
  * The maximum number of pages to writeout in a single bdflush/kupdate
@@ -303,6 +304,21 @@ void throttle_vm_writeout(void)
 	long dirty_thresh;
 
         for ( ; ; ) {
+		/*
+		 * If there's no swapping going on, don't throttle.
+		 *
+		 * Starting writeback against mapped pages shouldn't
+		 * be a problem, as that doesn't increase the
+		 * sum of dirty + writeback.
+		 *
+		 * Without this, a deadlock is possible (also see
+		 * comment in balance_dirty_pages).  This has been
+		 * observed with running bash-shared-mapping on a
+		 * loopback mount.
+		 */
+		if (nr_swap_writeback < 16)
+			break;
+
 		get_dirty_limits(&background_thresh, &dirty_thresh, NULL);
 
                 /*
@@ -314,6 +330,7 @@ void throttle_vm_writeout(void)
                 if (global_page_state(NR_UNSTABLE_NFS) +
 			global_page_state(NR_WRITEBACK) <= dirty_thresh)
                         	break;
+
                 congestion_wait(WRITE, HZ/10);
         }
 }
Index: linux/mm/page_io.c
===================================================================
--- linux.orig/mm/page_io.c	2007-02-27 14:40:55.000000000 +0100
+++ linux/mm/page_io.c	2007-02-27 14:41:08.000000000 +0100
@@ -70,6 +70,7 @@ static int end_swap_bio_write(struct bio
 		ClearPageReclaim(page);
 	}
 	end_page_writeback(page);
+	atomic_long_dec(&swapper_space.backing_dev_info->nr_writeback);
 	bio_put(bio);
 	return 0;
 }
@@ -121,6 +122,7 @@ int swap_writepage(struct page *page, st
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		rw |= (1 << BIO_RW_SYNC);
 	count_vm_event(PSWPOUT);
+	atomic_long_inc(&swapper_space.backing_dev_info->nr_writeback);
 	set_page_writeback(page);
 	unlock_page(page);
 	submit_bio(rw, bio);

--
