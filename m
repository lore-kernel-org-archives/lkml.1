Return-Path: <linux-kernel-owner+w=401wt.eu-S1761763AbYEVVAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761763AbYEVVAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756956AbYEVU75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:59:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37373 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755265AbYEVU75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:59:57 -0400
Date: Thu, 22 May 2008 21:47:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] sx: Push BKL down into the firmware ioctl handler
Message-ID: <20080522214725.30614b07@core>
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

Also fix the capability checking for firmware load.

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index d5cffcd..153e16e 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -286,8 +286,8 @@ static void sx_close(void *ptr);
 static int sx_chars_in_buffer(void *ptr);
 static int sx_init_board(struct sx_board *board);
 static int sx_init_portstructs(int nboards, int nports);
-static int sx_fw_ioctl(struct inode *inode, struct file *filp,
-		unsigned int cmd, unsigned long arg);
+static long sx_fw_ioctl(struct file *filp, unsigned int cmd,
+						unsigned long arg);
 static int sx_init_drivers(void);
 
 static struct tty_driver *sx_driver;
@@ -396,7 +396,7 @@ static struct real_driver sx_real_driver = {
 
 static const struct file_operations sx_fw_fops = {
 	.owner = THIS_MODULE,
-	.ioctl = sx_fw_ioctl,
+	.unlocked_ioctl = sx_fw_ioctl,
 };
 
 static struct miscdevice sx_fw_device = {
@@ -1686,10 +1686,10 @@ static int do_memtest_w(struct sx_board *board, int min, int max)
 }
 #endif
 
-static int sx_fw_ioctl(struct inode *inode, struct file *filp,
-		unsigned int cmd, unsigned long arg)
+static long sx_fw_ioctl(struct file *filp, unsigned int cmd,
+							unsigned long arg)
 {
-	int rc = 0;
+	long rc = 0;
 	int __user *descr = (int __user *)arg;
 	int i;
 	static struct sx_board *board = NULL;
@@ -1699,13 +1699,10 @@ static int sx_fw_ioctl(struct inode *inode, struct file *filp,
 
 	func_enter();
 
-#if 0
-	/* Removed superuser check: Sysops can use the permissions on the device
-	   file to restrict access. Recommendation: Root only. (root.root 600) */
-	if (!capable(CAP_SYS_ADMIN)) {
+	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
-	}
-#endif
+
+	lock_kernel();
 
 	sx_dprintk(SX_DEBUG_FIRMWARE, "IOCTL %x: %lx\n", cmd, arg);
 
@@ -1720,19 +1717,23 @@ static int sx_fw_ioctl(struct inode *inode, struct file *filp,
 		for (i = 0; i < SX_NBOARDS; i++)
 			sx_dprintk(SX_DEBUG_FIRMWARE, "<%x> ", boards[i].flags);
 		sx_dprintk(SX_DEBUG_FIRMWARE, "\n");
+		unlock_kernel();
 		return -EIO;
 	}
 
 	switch (cmd) {
 	case SXIO_SET_BOARD:
 		sx_dprintk(SX_DEBUG_FIRMWARE, "set board to %ld\n", arg);
+		rc = -EIO;
 		if (arg >= SX_NBOARDS)
-			return -EIO;
+			break;
 		sx_dprintk(SX_DEBUG_FIRMWARE, "not out of range\n");
 		if (!(boards[arg].flags & SX_BOARD_PRESENT))
-			return -EIO;
+			break;
 		sx_dprintk(SX_DEBUG_FIRMWARE, ".. and present!\n");
 		board = &boards[arg];
+		rc = 0;
+		/* FIXME: And this does ... nothing?? */
 		break;
 	case SXIO_GET_TYPE:
 		rc = -ENOENT;	/* If we manage to miss one, return error. */
@@ -1746,7 +1747,7 @@ static int sx_fw_ioctl(struct inode *inode, struct file *filp,
 			rc = SX_TYPE_SI;
 		if (IS_EISA_BOARD(board))
 			rc = SX_TYPE_SI;
-		sx_dprintk(SX_DEBUG_FIRMWARE, "returning type= %d\n", rc);
+		sx_dprintk(SX_DEBUG_FIRMWARE, "returning type= %ld\n", rc);
 		break;
 	case SXIO_DO_RAMTEST:
 		if (sx_initialized)	/* Already initialized: better not ramtest the board.  */
@@ -1760,19 +1761,26 @@ static int sx_fw_ioctl(struct inode *inode, struct file *filp,
 			rc = do_memtest(board, 0, 0x7ff8);
 			/* if (!rc) rc = do_memtest_w (board, 0, 0x7ff8); */
 		}
-		sx_dprintk(SX_DEBUG_FIRMWARE, "returning memtest result= %d\n",
-			   rc);
+		sx_dprintk(SX_DEBUG_FIRMWARE,
+				"returning memtest result= %ld\n", rc);
 		break;
 	case SXIO_DOWNLOAD:
-		if (sx_initialized)	/* Already initialized */
-			return -EEXIST;
-		if (!sx_reset(board))
-			return -EIO;
+		if (sx_initialized) {/* Already initialized */
+			rc = -EEXIST;
+			break;
+		}
+		if (!sx_reset(board)) {
+			rc = -EIO;
+			break;
+		}
 		sx_dprintk(SX_DEBUG_INIT, "reset the board...\n");
 
 		tmp = kmalloc(SX_CHUNK_SIZE, GFP_USER);
-		if (!tmp)
-			return -ENOMEM;
+		if (!tmp) {
+			rc = -ENOMEM;
+			break;
+		}
+		/* FIXME: check returns */
 		get_user(nbytes, descr++);
 		get_user(offset, descr++);
 		get_user(data, descr++);
@@ -1782,7 +1790,8 @@ static int sx_fw_ioctl(struct inode *inode, struct file *filp,
 						(i + SX_CHUNK_SIZE > nbytes) ?
 						nbytes - i : SX_CHUNK_SIZE)) {
 					kfree(tmp);
-					return -EFAULT;
+					rc = -EFAULT;
+					break;
 				}
 				memcpy_toio(board->base2 + offset + i, tmp,
 						(i + SX_CHUNK_SIZE > nbytes) ?
@@ -1798,13 +1807,17 @@ static int sx_fw_ioctl(struct inode *inode, struct file *filp,
 		rc = sx_nports;
 		break;
 	case SXIO_INIT:
-		if (sx_initialized)	/* Already initialized */
-			return -EEXIST;
+		if (sx_initialized) {	/* Already initialized */
+			rc = -EEXIST;
+			break;
+		}
 		/* This is not allowed until all boards are initialized... */
 		for (i = 0; i < SX_NBOARDS; i++) {
 			if ((boards[i].flags & SX_BOARD_PRESENT) &&
-				!(boards[i].flags & SX_BOARD_INITIALIZED))
-				return -EIO;
+				!(boards[i].flags & SX_BOARD_INITIALIZED)) {
+				rc = -EIO;
+				break;
+			}
 		}
 		for (i = 0; i < SX_NBOARDS; i++)
 			if (!(boards[i].flags & SX_BOARD_PRESENT))
@@ -1832,10 +1845,10 @@ static int sx_fw_ioctl(struct inode *inode, struct file *filp,
 		rc = sx_nports;
 		break;
 	default:
-		printk(KERN_WARNING "Unknown ioctl on firmware device (%x).\n",
-				cmd);
+		rc = -ENOTTY;
 		break;
 	}
+	unlock_kernel();
 	func_exit();
 	return rc;
 }
