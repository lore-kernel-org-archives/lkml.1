Return-Path: <linux-kernel-owner+w=401wt.eu-S934893AbZAPOeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934893AbZAPOeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbZAPOeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:34:01 -0500
Received: from smtp.nokia.com ([192.100.122.230]:40237 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbZAPOeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:34:00 -0500
Subject: Re: [PATCH] UBI: add ioctl compatibility
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200901161324.35271.arnd@arndb.de>
References: <1232036381.25068.10.camel@localhost.localdomain>
	 <200901151734.23870.arnd@arndb.de>
	 <1232104138.25068.22.camel@localhost.localdomain>
	 <200901161324.35271.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Jan 2009 16:34:07 +0200
Message-Id: <1232116447.25068.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 16 Jan 2009 14:33:37.0896 (UTC) FILETIME=[6B59AE80:01C977E7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-16 at 13:24 +0100, Arnd Bergmann wrote:
> On Friday 16 January 2009, Artem Bityutskiy wrote:
> > Thank you Arnd. Here is the corrected patch. Tested on x68_64 + 32-bit
> > UBI tools.
> > 
> 
> Looks better now, but the compat_ versions are still missing the
> compat_ptr() conversions. Those only make a difference on s390,
> so you wouldn't see the problem on x86_64.

Ok, here is the new patch.

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH] UBI: add ioctl compatibility

UBI ioctl's do not work when running 64-bit kernel and 32-bit
user-land. Fix this by adding the compat_ioctl method.

Also, UBI serializes all ioctls, so more than one ioctl at a time
is not a problem. Amd UBI does not seem to depend on anything else,
so use unlocked_ioctl instead of ioctl (no BKL needed).

Reported-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 drivers/mtd/ubi/cdev.c |   66 ++++++++++++++++++++++++++++++++++--------------
 1 files changed, 47 insertions(+), 19 deletions(-)

diff --git a/drivers/mtd/ubi/cdev.c b/drivers/mtd/ubi/cdev.c
index d99935c..820f50e 100644
--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -40,6 +40,7 @@
 #include <linux/ioctl.h>
 #include <linux/capability.h>
 #include <linux/uaccess.h>
+#include <linux/compat.h>
 #include <mtd/ubi-user.h>
 #include <asm/div64.h>
 #include "ubi.h"
@@ -401,8 +402,8 @@ static ssize_t vol_cdev_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static int vol_cdev_ioctl(struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg)
+static long vol_cdev_ioctl(struct file *file, unsigned int cmd,
+			   unsigned long arg)
 {
 	int err = 0;
 	struct ubi_volume_desc *desc = file->private_data;
@@ -566,6 +567,14 @@ static int vol_cdev_ioctl(struct inode *inode, struct file *file,
 	return err;
 }
 
+static long vol_cdev_compat_ioctl(struct file *file, unsigned int cmd,
+				  unsigned long arg)
+{
+	unsigned long translated_arg = (unsigned long)compat_ptr(arg);
+
+	return vol_cdev_ioctl(file, cmd, translated_arg);
+}
+
 /**
  * verify_mkvol_req - verify volume creation request.
  * @ubi: UBI device description object
@@ -800,8 +809,8 @@ out_free:
 	return err;
 }
 
-static int ubi_cdev_ioctl(struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg)
+static long ubi_cdev_ioctl(struct file *file, unsigned int cmd,
+			   unsigned long arg)
 {
 	int err = 0;
 	struct ubi_device *ubi;
@@ -811,7 +820,7 @@ static int ubi_cdev_ioctl(struct inode *inode, struct file *file,
 	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
 
-	ubi = ubi_get_by_major(imajor(inode));
+	ubi = ubi_get_by_major(imajor(file->f_mapping->host));
 	if (!ubi)
 		return -ENODEV;
 
@@ -947,8 +956,16 @@ static int ubi_cdev_ioctl(struct inode *inode, struct file *file,
 	return err;
 }
 
-static int ctrl_cdev_ioctl(struct inode *inode, struct file *file,
-			   unsigned int cmd, unsigned long arg)
+static long ubi_cdev_compat_ioctl(struct file *file, unsigned int cmd,
+				  unsigned long arg)
+{
+	unsigned long translated_arg = (unsigned long)compat_ptr(arg);
+
+	return ubi_cdev_ioctl(file, cmd, translated_arg);
+}
+
+static long ctrl_cdev_ioctl(struct file *file, unsigned int cmd,
+			    unsigned long arg)
 {
 	int err = 0;
 	void __user *argp = (void __user *)arg;
@@ -1024,26 +1041,37 @@ static int ctrl_cdev_ioctl(struct inode *inode, struct file *file,
 	return err;
 }
 
+static long ctrl_cdev_compat_ioctl(struct file *file, unsigned int cmd,
+				   unsigned long arg)
+{
+	unsigned long translated_arg = (unsigned long)compat_ptr(arg);
+
+	return ctrl_cdev_ioctl(file, cmd, translated_arg);
+}
+
 /* UBI control character device operations */
 const struct file_operations ubi_ctrl_cdev_operations = {
-	.ioctl = ctrl_cdev_ioctl,
-	.owner = THIS_MODULE,
+	.owner          = THIS_MODULE,
+	.unlocked_ioctl = ctrl_cdev_ioctl,
+	.compat_ioctl   = ctrl_cdev_compat_ioctl,
 };
 
 /* UBI character device operations */
 const struct file_operations ubi_cdev_operations = {
-	.owner = THIS_MODULE,
-	.ioctl = ubi_cdev_ioctl,
-	.llseek = no_llseek,
+	.owner          = THIS_MODULE,
+	.llseek         = no_llseek,
+	.unlocked_ioctl = ubi_cdev_ioctl,
+	.compat_ioctl   = ubi_cdev_compat_ioctl,
 };
 
 /* UBI volume character device operations */
 const struct file_operations ubi_vol_cdev_operations = {
-	.owner   = THIS_MODULE,
-	.open    = vol_cdev_open,
-	.release = vol_cdev_release,
-	.llseek  = vol_cdev_llseek,
-	.read    = vol_cdev_read,
-	.write   = vol_cdev_write,
-	.ioctl   = vol_cdev_ioctl,
+	.owner          = THIS_MODULE,
+	.open           = vol_cdev_open,
+	.release        = vol_cdev_release,
+	.llseek         = vol_cdev_llseek,
+	.read           = vol_cdev_read,
+	.write          = vol_cdev_write,
+	.unlocked_ioctl = vol_cdev_ioctl,
+	.compat_ioctl   = vol_cdev_compat_ioctl,
 };
-- 
1.6.0.6

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

