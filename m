Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbYEVUx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbYEVUx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755318AbYEVUxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:53:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54305 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761378AbYEVUxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:53:10 -0400
Date: Thu, 22 May 2008 21:40:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ip2: Push BKL down for the firmware interface
Message-ID: <20080522214039.38591cd7@core>
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

(The tty side is already done)

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index c12cf8f..9c8692f 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -202,7 +202,7 @@ static int set_serial_info(i2ChanStrPtr, struct serial_struct __user *);
 
 static ssize_t ip2_ipl_read(struct file *, char __user *, size_t, loff_t *);
 static ssize_t ip2_ipl_write(struct file *, const char __user *, size_t, loff_t *);
-static int ip2_ipl_ioctl(struct inode *, struct file *, UINT, ULONG);
+static long ip2_ipl_ioctl(struct file *, UINT, ULONG);
 static int ip2_ipl_open(struct inode *, struct file *);
 
 static int DumpTraceBuffer(char __user *, int);
@@ -235,7 +235,7 @@ static const struct file_operations ip2_ipl = {
 	.owner		= THIS_MODULE,
 	.read		= ip2_ipl_read,
 	.write		= ip2_ipl_write,
-	.ioctl		= ip2_ipl_ioctl,
+	.unlocked_ioctl	= ip2_ipl_ioctl,
 	.open		= ip2_ipl_open,
 }; 
 
@@ -2818,10 +2818,10 @@ ip2_ipl_write(struct file *pFile, const char __user *pData, size_t count, loff_t
 /*                                                                            */
 /*                                                                            */
 /******************************************************************************/
-static int
-ip2_ipl_ioctl ( struct inode *pInode, struct file *pFile, UINT cmd, ULONG arg )
+static long
+ip2_ipl_ioctl (struct file *pFile, UINT cmd, ULONG arg )
 {
-	unsigned int iplminor = iminor(pInode);
+	unsigned int iplminor = iminor(pFile->f_path.dentry->d_inode);
 	int rc = 0;
 	void __user *argp = (void __user *)arg;
 	ULONG __user *pIndex = argp;
@@ -2832,6 +2832,8 @@ ip2_ipl_ioctl ( struct inode *pInode, struct file *pFile, UINT cmd, ULONG arg )
 	printk (KERN_DEBUG "IP2IPL: ioctl cmd %d, arg %ld\n", cmd, arg );
 #endif
 
+	lock_kernel();
+
 	switch ( iplminor ) {
 	case 0:	    // IPL device
 		rc = -EINVAL;
@@ -2892,6 +2894,7 @@ ip2_ipl_ioctl ( struct inode *pInode, struct file *pFile, UINT cmd, ULONG arg )
 		rc = -ENODEV;
 		break;
 	}
+	unlock_kernel();
 	return rc;
 }
 
