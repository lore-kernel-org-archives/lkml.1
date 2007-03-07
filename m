Return-Path: <linux-kernel-owner+w=401wt.eu-S1422925AbXCGRSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422925AbXCGRSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422919AbXCGRSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:18:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43850 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422924AbXCGRS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:18:28 -0500
Message-Id: <20070307171650.864004527@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:12:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       nickpiggin@yahoo.com.au, galak@kernel.crashing.org, zaitcev@redhat.com,
       hirofumi@mail.parknet.co.jp
Subject: [patch 095/101] throttle_vm_writeout(): dont loop on GFP_NOFS and GFP_NOIO allocations
Content-Disposition: inline; filename=throttle_vm_writeout-don-t-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andrew Morton <akpm@linux-foundation.org>

throttle_vm_writeout() is designed to wait for the dirty levels to subside. 
But if the caller holds IO or FS locks, we might be holding up that writeout.

So change it to take a single nap to give other devices a chance to clean some
memory, then return.

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/writeback.h |    2 +-
 mm/page-writeback.c       |   13 +++++++++++--
 mm/vmscan.c               |    2 +-
 3 files changed, 13 insertions(+), 4 deletions(-)

--- linux-2.6.20.1.orig/include/linux/writeback.h
+++ linux-2.6.20.1/include/linux/writeback.h
@@ -84,7 +84,7 @@ static inline void wait_on_inode(struct 
 int wakeup_pdflush(long nr_pages);
 void laptop_io_completion(void);
 void laptop_sync_completion(void);
-void throttle_vm_writeout(void);
+void throttle_vm_writeout(gfp_t gfp_mask);
 
 /* These are exported to sysctl. */
 extern int dirty_background_ratio;
--- linux-2.6.20.1.orig/mm/page-writeback.c
+++ linux-2.6.20.1/mm/page-writeback.c
@@ -296,11 +296,21 @@ void balance_dirty_pages_ratelimited_nr(
 }
 EXPORT_SYMBOL(balance_dirty_pages_ratelimited_nr);
 
-void throttle_vm_writeout(void)
+void throttle_vm_writeout(gfp_t gfp_mask)
 {
 	long background_thresh;
 	long dirty_thresh;
 
+	if ((gfp_mask & (__GFP_FS|__GFP_IO)) != (__GFP_FS|__GFP_IO)) {
+		/*
+		 * The caller might hold locks which can prevent IO completion
+		 * or progress in the filesystem.  So we cannot just sit here
+		 * waiting for IO to complete.
+		 */
+		congestion_wait(WRITE, HZ/10);
+		return;
+	}
+
         for ( ; ; ) {
 		get_dirty_limits(&background_thresh, &dirty_thresh, NULL);
 
@@ -317,7 +327,6 @@ void throttle_vm_writeout(void)
         }
 }
 
-
 /*
  * writeback at least _min_pages, and keep writing until the amount of dirty
  * memory is less than the background threshold, or until we're all clean.
--- linux-2.6.20.1.orig/mm/vmscan.c
+++ linux-2.6.20.1/mm/vmscan.c
@@ -949,7 +949,7 @@ static unsigned long shrink_zone(int pri
 		}
 	}
 
-	throttle_vm_writeout();
+	throttle_vm_writeout(sc->gfp_mask);
 
 	atomic_dec(&zone->reclaim_in_progress);
 	return nr_reclaimed;

--
