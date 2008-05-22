Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938AbYEVUho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbYEVUho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbYEVUhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:37:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54646 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754675AbYEVUhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:37:33 -0400
Date: Thu, 22 May 2008 21:24:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, dwmw2@redhat.com
Subject: [PATCH] applicom: push BKL down into driver
Message-ID: <20080522212449.0ad5f598@core>
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

Not a lot of elimination here just push it down so someone can do it
later.

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index 31d08b6..80fed25 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -104,8 +104,7 @@ static unsigned int DeviceErrorCount;	/* number of device error     */
 
 static ssize_t ac_read (struct file *, char __user *, size_t, loff_t *);
 static ssize_t ac_write (struct file *, const char __user *, size_t, loff_t *);
-static int ac_ioctl(struct inode *, struct file *, unsigned int,
-		    unsigned long);
+static long ac_ioctl(struct file *, unsigned int, unsigned long);
 static irqreturn_t ac_interrupt(int, void *);
 
 static const struct file_operations ac_fops = {
@@ -113,7 +112,7 @@ static const struct file_operations ac_fops = {
 	.llseek = no_llseek,
 	.read = ac_read,
 	.write = ac_write,
-	.ioctl = ac_ioctl,
+	.unlocked_ioctl = ac_ioctl,
 };
 
 static struct miscdevice ac_miscdev = {
@@ -687,7 +686,7 @@ static irqreturn_t ac_interrupt(int vec, void *dev_instance)
 
 
 
-static int ac_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long ac_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
      
 {				/* @ ADG ou ATO selon le cas */
 	int i;
@@ -710,6 +709,8 @@ static int ac_ioctl(struct inode *inode, struct file *file, unsigned int cmd, un
 		return -EFAULT;
 	}
 	
+	lock_kernel();
+
 	IndexCard = adgl->num_card-1;
 	 
 	if(cmd != 0 && cmd != 6 &&
@@ -720,6 +721,7 @@ static int ac_ioctl(struct inode *inode, struct file *file, unsigned int cmd, un
 			warncount--;
 		}
 		kfree(adgl);
+		unlock_kernel();
 		return -EINVAL;
 	}
 
@@ -837,6 +839,7 @@ static int ac_ioctl(struct inode *inode, struct file *file, unsigned int cmd, un
 		break;
 	}
 	Dummy = readb(apbs[IndexCard].RamIO + VERS);
+	unlock_kernel();
 	kfree(adgl);
 	return 0;
 }
