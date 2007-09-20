Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbXITOrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbXITOrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 10:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbXITOqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 10:46:53 -0400
Received: from www.osadl.org ([213.239.205.134]:59962 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753216AbXITOqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 10:46:53 -0400
Subject: [PATCH] usb-gadget-ether: Prevent oops caused by error interrupt
	race
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: David Brownell <david-b@pacbell.net>, LKML <linux-kernel@vger.kernel.org>,
       Benedikt Spranger <bene@linutronix.de>, Stable Team <stable@kernel.org>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 16:46:51 +0200
Message-Id: <1190299611.3481.34.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benedikt Spranger <bene@linutronix.de>

An USB error interrupt (e.g. disconnect) nukes the pending requests for
an ethernet gadget device asynchronously. This can race against
eth_start_xmit(), where we end up dereferencing the list head itself.

The nuke code is serialized against eth_start_xmit via dev->req_lock,
but we need to check the list for empty first instead of unconditionally
accessing dev->tx_reqs.next.

This is a long standing bug, which should be fixed in stable as well.

Signed-off-by: Benedikt Spranger <bene@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/drivers/usb/gadget/ether.c b/drivers/usb/gadget/ether.c
index 593e235..f1d7c82 100644
--- a/drivers/usb/gadget/ether.c
+++ b/drivers/usb/gadget/ether.c
@@ -1989,8 +1989,20 @@ static int eth_start_xmit (struct sk_buff *skb, struct net_device *net)
 	}
 
 	spin_lock_irqsave(&dev->req_lock, flags);
+	/*
+	 * dev->tx_reqs may be empty due to an error interrupt which
+	 * nuked all requests.
+	 */
+	if (list_empty(&dev->tx_reqs)) {
+		netif_stop_queue(net);
+		spin_unlock_irqrestore(&dev->req_lock, flags);
+		return 1;
+	}
+
 	req = container_of (dev->tx_reqs.next, struct usb_request, list);
 	list_del (&req->list);
+
+	/* last request in list: stop queue */
 	if (list_empty (&dev->tx_reqs))
 		netif_stop_queue (net);
 	spin_unlock_irqrestore(&dev->req_lock, flags);


