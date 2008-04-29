Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbYD2Upl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbYD2Upl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbYD2Upb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:45:31 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:23641 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795AbYD2Upa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:45:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=ECnADQrJDHnzQZtRjCpZPs6b62S7Rv5aSLqYBUQFCmOyXqJ988X/J3J+FPbrCONw9PYM2xUBxUVEs/2unSYcIkiUN9LbM2uFfCvgXMzNvFDNJes/TSnYSagWqH2RGrRYFlLxG5MXikXBxdSiZPDVD6aazzct8xhlW94yHVM18AI=
Date: Tue, 29 Apr 2008 23:45:22 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] x86 mmiotrace: use resource_size_t for phys addresses
Message-ID: <20080429234522.31db6307@daedalus.pq.iki.fi>
In-Reply-To: <20080429234021.071f7948@daedalus.pq.iki.fi>
References: <20080428214504.5c359195@daedalus.pq.iki.fi>
	<20080429234021.071f7948@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 921daf84218f4d2b35007f7d867f3301bb59173d Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Tue, 29 Apr 2008 22:52:31 +0300
Subject: [PATCH] x86 mmiotrace: use resource_size_t for phys addresses

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/mm/mmio-mod.c         |   11 ++++++-----
 include/linux/mmiotrace.h      |   14 +++++++-------
 kernel/trace/trace_mmiotrace.c |   20 ++++++++++++--------
 3 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 278998c..3b04a01 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -48,7 +48,7 @@ struct trap_reason {
 struct remap_trace {
 	struct list_head list;
 	struct kmmio_probe probe;
-	unsigned long phys;
+	resource_size_t phys;
 	unsigned long id;
 };
 
@@ -275,7 +275,7 @@ static void post(struct kmmio_probe *p, unsigned long condition,
 	put_cpu_var(pf_reason);
 }
 
-static void ioremap_trace_core(unsigned long offset, unsigned long size,
+static void ioremap_trace_core(resource_size_t offset, unsigned long size,
 							void __iomem *addr)
 {
 	static atomic_t next_id;
@@ -319,13 +319,14 @@ not_enabled:
 	spin_unlock_irq(&trace_lock);
 }
 
-void
-mmiotrace_ioremap(unsigned long offset, unsigned long size, void __iomem *addr)
+void mmiotrace_ioremap(resource_size_t offset, unsigned long size,
+						void __iomem *addr)
 {
 	if (!is_enabled()) /* recheck and proper locking in *_core() */
 		return;
 
-	pr_debug(NAME "ioremap_*(0x%lx, 0x%lx) = %p\n", offset, size, addr);
+	pr_debug(NAME "ioremap_*(0x%llx, 0x%lx) = %p\n",
+				(unsigned long long)offset, size, addr);
 	if ((filter_offset) && (offset != filter_offset))
 		return;
 	ioremap_trace_core(offset, size, addr);
diff --git a/include/linux/mmiotrace.h b/include/linux/mmiotrace.h
index de8e912..5cbbc37 100644
--- a/include/linux/mmiotrace.h
+++ b/include/linux/mmiotrace.h
@@ -2,7 +2,6 @@
 #define MMIOTRACE_H
 
 #include <linux/types.h>
-
 #include <linux/list.h>
 
 struct kmmio_probe;
@@ -37,14 +36,15 @@ extern int kmmio_handler(struct pt_regs *regs, unsigned long addr);
 
 /* Called from ioremap.c */
 #ifdef CONFIG_MMIOTRACE
-extern void
-mmiotrace_ioremap(unsigned long offset, unsigned long size, void __iomem *addr);
+extern void mmiotrace_ioremap(resource_size_t offset, unsigned long size,
+							void __iomem *addr);
 extern void mmiotrace_iounmap(volatile void __iomem *addr);
 #else
-static inline void
-mmiotrace_ioremap(unsigned long offset, unsigned long size, void __iomem *addr)
+static inline void mmiotrace_ioremap(resource_size_t offset,
+					unsigned long size, void __iomem *addr)
 {
 }
+
 static inline void mmiotrace_iounmap(volatile void __iomem *addr)
 {
 }
@@ -60,7 +60,7 @@ enum mm_io_opcode {
 };
 
 struct mmiotrace_rw {
-	unsigned long phys;	/* PCI address of register */
+	resource_size_t phys;	/* PCI address of register */
 	unsigned long value;
 	unsigned long pc;	/* optional program counter */
 	int map_id;
@@ -69,7 +69,7 @@ struct mmiotrace_rw {
 };
 
 struct mmiotrace_map {
-	unsigned long phys;	/* base address in PCI space */
+	resource_size_t phys;	/* base address in PCI space */
 	unsigned long virt;	/* base virtual address */
 	unsigned long len;	/* mapping size */
 	int map_id;
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 3c1dacd..b13dc19 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -184,20 +184,23 @@ static int mmio_print_rw(struct trace_iterator *iter)
 	switch (entry->mmiorw.opcode) {
 	case MMIO_READ:
 		ret = trace_seq_printf(s,
-			"R %d %lu.%06lu %d 0x%lx 0x%lx 0x%lx %d\n",
-			rw->width, secs, usec_rem, rw->map_id, rw->phys,
+			"R %d %lu.%06lu %d 0x%llx 0x%lx 0x%lx %d\n",
+			rw->width, secs, usec_rem, rw->map_id,
+			(unsigned long long)rw->phys,
 			rw->value, rw->pc, 0);
 		break;
 	case MMIO_WRITE:
 		ret = trace_seq_printf(s,
-			"W %d %lu.%06lu %d 0x%lx 0x%lx 0x%lx %d\n",
-			rw->width, secs, usec_rem, rw->map_id, rw->phys,
+			"W %d %lu.%06lu %d 0x%llx 0x%lx 0x%lx %d\n",
+			rw->width, secs, usec_rem, rw->map_id,
+			(unsigned long long)rw->phys,
 			rw->value, rw->pc, 0);
 		break;
 	case MMIO_UNKNOWN_OP:
 		ret = trace_seq_printf(s,
-			"UNKNOWN %lu.%06lu %d 0x%lx %02x,%02x,%02x 0x%lx %d\n",
-			secs, usec_rem, rw->map_id, rw->phys,
+			"UNKNOWN %lu.%06lu %d 0x%llx %02x,%02x,%02x 0x%lx %d\n",
+			secs, usec_rem, rw->map_id,
+			(unsigned long long)rw->phys,
 			(rw->value >> 16) & 0xff, (rw->value >> 8) & 0xff,
 			(rw->value >> 0) & 0xff, rw->pc, 0);
 		break;
@@ -223,8 +226,9 @@ static int mmio_print_map(struct trace_iterator *iter)
 	switch (entry->mmiorw.opcode) {
 	case MMIO_PROBE:
 		ret = trace_seq_printf(s,
-			"MAP %lu.%06lu %d 0x%lx 0x%lx 0x%lx 0x%lx %d\n",
-			secs, usec_rem, m->map_id, m->phys, m->virt, m->len,
+			"MAP %lu.%06lu %d 0x%llx 0x%lx 0x%lx 0x%lx %d\n",
+			secs, usec_rem, m->map_id,
+			(unsigned long long)m->phys, m->virt, m->len,
 			0UL, 0);
 		break;
 	case MMIO_UNPROBE:
-- 
1.5.3.7

