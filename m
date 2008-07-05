Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbYGEEVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbYGEEVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 00:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbYGEEVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 00:21:10 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:36311 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYGEEVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 00:21:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=EE6PurmcSuXov/iwsthmg8Hmat6sRD1woD25ykvzVGbX8qQ2YT/Uw4XGBQL1/v+gHE
         xu8aK8fwnJ/micDUOYZV8J9mseQ2JJMrJeyqo9Jmu97n9SDwexhpQ8meDyfSKrdt+Hef
         afABjCIy9F6pPguXKtRI+JmgFdIikJvUUvv2o=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Uwe.Kleine-Koenig@digi.com, gregkh@suse.de, akpm@linux-foundation.org,
       hjk@linutronix.de, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, tglx@linutronix.de,
       alan@lxorguk.ukuu.org.uk
Date: Sat, 05 Jul 2008 13:21:21 +0900
Message-Id: <20080705042121.4647.29429.sendpatchset@rx1.opensource.se>
Subject: [PATCH] uio: User IRQ Mode V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is V2 of the UIO "User IRQ Mode" patch.

In User IRQ Mode the kernel space interrupt handler simply disables
the serviced interrupt in the interrupt controller and makes the
user space driver responsible for acknowledging the interrupt in
the device and reenabling the interrupt in the interrupt controller.

Shared interrupts are not supported by the User IRQ Mode since the
generic in-kernel interrupt handler will disable the shared interrupt
in the interrupt controller, and in a shared interrupt configuration
this will stop other devices from delivering interrupts.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---

 Changes since V1
  - use disable_irq_nosync() in interrupt handler, thanks Alan!

 Changes since Uwe's last version:
  - flags should be unsigned long
  - simplify uio_userirq_handler()

 Similar code has been posted some time ago as:
 "[PATCH] uio_pdrv: Unique IRQ Mode"
 "[PATCH 00/03][RFC] Reusable UIO Platform Driver".

 Needs "[PATCH 0/1] UIO: Add a write() function to enable/disable interrupts"

 include/linux/uio_driver.h |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- 0001/include/linux/uio_driver.h
+++ work/include/linux/uio_driver.h	2008-07-05 12:46:09.000000000 +0900
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
@@ -92,4 +94,28 @@ extern void uio_event_notify(struct uio_
 #define UIO_MEM_LOGICAL	2
 #define UIO_MEM_VIRTUAL 3
 
+/* defines for uio_info->flags */
+#define UIO_FLAGS_IRQDISABLED 0
+
+static inline irqreturn_t uio_userirq_handler(int irq, struct uio_info *info)
+{
+	if (!test_and_set_bit(UIO_FLAGS_IRQDISABLED, &info->flags))
+		disable_irq_nosync(info->irq);
+
+	return IRQ_HANDLED;
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
