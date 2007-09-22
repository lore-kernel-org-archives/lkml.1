Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbXIVUXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbXIVUXQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 16:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbXIVUXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 16:23:05 -0400
Received: from www.osadl.org ([213.239.205.134]:47610 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751688AbXIVUXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 16:23:02 -0400
Subject: Re: [PATCH] usb-gadget-ether: Prevent oops caused by error
	interrupt  race -V2 (comments update)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Brownell <david-b@pacbell.net>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, bene@linutronix.de,
       akpm@osdl.org
In-Reply-To: <20070922201450.EB20823974D@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <1190299611.3481.34.camel@chaos>
	 <200709211508.42968.david-b@pacbell.net> <1190482861.4035.59.camel@chaos>
	 <20070922191806.A2F59C2308@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	 <1190489440.4035.103.camel@chaos>
	 <20070922201450.EB20823974D@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Content-Type: text/plain
Date: Sat, 22 Sep 2007 22:23:00 +0200
Message-Id: <1190492580.4035.116.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-09-22 at 13:14 -0700, David Brownell wrote:
> How's this?  Note that the queue should already have been stopped,
> so I removed what should be an extra call (as well as fixing the
> comments).

Yeah, stop queue should be not necessary.

> - Dave
> 
> ========
> From: Thomas Gleixner <tglx@linutronix.de>

Please change to:

From: Benedikt Spranger <bene@linutronix.de>

He did all the grump work of figuring out what's going wrong. I was just
the messenger.

> This patch fixes a longstanding race in the Ethernet gadget driver,
> which can cause an oops on device disconnect.  The fix is just to
> make the TX path check whether its freelist is empty.  That check
> is otherwise not necessary, since the queue is always stopped when
> that list empties (and restarted when request completion puts an
> entry back on that freelist).

Sigh. I need a real deep look inside that code to understand, why
tx_reqs is not a requestlist but a freelist. Very intuitive naming :)

> The race window starts when the network code decides to transmit a
> packet, and ends when hard_start_xmit() grabs the freelist lock.
> If disconnect() is called inside that window, it shuts down the
> TX queue and breaks the otherwise-solid assumption that packets are
> never sent when the TX queue is stopped.

Please add our signed offs as well

Signed-off-by: Benedikt Spranger <bene@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Thanks,
	tglx


> --- a/drivers/usb/gadget/ether.c
> +++ b/drivers/usb/gadget/ether.c
> @@ -1989,8 +1989,20 @@ static int eth_start_xmit (struct sk_buff *skb, struct net_device *net)
>  	}
>  
>  	spin_lock_irqsave(&dev->req_lock, flags);
> +	/*
> +	 * the freelist can be empty if an interrupt triggered disconnect()
> +	 * and reconfigured the gadget (shutting down this queue) after the
> +	 * network stack decided to xmit but before we got the spinlock.
> +	 */
> +	if (list_empty(&dev->tx_reqs)) {
> +		spin_unlock_irqrestore(&dev->req_lock, flags);
> +		return 1;
> +	}
> +
>  	req = container_of (dev->tx_reqs.next, struct usb_request, list);
>  	list_del (&req->list);
> +
> +	/* temporarily stop TX queue when the freelist empties */
>  	if (list_empty (&dev->tx_reqs))
>  		netif_stop_queue (net);
>  	spin_unlock_irqrestore(&dev->req_lock, flags);
> 
> 

