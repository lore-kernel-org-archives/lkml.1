Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528Ab0ADQlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab0ADQlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 11:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397Ab0ADQln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 11:41:43 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57999 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753333Ab0ADQln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 11:41:43 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] i2o: propogate the BKL down into the ioctl method
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 04 Jan 2010 16:18:27 +0000
Message-ID: <20100104161801.16711.65931.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody seems to want to own I2O patches so sending this one directly.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/message/i2o/i2o_config.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)


diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index efba702..3d5f40c 100644
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
@@ -984,11 +983,11 @@ out:
 /*
  * IOCTL Handler
  */
-static int i2o_cfg_ioctl(struct inode *inode, struct file *fp, unsigned int cmd,
-			 unsigned long arg)
+static long i2o_cfg_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 {
 	int ret;
 
+	lock_kernel();
 	switch (cmd) {
 	case I2OGETIOPS:
 		ret = i2o_cfg_getiops(arg);
@@ -1044,7 +1043,7 @@ static int i2o_cfg_ioctl(struct inode *inode, struct file *fp, unsigned int cmd,
 		osm_debug("unknown ioctl called!\n");
 		ret = -EINVAL;
 	}
-
+	unlock_kernel();
 	return ret;
 }
 
@@ -1118,7 +1117,7 @@ static int cfg_release(struct inode *inode, struct file *file)
 static const struct file_operations config_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
-	.ioctl = i2o_cfg_ioctl,
+	.unlocked_ioctl = i2o_cfg_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = i2o_cfg_compat_ioctl,
 #endif

