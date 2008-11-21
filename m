Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYKULs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYKULs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 06:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbYKULsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 06:48:47 -0500
Received: from mx1.suse.de ([195.135.220.2]:38351 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbYKULsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 06:48:46 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: linux-kernel@vger.kernel.org
Subject: [RFC] kreplace: Rebootless kernel updates
Date: Fri, 21 Nov 2008 17:20:25 +0530
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: ananth@in.ibm.com, davem@davemloft.net, mhiramat@redhat.com,
       contact@ksplice.com, jbarnold@ksplice.com, tabbott@ksplice.com,
       wdaher@ksplice.com, andersk@ksplice.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811211720.26394.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This RFC patch adds support for limited form of rebootless kernel patching 
even without building the entire kernel.

When looking for a shortcut to avoid the rebuild/reboot cycle when hacking the  
kernel - the ksplice[1] was posted. This patch extends kprobes to do something 
similar, which would require even lesser time to _experiment_ with the running 
kernel. 

This small patch extends jprobes so that the jprobe's handler is executed but 
skips executing the actual function. But this has its own limitations such as 
Cannot access symbols not exported for modules (ofcourse hacks like 
pointers[2] can be used.), problems related to return values[3], etc... This 
is currently a x86_64 only _hack_.

Thanks
Nikanth Karthikesan

[1] http://lkml.org/lkml/2008/9/13/6
[2] kallsyms_lookup_name may not be exported to the modules, but still one can 
create and destroy a kprobe for a function to get its pointer!
[3] I wrote few helpers to handle return values of different sizes but omiting 
them here to make it more readable. Patch for just no return value or 
returning through accumulator is attached.

Sample code which uses this to replace the attempt_back_merge function in 
block layer to always return zero, so that back merges would never be done.
The kernel patch follows this.

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/kprobes.h>
#include <linux/blkdev.h>

/* New routine having the same arguments as actual routine */
int kreplace_attempt_back_merge(struct request_queue *q, struct request *rq)
{
	static int count=0;
	count++;
	if (count%50 == 0)
        	printk("kreplace_attempt_back_merge called another 50 times\n");
	set_ax(0); /* return value through ax - depends on arch, etc... */
	jprobe_return();
        return 0;// silence gcc
}

static struct jprobe my_kreplace = {
	.entry			= kreplace_attempt_back_merge,
	.kp = {
		.symbol_name	= "attempt_back_merge",
	},
};

static int __init jprobe_init(void)
{
	int ret;

	ret = register_kreplace(&my_kreplace);
	if (ret < 0) {
		printk(KERN_INFO "register_kreplace failed, returned %d\n", ret);
		return -1;
	}
	printk(KERN_INFO "Planted kreplace at %p, handler addr %p\n",
		       my_kreplace.kp.addr, my_kreplace.entry);
	return 0;
}

static void __exit jprobe_exit(void)
{
	unregister_kreplace(&my_kreplace);
	printk(KERN_INFO "kreplace at %p unregistered\n", my_kreplace.kp.addr);
}

module_init(jprobe_init)
module_exit(jprobe_exit)
MODULE_LICENSE("GPL");

---

The kernel patch for kreplace, an extension to kprobes to do hot patching.  
Only on x86_64. Do not try this on any other platforms without modifying.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---
 arch/x86/kernel/kprobes.c |   18 ++++++++++++++----
 include/linux/kprobes.h   |    5 ++++-
 kernel/kprobes.c          |   37 ++++++++++++++++++++++++++++++++-----
 3 files changed, 50 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 6c27679..9e2ea2b 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -340,9 +340,13 @@ static void __kprobes fix_riprel(struct kprobe *p)
 #endif
 }
 
-static void __kprobes arch_copy_kprobe(struct kprobe *p)
+static void __kprobes arch_copy_kprobe(struct kprobe *p, int replace)
 {
-	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
+	if (replace)
+		memcpy(p->ainsn.insn, ((unsigned char []){0xc3}), 1);
+	else
+		memcpy(p->ainsn.insn, p->addr,
+				MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
 
 	fix_riprel(p);
 
@@ -354,13 +358,13 @@ static void __kprobes arch_copy_kprobe(struct kprobe *p)
 	p->opcode = *p->addr;
 }
 
-int __kprobes arch_prepare_kprobe(struct kprobe *p)
+int __kprobes arch_prepare_kprobe(struct kprobe *p, int replace)
 {
 	/* insn: must be on special executable page on x86. */
 	p->ainsn.insn = get_insn_slot();
 	if (!p->ainsn.insn)
 		return -ENOMEM;
-	arch_copy_kprobe(p);
+	arch_copy_kprobe(p, replace);
 	return 0;
 }
 
@@ -1023,6 +1027,12 @@ void __kprobes jprobe_return(void)
 			(kcb->jprobe_saved_sp):"memory");
 }
 
+void __kprobes set_ax(unsigned long ax)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	kcb->jprobe_saved_regs.ax = ax;
+}
+
 int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 497b1d1..91e83fb 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -202,7 +202,7 @@ static inline int init_test_probes(void)
 #endif /* CONFIG_KPROBES_SANITY_TEST */
 
 extern struct mutex kprobe_mutex;
-extern int arch_prepare_kprobe(struct kprobe *p);
+extern int arch_prepare_kprobe(struct kprobe *p, int replace);
 extern void arch_arm_kprobe(struct kprobe *p);
 extern void arch_disarm_kprobe(struct kprobe *p);
 extern int arch_init_kprobes(void);
@@ -240,11 +240,14 @@ int register_kprobes(struct kprobe **kps, int num);
 void unregister_kprobes(struct kprobe **kps, int num);
 int setjmp_pre_handler(struct kprobe *, struct pt_regs *);
 int longjmp_break_handler(struct kprobe *, struct pt_regs *);
+int register_kreplace(struct jprobe *p);
+void unregister_kreplace(struct jprobe *p);
 int register_jprobe(struct jprobe *p);
 void unregister_jprobe(struct jprobe *p);
 int register_jprobes(struct jprobe **jps, int num);
 void unregister_jprobes(struct jprobe **jps, int num);
 void jprobe_return(void);
+void set_ax(unsigned long);
 unsigned long arch_deref_entry_point(void *);
 
 int register_kretprobe(struct kretprobe *rp);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 8b57a25..8da3be7 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -269,6 +269,7 @@ void __kprobes free_insn_slot(kprobe_opcode_t * slot, int 
dirty)
 		collect_garbage_slots();
 }
 #endif
+EXPORT_SYMBOL_GPL(set_ax);
 
 /* We have preemption disabled.. so it is safe to use __ versions */
 static inline void set_kprobe_instance(struct kprobe *kp)
@@ -601,7 +602,7 @@ static kprobe_opcode_t __kprobes *kprobe_addr(struct 
kprobe *p)
 }
 
 static int __kprobes __register_kprobe(struct kprobe *p,
-	unsigned long called_from)
+	unsigned long called_from, int replace)
 {
 	int ret = 0;
 	struct kprobe *old_p;
@@ -647,7 +648,7 @@ static int __kprobes __register_kprobe(struct kprobe *p,
 		goto out;
 	}
 
-	ret = arch_prepare_kprobe(p);
+	ret = arch_prepare_kprobe(p, replace);
 	if (ret)
 		goto out;
 
@@ -742,7 +743,7 @@ static int __register_kprobes(struct kprobe **kps, int 
num,
 	if (num <= 0)
 		return -EINVAL;
 	for (i = 0; i < num; i++) {
-		ret = __register_kprobe(kps[i], called_from);
+		ret = __register_kprobe(kps[i], called_from, 0);
 		if (ret < 0) {
 			if (i > 0)
 				unregister_kprobes(kps, i);
@@ -819,7 +820,7 @@ static int __register_jprobes(struct jprobe **jps, int 
num,
 			/* Todo: Verify probepoint is a function entry point */
 			jp->kp.pre_handler = setjmp_pre_handler;
 			jp->kp.break_handler = longjmp_break_handler;
-			ret = __register_kprobe(&jp->kp, called_from);
+			ret = __register_kprobe(&jp->kp, called_from, 0);
 		}
 		if (ret < 0) {
 			if (i > 0)
@@ -836,11 +837,35 @@ int __kprobes register_jprobe(struct jprobe *jp)
 		(unsigned long)__builtin_return_address(0));
 }
 
+int __kprobes register_kreplace(struct jprobe *jp)
+{
+	int ret = 0;
+	unsigned long addr;
+
+	addr = arch_deref_entry_point(jp->entry);
+
+	if (!kernel_text_address(addr))
+		ret = -EINVAL;
+	else {
+		/* Todo: Verify probepoint is a function entry point */
+		jp->kp.pre_handler = setjmp_pre_handler;
+		jp->kp.break_handler = longjmp_break_handler;
+		ret = __register_kprobe(&jp->kp,
+				(unsigned long)__builtin_return_address(0), 1);
+	}
+	return ret;
+}
+
 void __kprobes unregister_jprobe(struct jprobe *jp)
 {
 	unregister_jprobes(&jp, 1);
 }
 
+void __kprobes unregister_kreplace(struct jprobe *jp)
+{
+	unregister_jprobes(&jp, 1);
+}
+
 int __kprobes register_jprobes(struct jprobe **jps, int num)
 {
 	return __register_jprobes(jps, num,
@@ -956,7 +981,7 @@ static int __kprobes __register_kretprobe(struct kretprobe 
*rp,
 
 	rp->nmissed = 0;
 	/* Establish function entry probe point */
-	ret = __register_kprobe(&rp->kp, called_from);
+	ret = __register_kprobe(&rp->kp, called_from, 0);
 	if (ret != 0)
 		free_rp_inst(rp);
 	return ret;
@@ -1333,6 +1358,8 @@ EXPORT_SYMBOL_GPL(register_kprobe);
 EXPORT_SYMBOL_GPL(unregister_kprobe);
 EXPORT_SYMBOL_GPL(register_kprobes);
 EXPORT_SYMBOL_GPL(unregister_kprobes);
+EXPORT_SYMBOL_GPL(register_kreplace);
+EXPORT_SYMBOL_GPL(unregister_kreplace);
 EXPORT_SYMBOL_GPL(register_jprobe);
 EXPORT_SYMBOL_GPL(unregister_jprobe);
 EXPORT_SYMBOL_GPL(register_jprobes);

