Return-Path: <linux-kernel-owner+w=401wt.eu-S1757234AbZJSSVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbZJSSVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 14:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbZJSSVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 14:21:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754990AbZJSSU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 14:20:59 -0400
Date: Mon, 19 Oct 2009 20:20:30 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Arnd Bergmann <arndbergmann@googlemail.com>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open
In-Reply-To: <200910190619.48037.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.0910192019420.3563@localhost.localdomain>
References: <alpine.LFD.2.00.0910182353480.3405@localhost.localdomain> <200910190619.48037.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 Oct 2009, Arnd Bergmann wrote:

> On Sunday 18 October 2009, John Kacur wrote:
> > The BKL is in this function because of the BKL pushdown
> > (see commit f8f2c79d594463427f7114cedb1555110d547d89)
> > 
> > It is not needed here because the mutex_lock sonypi_device.lock
> > provides the necessary locking.
> 
> The driver still uses the BKL in the ioctl function, which can
> probably be removed at the same time.
> 
> 	Arnd <><
> 

How does this look? (Version 2 of the patch follows)

>From efd07cfcd021b4438d83d383ab81f9b35cb41eb9 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Sun, 18 Oct 2009 23:49:49 +0200
Subject: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open

The BKL is in this function because of the BKL pushdown
(see commit f8f2c79d594463427f7114cedb1555110d547d89)

It is not needed here because the mutex_lock sonypi_device.lock
provides the necessary locking.

sonpi_misc_ioctl can be converted to unlocked ioctls since it relies on
its own locking (the mutex sonypi_device.lock) and not the bkl

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/char/sonypi.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index 8c262aa..593cbb5 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -50,7 +50,6 @@
 #include <linux/err.h>
 #include <linux/kfifo.h>
 #include <linux/platform_device.h>
-#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -902,14 +901,13 @@ static int sonypi_misc_release(struct inode *inode, struct file *file)
 
 static int sonypi_misc_open(struct inode *inode, struct file *file)
 {
-	lock_kernel();
 	mutex_lock(&sonypi_device.lock);
 	/* Flush input queue on first open */
 	if (!sonypi_device.open_count)
 		kfifo_reset(sonypi_device.fifo);
 	sonypi_device.open_count++;
 	mutex_unlock(&sonypi_device.lock);
-	unlock_kernel();
+
 	return 0;
 }
 
@@ -951,10 +949,10 @@ static unsigned int sonypi_misc_poll(struct file *file, poll_table *wait)
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
@@ -1070,7 +1068,7 @@ static const struct file_operations sonypi_misc_fops = {
 	.open		= sonypi_misc_open,
 	.release	= sonypi_misc_release,
 	.fasync		= sonypi_misc_fasync,
-	.ioctl		= sonypi_misc_ioctl,
+	.unlocked_ioctl	= sonypi_misc_ioctl,
 };
 
 static struct miscdevice sonypi_misc_device = {
-- 
1.6.0.6


