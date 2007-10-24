Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbXJXDPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbXJXDPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 23:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbXJXDPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 23:15:41 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:64480 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbXJXDPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 23:15:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=gKz3ER+UcP2rRKNSsy0qvxJJcYG0b2udKmbe6I7r7rRQ94HJ2BdlXjfza7unRA3p+QQMKttr9ZxryLe1MJLU01ZCmICXIKDVIncUhGg2lUQlDsSgKlMlMw3Xt4FWP4WX/i4souMXwXFKeErjfjJSRdi4xIMzB0fomVZbUbQCVSc=
Date: Wed, 24 Oct 2007 11:14:19 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: bluez-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] bluetooth: hidp_process_hid_control remove unnecessary parameter dealing
Message-ID: <20071024031419.GA7409@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

According to the bluetooth HID spec v1.0 chapter 7.4.2

"This code requests a major state change in a BT-HID device. A HID_CONTROL request does not generate a HANDSHAKE response."

"A HID_CONTROL packet with a parameter of VIRTUAL_CABLE_UNPLUG is the only HID_CONTROL packet a device can send to a host. A host will ignore all other packets."

So in the hidp_precess_hid_control function, we just need to deal with the UNLUG packet.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
net/bluetooth/hidp/core.c |   19 +------------------
1 file changed, 1 insertion(+), 18 deletions(-)

diff -upr linux/net/bluetooth/hidp/core.c linux.new/net/bluetooth/hidp/core.c
--- linux/net/bluetooth/hidp/core.c	2007-10-15 14:05:23.000000000 +0800
+++ linux.new/net/bluetooth/hidp/core.c	2007-10-24 11:01:07.000000000 +0800
@@ -369,30 +369,13 @@ static inline void hidp_process_hid_cont
 {
 	BT_DBG("session %p param 0x%02x", session, param);
 
-	switch (param) {
-	case HIDP_CTRL_NOP:
-		break;
-
-	case HIDP_CTRL_VIRTUAL_CABLE_UNPLUG:
+	if (param == HIDP_CTRL_VIRTUAL_CABLE_UNPLUG) {
 		/* Flush the transmit queues */
 		skb_queue_purge(&session->ctrl_transmit);
 		skb_queue_purge(&session->intr_transmit);
 
 		/* Kill session thread */
 		atomic_inc(&session->terminate);
-		break;
-
-	case HIDP_CTRL_HARD_RESET:
-	case HIDP_CTRL_SOFT_RESET:
-	case HIDP_CTRL_SUSPEND:
-	case HIDP_CTRL_EXIT_SUSPEND:
-		/* FIXME: We have to parse these and return no error */
-		break;
-
-	default:
-		__hidp_send_ctrl_message(session,
-			HIDP_TRANS_HANDSHAKE | HIDP_HSHK_ERR_INVALID_PARAMETER, NULL, 0);
-		break;
 	}
 }
 
