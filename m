Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab0CITUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:20:09 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:39151 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab0CITUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:20:05 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>, John Kacur <jkacur@gmail.com>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 1/3] input: remove BKL from mousedev
Date: Tue,  9 Mar 2010 16:19:44 -0300
Message-Id: <1268162386-2745-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need for BKL in mousedev. It uses lots of locking already
that should handle the open case.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/input/mousedev.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index a13d80f..f34b22b 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -15,7 +15,6 @@
 
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/poll.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -542,10 +541,8 @@ static int mousedev_open(struct inode *inode, struct file *file)
 	if (i >= MOUSEDEV_MINORS)
 		return -ENODEV;
 
-	lock_kernel();
 	error = mutex_lock_interruptible(&mousedev_table_mutex);
 	if (error) {
-		unlock_kernel();
 		return error;
 	}
 	mousedev = mousedev_table[i];
@@ -554,7 +551,6 @@ static int mousedev_open(struct inode *inode, struct file *file)
 	mutex_unlock(&mousedev_table_mutex);
 
 	if (!mousedev) {
-		unlock_kernel();
 		return -ENODEV;
 	}
 
@@ -575,7 +571,6 @@ static int mousedev_open(struct inode *inode, struct file *file)
 		goto err_free_client;
 
 	file->private_data = client;
-	unlock_kernel();
 	return 0;
 
  err_free_client:
@@ -583,7 +578,6 @@ static int mousedev_open(struct inode *inode, struct file *file)
 	kfree(client);
  err_put_mousedev:
 	put_device(&mousedev->dev);
-	unlock_kernel();
 	return error;
 }
 
-- 
1.6.6.1

