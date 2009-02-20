Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbZBTTv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbZBTTv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 14:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbZBTTuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 14:50:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58545 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbZBTTuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 14:50:23 -0500
Message-Id: <20090220195021.977949620@goodmis.org>
References: <20090220193239.561624242@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 20 Feb 2009 14:32:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/4] ftrace, x86: make kernel text writable only for conversions
Content-Disposition: inline; filename=0002-ftrace-x86-make-kernel-text-writable-only-for-conv.patch
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

The kernel text is converted to read/write, stop_machine is called to
modify the code, then the kernel text is converted back to read only.

The original version used SYSTEM_STATE to determine when it was OK
or not to change the code to rw or ro. Andrew Morton pointed out that
using SYSTEM_STATE is a bad idea since there is no guarantee to what
its state will actually be.

Instead, I moved the check into the set_kernel_text_* functions
themselves, and use a local variable to determine when it is
OK to change the kernel text RW permissions.

[ Update: Ingo Molnar suggested moving the prototypes to cacheflush.h ]

Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/include/asm/cacheflush.h |    5 +++++
 arch/x86/kernel/ftrace.c          |   13 +++++++++++++
 arch/x86/mm/init_32.c             |   35 ++++++++++++++++++++++++++++++++---
 arch/x86/mm/init_64.c             |   37 ++++++++++++++++++++++++++++++++-----
 4 files changed, 82 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index 2f84665..6145063 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -104,6 +104,11 @@ void clflush_cache_range(void *addr, unsigned int size);
 #ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void);
 extern const int rodata_test_data;
+void set_kernel_text_rw(void);
+void set_kernel_text_ro(void);
+#else
+static inline void set_kernel_text_rw(void) { }
+static inline void set_kernel_text_ro(void) { }
 #endif
 
 #ifdef CONFIG_DEBUG_RODATA_TEST
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 231bdd3..77857d4 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/list.h>
 
+#include <asm/cacheflush.h>
 #include <asm/ftrace.h>
 #include <linux/ftrace.h>
 #include <asm/nops.h>
@@ -26,6 +27,18 @@
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
+int ftrace_arch_code_modify_prepare(void)
+{
+	set_kernel_text_rw();
+	return 0;
+}
+
+int ftrace_arch_code_modify_post_process(void)
+{
+	set_kernel_text_ro();
+	return 0;
+}
+
 union ftrace_code_union {
 	char code[MCOUNT_INSN_SIZE];
 	struct {
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 2cef050..3eb2ed1 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -1155,17 +1155,47 @@ static noinline int do_test_wp_bit(void)
 const int rodata_test_data = 0xC3;
 EXPORT_SYMBOL_GPL(rodata_test_data);
 
+static int kernel_set_to_readonly;
+
+void set_kernel_text_rw(void)
+{
+	unsigned long start = PFN_ALIGN(_text);
+	unsigned long size = PFN_ALIGN(_etext) - start;
+
+	if (!kernel_set_to_readonly)
+		return;
+
+	pr_debug("Set kernel text: %lx - %lx for read write\n",
+		 start, start+size);
+
+	set_pages_rw(virt_to_page(start), size >> PAGE_SHIFT);
+}
+
+void set_kernel_text_ro(void)
+{
+	unsigned long start = PFN_ALIGN(_text);
+	unsigned long size = PFN_ALIGN(_etext) - start;
+
+	if (!kernel_set_to_readonly)
+		return;
+
+	pr_debug("Set kernel text: %lx - %lx for read only\n",
+		 start, start+size);
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
 
+	kernel_set_to_readonly = 1;
+
 #ifdef CONFIG_CPA_DEBUG
 	printk(KERN_INFO "Testing CPA: Reverting %lx-%lx\n",
 		start, start+size);
@@ -1174,7 +1204,6 @@ void mark_rodata_ro(void)
 	printk(KERN_INFO "Testing CPA: write protecting again\n");
 	set_pages_ro(virt_to_page(start), size>>PAGE_SHIFT);
 #endif
-#endif /* CONFIG_DYNAMIC_FTRACE */
 
 	start += size;
 	size = (unsigned long)__end_rodata - start;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index e6d36b4..63fdc53 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -986,21 +986,48 @@ void free_initmem(void)
 const int rodata_test_data = 0xC3;
 EXPORT_SYMBOL_GPL(rodata_test_data);
 
+static int kernel_set_to_readonly;
+
+void set_kernel_text_rw(void)
+{
+	unsigned long start = PFN_ALIGN(_stext);
+	unsigned long end = PFN_ALIGN(__start_rodata);
+
+	if (!kernel_set_to_readonly)
+		return;
+
+	pr_debug("Set kernel text: %lx - %lx for read write\n",
+		 start, end);
+
+	set_memory_rw(start, (end - start) >> PAGE_SHIFT);
+}
+
+void set_kernel_text_ro(void)
+{
+	unsigned long start = PFN_ALIGN(_stext);
+	unsigned long end = PFN_ALIGN(__start_rodata);
+
+	if (!kernel_set_to_readonly)
+		return;
+
+	pr_debug("Set kernel text: %lx - %lx for read only\n",
+		 start, end);
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
 
+	kernel_set_to_readonly = 1;
+
 	/*
 	 * The rodata section (but not the kernel text!) should also be
 	 * not-executable.
-- 
1.5.6.5

-- 
