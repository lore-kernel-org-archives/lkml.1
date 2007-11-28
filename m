Return-Path: <linux-kernel-owner+w=401wt.eu-S1761179AbXK1VRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761179AbXK1VRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 16:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757235AbXK1VPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 16:15:33 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56243 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755590AbXK1VP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 16:15:28 -0500
Message-Id: <20071128211528.090929484@sgi.com>
References: <20071128210926.008783214@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 28 Nov 2007 13:09:35 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       tony.luck@intel.com
Subject: [patch 09/10] ia64: Use generic percpu
Content-Disposition: inline; filename=ia64_generic_percpu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

V1->V2:
- Merge fixes
- Remove transitional check for PER_CPU_ATTRIBUTES from linux/percpu.h

ia64 has a special processor specific mapping that can be used to locate the
offset for the current per cpu area.

Cc: linux-ia64@vger.kernel.org
Cc: tony.luck@intel.com
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-ia64/percpu.h |   25 +++++++------------------
 include/linux/percpu.h    |    4 ----
 2 files changed, 7 insertions(+), 22 deletions(-)

Index: linux-2.6.24-rc3-mm2/include/asm-ia64/percpu.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-ia64/percpu.h	2007-11-28 12:51:42.448213150 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-ia64/percpu.h	2007-11-28 12:52:04.955963258 -0800
@@ -12,36 +12,20 @@
 # define THIS_CPU(var)	(per_cpu__##var)  /* use this to mark accesses to per-CPU variables... */
 #else /* !__ASSEMBLY__ */
 
-
 #include <linux/threads.h>
 
 #ifdef HAVE_MODEL_SMALL_ATTRIBUTE
 # define PER_CPU_ATTRIBUTES	__attribute__((__model__ (__small__)))
 #endif
 
-#define DECLARE_PER_CPU(type, name)				\
-	extern PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
-
 #ifdef CONFIG_SMP
 
-extern unsigned long __per_cpu_offset[NR_CPUS];
-#define per_cpu_offset(x) (__per_cpu_offset[x])
-
-/* Equal to __per_cpu_offset[smp_processor_id()], but faster to access: */
-DECLARE_PER_CPU(unsigned long, local_per_cpu_offset);
-
-#define per_cpu(var, cpu)  (*RELOC_HIDE(&per_cpu__##var, __per_cpu_offset[cpu]))
-#define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __ia64_per_cpu_var(local_per_cpu_offset)))
-#define __raw_get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __ia64_per_cpu_var(local_per_cpu_offset)))
+#define __my_cpu_offset	__ia64_per_cpu_var(local_per_cpu_offset)
 
-extern void setup_per_cpu_areas (void);
 extern void *per_cpu_init(void);
 
 #else /* ! SMP */
 
-#define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
-#define __get_cpu_var(var)			per_cpu__##var
-#define __raw_get_cpu_var(var)			per_cpu__##var
 #define per_cpu_init()				(__phys_per_cpu_start)
 
 #endif	/* SMP */
@@ -52,7 +36,12 @@ extern void *per_cpu_init(void);
  * On the positive side, using __ia64_per_cpu_var() instead of __get_cpu_var() is slightly
  * more efficient.
  */
-#define __ia64_per_cpu_var(var)	(per_cpu__##var)
+#define __ia64_per_cpu_var(var)	per_cpu__##var
+
+#include <asm-generic/percpu.h>
+
+/* Equal to __per_cpu_offset[smp_processor_id()], but faster to access: */
+DECLARE_PER_CPU(unsigned long, local_per_cpu_offset);
 
 #endif /* !__ASSEMBLY__ */
 
Index: linux-2.6.24-rc3-mm2/include/linux/percpu.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/linux/percpu.h	2007-11-28 12:51:42.448213150 -0800
+++ linux-2.6.24-rc3-mm2/include/linux/percpu.h	2007-11-28 12:52:04.955963258 -0800
@@ -9,10 +9,6 @@
 
 #include <asm/percpu.h>
 
-#ifndef PER_CPU_ATTRIBUTES
-#define PER_CPU_ATTRIBUTES
-#endif
-
 #define DEFINE_PER_CPU(type, name)					\
 	__attribute__((__section__(".data.percpu")))			\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name

-- 
