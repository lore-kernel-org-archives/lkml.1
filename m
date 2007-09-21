Return-Path: <linux-kernel-owner+w=401wt.eu-S1763927AbXIUWIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763927AbXIUWIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761586AbXIUWIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:08:46 -0400
Received: from smtp104.sbc.mail.re2.yahoo.com ([68.142.229.101]:30098 "HELO
	smtp104.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752086AbXIUWIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:08:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Kh5eUJKhUVg26a7L0cqK8l7Jygc6CSyii5xQurvhqoLqtrjPmArwgrG5W55bZlXS0pU+/1IiioYtHLOhUchLzHoJCtibGEy+vNXC4dGeICLzwDfPy8DDPfHCjNP4To0WAYoUcMjI0OtcLdg5PCZrjhEiFtgc6i6P3hGndrdESUA=  ;
X-YMail-OSG: NPgNxKsVM1nBkjpVVy.xxJMvdAY8RUvmmdLJhsW7FzQDYGdOxXy.ndSNCugwo3jWf2sRSJL.3qa9SbaiCLi0R.oXaTUy0COd3W9gQmV7_qrN2efQzUl2tw--
From: David Brownell <david-b@pacbell.net>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] usb-gadget-ether: Prevent oops caused by error interrupt race
Date: Fri, 21 Sep 2007 15:08:42 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Benedikt Spranger <bene@linutronix.de>, Stable Team <stable@kernel.org>
References: <1190299611.3481.34.camel@chaos>
In-Reply-To: <1190299611.3481.34.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709211508.42968.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2007, Thomas Gleixner wrote:
> From: Benedikt Spranger <bene@linutronix.de>
> 
> An USB error interrupt (e.g. disconnect) nukes the pending requests for
> an ethernet gadget device asynchronously. This can race against
> eth_start_xmit(), where we end up dereferencing the list head itself.
> 
> The nuke code is serialized against eth_start_xmit via dev->req_lock,
> but we need to check the list for empty first instead of unconditionally
> accessing dev->tx_reqs.next.

Looks OK, although the comments are confusingly incorrect which
made it hard to see what this was doing:

 - There is no "nuke()" method in this driver, even comments
   don't use that term.

 - When "nuke" is used in the gadget stack, it means the way
   that controller drivers scrub out a queue of live requests
   queued to an endpoint ... *NOT* recycling memory that sits
   on a freelist, which is what's involved here.

 - Disconnect is *NOT* an error, it's a routine occurrence
   which can happen at essentially any time.

If you update the patch and comments accordingly, ACK.


> This is a long standing bug, which should be fixed in stable as well.
> 
> Signed-off-by: Benedikt Spranger <bene@linutronix.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> diff --git a/drivers/usb/gadget/ether.c b/drivers/usb/gadget/ether.c
> index 593e235..f1d7c82 100644
> --- a/drivers/usb/gadget/ether.c
> +++ b/drivers/usb/gadget/ether.c
> @@ -1989,8 +1989,20 @@ static int eth_start_xmit (struct sk_buff *skb, struct net_device *net)
>  	}
>  
>  	spin_lock_irqsave(&dev->req_lock, flags);
> +	/*
> +	 * dev->tx_reqs may be empty due to an error interrupt which

Please reword:  "may be empty because disconnecting an
active device cleans out this freelist".  

> +	 * nuked all requests.
> +	 */
> +	if (list_empty(&dev->tx_reqs)) {
> +		netif_stop_queue(net);
> +		spin_unlock_irqrestore(&dev->req_lock, flags);
> +		return 1;
> +	}
> +
>  	req = container_of (dev->tx_reqs.next, struct usb_request, list);
>  	list_del (&req->list);
> +
> +	/* last request in list: stop queue */
>  	if (list_empty (&dev->tx_reqs))
>  		netif_stop_queue (net);
>  	spin_unlock_irqrestore(&dev->req_lock, flags);
> 
> 


