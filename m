Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbXC0WhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbXC0WhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 18:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbXC0WhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 18:37:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:39074 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbXC0WhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 18:37:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,335,1170662400"; 
   d="scan'208"; a="220434931:sNHT23650991"
Date: Tue, 27 Mar 2007 15:36:25 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       davej@codemonkey.org.uk, johnstul@us.ibm.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] Add support for deferrable timers (respun)
Message-ID: <20070327223625.GA30923@linux-os.sc.intel.com>
References: <200703212353.l2LNrNOj007453@shell0.pdx.osdl.net> <20070322140532.GA120@tv-sign.ru> <20070322151817.GA29840@linux-os.sc.intel.com> <20070322161355.GA160@tv-sign.ru> <20070327204344.GA21529@linux-os.sc.intel.com> <20070327211145.GB216@tv-sign.ru> <20070327215542.GA27408@linux-os.sc.intel.com> <20070327222227.GA279@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070327222227.GA279@tv-sign.ru>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 02:22:27AM +0400, Oleg Nesterov wrote:
> On 03/27, Venki Pallipadi wrote:
> >
> > @@ -368,7 +368,7 @@
> >  
> >  	for (;;) {
> >  		tvec_base_t *prelock_base = timer->base;
> > -		base = timer_get_base(timer);
> > +		base = tbase_get_base(prelock_base);
> >  		if (likely(base != NULL)) {
> >  			spin_lock_irqsave(&base->lock, *flags);
> >  			if (likely(prelock_base == timer->base))
> 
> Looks correct to me... Personally, I'd prefer
> 
> 	static tvec_base_t *lock_timer_base(struct timer_list *timer,
> 						unsigned long *flags)
> 		__acquires(timer->base->lock)
> 	{
> 		tvec_base_t *base;
> 
> 		for (;;) {
> 			base = timer_get_base(timer);
> 			if (likely(base != NULL)) {
> 				spin_lock_irqsave(&base->lock, *flags);
> 				if (likely(base == timer_get_base(timer))
> 					return base;
> 				/* The timer has migrated to another CPU */
> 				spin_unlock_irqrestore(&base->lock, *flags);
> 			}
> 			cpu_relax();
> 		}
> 	}
> 
> but this is a matter of taste.

I thought about this. But, chose the other one just to save one additional
'and' overhead.


> 
> A minor nitpick,
> 
> > +/* new_base is guaranteed to have last bit not set, in all callers below */
> > +static inline void timer_set_base(struct timer_list *timer,
> > +                                       struct tvec_t_base_s *old_base,
> > +                                       struct tvec_t_base_s *new_base)
> > +{
> > +       timer->base = (struct tvec_t_base_s *)((unsigned long)(new_base) |
> > +                                              tbase_get_deferrable(old_base));
> > +}
> 
> looks a little bit ugly, but may be this is just me. How about
> 
> 	void timer_set_base(struct timer_list *timer, struct tvec_t_base_s *new_base)
> 	{
> 		timer->base = (struct tvec_t_base_s *)
> 			((unsigned long)(new_base) | tbase_get_deferrable(timer->base));
> 	}
> 
> __mod_timer:
> 	-	tvec_base_t *old_base = timer->base;
> 	-	timer->base = NULL;
> 	+	timer_set_base(timer, NULL);
>
> ?

I agree the above suggestion is clean. But, it will have one additional 'and'
operation when we set NULL. I saw some concern from Andrew earlier on overhead
this patch was adding.

> 
> > +                       /* Make sure that tvec_base is 2 byte aligned */
> > +                       if (tbase_get_deferrable(base)) {
> > +                               WARN_ON(1);
> > +                               kfree(base);
> > +                               return -ENOMEM;
> > +                       }
> 
> Not a comment, but a question: do we really need this?

AFAIK, kmalloc_node should return an even address always. I was just being
paranoid and wanted to assert it here as otherwise some normal timer may end up
being deferred timer.

Thanks,
Venki
