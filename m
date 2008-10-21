Return-Path: <linux-kernel-owner+w=401wt.eu-S1752871AbYJUF66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbYJUF66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 01:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYJUF6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 01:58:50 -0400
Received: from smtpauth.net4india.com ([202.71.129.41]:41829 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbYJUF6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 01:58:49 -0400
From: David John <davidjon@xenontk.org>
To: mingo@elte.hu
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       tglx@linutronix.de, andi@firstfloor.org
Subject: [PATCH v5] HPET: Remove the BKL.
Date: Tue, 21 Oct 2008 11:28:27 +0530
Message-Id: <1224568707-2361-1-git-send-email-davidjon@xenontk.org>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove calls to the BKL as concurrent access is protected
by the spinlock hpet_lock.

Signed-off-by: David John <davidjon@xenontk.org>
---
 drivers/char/hpet.c |   41 ++++++++++++++++++++++++-----------------
 1 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index b3f5dbc..ba40096 100644
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
 
@@ -414,7 +407,6 @@ static int hpet_ioctl_ieon(struct hpet_dev *devp)
 
 	if (readl(&timer->hpet_config) & Tn_INT_TYPE_CNF_MASK)
 		devp->hd_flags |= HPET_SHARED_IRQ;
-	spin_unlock_irq(&hpet_lock);
 
 	irq = devp->hd_hdwirq;
 
@@ -432,7 +424,6 @@ static int hpet_ioctl_ieon(struct hpet_dev *devp)
 	}
 
 	if (irq == 0) {
-		spin_lock_irq(&hpet_lock);
 		devp->hd_flags ^= HPET_IE;
 		spin_unlock_irq(&hpet_lock);
 		return -EIO;
@@ -463,7 +454,9 @@ static int hpet_ioctl_ieon(struct hpet_dev *devp)
 		isr = 1 << (devp - devp->hd_hpets->hp_dev);
 		writel(isr, &hpet->hpet_isr);
 	}
+
 	writeq(g, &timer->hpet_config);
+	spin_unlock_irq(&hpet_lock);
 	local_irq_restore(flags);
 
 	return 0;
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
@@ -509,8 +502,11 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 
 	switch (cmd) {
 	case HPET_IE_OFF:
-		if ((devp->hd_flags & HPET_IE) == 0)
+		spin_lock_irq(&hpet_lock);
+		if ((devp->hd_flags & HPET_IE) == 0) {
+			spin_unlock_irq(&hpet_lock);
 			break;
+		}
 		v = readq(&timer->hpet_config);
 		v &= ~Tn_INT_ENB_CNF_MASK;
 		writeq(v, &timer->hpet_config);
@@ -519,11 +515,13 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 			devp->hd_irq = 0;
 		}
 		devp->hd_flags ^= HPET_IE;
+		spin_unlock_irq(&hpet_lock);
 		break;
 	case HPET_INFO:
 		{
 			struct hpet_info info;
 
+			spin_lock_irq(&hpet_lock);
 			if (devp->hd_ireqfreq)
 				info.hi_ireqfreq =
 					hpet_time_div(hpetp, devp->hd_ireqfreq);
@@ -533,6 +531,7 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 			    readq(&timer->hpet_config) & Tn_PER_INT_CAP_MASK;
 			info.hi_hpet = hpetp->hp_which;
 			info.hi_timer = devp - hpetp->hp_dev;
+			spin_unlock_irq(&hpet_lock);
 			if (kernel)
 				memcpy((void *)arg, &info, sizeof(info));
 			else
@@ -542,16 +541,21 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 			break;
 		}
 	case HPET_EPI:
+		spin_lock_irq(&hpet_lock);
 		v = readq(&timer->hpet_config);
 		if ((v & Tn_PER_INT_CAP_MASK) == 0) {
+			spin_unlock_irq(&hpet_lock);
 			err = -ENXIO;
 			break;
 		}
 		devp->hd_flags |= HPET_PERIODIC;
+		spin_unlock_irq(&hpet_lock);
 		break;
 	case HPET_DPI:
+		spin_lock_irq(&hpet_lock);
 		v = readq(&timer->hpet_config);
 		if ((v & Tn_PER_INT_CAP_MASK) == 0) {
+			spin_unlock_irq(&hpet_lock);
 			err = -ENXIO;
 			break;
 		}
@@ -562,6 +566,7 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 			writeq(v, &timer->hpet_config);
 		}
 		devp->hd_flags &= ~HPET_PERIODIC;
+		spin_unlock_irq(&hpet_lock);
 		break;
 	case HPET_IRQFREQ:
 		if (!kernel && (arg > hpet_max_freq) &&
@@ -575,7 +580,9 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 			break;
 		}
 
+		spin_lock_irq(&hpet_lock);
 		devp->hd_ireqfreq = hpet_time_div(hpetp, arg);
+		spin_unlock_irq(&hpet_lock);
 	}
 
 	return err;
@@ -586,7 +593,7 @@ static const struct file_operations hpet_fops = {
 	.llseek = no_llseek,
 	.read = hpet_read,
 	.poll = hpet_poll,
-	.ioctl = hpet_ioctl,
+	.unlocked_ioctl = hpet_ioctl,
 	.open = hpet_open,
 	.release = hpet_release,
 	.fasync = hpet_fasync,
