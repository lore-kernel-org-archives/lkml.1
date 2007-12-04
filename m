Return-Path: <linux-kernel-owner+w=401wt.eu-S1751689AbXLDSuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbXLDSuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 13:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbXLDSse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 13:48:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbXLDSsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 13:48:33 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 5/10] unify cpuid functions
Date: Tue,  4 Dec 2007 14:03:55 -0200
Message-Id: <119678426719-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11967842622658-git-send-email-gcosta@redhat.com>
References: 20071204140939.GA16328@elte.hu <11967842402729-git-send-email-gcosta@redhat.com> <11967842482873-git-send-email-gcosta@redhat.com> <11967842531735-git-send-email-gcosta@redhat.com> <11967842573035-git-send-email-gcosta@redhat.com> <11967842622658-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuid is not very different between i386 and x86_64.
We move away the x86_64 version from msr.h, and
unify them at processor.h, where they belong.

cpuid() paravirt then comes for free.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/msr.h          |   67 ----------------------------------
 include/asm-x86/processor.h    |   78 ++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/processor_32.h |   69 -----------------------------------
 3 files changed, 78 insertions(+), 136 deletions(-)

diff --git a/include/asm-x86/msr.h b/include/asm-x86/msr.h
index b3cd509..5fa30bd 100644
--- a/include/asm-x86/msr.h
+++ b/include/asm-x86/msr.h
@@ -230,73 +230,6 @@ static inline int wrmsr_safe(u32 __msr, u32 __low, u32 __high)
 			  : "=a" (low), "=d" (high) \
 			  : "c" (counter))
 
-static inline void cpuid(int op, unsigned int *eax, unsigned int *ebx,
-			 unsigned int *ecx, unsigned int *edx)
-{
-	__asm__("cpuid"
-		: "=a" (*eax),
-		  "=b" (*ebx),
-		  "=c" (*ecx),
-		  "=d" (*edx)
-		: "0" (op));
-}
-
-/* Some CPUID calls want 'count' to be placed in ecx */
-static inline void cpuid_count(int op, int count, int *eax, int *ebx, int *ecx,
-			       int *edx)
-{
-	__asm__("cpuid"
-		: "=a" (*eax),
-		  "=b" (*ebx),
-		  "=c" (*ecx),
-		  "=d" (*edx)
-		: "0" (op), "c" (count));
-}
-
-/*
- * CPUID functions returning a single datum
- */
-static inline unsigned int cpuid_eax(unsigned int op)
-{
-	unsigned int eax;
-
-	__asm__("cpuid"
-		: "=a" (eax)
-		: "0" (op)
-		: "bx", "cx", "dx");
-	return eax;
-}
-static inline unsigned int cpuid_ebx(unsigned int op)
-{
-	unsigned int eax, ebx;
-
-	__asm__("cpuid"
-		: "=a" (eax), "=b" (ebx)
-		: "0" (op)
-		: "cx", "dx" );
-	return ebx;
-}
-static inline unsigned int cpuid_ecx(unsigned int op)
-{
-	unsigned int eax, ecx;
-
-	__asm__("cpuid"
-		: "=a" (eax), "=c" (ecx)
-		: "0" (op)
-		: "bx", "dx" );
-	return ecx;
-}
-static inline unsigned int cpuid_edx(unsigned int op)
-{
-	unsigned int eax, edx;
-
-	__asm__("cpuid"
-		: "=a" (eax), "=d" (edx)
-		: "0" (op)
-		: "bx", "cx");
-	return edx;
-}
-
 #endif  /* __ASSEMBLY__ */
 
 #endif  /* !__i386__ */
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 46e1c04..dea81b7 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -1,5 +1,83 @@
+#ifndef __ASM_X86_PROCESSOR_H
+#define __ASM_X86_PROCESSOR_H
+
+static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
+					 unsigned int *ecx, unsigned int *edx)
+{
+	/* ecx is often an input as well as an output. */
+	__asm__("cpuid"
+		: "=a" (*eax),
+		  "=b" (*ebx),
+		  "=c" (*ecx),
+		  "=d" (*edx)
+		: "0" (*eax), "2" (*ecx));
+}
+
+
 #ifdef CONFIG_X86_32
 # include "processor_32.h"
 #else
 # include "processor_64.h"
 #endif
+
+#ifndef CONFIG_PARAVIRT
+#define __cpuid native_cpuid
+#endif
+
+/*
+ * Generic CPUID function
+ * clear %ecx since some cpus (Cyrix MII) do not set or clear %ecx
+ * resulting in stale register contents being returned.
+ */
+static inline void cpuid(unsigned int op,
+			 unsigned int *eax, unsigned int *ebx,
+			 unsigned int *ecx, unsigned int *edx)
+{
+	*eax = op;
+	*ecx = 0;
+	__cpuid(eax, ebx, ecx, edx);
+}
+
+/* Some CPUID calls want 'count' to be placed in ecx */
+static inline void cpuid_count(unsigned int op, int count,
+			       unsigned int *eax, unsigned int *ebx,
+			       unsigned int *ecx, unsigned int *edx)
+{
+	*eax = op;
+	*ecx = count;
+	__cpuid(eax, ebx, ecx, edx);
+}
+
+/*
+ * CPUID functions returning a single datum
+ */
+static inline unsigned int cpuid_eax(unsigned int op)
+{
+	unsigned int eax, ebx, ecx, edx;
+
+	cpuid(op, &eax, &ebx, &ecx, &edx);
+	return eax;
+}
+static inline unsigned int cpuid_ebx(unsigned int op)
+{
+	unsigned int eax, ebx, ecx, edx;
+
+	cpuid(op, &eax, &ebx, &ecx, &edx);
+	return ebx;
+}
+static inline unsigned int cpuid_ecx(unsigned int op)
+{
+	unsigned int eax, ebx, ecx, edx;
+
+	cpuid(op, &eax, &ebx, &ecx, &edx);
+	return ecx;
+}
+static inline unsigned int cpuid_edx(unsigned int op)
+{
+	unsigned int eax, ebx, ecx, edx;
+
+	cpuid(op, &eax, &ebx, &ecx, &edx);
+	return edx;
+}
+
+#endif
diff --git a/include/asm-x86/processor_32.h b/include/asm-x86/processor_32.h
index 13976b0..12a4f83 100644
--- a/include/asm-x86/processor_32.h
+++ b/include/asm-x86/processor_32.h
@@ -134,18 +134,6 @@ extern void detect_ht(struct cpuinfo_x86 *c);
 static inline void detect_ht(struct cpuinfo_x86 *c) {}
 #endif
 
-static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
-					 unsigned int *ecx, unsigned int *edx)
-{
-	/* ecx is often an input as well as an output. */
-	__asm__("cpuid"
-		: "=a" (*eax),
-		  "=b" (*ebx),
-		  "=c" (*ecx),
-		  "=d" (*edx)
-		: "0" (*eax), "2" (*ecx));
-}
-
 #define load_cr3(pgdir) write_cr3(__pa(pgdir))
 
 /*
@@ -578,7 +566,6 @@ static inline void native_set_iopl_mask(unsigned mask)
 #include <asm/paravirt.h>
 #else
 #define paravirt_enabled() 0
-#define __cpuid native_cpuid
 
 static inline void load_esp0(struct tss_struct *tss, struct thread_struct *thread)
 {
@@ -596,62 +583,6 @@ static inline void load_esp0(struct tss_struct *tss, struct thread_struct *threa
 #define set_iopl_mask native_set_iopl_mask
 #endif /* CONFIG_PARAVIRT */
 
-/*
- * Generic CPUID function
- * clear %ecx since some cpus (Cyrix MII) do not set or clear %ecx
- * resulting in stale register contents being returned.
- */
-static inline void cpuid(unsigned int op,
-			 unsigned int *eax, unsigned int *ebx,
-			 unsigned int *ecx, unsigned int *edx)
-{
-	*eax = op;
-	*ecx = 0;
-	__cpuid(eax, ebx, ecx, edx);
-}
-
-/* Some CPUID calls want 'count' to be placed in ecx */
-static inline void cpuid_count(unsigned int op, int count,
-			       unsigned int *eax, unsigned int *ebx,
-			       unsigned int *ecx, unsigned int *edx)
-{
-	*eax = op;
-	*ecx = count;
-	__cpuid(eax, ebx, ecx, edx);
-}
-
-/*
- * CPUID functions returning a single datum
- */
-static inline unsigned int cpuid_eax(unsigned int op)
-{
-	unsigned int eax, ebx, ecx, edx;
-
-	cpuid(op, &eax, &ebx, &ecx, &edx);
-	return eax;
-}
-static inline unsigned int cpuid_ebx(unsigned int op)
-{
-	unsigned int eax, ebx, ecx, edx;
-
-	cpuid(op, &eax, &ebx, &ecx, &edx);
-	return ebx;
-}
-static inline unsigned int cpuid_ecx(unsigned int op)
-{
-	unsigned int eax, ebx, ecx, edx;
-
-	cpuid(op, &eax, &ebx, &ecx, &edx);
-	return ecx;
-}
-static inline unsigned int cpuid_edx(unsigned int op)
-{
-	unsigned int eax, ebx, ecx, edx;
-
-	cpuid(op, &eax, &ebx, &ecx, &edx);
-	return edx;
-}
-
 /* generic versions from gas */
 #define GENERIC_NOP1	".byte 0x90\n"
 #define GENERIC_NOP2    	".byte 0x89,0xf6\n"
-- 
1.4.4.2

