Return-Path: <linux-kernel-owner+w=401wt.eu-S1759359AbZEFCCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359AbZEFCCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 22:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758747AbZEFCAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 22:00:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:50566 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758734AbZEFCAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 22:00:39 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to force writes
Date: Tue,  5 May 2009 21:00:05 -0500
Message-Id: <1241575205-12199-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1241575205-12199-5-git-send-email-jason.wessel@windriver.com>
References: <1241575205-12199-1-git-send-email-jason.wessel@windriver.com>
 <1241575205-12199-2-git-send-email-jason.wessel@windriver.com>
 <1241575205-12199-3-git-send-email-jason.wessel@windriver.com>
 <1241575205-12199-4-git-send-email-jason.wessel@windriver.com>
 <1241575205-12199-5-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 06 May 2009 02:00:03.0722 (UTC) FILETIME=[5F0ABEA0:01C9CDEE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem that this patch tries to solve is that data is lost
because there are too many outstanding transmit urb's.

The question is what is the right way to force the controller to catch
up, and ideally let the kernel do some other things in the mean time?

This patch takes the route of forcibly polling the hcd device to drain
the urb queue and initiate the bulk write call backs.

NOTE this patch is not signed off, it is a question of what is the
right way to do this?
---
 drivers/usb/core/hcd.c         |    1 +
 drivers/usb/serial/usb_debug.c |   23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 42b93da..57c09c2 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1760,6 +1760,7 @@ irqreturn_t usb_hcd_irq (int irq, void *__hcd)
 	local_irq_restore(flags);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(usb_hcd_irq);
 
 /*-------------------------------------------------------------------------*/
 
diff --git a/drivers/usb/serial/usb_debug.c b/drivers/usb/serial/usb_debug.c
index 58feab9..8838418 100644
--- a/drivers/usb/serial/usb_debug.c
+++ b/drivers/usb/serial/usb_debug.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
+#include "../core/hcd.h"
 
 #define URB_UPPER_LIMIT			42
 #define USB_DEBUG_MAX_PACKET_SIZE	8
@@ -91,6 +92,23 @@ static int usb_debug_port_probe(struct usb_serial_port *port)
 	return 0;
 }
 
+/* If the driver is close to running of tx urb's try to free some up
+ * by asking the hcd device to do some processing.  XXX This needs
+ * review as to if this is a reasonable way to implement forcing the
+ * HCD device to run.
+ */
+static void poll_hcd_irq(struct urb *urb)
+{
+	struct usb_hcd *hcd;
+
+	if (!urb)
+		return;
+
+	hcd = bus_to_hcd(urb->dev->bus);
+	if (hcd)
+		usb_hcd_irq(0, hcd);
+}
+
 static int usb_debug_write_room(struct tty_struct *tty)
 {
 	unsigned long flags;
@@ -156,10 +174,15 @@ static int usb_debug_write(struct tty_struct *tty,
 		dbg("%s - write request of 0 bytes", __func__);
 
 	while (count > 0) {
+		int loops = 1000;
+try_again:
 		spin_lock_irqsave(&priv->tx_lock, flags);
 		if (priv->tx_outstanding_urbs > URB_UPPER_LIMIT) {
 			spin_unlock_irqrestore(&priv->tx_lock, flags);
 			dbg("%s - write limit hit\n", __func__);
+			poll_hcd_irq(port->read_urb);
+			if (loops-- > 0)
+				goto try_again;
 			return bwrite;
 		}
 
-- 
1.6.3.rc0.1.gf800

