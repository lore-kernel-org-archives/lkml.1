Return-Path: <linux-kernel-owner+w=401wt.eu-S934383AbZJJPkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934383AbZJJPkb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761944AbZJJPjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:39:07 -0400
Received: from www.tglx.de ([62.245.132.106]:55622 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762006AbZJJPi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:38:58 -0400
Message-Id: <20091010153350.006406413@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:37:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Jean Delvare <khali@linux-fr.org>
Subject: [patch 23/28] i2c: Remove big kernel lock from i2cdev_open
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline;
	filename=remove-big-kernel-lock-use-from-i2cdev_open.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL is held over a kmalloc so cannot protect anything beyond that.
The two calls before the kmalloc have their own locking.
Improve device open function by removing the now unnecessary ret variable

Signed-off-by: Vincent Sanders <vince@simtec.co.uk>
LKML-Reference: <1255175172-2666-1-git-send-email-vince@simtec.co.uk>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/i2c/i2c-dev.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

Index: linux-2.6-tip/drivers/i2c/i2c-dev.c
===================================================================
--- linux-2.6-tip.orig/drivers/i2c/i2c-dev.c
+++ linux-2.6-tip/drivers/i2c/i2c-dev.c
@@ -34,7 +34,6 @@
 #include <linux/list.h>
 #include <linux/i2c.h>
 #include <linux/i2c-dev.h>
-#include <linux/smp_lock.h>
 #include <linux/jiffies.h>
 #include <asm/uaccess.h>
 
@@ -445,20 +444,14 @@ static int i2cdev_open(struct inode *ino
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
@@ -470,8 +463,7 @@ static int i2cdev_open(struct inode *ino
 	client = kzalloc(sizeof(*client), GFP_KERNEL);
 	if (!client) {
 		i2c_put_adapter(adap);
-		ret = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 	snprintf(client->name, I2C_NAME_SIZE, "i2c-dev %d", adap->nr);
 	client->driver = &i2cdev_driver;
@@ -479,9 +471,7 @@ static int i2cdev_open(struct inode *ino
 	client->adapter = adap;
 	file->private_data = client;
 
-out:
-	unlock_kernel();
-	return ret;
+	return 0;
 }
 
 static int i2cdev_release(struct inode *inode, struct file *file)


