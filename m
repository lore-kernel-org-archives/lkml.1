Return-Path: <linux-kernel-owner+w=401wt.eu-S1761781AbYC0RMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761781AbYC0RMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759357AbYC0RLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:11:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758936AbYC0RLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:11:04 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 3/9] [PATCH] x86: merge hard/logical_smp_processor_id
Date: Thu, 27 Mar 2008 14:05:58 -0300
Message-Id: <12066375783022-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12066375644061-git-send-email-gcosta@redhat.com>
References: <12066375644061-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code is now the same between i386 and x86_64. We already
know what happens when it reaches this point: They go away
from the arch-specific headers, and suddenly appears in the common
header.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/smp.h    |   27 +++++++++++++++++++++++++++
 include/asm-x86/smp_32.h |   27 ---------------------------
 include/asm-x86/smp_64.h |   27 ---------------------------
 3 files changed, 27 insertions(+), 54 deletions(-)

diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 664f9c0..eb05804 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -128,6 +128,33 @@ void smp_store_cpu_info(int id);
 # include "smp_64.h"
 #endif
 
+#ifdef CONFIG_X86_LOCAL_APIC
+
+static inline int logical_smp_processor_id(void)
+{
+	/* we don't want to mark this access volatile - bad code generation */
+	return GET_APIC_LOGICAL_ID(*(u32 *)(APIC_BASE + APIC_LDR));
+}
+
+# ifdef APIC_DEFINITION
+extern int hard_smp_processor_id(void);
+# else
+#  include <mach_apicdef.h>
+static inline int hard_smp_processor_id(void)
+{
+	/* we don't want to mark this access volatile - bad code generation */
+	return GET_APIC_ID(*(u32 *)(APIC_BASE + APIC_ID));
+}
+# endif /* APIC_DEFINITION */
+
+#else /* CONFIG_X86_LOCAL_APIC */
+
+# ifndef CONFIG_SMP
+#  define hard_smp_processor_id()	0
+# endif
+
+#endif /* CONFIG_X86_LOCAL_APIC */
+
 #ifdef CONFIG_HOTPLUG_CPU
 extern void cpu_exit_clear(void);
 extern void cpu_uninit(void);
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index cb3ada2..53432db 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -42,32 +42,5 @@ static inline int num_booting_cpus(void)
 #define safe_smp_processor_id()		0
 #endif /* !CONFIG_SMP */
 
-#ifdef CONFIG_X86_LOCAL_APIC
-
-static inline int logical_smp_processor_id(void)
-{
-	/* we don't want to mark this access volatile - bad code generation */
-	return GET_APIC_LOGICAL_ID(*(u32 *)(APIC_BASE + APIC_LDR));
-}
-
-# ifdef APIC_DEFINITION
-extern int hard_smp_processor_id(void);
-# else
-#  include <mach_apicdef.h>
-static inline int hard_smp_processor_id(void)
-{
-	/* we don't want to mark this access volatile - bad code generation */
-	return GET_APIC_ID(*(u32 *)(APIC_BASE + APIC_ID));
-}
-# endif /* APIC_DEFINITION */
-
-#else /* CONFIG_X86_LOCAL_APIC */
-
-# ifndef CONFIG_SMP
-#  define hard_smp_processor_id()	0
-# endif
-
-#endif /* CONFIG_X86_LOCAL_APIC */
-
 #endif /* !ASSEMBLY */
 #endif
diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index c46585e..015d36e 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -46,32 +46,5 @@ static inline int num_booting_cpus(void)
 
 #define safe_smp_processor_id()		smp_processor_id()
 
-#ifdef CONFIG_X86_LOCAL_APIC
-
-static inline int logical_smp_processor_id(void)
-{
-	/* we don't want to mark this access volatile - bad code generation */
-	return GET_APIC_LOGICAL_ID(*(u32 *)(APIC_BASE + APIC_LDR));
-}
-
-# ifdef APIC_DEFINITION
-extern int hard_smp_processor_id(void);
-# else
-#  include <mach_apicdef.h>
-static inline int hard_smp_processor_id(void)
-{
-	/* we don't want to mark this access volatile - bad code generation */
-	return GET_APIC_ID(*(u32 *)(APIC_BASE + APIC_ID));
-}
-# endif /* APIC_DEFINITION */
-
-#else /* CONFIG_X86_LOCAL_APIC */
-
-# ifndef CONFIG_SMP
-#  define hard_smp_processor_id()	0
-# endif
-
-#endif /* CONFIG_X86_LOCAL_APIC */
-
 #endif
 
-- 
1.5.0.6

