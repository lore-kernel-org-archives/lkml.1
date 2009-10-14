Return-Path: <linux-kernel-owner+w=401wt.eu-S934742AbZJNPvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934742AbZJNPvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934602AbZJNPvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:51:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:34626 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934681AbZJNPvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:51:12 -0400
Date: Wed, 14 Oct 2009 15:50:12 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <20091010153350.046644063@linutronix.de>
References: <20091010153350.046644063@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/drivers] rtc: Remove BKL from efirtc
Message-ID: <tip-a5ee6dc9ebe8fc2640ee3fbf2c340bd853e2fd36@git.kernel.org>
Git-Commit-ID: a5ee6dc9ebe8fc2640ee3fbf2c340bd853e2fd36
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:50:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5ee6dc9ebe8fc2640ee3fbf2c340bd853e2fd36
Gitweb:     http://git.kernel.org/tip/a5ee6dc9ebe8fc2640ee3fbf2c340bd853e2fd36
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 10 Oct 2009 15:14:03 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:36:51 +0200

rtc: Remove BKL from efirtc

BKL locking came to efirtc via the big BKL push down, but the access
to the efi functions is protected by efi_rtc_lock already.

Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20091010153350.046644063@linutronix.de>
---
 drivers/char/efirtc.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/char/efirtc.c b/drivers/char/efirtc.c
index 34d15d5..26a47dc 100644
--- a/drivers/char/efirtc.c
+++ b/drivers/char/efirtc.c
@@ -27,8 +27,6 @@
  * 	- Add module support
  */
 
-
-#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
@@ -174,13 +172,12 @@ static long efi_rtc_ioctl(struct file *file, unsigned int cmd,
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
@@ -202,13 +199,11 @@ static long efi_rtc_ioctl(struct file *file, unsigned int cmd,
 
 			convert_to_efi_time(&wtime, &eft);
 
-			lock_kernel();
 			spin_lock_irqsave(&efi_rtc_lock, flags);
 
 			status = efi.set_time(&eft);
 
 			spin_unlock_irqrestore(&efi_rtc_lock,flags);
-			unlock_kernel();
 
 			return status == EFI_SUCCESS ? 0 : -EINVAL;
 
@@ -224,7 +219,6 @@ static long efi_rtc_ioctl(struct file *file, unsigned int cmd,
 
 			convert_to_efi_time(&wtime, &eft);
 
-			lock_kernel();
 			spin_lock_irqsave(&efi_rtc_lock, flags);
 			/*
 			 * XXX Fixme:
@@ -235,19 +229,16 @@ static long efi_rtc_ioctl(struct file *file, unsigned int cmd,
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
 
@@ -277,7 +268,6 @@ static int efi_rtc_open(struct inode *inode, struct file *file)
 	 * We do accept multiple open files at the same time as we
 	 * synchronize on the per call operation.
 	 */
-	cycle_kernel_lock();
 	return 0;
 }
 
