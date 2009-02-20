Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbZBTBRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbZBTBRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 20:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbZBTBP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 20:15:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50019 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbZBTBPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 20:15:22 -0500
Message-Id: <20090220011521.003556651@goodmis.org>
References: <20090220011316.379904625@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 19 Feb 2009 20:13:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/6] ftrace, x86: make kernel text writable only for conversions
Content-Disposition: inline; filename=0004-ftrace-x86-make-kernel-text-writable-only-for-conv.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: keep kernel text read only

Because dynamic ftrace converts the calls to mcount into and out of
nops at run time, we needed to always keep the kernel text writable.

But this defeats the point of CONFIG_DEBUG_RODATA. This patch converts
the kernel code to writable before ftrace modifies the text, and converts
it back to read only afterward.

The conversion is done via stop_machine and no IPIs may be executed
at that time. The kernel text is set to write just before calling
stop_machine and set to read only again right afterward.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/include/asm/ftrace.h |   10 ++++++++++
 arch/x86/kernel/ftrace.c      |   20 ++++++++++++++++++++
 arch/x86/mm/init_32.c         |   27 ++++++++++++++++++++++++---
 arch/x86/mm/init_64.c         |   29 ++++++++++++++++++++++++-----
 4 files changed, 78 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index b55b4a7..5564cf3 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -80,4 +80,14 @@ extern void return_to_handler(void);
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
+#ifndef __ASSEMBLY__
+#ifdef CONFIG_DEBUG_RODATA
+void set_kernel_text_rw(void);
+void set_kernel_text_ro(void);
+#else
+static inline void set_kernel_text_rw(void) { }
+static inline void set_kernel_text_ro(void) { }
+#endif
+#endif /* __ASSEMBLY__ */
+
 #endif /* _ASM_X86_FTRACE_H */
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 2f9c0c8..05041b0 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -26,6 +26,26 @@
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
+int ftrace_arch_modify_prepare(void)
+{
+	/* at boot up, we are still writable */
+	if (system_state != SYSTEM_RUNNING)
+		return 0;
+
+	set_kernel_text_rw();
+	return 0;
+}
+
+int ftrace_arch_modify_post_process(void)
+{
+	/* at boot up, we are still writable */
+	if (system_state != SYSTEM_RUNNING)
+		return 0;
+
+	set_kernel_text_ro();
+	return 0;
+}
+
 union ftrace_code_union {
 	char code[MCOUNT_INSN_SIZE];
 	struct {
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 2cef050..bcd7f00 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -1155,13 +1155,35 @@ static noinline int do_test_wp_bit(void)
 const int rodata_test_data = 0xC3;
 EXPORT_SYMBOL_GPL(rodata_test_data);
 
+/* used by ftrace */
+void set_kernel_text_rw(void)
+{
+	unsigned long start = PFN_ALIGN(_text);
+	unsigned long size = PFN_ALIGN(_etext) - start;
+
+	printk(KERN_INFO "Set kernel text: %lx - %lx for read write\n",
+	       start, start+size);
+
+	set_pages_rw(virt_to_page(start), size >> PAGE_SHIFT);
+}
+
+/* used by ftrace */
+void set_kernel_text_ro(void)
+{
+	unsigned long start = PFN_ALIGN(_text);
+	unsigned long size = PFN_ALIGN(_etext) - start;
+
+	printk(KERN_INFO "Set kernel text: %lx - %lx for read only\n",
+	       start, start+size);
+
+	set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
+}
+
 void mark_rodata_ro(void)
 {
 	unsigned long start = PFN_ALIGN(_text);
 	unsigned long size = PFN_ALIGN(_etext) - start;
 
-#ifndef CONFIG_DYNAMIC_FTRACE
-	/* Dynamic tracing modifies the kernel text section */
 	set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
 	printk(KERN_INFO "Write protecting the kernel text: %luk\n",
 		size >> 10);
@@ -1174,7 +1196,6 @@ void mark_rodata_ro(void)
 	printk(KERN_INFO "Testing CPA: write protecting again\n");
 	set_pages_ro(virt_to_page(start), size>>PAGE_SHIFT);
 #endif
-#endif /* CONFIG_DYNAMIC_FTRACE */
 
 	start += size;
 	size = (unsigned long)__end_rodata - start;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index e6d36b4..8c1b5ee 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -986,17 +986,36 @@ void free_initmem(void)
 const int rodata_test_data = 0xC3;
 EXPORT_SYMBOL_GPL(rodata_test_data);
 
+/* used by ftrace */
+void set_kernel_text_rw(void)
+{
+	unsigned long start = PFN_ALIGN(_stext);
+	unsigned long end = PFN_ALIGN(__start_rodata);
+
+	printk(KERN_INFO "Set kernel text: %lx - %lx for read write\n",
+	       start, end);
+
+	set_memory_rw(start, (end - start) >> PAGE_SHIFT);
+}
+
+/* used by ftrace */
+void set_kernel_text_ro(void)
+{
+	unsigned long start = PFN_ALIGN(_stext);
+	unsigned long end = PFN_ALIGN(__start_rodata);
+
+	printk(KERN_INFO "Set kernel text: %lx - %lx for read only\n",
+	       start, end);
+
+	set_memory_ro(start, (end - start) >> PAGE_SHIFT);
+}
+
 void mark_rodata_ro(void)
 {
 	unsigned long start = PFN_ALIGN(_stext), end = PFN_ALIGN(__end_rodata);
 	unsigned long rodata_start =
 		((unsigned long)__start_rodata + PAGE_SIZE - 1) & PAGE_MASK;
 
-#ifdef CONFIG_DYNAMIC_FTRACE
-	/* Dynamic tracing modifies the kernel text section */
-	start = rodata_start;
-#endif
-
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
 	set_memory_ro(start, (end - start) >> PAGE_SHIFT);
-- 
1.5.6.5

-- 
