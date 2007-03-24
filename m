Return-Path: <linux-kernel-owner+w=401wt.eu-S1751480AbXCXV6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbXCXV6A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 17:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbXCXV6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 17:58:00 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:32837 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbXCXV57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 17:57:59 -0400
To: akpm@linux-foundation.org
CC: dgc@sgi.com, linux-kernel@vger.kernel.org
In-reply-to: <E1HVECv-0006bU-00@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Sat, 24 Mar 2007 22:55:29 +0100)
Subject: [patch 2/3] remove throttle_vm_writeout()
References: <E1HVECv-0006bU-00@dorka.pomaz.szeredi.hu>
Message-Id: <E1HVEEw-0006cP-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 24 Mar 2007 22:57:34 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Remove this function.  It's purpose was to limit the global number of
writeback pages from submitted by direct reclaim.  But this is equally
well accomplished by limited queue lengths.  When this function was
added, the device queues had much larger default lengths (8192
requests, now it's 128), causing problems.

When writable shared mapping support is added to fuse, this function
would be able to cause a deadlock if the userspace filesystem needs to
allocate memory while writing back dirty pages.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/include/linux/writeback.h
===================================================================
--- linux.orig/include/linux/writeback.h	2007-03-24 22:07:00.000000000 +0100
+++ linux/include/linux/writeback.h	2007-03-24 22:28:52.000000000 +0100
@@ -85,7 +85,6 @@ static inline void wait_on_inode(struct 
 int wakeup_pdflush(long nr_pages);
 void laptop_io_completion(void);
 void laptop_sync_completion(void);
-void throttle_vm_writeout(gfp_t gfp_mask);
 
 /* These are exported to sysctl. */
 extern int dirty_background_ratio;
Index: linux/mm/page-writeback.c
===================================================================
--- linux.orig/mm/page-writeback.c	2007-03-24 22:07:00.000000000 +0100
+++ linux/mm/page-writeback.c	2007-03-24 22:28:52.000000000 +0100
@@ -312,37 +312,6 @@ void balance_dirty_pages_ratelimited_nr(
 }
 EXPORT_SYMBOL(balance_dirty_pages_ratelimited_nr);
 
-void throttle_vm_writeout(gfp_t gfp_mask)
-{
-	long background_thresh;
-	long dirty_thresh;
-
-	if ((gfp_mask & (__GFP_FS|__GFP_IO)) != (__GFP_FS|__GFP_IO)) {
-		/*
-		 * The caller might hold locks which can prevent IO completion
-		 * or progress in the filesystem.  So we cannot just sit here
-		 * waiting for IO to complete.
-		 */
-		congestion_wait(WRITE, HZ/10);
-		return;
-	}
-
-        for ( ; ; ) {
-		get_dirty_limits(&background_thresh, &dirty_thresh, NULL);
-
-                /*
-                 * Boost the allowable dirty threshold a bit for page
-                 * allocators so they don't get DoS'ed by heavy writers
-                 */
-                dirty_thresh += dirty_thresh / 10;      /* wheeee... */
-
-                if (global_page_state(NR_UNSTABLE_NFS) +
-			global_page_state(NR_WRITEBACK) <= dirty_thresh)
-                        	break;
-                congestion_wait(WRITE, HZ/10);
-        }
-}
-
 /*
  * writeback at least _min_pages, and keep writing until the amount of dirty
  * memory is less than the background threshold, or until we're all clean.
Index: linux/mm/vmscan.c
===================================================================
--- linux.orig/mm/vmscan.c	2007-03-24 22:06:53.000000000 +0100
+++ linux/mm/vmscan.c	2007-03-24 22:07:03.000000000 +0100
@@ -952,8 +952,6 @@ static unsigned long shrink_zone(int pri
 		}
 	}
 
-	throttle_vm_writeout(sc->gfp_mask);
-
 	atomic_dec(&zone->reclaim_in_progress);
 	return nr_reclaimed;
 }
