Return-Path: <linux-kernel-owner+w=401wt.eu-S935499AbZJOU3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935499AbZJOU3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 16:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935478AbZJOU3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 16:29:34 -0400
Received: from www.tglx.de ([62.245.132.106]:52491 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935475AbZJOU3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 16:29:33 -0400
Message-Id: <20091015202758.441681409@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 15 Oct 2009 20:28:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: ALan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: [patch 2/5] macintosh: Remove BKL from nvram driver
References: <20091015202722.372890083@linutronix.de>
Content-Disposition: inline; filename=drivers-mac-nvram-remove-bkl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the bkl from nvram_llseek() as it obviously protects nothing. The
file offset is safe in essence.

The ioctl can be converted to unlocked_ioctl because it just calls
pmac_get_partition() which reads a value from an array which was
initialized at early boot time. No need for serialization.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org
---
 drivers/macintosh/nvram.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

Index: linux-2.6-tip/drivers/macintosh/nvram.c
===================================================================
--- linux-2.6-tip.orig/drivers/macintosh/nvram.c
+++ linux-2.6-tip/drivers/macintosh/nvram.c
@@ -13,7 +13,6 @@
 #include <linux/fcntl.h>
 #include <linux/nvram.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include <asm/nvram.h>
 
@@ -21,7 +20,6 @@
 
 static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
 {
-	lock_kernel();
 	switch (origin) {
 	case 1:
 		offset += file->f_pos;
@@ -30,12 +28,10 @@ static loff_t nvram_llseek(struct file *
 		offset += NVRAM_SIZE;
 		break;
 	}
-	if (offset < 0) {
-		unlock_kernel();
+	if (offset < 0)
 		return -EINVAL;
-	}
+
 	file->f_pos = offset;
-	unlock_kernel();
 	return file->f_pos;
 }
 
@@ -76,8 +72,7 @@ static ssize_t write_nvram(struct file *
 	return p - buf;
 }
 
-static int nvram_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long nvram_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	switch(cmd) {
 		case PMAC_NVRAM_GET_OFFSET:


