Return-Path: <linux-kernel-owner+w=401wt.eu-S1753332AbZJUK2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbZJUK2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 06:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbZJUK2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 06:28:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbZJUK2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 06:28:06 -0400
Date: Wed, 21 Oct 2009 12:27:42 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Arnd Bergmann <arndbergmann@googlemail.com>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mattia Dongili <malattia@linux.it>
Subject: Re: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open
In-Reply-To: <200910211029.21702.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.0910211226180.3526@localhost.localdomain>
References: <alpine.LFD.2.00.0910182353480.3405@localhost.localdomain> <200910200008.57468.arnd@arndb.de> <alpine.LFD.2.00.0910210157170.8674@localhost.localdomain> <200910211029.21702.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 Oct 2009, Arnd Bergmann wrote:

> On Wednesday 21 October 2009, John Kacur wrote:
> > From 11e6a3b690413c3926e6db1c53a53410b5214c3d Mon Sep 17 00:00:00 2001
> > From: John Kacur <jkacur@redhat.com>
> > Date: Wed, 21 Oct 2009 01:51:41 +0200
> > Subject: [PATCH] sonypi: Use non-BKL version of llseek.
> > 
> > The default version of llseek uses the BKL.
> > We have removed the use of the BKL in open and the ioctl.
> > Now lets remove the last use of the BKL by explictly calling the
> > generic unlocked llseek, under the sonypi_device.lock mutex
> > 
> > Signed-off-by: John Kacur <jkacur@redhat.com>
> 
> Well, for this specific case, the driver does not actually need to seek,
> because the read function never looks at the position and there is no
> write function. For annotation purposes, IMHO we should have a simple
> '.llseek = no_llseek' in there.
> 
> In other files, the best solution may be to just point to generic_file_llseek
> and make sure we hold the i_mutex when accessing the file->f_pos explicitly.
> 
> Interestingly, atomicity of updates to f_pos is currently maintained through
> file_pos_write(), which does not hold any lock but assumes that a store to
> an loff_t is atomic. It is not atomic in general, so concurrent lseek and
> read/write operations seem to have undefined behaviour no matter what kind
> of locking we have in the llseek function.

Thanks again Arnd for all the information you provide!

Here is the 3rd and hopefully final version of the patch. It is simple
the version that you acked, plus .llseek		= no_llseek,

>From 96872f13a510db69fbb32f9e956615cd826f8986 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Sun, 18 Oct 2009 23:49:49 +0200
Subject: [PATCH] sony_pi: Remove the BKL from open and ioctl

The BKL is in this function because of the BKL pushdown
(see commit f8f2c79d594463427f7114cedb1555110d547d89)

It is not needed here because the mutex_lock sonypi_device.lock
provides the necessary locking.

sonpi_misc_ioctl can be converted to unlocked ioctls since it relies on
its own locking (the mutex sonypi_device.lock) and not the bkl

Document that llseek is not needed by explictly setting it to no_llseek

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/char/sonypi.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index 8c262aa..3f68be3 100644
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
@@ -1070,7 +1068,8 @@ static const struct file_operations sonypi_misc_fops = {
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

