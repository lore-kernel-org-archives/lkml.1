Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933986Ab0BEWjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 17:39:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933977Ab0BEWjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 17:39:32 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v9 0/9] kprobes: Kprobes jump optimization support
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Anders Kaseorg <andersk@ksplice.com>,
       Tim Abbott <tabbott@ksplice.com>, Andi Kleen <andi@firstfloor.org>,
       Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Fri, 05 Feb 2010 17:46:13 -0500
Message-ID: <20100205224613.31959.59651.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are the patchset of the kprobes jump optimization v9
(a.k.a. Djprobe). This version includes some bugfixes,
enhancements, and applicable for 2.6.33-rc6-tip.

This version of patch series uses text_poke_smp() which
update kernel text by stop_machine(). That is 'officially'
supported on Intel's processors. text_poke_smp() can't
be used for modifying NMI code, but, fortunately:), kprobes
also can't probe NMI code. Thus, kprobes jump-optimization
can use it.

Int3-bypassing method (text_poke_fixup()) is still unofficial
and we need to get more official answers from x86 vendors.
I'd like to push it after this series of patches are merged.

Anyway, thanks Mathieu and Peter, for helping me to
implement it and organizing discussion points about
int3-bypass XMC!

These patches can be applied on the latest -tip.

Changes in v9:
 - Fix a bug to optimize probe when enabling.
 - Check nearby probes can be optimize/unoptimize when disarming/arming
   kprobes, instead of registering/unregistering. This will help
   kprobe-tracer because most of probes on it are usually disabled.
 - Use *_text_reserved() for checking the probe can be optimized.
 - Verify jump address range is in 2G range when preparing slot.
 - Backup original code when switching optimized buffer, instead of
   preparing buffer, because there can be int3 of other probes in
   preparing phase.
 - Check kprobe is disabled in arch_check_optimized_kprobe().
 - Strictly check indirect jump opcodes (ff /4, ff /5).


And kprobe stress test didn't found any regressions - from kprobes,
under kvm/x86.

TODO:
 - Support NMI-safe int3-bypassing text_poke.
 - Support preemptive kernel (by stack unwinding and checking address).


How to use it
=============

The jump replacement optimization is transparently done in kprobes.
So, if you enables CONFIG_KPROBE_EVENT(a.k.a. kprobe-tracer) in
kernel config, you can use it via kprobe_events interface.

e.g.

 # echo p:probe1 schedule > /sys/kernel/debug/tracing/kprobe_evnets

 # cat /sys/kernel/debug/kprobes/list
 c069ce4c  k  schedule+0x0    [DISABLED]

 # echo 1 > /sys/kernel/debug/tracing/events/kprobes/probe1/enable

 # cat /sys/kernel/debug/kprobes/list
 c069ce4c  k  schedule+0x0    [OPTIMIZED]

Note:
 Which probe can be optimized is depends on the actual kernel binary.
 So, in some cases, it might not be optimized. Please try to probe
 another place in that case.


Jump Optimized Kprobes
======================
o Concept
 Kprobes uses the int3 breakpoint instruction on x86 for instrumenting
probes into running kernel. Jump optimization allows kprobes to replace
breakpoint with a jump instruction for reducing probing overhead drastically.

o Performance
 An optimized kprobe 5 times faster than a kprobe.

 Optimizing probes gains its performance. Usually, a kprobe hit takes
0.5 to 1.0 microseconds to process. On the other hand, a jump optimized
probe hit takes less than 0.1 microseconds (actual number depends on the
processor). Here is a sample overheads.

Intel(R) Xeon(R) CPU E5410  @ 2.33GHz
(without debugging options, with text_poke_smp patch, 2.6.33-rc4-tip+)

			x86-32  x86-64
kprobe:			0.80us  0.99us
kprobe+booster:		0.33us  0.43us
kprobe+optimized:	0.05us  0.06us
kprobe(post-handler):	0.81us	1.00us

kretprobe :		1.10us  1.24us
kretprobe+booster:	0.61us  0.68us
kretprobe+optimized:	0.33us  0.30us

jprobe:			1.37us	1.67us
jprobe+booster:		0.80us	1.10us

(booster skips single-stepping, kprobe with post handler
 isn't boosted/optimized, and jprobe isn't optimized.)

 Note that jump optimization also consumes more memory, but not so much.
It just uses ~200 bytes, so, even if you use ~10,000 probes, it just 
consumes a few MB.


o Usage
 Set CONFIG_OPTPROBES=y when building a kernel, then all *probes will be
optimized if possible.

 Kprobes decodes probed function and checks whether the target instructions
can be optimized(replaced with a jump) safely. If it can't be, Kprobes just
doesn't optimize it.


o Optimization
  Before preparing optimization, Kprobes inserts original(user-defined)
 kprobe on the specified address. So, even if the kprobe is not
 possible to be optimized, it just uses a normal kprobe.

 - Safety check
  First, Kprobes gets the address of probed function and checks whether the
 optimized region, which will be replaced by a jump instruction, does NOT
 straddle the function boundary, because if the optimized region reaches the
 next function, its caller causes unexpected results.
  Next, Kprobes decodes whole body of probed function and checks there is
 NO indirect jump, NO instruction which will cause exception by checking
 exception_tables (this will jump to fixup code and fixup code jumps into
 same function body) and NO near jump which jumps into the optimized region
 (except the 1st byte of jump), because if some jump instruction jumps
 into the middle of another instruction, it causes unexpected results too.
  Kprobes also measures the length of instructions which will be replaced
 by a jump instruction, because a jump instruction is longer than 1 byte,
 it may replaces multiple instructions, and it checks whether those
 instructions can be executed out-of-line.

 - Preparing detour code
  Then, Kprobes prepares "detour" buffer, which contains exception emulating
 code (push/pop registers, call handler), copied instructions(Kprobes copies
 instructions which will be replaced by a jump, to the detour buffer), and
 a jump which jumps back to the original execution path.

 - Pre-optimization
  After preparing detour code, Kprobes enqueues the kprobe to optimizing list
 and kicks kprobe-optimizer workqueue to optimize it. To wait other optimized
 probes, kprobe-optimizer will delay to work.
  When the optimized-kprobe is hit before optimization, its handler
 changes IP(instruction pointer) to copied code and exits. So, those
 copied instructions are executed on the detour buffer.

 - Optimization
  Kprobe-optimizer doesn't start instruction-replacing soon, it waits
 synchronize_sched for safety, because some processors are possible to be
 interrupted on the middle of instruction series (2nd or Nth instruction)
 which will be replaced by a jump instruction(*).
 As you know, synchronize_sched() can ensure that all interruptions which
 were executed when synchronize_sched() was called are done, only if
 CONFIG_PREEMPT=n. So, this version supports only the kernel with
 CONFIG_PREEMPT=n.(**)
  After that, kprobe-optimizer calls stop_machine() to replace probed-
 instructions with a jump instruction by using text_poke_smp().

 - Unoptimization
  When unregistering, disabling kprobe or being blocked by other kprobe,
 an optimized-kprobe will be unoptimized. Before kprobe-optimizer runs,
 the kprobe just be dequeued from the optimized list. When the optimization
 has been done, it replaces a jump with int3 breakpoint and original code
 by using text_poke_smp().

(*)Please imagine that 2nd instruction is interrupted and
optimizer replaces the 2nd instruction with jump *address*
while the interrupt handler is running. When the interrupt
returns to original address, there is no valid instructions
and it causes unexpected result.

(**)This optimization-safety checking may be replaced with stop-machine
method which ksplice is done for supporting CONFIG_PREEMPT=y kernel.


Thank you,

---

Masami Hiramatsu (9):
      kprobes: Add documents of jump optimization
      kprobes/x86: Support kprobes jump optimization on x86
      x86: Add text_poke_smp for SMP cross modifying code
      kprobes/x86: Cleanup save/restore registers
      kprobes/x86: Boost probes when reentering
      kprobes: Jump optimization sysctl interface
      kprobes: Introduce kprobes jump optimization
      kprobes: Introduce generic insn_slot framework
      kprobes/x86: Cleanup RELATIVEJUMP_INSTRUCTION to RELATIVEJUMP_OPCODE


 Documentation/kprobes.txt          |  191 ++++++++++-
 arch/Kconfig                       |   13 +
 arch/x86/Kconfig                   |    1 
 arch/x86/include/asm/alternative.h |    4 
 arch/x86/include/asm/kprobes.h     |   31 ++
 arch/x86/kernel/alternative.c      |   60 +++
 arch/x86/kernel/kprobes.c          |  609 ++++++++++++++++++++++++++++------
 include/linux/kprobes.h            |   44 ++
 kernel/kprobes.c                   |  647 +++++++++++++++++++++++++++++++-----
 kernel/sysctl.c                    |   12 +
 10 files changed, 1402 insertions(+), 210 deletions(-)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
