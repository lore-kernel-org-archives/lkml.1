Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbZHJUA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbZHJUA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbZHJUA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:00:56 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:23863 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbZHJUA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:00:56 -0400
Date: Mon, 10 Aug 2009 14:00:56 -0600
From: David Altobelli <david.altobelli@hp.com>
To: David Altobelli <david.altobelli@hp.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: [PATCH 3/3] hpilo: add poll f_op
Message-ID: <20090810200056.GC29404@ldl.fc.hp.com>
References: <20090810195735.GA29372@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810195735.GA29372@ldl.fc.hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add poll handler to hpilo, to allow applications a low overhead method 
of waiting for data.

Please CC me on any replies.

Signed-off-by: David Altobelli <david.altobelli@hp.com>
---
 hpilo.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)
--- linux-2.6.30.3/drivers/misc/hpilo.c.orig	2009-08-07 09:40:48.000000000 -0500
+++ linux-2.6.30.3/drivers/misc/hpilo.c	2009-08-07 09:41:10.000000000 -0500
@@ -23,6 +23,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/wait.h>
+#include <linux/poll.h>
 #include "hpilo.h"
 
 static struct class *ilo_class;
@@ -102,6 +103,22 @@ static int fifo_dequeue(struct ilo_hwinf
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
@@ -146,6 +163,13 @@ static int ilo_pkt_dequeue(struct ilo_hw
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
@@ -486,6 +510,21 @@ static ssize_t ilo_write(struct file *fp
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
@@ -595,6 +634,7 @@ static const struct file_operations ilo_
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
