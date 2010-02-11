Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab0BKTCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 14:02:37 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38650 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756629Ab0BKTCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 14:02:35 -0500
Subject: Re: [PATCH -tip v9 9/9] kprobes: Add documents of jump optimization
From: Jim Keniston <jkenisto@us.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Content-Type: text/plain
Date: Thu, 11 Feb 2010 11:01:36 -0800
Message-Id: <1265914896.5150.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-05 at 17:47 -0500, Masami Hiramatsu wrote:
> Add documentations about kprobe jump optimization to Documentation/kprobes.txt.

Hi, Masami.  I reviewed your patch, and I recommend the enclosed editorial fixups
and clarifications.  The enclosed patch is a diff between your version (resulting
from your patch #9 v9) and mine.  If you incorporate most or all of these changes,
feel free to mark the result as Signed-off-by or Acked-by me.

Jim Keniston

diff -upr masami/Documentation/kprobes.txt jimk/Documentation/kprobes.txt
--- masami/Documentation/kprobes.txt	2010-02-08 13:01:15.000000000 -0800
+++ jimk/Documentation/kprobes.txt	2010-02-11 10:38:15.000000000 -0800
@@ -1,6 +1,6 @@
 Title	: Kernel Probes (Kprobes)
 Authors	: Jim Keniston <jkenisto@us.ibm.com>
-	: Prasanna S Panchamukhi <prasanna@in.ibm.com>
+	: Prasanna S Panchamukhi <prasanna.panchamukhi@gmail.com>
 	: Masami Hiramatsu <mhiramat@redhat.com>
 
 CONTENTS
@@ -15,8 +15,8 @@ CONTENTS
 8. Kprobes Example
 9. Jprobes Example
 10. Kretprobes Example
-11. Optimization Example
 Appendix A: The kprobes debugfs interface
+Appendix B: The kprobes sysctl interface
 
 1. Concepts: Kprobes, Jprobes, Return Probes
 
@@ -45,7 +45,7 @@ can speed up unregistration process when
 a lot of probes at once.
 
 The next four subsections explain how the different types of
-probes work and how the optimization works.  They explain certain
+probes work and how jump optimization works.  They explain certain
 things that you'll need to know in order to make the best use of
 Kprobes -- e.g., the difference between a pre_handler and
 a post_handler, and how to use the maxactive and nmissed fields of
@@ -163,101 +163,115 @@ In case probed function is entered but t
 object available, then in addition to incrementing the nmissed count,
 the user entry_handler invocation is also skipped.
 
-1.4 How Does the Optimization Work?
+1.4 How Does Jump Optimization Work?
 
- If you configured kernel with CONFIG_OPTPROBES=y (currently this option is
-supported on x86/x86-64, non-preemptive kernel) and
-"debug.kprobes_optimization" sysctl sets 1, kprobes tries to use a
-jump instruction instead of breakpoint instruction automatically.
+If you configured your kernel with CONFIG_OPTPROBES=y (currently
+this option is supported on x86/x86-64, non-preemptive kernel) and
+the "debug.kprobes_optimization" kernel parameter is set to 1 (see
+sysctl(8)), Kprobes tries to reduce probe-hit overhead by using a jump
+instruction instead of a breakpoint instruction at each probepoint.
 
 1.4.1 Init a Kprobe
 
- Before preparing optimization, Kprobes inserts original(user-defined)
-kprobe on the specified address. So, even if the kprobe is not
-possible to be optimized, it just uses a normal kprobe.
-
-1.4.2 Safety check
-
- First, Kprobes gets the address of probed function and checks whether the
-optimized region, which will be replaced by a jump instruction, does NOT
-straddle the function boundary, because if the optimized region reaches the
-next function, its caller causes unexpected results.
- Next, Kprobes decodes whole body of probed function and checks there is
-NO indirect jump, NO instruction which will cause exception by checking
-exception_tables (this will jump to fixup code and fixup code jumps into
-same function body) and NO near jump which jumps into the optimized region
-(except the 1st byte of jump), because if some jump instruction jumps
-into the middle of another instruction, it causes unexpected results too.
- Kprobes also measures the length of instructions which will be replaced
-by a jump instruction, because a jump instruction is longer than 1 byte,
-it may replaces multiple instructions, and it checks whether those
-instructions can be executed out-of-line.
-
-1.4.3 Preparing detour buffer
-
- Then, Kprobes prepares "detour" buffer, which contains exception emulating
-code (push/pop registers, call handler), copied instructions(Kprobes copies
-instructions which will be replaced by a jump, to the detour buffer), and
-a jump which jumps back to the original execution path.
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
+- a call to the user's probe handler
+- code to restore registers
+- the instructions from the optimized region
+- a jump back to the original execution path.
 
 1.4.4 Pre-optimization
 
- After preparing detour buffer, Kprobes checks that the probe is *NOT* in
-the below cases;
- - The probe has either break_handler or post_handler.
- - Other probes are probing the instructions which will be replaced by
-   a jump instruction.
- - The probe is disabled.
-In above cases, Kprobes just doesn't start optimizating the probe.
-
- If the kprobe can be optimized, Kprobes enqueues the kprobe to optimizing
-list and kicks kprobe-optimizer workqueue to optimize it. To wait other
-optimized probes, kprobe-optimizer will delay to work.
- When the optimized-kprobe is hit before optimization, its handler changes
-IP(instruction pointer) to copied code and exits. So, the instructions which
-were copied to detour buffer are executed on the detour buffer.
+After preparing the detour buffer, Kprobes verifies that none of the
+following situations exist:
+- The probe has either a break_handler (i.e., it's a jprobe) or a
+post_handler.
+- Other instructions in the optimized region are probed.
+- The probe is disabled.
+In any of the above cases, Kprobes won't optimize the probe.
+
+If the kprobe can be optimized, Kprobes enqueues the kprobe to an
+optimizing list, and kicks the kprobe-optimizer workqueue to optimize
+it.  If the to-be-optimized probepoint is hit before being optimized,
+Kprobes returns control to the original instruction path by setting
+the CPU's instruction pointer to the copied code in the detour buffer
+-- thus at least avoiding the single-step.
 
 1.4.5 Optimization
 
-  Kprobe-optimizer doesn't start instruction-replacing soon, it waits
- synchronize_sched for safety, because some processors are possible to be
- interrupted on the middle of instruction series (2nd or Nth instruction)
- which will be replaced by a jump instruction(*).
- As you know, synchronize_sched() can ensure that all interruptions which
- were executed when synchronize_sched() was called are done, only if
- CONFIG_PREEMPT=n. So, this version supports only the kernel with
- CONFIG_PREEMPT=n.(**)
-  After that, kprobe-optimizer calls stop_machine() to replace probed-
- instructions with a jump instruction by using text_poke_smp().
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
 
 1.4.6 Unoptimization
-  When unregistering, disabling kprobe or being blocked by other kprobe,
- an optimized-kprobe will be unoptimized. Before kprobe-optimizer runs,
- the kprobe is just dequeued from the optimized list. When the optimization
- has been done, it replaces a jump with int3 breakpoint and original code
- by using text_poke_smp().
 
-(*)Please imagine that 2nd instruction is interrupted and
-optimizer replaces the 2nd instruction with jump *address*
+When an optimized kprobe is unregistered, disabled, or blocked by
+another kprobe, it will be unoptimized.  If this happens before
+the optimization is complete, the kprobe is just dequeued from the
+optimized list.  If the optimization has been done, the jump is
+replaced with the original code (except for an int3 breakpoint in
+the first byte) by using text_poke_smp().
+
+(*)Please imagine that the 2nd instruction is interrupted and then
+the optimizer replaces the 2nd instruction with the jump *address*
 while the interrupt handler is running. When the interrupt
-returns to original address, there is no valid instructions
-and it causes unexpected result.
+returns to original address, there is no valid instruction,
+and it causes an unexpected result.
 
-(**)This optimization-safety checking may be replaced with stop-machine
-method which ksplice is done for supporting CONFIG_PREEMPT=y kernel.
+(**)This optimization-safety checking may be replaced with the
+stop-machine method that ksplice uses for supporting a CONFIG_PREEMPT=y
+kernel.
 
 NOTE for geeks:
 The jump optimization changes the kprobe's pre_handler behavior.
-Without optimization, pre_handler can change kernel execution path by
-changing regs->ip and return 1. However, after optimizing the probe,
-that modification is ignored. Thus, if you'd like to tweak kernel
-execution path, you need to avoid optimization. In that case, you can
-choose either,
- - Set empty function to post_handler or break_handler.
+Without optimization, the pre_handler can change the kernel's execution
+path by changing regs->ip and returning 1.  However, when the probe
+is optimized, that modification is ignored.  Thus, if you want to
+tweak the kernel's execution path, you need to suppress optimization,
+using one of the following techniques:
+- Specify an empty function for the kprobe's post_handler or break_handler.
  or
- - Config CONFIG_OPTPROBES=n.
+- Config CONFIG_OPTPROBES=n.
  or
- - Execute 'sysctl -w debug.kprobes_optimization=n'
+- Execute 'sysctl -w debug.kprobes_optimization=n'
 
 2. Architectures Supported
 
@@ -292,7 +306,7 @@ so you can use "objdump -d -l vmlinux" t
 code mapping.
 
 If you want to reduce probing overhead, set "Kprobes jump optimization
-support" (CONFIG_OPTPROBES) to "y". You can find this option under
+support" (CONFIG_OPTPROBES) to "y". You can find this option under the
 "Kprobes" line.
 
 4. API Reference
@@ -489,12 +503,12 @@ the probe which has been registered.
 
 5. Kprobes Features and Limitations
 
-Kprobes allows multiple probes at the same address even if it is optimized.
-Currently, however, there cannot be multiple jprobes on the same function
-at the same time. And also, optimized kprobes can not invoke the
-post_handler and the break_handler. So if you attempt to install the probe
-which has the the post_handler or the break_handler at the same address of
-an optimized kprobe, the probe will be unoptimized automatically.
+Kprobes allows multiple probes at the same address.  Currently,
+however, there cannot be multiple jprobes on the same function at
+the same time.  Also, a probepoint for which there is a jprobe or
+a post_handler cannot be optimized.  So if you install a jprobe,
+or a kprobe with a post_handler, at an optimized probepoint, the
+probepoint will be unoptimized automatically.
 
 In general, you can install a probe anywhere in the kernel.
 In particular, you can probe interrupt handlers.  Known exceptions
@@ -558,10 +572,11 @@ reason, Kprobes doesn't support return p
 on the x86_64 version of __switch_to(); the registration functions
 return -EINVAL.
 
-On x86/x86-64, since the Jump Optimization of Kprobes modifies instructions
-widely, there are some limitations for optimization. To explain it,
-we introduce some terminology. Image certain binary line which is
-constructed by 2 byte instruction, 2byte instruction and 3byte instruction.
+On x86/x86-64, since the Jump Optimization of Kprobes modifies
+instructions widely, there are some limitations to optimization. To
+explain it, we introduce some terminology. Imagine a 3-instruction
+sequence consisting of a two 2-byte instructions and one 3-byte
+instruction.
 
         IA
          |
@@ -578,16 +593,16 @@ JTPR: Jump Target Prohibition Region
 DCR: Detoured Code Region
 
 The instructions in DCR are copied to the out-of-line buffer
-of the djprobe instance, because the bytes in JTPR are replaced by
-a jump instruction. So, there are several limitations.
+of the kprobe, because the bytes in DCR are replaced by
+a 5-byte jump instruction. So there are several limitations.
 
 a) The instructions in DCR must be relocatable.
-b) The instructions in DCR must not include call instruction.
+b) The instructions in DCR must not include a call instruction.
 c) JTPR must not be targeted by any jump or call instruction.
 d) DCR must not straddle the border betweeen functions.
 
-Anyway, these limitations are checked by in-kernel instruction decoder,
-so you don't need to care about that.
+Anyway, these limitations are checked by the in-kernel instruction
+decoder, so you don't need to worry about that.
 
 6. Probe Overhead
 
@@ -615,8 +630,8 @@ k = 0.77 usec; j = 1.31; r = 1.26; kr = 
 6.1 Optimized Probe Overhead
 
 Typically, an optimized kprobe hit takes 0.07 to 0.1 microseconds to
-process. Here are sample overhead figures (in usec) for x86-64 architectures.
-k = unoptimized kprobe, b = boosted(single-step skipped), o = optimized kprobe,
+process. Here are sample overhead figures (in usec) for x86 architectures.
+k = unoptimized kprobe, b = boosted (single-step skipped), o = optimized kprobe,
 r = unoptimized kretprobe, rb = boosted kretprobe, ro = optimized kretprobe.
 
 i386: Intel(R) Xeon(R) E5410, 2.33GHz, 4656.90 bogomips
@@ -689,12 +704,13 @@ Appendix B: The kprobes sysctl interface
 
 /proc/sys/debug/kprobes-optimization: Turn kprobes optimization ON/OFF.
 
-When CONFIG_OPTPROBES=y, this sysctl interface appears and it provides a knob
-to globally and forcibly turn the jump optimization ON or OFF. By default,
-jump optimization is allowed(ON). By echoing "0" to this file or By setting
-0 to "debug.kprobes_optimization" via sysctl, all optimized probes will be
-unoptimized. And new probes registered after that will not be optimized.
-Note that this knob *Changes* the optimized state. This means that optimized
-probes (marked [OPTIMIZED]) will be unoptimized ([OPTIMIZED] tag will be
-removed). And after the knob is turned on, it will be optimized again.
+When CONFIG_OPTPROBES=y, this sysctl interface appears and it provides
+a knob to globally and forcibly turn jump optimization (see section
+1.4) ON or OFF. By default, jump optimization is allowed (ON).
+If you echo "0" to this file or set "debug.kprobes_optimization" to
+0 via sysctl, all optimized probes will be unoptimized, and any new
+probes registered after that will not be optimized.  Note that this
+knob *changes* the optimized state. This means that optimized probes
+(marked [OPTIMIZED]) will be unoptimized ([OPTIMIZED] tag will be
+removed). If the knob is turned on, they will be optimized again.
 


