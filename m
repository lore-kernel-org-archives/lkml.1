Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544Ab0AQT6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab0AQT6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 14:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244Ab0AQT6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 14:58:19 -0500
Received: from mail.df.lth.se ([194.47.250.12]:46453 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750743Ab0AQT6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 14:58:19 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH] MFD Fix debugfs code in AB3100 OTP driver
Date: Sun, 17 Jan 2010 20:57:43 +0100
Message-Id: <1263758263-21924-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the aged and unreachable debugfs code in the AB3100
OTP driver so that it's (A) reachable and (B) works. Bug detected
in parallell by Christoph Egger using VAMOS and Robert P. J. Day
by his kernel scanning script.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Cc: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Cc: Robert P. J. Day <rpjday@crashcourse.ca>
---
 drivers/mfd/ab3100-otp.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/ab3100-otp.c b/drivers/mfd/ab3100-otp.c
index 0499b20..b603469 100644
--- a/drivers/mfd/ab3100-otp.c
+++ b/drivers/mfd/ab3100-otp.c
@@ -13,6 +13,7 @@
 #include <linux/platform_device.h>
 #include <linux/mfd/ab3100.h>
 #include <linux/debugfs.h>
+#include <linux/seq_file.h>
 
 /* The OTP registers */
 #define AB3100_OTP0		0xb0
@@ -95,11 +96,10 @@ static int __init ab3100_otp_read(struct ab3100_otp *otp)
  * This is a simple debugfs human-readable file that dumps out
  * the contents of the OTP.
  */
-#ifdef CONFIG_DEBUGFS
-static int show_otp(struct seq_file *s, void *v)
+#ifdef CONFIG_DEBUG_FS
+static int ab3100_show_otp(struct seq_file *s, void *v)
 {
 	struct ab3100_otp *otp = s->private;
-	int err;
 
 	seq_printf(s, "OTP is %s\n", otp->locked ? "LOCKED" : "UNLOCKED");
 	seq_printf(s, "OTP clock switch startup is %uHz\n", otp->freq);
@@ -113,7 +113,7 @@ static int show_otp(struct seq_file *s, void *v)
 
 static int ab3100_otp_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, ab3100_otp_show, inode->i_private);
+	return single_open(file, ab3100_show_otp, inode->i_private);
 }
 
 static const struct file_operations ab3100_otp_operations = {
@@ -131,13 +131,14 @@ static int __init ab3100_otp_init_debugfs(struct device *dev,
 					   &ab3100_otp_operations);
 	if (!otp->debugfs) {
 		dev_err(dev, "AB3100 debugfs OTP file registration failed!\n");
-		return err;
+		return -ENOENT;
 	}
+	return 0;
 }
 
 static void __exit ab3100_otp_exit_debugfs(struct ab3100_otp *otp)
 {
-	debugfs_remove_file(otp->debugfs);
+	debugfs_remove(otp->debugfs);
 }
 #else
 /* Compile this out if debugfs not selected */
-- 
1.6.3.3

