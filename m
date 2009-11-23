Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbZKWXUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbZKWXUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:20:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757476AbZKWXUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:20:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757487AbZKWXUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:20:07 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v5 09/10] [RFC] x86: Introduce generic jump patching
	without stop_machine
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Anders Kaseorg <andersk@ksplice.com>,
       Tim Abbott <tabbott@ksplice.com>, Andi Kleen <andi@firstfloor.org>,
       Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Mon, 23 Nov 2009 18:22:26 -0500
Message-ID: <20091123232226.22071.57201.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

Changes in v5
 - Add some comments.
 - Use smp_wmb()/smp_rmb()
 - Remove unneeded sync_core_all()

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
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---

 arch/x86/include/asm/alternative.h |   11 ++++
 arch/x86/kernel/alternative.c      |  102 ++++++++++++++++++++++++++++++++++++
 kernel/kprobes.c                   |    2 -
 3 files changed, 114 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index c240efc..b48ca4d 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -160,4 +160,15 @@ static inline void apply_paravirt(struct paravirt_patch_site *start,
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
+extern void sync_core_all(void);
+
 #endif /* _ASM_X86_ALTERNATIVE_H */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index de7353c..04576e4 100644
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
@@ -552,3 +553,104 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
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
+	smp_rmb();
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
+	/* Preparing fixup address */
+	patch_fixup_addr = fixup;
+	patch_fixup_from = (u8 *)addr + int3_size; /* IP address after int3 */
+	smp_wmb();
+
+	/* Cap by an int3 - expecting synchronously */
+	text_poke(addr, &int3_insn, int3_size);
+
+	/* Replace tail bytes */
+	text_poke((char *)addr + int3_size, (const char *)opcode + int3_size,
+		  len - int3_size);
+	/* Synchronous code cache */
+	sync_core_all();
+
+	/* Replace int3 with head byte - expecting synchronously */
+	text_poke(addr, opcode, int3_size);
+
+	/*
+	 * Sync core again - this is for waiting for disabled IRQ code
+	 * quiescent state, IOW, waiting for all running int3 fixup
+	 * handlers.
+	 */
+	sync_core_all();
+
+	/* Cleanup fixup address */
+	patch_fixup_from = NULL;
+	smp_wmb();
+	return addr;
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
index 1e862ed..22c2ae5 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1298,7 +1298,7 @@ EXPORT_SYMBOL_GPL(unregister_kprobes);
 
 static struct notifier_block kprobe_exceptions_nb = {
 	.notifier_call = kprobe_exceptions_notify,
-	.priority = 0x7fffffff /* we need to be notified first */
+	.priority = 0x7ffffff0 /* High priority, but not first.  */
 };
 
 unsigned long __weak arch_deref_entry_point(void *entry)


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
