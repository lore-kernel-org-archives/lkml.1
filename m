Return-Path: <linux-kernel-owner+w=401wt.eu-S1760983AbYEVUwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760983AbYEVUwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760383AbYEVUwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:52:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50153 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759779AbYEVUwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:52:17 -0400
Date: Thu, 22 May 2008 21:39:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: [PATCH] hpet: push BKL down into hpet driver
Message-ID: <20080522213933.3639eac4@core>
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

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index e7fb0bc..054060f 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -30,6 +30,7 @@
 #include <linux/seq_file.h>
 #include <linux/bitops.h>
 #include <linux/clocksource.h>
+#include <linux/smp_lock.h>
 
 #include <asm/current.h>
 #include <asm/uaccess.h>
@@ -371,16 +372,19 @@ static int hpet_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int hpet_ioctl_common(struct hpet_dev *, int, unsigned long, int);
+static long hpet_ioctl_common(struct hpet_dev *, int, unsigned long, int);
 
-static int
-hpet_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	   unsigned long arg)
+static long hpet_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
-	struct hpet_dev *devp;
+	struct hpet_dev *devp = file->private_data;
+	long ret;
 
-	devp = file->private_data;
-	return hpet_ioctl_common(devp, cmd, arg, 0);
+	lock_kernel();
+	ret =  hpet_ioctl_common(devp, cmd, arg, 0);
+	unlock_kernel();
+
+	return ret;
 }
 
 static int hpet_ioctl_ieon(struct hpet_dev *devp)
@@ -476,8 +480,8 @@ static inline unsigned long hpet_time_div(struct hpets *hpets,
 	return (unsigned long)m;
 }
 
-static int
-hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
+static long hpet_ioctl_common(struct hpet_dev *devp, int cmd,
+					unsigned long arg, int kernel)
 {
 	struct hpet_timer __iomem *timer;
 	struct hpet __iomem *hpet;
@@ -582,7 +586,7 @@ static const struct file_operations hpet_fops = {
 	.llseek = no_llseek,
 	.read = hpet_read,
 	.poll = hpet_poll,
-	.ioctl = hpet_ioctl,
+	.unlocked_ioctl = hpet_ioctl,
 	.open = hpet_open,
 	.release = hpet_release,
 	.fasync = hpet_fasync,
