Return-Path: <linux-kernel-owner+w=401wt.eu-S1752315AbZI1HJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbZI1HJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 03:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbZI1HJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 03:09:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:56677 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbZI1HJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 03:09:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,465,1249282800"; 
   d="scan'208";a="452159689"
Subject: Re: [BUGFIX -v2] x86, mce, inject: Make injected mce valid only
 during faked handler call
From: Huang Ying <ying.huang@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4AC05A57.1080505@jp.fujitsu.com>
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>
	 <4AC05A57.1080505@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 28 Sep 2009 15:09:13 +0800
Message-Id: <1254121753.15717.1373.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-28 at 14:40 +0800, Hidetoshi Seto wrote: 
> Hi Huang,
> 
> Huang Ying wrote:
> > In the current implementation, injected MCE is valid from the point
> > the MCE is injected to the point the MCE is processed by the faked
> > handler call.
> > 
> > This has an undesired side-effect: it is possible for it to be
> > consumed by real machine_check_poll. This may confuse a real system
> > error and may confuse the mce test suite.
> > 
> > To fix this, this patch introduces another flag MCJ_VALID to indicate
>                                                   ^^^^^^^^^
> MCJ_LOADED?

Sorry, will fix this.

> > that the MCE entry is valid for injector but not for the
> > handler. Another flag, mce.finished is used to indicate the MCE entry
> > is valid for the handler.
> > 
> > mce.finished is enabled only during faked MCE handler call and
> > protected by IRQ disabling. This make it impossible for real
> > machine_check_poll to consume it.
> 
> Are there the reverse case - is it possible that the faked handler
> call might consume real error which is not handled yet by the real
> machine_check_poll?

Yes. It's possible at least in theory. But whole mce-inject.c is used
for testing only. The faked handler call will not occur on real system.

> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > 
> > v2:
> > - Revise commit changelog (Thanks Ingo)
> > - Change naming (XX_BIT for bit definition)
> > 
> > ---
> >  arch/x86/include/asm/mce.h              |   17 +++++++++++------
> >  arch/x86/kernel/cpu/mcheck/mce-inject.c |   23 ++++++++++++++++-------
> >  2 files changed, 27 insertions(+), 13 deletions(-)
> > 
> > --- a/arch/x86/include/asm/mce.h
> > +++ b/arch/x86/include/asm/mce.h
> > @@ -38,13 +38,18 @@
> >  #define MCM_ADDR_MEM	 3	/* memory address */
> >  #define MCM_ADDR_GENERIC 7	/* generic */
> >  
> > -#define MCJ_CTX_MASK		3
> > +#define MCJ_NMI_BROADCAST_BIT	2    /* do NMI broadcasting */
> > +#define MCJ_EXCEPTION_BIT	3    /* raise as exception */
> > +#define MCJ_LOADED_BIT		4    /* entry is valid for injector */
> > +
> > +#define MCJ_CTX_MASK		0x03
> >  #define MCJ_CTX(flags)		((flags) & MCJ_CTX_MASK)
> > -#define MCJ_CTX_RANDOM		0    /* inject context: random */
> > -#define MCJ_CTX_PROCESS		1    /* inject context: process */
> > -#define MCJ_CTX_IRQ		2    /* inject context: IRQ */
> > -#define MCJ_NMI_BROADCAST	4    /* do NMI broadcasting */
> > -#define MCJ_EXCEPTION		8    /* raise as exception */
> > +#define MCJ_CTX_RANDOM		0x00    /* inject context: random */
> > +#define MCJ_CTX_PROCESS		0x01    /* inject context: process */
> > +#define MCJ_CTX_IRQ		0x02    /* inject context: IRQ */
> > +#define MCJ_NMI_BROADCAST	(1 << MCJ_NMI_BROADCAST_BIT)
> > +#define MCJ_EXCEPTION		(1 << MCJ_EXCEPTION_BIT)
> > +#define MCJ_LOADED		(1 << MCJ_LOADED_BIT)
> 
> I'd like to see a patch to replace MCJ_* to MCE_INJ_* before
> adding new flag.

MCX_ prefix is the naming convention used all over the mce.h, such as
MCG_, MCI_, MCM_, if we want to change MCJ_ into MCE_INJ_, we should
consider changing all these into similar style to keep consistent. 
  
> >  /* Fields are zero when not available */
> >  struct mce {
> > --- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
> > +++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
> > @@ -32,16 +32,16 @@ static void inject_mce(struct mce *m)
> >  
> >  	/* Make sure noone reads partially written injectm */
> >  	i->finished = 0;
> > +	clear_bit(MCJ_LOADED_BIT, (unsigned long *)&i->inject_flags);
> >  	mb();
> >  	m->finished = 0;
> > -	/* First set the fields after finished */
> > +	clear_bit(MCJ_LOADED_BIT, (unsigned long *)&m->inject_flags);
> >  	i->extcpu = m->extcpu;
> >  	mb();
> > -	/* Now write record in order, finished last (except above) */
> >  	memcpy(i, m, sizeof(struct mce));
> >  	/* Finally activate it */
> >  	mb();
> > -	i->finished = 1;
> > +	set_bit(MCJ_LOADED_BIT, (unsigned long *)&i->inject_flags);
> 
> Why
>   clear_bit(MCJ_LOADED_BIT, (unsigned long *)&m->inject_flags);
>   set_bit(MCJ_LOADED_BIT, (unsigned long *)&i->inject_flags);
> cannot be
>   m->inject_flags &= ~MCJ_LOADED;
>   m->inject_flags |= MCJ_LOADED;
> ?

Because they may be write on one CPU and read on another CPU, atomic
operation is safer for this.

> If it can, defined *_BIT will not be necessary here.
> 
> >  }
> >  
> >  static void raise_poll(struct mce *m)
> > @@ -51,9 +51,11 @@ static void raise_poll(struct mce *m)
> >  
> >  	memset(&b, 0xff, sizeof(mce_banks_t));
> >  	local_irq_save(flags);
> > +	m->finished = 1;
> >  	machine_check_poll(0, &b);
> > -	local_irq_restore(flags);
> >  	m->finished = 0;
> > +	clear_bit(MCJ_LOADED_BIT, (unsigned long *)&m->inject_flags);
> > +	local_irq_restore(flags);
> >  }
> 
> I think the "finished" is not good name. (I suppose it is named
> after "loading data to structure have been finished" or so.)

No. Its name is not invented for injecting. It stands for the MCE record
writing to mce log buffer has finished. That is, it is named according
to normal path, not testing path.

> And also I think "MCJ_LOADED" is not good name, because I could not
> figure out the difference between "loading finished" and "loaded."
> 
> OTOH in the course of nature mce_rdmsrl() returns injected data
> anytime if data is loaded, because it is defined to do so.
>     304 /* MSR access wrappers used for error injection */
>     305 static u64 mce_rdmsrl(u32 msr)
>     306 {
>     307         u64 v;
>     308
>     309         if (__get_cpu_var(injectm).finished) {
> 
> I believe what you want to do here is "make mce_rdmsrl()/mce_wrmsrl()
> to refer faked data only during faked handler call."
> Then what we have to do is making a flag to indicate that "now
> in faked handler call," for an example:
> 
>     309         if (__get_cpu_var(mce_fake_in_progress)) {
> 
> and:
> 	local_irq_save(flags);
> 	__get_cpu_var(mce_fake_in_progress) = 1;
> 	machine_check_poll(0, &b);
> 	__get_cpu_var(mce_fake_in_progress) = 0;
> 	local_irq_restore(flags);

I don't think this method is better than the original one. They are just
equivalent. 
  
> >  static void raise_exception(struct mce *m, struct pt_regs *pregs)
> > @@ -69,9 +71,11 @@ static void raise_exception(struct mce *
> >  	}
> >  	/* in mcheck exeception handler, irq will be disabled */
> >  	local_irq_save(flags);
> > +	m->finished = 1;
> >  	do_machine_check(pregs, 0);
> > -	local_irq_restore(flags);
> >  	m->finished = 0;
> > +	clear_bit(MCJ_LOADED_BIT, (unsigned long *)&m->inject_flags);
> > +	local_irq_restore(flags);
> >  }
> >  
> >  static cpumask_t mce_inject_cpumask;
> > @@ -89,6 +93,8 @@ static int mce_raise_notify(struct notif
> >  		raise_exception(m, args->regs);
> >  	else if (m->status)
> >  		raise_poll(m);
> > +	else
> > +		clear_bit(MCJ_LOADED_BIT, (unsigned long *)&m->inject_flags);
> >  	return NOTIFY_STOP;
> >  }
> >  
> > @@ -129,7 +135,7 @@ static int raise_local(void)
> >  		mce_notify_irq();
> >  		printk(KERN_INFO "Machine check poll done on CPU %d\n", cpu);
> >  	} else
> > -		m->finished = 0;
> > +		clear_bit(MCJ_LOADED_BIT, (unsigned long *)&m->inject_flags);
> >  
> >  	return ret;
> >  }
> > @@ -152,10 +158,13 @@ static void raise_mce(struct mce *m)
> >  		cpu_clear(get_cpu(), mce_inject_cpumask);
> >  		for_each_online_cpu(cpu) {
> >  			struct mce *mcpu = &per_cpu(injectm, cpu);
> > -			if (!mcpu->finished ||
> > +			if (!test_bit(MCJ_LOADED_BIT,
> > +				      (unsigned long *)&mcpu->inject_flags) ||
> >  			    MCJ_CTX(mcpu->inject_flags) != MCJ_CTX_RANDOM)
> >  				cpu_clear(cpu, mce_inject_cpumask);
> >  		}
> > +		/* make sure needed data is available on other CPUs */
> > +		smp_mb();
> 
> What data are you taking care here for?

For mce_inject_cpumask.

Best Regards,
Huang Ying


