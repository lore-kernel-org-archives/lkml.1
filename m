Return-Path: <linux-kernel-owner+w=401wt.eu-S933647AbZJOIss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647AbZJOIss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757875AbZJOIsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:48:47 -0400
Received: from www.tglx.de ([62.245.132.106]:34187 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467AbZJOIsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:48:47 -0400
Message-Id: <20091015083933.942440598@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 15 Oct 2009 08:42:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>,
       ALan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Dike <jdike@addtoit.com>
Subject: [patch 5/7] um: Convert hostaudio to unlocked ioctl
References: <20091015083906.716130653@linutronix.de>
Content-Disposition: inline;
	filename=um-convert-hostaudio-to-unlocked-ioctl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hostaudio ioctls can be converted to unlocked ioctls for the
following reasons:

  - get/put_user do not require the BKL
  - os_ioctl_generic() passes the ioctl to the host and does not
    need serialization.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeff Dike <jdike@addtoit.com>
---
 arch/um/drivers/hostaudio_kern.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6-tip/arch/um/drivers/hostaudio_kern.c
===================================================================
--- linux-2.6-tip.orig/arch/um/drivers/hostaudio_kern.c
+++ linux-2.6-tip/arch/um/drivers/hostaudio_kern.c
@@ -136,8 +136,8 @@ static unsigned int hostaudio_poll(struc
 	return mask;
 }
 
-static int hostaudio_ioctl(struct inode *inode, struct file *file,
-			   unsigned int cmd, unsigned long arg)
+static long hostaudio_ioctl(struct file *file, unsigned int cmd,
+			    unsigned long arg)
 {
 	struct hostaudio_state *state = file->private_data;
 	unsigned long data = 0;
@@ -223,8 +223,8 @@ static int hostaudio_release(struct inod
 
 /* /dev/mixer file operations */
 
-static int hostmixer_ioctl_mixdev(struct inode *inode, struct file *file,
-				  unsigned int cmd, unsigned long arg)
+static long hostmixer_ioctl_mixdev(struct file *file, unsigned int cmd,
+				   unsigned long arg)
 {
 	struct hostmixer_state *state = file->private_data;
 
@@ -289,7 +289,7 @@ static const struct file_operations host
 	.read           = hostaudio_read,
 	.write          = hostaudio_write,
 	.poll           = hostaudio_poll,
-	.ioctl          = hostaudio_ioctl,
+	.unlocked_ioctl = hostaudio_ioctl,
 	.mmap           = NULL,
 	.open           = hostaudio_open,
 	.release        = hostaudio_release,
@@ -298,7 +298,7 @@ static const struct file_operations host
 static const struct file_operations hostmixer_fops = {
 	.owner          = THIS_MODULE,
 	.llseek         = no_llseek,
-	.ioctl          = hostmixer_ioctl_mixdev,
+	.unlocked_ioctl = hostmixer_ioctl_mixdev,
 	.open           = hostmixer_open_mixdev,
 	.release        = hostmixer_release,
 };


