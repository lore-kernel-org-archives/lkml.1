Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbXIVUxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbXIVUxo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 16:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbXIVUxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 16:53:36 -0400
Received: from smtp116.sbc.mail.re3.yahoo.com ([66.196.96.89]:29320 "HELO
	smtp116.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751275AbXIVUxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 16:53:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=VVbJj/mbMokyPxMAkLDQo6kNNmSZOkm2FBhcmgfxaP8MLS6WV4PQWmSqGoBlxqXQCsuffwimmgtDL3X3XhV3YGjR1wcVk7gL78qggSX9GNhrxXglHy1wTEtU9ileTBvEeLrpZtBBlq2DQpvV8tyGr9e7jYv4jhDjcgcsfNG8mlg=  ;
X-YMail-OSG: .Gbl4VwVM1koRZWFdS13F93tgxPp4MF.7z7hDW6XyztCMV4va.KWVkAr2dqzfpVJ1.ZkQSpmGQ--
Date: Sat, 22 Sep 2007 13:53:33 -0700
From: David Brownell <david-b@pacbell.net>
To: tglx@linutronix.de
Subject: Re: [PATCH] usb-gadget-ether: Prevent oops caused by error interrupt  race -V2 (comments update)
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, bene@linutronix.de,
       akpm@osdl.org
References: <1190299611.3481.34.camel@chaos>
 <200709211508.42968.david-b@pacbell.net>
 <1190482861.4035.59.camel@chaos>
 <20070922191806.A2F59C2308@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <1190489440.4035.103.camel@chaos>
 <20070922201450.EB20823974D@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <1190492580.4035.116.camel@chaos>
In-Reply-To: <1190492580.4035.116.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070922205333.EEA972300C1@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Sigh. I need a real deep look inside that code to understand, why
> tx_reqs is not a requestlist but a freelist. Very intuitive naming :)

It *is* a list of requests:  free ones -- the only kind this level of
driver is allowed to remember!  ;)

Yeah, I had to go back and read the driver again before I understood
just what problem this patch was trying to fix.  Which is why I wanted
to make sure the mismatch between comments and contents was resolved.

- Dave

==========	CUT HERE
From: Benedikt Spranger <bene@linutronix.de>

This patch fixes a longstanding race in the Ethernet gadget driver,
which can cause an oops on device disconnect.  The fix is just to
make the TX path check whether its freelist is empty.  That check
is otherwise not necessary, since the queue is always stopped when
that list empties (and restarted when request completion puts an
entry back on that freelist).

The race window starts when the network code decides to transmit a
packet, and ends when hard_start_xmit() grabs the freelist lock.
When disconnect() is called inside that window, it shuts down the
TX queue and breaks the otherwise-solid assumption that packets are
never sent through a TX queue that's stopped.

Signed-off-by: Benedikt Spranger <bene@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

--- a/drivers/usb/gadget/ether.c
+++ b/drivers/usb/gadget/ether.c
@@ -1989,8 +1989,20 @@ static int eth_start_xmit (struct sk_buff *skb, struct net_device *net)
 	}
 
 	spin_lock_irqsave(&dev->req_lock, flags);
+	/*
+	 * this freelist can be empty if an interrupt triggered disconnect()
+	 * and reconfigured the gadget (shutting down this queue) after the
+	 * network stack decided to xmit but before we got the spinlock.
+	 */
+	if (list_empty(&dev->tx_reqs)) {
+		spin_unlock_irqrestore(&dev->req_lock, flags);
+		return 1;
+	}
+
 	req = container_of (dev->tx_reqs.next, struct usb_request, list);
 	list_del (&req->list);
+
+	/* temporarily stop TX queue when the freelist empties */
 	if (list_empty (&dev->tx_reqs))
 		netif_stop_queue (net);
 	spin_unlock_irqrestore(&dev->req_lock, flags);


