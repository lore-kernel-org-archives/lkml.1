Return-Path: <linux-kernel-owner+w=401wt.eu-S932517AbZAPLJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517AbZAPLJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 06:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759444AbZAPLJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 06:09:09 -0500
Received: from smtp.nokia.com ([192.100.122.230]:56833 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759094AbZAPLJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 06:09:08 -0500
Subject: Re: [PATCH] UBI: add ioctl compatibility
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200901151734.23870.arnd@arndb.de>
References: <1232036381.25068.10.camel@localhost.localdomain>
	 <200901151734.23870.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Jan 2009 13:08:58 +0200
Message-Id: <1232104138.25068.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 16 Jan 2009 11:08:28.0919 (UTC) FILETIME=[C2A0D870:01C977CA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 17:34 +0100, Arnd Bergmann wrote:
> On Thursday 15 January 2009, Artem Bityutskiy wrote:
> 
> > would you please glance if this patch all-right?
> 
> No, it's not. New ioctl numbers should not be added to fs/compat_ioctl.c
> but rather to the file that implements the file operations (ubi/cdev.c).

Thank you Arnd. Here is the corrected patch. Tested on x68_64 + 32-bit
UBI tools.

>From 8d1e92e1e277e3f9fb51491b248f3c6cbfc86083 Mon Sep 17 00:00:00 2001
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Fri, 16 Jan 2009 14:08:35 +0200
Subject: [PATCH] UBI: add ioctl compatibility

UBI ioctl's do not work when running 64-bit kernel and 32-bit
user-land. Fix this by adding the compat_ioctl method.

Also, UBI serializes all ioctls, so more than one ioctl at a time,
and UBI does not seem to depend on anything else, so use
unlocked_ioctl instead of ioctl (no BKL needed).

Reported-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 drivers/mtd/ubi/cdev.c |   41 ++++++++++++++++++++++-------------------
 1 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/mtd/ubi/cdev.c b/drivers/mtd/ubi/cdev.c
index a4a6e9a..c5f8a91 100644
--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -402,8 +402,8 @@ static ssize_t vol_cdev_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static int vol_cdev_ioctl(struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg)
+static long vol_cdev_ioctl(struct file *file, unsigned int cmd,
+			   unsigned long arg)
 {
 	int err = 0;
 	struct ubi_volume_desc *desc = file->private_data;
@@ -803,8 +803,8 @@ out_free:
 	return err;
 }
 
-static int ubi_cdev_ioctl(struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg)
+static long ubi_cdev_ioctl(struct file *file, unsigned int cmd,
+			   unsigned long arg)
 {
 	int err = 0;
 	struct ubi_device *ubi;
@@ -814,7 +814,7 @@ static int ubi_cdev_ioctl(struct inode *inode, struct file *file,
 	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
 
-	ubi = ubi_get_by_major(imajor(inode));
+	ubi = ubi_get_by_major(imajor(file->f_mapping->host));
 	if (!ubi)
 		return -ENODEV;
 
@@ -950,8 +950,8 @@ static int ubi_cdev_ioctl(struct inode *inode, struct file *file,
 	return err;
 }
 
-static int ctrl_cdev_ioctl(struct inode *inode, struct file *file,
-			   unsigned int cmd, unsigned long arg)
+static long ctrl_cdev_ioctl(struct file *file, unsigned int cmd,
+			    unsigned long arg)
 {
 	int err = 0;
 	void __user *argp = (void __user *)arg;
@@ -1029,24 +1029,27 @@ static int ctrl_cdev_ioctl(struct inode *inode, struct file *file,
 
 /* UBI control character device operations */
 const struct file_operations ubi_ctrl_cdev_operations = {
-	.ioctl = ctrl_cdev_ioctl,
-	.owner = THIS_MODULE,
+	.owner          = THIS_MODULE,
+	.unlocked_ioctl = ctrl_cdev_ioctl,
+	.compat_ioctl   = ctrl_cdev_ioctl,
 };
 
 /* UBI character device operations */
 const struct file_operations ubi_cdev_operations = {
-	.owner = THIS_MODULE,
-	.ioctl = ubi_cdev_ioctl,
-	.llseek = no_llseek,
+	.owner          = THIS_MODULE,
+	.llseek         = no_llseek,
+	.unlocked_ioctl = ubi_cdev_ioctl,
+	.compat_ioctl   = ubi_cdev_ioctl,
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
+	.compat_ioctl   = vol_cdev_ioctl,
 };
-- 
1.6.0.6



-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

