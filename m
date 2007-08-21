Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbXHUVCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbXHUVCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 17:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbXHUVCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 17:02:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbXHUVCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 17:02:46 -0400
Message-ID: <46CB529F.9060306@redhat.com>
Date: Tue, 21 Aug 2007 17:01:19 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ananth@in.ibm.com, prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
       Jim Keniston <jkenisto@us.ibm.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH][kprobes] support kretprobe-blacklist take2
References: <46C5FA48.2050308@redhat.com> <20070817150348.0f2f54da.akpm@linux-foundation.org>
In-Reply-To: <20070817150348.0f2f54da.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

I updated my patch and removed #ifdefs from it.
Thank you,

Masami Hiramatsu
Hitachi Computer Products (America), Inc.


This patch introduces architecture dependent kretprobe
blacklists to prohibit users from inserting return
probes on the function in which kprobes can be inserted
but kretprobes can not.
This patch also removes "__kprobes" mark from "__switch_to" on x86_64
and registers "__switch_to" to the blacklist on x86-64, because that mark
is to prohibit user from inserting only kretprobe.


Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>

---
 arch/avr32/kernel/kprobes.c   |    2 ++
 arch/i386/kernel/kprobes.c    |    7 +++++++
 arch/ia64/kernel/kprobes.c    |    2 ++
 arch/powerpc/kernel/kprobes.c |    2 ++
 arch/s390/kernel/kprobes.c    |    2 ++
 arch/sparc64/kernel/kprobes.c |    2 ++
 arch/x86_64/kernel/kprobes.c  |    7 +++++++
 arch/x86_64/kernel/process.c  |    2 +-
 include/asm-avr32/kprobes.h   |    2 ++
 include/asm-i386/kprobes.h    |    2 ++
 include/asm-ia64/kprobes.h    |    1 +
 include/asm-powerpc/kprobes.h |    1 +
 include/asm-s390/kprobes.h    |    1 +
 include/asm-sparc64/kprobes.h |    2 ++
 include/asm-x86_64/kprobes.h  |    1 +
 include/linux/kprobes.h       |    6 ++++++
 kernel/kprobes.c              |   23 +++++++++++++++++++++++
 17 files changed, 64 insertions(+), 1 deletion(-)

Index: 2.6.23-rc2-mm2/arch/i386/kernel/kprobes.c
===================================================================
--- 2.6.23-rc2-mm2.orig/arch/i386/kernel/kprobes.c
+++ 2.6.23-rc2-mm2/arch/i386/kernel/kprobes.c
@@ -42,6 +42,13 @@ void jprobe_return_end(void);
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);

+struct kretprobe_blackpoint kretprobe_blacklist[] = {
+	{"__switch_to", }, /* This function switches only current task, but
+			     doesn't switch kernel stack.*/
+	{NULL, NULL}	/* Terminator */
+};
+const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
+
 /* insert a jmp code */
 static __always_inline void set_jmp_op(void *from, void *to)
 {
Index: 2.6.23-rc2-mm2/kernel/kprobes.c
===================================================================
--- 2.6.23-rc2-mm2.orig/kernel/kprobes.c
+++ 2.6.23-rc2-mm2/kernel/kprobes.c
@@ -716,6 +716,18 @@ int __kprobes register_kretprobe(struct
 	int ret = 0;
 	struct kretprobe_instance *inst;
 	int i;
+	void *addr = rp->kp.addr;
+
+	if (kretprobe_blacklist_size) {
+		if (addr == NULL)
+			kprobe_lookup_name(rp->kp.symbol_name, addr);
+		addr += rp->kp.offset;
+
+		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
+			if (kretprobe_blacklist[i].addr == addr)
+				return -EINVAL;
+		}
+	}

 	rp->kp.pre_handler = pre_handler_kretprobe;
 	rp->kp.post_handler = NULL;
@@ -794,6 +806,17 @@ static int __init init_kprobes(void)
 		INIT_HLIST_HEAD(&kretprobe_inst_table[i]);
 	}

+	if (kretprobe_blacklist_size) {
+		/* lookup the function address from its name */
+		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
+			kprobe_lookup_name(kretprobe_blacklist[i].name,
+					   kretprobe_blacklist[i].addr);
+			if (!kretprobe_blacklist[i].addr)
+				printk("kretprobe: lookup failed: %s\n",
+				       kretprobe_blacklist[i].name);
+		}
+	}
+
 	/* By default, kprobes are enabled */
 	kprobe_enabled = true;

Index: 2.6.23-rc2-mm2/arch/x86_64/kernel/kprobes.c
===================================================================
--- 2.6.23-rc2-mm2.orig/arch/x86_64/kernel/kprobes.c
+++ 2.6.23-rc2-mm2/arch/x86_64/kernel/kprobes.c
@@ -49,6 +49,13 @@ static void __kprobes arch_copy_kprobe(s
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);

+struct kretprobe_blackpoint kretprobe_blacklist[] = {
+	{"__switch_to", }, /* This function switches only current task, but
+			      doesn't switch kernel stack.*/
+	{NULL, NULL}	/* Terminator */
+};
+const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
+
 /*
  * returns non-zero if opcode modifies the interrupt flag.
  */
Index: 2.6.23-rc2-mm2/include/linux/kprobes.h
===================================================================
--- 2.6.23-rc2-mm2.orig/include/linux/kprobes.h
+++ 2.6.23-rc2-mm2/include/linux/kprobes.h
@@ -166,6 +166,12 @@ struct kretprobe_instance {
 	struct task_struct *task;
 };

+struct kretprobe_blackpoint {
+	const char *name;
+	void *addr;
+};
+extern struct kretprobe_blackpoint kretprobe_blacklist[];
+
 static inline void kretprobe_assert(struct kretprobe_instance *ri,
 	unsigned long orig_ret_address, unsigned long trampoline_address)
 {
Index: 2.6.23-rc2-mm2/arch/x86_64/kernel/process.c
===================================================================
--- 2.6.23-rc2-mm2.orig/arch/x86_64/kernel/process.c
+++ 2.6.23-rc2-mm2/arch/x86_64/kernel/process.c
@@ -584,7 +584,7 @@ static inline void __switch_to_xtra(stru
  *
  * Kprobes not supported here. Set the probe on schedule instead.
  */
-__kprobes struct task_struct *
+struct task_struct *
 __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 {
 	struct thread_struct *prev = &prev_p->thread,
Index: 2.6.23-rc2-mm2/include/asm-ia64/kprobes.h
===================================================================
--- 2.6.23-rc2-mm2.orig/include/asm-ia64/kprobes.h
+++ 2.6.23-rc2-mm2/include/asm-ia64/kprobes.h
@@ -83,6 +83,7 @@ struct kprobe_ctlblk {
 };

 #define ARCH_SUPPORTS_KRETPROBES
+#define kretprobe_blacklist_size 0

 #define SLOT0_OPCODE_SHIFT	(37)
 #define SLOT1_p1_OPCODE_SHIFT	(37 - (64-46))
Index: 2.6.23-rc2-mm2/include/asm-powerpc/kprobes.h
===================================================================
--- 2.6.23-rc2-mm2.orig/include/asm-powerpc/kprobes.h
+++ 2.6.23-rc2-mm2/include/asm-powerpc/kprobes.h
@@ -82,6 +82,7 @@ typedef unsigned int kprobe_opcode_t;

 #define ARCH_SUPPORTS_KRETPROBES
 #define flush_insn_slot(p)	do { } while (0)
+#define kretprobe_blacklist_size 0

 void kretprobe_trampoline(void);
 extern void arch_remove_kprobe(struct kprobe *p);
Index: 2.6.23-rc2-mm2/include/asm-s390/kprobes.h
===================================================================
--- 2.6.23-rc2-mm2.orig/include/asm-s390/kprobes.h
+++ 2.6.23-rc2-mm2/include/asm-s390/kprobes.h
@@ -47,6 +47,7 @@ typedef u16 kprobe_opcode_t;
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))

 #define ARCH_SUPPORTS_KRETPROBES
+#define kretprobe_blacklist_size 0

 #define KPROBE_SWAP_INST	0x10

Index: 2.6.23-rc2-mm2/include/asm-avr32/kprobes.h
===================================================================
--- 2.6.23-rc2-mm2.orig/include/asm-avr32/kprobes.h
+++ 2.6.23-rc2-mm2/include/asm-avr32/kprobes.h
@@ -17,6 +17,8 @@ typedef u16	kprobe_opcode_t;
 #define BREAKPOINT_INSTRUCTION	0xd673	/* breakpoint */
 #define MAX_INSN_SIZE		2

+#define kretprobe_blacklist_size 0
+
 #define arch_remove_kprobe(p)	do { } while (0)

 /* Architecture specific copy of original instruction */
Index: 2.6.23-rc2-mm2/include/asm-sparc64/kprobes.h
===================================================================
--- 2.6.23-rc2-mm2.orig/include/asm-sparc64/kprobes.h
+++ 2.6.23-rc2-mm2/include/asm-sparc64/kprobes.h
@@ -10,6 +10,8 @@ typedef u32 kprobe_opcode_t;
 #define BREAKPOINT_INSTRUCTION_2 0x91d02071 /* ta 0x71 */
 #define MAX_INSN_SIZE 2

+#define kretprobe_blacklist_size 0
+
 #define arch_remove_kprobe(p)	do {} while (0)

 #define flush_insn_slot(p)		\
Index: 2.6.23-rc2-mm2/arch/avr32/kernel/kprobes.c
===================================================================
--- 2.6.23-rc2-mm2.orig/arch/avr32/kernel/kprobes.c
+++ 2.6.23-rc2-mm2/arch/avr32/kernel/kprobes.c
@@ -22,6 +22,8 @@ DEFINE_PER_CPU(struct kprobe *, current_
 static unsigned long kprobe_status;
 static struct pt_regs jprobe_saved_regs;

+struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
+
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
 	int ret = 0;
Index: 2.6.23-rc2-mm2/arch/ia64/kernel/kprobes.c
===================================================================
--- 2.6.23-rc2-mm2.orig/arch/ia64/kernel/kprobes.c
+++ 2.6.23-rc2-mm2/arch/ia64/kernel/kprobes.c
@@ -40,6 +40,8 @@ extern void jprobe_inst_return(void);
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);

+struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
+
 enum instruction_type {A, I, M, F, B, L, X, u};
 static enum instruction_type bundle_encoding[32][3] = {
   { M, I, I },				/* 00 */
Index: 2.6.23-rc2-mm2/arch/powerpc/kernel/kprobes.c
===================================================================
--- 2.6.23-rc2-mm2.orig/arch/powerpc/kernel/kprobes.c
+++ 2.6.23-rc2-mm2/arch/powerpc/kernel/kprobes.c
@@ -38,6 +38,8 @@
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);

+struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
+
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
 	int ret = 0;
Index: 2.6.23-rc2-mm2/arch/s390/kernel/kprobes.c
===================================================================
--- 2.6.23-rc2-mm2.orig/arch/s390/kernel/kprobes.c
+++ 2.6.23-rc2-mm2/arch/s390/kernel/kprobes.c
@@ -33,6 +33,8 @@
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);

+struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
+
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
 	/* Make sure the probe isn't going on a difficult instruction */
Index: 2.6.23-rc2-mm2/arch/sparc64/kernel/kprobes.c
===================================================================
--- 2.6.23-rc2-mm2.orig/arch/sparc64/kernel/kprobes.c
+++ 2.6.23-rc2-mm2/arch/sparc64/kernel/kprobes.c
@@ -42,6 +42,8 @@
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);

+struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
+
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
 	p->ainsn.insn[0] = *p->addr;
Index: 2.6.23-rc2-mm2/include/asm-i386/kprobes.h
===================================================================
--- 2.6.23-rc2-mm2.orig/include/asm-i386/kprobes.h
+++ 2.6.23-rc2-mm2/include/asm-i386/kprobes.h
@@ -45,6 +45,8 @@ typedef u8 kprobe_opcode_t;
 #define ARCH_SUPPORTS_KRETPROBES
 #define flush_insn_slot(p)	do { } while (0)

+extern const int kretprobe_blacklist_size;
+
 void arch_remove_kprobe(struct kprobe *p);
 void kretprobe_trampoline(void);

Index: 2.6.23-rc2-mm2/include/asm-x86_64/kprobes.h
===================================================================
--- 2.6.23-rc2-mm2.orig/include/asm-x86_64/kprobes.h
+++ 2.6.23-rc2-mm2/include/asm-x86_64/kprobes.h
@@ -42,6 +42,7 @@ typedef u8 kprobe_opcode_t;
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))

 #define ARCH_SUPPORTS_KRETPROBES
+extern const int kretprobe_blacklist_size;

 void kretprobe_trampoline(void);
 extern void arch_remove_kprobe(struct kprobe *p);

