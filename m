Return-Path: <linux-kernel-owner+w=401wt.eu-S1758911AbXK0ARF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911AbXK0ARF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 19:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757975AbXK0AOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 19:14:38 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49142 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757048AbXK0AOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:14:32 -0500
Message-Id: <20071127001431.461987808@sgi.com>
References: <20071127001407.859743255@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 26 Nov 2007 16:14:17 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com
Subject: [patch 10/14] s390: Use generic percpu
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

Index: linux-2.6/include/asm-s390/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-s390/percpu.h	2007-11-24 16:20:38.776100537 -0800
+++ linux-2.6/include/asm-s390/percpu.h	2007-11-24 16:21:11.536101444 -0800
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
