Return-Path: <linux-kernel-owner+w=401wt.eu-S1759631AbYEVUjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631AbYEVUjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037AbYEVUjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:39:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60348 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755830AbYEVUjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:39:15 -0400
Date: Thu, 22 May 2008 21:26:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] paride: Push ioctl down into driver
Message-ID: <20080522212644.69e753e9@core>
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

Leaves us with lock_krnel for two methods. Also remove a bogus printk
with no printk level and return -ENOTTY not -EINVAL for correctness.

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/block/paride/pt.c b/drivers/block/paride/pt.c
index 8b9549a..27455ee 100644
--- a/drivers/block/paride/pt.c
+++ b/drivers/block/paride/pt.c
@@ -146,6 +146,7 @@ static int (*drives[4])[6] = {&drive0, &drive1, &drive2, &drive3};
 #include <linux/mtio.h>
 #include <linux/device.h>
 #include <linux/sched.h>	/* current, TASK_*, schedule_timeout() */
+#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 
@@ -189,8 +190,7 @@ module_param_array(drive3, int, NULL, 0);
 #define ATAPI_LOG_SENSE		0x4d
 
 static int pt_open(struct inode *inode, struct file *file);
-static int pt_ioctl(struct inode *inode, struct file *file,
-		    unsigned int cmd, unsigned long arg);
+static long pt_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 static int pt_release(struct inode *inode, struct file *file);
 static ssize_t pt_read(struct file *filp, char __user *buf,
 		       size_t count, loff_t * ppos);
@@ -236,7 +236,7 @@ static const struct file_operations pt_fops = {
 	.owner = THIS_MODULE,
 	.read = pt_read,
 	.write = pt_write,
-	.ioctl = pt_ioctl,
+	.unlocked_ioctl = pt_ioctl,
 	.open = pt_open,
 	.release = pt_release,
 };
@@ -685,8 +685,7 @@ out:
 	return err;
 }
 
-static int pt_ioctl(struct inode *inode, struct file *file,
-	 unsigned int cmd, unsigned long arg)
+static long pt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct pt_unit *tape = file->private_data;
 	struct mtop __user *p = (void __user *)arg;
@@ -700,23 +699,26 @@ static int pt_ioctl(struct inode *inode, struct file *file,
 		switch (mtop.mt_op) {
 
 		case MTREW:
+			lock_kernel();
 			pt_rewind(tape);
+			unlock_kernel();
 			return 0;
 
 		case MTWEOF:
+			lock_kernel();
 			pt_write_fm(tape);
+			unlock_kernel();
 			return 0;
 
 		default:
-			printk("%s: Unimplemented mt_op %d\n", tape->name,
+			/* FIXME: rate limit ?? */
+			printk(KERN_DEBUG "%s: Unimplemented mt_op %d\n", tape->name,
 			       mtop.mt_op);
 			return -EINVAL;
 		}
 
 	default:
-		printk("%s: Unimplemented ioctl 0x%x\n", tape->name, cmd);
-		return -EINVAL;
-
+		return -ENOTTY;
 	}
 }
 
