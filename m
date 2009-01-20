Return-Path: <linux-kernel-owner+w=401wt.eu-S1761710AbZATWLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761710AbZATWLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 17:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbZATWLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 17:11:10 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:36311 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbZATWLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 17:11:08 -0500
From: Christian Lamparter <chunkeey@web.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH gr <gregkh@suse.de>,
       Artur Skawina <art.08.09@gmail.com>
Subject: [PATCH -stable] p54usb: fix traffic stalls / packet drop
Date: Tue, 20 Jan 2009 23:11:11 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Larry Finger" <Larry.Finger@lwfinger.net>,
       "Linux wireless" <linux-wireless@vger.kernel.org>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera> <cX2gZ6Cy9nC.A.vUD.KKRdJB@chimera>
In-Reply-To: <cX2gZ6Cy9nC.A.vUD.KKRdJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901202311.11854.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1/nhsg7h1IRau5qSw6mZ4vUje1uq3w2CjDGjGc7
	2tSWPap7mjVG22AZcYpyAHFomaY2PONV28s49vgz6rYc4dp1qU
	nMg1QWwI8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All p54usb devices need a explicit termination packet, in oder to finish the pending transfer properly.
Else, the firmware could freeze, or simply drop the frame.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
Cc: stable <stable@kernel.org>
---
Attached is the patch is for the stable series only.
Bugzilla reference: http://bugzilla.kernel.org/show_bug.cgi?id=12260
(wireless-testing needs a different one)

Rafael, I hope we can close this bug. Greg?
---
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 75d749b..be40369 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -214,6 +214,8 @@ static void p54u_tx_3887(struct ieee80211_hw *dev, struct p54_control_hdr *data,
 	usb_fill_bulk_urb(data_urb, priv->udev,
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), data, len,
 		free_on_tx ? p54u_tx_free_cb : p54u_tx_cb, dev);
+	addr_urb->transfer_flags |= URB_ZERO_PACKET;
+	data_urb->transfer_flags |= URB_ZERO_PACKET;
 
 	usb_submit_urb(addr_urb, GFP_ATOMIC);
 	usb_submit_urb(data_urb, GFP_ATOMIC);
@@ -251,6 +253,7 @@ static void p54u_tx_lm87(struct ieee80211_hw *dev,
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), hdr,
 		len + sizeof(*hdr), free_on_tx ? p54u_tx_free_cb : p54u_tx_cb,
 		dev);
+	data_urb->transfer_flags |= URB_ZERO_PACKET;
 
 	usb_submit_urb(data_urb, GFP_ATOMIC);
 }
@@ -293,11 +296,13 @@ static void p54u_tx_net2280(struct ieee80211_hw *dev, struct p54_control_hdr *da
 	usb_fill_bulk_urb(int_urb, priv->udev,
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DEV), reg, sizeof(*reg),
 		p54u_tx_free_cb, dev);
+	int_urb->transfer_flags |= URB_ZERO_PACKET;
 	usb_submit_urb(int_urb, GFP_ATOMIC);
 
 	usb_fill_bulk_urb(data_urb, priv->udev,
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), hdr, len + sizeof(*hdr),
 		free_on_tx ? p54u_tx_free_cb : p54u_tx_cb, dev);
+	data_urb->transfer_flags |= URB_ZERO_PACKET;
 	usb_submit_urb(data_urb, GFP_ATOMIC);
 }
 
