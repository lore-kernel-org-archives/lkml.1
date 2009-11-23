Return-Path: <linux-kernel-owner+w=401wt.eu-S932092AbZKWXTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbZKWXTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757238AbZKWXTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:19:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757252AbZKWXTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:19:17 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v5 00/10] kprobes: Kprobes jump optimization support
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Mon, 23 Nov 2009 18:21:16 -0500
Message-ID: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are the patchset of the kprobes jump optimization v5
(a.k.a. Djprobe). Since it is not ensured that the int3 bypassing
cross modifying code is safe on any processors yet, I introduced
stop_machine() version of XMC. Using stop_machine() will disable
us to probe NMI codes, but anyway, kprobes itself can't probe
those codes. So, it's not a problem. This version also includes
get/put_online_cpus() around optimization for avoiding deadlock
of text_mutex.

These patches can be applied on the latest -tip.

Changes in v5:
- Use stop_machine() to replace a breakpoint with a jump.
- get/put_online_cpus() around optimization.
- Make generic jump patching interface RFC.

And kprobe stress test didn't found any regressions - from kprobes,
under kvm/x86.

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

Intel(R) Xeon(R) CPU E5410  @ 2.33GHz (without debugging options)

                     x86-32  x86-64
kprobe:              0.68us  0.91us
kprobe+booster:	     0.27us  0.40us
kprobe+optimized:    0.06us  0.06us

kretprobe :          0.95us  1.21us
kretprobe+booster:   0.53us  0.71us
kretprobe+optimized: 0.30us  0.35us

(booster skips single-stepping)

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
 changes IP(instruction pointer) to copied code and exits. So, the
 instructions which were copied to detour buffer are executed on the detour
 buffer.

 - Optimization
  Kprobe-optimizer doesn't start instruction-replacing soon, it waits
 synchronize_sched for safety, because some processors are possible to be
 interrupted on the instructions which will be replaced by a jump instruction.
 As you know, synchronize_sched() can ensure that all interruptions which were
 executed when synchronize_sched() was called are done, only if
 CONFIG_PREEMPT=n. So, this version supports only the kernel with
 CONFIG_PREEMPT=n.(*)
  After that, kprobe-optimizer replaces the 4 bytes right after int3 breakpoint
 with relative-jump destination, and synchronize caches on all processors. Next,
 it replaces int3 with relative-jump opcode, and synchronize caches again.

 - Unoptimization
  When unregistering, disabling kprobe or being blocked by other kprobe,
 an optimized-kprobe will be unoptimized. Before kprobe-optimizer runs,
 the kprobe just be dequeued from the optimized list. When the optimization
 has been done, it replaces a jump with int3 breakpoint and original code.
  First it puts int3 at the first byte of the jump, synchronize caches
 on all processors, and replaces the 4 bytes right after int3 with the
 original code.

(*)This optimization-safety checking may be replaced with stop-machine method
 which ksplice is done for supporting CONFIG_PREEMPT=y kernel.


Thank you,

---

Masami Hiramatsu (10):
      [RFC] kprobes/x86: Use text_poke_fixup() for jump optimization
      [RFC] x86: Introduce generic jump patching without stop_machine
      kprobes: Add documents of jump optimization
      kprobes/x86: Support kprobes jump optimization on x86
      kprobes/x86: Cleanup save/restore registers
      kprobes/x86: Boost probes when reentering
      kprobes: Jump optimization sysctl interface
      kprobes: Introduce kprobes jump optimization
      kprobes: Introduce generic insn_slot framework
      kprobes/x86: Cleanup RELATIVEJUMP_INSTRUCTION to RELATIVEJUMP_OPCODE


 Documentation/kprobes.txt          |  192 +++++++++++-
 arch/Kconfig                       |   13 +
 arch/x86/Kconfig                   |    1 
 arch/x86/include/asm/alternative.h |   11 +
 arch/x86/include/asm/kprobes.h     |   31 ++
 arch/x86/kernel/alternative.c      |  102 ++++++
 arch/x86/kernel/kprobes.c          |  585 +++++++++++++++++++++++++++++-------
 include/linux/kprobes.h            |   44 +++
 kernel/kprobes.c                   |  587 +++++++++++++++++++++++++++++++-----
 kernel/sysctl.c                    |   13 +
 10 files changed, 1374 insertions(+), 205 deletions(-)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
