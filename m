Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbYJFJnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbYJFJnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 05:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbYJFJnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 05:43:43 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37338 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752439AbYJFJnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 05:43:43 -0400
Message-Id: <1223286222.26001.1277718971@webmail.messagingengine.com>
X-Sasl-Enc: 5jOmKrgOX2zwGgtI0aECiSySr7DpZUG6b3bK3pQVgK23 1223286222
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: Louis.Rilling@kerlabs.com
Cc: "Ingo Molnar" <mingo@elte.hu>, "LKML" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1223154766-19350-1-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-2-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-3-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-4-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-5-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-6-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-7-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-8-git-send-email-heukelum@fastmail.fm>
 <20081006093529.GA29198@hawkmoon.kerlabs.com>
Subject: Re: [PATCH] dumpstack: x86: various small unification steps
In-Reply-To: <20081006093529.GA29198@hawkmoon.kerlabs.com>
Date: Mon, 06 Oct 2008 11:43:42 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2008 11:35:29 +0200, "Louis Rilling"
<Louis.Rilling@kerlabs.com> said:
> On Sat, Oct 04, 2008 at 11:12:46PM +0200, Alexander van Heukelum wrote:
> >  - define STACKSLOTS_PER_LINE and use it
> >  - define get_bp macro to hide the %%ebp/%%rbp difference
> >  - i386: check task==NULL in dump_trace, like x86_64
> >  - i386: show_trace(NULL, ...) uses current automatically
> >  - x86_64: use [#%d] for die_counter, like i386
> >  - whitespace and comments
> > 
> [...]
> 
> > diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
> > index 6ac80f0..ddc8a38 100644
> > --- a/arch/x86/kernel/dumpstack_64.c
> > +++ b/arch/x86/kernel/dumpstack_64.c
> > @@ -16,8 +16,11 @@
> >  
> >  #include <asm/stacktrace.h>
> >  
> > +#define STACKSLOTS_PER_LINE 4
> > +#define get_bp(bp) asm("movl %%rbp, %0" : "=r" (bp) :)
>                            ^^^^
> Should be movq.

Hi Louis,

You're right. A fix has been sent and applied already, though.

Thanks,
    Alexander

> Louis
> 
> >  int panic_on_unrecovered_nmi;
> > -int kstack_depth_to_print = 12;
> > +int kstack_depth_to_print = 3 * STACKSLOTS_PER_LINE;
> >  static unsigned int code_bytes = 64;
> >  static int die_counter;
> >  
> > @@ -177,7 +180,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
> >  	if (!bp) {
> >  		if (task == current) {
> >  			/* Grab bp right from our regs */
> > -			asm("movq %%rbp, %0" : "=r" (bp) : );
> > +			get_bp(bp);
> >  		} else {
> >  			/* bp is the last reg pushed by switch_to */
> >  			bp = *(unsigned long *) task->thread.sp;
> > @@ -329,7 +332,7 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
> >  		if (((long) stack & (THREAD_SIZE-1)) == 0)
> >  			break;
> >  		}
> > -		if (i && ((i % 4) == 0))
> > +		if (i && ((i % STACKSLOTS_PER_LINE) == 0))
> >  			printk("\n%s", log_lvl);
> >  		printk(" %016lx", *stack++);
> >  		touch_nmi_watchdog();
> > @@ -353,7 +356,7 @@ void dump_stack(void)
> >  
> >  #ifdef CONFIG_FRAME_POINTER
> >  	if (!bp)
> > -		asm("movq %%rbp, %0" : "=r" (bp) : );
> > +		get_bp(bp);
> >  #endif
> >  
> >  	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
> > @@ -396,7 +399,7 @@ void show_registers(struct pt_regs *regs)
> >  
> >  		ip = (u8 *)regs->ip - code_prologue;
> >  		if (ip < (u8 *)PAGE_OFFSET || probe_kernel_address(ip, c)) {
> > -			/* try starting at RIP */
> > +			/* try starting at IP */
> >  			ip = (u8 *)regs->ip;
> >  			code_len = code_len - code_prologue + 1;
> >  		}
> > @@ -477,7 +480,7 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
> >  
> >  int __kprobes __die(const char *str, struct pt_regs *regs, long err)
> >  {
> > -	printk(KERN_EMERG "%s: %04lx [%u] ", str, err & 0xffff, ++die_counter);
> > +	printk(KERN_EMERG "%s: %04lx [#%d] ", str, err & 0xffff, ++die_counter);
> >  #ifdef CONFIG_PREEMPT
> >  	printk("PREEMPT ");
> >  #endif
> > -- 
> > 1.5.4.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
> Dr Louis Rilling			Kerlabs
> Skype: louis.rilling			Batiment Germanium
> Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
> http://www.kerlabs.com/			35700 Rennes
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - IMAP accessible web-mail

