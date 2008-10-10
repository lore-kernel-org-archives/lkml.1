Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbYJJIA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbYJJIA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 04:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYJJIAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 04:00:49 -0400
Received: from smtpauth.net4india.com ([202.71.129.41]:50729 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbYJJIAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 04:00:49 -0400
From: David John <davidjon@xenontk.org>
To: venkatesh.pallipadi@intel.com
Cc: clemens@ladisch.de, vojtech@suse.cz, bob.picco@hp.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org
Subject: [PATCH] HPET: Remove the BKL.
Date: Fri, 10 Oct 2008 13:30:42 +0530
Message-Id: <1223625642-17610-1-git-send-email-davidjon@xenontk.org>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you review/check this patch? Compile tested only as I
don't have a machine with HPET.

CC'd: LKML.
---
From: David John <davidjon@xenontk.org>

Concurrent access is protected by the spin lock hpet_lock. The BKL
is not required.

Signed-off-by: David John <davidjon@xenontk.org>
---
 drivers/char/hpet.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index b3f5dbc..3393566 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -194,7 +194,6 @@ static int hpet_open(struct inode *inode, struct file *file)
 	if (file->f_mode & FMODE_WRITE)
 		return -EINVAL;
 
-	lock_kernel();
 	spin_lock_irq(&hpet_lock);
 
 	for (devp = NULL, hpetp = hpets; hpetp && !devp; hpetp = hpetp->hp_next)
@@ -209,7 +208,6 @@ static int hpet_open(struct inode *inode, struct file *file)
 
 	if (!devp) {
 		spin_unlock_irq(&hpet_lock);
-		unlock_kernel();
 		return -EBUSY;
 	}
 
@@ -217,7 +215,6 @@ static int hpet_open(struct inode *inode, struct file *file)
 	devp->hd_irqdata = 0;
 	devp->hd_flags |= HPET_OPEN;
 	spin_unlock_irq(&hpet_lock);
-	unlock_kernel();
 
 	return 0;
 }
@@ -375,15 +372,12 @@ static int hpet_release(struct inode *inode, struct file *file)
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
 
@@ -480,13 +474,13 @@ static inline unsigned long hpet_time_div(struct hpets *hpets,
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
@@ -518,7 +512,9 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 			free_irq(devp->hd_irq, devp);
 			devp->hd_irq = 0;
 		}
+		spin_lock_irq(&hpet_lock);
 		devp->hd_flags ^= HPET_IE;
+		spin_unlock_irq(&hpet_lock);
 		break;
 	case HPET_INFO:
 		{
@@ -547,7 +543,9 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 			err = -ENXIO;
 			break;
 		}
+		spin_lock_irq(&hpet_lock);
 		devp->hd_flags |= HPET_PERIODIC;
+		spin_unlock_irq(&hpet_lock);
 		break;
 	case HPET_DPI:
 		v = readq(&timer->hpet_config);
@@ -561,7 +559,9 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 			v ^= Tn_TYPE_CNF_MASK;
 			writeq(v, &timer->hpet_config);
 		}
+		spin_lock_irq(&hpet_lock);
 		devp->hd_flags &= ~HPET_PERIODIC;
+		spin_unlock_irq(&hpet_lock);
 		break;
 	case HPET_IRQFREQ:
 		if (!kernel && (arg > hpet_max_freq) &&
@@ -586,7 +586,7 @@ static const struct file_operations hpet_fops = {
 	.llseek = no_llseek,
 	.read = hpet_read,
 	.poll = hpet_poll,
-	.ioctl = hpet_ioctl,
+	.unlocked_ioctl = hpet_ioctl,
 	.open = hpet_open,
 	.release = hpet_release,
 	.fasync = hpet_fasync,
