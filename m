Return-Path: <linux-kernel-owner+w=401wt.eu-S1761414AbXK1VRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761414AbXK1VRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 16:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757366AbXK1VPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 16:15:35 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56245 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755595AbXK1VP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 16:15:28 -0500
Message-Id: <20071128211527.846491979@sgi.com>
References: <20071128210926.008783214@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 28 Nov 2007 13:09:34 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: [patch 08/10] Sparc64: Use generic percpu
Content-Disposition: inline; filename=sparc64_generic_percpu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sparc64 has a way of providing the base address for the per cpu area of the
currently executing processor in a global register.

Sparc64 also provides a way to calculate the address of a per cpu area
from a base address instead of performing an array lookup.

Cc: David Miller <davem@davemloft.net>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/sparc64/mm/init.c       |    5 +++++
 include/asm-sparc64/percpu.h |   12 ++----------
 2 files changed, 7 insertions(+), 10 deletions(-)

Index: linux-2.6.24-rc3-mm2/include/asm-sparc64/percpu.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-sparc64/percpu.h	2007-11-28 12:51:42.448213150 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-sparc64/percpu.h	2007-11-28 12:52:01.036463295 -0800
@@ -7,7 +7,6 @@ register unsigned long __local_per_cpu_o
 
 #ifdef CONFIG_SMP
 
-#define setup_per_cpu_areas()			do { } while (0)
 extern void real_setup_per_cpu_areas(void);
 
 extern unsigned long __per_cpu_base;
@@ -16,21 +15,14 @@ extern unsigned long __per_cpu_shift;
 	(__per_cpu_base + ((unsigned long)(__cpu) << __per_cpu_shift))
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
-/* var is in discarded region: offset to particular copy we want */
-#define per_cpu(var, cpu) (*RELOC_HIDE(&per_cpu__##var, __per_cpu_offset(cpu)))
-#define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __local_per_cpu_offset))
-#define __raw_get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __local_per_cpu_offset))
+#define __my_cpu_offset __local_per_cpu_offset
 
 #else /* ! SMP */
 
 #define real_setup_per_cpu_areas()		do { } while (0)
 
-#define per_cpu(var, cpu)			(*((void)cpu, &per_cpu__##var))
-#define __get_cpu_var(var)			per_cpu__##var
-#define __raw_get_cpu_var(var)			per_cpu__##var
-
 #endif	/* SMP */
 
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
+#include <asm-generic/percpu.h>
 
 #endif /* __ARCH_SPARC64_PERCPU__ */
Index: linux-2.6.24-rc3-mm2/arch/sparc64/mm/init.c
===================================================================
--- linux-2.6.24-rc3-mm2.orig/arch/sparc64/mm/init.c	2007-11-28 12:51:19.464963124 -0800
+++ linux-2.6.24-rc3-mm2/arch/sparc64/mm/init.c	2007-11-28 12:52:01.040463210 -0800
@@ -1323,6 +1323,11 @@ pgd_t swapper_pg_dir[2048];
 static void sun4u_pgprot_init(void);
 static void sun4v_pgprot_init(void);
 
+/* Dummy function */
+void __init setup_per_cpu_areas(void)
+{
+}
+
 void __init paging_init(void)
 {
 	unsigned long end_pfn, pages_avail, shift, phys_base;

-- 
