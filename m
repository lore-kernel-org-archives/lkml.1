Return-Path: <linux-kernel-owner+w=401wt.eu-S1752344AbZKHMvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbZKHMvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbZKHMvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:51:51 -0500
Received: from www84.your-server.de ([213.133.104.84]:54380 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbZKHMvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:51:51 -0500
Subject: Re: [PATCH] RFC x86_64 more accurate KSTK_ESP implementation
From: Stefani Seibold <stefani@seibold.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20091108113546.GN11372@elte.hu>
References: <1257233486.22553.6.camel@wall-e>
	 <20091103082843.GA27676@elte.hu> <1257239184.4889.15.camel@wall-e>
	 <1257409189.26874.18.camel@wall-e>  <20091108113546.GN11372@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 08 Nov 2009 13:51:06 +0100
Message-ID: <1257684666.20579.9.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 08.11.2009, 12:35 +0100 schrieb Ingo Molnar:
> * Stefani Seibold <stefani@seibold.net> wrote:
>  
> > +
> > +	if (((stkp < stk) || (stkp >= stk + THREAD_SIZE))
> > +	    && regs->ip < PAGE_OFFSET)
> > +		percpu_write(old_rsp, stkp);
> > +}
> 
> that check for regs->ip looks imprecise - why dont you use the 
> user_mode_vm()?
> 
> It's true that the value itself is statistical, but still we dont want 
> to leak a kernel-space regs->sp reason - it's an information leak.
> 

Good idea. Much better ;-)


> > --- linux-2.6.32-rc5.old/arch/x86/kernel/irq_64.c	2009-10-16 02:41:50.000000000 +0200
> > +++ linux-2.6.32-rc5.new/arch/x86/kernel/irq_64.c	2009-11-04 22:29:55.762951577 +0100
> > @@ -53,6 +53,7 @@
> >  	struct irq_desc *desc;
> >  
> >  	stack_overflow_check(regs);
> > +	update_usersp(regs);
> >
> >  
> >  	desc = irq_to_desc(irq);
> >  	if (unlikely(!desc))
> > --- linux-2.6.32-rc5.old/arch/x86/kernel/apic/apic.c	2009-10-16 02:41:50.000000000 +0200
> > +++ linux-2.6.32-rc5.new/arch/x86/kernel/apic/apic.c	2009-11-04 23:12:32.805086991 +0100
> > @@ -831,6 +831,9 @@
> >  {
> >  	struct pt_regs *old_regs = set_irq_regs(regs);
> >  
> > +#ifndef CONFIG_X86_32
> > +	update_usersp(regs);
> > +#endif
> 
> Cleanliness: please eliminate this #ifdef by defining update_usersp() on 
> 32-bit as well, as an empty inline function.
> 
> But, i dont like this patch because it adds overhead to the IRQ 
> fastpath.
> 

Agree, but i saw no other way.
 
> I'd suggest a competely different method: why dont you use an IPI to 
> sample the SP whenever someone wants to read it from /proc and we see 
> that the task is running on a CPU right now?
> 

Sounds like a challenge, i like the idea. I will have a look on it... 

Stefani


