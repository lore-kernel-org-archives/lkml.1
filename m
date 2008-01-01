Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbYAAUyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbYAAUyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 15:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbYAAUyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 15:54:13 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:17359 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbYAAUyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 15:54:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rdcmEtp1kXxRLOquKef1CE18x8lWxdps0lXaHEqKH+LJERQQIIay9CgDCyQVJiVaARiJ6vYGXRwgmqjh9HFq1Rbl0kG4EWANxqYJ4DfxRj0BJ3iB48QzH1nscaC34xtVv3vyDw1PzvVCH8TirQHSikkI0Dx4LBv+cHn8aNpzEm8=
Message-ID: <863e9df20801011254g12f30cces58d452cfeeb4350e@mail.gmail.com>
Date: Wed, 2 Jan 2008 02:24:09 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [PATCH] x86: kprobes change kprobe_handler flow
Cc: "Ingo Molnar" <mingo@elte.hu>, "Masami Hiramatsu" <mhiramat@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, qbarnes@gmail.com,
       ananth@in.ibm.com, jkenisto@us.ibm.com
In-Reply-To: <1199218777.6323.59.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1198806265.6323.34.camel@brick> <4778E8B0.6010400@gmail.com>
	 <20080101153558.GJ4434@elte.hu> <477A971A.8030006@gmail.com>
	 <1199218777.6323.59.camel@brick>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/2/08, Harvey Harrison <harvey.harrison@gmail.com> wrote:
> > +#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
> > +static __always_inline int setup_boost(struct kprobe *p, struct pt_regs *regs)
> > +{
> > +     if (p->ainsn.boostable == 1 && !p->post_handler) {
> > +             /* Boost up -- we can execute copied instructions directly */
> > +             reset_current_kprobe();
> > +             regs->ip = (unsigned long)p->ainsn.insn;
> > +             preempt_enable_no_resched();
> > +             return 0;
> > +     }
> > +     return 1;
> > +}
> > +#else
> > +static __always_inline int setup_boost(struct kprobe *p, struct pt_regs *regs)
> > +{
> > +     return 1;
> > +}
> > +#endif
> > +
> In the kernel __always_inline == inline, also I think it's nicer to only
> have one function declaration, and then ifdef the body of the function.
>
> Something like:
>
> static inline int setup_boost(struct kprobe *p, struct pt_regs *regs)
> {
> #if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
>         if (p->ainsn.boostable == 1 && !p->post_handler) {
>                 /* Boost up -- we can execute copied instructions directly */
>                 reset_current_kprobe();
>                 regs->ip = (unsigned long)p->ainsn.insn;
>                 preempt_enable_no_resched();
>                 return 0;
>         }
> #endif
>         return 1;
> }

Ok...will include this after I pick up some more comments.

> >  static int __kprobes kprobe_handler(struct pt_regs *regs)
> >  {
> > -     struct kprobe *p;
> >       int ret = 0;
> >       kprobe_opcode_t *addr;
> > +     struct kprobe *p, *cur;
> >       struct kprobe_ctlblk *kcb;
> >
> >       addr = (kprobe_opcode_t *)(regs->ip - sizeof(kprobe_opcode_t));
> > +     if (*addr != BREAKPOINT_INSTRUCTION) {
> > +             /*
> > +              * The breakpoint instruction was removed right
> > +              * after we hit it.  Another cpu has removed
> > +              * either a probepoint or a debugger breakpoint
> > +              * at this address.  In either case, no further
> > +              * handling of this interrupt is appropriate.
> > +              * Back up over the (now missing) int3 and run
> > +              * the original instruction.
> > +              */
> > +             regs->ip = (unsigned long)addr;
> > +             return 1;
> > +     }
>
> This return is fine I guess, but after the preempt_disable() I like
> the goto approach as it will be easier to see what paths enable
> preemption again and which don't....bonus points if we can move this
> to the caller or make sure we reenable in all cases before returning
> and pull in the code in the caller that does this for us.
>
> But I guess your approach of using ret to test whether we need to
> reenable preemption or not would work as a signal to the caller that
> they need to reenable preemption.

Hmm...since enabling preemption is tied to 'ret', anyone reading
kprobe_handler will have to follow around all calls which modify it.
There are some checks in the current kprobe_handler definition made
just to do what you're saying, i.e, to push all preemption
enable/disables in krpobe_handler. LIke this one (from the current x86
kprobe_handler):

------------
ret = reenter_kprobe(p, regs, kcb);
if (kcb->kprobe_status == KPROBE_REENTER)
{
    ret = 1;
    goto out;
}
goto preempt_out;

-------------

This is just confusing because we're not actually making any
exceptions here for the KPROBE_REENTER case (which has been partially
handled in reenter_kprobe), rather just tricking our way out of
preemption enabling for a cpl of cases in reenter_kprobe.

> Cheers,
>
> Harvey

Thanks,
Abhishek
