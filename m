Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934042Ab0BEWkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 17:40:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933957Ab0BEWki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 17:40:38 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v9 9/9] kprobes: Add documents of jump optimization
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
Date: Fri, 05 Feb 2010 17:47:22 -0500
Message-ID: <20100205224722.31959.62300.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20100205224613.31959.59651.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100205224613.31959.59651.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentations about kprobe jump optimization to Documentation/kprobes.txt.

Changes in v8:
 - Update documentation and benchmark results.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
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

 Documentation/kprobes.txt |  191 ++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 178 insertions(+), 13 deletions(-)

diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index 053037a..48af218 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -1,6 +1,7 @@
 Title	: Kernel Probes (Kprobes)
 Authors	: Jim Keniston <jkenisto@us.ibm.com>
 	: Prasanna S Panchamukhi <prasanna@in.ibm.com>
+	: Masami Hiramatsu <mhiramat@redhat.com>
 
 CONTENTS
 
@@ -14,6 +15,7 @@ CONTENTS
 8. Kprobes Example
 9. Jprobes Example
 10. Kretprobes Example
+11. Optimization Example
 Appendix A: The kprobes debugfs interface
 
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
+probes work and how the optimization works.  They explain certain
+things that you'll need to know in order to make the best use of
+Kprobes -- e.g., the difference between a pre_handler and
+a post_handler, and how to use the maxactive and nmissed fields of
+a kretprobe.  But if you're in a hurry to start using Kprobes, you
+can skip ahead to section 2.
 
 1.1 How Does a Kprobe Work?
 
@@ -161,13 +163,109 @@ In case probed function is entered but there is no kretprobe_instance
 object available, then in addition to incrementing the nmissed count,
 the user entry_handler invocation is also skipped.
 
+1.4 How Does the Optimization Work?
+
+ If you configured kernel with CONFIG_OPTPROBES=y (currently this option is
+supported on x86/x86-64, non-preemptive kernel) and
+"debug.kprobes_optimization" sysctl sets 1, kprobes tries to use a
+jump instruction instead of breakpoint instruction automatically.
+
+1.4.1 Init a Kprobe
+
+ Before preparing optimization, Kprobes inserts original(user-defined)
+kprobe on the specified address. So, even if the kprobe is not
+possible to be optimized, it just uses a normal kprobe.
+
+1.4.2 Safety check
+
+ First, Kprobes gets the address of probed function and checks whether the
+optimized region, which will be replaced by a jump instruction, does NOT
+straddle the function boundary, because if the optimized region reaches the
+next function, its caller causes unexpected results.
+ Next, Kprobes decodes whole body of probed function and checks there is
+NO indirect jump, NO instruction which will cause exception by checking
+exception_tables (this will jump to fixup code and fixup code jumps into
+same function body) and NO near jump which jumps into the optimized region
+(except the 1st byte of jump), because if some jump instruction jumps
+into the middle of another instruction, it causes unexpected results too.
+ Kprobes also measures the length of instructions which will be replaced
+by a jump instruction, because a jump instruction is longer than 1 byte,
+it may replaces multiple instructions, and it checks whether those
+instructions can be executed out-of-line.
+
+1.4.3 Preparing detour buffer
+
+ Then, Kprobes prepares "detour" buffer, which contains exception emulating
+code (push/pop registers, call handler), copied instructions(Kprobes copies
+instructions which will be replaced by a jump, to the detour buffer), and
+a jump which jumps back to the original execution path.
+
+1.4.4 Pre-optimization
+
+ After preparing detour buffer, Kprobes checks that the probe is *NOT* in
+the below cases;
+ - The probe has either break_handler or post_handler.
+ - Other probes are probing the instructions which will be replaced by
+   a jump instruction.
+ - The probe is disabled.
+In above cases, Kprobes just doesn't start optimizating the probe.
+
+ If the kprobe can be optimized, Kprobes enqueues the kprobe to optimizing
+list and kicks kprobe-optimizer workqueue to optimize it. To wait other
+optimized probes, kprobe-optimizer will delay to work.
+ When the optimized-kprobe is hit before optimization, its handler changes
+IP(instruction pointer) to copied code and exits. So, the instructions which
+were copied to detour buffer are executed on the detour buffer.
+
+1.4.5 Optimization
+
+  Kprobe-optimizer doesn't start instruction-replacing soon, it waits
+ synchronize_sched for safety, because some processors are possible to be
+ interrupted on the middle of instruction series (2nd or Nth instruction)
+ which will be replaced by a jump instruction(*).
+ As you know, synchronize_sched() can ensure that all interruptions which
+ were executed when synchronize_sched() was called are done, only if
+ CONFIG_PREEMPT=n. So, this version supports only the kernel with
+ CONFIG_PREEMPT=n.(**)
+  After that, kprobe-optimizer calls stop_machine() to replace probed-
+ instructions with a jump instruction by using text_poke_smp().
+
+1.4.6 Unoptimization
+  When unregistering, disabling kprobe or being blocked by other kprobe,
+ an optimized-kprobe will be unoptimized. Before kprobe-optimizer runs,
+ the kprobe is just dequeued from the optimized list. When the optimization
+ has been done, it replaces a jump with int3 breakpoint and original code
+ by using text_poke_smp().
+
+(*)Please imagine that 2nd instruction is interrupted and
+optimizer replaces the 2nd instruction with jump *address*
+while the interrupt handler is running. When the interrupt
+returns to original address, there is no valid instructions
+and it causes unexpected result.
+
+(**)This optimization-safety checking may be replaced with stop-machine
+method which ksplice is done for supporting CONFIG_PREEMPT=y kernel.
+
+NOTE for geeks:
+The jump optimization changes the kprobe's pre_handler behavior.
+Without optimization, pre_handler can change kernel execution path by
+changing regs->ip and return 1. However, after optimizing the probe,
+that modification is ignored. Thus, if you'd like to tweak kernel
+execution path, you need to avoid optimization. In that case, you can
+choose either,
+ - Set empty function to post_handler or break_handler.
+ or
+ - Config CONFIG_OPTPROBES=n.
+ or
+ - Execute 'sysctl -w debug.kprobes_optimization=n'
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
@@ -193,6 +291,10 @@ it useful to "Compile the kernel with debug info" (CONFIG_DEBUG_INFO),
 so you can use "objdump -d -l vmlinux" to see the source-to-object
 code mapping.
 
+If you want to reduce probing overhead, set "Kprobes jump optimization
+support" (CONFIG_OPTPROBES) to "y". You can find this option under
+"Kprobes" line.
+
 4. API Reference
 
 The Kprobes API includes a "register" function and an "unregister"
@@ -387,9 +489,12 @@ the probe which has been registered.
 
 5. Kprobes Features and Limitations
 
-Kprobes allows multiple probes at the same address.  Currently,
-however, there cannot be multiple jprobes on the same function at
-the same time.
+Kprobes allows multiple probes at the same address even if it is optimized.
+Currently, however, there cannot be multiple jprobes on the same function
+at the same time. And also, optimized kprobes can not invoke the
+post_handler and the break_handler. So if you attempt to install the probe
+which has the the post_handler or the break_handler at the same address of
+an optimized kprobe, the probe will be unoptimized automatically.
 
 In general, you can install a probe anywhere in the kernel.
 In particular, you can probe interrupt handlers.  Known exceptions
@@ -453,6 +558,37 @@ reason, Kprobes doesn't support return probes (or kprobes or jprobes)
 on the x86_64 version of __switch_to(); the registration functions
 return -EINVAL.
 
+On x86/x86-64, since the Jump Optimization of Kprobes modifies instructions
+widely, there are some limitations for optimization. To explain it,
+we introduce some terminology. Image certain binary line which is
+constructed by 2 byte instruction, 2byte instruction and 3byte instruction.
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
+of the djprobe instance, because the bytes in JTPR are replaced by
+a jump instruction. So, there are several limitations.
+
+a) The instructions in DCR must be relocatable.
+b) The instructions in DCR must not include call instruction.
+c) JTPR must not be targeted by any jump or call instruction.
+d) DCR must not straddle the border betweeen functions.
+
+Anyway, these limitations are checked by in-kernel instruction decoder,
+so you don't need to care about that.
+
 6. Probe Overhead
 
 On a typical CPU in use in 2005, a kprobe hit takes 0.5 to 1.0
@@ -476,6 +612,19 @@ k = 0.49 usec; j = 0.76; r = 0.80; kr = 0.82; jr = 1.07
 ppc64: POWER5 (gr), 1656 MHz (SMT disabled, 1 virtual CPU per physical CPU)
 k = 0.77 usec; j = 1.31; r = 1.26; kr = 1.45; jr = 1.99
 
+6.1 Optimized Probe Overhead
+
+Typically, an optimized kprobe hit takes 0.07 to 0.1 microseconds to
+process. Here are sample overhead figures (in usec) for x86-64 architectures.
+k = unoptimized kprobe, b = boosted(single-step skipped), o = optimized kprobe,
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
@@ -523,7 +672,8 @@ is also specified. Following columns show probe status. If the probe is on
 a virtual address that is no longer valid (module init sections, module
 virtual addresses that correspond to modules that've been unloaded),
 such probes are marked with [GONE]. If the probe is temporarily disabled,
-such probes are marked with [DISABLED].
+such probes are marked with [DISABLED]. If the probe is optimized, it is
+marked with [OPTIMIZED].
 
 /sys/kernel/debug/kprobes/enabled: Turn kprobes ON/OFF forcibly.
 
@@ -533,3 +683,18 @@ registered probes will be disarmed, till such time a "1" is echoed to this
 file. Note that this knob just disarms and arms all kprobes and doesn't
 change each probe's disabling state. This means that disabled kprobes (marked
 [DISABLED]) will be not enabled if you turn ON all kprobes by this knob.
+
+
+Appendix B: The kprobes sysctl interface
+
+/proc/sys/debug/kprobes-optimization: Turn kprobes optimization ON/OFF.
+
+When CONFIG_OPTPROBES=y, this sysctl interface appears and it provides a knob
+to globally and forcibly turn the jump optimization ON or OFF. By default,
+jump optimization is allowed(ON). By echoing "0" to this file or By setting
+0 to "debug.kprobes_optimization" via sysctl, all optimized probes will be
+unoptimized. And new probes registered after that will not be optimized.
+Note that this knob *Changes* the optimized state. This means that optimized
+probes (marked [OPTIMIZED]) will be unoptimized ([OPTIMIZED] tag will be
+removed). And after the knob is turned on, it will be optimized again.
+


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
