Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZCXVR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZCXVR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZCXVNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:13:31 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:10497 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbZCXVN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:13:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dUH9ajyiuVJzcFPpo7b91UA0/9Ky4CUeSeImw4CKaeQD591N6RCvr6CPJf5Udh5lAd
         EEFm/PeLGAIxOcFusX6Aj5tN40Yxh4c6rnUCIjZCMGJgXUsi6jMr1J8oa+9VjMLadKkb
         +vP8f6g2zUJdNKXCsrMV1WhO0KwZLDamlX0FI=
From: stoyboyker@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>
Subject: [PATCH 13/13] [drivers] changed ioctls to unlocked
Date: Tue, 24 Mar 2009 16:12:48 -0500
Message-Id: <1237929168-15341-14-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stoyan Gaydarov <stoyboyker@gmail.com>

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 drivers/message/i2o/i2o_config.c |   13 +++++++------
 drivers/parisc/eisa_eeprom.c     |    5 ++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index efba702..dc8548f 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -40,8 +40,7 @@
 
 #define SG_TABLESIZE		30
 
-static int i2o_cfg_ioctl(struct inode *, struct file *, unsigned int,
-			 unsigned long);
+static long i2o_cfg_ioctl(struct file *, unsigned int, unsigned long);
 
 static spinlock_t i2o_config_lock;
 
@@ -751,7 +750,7 @@ static long i2o_cfg_compat_ioctl(struct file *file, unsigned cmd,
 	lock_kernel();
 	switch (cmd) {
 	case I2OGETIOPS:
-		ret = i2o_cfg_ioctl(NULL, file, cmd, arg);
+		ret = i2o_cfg_ioctl(file, cmd, arg);
 		break;
 	case I2OPASSTHRU32:
 		ret = i2o_cfg_passthru32(file, cmd, arg);
@@ -984,10 +983,11 @@ out:
 /*
  * IOCTL Handler
  */
-static int i2o_cfg_ioctl(struct inode *inode, struct file *fp, unsigned int cmd,
-			 unsigned long arg)
+static long i2o_cfg_ioctl(struct file *fp, unsigned int cmd,
+		  unsigned long arg)
 {
 	int ret;
+	lock_kernel();
 
 	switch (cmd) {
 	case I2OGETIOPS:
@@ -1045,6 +1045,7 @@ static int i2o_cfg_ioctl(struct inode *inode, struct file *fp, unsigned int cmd,
 		ret = -EINVAL;
 	}
 
+	unlock_kernel();
 	return ret;
 }
 
@@ -1118,7 +1119,7 @@ static int cfg_release(struct inode *inode, struct file *file)
 static const struct file_operations config_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
-	.ioctl = i2o_cfg_ioctl,
+	.unlocked_ioctl = i2o_cfg_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = i2o_cfg_compat_ioctl,
 #endif
diff --git a/drivers/parisc/eisa_eeprom.c b/drivers/parisc/eisa_eeprom.c
index 685d94e..5d3ddbc 100644
--- a/drivers/parisc/eisa_eeprom.c
+++ b/drivers/parisc/eisa_eeprom.c
@@ -75,8 +75,7 @@ static ssize_t eisa_eeprom_read(struct file * file,
 	return ret;
 }
 
-static int eisa_eeprom_ioctl(struct inode *inode, struct file *file, 
-			   unsigned int cmd,
+static long eisa_eeprom_ioctl(struct file *file, unsigned int cmd,
 			   unsigned long arg)
 {
 	return -ENOTTY;
@@ -104,7 +103,7 @@ static const struct file_operations eisa_eeprom_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	eisa_eeprom_llseek,
 	.read =		eisa_eeprom_read,
-	.ioctl =	eisa_eeprom_ioctl,
+	.unlocked_ioctl =	eisa_eeprom_ioctl,
 	.open =		eisa_eeprom_open,
 	.release =	eisa_eeprom_release,
 };
-- 
1.6.2

