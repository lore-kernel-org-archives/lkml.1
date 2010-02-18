Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab0BRWHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 17:07:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758703Ab0BRWHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 17:07:07 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v10 0/9] kprobes: Kprobes jump optimization support
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
Date: Thu, 18 Feb 2010 17:12:47 -0500
Message-ID: <20100218221247.19637.80088.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here are the patchset of the kprobes jump optimization v10
(a.k.a. Djprobe). This version just updated a document,
and applicable for 2.6.33-rc8-tip.

This version of patch series uses text_poke_smp() which
update kernel text by stop_machine(). That is 'officially'
supported on Intel's processors. text_poke_smp() can't
be used for modifying NMI code, but, fortunately:), kprobes
also can't probe NMI code. Thus, kprobes jump-optimization
can use it.
(Int3-bypassing method (text_poke_fixup()) is still unofficial
 and we need to get more official answers from x86 vendors.)


Changes in v10:
 - Editorial update by Jim Keniston.


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
 An optimized kprobe is about 5 times faster than a kprobe.

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
 If you configured your kernel with CONFIG_OPTPROBES=y (currently
this option is supported on x86/x86-64, non-preemptive kernel) and
the "debug.kprobes_optimization" kernel parameter is set to 1 (see
sysctl(8)), Kprobes tries to reduce probe-hit overhead by using a jump
instruction instead of a breakpoint instruction at each probepoint.


o Optimization
 When a probe is registered, before attempting this optimization,
Kprobes inserts an ordinary, breakpoint-based kprobe at the specified
address. So, even if it's not possible to optimize this particular
probepoint, there'll be a probe there.

- Safety check
 Before optimizing a probe, Kprobes performs the following safety checks:

  - Kprobes verifies that the region that will be replaced by the jump
  instruction (the "optimized region") lies entirely within one function.
  (A jump instruction is multiple bytes, and so may overlay multiple
  instructions.)

  - Kprobes analyzes the entire function and verifies that there is no
  jump into the optimized region.  Specifically:
    - the function contains no indirect jump;
    - the function contains no instruction that causes an exception (since
    the fixup code triggered by the exception could jump back into the
    optimized region -- Kprobes checks the exception tables to verify this);
    and
    - there is no near jump to the optimized region (other than to the first
    byte).

  - For each instruction in the optimized region, Kprobes verifies that
  the instruction can be executed out of line.

- Preparing detour code
  Next, Kprobes prepares a "detour" buffer, which contains the following
  instruction sequence:
  - code to push the CPU's registers (emulating a breakpoint trap)
  - a call to the trampoline code which calls user's probe handlers.
  - code to restore registers
  - the instructions from the optimized region
  - a jump back to the original execution path.

- Pre-optimization
  After preparing the detour buffer, Kprobes verifies that none of the
  following situations exist:
  - The probe has either a break_handler (i.e., it's a jprobe) or a
  post_handler.
  - Other instructions in the optimized region are probed.
  - The probe is disabled.
  In any of the above cases, Kprobes won't start optimizing the probe.
  Since these are temporary situations, Kprobes tries to start
  optimizing it again if the situation is changed.

  If the kprobe can be optimized, Kprobes enqueues the kprobe to an
  optimizing list, and kicks the kprobe-optimizer workqueue to optimize
  it.  If the to-be-optimized probepoint is hit before being optimized,
  Kprobes returns control to the original instruction path by setting
  the CPU's instruction pointer to the copied code in the detour buffer
  -- thus at least avoiding the single-step.

- Optimization
  The Kprobe-optimizer doesn't insert the jump instruction immediately;
  rather, it calls synchronize_sched() for safety first, because it's
  possible for a CPU to be interrupted in the middle of executing the
  optimized region(*).  As you know, synchronize_sched() can ensure
  that all interruptions that were active when synchronize_sched()
  was called are done, but only if CONFIG_PREEMPT=n.  So, this version
  of kprobe optimization supports only kernels with CONFIG_PREEMPT=n.(**)

  After that, the Kprobe-optimizer calls stop_machine() to replace
  the optimized region with a jump instruction to the detour buffer,
  using text_poke_smp().

 - Unoptimization
  When an optimized kprobe is unregistered, disabled, or blocked by
  another kprobe, it will be unoptimized.  If this happens before
  the optimization is complete, the kprobe is just dequeued from the
  optimized list.  If the optimization has been done, the jump is
  replaced with the original code (except for an int3 breakpoint in
  the first byte) by using text_poke_smp().

(*)Please imagine that the 2nd instruction is interrupted and then
the optimizer replaces the 2nd instruction with the jump *address*
while the interrupt handler is running. When the interrupt
returns to original address, there is no valid instruction,
and it causes an unexpected result.

(**)This optimization-safety checking may be replaced with the
stop-machine method that ksplice uses for supporting a CONFIG_PREEMPT=y
kernel.


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


 Documentation/kprobes.txt          |  207 +++++++++++-
 arch/Kconfig                       |   13 +
 arch/x86/Kconfig                   |    1 
 arch/x86/include/asm/alternative.h |    4 
 arch/x86/include/asm/kprobes.h     |   31 ++
 arch/x86/kernel/alternative.c      |   60 +++
 arch/x86/kernel/kprobes.c          |  609 ++++++++++++++++++++++++++++------
 include/linux/kprobes.h            |   44 ++
 kernel/kprobes.c                   |  647 +++++++++++++++++++++++++++++++-----
 kernel/sysctl.c                    |   12 +
 10 files changed, 1419 insertions(+), 209 deletions(-)

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
