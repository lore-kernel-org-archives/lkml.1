Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924Ab0ADTi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab0ADTi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 14:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740Ab0ADTi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 14:38:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587Ab0ADTi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 14:38:27 -0500
Date: Mon, 4 Jan 2010 20:37:58 +0100 (CET)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH: resend] sony_pi: Remove the BKL from open and ioctl 
Message-ID: <alpine.LFD.2.00.1001042019450.6613@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus please consider the following patch for 2.6.33
It was sent to the list in October and folks like Arnd, Thomas and Alan 
were all cced - it went through a round of discussion too. (and was 
acked by Arnd) If it is too late for such patches, that's fine too.
I'll just queue them all up for 2.6.34

Also, I've regenerated the below patch against your current git repo.

Thanks.

>From ac2c28aea6c1d06579c920ab77ed0b97d1b02c89 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Sun, 18 Oct 2009 23:49:49 +0200
Subject: [PATCH] sony_pi: Remove the BKL from open and ioctl

The BKL is in this function because of the BKL pushdown
(see commit f8f2c79d594463427f7114cedb1555110d547d89)

It is not needed here because the mutex_lock sonypi_device.lock
provides the necessary locking.

sonypi_misc_ioctl can be converted to unlocked ioctls since it relies on
its own locking (the mutex sonypi_device.lock) and not the bkl

Document that llseek is not needed by explictly setting it to no_llseek

LKML-Reference: <alpine.LFD.2.00.0910192019420.3563@localhost.localdomain>
Signed-off-by: John Kacur <jkacur@redhat.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/sonypi.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index 0798754..bba727c 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -50,7 +50,6 @@
 #include <linux/err.h>
 #include <linux/kfifo.h>
 #include <linux/platform_device.h>
-#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -905,14 +904,13 @@ static int sonypi_misc_release(struct inode *inode, struct file *file)
 
 static int sonypi_misc_open(struct inode *inode, struct file *file)
 {
-	lock_kernel();
 	mutex_lock(&sonypi_device.lock);
 	/* Flush input queue on first open */
 	if (!sonypi_device.open_count)
 		kfifo_reset(&sonypi_device.fifo);
 	sonypi_device.open_count++;
 	mutex_unlock(&sonypi_device.lock);
-	unlock_kernel();
+
 	return 0;
 }
 
@@ -955,10 +953,10 @@ static unsigned int sonypi_misc_poll(struct file *file, poll_table *wait)
 	return 0;
 }
 
-static int sonypi_misc_ioctl(struct inode *ip, struct file *fp,
+static long sonypi_misc_ioctl(struct file *fp,
 			     unsigned int cmd, unsigned long arg)
 {
-	int ret = 0;
+	long ret = 0;
 	void __user *argp = (void __user *)arg;
 	u8 val8;
 	u16 val16;
@@ -1074,7 +1072,8 @@ static const struct file_operations sonypi_misc_fops = {
 	.open		= sonypi_misc_open,
 	.release	= sonypi_misc_release,
 	.fasync		= sonypi_misc_fasync,
-	.ioctl		= sonypi_misc_ioctl,
+	.unlocked_ioctl	= sonypi_misc_ioctl,
+	.llseek		= no_llseek,
 };
 
 static struct miscdevice sonypi_misc_device = {
-- 
1.6.0.6

