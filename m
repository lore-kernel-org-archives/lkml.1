Return-Path: <linux-kernel-owner+w=401wt.eu-S1761515AbYARCh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761515AbYARCh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759939AbYARCgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:36:49 -0500
Received: from waste.org ([66.93.16.53]:40557 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759097AbYARCgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:36:47 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 03 of 12] random: use unlocked_ioctl
X-Mercurial-Node: 6f8bed9c59f7d2e5aab79a146dab832b8c3e6635
Message-Id: <6f8bed9c59f7d2e5aab7.1200623625@cinder.waste.org>
In-Reply-To: <patchbomb.1200623622@cinder.waste.org>
Date: Thu, 17 Jan 2008 20:33:45 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No locking actually needed.

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r f814137b0bfc -r 6f8bed9c59f7 drivers/char/random.c
--- a/drivers/char/random.c	Thu Jan 17 20:25:23 2008 -0600
+++ b/drivers/char/random.c	Thu Jan 17 20:25:23 2008 -0600
@@ -1063,8 +1063,7 @@
 	return (ssize_t)count;
 }
 
-static int random_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 {
 	int size, ent_count;
 	int __user *p = (int __user *)arg;
@@ -1072,8 +1071,8 @@
 
 	switch (cmd) {
 	case RNDGETENTCNT:
-		ent_count = input_pool.entropy_count;
-		if (put_user(ent_count, p))
+		/* inherently racy, no point locking */
+		if (put_user(input_pool.entropy_count, p))
 			return -EFAULT;
 		return 0;
 	case RNDADDTOENTCNT:
@@ -1116,13 +1115,13 @@
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
