Return-Path: <linux-kernel-owner+w=401wt.eu-S1759666AbYEVUqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759666AbYEVUqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbYEVUqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:46:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44000 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753994AbYEVUqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:46:38 -0400
Date: Thu, 22 May 2008 21:34:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org
Subject: [PATCH] ds1286: push down BKL
Message-ID: <20080522213411.698845d5@core>
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

Not one I can test but hopefully someone can check this on the mips side
and better still eliminate the BKL in the ioctl handler entirely

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/ds1286.c b/drivers/char/ds1286.c
index ea35ab2..775b3f6 100644
--- a/drivers/char/ds1286.c
+++ b/drivers/char/ds1286.c
@@ -40,8 +40,8 @@
 #include <linux/bcd.h>
 #include <linux/proc_fs.h>
 #include <linux/jiffies.h>
-
-#include <asm/uaccess.h>
+#include <linux/smp_lock.h>
+#include <linux/uaccess.h>
 #include <asm/system.h>
 
 #define DS1286_VERSION		"1.0"
@@ -58,8 +58,8 @@ static DECLARE_WAIT_QUEUE_HEAD(ds1286_wait);
 static ssize_t ds1286_read(struct file *file, char *buf,
 			size_t count, loff_t *ppos);
 
-static int ds1286_ioctl(struct inode *inode, struct file *file,
-                        unsigned int cmd, unsigned long arg);
+static long ds1286_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg);
 
 static unsigned int ds1286_poll(struct file *file, poll_table *wait);
 
@@ -97,8 +97,8 @@ static ssize_t ds1286_read(struct file *file, char *buf,
 	return -EIO;
 }
 
-static int ds1286_ioctl(struct inode *inode, struct file *file,
-                        unsigned int cmd, unsigned long arg)
+static long do_ds1286_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	struct rtc_time wtime;
 
@@ -244,6 +244,16 @@ static int ds1286_ioctl(struct inode *inode, struct file *file,
 	return copy_to_user((void *)arg, &wtime, sizeof wtime) ? -EFAULT : 0;
 }
 
+static long ds1286_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
+{
+	long ret;
+	lock_kernel();
+	ret = ds1286_do_ioctl(file, cmd, arg);
+	unlock_kernel();
+	return ret;
+}
+
 /*
  *	We enforce only one user at a time here with the open/close.
  *	Also clear the previous interrupt data on an open, and clean
@@ -289,7 +299,7 @@ static const struct file_operations ds1286_fops = {
 	.llseek		= no_llseek,
 	.read		= ds1286_read,
 	.poll		= ds1286_poll,
-	.ioctl		= ds1286_ioctl,
+	.unlocked_ioctl	= ds1286_ioctl,
 	.open		= ds1286_open,
 	.release	= ds1286_release,
 };
