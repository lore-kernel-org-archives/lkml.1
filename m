Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbYGKA22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbYGKA22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 20:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbYGKA2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:28:19 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:53353 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbYGKA2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:28:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ORVlU6C3KrduuFBI75We8e4Y0y3eqT6/Z4YqpsTezXtFUrBUdh9wEaPeBiQBFt5Fup
         5k2rWlTZvNgOnriICAy27L7crSWE3H8Zs8f1TkfW4JLq4Lp43GmmIIU+wbKg4n06PrEZ
         yc3znFVusFxoYQHjjiCf1jBK9MmSCakjDnb4o=
Message-ID: <6d291e080807101728j62be7c93qba11aa214a8dfe1@mail.gmail.com>
Date: Thu, 10 Jul 2008 19:28:16 -0500
From: "Stoyan Gaydarov" <stoyboyker@gmail.com>
To: rjw@sisk.pl, pavel@suse.cz
Subject: [PATCH] ioctl conversion
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the ioctl usage of kernel/power/user.c to use the unlocked_ioctl

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>

diff -uprN linux-2.6.26-rc9/kernel/power/user.c devel/kernel/power/user.c
--- linux-2.6.26-rc9/kernel/power/user.c        2008-07-05
17:53:22.000000000 -0500
+++ devel/kernel/power/user.c   2008-07-10 19:26:42.000000000 -0500
@@ -18,6 +18,7 @@
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/smp_lock.h>
 #include <linux/pm.h>
 #include <linux/fs.h>
 #include <linux/console.h>
@@ -164,20 +165,28 @@ static ssize_t snapshot_write(struct fil
        return res;
 }

-static int snapshot_ioctl(struct inode *inode, struct file *filp,
-                          unsigned int cmd, unsigned long arg)
+static long snapshot_ioctl(struct file *filp, unsigned int cmd,
+                          unsigned long arg)
 {
        int error = 0;
        struct snapshot_data *data;
        loff_t size;
        sector_t offset;

-       if (_IOC_TYPE(cmd) != SNAPSHOT_IOC_MAGIC)
+       lock_kernel();
+
+       if (_IOC_TYPE(cmd) != SNAPSHOT_IOC_MAGIC) {
+               unlock_kernel();
                return -ENOTTY;
-       if (_IOC_NR(cmd) > SNAPSHOT_IOC_MAXNR)
+       }
+       if (_IOC_NR(cmd) > SNAPSHOT_IOC_MAXNR) {
+               unlock_kernel();
                return -ENOTTY;
-       if (!capable(CAP_SYS_ADMIN))
+       }
+       if (!capable(CAP_SYS_ADMIN)) {
+               unlock_kernel();
                return -EPERM;
+       }

        data = filp->private_data;

@@ -390,6 +399,7 @@ static int snapshot_ioctl(struct inode *

        }

+       unlock_kernel();
        return error;
 }

@@ -399,7 +409,7 @@ static const struct file_operations snap
        .read = snapshot_read,
        .write = snapshot_write,
        .llseek = no_llseek,
-       .ioctl = snapshot_ioctl,
+       .unlocked_ioctl = snapshot_ioctl,
 };

 static struct miscdevice snapshot_device = {
