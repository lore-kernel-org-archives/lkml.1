Return-Path: <linux-kernel-owner+w=401wt.eu-S1762004AbZJJQoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762004AbZJJQoN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 12:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbZJJQoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 12:44:12 -0400
Received: from flounder.pepperfish.net ([87.237.62.181]:42707 "EHLO
	flounder.pepperfish.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbZJJQoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 12:44:12 -0400
From: Vincent Sanders <vince@simtec.co.uk>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Vincent Sanders <vince@simtec.co.uk>
Subject: [PATCH] Remove big kernel lock use from i2cdev_open
Date: Sat, 10 Oct 2009 12:46:12 +0100
Message-Id: <1255175172-2666-1-git-send-email-vince@simtec.co.uk>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL is held over a kmalloc so cannot protect anything beyond that.
The two calls before the kmalloc have their own locking.
Improve device open function by removing the now unnecessary ret variable

Signed-off-by: Vincent Sanders <vince@simtec.co.uk>
---
 drivers/i2c/i2c-dev.c |   21 ++++++---------------
 1 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index 7e13d2d..3196503 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -445,20 +445,14 @@ static int i2cdev_open(struct inode *inode, struct file *file)
 	struct i2c_client *client;
 	struct i2c_adapter *adap;
 	struct i2c_dev *i2c_dev;
-	int ret = 0;
 
-	lock_kernel();
 	i2c_dev = i2c_dev_get_by_minor(minor);
-	if (!i2c_dev) {
-		ret = -ENODEV;
-		goto out;
-	}
+	if (!i2c_dev)
+		return -ENODEV;
 
 	adap = i2c_get_adapter(i2c_dev->adap->nr);
-	if (!adap) {
-		ret = -ENODEV;
-		goto out;
-	}
+	if (!adap)
+		return -ENODEV;
 
 	/* This creates an anonymous i2c_client, which may later be
 	 * pointed to some address using I2C_SLAVE or I2C_SLAVE_FORCE.
@@ -470,8 +464,7 @@ static int i2cdev_open(struct inode *inode, struct file *file)
 	client = kzalloc(sizeof(*client), GFP_KERNEL);
 	if (!client) {
 		i2c_put_adapter(adap);
-		ret = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 	snprintf(client->name, I2C_NAME_SIZE, "i2c-dev %d", adap->nr);
 	client->driver = &i2cdev_driver;
@@ -479,9 +472,7 @@ static int i2cdev_open(struct inode *inode, struct file *file)
 	client->adapter = adap;
 	file->private_data = client;
 
-out:
-	unlock_kernel();
-	return ret;
+	return 0;
 }
 
 static int i2cdev_release(struct inode *inode, struct file *file)
-- 
1.6.0.4

