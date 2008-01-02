Return-Path: <linux-kernel-owner+w=401wt.eu-S1758889AbYABQBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889AbYABQBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 11:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbYABQBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 11:01:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbYABQBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 11:01:22 -0500
Message-ID: <477BB516.8040507@redhat.com>
Date: Wed, 02 Jan 2008 11:00:22 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Abhishek Sagar <sagar.abhishek@gmail.com>, ananth@in.ibm.com,
       jkenisto@us.ibm.com
CC: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, qbarnes@gmail.com
Subject: Re: [PATCH] x86: kprobes change kprobe_handler flow
References: <1198806265.6323.34.camel@brick> <4778E8B0.6010400@gmail.com>	 <477A7D1F.8020703@redhat.com> <863e9df20801011224g8a3111dg1b09ce6726759d97@mail.gmail.com>
In-Reply-To: <863e9df20801011224g8a3111dg1b09ce6726759d97@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Abhishek Sagar wrote:
>>>  static int __kprobes kprobe_handler(struct pt_regs *regs)
>>>  {
>>> -     struct kprobe *p;
>>>       int ret = 0;
>>>       kprobe_opcode_t *addr;
>>> +     struct kprobe *p, *cur;
>>>       struct kprobe_ctlblk *kcb;
>>>
>>>       addr = (kprobe_opcode_t *)(regs->eip - sizeof(kprobe_opcode_t));
>>> +     if (*addr != BREAKPOINT_INSTRUCTION) {
>>> +             /*
>>> +              * The breakpoint instruction was removed right
>>> +              * after we hit it.  Another cpu has removed
>>> +              * either a probepoint or a debugger breakpoint
>>> +              * at this address.  In either case, no further
>>> +              * handling of this interrupt is appropriate.
>>> +              * Back up over the (now missing) int3 and run
>>> +              * the original instruction.
>>> +              */
>>> +             regs->eip -= sizeof(kprobe_opcode_t);
>>> +             return 1;
>>> +     }
> 
> I have moved the above breakpoint removal check at the beginning of
> the function. The current check is for '!p' case only, whereas IMO
> this check should be performed for all cases. An external debugger may
> very well plant and remove a breakpoint on an address which has probe
> on it. This check is a race nevertheless, so its relative placing
> within kprobe_handler() would be best where its duplication can be
> avoided.

I think there is another reason; now we have disable_all_kprobes() which
disarms(removes BREAKPOINT instruction) all kprobes. So, this should be commented.

By the way, IMHO, if a debugger causes it, that might be a bug.
Since when the debugger removes a breakpoint, it should prevent the exception
caused by the breakpoint on other processors. In other words, the debugger
should work as transparently as possible.

>>> -     /* Check we're not actually recursing */
>>> -     if (kprobe_running()) {
>>> -             p = get_kprobe(addr);
>>> -             if (p) {
>>> -                     if (kcb->kprobe_status == KPROBE_HIT_SS &&
>>> -                             *p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
>>> -                             regs->eflags &= ~TF_MASK;
>>> -                             regs->eflags |= kcb->kprobe_saved_eflags;
>>> -                             goto no_kprobe;
>>> -                     }
>>> -                     /* We have reentered the kprobe_handler(), since
>>> -                      * another probe was hit while within the handler.
>>> -                      * We here save the original kprobes variables and
>>> -                      * just single step on the instruction of the new probe
>>> -                      * without calling any user handlers.
>>> -                      */
>>> -                     save_previous_kprobe(kcb);
>>> -                     set_current_kprobe(p, regs, kcb);
>>> -                     kprobes_inc_nmissed_count(p);
>>> -                     prepare_singlestep(p, regs);
>>> -                     kcb->kprobe_status = KPROBE_REENTER;
>>> -                     return 1;
>>> -             } else {
>>> -                     if (*addr != BREAKPOINT_INSTRUCTION) {
>>> -                     /* The breakpoint instruction was removed by
>>> -                      * another cpu right after we hit, no further
>>> -                      * handling of this interrupt is appropriate
>>> -                      */
>>> -                             regs->eip -= sizeof(kprobe_opcode_t);
>>> +     if (p) {
>>> +             if (cur) {
>>> +                     switch (kcb->kprobe_status) {
>>> +                     case KPROBE_HIT_ACTIVE:
>>> +                     case KPROBE_HIT_SSDONE:
>>> +                             /* a probe has been hit inside a
>>> +                              * user handler */
>>> +                             save_previous_kprobe(kcb);
>>> +                             set_current_kprobe(p, regs, kcb);
>>> +                             kprobes_inc_nmissed_count(p);
>>> +                             prepare_singlestep(p, regs);
>>> +                             kcb->kprobe_status = KPROBE_REENTER;
>>>                               ret = 1;
>>> -                             goto no_kprobe;
>>> -                     }
>>> -                     p = __get_cpu_var(current_kprobe);
>>> -                     if (p->break_handler && p->break_handler(p, regs)) {
>>> -                             goto ss_probe;
>>> +                             break;
>>> +                     case KPROBE_HIT_SS:
>>> +                             if (*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
>>> +                                     regs->eflags &= ~TF_MASK;
>>> +                                     regs->eflags |=
>>> +                                             kcb->kprobe_saved_eflags;
>>> +                             } else {
>>> +                                     /* BUG? */
>>> +                             }

I think whole of this case might have a bug. Since "p" is a recursing kprobe on
the instruction buffer of the running kprobe, *p->ainsn.insn is the next singlestep
target. I think KPROBE_HIT_SS should be treated as same as KPROBE_HIT_ACTIVE.

If the author thought a situation that a user inserts a kprobe on a breakpoint which
has been set by other debugger, we have to check it in !p case, because
get_kprobe(running_kprobe->ainsn.insn) will return NULL in that case.


>>> +                             break;
>>> +                     default:
>>> +                             /* impossible cases */
>>> +                             BUG();
>>>                       }
>>> -             }
> 
> Replaced deeply nested if-elses with a switch.

Originally, if (kcb->kprobe_status==KPROBE_HIT_SS) && !(*p->ainsn.insn == BREAKPOINT_INSTRUCTION),
it increments nmissed_count and change the status to KPROBE_REENTER. Please trace the flow carefully.

> 
> Please let me know if there are any changes on which you would like
> further clarification.
> 
>> --
>> Masami Hiramatsu
>>
>> Software Engineer
>> Hitachi Computer Products (America) Inc.
>> Software Solutions Division
>>
>> e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com
> --
> 
> Thanks,
> Abhishek Sagar

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

