Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbZHBT1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbZHBT1c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 15:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbZHBT1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 15:27:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49030 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361AbZHBT1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 15:27:30 -0400
Date: Sun, 2 Aug 2009 21:26:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: paulmck@linux.vnet.ibm.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/debug] debug lockups: Improve lockup detection
Message-ID: <20090802192657.GA21882@elte.hu>
References: <tip-c1dc0b9c0c8979ce4d411caadff5c0d79dee58bc@git.kernel.org> <20090802114545.f1520c81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090802114545.f1520c81.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 2 Aug 2009 13:09:34 GMT tip-bot for Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Commit-ID:  c1dc0b9c0c8979ce4d411caadff5c0d79dee58bc
> > Gitweb:     http://git.kernel.org/tip/c1dc0b9c0c8979ce4d411caadff5c0d79dee58bc
> > Author:     Ingo Molnar <mingo@elte.hu>
> > AuthorDate: Sun, 2 Aug 2009 11:28:21 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sun, 2 Aug 2009 13:27:17 +0200
> > 
> > --- a/drivers/char/sysrq.c
> > +++ b/drivers/char/sysrq.c
> > @@ -24,6 +24,7 @@
> >  #include <linux/sysrq.h>
> >  #include <linux/kbd_kern.h>
> >  #include <linux/proc_fs.h>
> > +#include <linux/nmi.h>
> >  #include <linux/quotaops.h>
> >  #include <linux/perf_counter.h>
> >  #include <linux/kernel.h>
> > @@ -222,12 +223,7 @@ static DECLARE_WORK(sysrq_showallcpus, sysrq_showregs_othercpus);
> >  
> >  static void sysrq_handle_showallcpus(int key, struct tty_struct *tty)
> >  {
> > -	struct pt_regs *regs = get_irq_regs();
> > -	if (regs) {
> > -		printk(KERN_INFO "CPU%d:\n", smp_processor_id());
> > -		show_regs(regs);
> > -	}
> > -	schedule_work(&sysrq_showallcpus);
> > +	trigger_all_cpu_backtrace();
> >  }
> 
> I think this just broke all non-x86 non-sparc SMP architectures.

Yeah - it 'broke' them in the sense of them not having a working 
trigger_all_cpu_backtrace() implementation to begin with. (which 
breaks/degrades spinlock-debug to begin with so it's an existing 
problem)

One solution would be to do a generic trigger_all_cpu_backtrace() 
implementation that does the above schedule_work() approach.

I never understood why we proliferated all these different 
backtrace-triggering mechanisms instead of doing one good approach 
that everything uses.

> >  static struct sysrq_key_op sysrq_showallcpus_op = {
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 7717b95..9c5fa9f 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -35,6 +35,7 @@
> >  #include <linux/rcupdate.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/sched.h>
> > +#include <linux/nmi.h>
> >  #include <asm/atomic.h>
> >  #include <linux/bitops.h>
> >  #include <linux/module.h>
> > @@ -469,6 +470,8 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
> >  	}
> >  	printk(" (detected by %d, t=%ld jiffies)\n",
> >  	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
> > +	trigger_all_cpu_backtrace();
> 
> Be aware that trigger_all_cpu_backtrace() is a PITA when you have 
> a lot of CPUs.
> 
> If a callsite is careful to ensure that the most important 
> information is emitted last then that might improve things.
> 
> otoh, log buffer overflow will truncate, I think.  So that info 
> needs to be emitted first too ;)
> 
> It's a PITA.

Yeah, it is - i'd expect larger systems to have larger log buffers. 
Lack of info was obviously a showstopper with the highest priority.

	Ingo
