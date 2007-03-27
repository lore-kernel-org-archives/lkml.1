Return-Path: <linux-kernel-owner+w=401wt.eu-S933045AbXC0V4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045AbXC0V4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 17:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934095AbXC0V4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 17:56:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:47717 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933045AbXC0V4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 17:56:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,335,1170662400"; 
   d="scan'208"; a="217510265:sNHT44273985"
Date: Tue, 27 Mar 2007 14:55:42 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       davej@codemonkey.org.uk, johnstul@us.ibm.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] Add support for deferrable timers (respun)
Message-ID: <20070327215542.GA27408@linux-os.sc.intel.com>
References: <200703212353.l2LNrNOj007453@shell0.pdx.osdl.net> <20070322140532.GA120@tv-sign.ru> <20070322151817.GA29840@linux-os.sc.intel.com> <20070322161355.GA160@tv-sign.ru> <20070327204344.GA21529@linux-os.sc.intel.com> <20070327211145.GB216@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070327211145.GB216@tv-sign.ru>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 01:11:45AM +0400, Oleg Nesterov wrote:
> On 03/27, Venki Pallipadi wrote:
> >
> >  	for (;;) {
> > -		base = timer->base;
> > +		tvec_base_t *prelock_base = timer->base;
> > +		base = timer_get_base(timer);
> >  		if (likely(base != NULL)) {
> >  			spin_lock_irqsave(&base->lock, *flags);
> > -			if (likely(base == timer->base))
> > +			if (likely(prelock_base == timer->base))
> >  				return base;
> 
> I don't think this is correct, at least in theory.
> 
> Suppose that
> 
> 	tvec_base_t *prelock_base = timer->base;
> 	base = timer_get_base(timer);
> 
> are re-ordered (the second LOAD happens after the first one), and the timer
> changes its base in between. Now, we lock the old base, and return it because
> "prelock_base == timer->base" == true.
> 

Great catch. Yes. this is a theoritical possibility, even though most compilers
would load base only once and use it for prelock_base and 'and' it for
base. Atleast that is what I see on i386/gcc.

Incremental patch below eliminates this race.

Index: new/kernel/timer.c
===================================================================
--- new.orig/kernel/timer.c	2007-03-26 15:19:35.000000000 -0800
+++ new/kernel/timer.c	2007-03-27 13:00:33.000000000 -0800
@@ -96,9 +96,9 @@
 	return tbase_get_deferrable(timer->base);
 }
 
-static inline struct tvec_t_base_s *timer_get_base(struct timer_list *timer)
+static inline struct tvec_t_base_s *tbase_get_base(struct tvec_t_base_s *base)
 {
-	return ((struct tvec_t_base_s *)((unsigned long)(timer->base) &
+	return ((struct tvec_t_base_s *)((unsigned long)base &
 	                                 ~TBASE_DEFERRABLE_FLAG));
 }
 
@@ -368,7 +368,7 @@
 
 	for (;;) {
 		tvec_base_t *prelock_base = timer->base;
-		base = timer_get_base(timer);
+		base = tbase_get_base(prelock_base);
 		if (likely(base != NULL)) {
 			spin_lock_irqsave(&base->lock, *flags);
 			if (likely(prelock_base == timer->base))
@@ -592,7 +592,7 @@
 	 * don't have to detach them individually.
 	 */
 	list_for_each_entry_safe(timer, tmp, &tv_list, entry) {
-		BUG_ON(timer_get_base(timer) != base);
+		BUG_ON(tbase_get_base(timer->base) != base);
 		internal_add_timer(base, timer);
 	}
 
