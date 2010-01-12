Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536Ab0ALQ1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab0ALQ1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 11:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498Ab0ALQ1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 11:27:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479Ab0ALQ1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 11:27:08 -0500
Date: Tue, 12 Jan 2010 11:26:28 -0500
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com
Message-Id: <a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com>
In-Reply-To: <cover.1263247113.git.jbaron@redhat.com>
References: <cover.1263247113.git.jbaron@redhat.com>
Subject: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump patching without stop_machine
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add text_poke_fixup() which takes a fixup address to where a processor
jumps if it hits the modifying address while code modifying.
text_poke_fixup() does following steps for this purpose.

 1. Setup int3 handler for fixup.
 2. Put a breakpoint (int3) on the first byte of modifying region,
    and synchronize code on all CPUs.
 3. Modify other bytes of modifying region, and synchronize code on all CPUs.
 4. Modify the first byte of modifying region, and synchronize code
    on all CPUs.
 5. Clear int3 handler.

Thus, if some other processor execute modifying address when step2 to step4,
it will be jumped to fixup code.

This still has many limitations for modifying multi-instructions at once.
However, it is enough for 'a 5 bytes nop replacing with a jump' patching,
because;
 - Replaced instruction is just one instruction, which is executed atomically.
 - Replacing instruction is a jump, so we can set fixup address where the jump
   goes to.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 arch/x86/include/asm/alternative.h |   12 ++++
 arch/x86/include/asm/kprobes.h     |    1 +
 arch/x86/kernel/alternative.c      |  120 ++++++++++++++++++++++++++++++++++++
 kernel/kprobes.c                   |    2 +-
 4 files changed, 134 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 3b5b828..9b856b7 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -166,4 +166,16 @@ static inline void apply_paravirt(struct paravirt_patch_site *start,
  */
 extern void *text_poke(void *addr, const void *opcode, size_t len);
 
+/*
+ * Setup int3 trap and fixup execution for cross-modifying on SMP case.
+ * If the other cpus execute modifying instruction, it will hit int3
+ * and go to fixup code. This just provides a minimal safety check.
+ * Additional checks/restrictions are required for completely safe
+ * cross-modifying.
+ */
+extern void *text_poke_fixup(void *addr, const void *opcode, size_t len,
+			     void *fixup);
+extern int text_patch_jump(void *addr, void *dest);
+extern void sync_core_all(void);
+
 #endif /* _ASM_X86_ALTERNATIVE_H */
diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index eaec8ea..febab97 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -33,6 +33,7 @@ struct kprobe;
 typedef u8 kprobe_opcode_t;
 #define BREAKPOINT_INSTRUCTION	0xcc
 #define RELATIVEJUMP_OPCODE 0xe9
+#define RELATIVEJUMP_SIZE 5
 #define MAX_INSN_SIZE 16
 #define MAX_STACK_SIZE 64
 #define MIN_STACK_SIZE(ADDR)					       \
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 2589ea4..cf42144 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -4,6 +4,7 @@
 #include <linux/list.h>
 #include <linux/stringify.h>
 #include <linux/kprobes.h>
+#include <linux/kdebug.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/memory.h>
@@ -554,3 +555,122 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 	local_irq_restore(flags);
 	return addr;
 }
+
+/*
+ * On pentium series, Unsynchronized cross-modifying code
+ * operations can cause unexpected instruction execution results.
+ * So after code modified, we should synchronize it on each processor.
+ */
+static void __kprobes __local_sync_core(void *info)
+{
+	sync_core();
+}
+
+void __kprobes sync_core_all(void)
+{
+	on_each_cpu(__local_sync_core, NULL, 1);
+}
+
+/* Safely cross-code modifying with fixup address */
+static void *patch_fixup_from;
+static void *patch_fixup_addr;
+
+static int __kprobes patch_exceptions_notify(struct notifier_block *self,
+					      unsigned long val, void *data)
+{
+	struct die_args *args = data;
+	struct pt_regs *regs = args->regs;
+
+	if (likely(!patch_fixup_from))
+		return NOTIFY_DONE;
+
+	if (val != DIE_INT3 || !regs || user_mode_vm(regs) ||
+	    (unsigned long)patch_fixup_from != regs->ip)
+		return NOTIFY_DONE;
+
+	args->regs->ip = (unsigned long)patch_fixup_addr;
+	return NOTIFY_STOP;
+}
+
+/**
+ * text_poke_fixup() -- cross-modifying kernel text with fixup address.
+ * @addr:	Modifying address.
+ * @opcode:	New instruction.
+ * @len:	length of modifying bytes.
+ * @fixup:	Fixup address.
+ *
+ * Note: You must backup replaced instructions before calling this,
+ * if you need to recover it.
+ * Note: Must be called under text_mutex.
+ */
+void *__kprobes text_poke_fixup(void *addr, const void *opcode, size_t len,
+				void *fixup)
+{
+	static const unsigned char int3_insn = BREAKPOINT_INSTRUCTION;
+	static const int int3_size = sizeof(int3_insn);
+
+	/* Replacing 1 byte can be done atomically. */
+	if (unlikely(len <= 1))
+		return text_poke(addr, opcode, len);
+
+	/* Preparing */
+	patch_fixup_addr = fixup;
+	wmb();
+	patch_fixup_from = (u8 *)addr + int3_size; /* IP address after int3 */
+
+	/* Cap by an int3 */
+	text_poke(addr, &int3_insn, int3_size);
+	sync_core_all();
+
+	/* Replace tail bytes */
+	text_poke((char *)addr + int3_size, (const char *)opcode + int3_size,
+		  len - int3_size);
+	sync_core_all();
+
+	/* Replace int3 with head byte */
+	text_poke(addr, opcode, int3_size);
+	sync_core_all();
+
+	/* Cleanup */
+	patch_fixup_from = NULL;
+	wmb();
+	return addr;
+}
+
+/**
+ * text_patch_jump() -- cross-modifying kernel text with a relative jump
+ * @addr:	Address where jump from.
+ * @dest:	Address where jump to.
+ *
+ * Return 0 if succeeded to embed a jump. Otherwise, there is an error.
+ * Note: You must backup replaced instructions before calling this,
+ * if you need to recover it.
+ * Note: Must be called under text_mutex.
+ */
+int __kprobes text_patch_jump(void *addr, void *dest)
+{
+	unsigned char jmp_code[RELATIVEJUMP_SIZE];
+	s32 rel = (s32)((long)dest - ((long)addr + RELATIVEJUMP_SIZE));
+
+	if (!addr || !dest ||
+	    (long)rel != ((long)dest - ((long)addr + RELATIVEJUMP_SIZE)))
+		return -EINVAL;
+
+	jmp_code[0] = RELATIVEJUMP_OPCODE;
+	*(s32 *)(&jmp_code[1]) = rel;
+
+	text_poke_fixup(addr, jmp_code, RELATIVEJUMP_SIZE, dest);
+	return 0;
+}
+
+static struct notifier_block patch_exceptions_nb = {
+	.notifier_call = patch_exceptions_notify,
+	.priority = 0x7fffffff /* we need to be notified first */
+};
+
+static int __init patch_init(void)
+{
+	return register_die_notifier(&patch_exceptions_nb);
+}
+
+arch_initcall(patch_init);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index b7df302..9c4697f 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -898,7 +898,7 @@ EXPORT_SYMBOL_GPL(unregister_kprobes);
 
 static struct notifier_block kprobe_exceptions_nb = {
 	.notifier_call = kprobe_exceptions_notify,
-	.priority = 0x7fffffff /* we need to be notified first */
+	.priority = 0x7ffffff0 /* High priority, but not first.  */
 };
 
 unsigned long __weak arch_deref_entry_point(void *entry)
-- 
1.6.5.1

