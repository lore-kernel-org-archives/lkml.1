Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbXHAEN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbXHAEN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 00:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbXHAENT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 00:13:19 -0400
Received: from smtp3.Stanford.EDU ([171.67.20.26]:37663 "EHLO
	smtp3.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbXHAENS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 00:13:18 -0400
Subject: Re: [Fwd: [PlanetCCRMA] atl1 driver; sleeping function]
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Matt Barber <brbrofsvl@gmail.com>, nando@ccrma.Stanford.EDU
In-Reply-To: <20070731085122.GC14758@elte.hu>
References: <1185852942.32478.3.camel@cmn3.stanford.edu>
	 <20070731085122.GC14758@elte.hu>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 21:13:14 -0700
Message-Id: <1185941594.8994.13.camel@cmn3.stanford.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 10:51 +0200, Ingo Molnar wrote:
> * Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
> 
> > Hi Ingo, I'm forwading this report from a Planet CCRMA user, this is 
> > happening to him with 2.6.21.6-rt21...
> 
> thanks!

Thanks for the patch!
Looks like it fixed the problem Matt was having...
-- Fernando

-------- Forwarded Message --------
From: Matt Barbe
To: Fernando Lopez-Lezcano
Cc: planetccrma@ccrma.Stanford.EDU
Subject: Re: [PlanetCCRMA] atl1 driver; sleeping function
Date: Tue, 31 Jul 2007 22:50:28 -0400

The newly patched atl1 driver seems to be working fine.  I tried it
also in rt21.3 (that's the latest src.rpm in
http://ccrma.stanford.edu/planetccrma/mirror/all/linux/SRPMS/), and it
also worked fine -- I need kernel-rt-devel because I do use apps that
need nvidia drivers, and those are working fine in rt21.3 as well.  I
can keep you up to date if anything negative happens.

Thanks again,

Matt

> 
> > BUG: sleeping function called from invalid context IRQ-219(2243) at
> > kernel/rtmutex.c:613
> > in_atomic():0 [00000000], irqs_disabled():1
> >  [<c0405f88>] dump_trace+0x64/0x105
> >  [<c0406041>] show_trace_log_lvl+0x18/0x2c
> >  [<c040664e>] show_trace+0xf/0x11
> >  [<c04066cf>] dump_stack+0x12/0x14
> >  [<c060511d>] __rt_spin_lock+0x21/0x3d
> >  [<f8a20e0c>] atl1_xmit_frame+0x66f/0x6c6 [atl1]
> >  [<c05a3d96>] dev_hard_start_xmit+0x1c6/0x225
> >  [<c05b29bd>] __qdisc_run+0xb7/0x1cf
> 
> could you try the patch below, does it fix the problem? The atl1 driver 
> uses raw irq flags in combination with a spinlock that is a sleeping 
> lock on -rt. (this is valid code on upstream, fortunately the -rt fix is 
> also a cleanup and a small code reduction enhancement on upstream, so 
> there's no problem pushing such fixes upstream.)
> 
> 	Ingo
> 
> --------------------------->
> Subject: [patch] drivers/net/atl1/atl1_main.c: use spin_trylock_irqsave()
> From: Ingo Molnar <mingo@elte.hu>
> 
> use the simpler spin_trylock_irqsave() API to get the adapter lock.
> 
> [ this is also a fix for -rt where adapter->lock is a sleeping lock. ]
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/net/atl1/atl1_main.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> Index: linux-rt-rebase.q/drivers/net/atl1/atl1_main.c
> ===================================================================
> --- linux-rt-rebase.q.orig/drivers/net/atl1/atl1_main.c
> +++ linux-rt-rebase.q/drivers/net/atl1/atl1_main.c
> @@ -1704,10 +1704,8 @@ static int atl1_xmit_frame(struct sk_buf
>  		}
>  	}
>  
> -	local_irq_save(flags);
> -	if (!spin_trylock(&adapter->lock)) {
> +	if (!spin_trylock_irqsave(&adapter->lock, flags)) {
>  		/* Can't get lock - tell upper layer to requeue */
> -		local_irq_restore(flags);
>  		dev_printk(KERN_DEBUG, &adapter->pdev->dev, "tx locked\n");
>  		return NETDEV_TX_LOCKED;
>  	}

