Return-Path: <linux-kernel-owner+w=401wt.eu-S1759459AbYAQWgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459AbYAQWgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:36:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757427AbYAQWfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:35:15 -0500
Received: from relay2.sgi.com ([192.48.171.30]:50942 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755628AbYAQWfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:35:09 -0500
Message-Id: <20080117223505.644199000@sgi.com>
References: <20080117223505.203884000@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jan 2008 14:35:08 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: [PATCH 3/6] Sparc64: Use generic percpu
Content-Disposition: inline; filename=sparc64_generic_percpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparc64 has a way of providing the base address for the per cpu area of the
currently executing processor in a global register.

Sparc64 also provides a way to calculate the address of a per cpu area
from a base address instead of performing an array lookup.

Cc: David Miller <davem@davemloft.net>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/sparc64/mm/init.c       |    5 +++++
 include/asm-sparc64/percpu.h |   22 +++-------------------
 2 files changed, 8 insertions(+), 19 deletions(-)

--- a/arch/sparc64/mm/init.c
+++ b/arch/sparc64/mm/init.c
@@ -1328,6 +1328,11 @@ pgd_t swapper_pg_dir[2048];
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
--- a/include/asm-sparc64/percpu.h
+++ b/include/asm-sparc64/percpu.h
@@ -7,7 +7,6 @@ register unsigned long __local_per_cpu_o
 
 #ifdef CONFIG_SMP
 
-#define setup_per_cpu_areas()			do { } while (0)
 extern void real_setup_per_cpu_areas(void);
 
 extern unsigned long __per_cpu_base;
@@ -16,29 +15,14 @@ extern unsigned long __per_cpu_shift;
 	(__per_cpu_base + ((unsigned long)(__cpu) << __per_cpu_shift))
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
-/* var is in discarded region: offset to particular copy we want */
-#define per_cpu(var, cpu) (*RELOC_HIDE(&per_cpu__##var, __per_cpu_offset(cpu)))
-#define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __local_per_cpu_offset))
-#define __raw_get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __local_per_cpu_offset))
-
-/* A macro to avoid #include hell... */
-#define percpu_modcopy(pcpudst, src, size)			\
-do {								\
-	unsigned int __i;					\
-	for_each_possible_cpu(__i)				\
-		memcpy((pcpudst)+__per_cpu_offset(__i),		\
-		       (src), (size));				\
-} while (0)
+#define __my_cpu_offset __local_per_cpu_offset
+
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

-- 
