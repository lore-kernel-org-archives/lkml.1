Return-Path: <linux-kernel-owner+w=401wt.eu-S1759481AbYAKLgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbYAKLgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 06:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbYAKLgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 06:36:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:47100 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbYAKLgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 06:36:08 -0500
Subject: [PATCH] Random number driver: make random_ioctl as an
	unlocked_ioctl function
From: Nikanth Karthikesan <knikanth@suse.de>
To: mpm@selenic.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain
Date: Fri, 11 Jan 2008 17:09:52 +0530
Message-Id: <1200051592.3844.63.camel@nikanth-laptop.blr.novell.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The random_ioctl is registered as an ioctl function but it does not
require BKL to be held when called. Changing it as an unlocked_ioctl
function.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 5fee056..2446e14 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1065,9 +1065,8 @@ random_write(struct file * file, const char __user * buffer,
 	return (ssize_t)count;
 }
 
-static int
-random_ioctl(struct inode * inode, struct file * file,
-	     unsigned int cmd, unsigned long arg)
+static long
+random_ioctl(struct file * file, unsigned int cmd, unsigned long arg)
 {
 	int size, ent_count;
 	int __user *p = (int __user *)arg;
@@ -1131,13 +1130,13 @@ const struct file_operations random_fops = {
 	.read  = random_read,
 	.write = random_write,
 	.poll  = random_poll,
-	.ioctl = random_ioctl,
+	.unlocked_ioctl = random_ioctl,
 };
 
 const struct file_operations urandom_fops = {
 	.read  = urandom_read,
 	.write = random_write,
-	.ioctl = random_ioctl,
+	.unlocked_ioctl = random_ioctl,
 };
 
 /***************************************************************


