Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbZEKU0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbZEKU0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759287AbZEKUZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:25:17 -0400
Received: from mail.windriver.com ([147.11.1.11]:52605 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759039AbZEKUZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:25:14 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: greg@kroah.com
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 2/4] ftd_sio usb: move status check
Date: Mon, 11 May 2009 15:24:08 -0500
Message-Id: <1242073450-3794-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1242073450-3794-2-git-send-email-jason.wessel@windriver.com>
References: <1242073450-3794-1-git-send-email-jason.wessel@windriver.com>
 <1242073450-3794-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 11 May 2009 20:25:06.0777 (UTC) FILETIME=[92CECC90:01C9D276]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern commented that the private driver counts must be updated
regard less of the status return on the urb when the write call back
is executed.

This patch alters the behavior to update the private driver counts by
simply moving the status check to after the driver count update.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 0ab8474..3a1b84d 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1755,11 +1755,6 @@ static void ftdi_write_bulk_callback(struct urb *urb)
 
 	dbg("%s - port %d", __func__, port->number);
 
-	if (status) {
-		dbg("nonzero write bulk status received: %d", status);
-		return;
-	}
-
 	priv = usb_get_serial_port_data(port);
 	if (!priv) {
 		dbg("%s - bad port private data pointer - exiting", __func__);
@@ -1777,6 +1772,11 @@ static void ftdi_write_bulk_callback(struct urb *urb)
 	priv->tx_outstanding_bytes -= countback;
 	spin_unlock_irqrestore(&priv->tx_lock, flags);
 
+	if (status) {
+		dbg("nonzero write bulk status received: %d", status);
+		return;
+	}
+
 	usb_serial_port_softint(port);
 } /* ftdi_write_bulk_callback */
 
-- 
1.6.3.rc0.1.gf800

