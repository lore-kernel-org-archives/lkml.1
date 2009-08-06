Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbZHFJks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbZHFJks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 05:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbZHFJkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 05:40:47 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:38924 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZHFJkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 05:40:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Z5R/ZNzyh+14Yym0tZwIqwsXmiVnnVHGmxi+579AnBGBIqLNq+PUDQ35aglG7I1/z1
         DRb3kavlKoYEXZ+kOFvZ7R2pu1pScDII5vZ5eWbcRQaAb4e2z2kTovZNBJJ0OgI5k1aP
         UNcaIcCIgfLz0M5esmHUcMSf6m7Z9mOm0dhCE=
From: tom.leiming@gmail.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
       akpm@linux-foundation.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 2/2] init/do_mounts.c: replace polling for root device with devtmpfs_wait_for_dev v1
Date: Thu,  6 Aug 2009 17:40:42 +0800
Message-Id: <1249551642-13182-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch removes the polling for root device if rootwait parameter is
passed to kernel and CONFIG_DEVTMPFS is enabled. This way can lead to
a faster boot, especially booting from some asynchronous block device
(such as usb mass storage, mmc card, ...)

The patch has been verified in beagle board(mmc card as root device).

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 init/do_mounts.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index aa56007..46f0248 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -364,6 +364,7 @@ void __init mount_root(void)
 void __init prepare_namespace(void)
 {
 	int is_floppy;
+	int ret;
 
 	if (root_delay) {
 		printk(KERN_INFO "Waiting %dsec before mounting root device...\n",
@@ -371,6 +372,7 @@ void __init prepare_namespace(void)
 		ssleep(root_delay);
 	}
 
+#ifndef CONFIG_DEVTMPFS
 	/*
 	 * wait for the known devices to complete their probing
 	 *
@@ -379,6 +381,7 @@ void __init prepare_namespace(void)
 	 * for the touchpad of a laptop to initialize.
 	 */
 	wait_for_device_probe();
+#endif
 
 	md_run_setup();
 
@@ -397,6 +400,7 @@ void __init prepare_namespace(void)
 	if (initrd_load())
 		goto out;
 
+#ifndef CONFIG_DEVTMPFS
 	/* wait for any asynchronous scanning to complete */
 	if ((ROOT_DEV == 0) && root_wait) {
 		printk(KERN_INFO "Waiting for root device %s...\n",
@@ -406,6 +410,18 @@ void __init prepare_namespace(void)
 			msleep(100);
 		async_synchronize_full();
 	}
+#else
+	/*wait for root device, and expire if 120 seconds elapse*/
+	if (!strncmp(saved_root_name, "/dev/", 5)) {
+		ret = devtmpfs_wait_for_dev(saved_root_name+5, 120);
+		printk(KERN_INFO "wait for %s based on devtmpfs:%d\n",
+			saved_root_name, ret);
+	}
+
+	ROOT_DEV = name_to_dev_t(saved_root_name);
+	if (!ROOT_DEV)
+		printk(KERN_ERR "Root device %s not found!\n", saved_root_name);
+#endif
 
 	is_floppy = MAJOR(ROOT_DEV) == FLOPPY_MAJOR;
 
-- 
1.6.0.GIT

