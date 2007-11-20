Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbXKTBZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbXKTBZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:25:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756704AbXKTBOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:14:15 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49878 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756171AbXKTBNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:41 -0500
Message-Id: <20071120011340.801418447@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:12:10 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 38/45] x86_64: Remove obsolete per_cpu offset calculations
Content-Disposition: inline; filename=remove_per_cpu_offset_array
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace all uses of __per_cpu_offset with CPU_PTR. This will avoid a lot
of lookups for per cpu offset calculations.

Keep per_cpu_offset() itself because lockdep uses it.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/kernel/smpboot_64.c |    8 +++-----
 include/asm-x86/percpu_64.h  |   14 ++++++--------
 2 files changed, 9 insertions(+), 13 deletions(-)

Index: linux-2.6/include/asm-x86/percpu_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/percpu_64.h	2007-11-19 16:07:43.153640561 -0800
+++ linux-2.6/include/asm-x86/percpu_64.h	2007-11-19 16:12:01.977139696 -0800
@@ -11,10 +11,8 @@
 
 #include <asm/pda.h>
 
-#define __per_cpu_offset(cpu) (cpu_pda(cpu)->data_offset)
-#define __my_cpu_offset() read_pda(data_offset)
-
-#define per_cpu_offset(x) (__per_cpu_offset(x))
+/* Legacy: lockdep in the core kernel uses this */
+#define per_cpu_offset(cpu) CPU_OFFSET(cpu)
 
 /* Separate out the type, so (int[3], foo) works. */
 #define DEFINE_PER_CPU(type, name) \
@@ -32,20 +30,20 @@
 /* var is in discarded region: offset to particular copy we want */
 #define per_cpu(var, cpu) (*({				\
 	extern int simple_identifier_##var(void);	\
-	RELOC_HIDE(&per_cpu__##var, __per_cpu_offset(cpu)); }))
+	CPU_PTR(&per_cpu__##var, (cpu)); }))
 #define __get_cpu_var(var) (*({				\
 	extern int simple_identifier_##var(void);	\
-	RELOC_HIDE(&per_cpu__##var, __my_cpu_offset()); }))
+	THIS_CPU(&per_cpu__##var); }))
 #define __raw_get_cpu_var(var) (*({			\
 	extern int simple_identifier_##var(void);	\
-	RELOC_HIDE(&per_cpu__##var, __my_cpu_offset()); }))
+	__THIS_CPU(&per_cpu__##var); }))
 
 /* A macro to avoid #include hell... */
 #define percpu_modcopy(pcpudst, src, size)			\
 do {								\
 	unsigned int __i;					\
 	for_each_possible_cpu(__i)				\
-		memcpy((pcpudst)+__per_cpu_offset(__i),		\
+		memcpy(CPU_PTR(pcpudst, __i),			\
 		       (src), (size));				\
 } while (0)
 
Index: linux-2.6/arch/x86/kernel/smpboot_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot_64.c	2007-11-19 16:06:15.301390091 -0800
+++ linux-2.6/arch/x86/kernel/smpboot_64.c	2007-11-19 16:10:23.998889835 -0800
@@ -835,11 +835,9 @@ void __init smp_set_apicids(void)
 {
 	int cpu;
 
-	for_each_cpu_mask(cpu, cpu_possible_map) {
-		if (per_cpu_offset(cpu))
-			per_cpu(x86_cpu_to_apicid, cpu) =
-						x86_cpu_to_apicid_init[cpu];
-	}
+	for_each_cpu_mask(cpu, cpu_possible_map)
+		per_cpu(x86_cpu_to_apicid, cpu) =
+					x86_cpu_to_apicid_init[cpu];
 
 	/* indicate the static array will be going away soon */
 	x86_cpu_to_apicid_ptr = NULL;

-- 
