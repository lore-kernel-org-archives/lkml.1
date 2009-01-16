Return-Path: <linux-kernel-owner+w=401wt.eu-S1763225AbZAPI3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763225AbZAPI3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761546AbZAPI1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:27:40 -0500
Received: from smtp.nokia.com ([192.100.122.233]:41526 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760815AbZAPI1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:27:35 -0500
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [PATCH 04/10] omap mailbox: fix empty struct device for omap_mbox
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org
Date: Fri, 16 Jan 2009 10:27:22 +0200
Message-ID: <20090116082722.17571.54049.stgit@oreo.research.nokia.com>
In-Reply-To: <20090116081919.17571.34378.stgit@oreo.research.nokia.com>
References: <20090116081919.17571.34378.stgit@oreo.research.nokia.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 08:27:23.0596 (UTC) FILETIME=[41A598C0:01C977B4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since "mbox->dev" doesn't exist and isn't created either at
registration, this patch will create "struct device", which belongs to
"omap-mailbox" class and set this pointer for the member of
"struct omap_mbox".

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---

 arch/arm/plat-omap/include/mach/mailbox.h |    4 +-
 arch/arm/plat-omap/mailbox.c              |   63 ++++++++++++++---------------
 2 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/arch/arm/plat-omap/include/mach/mailbox.h b/arch/arm/plat-omap/include/mach/mailbox.h
index 7cbed93..577db68 100644
--- a/arch/arm/plat-omap/include/mach/mailbox.h
+++ b/arch/arm/plat-omap/include/mach/mailbox.h
@@ -53,7 +53,7 @@ struct omap_mbox {
 
 	mbox_msg_t		seq_snd, seq_rcv;
 
-	struct device		dev;
+	struct device		*dev;
 
 	struct omap_mbox	*next;
 	void			*priv;
@@ -67,7 +67,7 @@ void omap_mbox_init_seq(struct omap_mbox *);
 struct omap_mbox *omap_mbox_get(const char *);
 void omap_mbox_put(struct omap_mbox *);
 
-int omap_mbox_register(struct omap_mbox *);
+int omap_mbox_register(struct device *parent, struct omap_mbox *);
 int omap_mbox_unregister(struct omap_mbox *);
 
 #endif /* MAILBOX_H */
diff --git a/arch/arm/plat-omap/mailbox.c b/arch/arm/plat-omap/mailbox.c
index b52ce05..5e8cd65 100644
--- a/arch/arm/plat-omap/mailbox.c
+++ b/arch/arm/plat-omap/mailbox.c
@@ -1,10 +1,9 @@
 /*
  * OMAP mailbox driver
  *
- * Copyright (C) 2006 Nokia Corporation. All rights reserved.
+ * Copyright (C) 2006-2008 Nokia Corporation. All rights reserved.
  *
- * Contact: Toshihiro Kobayashi <toshihiro.kobayashi@nokia.com>
- *		Restructured by Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
+ * Contact: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -136,7 +135,7 @@ static void mbox_rx_work(struct work_struct *work)
 	unsigned long flags;
 
 	if (mbox->rxq->callback == NULL) {
-		sysfs_notify(&mbox->dev.kobj, NULL, "mbox");
+		sysfs_notify(&mbox->dev->kobj, NULL, "mbox");
 		return;
 	}
 
@@ -204,7 +203,7 @@ static void __mbox_rx_interrupt(struct omap_mbox *mbox)
 	/* no more messages in the fifo. clear IRQ source. */
 	ack_mbox_irq(mbox, IRQ_RX);
 	enable_mbox_irq(mbox, IRQ_RX);
-	nomem:
+nomem:
 	schedule_work(&mbox->rxq->work);
 }
 
@@ -286,7 +285,7 @@ static ssize_t mbox_show(struct class *class, char *buf)
 static CLASS_ATTR(mbox, S_IRUGO, mbox_show, NULL);
 
 static struct class omap_mbox_class = {
-	.name = "omap_mbox",
+	.name = "omap-mailbox",
 };
 
 static struct omap_mbox_queue *mbox_queue_alloc(struct omap_mbox *mbox,
@@ -333,21 +332,6 @@ static int omap_mbox_init(struct omap_mbox *mbox)
 			return ret;
 	}
 
-	mbox->dev.class = &omap_mbox_class;
-	dev_set_name(&mbox->dev, "%s", mbox->name);
-	dev_set_drvdata(&mbox->dev, mbox);
-
-	ret = device_register(&mbox->dev);
-	if (unlikely(ret))
-		goto fail_device_reg;
-
-	ret = device_create_file(&mbox->dev, &dev_attr_mbox);
-	if (unlikely(ret)) {
-		printk(KERN_ERR
-			"device_create_file failed: %d\n", ret);
-		goto fail_create_mbox;
-	}
-
 	ret = request_irq(mbox->irq, mbox_interrupt, IRQF_DISABLED,
 				mbox->name, mbox);
 	if (unlikely(ret)) {
@@ -377,10 +361,6 @@ static int omap_mbox_init(struct omap_mbox *mbox)
  fail_alloc_txq:
 	free_irq(mbox->irq, mbox);
  fail_request_irq:
-	device_remove_file(&mbox->dev, &dev_attr_mbox);
- fail_create_mbox:
-	device_unregister(&mbox->dev);
- fail_device_reg:
 	if (unlikely(mbox->ops->shutdown))
 		mbox->ops->shutdown(mbox);
 
@@ -393,8 +373,6 @@ static void omap_mbox_fini(struct omap_mbox *mbox)
 	mbox_queue_free(mbox->rxq);
 
 	free_irq(mbox->irq, mbox);
-	device_remove_file(&mbox->dev, &dev_attr_mbox);
-	class_unregister(&omap_mbox_class);
 
 	if (unlikely(mbox->ops->shutdown))
 		mbox->ops->shutdown(mbox);
@@ -440,7 +418,7 @@ void omap_mbox_put(struct omap_mbox *mbox)
 }
 EXPORT_SYMBOL(omap_mbox_put);
 
-int omap_mbox_register(struct omap_mbox *mbox)
+int omap_mbox_register(struct device *parent, struct omap_mbox *mbox)
 {
 	int ret = 0;
 	struct omap_mbox **tmp;
@@ -450,14 +428,31 @@ int omap_mbox_register(struct omap_mbox *mbox)
 	if (mbox->next)
 		return -EBUSY;
 
+	mbox->dev = device_create(&omap_mbox_class,
+				  parent, 0, mbox, "%s", mbox->name);
+	if (IS_ERR(mbox->dev))
+		return PTR_ERR(mbox->dev);
+
+	ret = device_create_file(mbox->dev, &dev_attr_mbox);
+	if (ret)
+		goto err_sysfs;
+
 	write_lock(&mboxes_lock);
 	tmp = find_mboxes(mbox->name);
-	if (*tmp)
+	if (*tmp) {
 		ret = -EBUSY;
-	else
-		*tmp = mbox;
+		write_unlock(&mboxes_lock);
+		goto err_find;
+	}
+	*tmp = mbox;
 	write_unlock(&mboxes_lock);
 
+	return 0;
+
+err_find:
+	device_remove_file(mbox->dev, &dev_attr_mbox);
+err_sysfs:
+	device_unregister(mbox->dev);
 	return ret;
 }
 EXPORT_SYMBOL(omap_mbox_register);
@@ -473,6 +468,8 @@ int omap_mbox_unregister(struct omap_mbox *mbox)
 			*tmp = mbox->next;
 			mbox->next = NULL;
 			write_unlock(&mboxes_lock);
+			device_remove_file(mbox->dev, &dev_attr_mbox);
+			device_unregister(mbox->dev);
 			return 0;
 		}
 		tmp = &(*tmp)->next;
@@ -501,4 +498,6 @@ static void __exit omap_mbox_class_exit(void)
 subsys_initcall(omap_mbox_class_init);
 module_exit(omap_mbox_class_exit);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("omap mailbox: interrupt driven messaging");
+MODULE_AUTHOR("Toshihiro Kobayashi and Hiroshi DOYU");

