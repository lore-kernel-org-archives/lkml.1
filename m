Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbYGAC6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbYGAC6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 22:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbYGAC5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 22:57:14 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:52183 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbYGAC5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 22:57:11 -0400
Subject: [PATCH 3/7] fat/dir.c: switch to struct __fat_dirent
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp, bunk@kernel.org
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Tue, 01 Jul 2008 11:57:03 +0900
Message-ID: <d3ce91fd3e848699cff311608.ps@mail.parknet.co.jp>
References: <9edbdefc3e848699cfe111608.ps@mail.parknet.co.jp>
	<129170883e848699cff211608.ps@mail.parknet.co.jp>
In-Reply-To: <129170883e848699cff211608.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


struct __fat_dirent is what was formerly the kernel struct dirent
(that was different from the userspace struct dirent).

Converting all fat users to struct __fat_dirent will allow us to get 
rid of the conflicting struct dirent definition.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/dir.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/fat/dir.c~fat_use-fat_fs_dirent fs/fat/dir.c
--- linux-2.6/fs/fat/dir.c~fat_use-fat_fs_dirent	2008-07-01 09:50:49.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/dir.c	2008-07-01 11:34:35.000000000 +0900
@@ -17,7 +17,6 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/msdos_fs.h>
-#include <linux/dirent.h>
 #include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/compat.h>
@@ -715,7 +714,7 @@ efault:									   \
 	return -EFAULT;							   \
 }
 
-FAT_IOCTL_FILLDIR_FUNC(fat_ioctl_filldir, dirent)
+FAT_IOCTL_FILLDIR_FUNC(fat_ioctl_filldir, __fat_dirent)
 
 static int fat_ioctl_readdir(struct inode *inode, struct file *filp,
 			     void __user *dirent, filldir_t filldir,
@@ -741,7 +740,7 @@ static int fat_ioctl_readdir(struct inod
 static int fat_dir_ioctl(struct inode *inode, struct file *filp,
 			 unsigned int cmd, unsigned long arg)
 {
-	struct dirent __user *d1 = (struct dirent __user *)arg;
+	struct __fat_dirent __user *d1 = (struct __fat_dirent __user *)arg;
 	int short_only, both;
 
 	switch (cmd) {
@@ -757,7 +756,7 @@ static int fat_dir_ioctl(struct inode *i
 		return fat_generic_ioctl(inode, filp, cmd, arg);
 	}
 
-	if (!access_ok(VERIFY_WRITE, d1, sizeof(struct dirent[2])))
+	if (!access_ok(VERIFY_WRITE, d1, sizeof(struct __fat_dirent[2])))
 		return -EFAULT;
 	/*
 	 * Yes, we don't need this put_user() absolutely. However old
_
