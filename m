Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbYJILXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbYJILXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 07:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756585AbYJILW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 07:22:58 -0400
Received: from smtpauth.net4india.com ([202.71.129.41]:50352 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123AbYJILW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 07:22:58 -0400
From: David John <davidjon@xenontk.org>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, vojtech@suse.cz, bob.picco@hp.com
Subject: [PATCH] HPET: Remove the BKL.
Date: Thu,  9 Oct 2008 16:52:51 +0530
Message-Id: <1223551371-3764-1-git-send-email-davidjon@xenontk.org>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Concurrent access is protected by the spin lock hpet_lock. The
BKL is not required.

Signed-off-by: David John <davidjon@xenontk.org>
---
 drivers/char/hpet.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index b3f5dbc..0237eeb 100644
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
@@ -586,7 +583,7 @@ static const struct file_operations hpet_fops = {
 	.llseek = no_llseek,
 	.read = hpet_read,
 	.poll = hpet_poll,
-	.ioctl = hpet_ioctl,
+	.unlocked_ioctl = hpet_ioctl,
 	.open = hpet_open,
 	.release = hpet_release,
 	.fasync = hpet_fasync,
