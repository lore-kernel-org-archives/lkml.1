Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbXIVRlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbXIVRlU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 13:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbXIVRlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 13:41:05 -0400
Received: from www.osadl.org ([213.239.205.134]:60010 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752340AbXIVRlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 13:41:03 -0400
Subject: [PATCH] usb-gadget-ether: Prevent oops caused by error interrupt
	race -V2 (comments update)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Benedikt Spranger <bene@linutronix.de>, Stable Team <stable@kernel.org>
In-Reply-To: <200709211508.42968.david-b@pacbell.net>
References: <1190299611.3481.34.camel@chaos>
	 <200709211508.42968.david-b@pacbell.net>
Content-Type: text/plain
Date: Sat, 22 Sep 2007 19:41:01 +0200
Message-Id: <1190482861.4035.59.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benedikt Spranger <bene@linutronix.de>
 
eth_start_xmit() can race against a disconnect interrupt in the gadget
device driver, which nukes all pending request. Right now we access the
pending request list unconditionally and dereference the request list
head itself in such a case, which results in an Oops.

Check whether the list is empty before actually dereferencing
dev->tx_reqs.next. Also add a comment for the second list_empty check
further down to avoid confusion.

Long standing bug. Patch should be applied to stable as well.

Signed-off-by: Benedikt Spranger <bene@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/drivers/usb/gadget/ether.c b/drivers/usb/gadget/ether.c
index 593e235..f2a7bd5 100644
--- a/drivers/usb/gadget/ether.c
+++ b/drivers/usb/gadget/ether.c
@@ -1989,8 +1989,21 @@ static int eth_start_xmit (struct sk_buff *skb, struct net_device *net)
 	}
 
 	spin_lock_irqsave(&dev->req_lock, flags);
+	/*
+	 * dev->tx_reqs may be empty. We raced against a disconnect
+	 * interrupt in the gadget device driver, which nuked all
+	 * pending requests.
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


