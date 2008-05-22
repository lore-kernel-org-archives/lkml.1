Return-Path: <linux-kernel-owner+w=401wt.eu-S1764067AbYEVViR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764067AbYEVViR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbYEVViB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:38:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37316 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752383AbYEVViA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:38:00 -0400
Date: Thu, 22 May 2008 22:25:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] snapshot: Push BKL down into ioctl handlers
Message-ID: <20080522222500.0f5873ff@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/kernel/power/user.c b/kernel/power/user.c
index f5512cb..658262b 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -23,6 +23,7 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/freezer.h>
+#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 
@@ -164,8 +165,8 @@ static ssize_t snapshot_write(struct file *filp, const char __user *buf,
 	return res;
 }
 
-static int snapshot_ioctl(struct inode *inode, struct file *filp,
-                          unsigned int cmd, unsigned long arg)
+static long snapshot_ioctl(struct file *filp, unsigned int cmd,
+							unsigned long arg)
 {
 	int error = 0;
 	struct snapshot_data *data;
@@ -181,6 +182,8 @@ static int snapshot_ioctl(struct inode *inode, struct file *filp,
 
 	data = filp->private_data;
 
+	lock_kernel();
+
 	switch (cmd) {
 
 	case SNAPSHOT_FREEZE:
@@ -389,7 +392,7 @@ static int snapshot_ioctl(struct inode *inode, struct file *filp,
 		error = -ENOTTY;
 
 	}
-
+	unlock_kernel();
 	return error;
 }
 
@@ -399,7 +402,7 @@ static const struct file_operations snapshot_fops = {
 	.read = snapshot_read,
 	.write = snapshot_write,
 	.llseek = no_llseek,
-	.ioctl = snapshot_ioctl,
+	.unlocked_ioctl = snapshot_ioctl,
 };
 
 static struct miscdevice snapshot_device = {
