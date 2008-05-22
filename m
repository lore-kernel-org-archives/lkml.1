Return-Path: <linux-kernel-owner+w=401wt.eu-S1759543AbYEVUe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbYEVUe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754393AbYEVUeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:34:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54640 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754245AbYEVUet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:34:49 -0400
Date: Thu, 22 May 2008 21:22:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Switch apm to unlocked_kernel
Message-ID: <20080522212204.177410b8@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pushes the lock a fair way down and the final kill looks like it
should be an easy project for someone who wants to have a shot at it.

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index bf9290e..00e6d13 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -228,6 +228,7 @@
 #include <linux/suspend.h>
 #include <linux/kthread.h>
 #include <linux/jiffies.h>
+#include <linux/smp_lock.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -1149,7 +1150,7 @@ static void queue_event(apm_event_t event, struct apm_user *sender)
 				as->event_tail = 0;
 		}
 		as->events[as->event_head] = event;
-		if ((!as->suser) || (!as->writer))
+		if (!as->suser || !as->writer)
 			continue;
 		switch (event) {
 		case APM_SYS_SUSPEND:
@@ -1396,7 +1397,7 @@ static void apm_mainloop(void)
 
 static int check_apm_user(struct apm_user *as, const char *func)
 {
-	if ((as == NULL) || (as->magic != APM_BIOS_MAGIC)) {
+	if (as == NULL || as->magic != APM_BIOS_MAGIC) {
 		printk(KERN_ERR "apm: %s passed bad filp\n", func);
 		return 1;
 	}
@@ -1459,18 +1460,19 @@ static unsigned int do_poll(struct file *fp, poll_table *wait)
 	return 0;
 }
 
-static int do_ioctl(struct inode *inode, struct file *filp,
-		    u_int cmd, u_long arg)
+static long do_ioctl(struct file *filp, u_int cmd, u_long arg)
 {
 	struct apm_user *as;
+	int ret;
 
 	as = filp->private_data;
 	if (check_apm_user(as, "ioctl"))
 		return -EIO;
-	if ((!as->suser) || (!as->writer))
+	if (!as->suser || !as->writer)
 		return -EPERM;
 	switch (cmd) {
 	case APM_IOC_STANDBY:
+		lock_kernel();
 		if (as->standbys_read > 0) {
 			as->standbys_read--;
 			as->standbys_pending--;
@@ -1479,8 +1481,10 @@ static int do_ioctl(struct inode *inode, struct file *filp,
 			queue_event(APM_USER_STANDBY, as);
 		if (standbys_pending <= 0)
 			standby();
+		unlock_kernel();
 		break;
 	case APM_IOC_SUSPEND:
+		lock_kernel();
 		if (as->suspends_read > 0) {
 			as->suspends_read--;
 			as->suspends_pending--;
@@ -1488,16 +1492,17 @@ static int do_ioctl(struct inode *inode, struct file *filp,
 		} else
 			queue_event(APM_USER_SUSPEND, as);
 		if (suspends_pending <= 0) {
-			return suspend(1);
+			ret = suspend(1);
 		} else {
 			as->suspend_wait = 1;
 			wait_event_interruptible(apm_suspend_waitqueue,
 					as->suspend_wait == 0);
-			return as->suspend_result;
+			ret = as->suspend_result;
 		}
-		break;
+		unlock_kernel();
+		return ret;
 	default:
-		return -EINVAL;
+		return -ENOTTY;
 	}
 	return 0;
 }
@@ -1860,7 +1865,7 @@ static const struct file_operations apm_bios_fops = {
 	.owner		= THIS_MODULE,
 	.read		= do_read,
 	.poll		= do_poll,
-	.ioctl		= do_ioctl,
+	.unlocked_ioctl	= do_ioctl,
 	.open		= do_open,
 	.release	= do_release,
 };
