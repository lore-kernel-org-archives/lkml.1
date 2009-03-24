Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbZCXVhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbZCXVhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZCXVgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:36:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50855
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754898AbZCXVge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:36:34 -0400
Date: Tue, 24 Mar 2009 14:36:22 -0700 (PDT)
Message-Id: <20090324.143622.186562202.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: mingo@elte.hu, r.schwebel@pengutronix.de, torvalds@linux-foundation.org,
       blaschka@linux.vnet.ibm.com, tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090324150928.GB30224@gondor.apana.org.au>
References: <20090324143303.GP5367@pengutronix.de>
	<20090324143942.GA20462@elte.hu>
	<20090324150928.GB30224@gondor.apana.org.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 24 Mar 2009 23:09:28 +0800

> On Tue, Mar 24, 2009 at 03:39:42PM +0100, Ingo Molnar wrote:
> >
> > Subject: [PATCH] net: Fix netpoll lockup in legacy receive path
> 
> Actually, this patch is still racy.  If some interrupt comes in
> and we suddenly get the maximum amount of backlog we can still
> hang when we call __napi_complete incorrectly.  It's unlikely
> but we certainly shouldn't allow that.  Here's a better version.
> 
> net: Fix netpoll lockup in legacy receive path

Hmmm...

> @@ -2588,9 +2588,10 @@ static int process_backlog(struct napi_struct *napi, int quota)
>  		local_irq_disable();
>  		skb = __skb_dequeue(&queue->input_pkt_queue);
>  		if (!skb) {
> +			list_del(&napi->poll_list);
> +			clear_bit(NAPI_STATE_SCHED, &napi->state);
>  			local_irq_enable();
> -			napi_complete(napi);
> -			goto out;
> +			break;
>  		}
>  		local_irq_enable();

I think the problem is that we need to do the GRO flush before the
list delete and clearing the NAPI_STATE_SCHED bit.

You can't disown the NAPI context until you've squared away the GRO
state, I think.

Ingo's case stresses TCP a lot so I think he's hitting these GRO
cases a lot as well as hitting the backlog maximum.

So this mis-ordering of completion operations could explain why
he still sees problems.
