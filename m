Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbZDFVlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbZDFVlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757771AbZDFVlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:41:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45727 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbZDFVlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:41:20 -0400
Message-ID: <49DA7702.5030308@redhat.com>
Date: Mon, 06 Apr 2009 17:41:22 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Vegard Nossum <vegard.nossum@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       Avi Kivity <avi@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Satoshi Oshima <satoshi.oshima.fk@hitachi.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PROTO][PATCH -tip 0/7] kprobes: support jump optimization on
 x86
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------030107070306070804060109"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030107070306070804060109
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

Here, I'd like to show you another x86 insn decoder user.
These are the prototype patchset of the kprobes jump optimization
(a.k.a. Djprobe, which I had developed two years ago). Finally,
I rewrote it as the jump optimized probe. These patches are still
under development, it neither support temporary disabling, nor
support debugfs interface. However, its basic functions(register/
unregister/optimizing/safety check) are implemented.

 These patches can be applied on -tip tree + following patches;
  - kprobes patches on -mm tree (I attached on this mail)
 And below patches which I sent last week.
  - x86: instruction decorder API
  - x86: kprobes checks safeness of insertion address.

 So, this is another example of x86 instruction decoder.

(Andrew, I ported some of -mm patches to -tip tree just for
 preventing source code forking. This should be done on -tip,
 because x86-instruction decoder has been discussed on -tip)


Jump Optimized Kprobes
======================
o What is jump optimization?
 Kprobes uses the int3 breakpoint instruction on x86 for instrumenting
probes into running kernel. Jump optimization allows kprobes to replace
breakpoint with a jump instruction for reducing probing overhead drastically.


o Advantage and Disadvantage
 The advantage is process time performance. Usually, a kprobe hit takes
0.5 to 1.0 microseconds to process. On the other hand, a jump optimized
probe hit takes less than 0.1 microseconds (actual number depends on the
processor). Here is a sample overheads.

Intel(R) Xeon(R) CPU E5410  @ 2.33GHz (running in 2GHz)

                     x86-32  x86-64
kprobe:              1.00us  1.05us
kprobe+booster:	     0.45us  0.50us
kprobe+optimized:    0.05us  0.07us

kretprobe :          1.77us  1.45us
kretprobe+booster:   1.30us  0.90us
kretprobe+optimized: 1.02us  0.40us

 However, there is a disadvantage (the law of equivalent exchange :)) too,
which is memory consumption. Jump optimization requires optimized_kprobe
data structure, and additional bigger instruction buffer than kprobe,
which contains exception emulating code (push/pop registers), copied
instructions, and a jump. Those data consumes 145 bytes(x86-32) of
memory per probe.

Briefly speaking, an optimized kprobe 5 times faster and 3 times bigger
than a kprobe.

Anyway, you can choose that you'd like to optimize your kprobes by setting
KPROBE_FLAG_OPTIMIZE to kp->flags field.


o How to use it?
 What you need to optimize your *probe is just adding KPROBE_FLAG_OPTIMIZE
to kp.flags before registering.

E.g.
 (setup handler/addr/symbol...)
 kp->flags |= KPROBE_FLAG_OPTIMIZE;
 (register kp)

 That's all. :-)

 kprobes decodes probed function and checks whether the target instructions
can be optimized(replaced with a jump) safely. If it can't, kprobes clears
KPROBE_FLAG_OPTIMIZE from kp->flags. So, you can check it after registering.


o How it works?
 kprobe jump optimization looks like an aggregated kprobe.

 Before preparing optimization, kprobe inserts original(user-defined)
 kprobe on the specified address. So, even if the kprobe is not
 possible to be optimized, it just fall back to a normal kprobe.

 - Safety check
  First, kprobe decodes whole body of probed function and checks
 whether there is NO indirect jump, and near jump which jumps into the
 region which will be replaced by a jump instruction (except the 1st
 byte of jump), because if some jump instruction jumps into the middle
 of another instruction, which causes unexpectable results.
  Kprobe also measures the length of instructions which will be replaced
 by a jump instruction, because a jump instruction is longer than 1 byte,
 it may replaces multiple instructions, and it checkes whether those
 instructions can be executed out-of-line.

 - Preparing detour code
  Next, kprobe prepares "detour" buffer, which contains exception emulating
 code (push/pop registers, call handler), copied instructions(kprobes copies
 instructions which will be replaced by a jump, to the detour buffer), and
 a jump which jumps back to the original execution path.

 - Pre-optimization
  After preparing detour code, kprobe kicks kprobe-optimizer workqueue to
 optimize kprobe. To wait other optimized_kprobes, kprobe optimizer will
 delay to work.
  When the optimized_kprobe is hit before optimization, its handler
 changes IP(instruction pointer) to detour code and exits. So, the
 instructions which were copied to detour buffer are not executed.

 - Optimization
  Kprobe-optimizer doesn't start instruction-replacing soon, it waits
 synchronize_sched for safety, because some processors are possible to be
 interrpted on the instructions which will be replaced by a jump instruction.
 As you know, synchronize_sched() can ensure that all interruptions which were
 executed when synchronize_sched() was called are done, only if CONFIG_PREEMPT=n.
 So, this version supports only the kernel with CONFIG_PREEMPT=n.(*)
  After that, kprobe-optimizer replaces the 4 bytes right after int3 breakpoint
 with relative-jump destination, and synchronize caches on all processors. Next,
 it replaces int3 with relative-jump opcode, and synchronize caches again.


(*)This optimization-safety checking may be replaced with stop-machine method
 which ksplice is done for supporting CONFIG_PREEMPT=y kernel.


 arch/Kconfig                   |   11 +
 arch/x86/Kconfig               |    1 +
 arch/x86/include/asm/kprobes.h |   25 ++-
 arch/x86/kernel/kprobes.c      |  483 +++++++++++++++++++++++++++++++++-------
 include/linux/kprobes.h        |   25 ++
 kernel/kprobes.c               |  294 ++++++++++++++++++++-----
 6 files changed, 707 insertions(+), 132 deletions(-)

NOTE: As I said, Attached patches are just ported from -mm tree,
      so those are NOT included in above statistics.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


--------------030107070306070804060109
Content-Type: text/plain;
 name="kprobes-cleanup-aggr_kprobe-related-code.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kprobes-cleanup-aggr_kprobe-related-code.patch"

Currently, kprobes can disable all probes at once, but can't disable it

From: Masami Hiramatsu <mhiramat@redhat.com>

individually (not unregister, just disable an kprobe, because
unregistering needs to wait for scheduler synchronization).  These patches
introduce APIs for on-the-fly per-probe disabling and re-enabling by
dis-arming/re-arming its breakpoint instruction.


This patch:

Change old_p to ap in add_new_kprobe() for readability, copy flags member
in add_aggr_kprobe(), and simplify the code flow of
register_aggr_kprobe().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |   60 +++++++++++++++++++++++++++---------------------------
 1 files changed, 30 insertions(+), 30 deletions(-)


diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 5016bfb..a55bfad 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -518,20 +518,20 @@ static inline void copy_kprobe(struct kprobe *old_p, struct kprobe *p)
 }
 
 /*
-* Add the new probe to old_p->list. Fail if this is the
+* Add the new probe to ap->list. Fail if this is the
 * second jprobe at the address - two jprobes can't coexist
 */
-static int __kprobes add_new_kprobe(struct kprobe *old_p, struct kprobe *p)
+static int __kprobes add_new_kprobe(struct kprobe *ap, struct kprobe *p)
 {
 	if (p->break_handler) {
-		if (old_p->break_handler)
+		if (ap->break_handler)
 			return -EEXIST;
-		list_add_tail_rcu(&p->list, &old_p->list);
-		old_p->break_handler = aggr_break_handler;
+		list_add_tail_rcu(&p->list, &ap->list);
+		ap->break_handler = aggr_break_handler;
 	} else
-		list_add_rcu(&p->list, &old_p->list);
-	if (p->post_handler && !old_p->post_handler)
-		old_p->post_handler = aggr_post_handler;
+		list_add_rcu(&p->list, &ap->list);
+	if (p->post_handler && !ap->post_handler)
+		ap->post_handler = aggr_post_handler;
 	return 0;
 }
 
@@ -544,6 +544,7 @@ static inline void add_aggr_kprobe(struct kprobe *ap, struct kprobe *p)
 	copy_kprobe(p, ap);
 	flush_insn_slot(ap);
 	ap->addr = p->addr;
+	ap->flags = p->flags;
 	ap->pre_handler = aggr_pre_handler;
 	ap->fault_handler = aggr_fault_handler;
 	/* We don't care the kprobe which has gone. */
@@ -566,44 +567,43 @@ static int __kprobes register_aggr_kprobe(struct kprobe *old_p,
 					  struct kprobe *p)
 {
 	int ret = 0;
-	struct kprobe *ap;
+	struct kprobe *ap = old_p;
 
-	if (kprobe_gone(old_p)) {
+	if (old_p->pre_handler != aggr_pre_handler) {
+		/* If old_p is not an aggr_probe, create new aggr_kprobe. */
+		ap = kzalloc(sizeof(struct kprobe), GFP_KERNEL);
+		if (!ap)
+			return -ENOMEM;
+		add_aggr_kprobe(ap, old_p);
+	}
+
+	if (kprobe_gone(ap)) {
 		/*
 		 * Attempting to insert new probe at the same location that
 		 * had a probe in the module vaddr area which already
 		 * freed. So, the instruction slot has already been
 		 * released. We need a new slot for the new probe.
 		 */
-		ret = arch_prepare_kprobe(old_p);
+		ret = arch_prepare_kprobe(ap);
 		if (ret)
+			/*
+			 * Even if fail to allocate new slot, don't need to
+			 * free aggr_probe. It will be used next time, or
+			 * freed by unregister_kprobe.
+			 */
 			return ret;
-	}
-	if (old_p->pre_handler == aggr_pre_handler) {
-		copy_kprobe(old_p, p);
-		ret = add_new_kprobe(old_p, p);
-		ap = old_p;
-	} else {
-		ap = kzalloc(sizeof(struct kprobe), GFP_KERNEL);
-		if (!ap) {
-			if (kprobe_gone(old_p))
-				arch_remove_kprobe(old_p);
-			return -ENOMEM;
-		}
-		add_aggr_kprobe(ap, old_p);
-		copy_kprobe(ap, p);
-		ret = add_new_kprobe(ap, p);
-	}
-	if (kprobe_gone(old_p)) {
+		/* Clear gone flag to prevent allocating new slot again. */
+		ap->flags &= ~KPROBE_FLAG_GONE;
 		/*
 		 * If the old_p has gone, its breakpoint has been disarmed.
 		 * We have to arm it again after preparing real kprobes.
 		 */
-		ap->flags &= ~KPROBE_FLAG_GONE;
 		if (kprobe_enabled)
 			arch_arm_kprobe(ap);
 	}
-	return ret;
+
+	copy_kprobe(ap, p);
+	return add_new_kprobe(ap, p);
 }
 
 static int __kprobes in_kprobes_functions(unsigned long addr)

--------------030107070306070804060109
Content-Type: text/plain;
 name="kprobes-cleanup-comment-style-in-kprobesh.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kprobes-cleanup-comment-style-in-kprobesh.patch"

Fix comment style in kprobes.h.

From: Masami Hiramatsu <mhiramat@redhat.com>

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kprobes.h |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)


diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 2ec6cc1..39826a6 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -94,12 +94,16 @@ struct kprobe {
 	/* Called after addr is executed, unless... */
 	kprobe_post_handler_t post_handler;
 
-	/* ... called if executing addr causes a fault (eg. page fault).
-	 * Return 1 if it handled fault, otherwise kernel will see it. */
+	/*
+	 * ... called if executing addr causes a fault (eg. page fault).
+	 * Return 1 if it handled fault, otherwise kernel will see it.
+	 */
 	kprobe_fault_handler_t fault_handler;
 
-	/* ... called if breakpoint trap occurs in probe handler.
-	 * Return 1 if it handled break, otherwise kernel will see it. */
+	/*
+	 * ... called if breakpoint trap occurs in probe handler.
+	 * Return 1 if it handled break, otherwise kernel will see it.
+	 */
 	kprobe_break_handler_t break_handler;
 
 	/* Saved opcode (which has been replaced with breakpoint) */

--------------030107070306070804060109
Content-Type: text/plain;
 name="kprobes-move-export_symbol_gpl-just-after-function-definitions.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="kprobes-move-export_symbol_gpl-just-after-function-definitio";
 filename*1="ns.patch"

Clean up positions of EXPORT_SYMBOL_GPL in kernel/kprobes.c according to

From: Masami Hiramatsu <mhiramat@redhat.com>

checkpatch.pl.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)


diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index a55bfad..ca4c22d 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -722,6 +722,7 @@ out:
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(register_kprobe);
 
 /*
  * Unregister a kprobe without a scheduler synchronization.
@@ -803,11 +804,13 @@ int __kprobes register_kprobes(struct kprobe **kps, int num)
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(register_kprobes);
 
 void __kprobes unregister_kprobe(struct kprobe *p)
 {
 	unregister_kprobes(&p, 1);
 }
+EXPORT_SYMBOL_GPL(unregister_kprobe);
 
 void __kprobes unregister_kprobes(struct kprobe **kps, int num)
 {
@@ -826,6 +829,7 @@ void __kprobes unregister_kprobes(struct kprobe **kps, int num)
 		if (kps[i]->addr)
 			__unregister_kprobe_bottom(kps[i]);
 }
+EXPORT_SYMBOL_GPL(unregister_kprobes);
 
 static struct notifier_block kprobe_exceptions_nb = {
 	.notifier_call = kprobe_exceptions_notify,
@@ -865,16 +869,19 @@ int __kprobes register_jprobes(struct jprobe **jps, int num)
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(register_jprobes);
 
 int __kprobes register_jprobe(struct jprobe *jp)
 {
 	return register_jprobes(&jp, 1);
 }
+EXPORT_SYMBOL_GPL(register_jprobe);
 
 void __kprobes unregister_jprobe(struct jprobe *jp)
 {
 	unregister_jprobes(&jp, 1);
 }
+EXPORT_SYMBOL_GPL(unregister_jprobe);
 
 void __kprobes unregister_jprobes(struct jprobe **jps, int num)
 {
@@ -894,6 +901,7 @@ void __kprobes unregister_jprobes(struct jprobe **jps, int num)
 			__unregister_kprobe_bottom(&jps[i]->kp);
 	}
 }
+EXPORT_SYMBOL_GPL(unregister_jprobes);
 
 #ifdef CONFIG_KRETPROBES
 /*
@@ -987,6 +995,7 @@ int __kprobes register_kretprobe(struct kretprobe *rp)
 		free_rp_inst(rp);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(register_kretprobe);
 
 int __kprobes register_kretprobes(struct kretprobe **rps, int num)
 {
@@ -1004,11 +1013,13 @@ int __kprobes register_kretprobes(struct kretprobe **rps, int num)
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(register_kretprobes);
 
 void __kprobes unregister_kretprobe(struct kretprobe *rp)
 {
 	unregister_kretprobes(&rp, 1);
 }
+EXPORT_SYMBOL_GPL(unregister_kretprobe);
 
 void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
 {
@@ -1030,24 +1041,30 @@ void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
 		}
 	}
 }
+EXPORT_SYMBOL_GPL(unregister_kretprobes);
 
 #else /* CONFIG_KRETPROBES */
 int __kprobes register_kretprobe(struct kretprobe *rp)
 {
 	return -ENOSYS;
 }
+EXPORT_SYMBOL_GPL(register_kretprobe);
 
 int __kprobes register_kretprobes(struct kretprobe **rps, int num)
 {
 	return -ENOSYS;
 }
+EXPORT_SYMBOL_GPL(register_kretprobes);
+
 void __kprobes unregister_kretprobe(struct kretprobe *rp)
 {
 }
+EXPORT_SYMBOL_GPL(unregister_kretprobe);
 
 void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
 {
 }
+EXPORT_SYMBOL_GPL(unregister_kretprobes);
 
 static int __kprobes pre_handler_kretprobe(struct kprobe *p,
 					   struct pt_regs *regs)
@@ -1418,16 +1435,5 @@ late_initcall(debugfs_kprobe_init);
 
 module_init(init_kprobes);
 
-EXPORT_SYMBOL_GPL(register_kprobe);
-EXPORT_SYMBOL_GPL(unregister_kprobe);
-EXPORT_SYMBOL_GPL(register_kprobes);
-EXPORT_SYMBOL_GPL(unregister_kprobes);
-EXPORT_SYMBOL_GPL(register_jprobe);
-EXPORT_SYMBOL_GPL(unregister_jprobe);
-EXPORT_SYMBOL_GPL(register_jprobes);
-EXPORT_SYMBOL_GPL(unregister_jprobes);
+/* defined in arch/.../kernel/kprobes.c */
 EXPORT_SYMBOL_GPL(jprobe_return);
-EXPORT_SYMBOL_GPL(register_kretprobe);
-EXPORT_SYMBOL_GPL(unregister_kretprobe);
-EXPORT_SYMBOL_GPL(register_kretprobes);
-EXPORT_SYMBOL_GPL(unregister_kretprobes);

--------------030107070306070804060109
Content-Type: text/plain;
 name="kprobes-rename-kprobe_enabled-to-kprobes_all_disarmed.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="kprobes-rename-kprobe_enabled-to-kprobes_all_disarmed.patch"

Rename kprobe_enabled to kprobes_all_disarmed and invert logic due to

From: Masami Hiramatsu <mhiramat@redhat.com>

avoiding naming confusion from per-probe disabling.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)


diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index ca4c22d..dae198b 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -68,7 +68,7 @@ static struct hlist_head kprobe_table[KPROBE_TABLE_SIZE];
 static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
 
 /* NOTE: change this value only with kprobe_mutex held */
-static bool kprobe_enabled;
+static bool kprobes_all_disarmed;
 
 static DEFINE_MUTEX(kprobe_mutex);	/* Protects kprobe_table */
 static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
@@ -598,7 +598,7 @@ static int __kprobes register_aggr_kprobe(struct kprobe *old_p,
 		 * If the old_p has gone, its breakpoint has been disarmed.
 		 * We have to arm it again after preparing real kprobes.
 		 */
-		if (kprobe_enabled)
+		if (!kprobes_all_disarmed)
 			arch_arm_kprobe(ap);
 	}
 
@@ -709,7 +709,7 @@ int __kprobes register_kprobe(struct kprobe *p)
 	hlist_add_head_rcu(&p->hlist,
 		       &kprobe_table[hash_ptr(p->addr, KPROBE_HASH_BITS)]);
 
-	if (kprobe_enabled)
+	if (!kprobes_all_disarmed)
 		arch_arm_kprobe(p);
 
 out_unlock_text:
@@ -751,7 +751,7 @@ valid_p:
 		 * enabled and not gone - otherwise, the breakpoint would
 		 * already have been removed. We save on flushing icache.
 		 */
-		if (kprobe_enabled && !kprobe_gone(old_p)) {
+		if (!kprobes_all_disarmed && !kprobe_gone(old_p)) {
 			mutex_lock(&text_mutex);
 			arch_disarm_kprobe(p);
 			mutex_unlock(&text_mutex);
@@ -1190,8 +1190,8 @@ static int __init init_kprobes(void)
 		}
 	}
 
-	/* By default, kprobes are enabled */
-	kprobe_enabled = true;
+	/* By default, kprobes are armed */
+	kprobes_all_disarmed = false;
 
 	err = arch_init_kprobes();
 	if (!err)
@@ -1289,7 +1289,7 @@ static struct file_operations debugfs_kprobes_operations = {
 	.release        = seq_release,
 };
 
-static void __kprobes enable_all_kprobes(void)
+static void __kprobes arm_all_kprobes(void)
 {
 	struct hlist_head *head;
 	struct hlist_node *node;
@@ -1298,8 +1298,8 @@ static void __kprobes enable_all_kprobes(void)
 
 	mutex_lock(&kprobe_mutex);
 
-	/* If kprobes are already enabled, just return */
-	if (kprobe_enabled)
+	/* If kprobes are armed, just return */
+	if (!kprobes_all_disarmed)
 		goto already_enabled;
 
 	mutex_lock(&text_mutex);
@@ -1311,7 +1311,7 @@ static void __kprobes enable_all_kprobes(void)
 	}
 	mutex_unlock(&text_mutex);
 
-	kprobe_enabled = true;
+	kprobes_all_disarmed = false;
 	printk(KERN_INFO "Kprobes globally enabled\n");
 
 already_enabled:
@@ -1319,7 +1319,7 @@ already_enabled:
 	return;
 }
 
-static void __kprobes disable_all_kprobes(void)
+static void __kprobes disarm_all_kprobes(void)
 {
 	struct hlist_head *head;
 	struct hlist_node *node;
@@ -1328,11 +1328,11 @@ static void __kprobes disable_all_kprobes(void)
 
 	mutex_lock(&kprobe_mutex);
 
-	/* If kprobes are already disabled, just return */
-	if (!kprobe_enabled)
+	/* If kprobes are already disarmed, just return */
+	if (kprobes_all_disarmed)
 		goto already_disabled;
 
-	kprobe_enabled = false;
+	kprobes_all_disarmed = true;
 	printk(KERN_INFO "Kprobes globally disabled\n");
 	mutex_lock(&text_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
@@ -1364,7 +1364,7 @@ static ssize_t read_enabled_file_bool(struct file *file,
 {
 	char buf[3];
 
-	if (kprobe_enabled)
+	if (!kprobes_all_disarmed)
 		buf[0] = '1';
 	else
 		buf[0] = '0';
@@ -1387,12 +1387,12 @@ static ssize_t write_enabled_file_bool(struct file *file,
 	case 'y':
 	case 'Y':
 	case '1':
-		enable_all_kprobes();
+		arm_all_kprobes();
 		break;
 	case 'n':
 	case 'N':
 	case '0':
-		disable_all_kprobes();
+		disarm_all_kprobes();
 		break;
 	}
 

--------------030107070306070804060109
Content-Type: text/plain;
 name="kprobes-support-kretprobe-and-jprobe-per-probe-disabling.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="kprobes-support-kretprobe-and-jprobe-per-probe-disabling.pat";
 filename*1="ch"

Add disable/enable_kretprobe() and disable/enable_jprobe().

From: Masami Hiramatsu <mhiramat@redhat.com>

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kprobes.txt |   16 ++++++++++------
 include/linux/kprobes.h   |   17 +++++++++++++++++
 2 files changed, 27 insertions(+), 6 deletions(-)


diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index f609af2..1e7a769 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -365,21 +365,25 @@ probes) in the specified array, they clear the addr field of those
 incorrect probes. However, other probes in the array are
 unregistered correctly.
 
-4.7 disable_kprobe
+4.7 disable_*probe
 
 #include <linux/kprobes.h>
 int disable_kprobe(struct kprobe *kp);
+int disable_kretprobe(struct kretprobe *rp);
+int disable_jprobe(struct jprobe *jp);
 
-Temporarily disables the specified kprobe. You can enable it again by using
-enable_kprobe(). You must specify the kprobe which has been registered.
+Temporarily disables the specified *probe. You can enable it again by using
+enable_*probe(). You must specify the probe which has been registered.
 
-4.8 enable_kprobe
+4.8 enable_*probe
 
 #include <linux/kprobes.h>
 int enable_kprobe(struct kprobe *kp);
+int enable_kretprobe(struct kretprobe *rp);
+int enable_jprobe(struct jprobe *jp);
 
-Enables kprobe which has been disabled by disable_kprobe(). You must specify
-the kprobe which has been registered.
+Enables *probe which has been disabled by disable_*probe(). You must specify
+the probe which has been registered.
 
 5. Kprobes Features and Limitations
 
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 1071cfd..bcd9c07 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -371,4 +371,21 @@ static inline int enable_kprobe(struct kprobe *kp)
 	return -ENOSYS;
 }
 #endif /* CONFIG_KPROBES */
+static inline int disable_kretprobe(struct kretprobe *rp)
+{
+	return disable_kprobe(&rp->kp);
+}
+static inline int enable_kretprobe(struct kretprobe *rp)
+{
+	return enable_kprobe(&rp->kp);
+}
+static inline int disable_jprobe(struct jprobe *jp)
+{
+	return disable_kprobe(&jp->kp);
+}
+static inline int enable_jprobe(struct jprobe *jp)
+{
+	return enable_kprobe(&jp->kp);
+}
+
 #endif /* _LINUX_KPROBES_H */

--------------030107070306070804060109
Content-Type: text/plain;
 name="kprobes-support-per-kprobe-disabling.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kprobes-support-per-kprobe-disabling.patch"

Add disable_kprobe() and enable_kprobe() to disable/enable kprobes

From: Masami Hiramatsu <mhiramat@redhat.com>

temporarily.

disable_kprobe() asynchronously disables probe handlers of specified
kprobe.  So, after calling it, some handlers can be called at a while.
enable_kprobe() enables specified kprobe.

aggr_pre_handler and aggr_post_handler check disabled probes.  On the
other hand aggr_break_handler and aggr_fault_handler don't check it
because these handlers will be called while executing pre or post handlers
and usually those help error handling.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kprobes.txt |   34 ++++++++-
 include/linux/kprobes.h   |   23 ++++++
 kernel/kprobes.c          |  167 ++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 191 insertions(+), 33 deletions(-)


diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index 48b3de9..f609af2 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -212,7 +212,9 @@ hit, Kprobes calls kp->pre_handler.  After the probed instruction
 is single-stepped, Kprobe calls kp->post_handler.  If a fault
 occurs during execution of kp->pre_handler or kp->post_handler,
 or during single-stepping of the probed instruction, Kprobes calls
-kp->fault_handler.  Any or all handlers can be NULL.
+kp->fault_handler.  Any or all handlers can be NULL. If kp->flags
+is set KPROBE_FLAG_DISABLED, that kp will be registered but disabled,
+so, it's handlers aren't hit until calling enable_kprobe(kp).
 
 NOTE:
 1. With the introduction of the "symbol_name" field to struct kprobe,
@@ -363,6 +365,22 @@ probes) in the specified array, they clear the addr field of those
 incorrect probes. However, other probes in the array are
 unregistered correctly.
 
+4.7 disable_kprobe
+
+#include <linux/kprobes.h>
+int disable_kprobe(struct kprobe *kp);
+
+Temporarily disables the specified kprobe. You can enable it again by using
+enable_kprobe(). You must specify the kprobe which has been registered.
+
+4.8 enable_kprobe
+
+#include <linux/kprobes.h>
+int enable_kprobe(struct kprobe *kp);
+
+Enables kprobe which has been disabled by disable_kprobe(). You must specify
+the kprobe which has been registered.
+
 5. Kprobes Features and Limitations
 
 Kprobes allows multiple probes at the same address.  Currently,
@@ -500,10 +518,14 @@ the probe. If the probed function belongs to a module, the module name
 is also specified. Following columns show probe status. If the probe is on
 a virtual address that is no longer valid (module init sections, module
 virtual addresses that correspond to modules that've been unloaded),
-such probes are marked with [GONE].
+such probes are marked with [GONE]. If the probe is temporarily disabled,
+such probes are marked with [DISABLED].
 
-/debug/kprobes/enabled: Turn kprobes ON/OFF
+/debug/kprobes/enabled: Turn kprobes ON/OFF forcibly.
 
-Provides a knob to globally turn registered kprobes ON or OFF. By default,
-all kprobes are enabled. By echoing "0" to this file, all registered probes
-will be disarmed, till such time a "1" is echoed to this file.
+Provides a knob to globally and forcibly turn registered kprobes ON or OFF.
+By default, all kprobes are enabled. By echoing "0" to this file, all
+registered probes will be disarmed, till such time a "1" is echoed to this
+file. Note that this knob just disarms and arms all kprobes and doesn't
+change each probe's disabling state. This means that disabled kprobes (marked
+[DISABLED]) will be not enabled if you turn ON all kprobes by this knob.
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 39826a6..1071cfd 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -112,18 +112,28 @@ struct kprobe {
 	/* copy of the original instruction */
 	struct arch_specific_insn ainsn;
 
-	/* Indicates various status flags.  Protected by kprobe_mutex. */
+	/*
+	 * Indicates various status flags.
+	 * Protected by kprobe_mutex after this kprobe is registered.
+	 */
 	u32 flags;
 };
 
 /* Kprobe status flags */
 #define KPROBE_FLAG_GONE	1 /* breakpoint has already gone */
+#define KPROBE_FLAG_DISABLED	2 /* probe is temporarily disabled */
 
+/* Has this kprobe gone ? */
 static inline int kprobe_gone(struct kprobe *p)
 {
 	return p->flags & KPROBE_FLAG_GONE;
 }
 
+/* Is this kprobe disabled ? */
+static inline int kprobe_disabled(struct kprobe *p)
+{
+	return p->flags & (KPROBE_FLAG_DISABLED | KPROBE_FLAG_GONE);
+}
 /*
  * Special probe type that uses setjmp-longjmp type tricks to resume
  * execution at a specified entry with a matching prototype corresponding
@@ -283,6 +293,9 @@ void unregister_kretprobes(struct kretprobe **rps, int num);
 void kprobe_flush_task(struct task_struct *tk);
 void recycle_rp_inst(struct kretprobe_instance *ri, struct hlist_head *head);
 
+int disable_kprobe(struct kprobe *kp);
+int enable_kprobe(struct kprobe *kp);
+
 #else /* !CONFIG_KPROBES: */
 
 static inline int kprobes_built_in(void)
@@ -349,5 +362,13 @@ static inline void unregister_kretprobes(struct kretprobe **rps, int num)
 static inline void kprobe_flush_task(struct task_struct *tk)
 {
 }
+static inline int disable_kprobe(struct kprobe *kp)
+{
+	return -ENOSYS;
+}
+static inline int enable_kprobe(struct kprobe *kp)
+{
+	return -ENOSYS;
+}
 #endif /* CONFIG_KPROBES */
 #endif /* _LINUX_KPROBES_H */
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index dae198b..a5e74dd 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -328,7 +328,7 @@ static int __kprobes aggr_pre_handler(struct kprobe *p, struct pt_regs *regs)
 	struct kprobe *kp;
 
 	list_for_each_entry_rcu(kp, &p->list, list) {
-		if (kp->pre_handler && !kprobe_gone(kp)) {
+		if (kp->pre_handler && likely(!kprobe_disabled(kp))) {
 			set_kprobe_instance(kp);
 			if (kp->pre_handler(kp, regs))
 				return 1;
@@ -344,7 +344,7 @@ static void __kprobes aggr_post_handler(struct kprobe *p, struct pt_regs *regs,
 	struct kprobe *kp;
 
 	list_for_each_entry_rcu(kp, &p->list, list) {
-		if (kp->post_handler && !kprobe_gone(kp)) {
+		if (kp->post_handler && likely(!kprobe_disabled(kp))) {
 			set_kprobe_instance(kp);
 			kp->post_handler(kp, regs, flags);
 			reset_kprobe_instance();
@@ -523,6 +523,7 @@ static inline void copy_kprobe(struct kprobe *old_p, struct kprobe *p)
 */
 static int __kprobes add_new_kprobe(struct kprobe *ap, struct kprobe *p)
 {
+	BUG_ON(kprobe_gone(ap) || kprobe_gone(p));
 	if (p->break_handler) {
 		if (ap->break_handler)
 			return -EEXIST;
@@ -532,6 +533,13 @@ static int __kprobes add_new_kprobe(struct kprobe *ap, struct kprobe *p)
 		list_add_rcu(&p->list, &ap->list);
 	if (p->post_handler && !ap->post_handler)
 		ap->post_handler = aggr_post_handler;
+
+	if (kprobe_disabled(ap) && !kprobe_disabled(p)) {
+		ap->flags &= ~KPROBE_FLAG_DISABLED;
+		if (!kprobes_all_disarmed)
+			/* Arm the breakpoint again. */
+			arch_arm_kprobe(ap);
+	}
 	return 0;
 }
 
@@ -592,20 +600,36 @@ static int __kprobes register_aggr_kprobe(struct kprobe *old_p,
 			 * freed by unregister_kprobe.
 			 */
 			return ret;
-		/* Clear gone flag to prevent allocating new slot again. */
-		ap->flags &= ~KPROBE_FLAG_GONE;
+
 		/*
-		 * If the old_p has gone, its breakpoint has been disarmed.
-		 * We have to arm it again after preparing real kprobes.
+		 * Clear gone flag to prevent allocating new slot again, and
+		 * set disabled flag because it is not armed yet.
 		 */
-		if (!kprobes_all_disarmed)
-			arch_arm_kprobe(ap);
+		ap->flags = (ap->flags & ~KPROBE_FLAG_GONE)
+			    | KPROBE_FLAG_DISABLED;
 	}
 
 	copy_kprobe(ap, p);
 	return add_new_kprobe(ap, p);
 }
 
+/* Try to disable aggr_kprobe, and return 1 if succeeded.*/
+static int __kprobes try_to_disable_aggr_kprobe(struct kprobe *p)
+{
+	struct kprobe *kp;
+
+	list_for_each_entry_rcu(kp, &p->list, list) {
+		if (!kprobe_disabled(kp))
+			/*
+			 * There is an active probe on the list.
+			 * We can't disable aggr_kprobe.
+			 */
+			return 0;
+	}
+	p->flags |= KPROBE_FLAG_DISABLED;
+	return 1;
+}
+
 static int __kprobes in_kprobes_functions(unsigned long addr)
 {
 	struct kprobe_blackpoint *kb;
@@ -664,7 +688,9 @@ int __kprobes register_kprobe(struct kprobe *p)
 		return -EINVAL;
 	}
 
-	p->flags = 0;
+	/* User can pass only KPROBE_FLAG_DISABLED to register_kprobe */
+	p->flags &= KPROBE_FLAG_DISABLED;
+
 	/*
 	 * Check if are we probing a module.
 	 */
@@ -709,7 +735,7 @@ int __kprobes register_kprobe(struct kprobe *p)
 	hlist_add_head_rcu(&p->hlist,
 		       &kprobe_table[hash_ptr(p->addr, KPROBE_HASH_BITS)]);
 
-	if (!kprobes_all_disarmed)
+	if (!kprobes_all_disarmed && !kprobe_disabled(p))
 		arch_arm_kprobe(p);
 
 out_unlock_text:
@@ -724,25 +750,37 @@ out:
 }
 EXPORT_SYMBOL_GPL(register_kprobe);
 
-/*
- * Unregister a kprobe without a scheduler synchronization.
- */
-static int __kprobes __unregister_kprobe_top(struct kprobe *p)
+/* Check passed kprobe is valid and return kprobe in kprobe_table. */
+static struct kprobe * __kprobes __get_valid_kprobe(struct kprobe *p)
 {
 	struct kprobe *old_p, *list_p;
 
 	old_p = get_kprobe(p->addr);
 	if (unlikely(!old_p))
-		return -EINVAL;
+		return NULL;
 
 	if (p != old_p) {
 		list_for_each_entry_rcu(list_p, &old_p->list, list)
 			if (list_p == p)
 			/* kprobe p is a valid probe */
-				goto valid_p;
-		return -EINVAL;
+				goto valid;
+		return NULL;
 	}
-valid_p:
+valid:
+	return old_p;
+}
+
+/*
+ * Unregister a kprobe without a scheduler synchronization.
+ */
+static int __kprobes __unregister_kprobe_top(struct kprobe *p)
+{
+	struct kprobe *old_p, *list_p;
+
+	old_p = __get_valid_kprobe(p);
+	if (old_p == NULL)
+		return -EINVAL;
+
 	if (old_p == p ||
 	    (old_p->pre_handler == aggr_pre_handler &&
 	     list_is_singular(&old_p->list))) {
@@ -751,7 +789,7 @@ valid_p:
 		 * enabled and not gone - otherwise, the breakpoint would
 		 * already have been removed. We save on flushing icache.
 		 */
-		if (!kprobes_all_disarmed && !kprobe_gone(old_p)) {
+		if (!kprobes_all_disarmed && !kprobe_disabled(old_p)) {
 			mutex_lock(&text_mutex);
 			arch_disarm_kprobe(p);
 			mutex_unlock(&text_mutex);
@@ -769,6 +807,11 @@ valid_p:
 		}
 noclean:
 		list_del_rcu(&p->list);
+		if (!kprobe_disabled(old_p)) {
+			try_to_disable_aggr_kprobe(old_p);
+			if (!kprobes_all_disarmed && kprobe_disabled(old_p))
+				arch_disarm_kprobe(old_p);
+		}
 	}
 	return 0;
 }
@@ -1078,6 +1121,7 @@ static int __kprobes pre_handler_kretprobe(struct kprobe *p,
 static void __kprobes kill_kprobe(struct kprobe *p)
 {
 	struct kprobe *kp;
+
 	p->flags |= KPROBE_FLAG_GONE;
 	if (p->pre_handler == aggr_pre_handler) {
 		/*
@@ -1219,12 +1263,18 @@ static void __kprobes report_probe(struct seq_file *pi, struct kprobe *p,
 	else
 		kprobe_type = "k";
 	if (sym)
-		seq_printf(pi, "%p  %s  %s+0x%x  %s %s\n", p->addr, kprobe_type,
-			sym, offset, (modname ? modname : " "),
-			(kprobe_gone(p) ? "[GONE]" : ""));
+		seq_printf(pi, "%p  %s  %s+0x%x  %s %s%s\n",
+			p->addr, kprobe_type, sym, offset,
+			(modname ? modname : " "),
+			(kprobe_gone(p) ? "[GONE]" : ""),
+			((kprobe_disabled(p) && !kprobe_gone(p)) ?
+			 "[DISABLED]" : ""));
 	else
-		seq_printf(pi, "%p  %s  %p %s\n", p->addr, kprobe_type, p->addr,
-			(kprobe_gone(p) ? "[GONE]" : ""));
+		seq_printf(pi, "%p  %s  %p %s%s\n",
+			p->addr, kprobe_type, p->addr,
+			(kprobe_gone(p) ? "[GONE]" : ""),
+			((kprobe_disabled(p) && !kprobe_gone(p)) ?
+			 "[DISABLED]" : ""));
 }
 
 static void __kprobes *kprobe_seq_start(struct seq_file *f, loff_t *pos)
@@ -1289,6 +1339,71 @@ static struct file_operations debugfs_kprobes_operations = {
 	.release        = seq_release,
 };
 
+/* Disable one kprobe */
+int __kprobes disable_kprobe(struct kprobe *kp)
+{
+	int ret = 0;
+	struct kprobe *p;
+
+	mutex_lock(&kprobe_mutex);
+
+	/* Check whether specified probe is valid. */
+	p = __get_valid_kprobe(kp);
+	if (unlikely(p == NULL)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* If the probe is already disabled (or gone), just return */
+	if (kprobe_disabled(kp))
+		goto out;
+
+	kp->flags |= KPROBE_FLAG_DISABLED;
+	if (p != kp)
+		/* When kp != p, p is always enabled. */
+		try_to_disable_aggr_kprobe(p);
+
+	if (!kprobes_all_disarmed && kprobe_disabled(p))
+		arch_disarm_kprobe(p);
+out:
+	mutex_unlock(&kprobe_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(disable_kprobe);
+
+/* Enable one kprobe */
+int __kprobes enable_kprobe(struct kprobe *kp)
+{
+	int ret = 0;
+	struct kprobe *p;
+
+	mutex_lock(&kprobe_mutex);
+
+	/* Check whether specified probe is valid. */
+	p = __get_valid_kprobe(kp);
+	if (unlikely(p == NULL)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (kprobe_gone(kp)) {
+		/* This kprobe has gone, we couldn't enable it. */
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!kprobes_all_disarmed && kprobe_disabled(p))
+		arch_arm_kprobe(p);
+
+	p->flags &= ~KPROBE_FLAG_DISABLED;
+	if (p != kp)
+		kp->flags &= ~KPROBE_FLAG_DISABLED;
+out:
+	mutex_unlock(&kprobe_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(enable_kprobe);
+
 static void __kprobes arm_all_kprobes(void)
 {
 	struct hlist_head *head;
@@ -1306,7 +1421,7 @@ static void __kprobes arm_all_kprobes(void)
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist)
-			if (!kprobe_gone(p))
+			if (!kprobe_disabled(p))
 				arch_arm_kprobe(p);
 	}
 	mutex_unlock(&text_mutex);
@@ -1338,7 +1453,7 @@ static void __kprobes disarm_all_kprobes(void)
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist) {
-			if (!arch_trampoline_kprobe(p) && !kprobe_gone(p))
+			if (!arch_trampoline_kprobe(p) && !kprobe_disabled(p))
 				arch_disarm_kprobe(p);
 		}
 	}

--------------030107070306070804060109
Content-Type: text/plain;
 name="series"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="series"

# This series applies on GIT commit 4ec30d7ba076d9cc98e020880e48ddb2d2de0e39
kprobes-cleanup-aggr_kprobe-related-code.patch
kprobes-move-export_symbol_gpl-just-after-function-definitions.patch
kprobes-cleanup-comment-style-in-kprobesh.patch
kprobes-rename-kprobe_enabled-to-kprobes_all_disarmed.patch
kprobes-support-per-kprobe-disabling.patch
kprobes-support-kretprobe-and-jprobe-per-probe-disabling.patch

--------------030107070306070804060109--
