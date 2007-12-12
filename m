Return-Path: <linux-kernel-owner+w=401wt.eu-S1759469AbXLLQjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469AbXLLQjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 11:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757640AbXLLQjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 11:39:11 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45876 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757467AbXLLQjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 11:39:08 -0500
Date: Wed, 12 Dec 2007 08:36:48 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: David Miller <davem@davemloft.net>, joonwpark81@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       baum@tehutinetworks.net, andy@greyhouse.net
Subject: Re: [PATCH 6/7] [NETDEV]: tehuti Fix possible causing oops of
 net_rx_action
Message-ID: <20071212083648.13ab0aea@freepuppy.rosehill>
In-Reply-To: <20071212.072034.148833113.davem@davemloft.net>
References: <002901c83c73$b089b6e0$9c94fea9@jason>
	<20071211213939.122de1db@freepuppy.rosehill>
	<20071212.072034.148833113.davem@davemloft.net>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2007 07:20:34 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Stephen Hemminger <shemminger@linux-foundation.org>
> Date: Tue, 11 Dec 2007 21:39:39 -0800
> 
> > On Wed, 12 Dec 2007 13:01:27 +0900
> > "Joonwoo Park" <joonwpark81@gmail.com> wrote:
> > 
> > > [NETDEV]: tehuti Fix possible causing oops of net_rx_action
> > > 
> > > Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
> > > ---
> > >  drivers/net/tehuti.c |    2 ++
> > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/net/tehuti.c b/drivers/net/tehuti.c
> > > index 21230c9..955e749 100644
> > > --- a/drivers/net/tehuti.c
> > > +++ b/drivers/net/tehuti.c
> > > @@ -305,6 +305,8 @@ static int bdx_poll(struct napi_struct *napi, int budget)
> > >  
> > >  		netif_rx_complete(dev, napi);
> > >  		bdx_enable_interrupts(priv);
> > > +		if (unlikely(work_done == napi->weight))
> > > +			return work_done - 1;
> > >  	}
> > >  	return work_done;
> > >  }
> > 
> > A better fix would be not going over budget in the first place.
> 
> That's not the problem.
> 
> They are not going over the budget, rather, they are hitting
> the budget yet doing netif_rx_complete() as well which is
> illegal.
> 
> Unless you strictly process less than "weight" packets, you must
> not netif_rx_complete() and re-enable chip interrupts.
> 
> I can't believe people are trying to fix this bug like this.

Sorry, I was looking at a different possible problem. The issue
is that if netdev_budget was set smaller (say 128) but device
weight was set larger (say 256). The new code would still allow
the device to do a full swipe (256) packets rather than only
128 as in earlier NAPI. I guess it is an okay behaviour change, because
we don't really guarantee that case.

The problem with the tehuti driver is the logic around priv->napi_stop.
That whole early stop concept should be removed since it just
duplicates the logic of netdev->weight but breaks the assumptions
in the calling netif_rx_action.



-- 
Stephen Hemminger <shemminger@linux-foundation.org>
