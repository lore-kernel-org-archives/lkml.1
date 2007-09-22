Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbXIVUPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbXIVUPA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 16:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbXIVUOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 16:14:52 -0400
Received: from smtp111.sbc.mail.re2.yahoo.com ([68.142.229.94]:27813 "HELO
	smtp111.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751275AbXIVUOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 16:14:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=TUhDdXpIOpSJL6EMG9NkcuGcqlgep7bWPGU9zZueeeh94VEWqIjBxCHZ0hnrKP385l7FT59S3BhrnklCTWYMPQRg4jQhi9k+5hqNOhyRWvH4MOx448dR29K15oYTEQLeyygLTKOIu73VUQ1FMphsWp4SRtM24qXaMUMnLJJNTa4=  ;
X-YMail-OSG: Ra6GXXkVM1kcyyIW1cUZj0fer7NmKCF2nBAi2494alMVxKogso7zhcMGvFLgZCGLIz7pG._DSw--
Date: Sat, 22 Sep 2007 13:14:50 -0700
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
In-Reply-To: <1190489440.4035.103.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070922201450.EB20823974D@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

How's this?  Note that the queue should already have been stopped,
so I removed what should be an extra call (as well as fixing the
comments).

- Dave

========
From: Thomas Gleixner <tglx@linutronix.de>

This patch fixes a longstanding race in the Ethernet gadget driver,
which can cause an oops on device disconnect.  The fix is just to
make the TX path check whether its freelist is empty.  That check
is otherwise not necessary, since the queue is always stopped when
that list empties (and restarted when request completion puts an
entry back on that freelist).

The race window starts when the network code decides to transmit a
packet, and ends when hard_start_xmit() grabs the freelist lock.
If disconnect() is called inside that window, it shuts down the
TX queue and breaks the otherwise-solid assumption that packets are
never sent when the TX queue is stopped.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

--- a/drivers/usb/gadget/ether.c
+++ b/drivers/usb/gadget/ether.c
@@ -1989,8 +1989,20 @@ static int eth_start_xmit (struct sk_buff *skb, struct net_device *net)
 	}
 
 	spin_lock_irqsave(&dev->req_lock, flags);
+	/*
+	 * the freelist can be empty if an interrupt triggered disconnect()
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


