Return-Path: <linux-kernel-owner+w=401wt.eu-S1761437AbYEVU6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761437AbYEVU6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbYEVU6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:58:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37370 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754631AbYEVU6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:58:41 -0400
Date: Thu, 22 May 2008 21:46:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] rio: Push down the BKL into the firmware ioctl handler
Message-ID: <20080522214610.1f8ba9da@core>
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

TTY side is already done.

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/rio/rio_linux.c b/drivers/char/rio/rio_linux.c
index 6a828c2..c92bfeb 100644
--- a/drivers/char/rio/rio_linux.c
+++ b/drivers/char/rio/rio_linux.c
@@ -184,7 +184,7 @@ static int rio_set_real_termios(void *ptr);
 static void rio_hungup(void *ptr);
 static void rio_close(void *ptr);
 static int rio_chars_in_buffer(void *ptr);
-static int rio_fw_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg);
+static long rio_fw_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 static int rio_init_drivers(void);
 
 static void my_hd(void *addr, int len);
@@ -245,7 +245,7 @@ static struct real_driver rio_real_driver = {
 
 static const struct file_operations rio_fw_fops = {
 	.owner = THIS_MODULE,
-	.ioctl = rio_fw_ioctl,
+	.unlocked_ioctl = rio_fw_ioctl,
 };
 
 static struct miscdevice rio_fw_device = {
@@ -565,13 +565,15 @@ static void rio_close(void *ptr)
 
 
 
-static int rio_fw_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
+static long rio_fw_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	int rc = 0;
 	func_enter();
 
 	/* The "dev" argument isn't used. */
+	lock_kernel();
 	rc = riocontrol(p, 0, cmd, arg, capable(CAP_SYS_ADMIN));
+	unlock_kernel();
 
 	func_exit();
 	return rc;
