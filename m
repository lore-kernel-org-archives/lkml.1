Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbZCXVRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbZCXVRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbZCXVNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:13:30 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:10497 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbZCXVNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:13:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WpuWCuljYVWmy0CbN6/pKwtsJ3bpUk8DPUoqVbrB9G4J/XpHZzUmHmmhuu/A0/1bMq
         bFawvUAvn8PoTKRwxnRoQjlK2iDx1HvC34NOLK2j8ltOei4Yg1YN3hsS+ksYCz5+A+g4
         qka/wzcJmlIckxd0MQx5vm0MoyBQiVWIN1ECs=
From: stoyboyker@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, hdegoede@redhat.com
Subject: [PATCH 11/13] [hwmon] changed ioctls to unlocked
Date: Tue, 24 Mar 2009 16:12:46 -0500
Message-Id: <1237929168-15341-12-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stoyan Gaydarov <stoyboyker@gmail.com>

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 drivers/hwmon/fschmd.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/fschmd.c b/drivers/hwmon/fschmd.c
index d07f4ef..79efb7b 100644
--- a/drivers/hwmon/fschmd.c
+++ b/drivers/hwmon/fschmd.c
@@ -40,6 +40,7 @@
 #include <linux/hwmon-sysfs.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/smp_lock.h>
 #include <linux/sysfs.h>
 #include <linux/dmi.h>
 #include <linux/fs.h>
@@ -769,15 +770,17 @@ static ssize_t watchdog_write(struct file *filp, const char __user *buf,
 	return count;
 }
 
-static int watchdog_ioctl(struct inode *inode, struct file *filp,
-	unsigned int cmd, unsigned long arg)
+static long watchdog_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	static struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
 				WDIOF_CARDRESET,
 		.identity = "FSC watchdog"
 	};
-	int i, ret = 0;
+
+	lock_kernel();
+
+	int i, ret;
 	struct fschmd_data *data = filp->private_data;
 
 	switch (cmd) {
@@ -837,6 +840,10 @@ static int watchdog_ioctl(struct inode *inode, struct file *filp,
 		ret = -ENOTTY;
 	}
 
+	if(!ret)
+		ret = -ENOTTY;
+
+	unlock_kernel();
 	return ret;
 }
 
@@ -846,7 +853,7 @@ static struct file_operations watchdog_fops = {
 	.open = watchdog_open,
 	.release = watchdog_release,
 	.write = watchdog_write,
-	.ioctl = watchdog_ioctl,
+	.unlocked_ioctl = watchdog_ioctl,
 };
 
 
-- 
1.6.2

