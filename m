Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbZKCJGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbZKCJGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 04:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbZKCJGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 04:06:43 -0500
Received: from www84.your-server.de ([213.133.104.84]:36736 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967AbZKCJGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 04:06:40 -0500
Subject: Re: [PATCH] update fix X86_64 procfs provide stack information for
 threads
From: Stefani Seibold <stefani@seibold.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20091103082843.GA27676@elte.hu>
References: <1257233486.22553.6.camel@wall-e>
	 <20091103082843.GA27676@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 03 Nov 2009 10:06:24 +0100
Message-ID: <1257239184.4889.15.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 03.11.2009, 09:28 +0100 schrieb Ingo Molnar:
> > --- linux-2.6.32-rc5/arch/x86/include/asm/processor.h	2009-10-16 02:41:50.000000000 +0200
> > +++ linux-2.6.32-rc5.new/arch/x86/include/asm/processor.h	2009-11-02 10:39:47.177909657 +0100
> > @@ -1000,7 +1001,13 @@
> >  #define thread_saved_pc(t)	(*(unsigned long *)((t)->thread.sp - 8))
> >  
> >  #define task_pt_regs(tsk)	((struct pt_regs *)(tsk)->thread.sp0 - 1)
> > -#define KSTK_ESP(tsk)		-1 /* sorry. doesn't work for syscall. */
> > +
> > +#ifdef CONFIG_IA32_EMULATION
> > +extern unsigned long KSTK_ESP(struct task_struct *task);
> > +#else
> > +#define KSTK_ESP(task)		((task)->thread.usersp)
> > +#endif
> > +
> >  #endif /* CONFIG_X86_64 */
> >  
> >  extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
> > --- linux-2.6.32-rc5/arch/x86/kernel/process_64.c	2009-10-16 02:41:50.000000000 +0200
> > +++ linux-2.6.32-rc5.new/arch/x86/kernel/process_64.c	2009-11-02 10:48:23.614936810 +0100
> > @@ -664,3 +669,11 @@
> >  	return do_arch_prctl(current, code, addr);
> >  }
> >  
> > +#ifdef CONFIG_IA32_EMULATION
> > +unsigned long KSTK_ESP(struct task_struct *task)
> > +{
> > +	return (test_tsk_thread_flag(task, TIF_IA32)) ? \
> > +			(task_pt_regs(task)->sp) : \
> > +			((task)->thread.usersp);
> > +}
> > +#endif
> 
> That's quite ugly. The KSTK_ESP() function should be unconditional and 
> the #ifdef should be eliminated. If CONFIG_IA32_EMULATION is turned off 
> (whichis rare) then TIF_IA32 wont be set so the function should work 
> fine.
> 
> Thanks,
> 
> 	Ingo

Hi Ingo,

come on, thats not fair. This would be not the only piece of ugly code
in the x86_64 implementation. It is much better than the previous hack
where KSTK_ESP always returns a wrong hard coded value. That is really
ugly!!!!

It took me 6 hours to analyze the x64_64 code, most of them written in
assembler. I think it is a first solution, which makes the procfs stack
information work on this architecture and that was the goal.

I will remove the #ifdef's and repost the patch. Please accept this
patch, which make the KSTP_ESP thing on x86_64 better as before.

I am not a x64_64 bit hacker, i have not the knowledge to make a perfect
solution for this architecture. Also i am not a full time kernel hacker,
i have customers who wait for their projects.

Greeting,
Stefani


