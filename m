Return-Path: <linux-kernel-owner+w=401wt.eu-S1423142AbXBUVbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423142AbXBUVbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423141AbXBUVbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:31:37 -0500
Received: from smtp.osdl.org ([65.172.181.24]:49679 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423142AbXBUVbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:31:36 -0500
Date: Wed, 21 Feb 2007 13:31:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       <linux-usb-devel@lists.sourceforge.net>,
       Pete Zaitcev <zaitcev@redhat.com>, Greg KH <gregkh@suse.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] 2.6.20 kernel hang with USB drive and vfat
 doing ftruncate
Message-Id: <20070221133112.aec2bdac.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.0702211621310.3435-100000@iolanthe.rowland.org>
References: <20070221125736.e5ff4206.akpm@linux-foundation.org>
	<Pine.LNX.4.44L0.0702211621310.3435-100000@iolanthe.rowland.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007 16:22:17 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Wed, 21 Feb 2007, Andrew Morton wrote:
> 
> > > > It seems like usb-storage and aio are completely off in the weeds.   
> > > > Ideas?
> > > 
> > > It seems usb-storage should remove some kmalloc and use mempool() for
> > > urb...  Is someone working on this? And idea?
> > 
> > I think Pete said that we're supposed to be using GFP_NOIO in there.
> 
> We _are_ using it.

How admirably prompt.

> > Not that it'll help much: the VM calls throttle_vm_writeout() for GFP_NOIO
> > and GFP_NOFS allocations, which is a bug.  Because if the caller holds
> > locks which prevent filesystem or IO progress, we deadlock.
> > 
> > I'll fix the VM if someone else fixes USB ;)
> 
> What else needs to be fixed?

Would be nice if someone can confirm that this fixes it:



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
---

 include/linux/writeback.h |    2 +-
 mm/page-writeback.c       |   13 +++++++++++--
 mm/vmscan.c               |    2 +-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations mm/vmscan.c
--- a/mm/vmscan.c~throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations
+++ a/mm/vmscan.c
@@ -952,7 +952,7 @@ static unsigned long shrink_zone(int pri
 		}
 	}
 
-	throttle_vm_writeout();
+	throttle_vm_writeout(sc->gfp_mask);
 
 	atomic_dec(&zone->reclaim_in_progress);
 	return nr_reclaimed;
diff -puN mm/page-writeback.c~throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations mm/page-writeback.c
--- a/mm/page-writeback.c~throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations
+++ a/mm/page-writeback.c
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
+		 * The caller might hold locks which can prevert IO completion
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
diff -puN include/linux/writeback.h~throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations include/linux/writeback.h
--- a/include/linux/writeback.h~throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations
+++ a/include/linux/writeback.h
@@ -84,7 +84,7 @@ static inline void wait_on_inode(struct 
 int wakeup_pdflush(long nr_pages);
 void laptop_io_completion(void);
 void laptop_sync_completion(void);
-void throttle_vm_writeout(void);
+void throttle_vm_writeout(gfp_t gfp_mask);
 
 /* These are exported to sysctl. */
 extern int dirty_background_ratio;
_

