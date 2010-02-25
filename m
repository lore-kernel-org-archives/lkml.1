Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab0BYNbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 08:31:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932519Ab0BYNbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 08:31:33 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v3&10 09/18] kprobes: Add documents of jump optimization
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Anders Kaseorg <andersk@ksplice.com>,
       Tim Abbott <tabbott@ksplice.com>, Andi Kleen <andi@firstfloor.org>,
       Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Date: Thu, 25 Feb 2010 08:35:04 -0500
Message-ID: <20100225133504.6725.79395.stgit@localhost6.localdomain6>
In-Reply-To: <20100225133342.6725.26971.stgit@localhost6.localdomain6>
References: <20100225133342.6725.26971.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentations about kprobe jump optimization to Documentation/kprobes.txt.

Changes in v10:
 - Editorial fixups by Jim Keniston.

Changes in v8:
 - Update documentation and benchmark results.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Anders Kaseorg <andersk@ksplice.com>
Cc: Tim Abbott <tabbott@ksplice.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>
---

 Documentation/kprobes.txt |  207 ++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 195 insertions(+), 12 deletions(-)

diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index 053037a..2f9115c 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -1,6 +1,7 @@
 Title	: Kernel Probes (Kprobes)
 Authors	: Jim Keniston <jkenisto@us.ibm.com>
-	: Prasanna S Panchamukhi <prasanna@in.ibm.com>
+	: Prasanna S Panchamukhi <prasanna.panchamukhi@gmail.com>
+	: Masami Hiramatsu <mhiramat@redhat.com>
 
 CONTENTS
 
@@ -15,6 +16,7 @@ CONTENTS
 9. Jprobes Example
 10. Kretprobes Example
 Appendix A: The kprobes debugfs interface
+Appendix B: The kprobes sysctl interface
 
 1. Concepts: Kprobes, Jprobes, Return Probes
 
@@ -42,13 +44,13 @@ registration/unregistration of a group of *probes. These functions
 can speed up unregistration process when you have to unregister
 a lot of probes at once.
 
-The next three subsections explain how the different types of
-probes work.  They explain certain things that you'll need to
-know in order to make the best use of Kprobes -- e.g., the
-difference between a pre_handler and a post_handler, and how
-to use the maxactive and nmissed fields of a kretprobe.  But
-if you're in a hurry to start using Kprobes, you can skip ahead
-to section 2.
+The next four subsections explain how the different types of
+probes work and how jump optimization works.  They explain certain
+things that you'll need to know in order to make the best use of
+Kprobes -- e.g., the difference between a pre_handler and
+a post_handler, and how to use the maxactive and nmissed fields of
+a kretprobe.  But if you're in a hurry to start using Kprobes, you
+can skip ahead to section 2.
 
 1.1 How Does a Kprobe Work?
 
@@ -161,13 +163,125 @@ In case probed function is entered but there is no kretprobe_instance
 object available, then in addition to incrementing the nmissed count,
 the user entry_handler invocation is also skipped.
 
+1.4 How Does Jump Optimization Work?
+
+If you configured your kernel with CONFIG_OPTPROBES=y (currently
+this option is supported on x86/x86-64, non-preemptive kernel) and
+the "debug.kprobes_optimization" kernel parameter is set to 1 (see
+sysctl(8)), Kprobes tries to reduce probe-hit overhead by using a jump
+instruction instead of a breakpoint instruction at each probepoint.
+
+1.4.1 Init a Kprobe
+
+When a probe is registered, before attempting this optimization,
+Kprobes inserts an ordinary, breakpoint-based kprobe at the specified
+address. So, even if it's not possible to optimize this particular
+probepoint, there'll be a probe there.
+
+1.4.2 Safety Check
+
+Before optimizing a probe, Kprobes performs the following safety checks:
+
+- Kprobes verifies that the region that will be replaced by the jump
+instruction (the "optimized region") lies entirely within one function.
+(A jump instruction is multiple bytes, and so may overlay multiple
+instructions.)
+
+- Kprobes analyzes the entire function and verifies that there is no
+jump into the optimized region.  Specifically:
+  - the function contains no indirect jump;
+  - the function contains no instruction that causes an exception (since
+  the fixup code triggered by the exception could jump back into the
+  optimized region -- Kprobes checks the exception tables to verify this);
+  and
+  - there is no near jump to the optimized region (other than to the first
+  byte).
+
+- For each instruction in the optimized region, Kprobes verifies that
+the instruction can be executed out of line.
+
+1.4.3 Preparing Detour Buffer
+
+Next, Kprobes prepares a "detour" buffer, which contains the following
+instruction sequence:
+- code to push the CPU's registers (emulating a breakpoint trap)
+- a call to the trampoline code which calls user's probe handlers.
+- code to restore registers
+- the instructions from the optimized region
+- a jump back to the original execution path.
+
+1.4.4 Pre-optimization
+
+After preparing the detour buffer, Kprobes verifies that none of the
+following situations exist:
+- The probe has either a break_handler (i.e., it's a jprobe) or a
+post_handler.
+- Other instructions in the optimized region are probed.
+- The probe is disabled.
+In any of the above cases, Kprobes won't start optimizing the probe.
+Since these are temporary situations, Kprobes tries to start
+optimizing it again if the situation is changed.
+
+If the kprobe can be optimized, Kprobes enqueues the kprobe to an
+optimizing list, and kicks the kprobe-optimizer workqueue to optimize
+it.  If the to-be-optimized probepoint is hit before being optimized,
+Kprobes returns control to the original instruction path by setting
+the CPU's instruction pointer to the copied code in the detour buffer
+-- thus at least avoiding the single-step.
+
+1.4.5 Optimization
+
+The Kprobe-optimizer doesn't insert the jump instruction immediately;
+rather, it calls synchronize_sched() for safety first, because it's
+possible for a CPU to be interrupted in the middle of executing the
+optimized region(*).  As you know, synchronize_sched() can ensure
+that all interruptions that were active when synchronize_sched()
+was called are done, but only if CONFIG_PREEMPT=n.  So, this version
+of kprobe optimization supports only kernels with CONFIG_PREEMPT=n.(**)
+
+After that, the Kprobe-optimizer calls stop_machine() to replace
+the optimized region with a jump instruction to the detour buffer,
+using text_poke_smp().
+
+1.4.6 Unoptimization
+
+When an optimized kprobe is unregistered, disabled, or blocked by
+another kprobe, it will be unoptimized.  If this happens before
+the optimization is complete, the kprobe is just dequeued from the
+optimized list.  If the optimization has been done, the jump is
+replaced with the original code (except for an int3 breakpoint in
+the first byte) by using text_poke_smp().
+
+(*)Please imagine that the 2nd instruction is interrupted and then
+the optimizer replaces the 2nd instruction with the jump *address*
+while the interrupt handler is running. When the interrupt
+returns to original address, there is no valid instruction,
+and it causes an unexpected result.
+
+(**)This optimization-safety checking may be replaced with the
+stop-machine method that ksplice uses for supporting a CONFIG_PREEMPT=y
+kernel.
+
+NOTE for geeks:
+The jump optimization changes the kprobe's pre_handler behavior.
+Without optimization, the pre_handler can change the kernel's execution
+path by changing regs->ip and returning 1.  However, when the probe
+is optimized, that modification is ignored.  Thus, if you want to
+tweak the kernel's execution path, you need to suppress optimization,
+using one of the following techniques:
+- Specify an empty function for the kprobe's post_handler or break_handler.
+ or
+- Config CONFIG_OPTPROBES=n.
+ or
+- Execute 'sysctl -w debug.kprobes_optimization=n'
+
 2. Architectures Supported
 
 Kprobes, jprobes, and return probes are implemented on the following
 architectures:
 
-- i386
-- x86_64 (AMD-64, EM64T)
+- i386 (Supports jump optimization)
+- x86_64 (AMD-64, EM64T) (Supports jump optimization)
 - ppc64
 - ia64 (Does not support probes on instruction slot1.)
 - sparc64 (Return probes not yet implemented.)
@@ -193,6 +307,10 @@ it useful to "Compile the kernel with debug info" (CONFIG_DEBUG_INFO),
 so you can use "objdump -d -l vmlinux" to see the source-to-object
 code mapping.
 
+If you want to reduce probing overhead, set "Kprobes jump optimization
+support" (CONFIG_OPTPROBES) to "y". You can find this option under the
+"Kprobes" line.
+
 4. API Reference
 
 The Kprobes API includes a "register" function and an "unregister"
@@ -389,7 +507,10 @@ the probe which has been registered.
 
 Kprobes allows multiple probes at the same address.  Currently,
 however, there cannot be multiple jprobes on the same function at
-the same time.
+the same time.  Also, a probepoint for which there is a jprobe or
+a post_handler cannot be optimized.  So if you install a jprobe,
+or a kprobe with a post_handler, at an optimized probepoint, the
+probepoint will be unoptimized automatically.
 
 In general, you can install a probe anywhere in the kernel.
 In particular, you can probe interrupt handlers.  Known exceptions
@@ -453,6 +574,38 @@ reason, Kprobes doesn't support return probes (or kprobes or jprobes)
 on the x86_64 version of __switch_to(); the registration functions
 return -EINVAL.
 
+On x86/x86-64, since the Jump Optimization of Kprobes modifies
+instructions widely, there are some limitations to optimization. To
+explain it, we introduce some terminology. Imagine a 3-instruction
+sequence consisting of a two 2-byte instructions and one 3-byte
+instruction.
+
+        IA
+         |
+[-2][-1][0][1][2][3][4][5][6][7]
+        [ins1][ins2][  ins3 ]
+	[<-     DCR       ->]
+	   [<- JTPR ->]
+
+ins1: 1st Instruction
+ins2: 2nd Instruction
+ins3: 3rd Instruction
+IA:  Insertion Address
+JTPR: Jump Target Prohibition Region
+DCR: Detoured Code Region
+
+The instructions in DCR are copied to the out-of-line buffer
+of the kprobe, because the bytes in DCR are replaced by
+a 5-byte jump instruction. So there are several limitations.
+
+a) The instructions in DCR must be relocatable.
+b) The instructions in DCR must not include a call instruction.
+c) JTPR must not be targeted by any jump or call instruction.
+d) DCR must not straddle the border betweeen functions.
+
+Anyway, these limitations are checked by the in-kernel instruction
+decoder, so you don't need to worry about that.
+
 6. Probe Overhead
 
 On a typical CPU in use in 2005, a kprobe hit takes 0.5 to 1.0
@@ -476,6 +629,19 @@ k = 0.49 usec; j = 0.76; r = 0.80; kr = 0.82; jr = 1.07
 ppc64: POWER5 (gr), 1656 MHz (SMT disabled, 1 virtual CPU per physical CPU)
 k = 0.77 usec; j = 1.31; r = 1.26; kr = 1.45; jr = 1.99
 
+6.1 Optimized Probe Overhead
+
+Typically, an optimized kprobe hit takes 0.07 to 0.1 microseconds to
+process. Here are sample overhead figures (in usec) for x86 architectures.
+k = unoptimized kprobe, b = boosted (single-step skipped), o = optimized kprobe,
+r = unoptimized kretprobe, rb = boosted kretprobe, ro = optimized kretprobe.
+
+i386: Intel(R) Xeon(R) E5410, 2.33GHz, 4656.90 bogomips
+k = 0.80 usec; b = 0.33; o = 0.05; r = 1.10; rb = 0.61; ro = 0.33
+
+x86-64: Intel(R) Xeon(R) E5410, 2.33GHz, 4656.90 bogomips
+k = 0.99 usec; b = 0.43; o = 0.06; r = 1.24; rb = 0.68; ro = 0.30
+
 7. TODO
 
 a. SystemTap (http://sourceware.org/systemtap): Provides a simplified
@@ -523,7 +689,8 @@ is also specified. Following columns show probe status. If the probe is on
 a virtual address that is no longer valid (module init sections, module
 virtual addresses that correspond to modules that've been unloaded),
 such probes are marked with [GONE]. If the probe is temporarily disabled,
-such probes are marked with [DISABLED].
+such probes are marked with [DISABLED]. If the probe is optimized, it is
+marked with [OPTIMIZED].
 
 /sys/kernel/debug/kprobes/enabled: Turn kprobes ON/OFF forcibly.
 
@@ -533,3 +700,19 @@ registered probes will be disarmed, till such time a "1" is echoed to this
 file. Note that this knob just disarms and arms all kprobes and doesn't
 change each probe's disabling state. This means that disabled kprobes (marked
 [DISABLED]) will be not enabled if you turn ON all kprobes by this knob.
+
+
+Appendix B: The kprobes sysctl interface
+
+/proc/sys/debug/kprobes-optimization: Turn kprobes optimization ON/OFF.
+
+When CONFIG_OPTPROBES=y, this sysctl interface appears and it provides
+a knob to globally and forcibly turn jump optimization (see section
+1.4) ON or OFF. By default, jump optimization is allowed (ON).
+If you echo "0" to this file or set "debug.kprobes_optimization" to
+0 via sysctl, all optimized probes will be unoptimized, and any new
+probes registered after that will not be optimized.  Note that this
+knob *changes* the optimized state. This means that optimized probes
+(marked [OPTIMIZED]) will be unoptimized ([OPTIMIZED] tag will be
+removed). If the knob is turned on, they will be optimized again.
+


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
