Return-Path: <linux-kernel-owner+w=401wt.eu-S966766AbXJSIQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966766AbXJSIQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 04:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764008AbXJSIP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 04:15:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47045 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764183AbXJSIP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 04:15:56 -0400
Subject: Re: [NET]: Fix possible dev_deactivate race condition
From: Peter Zijlstra <peterz@infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20071019053624.GA10560@gondor.apana.org.au>
References: <E1IiWnJ-0000ne-00@gondolin.me.apana.org.au>
	 <1192745137.7367.40.camel@pasglop>
	 <alpine.LFD.0.999.0710181549330.26902@woody.linux-foundation.org>
	 <1192749449.7367.51.camel@pasglop>
	 <alpine.LFD.0.999.0710181627091.26902@woody.linux-foundation.org>
	 <20071019023219.GB8453@gondor.apana.org.au>
	 <alpine.LFD.0.999.0710181941020.26902@woody.linux-foundation.org>
	 <alpine.LFD.0.999.0710182007170.26902@woody.linux-foundation.org>
	 <20071019042025.GA9617@gondor.apana.org.au>
	 <20071019053624.GA10560@gondor.apana.org.au>
Content-Type: text/plain
Date: Fri, 19 Oct 2007 09:35:19 +0200
Message-Id: <1192779319.27435.163.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-19 at 13:36 +0800, Herbert Xu wrote:
> On Fri, Oct 19, 2007 at 12:20:25PM +0800, Herbert Xu wrote:
> >
> > In fact this bug exists elsewhere too.  For example, the network
> > stack does this in net/sched/sch_generic.c:
> > 
> >         /* Wait for outstanding qdisc_run calls. */
> >       while (test_bit(__LINK_STATE_QDISC_RUNNING, &dev->state))
> >               yield();
> > 
> > This has the same problem as the current synchronize_irq code.
> 

> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index e01d576..b3b7420 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -556,6 +556,7 @@ void dev_deactivate(struct net_device *dev)
>  {
>         struct Qdisc *qdisc;
>         struct sk_buff *skb;
> +       int running;
>  
>         spin_lock_bh(&dev->queue_lock);
>         qdisc = dev->qdisc;
> @@ -571,12 +572,31 @@ void dev_deactivate(struct net_device *dev)
>  
>         dev_watchdog_down(dev);
>  
> -       /* Wait for outstanding dev_queue_xmit calls. */
> +       /* Wait for outstanding qdisc-less dev_queue_xmit calls. */
>         synchronize_rcu();
>  
>         /* Wait for outstanding qdisc_run calls. */
> -       while (test_bit(__LINK_STATE_QDISC_RUNNING, &dev->state))
> -               yield();
> +       do {
> +               while (test_bit(__LINK_STATE_QDISC_RUNNING, &dev->state))
> +                       yield();
> +

Ouch!, is there really no sane locking alternative? Hashed waitqueues
like for the page lock come to mind.

> +               /*
> +                * Double-check inside queue lock to ensure that all effects
> +                * of the queue run are visible when we return.
> +                */
> +               spin_lock_bh(&dev->queue_lock);
> +               running = test_bit(__LINK_STATE_QDISC_RUNNING, &dev->state);
> +               spin_unlock_bh(&dev->queue_lock);
> +
> +               /*
> +                * The running flag should never be set at this point because
> +                * we've already set dev->qdisc to noop_qdisc *inside* the same
> +                * pair of spin locks.  That is, if any qdisc_run starts after
> +                * our initial test it should see the noop_qdisc and then
> +                * clear the RUNNING bit before dropping the queue lock.  So
> +                * if it is set here then we've found a bug.
> +                */
> +       } while (WARN_ON_ONCE(running));
>  }
>  
>  void dev_init_scheduler(struct net_device *dev) 

