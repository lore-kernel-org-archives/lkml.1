Return-Path: <linux-kernel-owner+w=401wt.eu-S1764026AbYEVVc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764026AbYEVVc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbYEVVct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:32:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33434 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757947AbYEVVcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:32:48 -0400
Date: Thu, 22 May 2008 22:20:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, sfr@au1.ibm.com
Subject: [PATCH] viotape: Push down BKL ioctls
Message-ID: <20080522222012.3a07bd57@core>
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

diff --git a/drivers/char/viotape.c b/drivers/char/viotape.c
index 58aad63..b75f79f 100644
--- a/drivers/char/viotape.c
+++ b/drivers/char/viotape.c
@@ -46,8 +46,9 @@
 #include <linux/completion.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/smp_lock.h>
+#include <linux/uaccess.h>
 
-#include <asm/uaccess.h>
 #include <asm/ioctls.h>
 #include <asm/firmware.h>
 #include <asm/vio.h>
@@ -509,18 +510,24 @@ free_op:
 }
 
 /* ioctl */
-static int viotap_ioctl(struct inode *inode, struct file *file,
-		unsigned int cmd, unsigned long arg)
+static long viotap_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	HvLpEvent_Rc hvrc;
 	int ret;
 	struct viot_devinfo_struct devi;
 	struct mtop mtc;
 	u32 myOp;
-	struct op_struct *op = get_op_struct();
+	struct op_struct *op;
 
-	if (op == NULL)
+	lock_kernel();
+
+	op= get_op_struct();
+
+	if (op == NULL) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 
 	get_dev_info(file->f_path.dentry->d_inode, &devi);
 
@@ -661,6 +668,7 @@ static int viotap_ioctl(struct inode *inode, struct file *file,
 					&viomtget[devi.devno],
 					sizeof(viomtget[0])))
 			ret = -EFAULT;
+		unlock_kernel();
 		return ret;
 	case MTIOCPOS:
 		printk(VIOTAPE_KERN_WARN "Got an (unsupported) MTIOCPOS\n");
@@ -674,6 +682,7 @@ static int viotap_ioctl(struct inode *inode, struct file *file,
 free_op:
 	free_op_struct(op);
 	up(&reqSem);
+	unlock_kernel();
 	return ret;
 }
 
@@ -783,12 +792,12 @@ free_op:
 }
 
 const struct file_operations viotap_fops = {
-	.owner =	THIS_MODULE,
-	.read =		viotap_read,
-	.write =	viotap_write,
-	.ioctl =	viotap_ioctl,
-	.open =		viotap_open,
-	.release =	viotap_release,
+	.owner =		THIS_MODULE,
+	.read =			viotap_read,
+	.write =		viotap_write,
+	.unlocked_ioctl =	viotap_ioctl,
+	.open =			viotap_open,
+	.release =		viotap_release,
 };
 
 /* Handle interrupt events for tape */
@@ -1000,8 +1009,7 @@ static int chg_state(int index, unsigned char new_state, struct file *file)
 	if (*cur_state == VIOT_WRITING) {
 		struct mtop write_eof = { MTWEOF, 1 };
 
-		rc = viotap_ioctl(NULL, file, MTIOCTOP,
-				  (unsigned long)&write_eof);
+		rc = viotap_ioctl(file, MTIOCTOP, (unsigned long)&write_eof);
 	}
 	*cur_state = new_state;
 	return rc;
