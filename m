Return-Path: <linux-kernel-owner+w=401wt.eu-S1762789AbYGBK7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762789AbYGBK7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 06:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbYGBK7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 06:59:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:31430 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbYGBK7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 06:59:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=YpdXIxnmmvjx0JrdS2ULOvmCEt2pZ0uoJjmpl7XBV7Zzk4Dre+gazLHlFSOChxZHQ4
         61pDCM+Lh5Q+agew56GXH3ZYkchJoQnb3eVQWitHwHsPcd1TUPBU3UfEHW7/cyZFeTU0
         xZCHclh6blgTxHtFiGiraN6JSm8Jh53d756AQ=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Uwe.Kleine-Koenig@digi.com, gregkh@suse.de, akpm@linux-foundation.org,
       hjk@linutronix.de, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, tglx@linutronix.de
Date: Wed, 02 Jul 2008 19:59:51 +0900
Message-Id: <20080702105951.22648.2197.sendpatchset@rx1.opensource.se>
Subject: [PATCH] uio: User IRQ Mode
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>

This patch adds a "User IRQ Mode" to UIO. In this mode the user space driver
is responsible for acknowledging and re-enabling the interrupt.
Shared interrupts are not supported by this mode.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Similar code has been posted some time ago as:
 "[PATCH] uio_pdrv: Unique IRQ Mode"
 "[PATCH 00/03][RFC] Reusable UIO Platform Driver".

 Changes since Uwe's last version:
  - flags should be unsigned long
  - simplify uio_userirq_handler()

 Needs "[PATCH 0/1] UIO: Add a write() function to enable/disable interrupts"

 include/linux/uio_driver.h |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- 0020/include/linux/uio_driver.h
+++ work/include/linux/uio_driver.h	2008-07-02 19:45:55.000000000 +0900
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/interrupt.h>
+#include <linux/bitops.h>
 
 struct uio_map;
 
@@ -63,6 +64,7 @@ struct uio_info {
 	long			irq;
 	unsigned long		irq_flags;
 	void			*priv;
+	unsigned long		flags;
 	irqreturn_t (*handler)(int irq, struct uio_info *dev_info);
 	int (*mmap)(struct uio_info *info, struct vm_area_struct *vma);
 	int (*open)(struct uio_info *info, struct inode *inode);
@@ -92,4 +94,31 @@ extern void uio_event_notify(struct uio_
 #define UIO_MEM_LOGICAL	2
 #define UIO_MEM_VIRTUAL 3
 
+/* defines for uio_info->flags */
+#define UIO_FLAGS_IRQDISABLED 0
+
+static inline irqreturn_t uio_userirq_handler(int irq,
+		struct uio_info *dev_info)
+{
+	int ret = -1;
+
+	if (likely(dev_info->irqcontrol))
+		ret = dev_info->irqcontrol(dev_info, 0);
+
+	return IRQ_RETVAL(ret == 0);
+}
+
+static inline int uio_userirq_irqcontrol(struct uio_info *info, s32 irq_on)
+{
+	if (irq_on) {
+		if (test_and_clear_bit(UIO_FLAGS_IRQDISABLED, &info->flags))
+			enable_irq(info->irq);
+	} else {
+		if (!test_and_set_bit(UIO_FLAGS_IRQDISABLED, &info->flags))
+			disable_irq(info->irq);
+	}
+
+	return 0;
+}
+
 #endif /* _LINUX_UIO_DRIVER_H_ */
