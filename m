Return-Path: <linux-kernel-owner+w=401wt.eu-S1758972AbXKTBZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972AbXKTBZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756690AbXKTBOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:14:12 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36900 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756093AbXKTBNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:40 -0500
Message-Id: <20071120011340.340784277@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:12:08 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 36/45] X86_64: Place pda first in cpu area.
Content-Disposition: inline; filename=x86_64_pda_first
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If we move the pda to the beginning of the cpu area then the gs segment will
also point to the beginning of the cpu area. After this patch we can use gs
on any percpu variable or cpu_alloc pointer from cpu 0 to get to the active
processors variable. There is no need anymore to add a per cpu offset
anymore.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/kernel/setup64.c         |    2 +-
 include/asm-generic/vmlinux.lds.h |    2 ++
 include/asm-x86/percpu_64.h       |    4 ++++
 3 files changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/setup64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup64.c	2007-11-19 14:55:18.546422138 -0800
+++ linux-2.6/arch/x86/kernel/setup64.c	2007-11-19 14:55:41.937923200 -0800
@@ -31,7 +31,7 @@ cpumask_t cpu_initialized __cpuinitdata 
 struct x8664_pda *_cpu_pda[NR_CPUS] __read_mostly;
 EXPORT_SYMBOL(_cpu_pda);
 
-DEFINE_PER_CPU(struct x8664_pda, pda);
+DEFINE_PER_CPU_FIRST(struct x8664_pda, pda);
 EXPORT_PER_CPU_SYMBOL(pda);
 
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
Index: linux-2.6/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.orig/include/asm-generic/vmlinux.lds.h	2007-11-19 14:53:45.510673454 -0800
+++ linux-2.6/include/asm-generic/vmlinux.lds.h	2007-11-19 14:55:24.554173129 -0800
@@ -260,6 +260,7 @@
 	__per_cpu_start = .;						\
 	__load_per_cpu_start = .;					\
 	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
+		*(.data.percpu.first)					\
 		*(.data.percpu)						\
 		*(.data.percpu.shared_aligned)				\
 	}								\
@@ -271,6 +272,7 @@
 	__load_per_cpu_start = .;					\
 	.data.percpu 0 : AT(__load_per_cpu_start - LOAD_OFFSET) {	\
 		__per_cpu_start = .;					\
+		*(.data.percpu.first)					\
 		*(.data.percpu)						\
 		*(.data.percpu.shared_aligned)				\
 		__per_cpu_end = .;					\
Index: linux-2.6/include/asm-x86/percpu_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/percpu_64.h	2007-11-19 14:53:45.518673338 -0800
+++ linux-2.6/include/asm-x86/percpu_64.h	2007-11-19 14:55:24.554173129 -0800
@@ -25,6 +25,10 @@
     __typeof__(type) per_cpu__##name				\
     ____cacheline_internodealigned_in_smp
 
+#define DEFINE_PER_CPU_FIRST(type, name)			\
+    __attribute__((__section__(".data.percpu.first")))		\
+    __typeof__(type) per_cpu__##name
+
 /* var is in discarded region: offset to particular copy we want */
 #define per_cpu(var, cpu) (*({				\
 	extern int simple_identifier_##var(void);	\

-- 
