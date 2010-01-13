Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884Ab0AMGSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab0AMGSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 01:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664Ab0AMGSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 01:18:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab0AMGSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 01:18:51 -0500
Message-ID: <4B4D65B1.3010204@redhat.com>
Date: Wed, 13 Jan 2010 01:18:25 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Dongdong Deng <libfetion@gmail.com>
CC: linux-kernel@vger.kernel.org, ananth@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       arjan@infradead.org, jkenisto@us.ibm.com
Subject: Re: Did we really need to clear the IF flag at prepare_singlestep()
 of 	x86 kprobes?
References: <ce2c83091001120309q19d58b45kc27610fc31ce01dc@mail.gmail.com>
In-Reply-To: <ce2c83091001120309q19d58b45kc27610fc31ce01dc@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dongdong Deng wrote:
> Hi Kprobe experts,
> 
> I have a doubt about the handling "X86_EFLAGS_IF" at prepare_singlestep(),
> Could you give me some suggestions?
> 
> 
> arch/x86/kernel/kprobes.c:
> 406 static void __kprobes prepare_singlestep(struct kprobe *p, struct
> pt_regs *regs)
> 407 {
> 408    clear_btf();
> 409    regs->flags |= X86_EFLAGS_TF;
> 410    regs->flags &= ~X86_EFLAGS_IF;
>   ...
> }
> 
> 
> for 410 line: Kprobe is intend to disable interrupt during the single step.
> 
> I think it is enough that just setting X86_EFLAGS_TF as following reasons.
> 
> 
> ******************
> Reason 1: "debug trap" was initalized as an interrupt gate
> 
> arch/x86/kernel/traps.c:892: set_intr_gate_ist(1, &debug, DEBUG_STACK);
> 
> The "debug trap" was initalized as an interrupt gate, thereby during the
> hanld function of debug exceptions, the X86_EFLAGS_IF have been
> cleared automatically.
> 
> 
> ******************
> Reason 2: the priority among debug exceptions and interrupts
> 
> Intel® 64 and IA-32 Architectures Software Developer’s Manual Volume
> 3A, page 5-11:
> 
> If more than one exception or interrupt is pending at an instruction
> boundary, the
> processor services them in a predictable order. Table 5-2 shows the
> priority among
> classes of exception and interrupt sources.
>           Table 5-2. Priority Among Simultaneous Exceptions and Interrupts
> Priority       Description
> 1 (Highest)    Hardware Reset and Machine Checks
>                - RESET
>                - Machine Check
> 2              Trap on Task Switch
>                - T flag in TSS is set
> 3              External Hardware Interventions
>                - FLUSH
>                - STOPCLK
>                - SMI
>                - INIT
> 4              Traps on the Previous Instruction
>                - Breakpoints
>                - Debug Trap Exceptions (TF flag set or data/I-O breakpoint)
> 5             Nonmaskable Interrupts (NMI)
> 6             Maskable Hardware Interrupts
> 
> 
> From the table we could see debug exceptions lies in priority 4 and
> external interrupt lies
> in priority 6.
> 
> Thereby the processor will handle Debug Trap Exceptions first, then
> handle external interrupt.

Hi Dongdong,

Hmm, can that be applied on other x86 compat cpus too?
And, when is the debug trap exception actually happened?

1: int3 ->
2:  -> pre_kprobe_handler
3:  -> prepare_singlestep
4: <- iret
5: execute instruction
6: debug trap ->
7: -> post_kprobe_handler
...

If we have an interrupt before step4, does that interrupt
really executed *after* step5? or step4?

If the processor really tries to execute interrupt
right after step5, your logic seems correct, but if it
is done right after step4, clearing IF seems correct.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

