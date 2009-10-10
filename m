Return-Path: <linux-kernel-owner+w=401wt.eu-S934071AbZJJPjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934071AbZJJPjQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762024AbZJJPjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:39:12 -0400
Received: from www.tglx.de ([62.245.132.106]:55620 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762005AbZJJPi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:38:58 -0400
Message-Id: <20091010153350.046644063@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:37:22 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>
Subject: [patch 24/28] rtc: Remove BKL from efirtc
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline; filename=efi-rtc-remove-bkl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL locking came to efirtc via the big BKL push down, but the access
to the efi functions is protected by efi_rtc_lock already.

Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
drivers/char/efirtc.c | 12 +----------- 1 file changed, 1 insertion(+), 11 deletions(-)

---
 drivers/char/efirtc.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

Index: linux-2.6-tip/drivers/char/efirtc.c
===================================================================
--- linux-2.6-tip.orig/drivers/char/efirtc.c
+++ linux-2.6-tip/drivers/char/efirtc.c
@@ -27,8 +27,6 @@
  * 	- Add module support
  */
 
-
-#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
@@ -174,13 +172,12 @@ static long efi_rtc_ioctl(struct file *f
 			return -EINVAL;
 
 		case RTC_RD_TIME:
-			lock_kernel();
 			spin_lock_irqsave(&efi_rtc_lock, flags);
 
 			status = efi.get_time(&eft, &cap);
 
 			spin_unlock_irqrestore(&efi_rtc_lock,flags);
-			unlock_kernel();
+
 			if (status != EFI_SUCCESS) {
 				/* should never happen */
 				printk(KERN_ERR "efitime: can't read time\n");
@@ -202,13 +199,11 @@ static long efi_rtc_ioctl(struct file *f
 
 			convert_to_efi_time(&wtime, &eft);
 
-			lock_kernel();
 			spin_lock_irqsave(&efi_rtc_lock, flags);
 
 			status = efi.set_time(&eft);
 
 			spin_unlock_irqrestore(&efi_rtc_lock,flags);
-			unlock_kernel();
 
 			return status == EFI_SUCCESS ? 0 : -EINVAL;
 
@@ -224,7 +219,6 @@ static long efi_rtc_ioctl(struct file *f
 
 			convert_to_efi_time(&wtime, &eft);
 
-			lock_kernel();
 			spin_lock_irqsave(&efi_rtc_lock, flags);
 			/*
 			 * XXX Fixme:
@@ -235,19 +229,16 @@ static long efi_rtc_ioctl(struct file *f
 			status = efi.set_wakeup_time((efi_bool_t)enabled, &eft);
 
 			spin_unlock_irqrestore(&efi_rtc_lock,flags);
-			unlock_kernel();
 
 			return status == EFI_SUCCESS ? 0 : -EINVAL;
 
 		case RTC_WKALM_RD:
 
-			lock_kernel();
 			spin_lock_irqsave(&efi_rtc_lock, flags);
 
 			status = efi.get_wakeup_time((efi_bool_t *)&enabled, (efi_bool_t *)&pending, &eft);
 
 			spin_unlock_irqrestore(&efi_rtc_lock,flags);
-			unlock_kernel();
 
 			if (status != EFI_SUCCESS) return -EINVAL;
 
@@ -277,7 +268,6 @@ static int efi_rtc_open(struct inode *in
 	 * We do accept multiple open files at the same time as we
 	 * synchronize on the per call operation.
 	 */
-	cycle_kernel_lock();
 	return 0;
 }
 


