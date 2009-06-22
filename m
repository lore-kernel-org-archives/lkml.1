Return-Path: <linux-kernel-owner+w=401wt.eu-S1759273AbZFVVVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbZFVVVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 17:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZFVVV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 17:21:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59705 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412AbZFVVV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 17:21:26 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [RFC][ PATCH -tip v2 0/7] kprobes: Kprobes jump optimization support
To: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Mon, 22 Jun 2009 17:22:55 -0400
Message-ID: <20090622212255.5384.53732.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are the RFC patchset of the kprobes jump optimization v2
(a.k.a. Djprobe). This version is including some bugfixes and disabling
crossjumping patch.

The gcc's crossjumping unifies equivalent code by inserting indirect
jumps which jump into other function body. It is hard to know to where
these jumps jump, so I decided to disable it when setting
CONFIG_OPTPROBES=y.

I also decided not to optimize probes when it is in functions which
will cause exceptions, because the exception in the kernel will jump
to a fixup code and the fixup code jumps back to the middle of the
same function body.

These patches can be applied on -tip tree + x86 instruction decoder
which I re-sent right now. This is another example of x86 instruction
decoder.


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

Masami Hiramatsu (7):
      kprobes: add documents of jump optimization
      kprobes: x86: support kprobes jump optimization on x86
      kprobes: x86: cleanup save/restore registers
      kprobes: kprobes jump optimization core
      Kbuild: disable gcc crossjumping
      kprobes: introducing generic insn_slot framework
      kprobes: use list instead of hlist for insn_pages


 Documentation/kprobes.txt      |  174 ++++++++++++-
 Makefile                       |    4 
 arch/Kconfig                   |   13 +
 arch/x86/Kconfig               |    1 
 arch/x86/include/asm/kprobes.h |   31 ++
 arch/x86/kernel/kprobes.c      |  534 ++++++++++++++++++++++++++++++++++------
 include/linux/kprobes.h        |   38 +++
 kernel/kprobes.c               |  521 ++++++++++++++++++++++++++++++++-------
 lib/Kconfig.debug              |    7 +
 9 files changed, 1128 insertions(+), 195 deletions(-)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
