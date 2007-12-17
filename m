Return-Path: <linux-kernel-owner+w=401wt.eu-S1764852AbXLRBi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764852AbXLRBi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760318AbXLRBgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:36:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760156AbXLRBgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:36:52 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 6/21] [PATCH] move the definition of set_iopl_mask to common header
Date: Mon, 17 Dec 2007 20:52:29 -0200
Message-Id: <11979319953427-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11979319903443-git-send-email-gcosta@redhat.com>
References: <11979319641796-git-send-email-gcosta@redhat.com> <1197931971748-git-send-email-gcosta@redhat.com> <11979319763641-git-send-email-gcosta@redhat.com> <11979319811234-git-send-email-gcosta@redhat.com> <11979319853319-git-send-email-gcosta@redhat.com> <11979319903443-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the definition of set_iopl_mask to processor.h,
instead of letting it at processor_32.h.
For x86_64, nothing is done, as we don't really need such a function.
However, having it on both arches saves us from putting an ifdef in the
pv_cpu_ops struct.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/processor.h    |   19 +++++++++++++++++++
 include/asm-x86/processor_32.h |   17 -----------------
 2 files changed, 19 insertions(+), 17 deletions(-)

Index: linux-2.6-x86/include/asm-x86/processor.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor.h
+++ linux-2.6-x86/include/asm-x86/processor.h
@@ -78,6 +78,24 @@ static inline void native_set_debugreg(i
 	}
 }
 
+/*
+ * Set IOPL bits in EFLAGS from given mask
+ */
+static inline void native_set_iopl_mask(unsigned mask)
+{
+#ifdef CONFIG_X86_32
+	unsigned int reg;
+	__asm__ __volatile__ ("pushfl;"
+			      "popl %0;"
+			      "andl %1, %0;"
+			      "orl %2, %0;"
+			      "pushl %0;"
+			      "popfl"
+				: "=&r" (reg)
+				: "i" (~X86_EFLAGS_IOPL), "r" (mask));
+#endif
+}
+
 
 #ifndef CONFIG_PARAVIRT
 #define __cpuid native_cpuid
@@ -91,6 +109,7 @@ static inline void native_set_debugreg(i
 #define set_debugreg(value, register)				\
 	native_set_debugreg(register, value)
 
+#define set_iopl_mask native_set_iopl_mask
 #endif /* CONFIG_PARAVIRT */
 
 /*
Index: linux-2.6-x86/include/asm-x86/processor_32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_32.h
+++ linux-2.6-x86/include/asm-x86/processor_32.h
@@ -455,21 +455,6 @@ static inline void native_load_sp0(struc
 		wrmsr(MSR_IA32_SYSENTER_CS, thread->sysenter_cs, 0);
 	}
 }
-/*
- * Set IOPL bits in EFLAGS from given mask
- */
-static inline void native_set_iopl_mask(unsigned mask)
-{
-	unsigned int reg;
-	__asm__ __volatile__ ("pushfl;"
-			      "popl %0;"
-			      "andl %1, %0;"
-			      "orl %2, %0;"
-			      "pushl %0;"
-			      "popfl"
-				: "=&r" (reg)
-				: "i" (~X86_EFLAGS_IOPL), "r" (mask));
-}
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
@@ -479,8 +464,6 @@ static inline void load_sp0(struct tss_s
 {
 	native_load_sp0(tss, thread);
 }
-
-#define set_iopl_mask native_set_iopl_mask
 #endif /* CONFIG_PARAVIRT */
 
 /* generic versions from gas */
