Return-Path: <linux-kernel-owner+w=401wt.eu-S933104AbZJOInb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104AbZJOInb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762528AbZJOIna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:43:30 -0400
Received: from www.tglx.de ([62.245.132.106]:55047 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762493AbZJOIn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:43:29 -0400
Message-Id: <20091015083933.815963538@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 15 Oct 2009 08:42:21 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>,
       ALan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch 2/7] m68k: Remove BKL from rtc implementations
References: <20091015083906.716130653@linutronix.de>
Content-Disposition: inline; filename=m68k-remove-bkl-from-rtc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68k does not support SMP. The access to the rtc is already serialized
with local_irq_save/restore which is sufficient on UP.

The open() protection in arch/m68k/mvme16x/rtc.c is not pretty but
sufficient on UP and safe w/o the BKL.

open() in arch/m68k/bvme6000/rtc.c can do with the same atomic logic
as arch/m68k/mvme16x/rtc.c

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/bvme6000/rtc.c |   29 +++++++++--------------------
 arch/m68k/mvme16x/rtc.c  |   19 +++++--------------
 2 files changed, 14 insertions(+), 34 deletions(-)

Index: linux-2.6-tip/arch/m68k/bvme6000/rtc.c
===================================================================
--- linux-2.6-tip.orig/arch/m68k/bvme6000/rtc.c
+++ linux-2.6-tip/arch/m68k/bvme6000/rtc.c
@@ -10,7 +10,6 @@
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/ioport.h>
 #include <linux/capability.h>
 #include <linux/fcntl.h>
@@ -36,10 +35,9 @@
 static unsigned char days_in_mo[] =
 {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
 
-static char rtc_status;
+static atomic_t rtc_status = ATOMIC_INIT(1);
 
-static int rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		     unsigned long arg)
+static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	volatile RtcPtr_t rtc = (RtcPtr_t)BVME_RTC_BASE;
 	unsigned char msr;
@@ -133,29 +131,20 @@ static int rtc_ioctl(struct inode *inode
 }
 
 /*
- *	We enforce only one user at a time here with the open/close.
- *	Also clear the previous interrupt data on an open, and clean
- *	up things on a close.
+ * We enforce only one user at a time here with the open/close.
  */
-
 static int rtc_open(struct inode *inode, struct file *file)
 {
-	lock_kernel();
-	if(rtc_status) {
-		unlock_kernel();
+	if (!atomic_dec_and_test(&rtc_status)) {
+		atomic_inc(&rtc_status);
 		return -EBUSY;
 	}
-
-	rtc_status = 1;
-	unlock_kernel();
 	return 0;
 }
 
 static int rtc_release(struct inode *inode, struct file *file)
 {
-	lock_kernel();
-	rtc_status = 0;
-	unlock_kernel();
+	atomic_inc(&rtc_status);
 	return 0;
 }
 
@@ -164,9 +153,9 @@ static int rtc_release(struct inode *ino
  */
 
 static const struct file_operations rtc_fops = {
-	.ioctl =	rtc_ioctl,
-	.open =		rtc_open,
-	.release =	rtc_release,
+	.unlocked_ioctl	= rtc_ioctl,
+	.open		= rtc_open,
+	.release	= rtc_release,
 };
 
 static struct miscdevice rtc_dev = {
Index: linux-2.6-tip/arch/m68k/mvme16x/rtc.c
===================================================================
--- linux-2.6-tip.orig/arch/m68k/mvme16x/rtc.c
+++ linux-2.6-tip/arch/m68k/mvme16x/rtc.c
@@ -10,7 +10,6 @@
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/ioport.h>
 #include <linux/capability.h>
 #include <linux/fcntl.h>
@@ -37,8 +36,7 @@ static const unsigned char days_in_mo[] 
 
 static atomic_t rtc_ready = ATOMIC_INIT(1);
 
-static int rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		     unsigned long arg)
+static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	volatile MK48T08ptr_t rtc = (MK48T08ptr_t)MVME_RTC_BASE;
 	unsigned long flags;
@@ -121,22 +119,15 @@ static int rtc_ioctl(struct inode *inode
 }
 
 /*
- *	We enforce only one user at a time here with the open/close.
- *	Also clear the previous interrupt data on an open, and clean
- *	up things on a close.
+ * We enforce only one user at a time here with the open/close.
  */
-
 static int rtc_open(struct inode *inode, struct file *file)
 {
-	lock_kernel();
 	if( !atomic_dec_and_test(&rtc_ready) )
 	{
 		atomic_inc( &rtc_ready );
-		unlock_kernel();
 		return -EBUSY;
 	}
-	unlock_kernel();
-
 	return 0;
 }
 
@@ -151,9 +142,9 @@ static int rtc_release(struct inode *ino
  */
 
 static const struct file_operations rtc_fops = {
-	.ioctl =	rtc_ioctl,
-	.open =		rtc_open,
-	.release =	rtc_release,
+	.unlocked_ioctl	= rtc_ioctl,
+	.open		= rtc_open,
+	.release	= rtc_release,
 };
 
 static struct miscdevice rtc_dev=


