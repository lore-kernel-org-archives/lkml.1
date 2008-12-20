Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbYLTTBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbYLTTBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 14:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbYLTTBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 14:01:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55363 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbYLTTBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 14:01:09 -0500
Date: Sat, 20 Dec 2008 13:01:05 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, chunkeey@web.de,
       linux-wireless@vger.kernel.org
Subject: [PATCH] p54usb: Fix regression when using LM87 firmware
Message-ID: <494d40f1.GbJ6M2Y8ASv5poNG%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Lamparter <chunkeey@web.de>

Commit 2b80848e3818fb1c8ccddc105b065a86c68afa9d entitled "p54usb: support LM87
firmwares" resulted in a regression when LM87 firmware is used, as this
firmware needs an explicit termination "packet" to terminate the transmission.
If this is missing, the device stalls. This problem is reported as Bugzilla
Entry No. 12260.

The original patch was suitable for the wireless-testing.git tree. This version
is designed for 2.6.28-rc9.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch should be sent to 2.6.28, preferably before release.

Larry
---

Index: linux-2.6/drivers/net/wireless/p54/p54usb.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/p54/p54usb.c
+++ linux-2.6/drivers/net/wireless/p54/p54usb.c
@@ -251,6 +251,7 @@ static void p54u_tx_lm87(struct ieee8021
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), hdr,
 		len + sizeof(*hdr), free_on_tx ? p54u_tx_free_cb : p54u_tx_cb,
 		dev);
+	data_urb->transfer_flags |= URB_ZERO_PACKET;
 
 	usb_submit_urb(data_urb, GFP_ATOMIC);
 }
