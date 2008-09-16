Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbYIPTAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbYIPTAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 15:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbYIPTAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 15:00:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:12484 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbYIPTAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 15:00:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=wbn/Ovgyn8MUlhY7O/yF+pguKABJJdGwHjp+sHdQmZrPmwAUErksdRqPmpOHa2CMXt
         NfEzl0RvNkBTVKVawFwf7ybZR1clA+gN65KjKsAUlSgZf/OCufvknpbWt+jCdG3DfM6O
         /3tlrloNBYbeDxWkl2/np8juvDFgZ3gvL7f+A=
Date: Tue, 16 Sep 2008 22:00:34 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       Pavel Roskin <proski@gnu.org>
Subject: [PATCH 4/7] x86 mmiotrace: implement mmiotrace_printk().
Message-ID: <20080916220034.0ffa296b@daedalus.pq.iki.fi>
In-Reply-To: <20080916215416.16aee2dd@daedalus.pq.iki.fi>
References: <48B1D5CA.8000607@gmail.com>
	<c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com>
	<20080827212130.4b8365a8@daedalus.pq.iki.fi>
	<c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com>
	<20080828214256.296e34ec@daedalus.pq.iki.fi>
	<c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com>
	<20080904203058.7e57729e@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0809041407140.2431@gandalf.stny.rr.com>
	<20080915224707.76b2cca0@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0809151556260.22620@gandalf.stny.rr.com>
	<20080916215416.16aee2dd@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ca4db25e22b79fd77f4a7c6bb812e605379840a0 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sun, 14 Sep 2008 18:37:46 +0300
Subject: [PATCH] x86 mmiotrace: implement mmiotrace_printk().

Offer mmiotrace users a function to inject markers from inside the kernel.
This depends on the trace_vprintk() patch.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/mm/mmio-mod.c         |   19 ++++++++++++++++++-
 arch/x86/mm/testmmiotrace.c    |    4 ++++
 include/linux/mmiotrace.h      |   17 +++++++++++++++--
 kernel/trace/trace_mmiotrace.c |    5 +++++
 4 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 754bd1e..5e2e2e7 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -75,7 +75,7 @@ static LIST_HEAD(trace_list);		/* struct remap_trace */
  *   and trace_lock.
  * - Routines depending on is_enabled() must take trace_lock.
  * - trace_list users must hold trace_lock.
- * - is_enabled() guarantees that mmio_trace_record is allowed.
+ * - is_enabled() guarantees that mmio_trace_{rw,mapping} are allowed.
  * - pre/post callbacks assume the effect of is_enabled() being true.
  */
 
@@ -379,6 +379,23 @@ void mmiotrace_iounmap(volatile void __iomem *addr)
 		iounmap_trace_core(addr);
 }
 
+int mmiotrace_printk(const char *fmt, ...)
+{
+	int ret = 0;
+	va_list args;
+	unsigned long flags;
+	va_start(args, fmt);
+
+	spin_lock_irqsave(&trace_lock, flags);
+	if (is_enabled())
+		ret = mmio_trace_printk(fmt, args);
+	spin_unlock_irqrestore(&trace_lock, flags);
+
+	va_end(args);
+	return ret;
+}
+EXPORT_SYMBOL(mmiotrace_printk);
+
 static void clear_trace_list(void)
 {
 	struct remap_trace *trace;
diff --git a/arch/x86/mm/testmmiotrace.c b/arch/x86/mm/testmmiotrace.c
index d877c5b..ab50a8d 100644
--- a/arch/x86/mm/testmmiotrace.c
+++ b/arch/x86/mm/testmmiotrace.c
@@ -3,6 +3,7 @@
  */
 #include <linux/module.h>
 #include <linux/io.h>
+#include <linux/mmiotrace.h>
 
 #define MODULE_NAME "testmmiotrace"
 
@@ -13,6 +14,7 @@ MODULE_PARM_DESC(mmio_address, "Start address of the mapping of 16 kB.");
 static void do_write_test(void __iomem *p)
 {
 	unsigned int i;
+	mmiotrace_printk("Write test.\n");
 	for (i = 0; i < 256; i++)
 		iowrite8(i, p + i);
 	for (i = 1024; i < (5 * 1024); i += 2)
@@ -24,6 +26,7 @@ static void do_write_test(void __iomem *p)
 static void do_read_test(void __iomem *p)
 {
 	unsigned int i;
+	mmiotrace_printk("Read test.\n");
 	for (i = 0; i < 256; i++)
 		ioread8(p + i);
 	for (i = 1024; i < (5 * 1024); i += 2)
@@ -39,6 +42,7 @@ static void do_test(void)
 		pr_err(MODULE_NAME ": could not ioremap, aborting.\n");
 		return;
 	}
+	mmiotrace_printk("ioremap returned %p.\n", p);
 	do_write_test(p);
 	do_read_test(p);
 	iounmap(p);
diff --git a/include/linux/mmiotrace.h b/include/linux/mmiotrace.h
index 61d19e1..60cc3bf 100644
--- a/include/linux/mmiotrace.h
+++ b/include/linux/mmiotrace.h
@@ -34,11 +34,15 @@ extern void unregister_kmmio_probe(struct kmmio_probe *p);
 /* Called from page fault handler. */
 extern int kmmio_handler(struct pt_regs *regs, unsigned long addr);
 
-/* Called from ioremap.c */
 #ifdef CONFIG_MMIOTRACE
+/* Called from ioremap.c */
 extern void mmiotrace_ioremap(resource_size_t offset, unsigned long size,
 							void __iomem *addr);
 extern void mmiotrace_iounmap(volatile void __iomem *addr);
+
+/* For anyone to insert markers. Remember trailing newline. */
+extern int mmiotrace_printk(const char *fmt, ...)
+				__attribute__ ((format (printf, 1, 2)));
 #else
 static inline void mmiotrace_ioremap(resource_size_t offset,
 					unsigned long size, void __iomem *addr)
@@ -48,7 +52,15 @@ static inline void mmiotrace_ioremap(resource_size_t offset,
 static inline void mmiotrace_iounmap(volatile void __iomem *addr)
 {
 }
-#endif /* CONFIG_MMIOTRACE_HOOKS */
+
+static inline int mmiotrace_printk(const char *fmt, ...)
+				__attribute__ ((format (printf, 1, 0)));
+
+static inline int mmiotrace_printk(const char *fmt, ...)
+{
+	return 0;
+}
+#endif /* CONFIG_MMIOTRACE */
 
 enum mm_io_opcode {
 	MMIO_READ = 0x1,     /* struct mmiotrace_rw */
@@ -81,5 +93,6 @@ extern void enable_mmiotrace(void);
 extern void disable_mmiotrace(void);
 extern void mmio_trace_rw(struct mmiotrace_rw *rw);
 extern void mmio_trace_mapping(struct mmiotrace_map *map);
+extern int mmio_trace_printk(const char *fmt, va_list args);
 
 #endif /* MMIOTRACE_H */
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index ef02747..767d1fa 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -335,3 +335,8 @@ void mmio_trace_mapping(struct mmiotrace_map *map)
 	__trace_mmiotrace_map(tr, data, map);
 	preempt_enable();
 }
+
+int mmio_trace_printk(const char *fmt, va_list args)
+{
+	return trace_vprintk(0, fmt, args);
+}
-- 
1.5.6.4

