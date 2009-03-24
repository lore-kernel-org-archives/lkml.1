Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbZCXVPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbZCXVPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbZCXVN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:13:26 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:5172 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZCXVNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:13:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=a90z5AeaLFZow1pkWiBQ726bX/dSpxSCHI6kctAKJYsC4/Lw2NOtbnFBpoQhntTHoH
         L3XVeLFj183iTDyJIjEAKDNX0eNbEW5ZlSH5Aq3GnoOuLciUMOFDcqL7iqiyiEhiJxQY
         Bwna95MC3iE4TWrUKPxJPSwG9lSt19VANT/8o=
From: stoyboyker@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>
Subject: [PATCH 09/13] [sbus] changed ioctls to unlocked
Date: Tue, 24 Mar 2009 16:12:44 -0500
Message-Id: <1237929168-15341-10-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stoyan Gaydarov <stoyboyker@gmail.com>

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 drivers/sbus/char/jsflash.c |   15 ++++++++++-----
 drivers/sbus/char/uctrl.c   |    7 +++----
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/sbus/char/jsflash.c b/drivers/sbus/char/jsflash.c
index e6d1fc8..a85ad05 100644
--- a/drivers/sbus/char/jsflash.c
+++ b/drivers/sbus/char/jsflash.c
@@ -383,18 +383,22 @@ static int jsf_ioctl_program(void __user *arg)
 	return 0;
 }
 
-static int jsf_ioctl(struct inode *inode, struct file *f, unsigned int cmd,
-    unsigned long arg)
+static long jsf_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 {
+	lock_kernel();
 	int error = -ENOTTY;
 	void __user *argp = (void __user *)arg;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_ADMIN)) {
+		unlock_kernel();
 		return -EPERM;
+	}
 	switch (cmd) {
 	case JSFLASH_IDENT:
-		if (copy_to_user(argp, &jsf0.id, JSFIDSZ))
+		if (copy_to_user(argp, &jsf0.id, JSFIDSZ)) {
+			unlock_kernel();
 			return -EFAULT;
+		}
 		break;
 	case JSFLASH_ERASE:
 		error = jsf_ioctl_erase(arg);
@@ -404,6 +408,7 @@ static int jsf_ioctl(struct inode *inode, struct file *f, unsigned int cmd,
 		break;
 	}
 
+	unlock_kernel();
 	return error;
 }
 
@@ -439,7 +444,7 @@ static const struct file_operations jsf_fops = {
 	.llseek =	jsf_lseek,
 	.read =		jsf_read,
 	.write =	jsf_write,
-	.ioctl =	jsf_ioctl,
+	.unlocked_ioctl =	jsf_ioctl,
 	.mmap =		jsf_mmap,
 	.open =		jsf_open,
 	.release =	jsf_release,
diff --git a/drivers/sbus/char/uctrl.c b/drivers/sbus/char/uctrl.c
index 27993c3..2c56fd5 100644
--- a/drivers/sbus/char/uctrl.c
+++ b/drivers/sbus/char/uctrl.c
@@ -197,9 +197,8 @@ static struct uctrl_driver {
 static void uctrl_get_event_status(struct uctrl_driver *);
 static void uctrl_get_external_status(struct uctrl_driver *);
 
-static int
-uctrl_ioctl(struct inode *inode, struct file *file,
-	      unsigned int cmd, unsigned long arg)
+static long
+uctrl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
 		default:
@@ -226,7 +225,7 @@ static irqreturn_t uctrl_interrupt(int irq, void *dev_id)
 static const struct file_operations uctrl_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
-	.ioctl =	uctrl_ioctl,
+	.unlocked_ioctl =	uctrl_ioctl,
 	.open =		uctrl_open,
 };
 
-- 
1.6.2

