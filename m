Return-Path: <linux-kernel-owner+w=401wt.eu-S1756472AbYABTbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbYABTbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbYABTba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:31:30 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:45675 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbYABTb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:31:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Try3zcgn5a1zWHxsbIny43gw0UpyuUeoliemM3uvidXK3JuATmaOfV3EkgHsTG2/8SDpWzMfPpzNLe783KTDtKxACj5VyIgK+SOleRJLUZLpSfGoqVoIQ8tDueLBsmp+pJw0ZJ0ld00HeRNHnnWE3tZ1RLt3NyUXMxg7ETwUvyU=
Message-ID: <863e9df20801021131j3a4d655dgd00fa60e39a97ec@mail.gmail.com>
Date: Thu, 3 Jan 2008 01:01:28 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Masami Hiramatsu" <mhiramat@redhat.com>
Subject: Re: [PATCH] x86: kprobes change kprobe_handler flow
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Harvey Harrison" <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, qbarnes@gmail.com,
       ananth@in.ibm.com, jkenisto@us.ibm.com
In-Reply-To: <477BD366.1060504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1198806265.6323.34.camel@brick> <4778E8B0.6010400@gmail.com>
	 <20080101153558.GJ4434@elte.hu> <477A971A.8030006@gmail.com>
	 <477BD366.1060504@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/2/08, Masami Hiramatsu <mhiramat@redhat.com> wrote:
> I think setup_singlestep() in your first patch is better, because it avoided
> code duplication(*).

Will retain it then.

> >  static int __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
> >                                   struct kprobe_ctlblk *kcb)
> >  {
> > -     if (kcb->kprobe_status == KPROBE_HIT_SS &&
> > -         *p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
> > -             regs->flags &= ~X86_EFLAGS_TF;
> > -             regs->flags |= kcb->kprobe_saved_flags;
> > -             return 0;
> > +     int ret = 0;
> > +
> > +     switch (kcb->kprobe_status) {
> > +     case KPROBE_HIT_SSDONE:
> >  #ifdef CONFIG_X86_64
> > -     } else if (kcb->kprobe_status == KPROBE_HIT_SSDONE) {
> > -             /* TODO: Provide re-entrancy from post_kprobes_handler() and
> > -              * avoid exception stack corruption while single-stepping on
> > +             /* TODO: Provide re-entrancy from
> > +              * post_kprobes_handler() and avoid exception
> > +              * stack corruption while single-stepping on
>
> Why would you modify it?

Do you mean the comment? I had this code in kprobe_handler earlier and
it consistently exceeded 80 columns in my case. Will fix it anyways.

> > +             ret = 1;
> > +             break;
> >  #endif
> > +     case KPROBE_HIT_ACTIVE:
> > +             /* a probe has been hit inside a
> > +              * user handler */
> > +             save_previous_kprobe(kcb);
> > +             set_current_kprobe(p, regs, kcb);
> > +             kprobes_inc_nmissed_count(p);
> > +             prepare_singlestep(p, regs);
> > +             kcb->kprobe_status = KPROBE_REENTER;
> > +             ret = 1;
> > +             break;
> > +     case KPROBE_HIT_SS:
> > +             if (*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
> > +                     regs->flags &= ~TF_MASK;
> > +                     regs->flags |= kcb->kprobe_saved_flags;
> > +             } else {
> > +                     /* BUG? */
> > +             }
> > +             break;
>
> If my thought is correct, we don't need to use swich-case here,
> Because there are only 2 cases, KPROBE_HIT_SSDONE (x86-64 only)
> or others.
> As a result, this function just setups re-entrance.

As you've also pointed out in your previous reply, this case is
peculiar and therefore I believe it should be marked as a BUG(). I've
left the original case, if (kcb->kprobe_status==KPROBE_HIT_SS) &&
(*p->ainsn.insn == BREAKPOINT_INSTRUCTION), untouched and is handled
as it was before. However, if (kcb->kprobe_status==KPROBE_HIT_SS) &&
!(*p->ainsn.insn == BREAKPOINT_INSTRUCTION), then instead of
incrementing nmissed count like before, it should cry out a BUG. This
is not an ordinary recursive probe handling case which should update
the nmissed count.

> > +     default:
> > +             /* impossible cases */
> > +             BUG();
>
> I think no need to check that here.

It may not get hit at runtime but is quite informative.

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
> I think this block changing would better be separated from this patch,
> because it changes code flow logically.

Agreed. I'll address this in another thread, but for now it is safest
to check it for all cases right at the entry of kprobe_handler().

> >
> > -     /*
> > -      * We don't want to be preempted for the entire
> > -      * duration of kprobe processing
> > -      */
> >       preempt_disable();
> >       kcb = get_kprobe_ctlblk();
> > -
> > +     cur = kprobe_running();
>
> I think you don't need "cur", because kprobe_running() is called
> just once on each path.

Will get rid of that.

> > -                     regs->ip = (unsigned long)addr;
> > +                     if (!p->pre_handler || !p->pre_handler(p, regs)) {
> > +                             if (setup_boost(p, regs)) {
> > +                                     prepare_singlestep(p, regs);
> > +                                     kcb->kprobe_status = KPROBE_HIT_SS;
>
> (*) duplication 1
>
> > +                             }
> > +                     }
> >                       ret = 1;
> > -                     goto preempt_out;
> >               }
> > -             if (kprobe_running()) {
> > -                     p = __get_cpu_var(current_kprobe);
> > -                     if (p->break_handler && p->break_handler(p, regs))
> > -                             goto ss_probe;
> > +     } else if (cur) {
> > +             p = __get_cpu_var(current_kprobe);
> > +             if (p->break_handler && p->break_handler(p, regs)) {
> > +                     if (setup_boost(p, regs)) {
> > +                             prepare_singlestep(p, regs);
> > +                             kcb->kprobe_status = KPROBE_HIT_SS;
>
> (*) duplication 2

Will replace it with setup_singlestep().

> > +                     }
> > +                     ret = 1;
> >               }
> > -             /* Not one of ours: let kernel handle it */
> > -             goto preempt_out;
> > -     }
> > +     } /* else: not a kprobe fault; let the kernel handle it */
> >
> > -ss_probe:
> > -     ret = 1;
> > -#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
> > -     if (p->ainsn.boostable == 1 && !p->post_handler) {
> > -             /* Boost up -- we can execute copied instructions directly */
> > -             reset_current_kprobe();
> > -             regs->ip = (unsigned long)p->ainsn.insn;
> > -             goto preempt_out;
> > -     }
> > -#endif
> > -     prepare_singlestep(p, regs);
> > -     kcb->kprobe_status = KPROBE_HIT_SS;
> > -     goto out;
> > -
> > -preempt_out:
> > -     preempt_enable_no_resched();
> > -out:
> > +     if (!ret)
> > +             preempt_enable_no_resched();
>
> I think this is a bit ugly...
> Why would you avoid using mutiple "return"s in this function?
> I think you can remove "ret" from this function.

Hmm...there the are no deeply nested if-elses nor overlapping paths
which need to be avoided. All the nested checks unroll cleanly too.

> Thank you,
>
> --
> Masami Hiramatsu
>
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
>
> e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com
--

Thanks for your review!
Abhishek
