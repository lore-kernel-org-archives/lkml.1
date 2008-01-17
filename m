Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYAQWhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYAQWhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759447AbYAQWfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:35:20 -0500
Received: from relay1.sgi.com ([192.48.171.29]:47367 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756267AbYAQWfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:35:09 -0500
Message-Id: <20080117223505.774586000@sgi.com>
References: <20080117223505.203884000@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jan 2008 14:35:09 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       tony.luck@intel.com
Subject: [PATCH 4/6] ia64: Use generic percpu
Content-Disposition: inline; filename=ia64_generic_percpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ia64 has a special processor specific mapping that can be used to locate the
offset for the current per cpu area.

Cc: linux-ia64@vger.kernel.org
Cc: tony.luck@intel.com
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---

V1->V2:
- Merge fixes
- Remove transitional check for PER_CPU_ATTRIBUTES from linux/percpu.h

V2-.V3:
- use generic percpy_modcopy()

---
 include/asm-ia64/percpu.h |   24 +++++++-----------------
 include/linux/percpu.h    |    4 ----
 2 files changed, 7 insertions(+), 21 deletions(-)

--- a/include/asm-ia64/percpu.h
+++ b/include/asm-ia64/percpu.h
@@ -19,29 +19,14 @@
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
@@ -52,7 +37,12 @@ extern void *per_cpu_init(void);
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
 
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -9,10 +9,6 @@
 
 #include <asm/percpu.h>
 
-#ifndef PER_CPU_ATTRIBUTES
-#define PER_CPU_ATTRIBUTES
-#endif
-
 #ifdef CONFIG_SMP
 #define DEFINE_PER_CPU(type, name)					\
 	__attribute__((__section__(".data.percpu")))			\

-- 
