Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbXLLPUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbXLLPUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbXLLPUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:20:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45154
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754075AbXLLPUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:20:38 -0500
Date: Wed, 12 Dec 2007 07:20:34 -0800 (PST)
Message-Id: <20071212.072034.148833113.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: joonwpark81@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       baum@tehutinetworks.net, andy@greyhouse.net
Subject: Re: [PATCH 6/7] [NETDEV]: tehuti Fix possible causing oops of
 net_rx_action
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071211213939.122de1db@freepuppy.rosehill>
References: <002901c83c73$b089b6e0$9c94fea9@jason>
	<20071211213939.122de1db@freepuppy.rosehill>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Tue, 11 Dec 2007 21:39:39 -0800

> On Wed, 12 Dec 2007 13:01:27 +0900
> "Joonwoo Park" <joonwpark81@gmail.com> wrote:
> 
> > [NETDEV]: tehuti Fix possible causing oops of net_rx_action
> > 
> > Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
> > ---
> >  drivers/net/tehuti.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/net/tehuti.c b/drivers/net/tehuti.c
> > index 21230c9..955e749 100644
> > --- a/drivers/net/tehuti.c
> > +++ b/drivers/net/tehuti.c
> > @@ -305,6 +305,8 @@ static int bdx_poll(struct napi_struct *napi, int budget)
> >  
> >  		netif_rx_complete(dev, napi);
> >  		bdx_enable_interrupts(priv);
> > +		if (unlikely(work_done == napi->weight))
> > +			return work_done - 1;
> >  	}
> >  	return work_done;
> >  }
> 
> A better fix would be not going over budget in the first place.

That's not the problem.

They are not going over the budget, rather, they are hitting
the budget yet doing netif_rx_complete() as well which is
illegal.

Unless you strictly process less than "weight" packets, you must
not netif_rx_complete() and re-enable chip interrupts.

I can't believe people are trying to fix this bug like this.
