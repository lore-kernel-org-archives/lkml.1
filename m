Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbYAAUYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbYAAUYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 15:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbYAAUYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 15:24:08 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:28687 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbYAAUYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 15:24:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G1nButNQbj5ux/0nOvmhheo7WH5NJXzVZMLK5HXblnX2hIsf0YfFGW5HyH1gC5QJLSgfmuXyPvdIDHA/BSwEp3uXzH3f/3p1Unz1UbSTBAI86Y8i0z95uUF0FZPjUbf9r+xD6LN1tRqHePyHjzjxjsrr5JotALOhDQA7Dzp2phA=
Message-ID: <863e9df20801011224g8a3111dg1b09ce6726759d97@mail.gmail.com>
Date: Wed, 2 Jan 2008 01:54:04 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Masami Hiramatsu" <mhiramat@redhat.com>
Subject: Re: [PATCH] x86: kprobes change kprobe_handler flow
Cc: "Harvey Harrison" <harvey.harrison@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, qbarnes@gmail.com,
       ananth@in.ibm.com, jkenisto@us.ibm.com
In-Reply-To: <477A7D1F.8020703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1198806265.6323.34.camel@brick> <4778E8B0.6010400@gmail.com>
	 <477A7D1F.8020703@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/1/08, Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Could you separate changing logic from cleanup and explain
> why the logic should be changed?

The major portion of logical changes is re-routing of code flow by
removing gotos. Hopefully all the cases have been covered. There are a
couple of changes that I'd like to address (see below).

> > +static __always_inline void setup_singlestep(struct kprobe *p,
> > +                                          struct pt_regs *regs,
> > +                                          struct kprobe_ctlblk *kcb)
> > +{
> > +#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
> > +     if (p->ainsn.boostable == 1 && !p->post_handler) {
> > +             /* Boost up -- we can execute copied instructions directly */
> > +             reset_current_kprobe();
> > +             regs->eip = (unsigned long)p->ainsn.insn;
> > +             preempt_enable_no_resched();
> > +     } else {
> > +             prepare_singlestep(p, regs);
> > +             kcb->kprobe_status = KPROBE_HIT_SS;
> > +     }
> > +#else
> > +     prepare_singlestep(p, regs);
> > +     kcb->kprobe_status = KPROBE_HIT_SS;
>
> please avoid code duplication.

I've addressed it in the latest patch.

> >  static int __kprobes kprobe_handler(struct pt_regs *regs)
> >  {
> > -     struct kprobe *p;
> >       int ret = 0;
> >       kprobe_opcode_t *addr;
> > +     struct kprobe *p, *cur;
> >       struct kprobe_ctlblk *kcb;
> >
> >       addr = (kprobe_opcode_t *)(regs->eip - sizeof(kprobe_opcode_t));
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
> > +             regs->eip -= sizeof(kprobe_opcode_t);
> > +             return 1;
> > +     }

I have moved the above breakpoint removal check at the beginning of
the function. The current check is for '!p' case only, whereas IMO
this check should be performed for all cases. An external debugger may
very well plant and remove a breakpoint on an address which has probe
on it. This check is a race nevertheless, so its relative placing
within kprobe_handler() would be best where its duplication can be
avoided.

> >
> > -     /* Check we're not actually recursing */
> > -     if (kprobe_running()) {
> > -             p = get_kprobe(addr);
> > -             if (p) {
> > -                     if (kcb->kprobe_status == KPROBE_HIT_SS &&
> > -                             *p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
> > -                             regs->eflags &= ~TF_MASK;
> > -                             regs->eflags |= kcb->kprobe_saved_eflags;
> > -                             goto no_kprobe;
> > -                     }
> > -                     /* We have reentered the kprobe_handler(), since
> > -                      * another probe was hit while within the handler.
> > -                      * We here save the original kprobes variables and
> > -                      * just single step on the instruction of the new probe
> > -                      * without calling any user handlers.
> > -                      */
> > -                     save_previous_kprobe(kcb);
> > -                     set_current_kprobe(p, regs, kcb);
> > -                     kprobes_inc_nmissed_count(p);
> > -                     prepare_singlestep(p, regs);
> > -                     kcb->kprobe_status = KPROBE_REENTER;
> > -                     return 1;
> > -             } else {
> > -                     if (*addr != BREAKPOINT_INSTRUCTION) {
> > -                     /* The breakpoint instruction was removed by
> > -                      * another cpu right after we hit, no further
> > -                      * handling of this interrupt is appropriate
> > -                      */
> > -                             regs->eip -= sizeof(kprobe_opcode_t);
> > +     if (p) {
> > +             if (cur) {
> > +                     switch (kcb->kprobe_status) {
> > +                     case KPROBE_HIT_ACTIVE:
> > +                     case KPROBE_HIT_SSDONE:
> > +                             /* a probe has been hit inside a
> > +                              * user handler */
> > +                             save_previous_kprobe(kcb);
> > +                             set_current_kprobe(p, regs, kcb);
> > +                             kprobes_inc_nmissed_count(p);
> > +                             prepare_singlestep(p, regs);
> > +                             kcb->kprobe_status = KPROBE_REENTER;
> >                               ret = 1;
> > -                             goto no_kprobe;
> > -                     }
> > -                     p = __get_cpu_var(current_kprobe);
> > -                     if (p->break_handler && p->break_handler(p, regs)) {
> > -                             goto ss_probe;
> > +                             break;
> > +                     case KPROBE_HIT_SS:
> > +                             if (*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
> > +                                     regs->eflags &= ~TF_MASK;
> > +                                     regs->eflags |=
> > +                                             kcb->kprobe_saved_eflags;
> > +                             } else {
> > +                                     /* BUG? */
> > +                             }
> > +                             break;
> > +                     default:
> > +                             /* impossible cases */
> > +                             BUG();
> >                       }
> > -             }

Replaced deeply nested if-elses with a switch.

Please let me know if there are any changes on which you would like
further clarification.

> --
> Masami Hiramatsu
>
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
>
> e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com
--

Thanks,
Abhishek Sagar
