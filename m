Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbZCXWsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbZCXWsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbZCXWr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:47:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51495
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751204AbZCXWr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:47:56 -0400
Date: Tue, 24 Mar 2009 15:47:43 -0700 (PDT)
Message-Id: <20090324.154743.200977253.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: mingo@elte.hu, r.schwebel@pengutronix.de, torvalds@linux-foundation.org,
       blaschka@linux.vnet.ibm.com, tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090324.143622.186562202.davem@davemloft.net>
References: <20090324143942.GA20462@elte.hu>
	<20090324150928.GB30224@gondor.apana.org.au>
	<20090324.143622.186562202.davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 24 Mar 2009 14:36:22 -0700 (PDT)

> From: Herbert Xu <herbert@gondor.apana.org.au>
> Date: Tue, 24 Mar 2009 23:09:28 +0800
> 
> > @@ -2588,9 +2588,10 @@ static int process_backlog(struct napi_struct *napi, int quota)
> >  		local_irq_disable();
> >  		skb = __skb_dequeue(&queue->input_pkt_queue);
> >  		if (!skb) {
> > +			list_del(&napi->poll_list);
> > +			clear_bit(NAPI_STATE_SCHED, &napi->state);
> >  			local_irq_enable();
> > -			napi_complete(napi);
> > -			goto out;
> > +			break;
> >  		}
> >  		local_irq_enable();
> 
> I think the problem is that we need to do the GRO flush before the
> list delete and clearing the NAPI_STATE_SCHED bit.

Ok Herbert, I'm even more sure of this because in your original commit
log message you mention:

	This simply doesn't work since we need to flush the held
	GRO packets first.

We are certainly in a pickle here, actually.

We can't run the GRO flush until we re-enable interrupts.  But if we
re-enable interrupts, more packets get queued to the input_pkt_queue
and we end up back where we started.
