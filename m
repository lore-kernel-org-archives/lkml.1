Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbYJWI0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbYJWI0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 04:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYJWI0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 04:26:18 -0400
Received: from smtpauth.net4india.com ([202.71.129.41]:48886 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbYJWI0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 04:26:16 -0400
From: David John <davidjon@xenontk.org>
To: mingo@elte.hu
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, a.zummo@towertech.it,
       rtc-linux@googlegroups.com
Subject: [PATCH RESEND] RTC: Remove the BKL.
Date: Thu, 23 Oct 2008 13:55:56 +0530
Message-Id: <1224750356-2626-1-git-send-email-davidjon@xenontk.org>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove calls to the BKL since concurrent access is protected
by the spin lock rtc_lock.

Signed-off-by: David John <davidjon@xenontk.org>
---
 drivers/char/rtc.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index f53d4d0..05b9d3c 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -48,9 +48,10 @@
  *		CONFIG_HPET_EMULATE_RTC
  *	1.12a	Maciej W. Rozycki: Handle memory-mapped chips properly.
  *	1.12ac	Alan Cox: Allow read access to the day of week register
+ *	1.12b	David John: Remove calls to the BKL.
  */
 
-#define RTC_VERSION		"1.12ac"
+#define RTC_VERSION		"1.12b"
 
 /*
  *	Note that *all* calls to CMOS_READ and CMOS_WRITE are done with
@@ -73,7 +74,6 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/sysctl.h>
 #include <linux/wait.h>
 #include <linux/bcd.h>
@@ -182,8 +182,8 @@ static int rtc_proc_open(struct inode *inode, struct file *file);
 
 /*
  * rtc_status is never changed by rtc_interrupt, and ioctl/open/close is
- * protected by the big kernel lock. However, ioctl can still disable the timer
- * in rtc_status and then with del_timer after the interrupt has read
+ * protected by the spin lock rtc_lock. However, ioctl can still disable the
+ * timer in rtc_status and then with del_timer after the interrupt has read
  * rtc_status but before mod_timer is called, which would then reenable the
  * timer (but you would need to have an awful timing before you'd trip on it)
  */
@@ -720,9 +720,7 @@ static int rtc_do_ioctl(unsigned int cmd, unsigned long arg, int kernel)
 static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
-	lock_kernel();
 	ret = rtc_do_ioctl(cmd, arg, 0);
-	unlock_kernel();
 	return ret;
 }
 
@@ -731,12 +729,8 @@ static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
  *	Also clear the previous interrupt data on an open, and clean
  *	up things on a close.
  */
-
-/* We use rtc_lock to protect against concurrent opens. So the BKL is not
- * needed here. Or anywhere else in this driver. */
 static int rtc_open(struct inode *inode, struct file *file)
 {
-	lock_kernel();
 	spin_lock_irq(&rtc_lock);
 
 	if (rtc_status & RTC_IS_OPEN)
@@ -746,12 +740,10 @@ static int rtc_open(struct inode *inode, struct file *file)
 
 	rtc_irq_data = 0;
 	spin_unlock_irq(&rtc_lock);
-	unlock_kernel();
 	return 0;
 
 out_busy:
 	spin_unlock_irq(&rtc_lock);
-	unlock_kernel();
 	return -EBUSY;
 }
 
@@ -802,7 +794,6 @@ no_irq:
 }
 
 #ifdef RTC_IRQ
-/* Called without the kernel lock - fine */
 static unsigned int rtc_poll(struct file *file, poll_table *wait)
 {
 	unsigned long l;
