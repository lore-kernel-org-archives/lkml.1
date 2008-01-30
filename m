Return-Path: <linux-kernel-owner+w=401wt.eu-S1764835AbYA3SL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764835AbYA3SL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758251AbYA3SJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:09:51 -0500
Received: from relay1.sgi.com ([192.48.171.29]:59565 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752818AbYA3SJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:09:42 -0500
Message-Id: <20080130180940.921597000@sgi.com>
References: <20080130180940.022172000@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 30 Jan 2008 10:09:46 -0800
From: travis@sgi.com
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 6/6] s390: Use generic percpu linux-2.6.git
Content-Disposition: inline; filename=s390_generic_percpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change s390 percpu.h to use asm-generic/percpu.h

Based on latest linux-2.6.git

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>

Signed-off-by: Mike Travis <travis@sgi.com>
---
linux-2.6.git:
  - added back in missing pieces from x86.git merge
---
 include/asm-s390/percpu.h |   33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

--- a/include/asm-s390/percpu.h
+++ b/include/asm-s390/percpu.h
@@ -13,40 +13,25 @@
  */
 #if defined(__s390x__) && defined(MODULE)
 
-#define __reloc_hide(var,offset) (*({			\
+#define SHIFT_PERCPU_PTR(ptr,offset) (({			\
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
+#define SHIFT_PERCPU_PTR(ptr, offset) (({				\
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
