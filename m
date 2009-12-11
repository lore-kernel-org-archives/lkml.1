Return-Path: <linux-kernel-owner+w=401wt.eu-S1762319AbZLKLdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762319AbZLKLdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 06:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762406AbZLKLc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 06:32:26 -0500
Received: from smtp.nokia.com ([192.100.122.233]:50304 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762327AbZLKLcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 06:32:16 -0500
From: Felipe Balbi <felipe.balbi@nokia.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>, linux-omap@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [RFC/PATCH 1/5] usb: otg: add notifier support
Date: Fri, 11 Dec 2009 13:31:22 +0200
Message-Id: <1260531086-23857-2-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.6.rc0
In-Reply-To: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
X-OriginalArrivalTime: 11 Dec 2009 11:31:45.0019 (UTC) FILETIME=[84AC8CB0:01CA7A55]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The notifier will be used to communicate usb events
to other drivers like the charger chip.

This can be used as source of information to kick
usb charger detection as described by the USB
Battery Charging Specification 1.1 and/or to
pass bMaxPower field of selected usb_configuration
to charger chip in order to use that information
as input current on the charging profile
setup.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 include/linux/usb/otg.h |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/include/linux/usb/otg.h b/include/linux/usb/otg.h
index 52bb917..6c0b676 100644
--- a/include/linux/usb/otg.h
+++ b/include/linux/usb/otg.h
@@ -9,6 +9,8 @@
 #ifndef __LINUX_USB_OTG_H
 #define __LINUX_USB_OTG_H
 
+#include <linux/notifier.h>
+
 /* OTG defines lots of enumeration states before device reset */
 enum usb_otg_state {
 	OTG_STATE_UNDEFINED = 0,
@@ -33,6 +35,14 @@ enum usb_otg_state {
 	OTG_STATE_A_VBUS_ERR,
 };
 
+enum usb_xceiv_events {
+	USB_EVENT_NONE,         /* no events or cable disconnected */
+	USB_EVENT_VBUS,         /* vbus valid event */
+	USB_EVENT_ID,           /* id was grounded */
+	USB_EVENT_CHARGER,      /* usb dedicated charger */
+	USB_EVENT_ENUMERATED,   /* gadget driver enumerated */
+};
+
 #define USB_OTG_PULLUP_ID		(1 << 0)
 #define USB_OTG_PULLDOWN_DP		(1 << 1)
 #define USB_OTG_PULLDOWN_DM		(1 << 2)
@@ -70,6 +80,9 @@ struct otg_transceiver {
 	struct otg_io_access_ops	*io_ops;
 	void __iomem			*io_priv;
 
+	/* for notification of usb_xceiv_events */
+	struct blocking_notifier_head	notifier;
+
 	/* to pass extra port status to the root hub */
 	u16			port_status;
 	u16			port_change;
@@ -203,6 +216,18 @@ otg_start_srp(struct otg_transceiver *otg)
 	return otg->start_srp(otg);
 }
 
+/* notifiers */
+static inline int
+otg_register_notifier(struct otg_transceiver *otg, struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&otg->notifier, nb);
+}
+
+static inline void
+otg_unregister_notifier(struct otg_transceiver *otg, struct notifier_block *nb)
+{
+	blocking_notifier_chain_unregister(&otg->notifier, nb);
+}
 
 /* for OTG controller drivers (and maybe other stuff) */
 extern int usb_bus_start_enum(struct usb_bus *bus, unsigned port_num);
-- 
1.6.6.rc0

