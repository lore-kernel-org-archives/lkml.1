Return-Path: <linux-kernel-owner+w=401wt.eu-S1763597AbYEVVS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763597AbYEVVS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758024AbYEVVRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:17:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35135 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762922AbYEVVRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:17:16 -0400
Date: Thu, 22 May 2008 22:04:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ftdi_usb: Eliminate ioctl and BKL ioctl use
Message-ID: <20080522220448.7d77a7db@core>
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

ftdi has one ioctl, which is buggy and for debugging. Kill it off

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index ec88b3b..97c2809 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -656,29 +656,6 @@ static int ftdi_elan_release(struct inode *inode, struct file *file)
 }
 
 
-#define FTDI_ELAN_IOC_MAGIC 0xA1
-#define FTDI_ELAN_IOCDEBUG _IOC(_IOC_WRITE, FTDI_ELAN_IOC_MAGIC, 1, 132)
-static int ftdi_elan_ioctl(struct inode *inode, struct file *file,
-        unsigned int cmd, unsigned long arg)
-{
-        switch (cmd) {
-        case FTDI_ELAN_IOCDEBUG:{
-                        char line[132];
-                        int size = strncpy_from_user(line,
-                                (const char __user *)arg, sizeof(line));
-                        if (size < 0) {
-                                return -EINVAL;
-                        } else {
-                                printk(KERN_ERR "TODO: ioctl %s\n", line);
-                                return 0;
-                        }
-                }
-        default:
-                return -EFAULT;
-        }
-}
-
-
 /*
 *
 * blocking bulk reads are used to get data from the device
@@ -1222,7 +1199,6 @@ error_1:
 static const struct file_operations ftdi_elan_fops = {
         .owner = THIS_MODULE,
         .llseek = no_llseek,
-        .ioctl = ftdi_elan_ioctl,
         .read = ftdi_elan_read,
         .write = ftdi_elan_write,
         .open = ftdi_elan_open,
