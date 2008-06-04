Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbYFDGIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbYFDGIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 02:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbYFDGIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 02:08:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:15540 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbYFDGIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 02:08:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=qB7o3ze7oq06FlO5dPf8XKj5N/ca6YLYlTbQxukYoj2Hz2lBTRaDafz6nNh5X95lZgG9+UKLDH5xkdjyn/9uoudTNmhCWeNzmj3GugA/8+zcStTD73lE74FPzLMjuMvpvM/3m2z2tQeZf6bGL23hgCZUR75xOfRYl+RnP53lOZQ=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Uwe.Kleine-Koenig@digi.com, gregkh@suse.de, akpm@linux-foundation.org,
       hjk@linutronix.de, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, tglx@linutronix.de
Date: Wed, 04 Jun 2008 15:08:26 +0900
Message-Id: <20080604060826.17162.46972.sendpatchset@rx1.opensource.se>
Subject: [PATCH] uio_pdrv: Unique IRQ Mode
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch adds a "Unique IRQ Mode" to the uio_pdrv UIO platform driver.
In this mode the user space driver is responsible for acknowledging and
re-enabling the interrupt. Shared interrupts are not supported.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

Think of this as V2 of "[PATCH 00/03][RFC] Reusable UIO Platform Driver".
Needs "[PATCH 0/1] UIO: Add a write() function to enable/disable interrupts"

 drivers/uio/uio_pdrv.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

--- 0006/drivers/uio/uio_pdrv.c
+++ work/drivers/uio/uio_pdrv.c	2008-06-04 14:51:56.000000000 +0900
@@ -16,8 +16,34 @@
 
 struct uio_platdata {
 	struct uio_info *uioinfo;
+	unsigned long irq_disabled;
 };
 
+static irqreturn_t uio_pdrv_unique_handler(int irq, struct uio_info *dev_info)
+{
+	struct uio_platdata *priv = dev_info->priv;
+
+	/* In "Unique IRQ Mode", just disable the interrupt and remember
+	 * the state so we can enable it later.
+	 */
+	disable_irq(irq);
+	set_bit(0, &priv->irq_disabled);
+	return IRQ_HANDLED;
+}
+
+static int uio_pdrv_unique_irqcontrol(struct uio_info *dev_info, s32 irq_on)
+{
+	struct uio_platdata *priv = dev_info->priv;
+
+	/* "Unique IRQ Mode" allows re-enabling of the interrupt */
+	if (irq_on && test_and_clear_bit(0, &priv->irq_disabled)) {
+		enable_irq(dev_info->irq);
+		return 0;
+	}
+
+	return -ENOSYS;
+}
+
 static int uio_pdrv_probe(struct platform_device *pdev)
 {
 	struct uio_info *uioinfo = pdev->dev.platform_data;
@@ -68,6 +94,23 @@ static int uio_pdrv_probe(struct platfor
 
 	pdata->uioinfo->priv = pdata;
 
+	/* This driver supports a special "Unique IRQ Mode".
+	 *
+	 * In this mode, no hardware specific kernel code is required to
+	 * acknowledge interrupts. Instead, the interrupt is disabled by
+	 * the interrupt handler. User space is responsible for performing
+	 * hardware specific acknowledge and enabling of interrupts.
+	 *
+	 * Interrupt sharing is _not_ supported by the "Unique IRQ Mode".
+	 *
+	 * Enable this mode by passing IRQ number but omitting irq callbacks.
+	 */
+	if (!uioinfo->handler && !uioinfo->irqcontrol && uioinfo->irq >= 0) {
+		uioinfo->irq_flags = IRQF_DISABLED;
+		uioinfo->handler = uio_pdrv_unique_handler;
+		uioinfo->irqcontrol = uio_pdrv_unique_irqcontrol;
+	}
+
 	ret = uio_register_device(&pdev->dev, pdata->uioinfo);
 
 	if (ret) {
