Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbZJULoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbZJULoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 07:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbZJULoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 07:44:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbZJULoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 07:44:07 -0400
Date: Wed, 21 Oct 2009 13:43:38 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Clemens Ladisch <clemens@ladisch.de>
Subject: hpet: Convert to unlocked_ioctl
In-Reply-To: <alpine.LFD.2.00.0910182210220.3462@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0910211340540.3526@localhost.localdomain>
References: <alpine.LFD.2.00.0910182210220.3462@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch converts the hpet_ioctl to the unlocked version. It is meant to 
be applied after the patch that removed the BKL from the hpet_open 
function.

Note that .llseek is already explicitly set to no_llseek.

>From 84e9964c4c7eeb4e99bb51e3a10768c1f869f259 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Wed, 21 Oct 2009 13:34:42 +0200
Subject: [PATCH] hpet: Convert to unlocked_ioctl

The ioctl functions here rely on their own locking using the hpet_lock spinlock.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/char/hpet.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 5e83828..e7754cd 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -426,11 +426,9 @@ static int hpet_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int hpet_ioctl_common(struct hpet_dev *, int, unsigned long, int);
+static long hpet_ioctl_common(struct hpet_dev *, int, unsigned long, int);
 
-static int
-hpet_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	   unsigned long arg)
+static long hpet_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct hpet_dev *devp;
 
@@ -438,7 +436,7 @@ hpet_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	return hpet_ioctl_common(devp, cmd, arg, 0);
 }
 
-static int hpet_ioctl_ieon(struct hpet_dev *devp)
+static long hpet_ioctl_ieon(struct hpet_dev *devp)
 {
 	struct hpet_timer __iomem *timer;
 	struct hpet __iomem *hpet;
@@ -545,13 +543,13 @@ static inline unsigned long hpet_time_div(struct hpets *hpets,
 	return (unsigned long)m;
 }
 
-static int
+static long
 hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 {
 	struct hpet_timer __iomem *timer;
 	struct hpet __iomem *hpet;
 	struct hpets *hpetp;
-	int err;
+	long err = 0;
 	unsigned long v;
 
 	switch (cmd) {
@@ -570,8 +568,6 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 		return -EINVAL;
 	}
 
-	err = 0;
-
 	switch (cmd) {
 	case HPET_IE_OFF:
 		if ((devp->hd_flags & HPET_IE) == 0)
@@ -651,7 +647,7 @@ static const struct file_operations hpet_fops = {
 	.llseek = no_llseek,
 	.read = hpet_read,
 	.poll = hpet_poll,
-	.ioctl = hpet_ioctl,
+	.unlocked_ioctl = hpet_ioctl,
 	.open = hpet_open,
 	.release = hpet_release,
 	.fasync = hpet_fasync,
-- 
1.6.0.6


