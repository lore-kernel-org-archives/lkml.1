Return-Path: <linux-kernel-owner+w=401wt.eu-S1758951AbXK1VR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbXK1VR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 16:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757667AbXK1VPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 16:15:35 -0500
Received: from relay1.sgi.com ([192.48.171.29]:38903 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755511AbXK1VP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 16:15:27 -0500
Message-Id: <20071128211527.373111512@sgi.com>
References: <20071128210926.008783214@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 28 Nov 2007 13:09:32 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com
Subject: [patch 06/10] s390: Use generic percpu
Content-Disposition: inline; filename=s390_generic_percpu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

s390 has a special way to determine the pointer to a per cpu area
plus there is a way to access the base of the per cpu area of the
currently executing processor.

Note: I had to do a minor change to ASM code. Please check that
this was done right.

Cc: schwidefsky@de.ibm.com
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-s390/percpu.h |   33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

Index: linux-2.6.24-rc3-mm2/include/asm-s390/percpu.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-s390/percpu.h	2007-11-28 12:51:42.448213150 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-s390/percpu.h	2007-11-28 12:51:53.193400115 -0800
@@ -13,40 +13,25 @@
  */
 #if defined(__s390x__) && defined(MODULE)
 
-#define __reloc_hide(var,offset) (*({			\
+#define SHIFT_PTR(ptr,offset) (({			\
 	extern int simple_identifier_##var(void);	\
 	unsigned long *__ptr;				\
-	asm ( "larl %0,per_cpu__"#var"@GOTENT"		\
-	    : "=a" (__ptr) : "X" (per_cpu__##var) );	\
-	(typeof(&per_cpu__##var))((*__ptr) + (offset));	}))
+	asm ( "larl %0, %1@GOTENT"		\
+	    : "=a" (__ptr) : "X" (ptr) );		\
+	(typeof(ptr))((*__ptr) + (offset));	}))
 
 #else
 
-#define __reloc_hide(var, offset) (*({				\
+#define SHIFT_PTR(ptr, offset) (({				\
 	extern int simple_identifier_##var(void);		\
 	unsigned long __ptr;					\
-	asm ( "" : "=a" (__ptr) : "0" (&per_cpu__##var) );	\
-	(typeof(&per_cpu__##var)) (__ptr + (offset)); }))
+	asm ( "" : "=a" (__ptr) : "0" (ptr) );			\
+	(typeof(ptr)) (__ptr + (offset)); }))
 
 #endif
 
-#ifdef CONFIG_SMP
+#define __my_cpu_offset S390_lowcore.percpu_offset
 
-extern unsigned long __per_cpu_offset[NR_CPUS];
-
-#define __get_cpu_var(var) __reloc_hide(var,S390_lowcore.percpu_offset)
-#define __raw_get_cpu_var(var) __reloc_hide(var,S390_lowcore.percpu_offset)
-#define per_cpu(var,cpu) __reloc_hide(var,__per_cpu_offset[cpu])
-#define per_cpu_offset(x) (__per_cpu_offset[x])
-
-#else /* ! SMP */
-
-#define __get_cpu_var(var) __reloc_hide(var,0)
-#define __raw_get_cpu_var(var) __reloc_hide(var,0)
-#define per_cpu(var,cpu) __reloc_hide(var,0)
-
-#endif /* SMP */
-
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
+#include <asm-generic/percpu.h>
 
 #endif /* __ARCH_S390_PERCPU__ */

-- 
