Return-Path: <linux-kernel-owner+w=401wt.eu-S1759024AbXHQTqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024AbXHQTqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 15:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756209AbXHQTpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 15:45:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061AbXHQTpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 15:45:42 -0400
Message-ID: <46C5FA48.2050308@redhat.com>
Date: Fri, 17 Aug 2007 15:43:04 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, ananth@in.ibm.com,
       prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
       Jim Keniston <jkenisto@us.ibm.com>, davem@davemloft.net
CC: linux-kernel@vger.kernel.org
Subject: [PATCH][kprobes] support kretprobe-blacklist
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces architecture dependent kretprobe
blacklists to prohibit users from inserting return
probes on the function in which kprobes can be inserted
but kretprobes can not.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>

---
 <Problem Description>
When a kretprobe is inserted in the entry of the "__switch_to()",
it causes kernel panic on i386 with recent kernel.

 <Problem Analysis>
In include/asm-i386/current.h, "current" is defined as an entry of
percpu variables.:

 DECLARE_PER_CPU(struct task_struct *, current_task);
 static __always_inline struct task_struct *get_current(void)
 {
         return x86_read_percpu(current_task);
 }

 #define current get_current()

This mean the "current" macro is separated from its stack register.
Kretprobe expects that "current" value when a function is called is
not changed, or both of "current" value and stack register are changed in
the target function.
But __switch_to() in arch/i386/kernel/process.c changes only the value of
"current", but doesn't changes the stack register(this was already switched
to new stack before calling __switch_to()):

 struct task_struct fastcall * __switch_to(struct task_struct *prev_p, struct
 task_struct *next_p)
 {
 	...
        x86_write_percpu(current_task, next_p);

        return prev_p;
 }

Kretprobe modifies the return address stored in the stack, and
it saves the original return address in the kretprobe_instance with
the value of "current".
When kretprobe is hit at the return of __switch_to(), it searches
kretprobe_instance related to the probe point from a hash list by
using the hash-value of the "current" instead of stack address.
However, since the value of "current" is already changed,
it can't find proper instance, and invokes BUG() macro.

 <Solution>
As a result of discussion with other kprobe developers, I'd
like to introduce arch-dependent blacklist.
To introduce "__kretprobes" mark (like "__kprobes") is another way.
But I thought it is not efficient way, because the kretprobe can
be inserted only in the entry of functions and there is no need to
check against a whole function.

This patch also removes "__kprobes" mark from "__switch_to" on x86_64
and registers "__switch_to" to the blacklist on x86-64, because that mark
is to prohibit user from inserting only kretprobe.

Thank you,

Masami Hiramatsu
Hitachi Computer Products (America), Inc.

 arch/i386/kernel/kprobes.c   |    5 +++++
 arch/x86_64/kernel/kprobes.c |    6 ++++++
 arch/x86_64/kernel/process.c |    2 +-
 include/asm-i386/kprobes.h   |    1 +
 include/asm-x86_64/kprobes.h |    1 +
 include/linux/kprobes.h      |    8 ++++++++
 kernel/kprobes.c             |   23 +++++++++++++++++++++++
 7 files changed, 45 insertions(+), 1 deletion(-)

Index: 2.6-mm/arch/i386/kernel/kprobes.c
===================================================================
--- 2.6-mm.orig/arch/i386/kernel/kprobes.c
+++ 2.6-mm/arch/i386/kernel/kprobes.c
@@ -41,6 +41,11 @@ void jprobe_return_end(void);

 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
+struct kretprobe_blacklist arch_kretprobe_blacklist[] = {
+	{"__switch_to", }, /* This function switches only current task, but
+			     doesn't switch kernel stack.*/
+	{NULL, NULL}	/* Terminator */
+};

 /* insert a jmp code */
 static __always_inline void set_jmp_op(void *from, void *to)
Index: 2.6-mm/include/asm-i386/kprobes.h
===================================================================
--- 2.6-mm.orig/include/asm-i386/kprobes.h
+++ 2.6-mm/include/asm-i386/kprobes.h
@@ -44,6 +44,7 @@ typedef u8 kprobe_opcode_t;

 #define ARCH_SUPPORTS_KRETPROBES
 #define flush_insn_slot(p)	do { } while (0)
+#define ARCH_SUPPORTS_KRETPROBE_BLACKLIST

 void arch_remove_kprobe(struct kprobe *p);
 void kretprobe_trampoline(void);
Index: 2.6-mm/kernel/kprobes.c
===================================================================
--- 2.6-mm.orig/kernel/kprobes.c
+++ 2.6-mm/kernel/kprobes.c
@@ -716,6 +716,18 @@ int __kprobes register_kretprobe(struct
 	int ret = 0;
 	struct kretprobe_instance *inst;
 	int i;
+#ifdef ARCH_SUPPORTS_KRETPROBE_BLACKLIST
+	void *addr = rp->kp.addr;
+
+	if (addr == NULL)
+		kprobe_lookup_name(rp->kp.symbol_name, addr);
+	addr += rp->kp.offset;
+
+	for (i = 0; arch_kretprobe_blacklist[i].name != NULL; i++) {
+		if (arch_kretprobe_blacklist[i].addr == addr)
+			return -EINVAL;
+	}
+#endif

 	rp->kp.pre_handler = pre_handler_kretprobe;
 	rp->kp.post_handler = NULL;
@@ -794,6 +806,17 @@ static int __init init_kprobes(void)
 		INIT_HLIST_HEAD(&kretprobe_inst_table[i]);
 	}

+#ifdef ARCH_SUPPORTS_KRETPROBE_BLACKLIST
+	/* lookup the function address from its name */
+	for (i = 0; arch_kretprobe_blacklist[i].name != NULL; i++) {
+		kprobe_lookup_name(arch_kretprobe_blacklist[i].name,
+				   arch_kretprobe_blacklist[i].addr);
+		if (!arch_kretprobe_blacklist[i].addr)
+			printk("kretprobe: Unknown blacklisted function: %s\n",
+			       arch_kretprobe_blacklist[i].name);
+	}
+#endif
+
 	/* By default, kprobes are enabled */
 	kprobe_enabled = true;

Index: 2.6-mm/arch/x86_64/kernel/kprobes.c
===================================================================
--- 2.6-mm.orig/arch/x86_64/kernel/kprobes.c
+++ 2.6-mm/arch/x86_64/kernel/kprobes.c
@@ -49,6 +49,12 @@ static void __kprobes arch_copy_kprobe(s
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);

+struct kretprobe_blacklist arch_kretprobe_blacklist[] = {
+	{"__switch_to", }, /* This function switches only current task, but
+			      doesn't switch kernel stack.*/
+	{NULL, NULL}	/* Terminator */
+};
+
 /*
  * returns non-zero if opcode modifies the interrupt flag.
  */
Index: 2.6-mm/include/asm-x86_64/kprobes.h
===================================================================
--- 2.6-mm.orig/include/asm-x86_64/kprobes.h
+++ 2.6-mm/include/asm-x86_64/kprobes.h
@@ -42,6 +42,7 @@ typedef u8 kprobe_opcode_t;
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))

 #define ARCH_SUPPORTS_KRETPROBES
+#define ARCH_SUPPORTS_KRETPROBE_BLACKLIST

 void kretprobe_trampoline(void);
 extern void arch_remove_kprobe(struct kprobe *p);
Index: 2.6-mm/include/linux/kprobes.h
===================================================================
--- 2.6-mm.orig/include/linux/kprobes.h
+++ 2.6-mm/include/linux/kprobes.h
@@ -166,6 +166,14 @@ struct kretprobe_instance {
 	struct task_struct *task;
 };

+#ifdef ARCH_SUPPORTS_KRETPROBE_BLACKLIST
+struct kretprobe_blacklist {
+	const char *name;
+	void *addr;
+};
+extern struct kretprobe_blacklist arch_kretprobe_blacklist[];
+#endif
+
 static inline void kretprobe_assert(struct kretprobe_instance *ri,
 	unsigned long orig_ret_address, unsigned long trampoline_address)
 {
Index: 2.6-mm/arch/x86_64/kernel/process.c
===================================================================
--- 2.6-mm.orig/arch/x86_64/kernel/process.c
+++ 2.6-mm/arch/x86_64/kernel/process.c
@@ -584,7 +584,7 @@ static inline void __switch_to_xtra(stru
  *
  * Kprobes not supported here. Set the probe on schedule instead.
  */
-__kprobes struct task_struct *
+struct task_struct *
 __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 {
 	struct thread_struct *prev = &prev_p->thread,





