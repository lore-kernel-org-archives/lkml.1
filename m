Return-Path: <linux-kernel-owner+w=401wt.eu-S1762405AbZLKLdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762405AbZLKLdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 06:33:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762431AbZLKLcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 06:32:33 -0500
Received: from smtp.nokia.com ([192.100.122.233]:50311 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762371AbZLKLcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 06:32:22 -0500
From: Felipe Balbi <felipe.balbi@nokia.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>, linux-omap@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [RFC/PATCH 5/5] usb: musb: musb supports otg notifier
Date: Fri, 11 Dec 2009 13:31:26 +0200
Message-Id: <1260531086-23857-6-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.6.rc0
In-Reply-To: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
X-OriginalArrivalTime: 11 Dec 2009 11:31:55.0983 (UTC) FILETIME=[8B3585F0:01CA7A55]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we use the notifier to kick the charger detection.
Needed on RX-51 board. Later on we will notify
also the bMaxPower field from usb_configuration.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 drivers/usb/musb/musb_core.c |   72 ++++++++++++++++++++++++++++++++++++++++++
 drivers/usb/musb/musb_core.h |    5 +++
 2 files changed, 77 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 55e185a..c7c60df 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -98,6 +98,7 @@
 #include <linux/kobject.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/notifier.h>
 
 #ifdef	CONFIG_ARM
 #include <mach/hardware.h>
@@ -144,6 +145,74 @@ MODULE_ALIAS("platform:" MUSB_DRIVER_NAME);
 
 /*-------------------------------------------------------------------------*/
 
+#include "isp1704.h"
+
+static int musb_detect_charger(struct musb *musb)
+{
+	unsigned long		timeout;
+	u8			vdat = 0;
+	u8			power;
+	u8			r;
+
+	/* first we disable data pullups */
+	power = musb_readb(musb->mregs, MUSB_POWER);
+	power &= ~MUSB_POWER_SOFTCONN;
+	musb_writeb(musb->mregs, MUSB_POWER, power);
+
+	/* now we set SW control bit in PWR_CTRL register */
+	r = musb_ulpi_readb(musb->mregs, ISP1704_PWR_CTRL);
+	r |= ISP1704_PWR_CTRL_SWCTRL;
+	musb_ulpi_writeb(musb->mregs, ISP1704_PWR_CTRL, r);
+
+	/* and finally enable manual charger detection */
+	r |= ISP1704_PWR_CTRL_DPVSRC_EN;
+	musb_ulpi_writeb(musb->mregs, ISP1704_PWR_CTRL, r);
+	msleep(10);
+
+	timeout = jiffies + msecs_to_jiffies(300);
+	while (!time_after(jiffies, timeout)) {
+		/* Check if there is a charger */
+		vdat = !!(musb_ulpi_readb(musb->mregs, ISP1704_PWR_CTRL)
+				& ISP1704_PWR_CTRL_VDAT_DET);
+		if (vdat)
+			break;
+	}
+
+	/* clear DPVSRC_EN, otherwise usb communication doesn't work */
+	r &= ~ISP1704_PWR_CTRL_DPVSRC_EN;
+	musb_ulpi_writeb(musb->mregs, ISP1704_PWR_CTRL, r);
+
+	if (vdat)
+		blocking_notifier_call_chain(&musb->xceiv->notifier,
+				USB_EVENT_CHARGER, &musb->g);
+
+	/*
+	 * re-enable data pullups, we might have been connected
+	 * to a host/hub charger
+	 */
+	power |= MUSB_POWER_SOFTCONN;
+	musb_writeb(musb->mregs, MUSB_POWER, power);
+
+	return vdat;
+}
+
+static int musb_notifier_call(struct notifier_block *nb, unsigned long event,
+		void *_gadget)
+{
+	struct usb_gadget	*g = _gadget;
+	struct musb		*musb = container_of(g, struct musb, g);
+
+	switch (event) {
+	case USB_EVENT_VBUS:
+		musb->is_charger = musb_detect_charger(musb);
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return NOTIFY_OK;
+}
+
 static inline struct musb *dev_to_musb(struct device *dev)
 {
 #ifdef CONFIG_USB_MUSB_HDRC_HCD
@@ -1961,6 +2030,9 @@ bad_config:
 		goto fail2;
 	}
 
+	musb->nb.notifier_call = musb_notifier_call;
+	otg_register_notifier(musb->xceiv, &musb->nb);
+
 #ifndef CONFIG_MUSB_PIO_ONLY
 	if (use_dma && dev->dma_mask) {
 		struct dma_controller	*c;
diff --git a/drivers/usb/musb/musb_core.h b/drivers/usb/musb/musb_core.h
index 644fcd8..3de6eb8 100644
--- a/drivers/usb/musb/musb_core.h
+++ b/drivers/usb/musb/musb_core.h
@@ -322,6 +322,9 @@ struct musb {
 	struct clk		*clock;
 	irqreturn_t		(*isr)(int, void *);
 	struct work_struct	irq_work;
+
+	struct notifier_block	nb;
+
 #define MUSB_HWVERS_MAJOR(x)	((x >> 10) & 0x1f)
 #define MUSB_HWVERS_MINOR(x)	(x & 0x3ff)
 #define MUSB_HWVERS_RC		0x8000
@@ -432,6 +435,8 @@ struct musb {
 	unsigned		is_self_powered:1;
 	unsigned		is_bus_powered:1;
 
+	unsigned		is_charger:1;
+
 	unsigned		set_address:1;
 	unsigned		test_mode:1;
 	unsigned		softconnect:1;
-- 
1.6.6.rc0

