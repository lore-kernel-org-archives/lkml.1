Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYJQF2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYJQF2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 01:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbYJQF2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 01:28:15 -0400
Received: from smtpauth.net4india.com ([202.71.129.41]:54612 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbYJQF2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 01:28:14 -0400
X-Greylist: delayed 814 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2008 01:28:14 EDT
From: David John <davidjon@xenontk.org>
To: mingo@elte.hu
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       tglx@linutronix.de, andi@firstfloor.org, mm-commits@vger.kernel.org
Subject: [PATCH v3] HPET: Remove the BKL.
Date: Fri, 17 Oct 2008 10:58:04 +0530
Message-Id: <1224221284-2381-1-git-send-email-davidjon@xenontk.org>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove calls to the BKL as concurrent access is protected by
the spinlock hpet_lock.

Signed-off-by: David John <davidjon@xenontk.org>
---
 drivers/char/hpet.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index b3f5dbc..6c14e6a 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -14,7 +14,6 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
 #include <linux/major.h>
@@ -194,7 +193,6 @@ static int hpet_open(struct inode *inode, struct file *file)
 	if (file->f_mode & FMODE_WRITE)
 		return -EINVAL;
 
-	lock_kernel();
 	spin_lock_irq(&hpet_lock);
 
 	for (devp = NULL, hpetp = hpets; hpetp && !devp; hpetp = hpetp->hp_next)
@@ -209,7 +207,6 @@ static int hpet_open(struct inode *inode, struct file *file)
 
 	if (!devp) {
 		spin_unlock_irq(&hpet_lock);
-		unlock_kernel();
 		return -EBUSY;
 	}
 
@@ -217,7 +214,6 @@ static int hpet_open(struct inode *inode, struct file *file)
 	devp->hd_irqdata = 0;
 	devp->hd_flags |= HPET_OPEN;
 	spin_unlock_irq(&hpet_lock);
-	unlock_kernel();
 
 	return 0;
 }
@@ -375,15 +371,12 @@ static int hpet_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int hpet_ioctl_common(struct hpet_dev *, int, unsigned long, int);
+static long hpet_ioctl_common(struct hpet_dev *, int, unsigned long, int);
 
-static int
-hpet_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	   unsigned long arg)
+static long
+hpet_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct hpet_dev *devp;
-
-	devp = file->private_data;
+	struct hpet_dev *devp = file->private_data;
 	return hpet_ioctl_common(devp, cmd, arg, 0);
 }
 
@@ -480,13 +473,13 @@ static inline unsigned long hpet_time_div(struct hpets *hpets,
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
+	long err;
 	unsigned long v;
 
 	switch (cmd) {
@@ -518,7 +511,9 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 			free_irq(devp->hd_irq, devp);
 			devp->hd_irq = 0;
 		}
+		spin_lock_irq(&hpet_lock);
 		devp->hd_flags ^= HPET_IE;
+		spin_unlock_irq(&hpet_lock);
 		break;
 	case HPET_INFO:
 		{
@@ -547,7 +542,9 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 			err = -ENXIO;
 			break;
 		}
+		spin_lock_irq(&hpet_lock);
 		devp->hd_flags |= HPET_PERIODIC;
+		spin_unlock_irq(&hpet_lock);
 		break;
 	case HPET_DPI:
 		v = readq(&timer->hpet_config);
@@ -561,7 +558,9 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 			v ^= Tn_TYPE_CNF_MASK;
 			writeq(v, &timer->hpet_config);
 		}
+		spin_lock_irq(&hpet_lock);
 		devp->hd_flags &= ~HPET_PERIODIC;
+		spin_unlock_irq(&hpet_lock);
 		break;
 	case HPET_IRQFREQ:
 		if (!kernel && (arg > hpet_max_freq) &&
@@ -586,7 +585,7 @@ static const struct file_operations hpet_fops = {
 	.llseek = no_llseek,
 	.read = hpet_read,
 	.poll = hpet_poll,
-	.ioctl = hpet_ioctl,
+	.unlocked_ioctl = hpet_ioctl,
 	.open = hpet_open,
 	.release = hpet_release,
 	.fasync = hpet_fasync,
