Return-Path: <linux-kernel-owner+w=401wt.eu-S1763067AbXLRBiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763067AbXLRBiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758103AbXLRBgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:36:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757962AbXLRBgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:36:39 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 4/21] [PATCH] move load_cr3 to a common place.
Date: Mon, 17 Dec 2007 20:52:27 -0200
Message-Id: <11979319853319-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11979319811234-git-send-email-gcosta@redhat.com>
References: <11979319641796-git-send-email-gcosta@redhat.com> <1197931971748-git-send-email-gcosta@redhat.com> <11979319763641-git-send-email-gcosta@redhat.com> <11979319811234-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are currently two definitions of load_cr3, that essentially do the
same thing. This patch moves them all to processor.h.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/mmu_context_64.h |    5 -----
 include/asm-x86/processor.h      |    7 +++++++
 include/asm-x86/processor_32.h   |    1 -
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/asm-x86/mmu_context_64.h b/include/asm-x86/mmu_context_64.h
index 98bfe43..7e2aa23 100644
--- a/include/asm-x86/mmu_context_64.h
+++ b/include/asm-x86/mmu_context_64.h
@@ -23,11 +23,6 @@ static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 #endif
 }
 
-static inline void load_cr3(pgd_t *pgd)
-{
-	asm volatile("movq %0,%%cr3" :: "r" (__pa(pgd)) : "memory");
-}
-
 static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next, 
 			     struct task_struct *tsk)
 {
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index e8dd394..36ee988 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -3,6 +3,9 @@
 
 #include <asm/processor-flags.h>
 
+#include <asm/page.h>
+#include <asm/system.h>
+
 static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
 					 unsigned int *ecx, unsigned int *edx)
 {
@@ -15,6 +18,10 @@ static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
 		: "0" (*eax), "2" (*ecx));
 }
 
+static inline void load_cr3(pgd_t *pgdir)
+{
+	write_cr3(__pa(pgdir));
+}
 
 #ifdef CONFIG_X86_32
 # include "processor_32.h"
diff --git a/include/asm-x86/processor_32.h b/include/asm-x86/processor_32.h
index cadeffb..b586902 100644
--- a/include/asm-x86/processor_32.h
+++ b/include/asm-x86/processor_32.h
@@ -120,7 +120,6 @@ extern void detect_ht(struct cpuinfo_x86 *c);
 static inline void detect_ht(struct cpuinfo_x86 *c) {}
 #endif
 
-#define load_cr3(pgdir) write_cr3(__pa(pgdir))
 
 /*
  * Save the cr4 feature set we're using (ie
-- 
1.4.4.2

