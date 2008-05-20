Return-Path: <linux-kernel-owner+w=401wt.eu-S1765107AbYETKwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765107AbYETKwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 06:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763929AbYETKv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 06:51:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:14091 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763730AbYETKv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 06:51:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=KYMiN46xgrVqu242s/ENFPWWFwbQoeXInP/RA/ZMws/DdMVbxGvH5AFK3WZKYJLF2RI/78n8nxILnaCfpIbL+UhaD73cycdWDp1yw69LTthMl3ryDSDKtymEAhy1WpGsaTzt5CzOY2AKFiOhPeIHfQj0H1/AR65iWZ3X9d913Ow=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
       lethal@linux-sh.org, hjk@linutronix.de, gregkh@suse.de
Date: Tue, 20 May 2008 19:51:40 +0900
Message-Id: <20080520105140.1474.59715.sendpatchset@rx1.opensource.se>
In-Reply-To: <20080520105132.1474.73941.sendpatchset@rx1.opensource.se>
References: <20080520105132.1474.73941.sendpatchset@rx1.opensource.se>
Subject: [PATCH 01/03] uio: Add enable_irq() callback
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add enable_irq() callback to struct uio_info. This callback is needed by
the uio_platform driver so interrupts can be enabled before blocking.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/uio/uio.c          |    6 ++++++
 include/linux/uio_driver.h |    1 +
 2 files changed, 7 insertions(+)

--- 0001/drivers/uio/uio.c
+++ work/drivers/uio/uio.c	2008-05-19 14:52:08.000000000 +0900
@@ -365,6 +365,9 @@ static unsigned int uio_poll(struct file
 	if (idev->info->irq == UIO_IRQ_NONE)
 		return -EIO;
 
+	if (idev->info->enable_irq)
+		idev->info->enable_irq(idev->info);
+
 	poll_wait(filep, &idev->wait, wait);
 	if (listener->event_count != atomic_read(&idev->event))
 		return POLLIN | POLLRDNORM;
@@ -391,6 +394,9 @@ static ssize_t uio_read(struct file *fil
 	do {
 		set_current_state(TASK_INTERRUPTIBLE);
 
+		if (idev->info->enable_irq)
+			idev->info->enable_irq(idev->info);
+
 		event_count = atomic_read(&idev->event);
 		if (event_count != listener->event_count) {
 			if (copy_to_user(buf, &event_count, count))
--- 0001/include/linux/uio_driver.h
+++ work/include/linux/uio_driver.h	2008-05-19 14:52:08.000000000 +0900
@@ -64,6 +64,7 @@ struct uio_info {
 	void			*priv;
 	irqreturn_t (*handler)(int irq, struct uio_info *dev_info);
 	int (*mmap)(struct uio_info *info, struct vm_area_struct *vma);
+	void (*enable_irq)(struct uio_info *info);
 	int (*open)(struct uio_info *info, struct inode *inode);
 	int (*release)(struct uio_info *info, struct inode *inode);
 };
