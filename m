Return-Path: <linux-kernel-owner+w=401wt.eu-S1754385AbZKCSQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbZKCSQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 13:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZKCSQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 13:16:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45722 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbZKCSQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 13:16:35 -0500
Date: Tue, 3 Nov 2009 19:16:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] update fix X86_64 procfs provide stack information for
	threads
Message-ID: <20091103181626.GB19715@elte.hu>
References: <1257233486.22553.6.camel@wall-e> <20091103082843.GA27676@elte.hu> <1257239184.4889.15.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257239184.4889.15.camel@wall-e>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Stefani Seibold <stefani@seibold.net> wrote:

> Am Dienstag, den 03.11.2009, 09:28 +0100 schrieb Ingo Molnar:
> > > --- linux-2.6.32-rc5/arch/x86/include/asm/processor.h	2009-10-16 02:41:50.000000000 +0200
> > > +++ linux-2.6.32-rc5.new/arch/x86/include/asm/processor.h	2009-11-02 10:39:47.177909657 +0100
> > > @@ -1000,7 +1001,13 @@
> > >  #define thread_saved_pc(t)	(*(unsigned long *)((t)->thread.sp - 8))
> > >  
> > >  #define task_pt_regs(tsk)	((struct pt_regs *)(tsk)->thread.sp0 - 1)
> > > -#define KSTK_ESP(tsk)		-1 /* sorry. doesn't work for syscall. */
> > > +
> > > +#ifdef CONFIG_IA32_EMULATION
> > > +extern unsigned long KSTK_ESP(struct task_struct *task);
> > > +#else
> > > +#define KSTK_ESP(task)		((task)->thread.usersp)
> > > +#endif
> > > +
> > >  #endif /* CONFIG_X86_64 */
> > >  
> > >  extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
> > > --- linux-2.6.32-rc5/arch/x86/kernel/process_64.c	2009-10-16 02:41:50.000000000 +0200
> > > +++ linux-2.6.32-rc5.new/arch/x86/kernel/process_64.c	2009-11-02 10:48:23.614936810 +0100
> > > @@ -664,3 +669,11 @@
> > >  	return do_arch_prctl(current, code, addr);
> > >  }
> > >  
> > > +#ifdef CONFIG_IA32_EMULATION
> > > +unsigned long KSTK_ESP(struct task_struct *task)
> > > +{
> > > +	return (test_tsk_thread_flag(task, TIF_IA32)) ? \
> > > +			(task_pt_regs(task)->sp) : \
> > > +			((task)->thread.usersp);
> > > +}
> > > +#endif
> > 
> > That's quite ugly. The KSTK_ESP() function should be unconditional and 
> > the #ifdef should be eliminated. If CONFIG_IA32_EMULATION is turned off 
> > (whichis rare) then TIF_IA32 wont be set so the function should work 
> > fine.
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> Hi Ingo,
> 
> come on, thats not fair. [...]

(Hacking the kernel is rarely 'fair' in the way you seem to be defining 
it.)

> [...] This would be not the only piece of ugly code in the x86_64 
> implementation. It is much better than the previous hack where 
> KSTK_ESP always returns a wrong hard coded value. That is really 
> ugly!!!!
> 
> It took me 6 hours to analyze the x64_64 code, most of them written in 
> assembler. I think it is a first solution, which makes the procfs 
> stack information work on this architecture and that was the goal.
> 
> I will remove the #ifdef's and repost the patch. Please accept this 
> patch, which make the KSTP_ESP thing on x86_64 better as before.
> 
> I am not a x64_64 bit hacker, i have not the knowledge to make a 
> perfect solution for this architecture. Also i am not a full time 
> kernel hacker, i have customers who wait for their projects.

The cleanup isnt really that hard at all, writng your mail probably took 
more time. I didnt see you complain when we merged your original procfs 
patch that introduced/exposed this whole issue:

 d899bf7: procfs: provide stack information for threads

Fixing followup issues is standard part of the work-with-upstream 
fairness equation.

	Ingo
