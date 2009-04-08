Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbZDHBv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbZDHBv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 21:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbZDHBvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 21:51:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59876 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548AbZDHBvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 21:51:47 -0400
Message-ID: <49DC0307.6080107@redhat.com>
Date: Tue, 07 Apr 2009 18:51:03 -0700
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Satoshi Oshima <satoshi.oshima.fk@hitachi.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PROTO][PATCH -tip 0/7] kprobes: support jump	optimization
 on x86
References: <49DA7702.5030308@redhat.com> <20090408011743.GB5977@nowhere>
In-Reply-To: <20090408011743.GB5977@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

Frederic Weisbecker wrote:
> On Mon, Apr 06, 2009 at 05:41:22PM -0400, Masami Hiramatsu wrote:
>> Hi,
>>
>> Here, I'd like to show you another x86 insn decoder user.
>> These are the prototype patchset of the kprobes jump optimization
>> (a.k.a. Djprobe, which I had developed two years ago). Finally,
>> I rewrote it as the jump optimized probe. These patches are still
>> under development, it neither support temporary disabling, nor
>> support debugfs interface. However, its basic functions(register/
>> unregister/optimizing/safety check) are implemented.
>>
>>  These patches can be applied on -tip tree + following patches;
>>   - kprobes patches on -mm tree (I attached on this mail)
>>  And below patches which I sent last week.
>>   - x86: instruction decorder API
>>   - x86: kprobes checks safeness of insertion address.
>>
>>  So, this is another example of x86 instruction decoder.
>>
>> (Andrew, I ported some of -mm patches to -tip tree just for
>>  preventing source code forking. This should be done on -tip,
>>  because x86-instruction decoder has been discussed on -tip)
>>
>>
>> Jump Optimized Kprobes
>> ======================
>> o What is jump optimization?
>>  Kprobes uses the int3 breakpoint instruction on x86 for instrumenting
>> probes into running kernel. Jump optimization allows kprobes to replace
>> breakpoint with a jump instruction for reducing probing overhead drastically.
>>
>>
>> o Advantage and Disadvantage
>>  The advantage is process time performance. Usually, a kprobe hit takes
>> 0.5 to 1.0 microseconds to process. On the other hand, a jump optimized
>> probe hit takes less than 0.1 microseconds (actual number depends on the
>> processor). Here is a sample overheads.
>>
>> Intel(R) Xeon(R) CPU E5410  @ 2.33GHz (running in 2GHz)
>>
>>                      x86-32  x86-64
>> kprobe:              1.00us  1.05us
>> kprobe+booster:	     0.45us  0.50us
>> kprobe+optimized:    0.05us  0.07us
>>
>> kretprobe :          1.77us  1.45us
>> kretprobe+booster:   1.30us  0.90us
>> kretprobe+optimized: 1.02us  0.40us
> 
> 
> Nice!

Thanks :)


>>  However, there is a disadvantage (the law of equivalent exchange :)) too,
>> which is memory consumption. Jump optimization requires optimized_kprobe
>> data structure, and additional bigger instruction buffer than kprobe,
>> which contains exception emulating code (push/pop registers), copied
>> instructions, and a jump. Those data consumes 145 bytes(x86-32) of
>> memory per probe.
> 
> 
> 
> But can we consider it as a small problem, assuming that kprobes are
> rarely intended for a massive use in once? I guess that usually, not a
> lot of functions are probed simultaneously.

Hm, yes and no, systemtap may use massive kprobes, because it supports
"wildcard" probes. However, optimizing in default may be acceptable.



>> Briefly speaking, an optimized kprobe 5 times faster and 3 times bigger
>> than a kprobe.
>>
>> Anyway, you can choose that you'd like to optimize your kprobes by setting
>> KPROBE_FLAG_OPTIMIZE to kp->flags field.
>>
>> o How to use it?
>>  What you need to optimize your *probe is just adding KPROBE_FLAG_OPTIMIZE
>> to kp.flags before registering.
>>
>> E.g.
>>  (setup handler/addr/symbol...)
>>  kp->flags |= KPROBE_FLAG_OPTIMIZE;
>>  (register kp)
>>
>>  That's all. :-)
> 
> 
> 
> May be it's better to set this flag as default-enable. Hm?

Yeah, this flag is just for the case without the last patch.
(in that case, user has to ensure that the kprobe can be optimized)

>>  kprobes decodes probed function and checks whether the target instructions
>> can be optimized(replaced with a jump) safely. If it can't, kprobes clears
>> KPROBE_FLAG_OPTIMIZE from kp->flags. So, you can check it after registering.
>>
>>
>> o How it works?
>>  kprobe jump optimization looks like an aggregated kprobe.
>>
>>  Before preparing optimization, kprobe inserts original(user-defined)
>>  kprobe on the specified address. So, even if the kprobe is not
>>  possible to be optimized, it just fall back to a normal kprobe.
>>
>>  - Safety check
>>   First, kprobe decodes whole body of probed function and checks
>>  whether there is NO indirect jump, and near jump which jumps into the
>>  region which will be replaced by a jump instruction (except the 1st
>>  byte of jump), because if some jump instruction jumps into the middle
>>  of another instruction, which causes unexpectable results.
>>   Kprobe also measures the length of instructions which will be replaced
>>  by a jump instruction, because a jump instruction is longer than 1 byte,
>>  it may replaces multiple instructions, and it checkes whether those
>>  instructions can be executed out-of-line.
>>
>>  - Preparing detour code
>>   Next, kprobe prepares "detour" buffer, which contains exception emulating
>>  code (push/pop registers, call handler), copied instructions(kprobes copies
>>  instructions which will be replaced by a jump, to the detour buffer), and
>>  a jump which jumps back to the original execution path.
>>
>>  - Pre-optimization
>>   After preparing detour code, kprobe kicks kprobe-optimizer workqueue to
>>  optimize kprobe. To wait other optimized_kprobes, kprobe optimizer will
>>  delay to work.
>>   When the optimized_kprobe is hit before optimization, its handler
>>  changes IP(instruction pointer) to detour code and exits. So, the
>>  instructions which were copied to detour buffer are not executed.
> 
> 
> I have some trouble to understand these three last lines.
> The detour code has been set at this time, so if we jump to it, its
> instructions (saved original code overwritten by jump, and jump to the rest)
> will be executed. No?

Oh, yes, sorry for confusing. It should be "the original instructions which
will be replaced by a jump are not executed, instead of that, copied
instructions are executed."

>>  - Optimization
>>   Kprobe-optimizer doesn't start instruction-replacing soon, it waits
>>  synchronize_sched for safety, because some processors are possible to be
>>  interrpted on the instructions which will be replaced by a jump instruction.
>>  As you know, synchronize_sched() can ensure that all interruptions which were
>>  executed when synchronize_sched() was called are done, only if CONFIG_PREEMPT=n.
>>  So, this version supports only the kernel with CONFIG_PREEMPT=n.(*)
>>   After that, kprobe-optimizer replaces the 4 bytes right after int3 breakpoint
>>  with relative-jump destination, and synchronize caches on all processors. Next,
>>  it replaces int3 with relative-jump opcode, and synchronize caches again.
>>
>>
>> (*)This optimization-safety checking may be replaced with stop-machine method
>>  which ksplice is done for supporting CONFIG_PREEMPT=y kernel.
>>
> 
> 
> 
> I have to look at this series :-)

Thank you!

> 
> Thanks,
> Frederic.
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

