Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbZIOTQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbZIOTQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758605AbZIOTQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:16:55 -0400
Received: from kroah.org ([198.145.64.141]:33077 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758539AbZIOTPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:15:07 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Altobelli <david.altobelli@hp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 14/20] hpilo: add poll f_op
Date: Tue, 15 Sep 2009 12:12:50 -0700
Message-Id: <1253041976-1111-14-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090915181247.GA32167@kroah.com>
References: <20090915181247.GA32167@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Altobelli <david.altobelli@hp.com>

Add poll handler to hpilo, to allow applications a low overhead method
of waiting for data.

Signed-off-by: David Altobelli <david.altobelli@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/hpilo.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index 9a370d5..1ad27c6 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -23,6 +23,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/wait.h>
+#include <linux/poll.h>
 #include "hpilo.h"
 
 static struct class *ilo_class;
@@ -102,6 +103,22 @@ static int fifo_dequeue(struct ilo_hwinfo *hw, char *fifobar, int *entry)
 	return ret;
 }
 
+static int fifo_check_recv(struct ilo_hwinfo *hw, char *fifobar)
+{
+	struct fifo *fifo_q = FIFOBARTOHANDLE(fifobar);
+	unsigned long flags;
+	int ret = 0;
+	u64 c;
+
+	spin_lock_irqsave(&hw->fifo_lock, flags);
+	c = fifo_q->fifobar[fifo_q->head & fifo_q->imask];
+	if (c & ENTRY_MASK_C)
+		ret = 1;
+	spin_unlock_irqrestore(&hw->fifo_lock, flags);
+
+	return ret;
+}
+
 static int ilo_pkt_enqueue(struct ilo_hwinfo *hw, struct ccb *ccb,
 			   int dir, int id, int len)
 {
@@ -146,6 +163,13 @@ static int ilo_pkt_dequeue(struct ilo_hwinfo *hw, struct ccb *ccb,
 	return ret;
 }
 
+static int ilo_pkt_recv(struct ilo_hwinfo *hw, struct ccb *ccb)
+{
+	char *fifobar = ccb->ccb_u3.recv_fifobar;
+
+	return fifo_check_recv(hw, fifobar);
+}
+
 static inline void doorbell_set(struct ccb *ccb)
 {
 	iowrite8(1, ccb->ccb_u5.db_base);
@@ -486,6 +510,21 @@ static ssize_t ilo_write(struct file *fp, const char __user *buf,
 	return err ? -EFAULT : len;
 }
 
+static unsigned int ilo_poll(struct file *fp, poll_table *wait)
+{
+	struct ccb_data *data = fp->private_data;
+	struct ccb *driver_ccb = &data->driver_ccb;
+
+	poll_wait(fp, &data->ccb_waitq, wait);
+
+	if (is_channel_reset(driver_ccb))
+		return POLLERR;
+	else if (ilo_pkt_recv(data->ilo_hw, driver_ccb))
+		return POLLIN | POLLRDNORM;
+
+	return 0;
+}
+
 static int ilo_close(struct inode *ip, struct file *fp)
 {
 	int slot;
@@ -595,6 +634,7 @@ static const struct file_operations ilo_fops = {
 	.owner		= THIS_MODULE,
 	.read		= ilo_read,
 	.write		= ilo_write,
+	.poll		= ilo_poll,
 	.open 		= ilo_open,
 	.release 	= ilo_close,
 };
@@ -835,7 +875,7 @@ static void __exit ilo_exit(void)
 	class_destroy(ilo_class);
 }
 
-MODULE_VERSION("1.1");
+MODULE_VERSION("1.2");
 MODULE_ALIAS(ILO_NAME);
 MODULE_DESCRIPTION(ILO_NAME);
 MODULE_AUTHOR("David Altobelli <david.altobelli@hp.com>");
-- 
1.6.4.2

