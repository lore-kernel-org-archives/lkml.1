Return-Path: <linux-kernel-owner+w=401wt.eu-S937640AbXLRBpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937640AbXLRBpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763305AbXLRBib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:38:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763266AbXLRBi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:38:29 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 18/21] [PATCH] unify prefetch operations
Date: Mon, 17 Dec 2007 20:52:41 -0200
Message-Id: <11979320551036-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1197932050948-git-send-email-gcosta@redhat.com>
References: <11979319641796-git-send-email-gcosta@redhat.com> <1197931971748-git-send-email-gcosta@redhat.com> <11979319763641-git-send-email-gcosta@redhat.com> <11979319811234-git-send-email-gcosta@redhat.com> <11979319853319-git-send-email-gcosta@redhat.com> <11979319903443-git-send-email-gcosta@redhat.com> <11979319953427-git-send-email-gcosta@redhat.com> <11979320011968-git-send-email-gcosta@redhat.com> <1197932006634-git-send-email-gcosta@redhat.com> <11979320114180-git-send-email-gcosta@redhat.com> <11979320163651-git-send-email-gcosta@redhat.com> <11979320211287-git-send-email-gcosta@redhat.com> <11979320252102-git-send-email-gcosta@redhat.com> <11979320302030-git-send-email-gcosta@redhat.com> <11979320354186-git-send-email-gcosta@redhat.com> <11979320401316-git-send-email-gcosta@redhat.com> <11979320451308-git-send-email-gcosta@redhat.com> <1197932050948-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the prefetch[w]? functions to processor.h

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/processor.h    |   30 ++++++++++++++++++++++++++++++
 include/asm-x86/processor_32.h |   25 -------------------------
 include/asm-x86/processor_64.h |    8 --------
 3 files changed, 30 insertions(+), 33 deletions(-)

Index: linux-2.6-x86/include/asm-x86/processor.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor.h
+++ linux-2.6-x86/include/asm-x86/processor.h
@@ -592,6 +592,36 @@ extern char ignore_fpu_irq;
 #define ARCH_HAS_PREFETCHW
 #define ARCH_HAS_SPINLOCK_PREFETCH
 
+#ifdef CONFIG_X86_32
+#define BASE_PREFETCH	ASM_NOP4
+#define ARCH_HAS_PREFETCH
+#else
+#define BASE_PREFETCH	"prefetcht0 (%1)"
+#endif
+
+/* Prefetch instructions for Pentium III and AMD Athlon */
+/* It's not worth to care about 3dnow! prefetches for the K6
+   because they are microcoded there and very slow.
+   However we don't do prefetches for pre XP Athlons currently
+   That should be fixed. */
+static inline void prefetch(const void *x)
+{
+	alternative_input(BASE_PREFETCH,
+			  "prefetchnta (%1)",
+			  X86_FEATURE_XMM,
+			  "r" (x));
+}
+
+/* 3dnow! prefetch to get an exclusive cache line. Useful for
+   spinlocks to avoid one state transition in the cache coherency protocol. */
+static inline void prefetchw(const void *x)
+{
+	alternative_input(BASE_PREFETCH,
+			  "prefetchw (%1)",
+			  X86_FEATURE_3DNOW,
+			  "r" (x));
+}
+
 #define spin_lock_prefetch(x)	prefetchw(x)
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
Index: linux-2.6-x86/include/asm-x86/processor_32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_32.h
+++ linux-2.6-x86/include/asm-x86/processor_32.h
@@ -228,29 +228,4 @@ extern unsigned long thread_saved_pc(str
 
 #define ASM_NOP_MAX 8
 
-/* Prefetch instructions for Pentium III and AMD Athlon */
-/* It's not worth to care about 3dnow! prefetches for the K6
-   because they are microcoded there and very slow.
-   However we don't do prefetches for pre XP Athlons currently
-   That should be fixed. */
-static inline void prefetch(const void *x)
-{
-	alternative_input(ASM_NOP4,
-			  "prefetchnta (%1)",
-			  X86_FEATURE_XMM,
-			  "r" (x));
-}
-
-#define ARCH_HAS_PREFETCH
-
-/* 3dnow! prefetch to get an exclusive cache line. Useful for 
-   spinlocks to avoid one state transition in the cache coherency protocol. */
-static inline void prefetchw(const void *x)
-{
-	alternative_input(ASM_NOP4,
-			  "prefetchw (%1)",
-			  X86_FEATURE_3DNOW,
-			  "r" (x));
-}
-
 #endif /* __ASM_I386_PROCESSOR_H */
Index: linux-2.6-x86/include/asm-x86/processor_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_64.h
+++ linux-2.6-x86/include/asm-x86/processor_64.h
@@ -124,12 +124,4 @@ DECLARE_PER_CPU(struct orig_ist, orig_is
 
 #define ASM_NOP_MAX 8
 
-static inline void prefetchw(void *x) 
-{ 
-	alternative_input("prefetcht0 (%1)",
-			  "prefetchw (%1)",
-			  X86_FEATURE_3DNOW,
-			  "r" (x));
-} 
-
 #endif /* __ASM_X86_64_PROCESSOR_H */
