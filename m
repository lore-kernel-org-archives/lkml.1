Return-Path: <linux-kernel-owner+w=401wt.eu-S936767AbXLRBm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936767AbXLRBm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762425AbXLRBiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:38:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664AbXLRBh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:37:59 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 12/21] [PATCH] unify TASK_ALIGN definitions
Date: Mon, 17 Dec 2007 20:52:35 -0200
Message-Id: <11979320252102-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11979320211287-git-send-email-gcosta@redhat.com>
References: <11979319641796-git-send-email-gcosta@redhat.com> <1197931971748-git-send-email-gcosta@redhat.com> <11979319763641-git-send-email-gcosta@redhat.com> <11979319811234-git-send-email-gcosta@redhat.com> <11979319853319-git-send-email-gcosta@redhat.com> <11979319903443-git-send-email-gcosta@redhat.com> <11979319953427-git-send-email-gcosta@redhat.com> <11979320011968-git-send-email-gcosta@redhat.com> <1197932006634-git-send-email-gcosta@redhat.com> <11979320114180-git-send-email-gcosta@redhat.com> <11979320163651-git-send-email-gcosta@redhat.com> <11979320211287-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the TASK_ALIGN constraints to common header.
The base of it is the same for x86_64 and i386. The only difference
is the presence of vSMP in x86_64. As it's not a worry in i386, we can
safely use the same code for both.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/processor.h    |    8 ++++++++
 include/asm-x86/processor_32.h |    1 -
 include/asm-x86/processor_64.h |    8 --------
 3 files changed, 8 insertions(+), 9 deletions(-)

Index: linux-2.6-x86/include/asm-x86/processor.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor.h
+++ linux-2.6-x86/include/asm-x86/processor.h
@@ -18,6 +18,14 @@ static inline void *current_text_addr(vo
 	return pc;
 }
 
+#ifdef CONFIG_X86_VSMP
+#define ARCH_MIN_TASKALIGN	(1 << INTERNODE_CACHE_SHIFT)
+#define ARCH_MIN_MMSTRUCT_ALIGN	(1 << INTERNODE_CACHE_SHIFT)
+#else
+#define ARCH_MIN_TASKALIGN	16
+#define ARCH_MIN_MMSTRUCT_ALIGN	0
+#endif
+
 static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
 					 unsigned int *ecx, unsigned int *edx)
 {
Index: linux-2.6-x86/include/asm-x86/processor_32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_32.h
+++ linux-2.6-x86/include/asm-x86/processor_32.h
@@ -174,7 +174,6 @@ typedef struct {
 	unsigned long seg;
 } mm_segment_t;
 
-#define ARCH_MIN_TASKALIGN	16
 
 #define INIT_THREAD  {							\
 	.sp0 = sizeof(init_stack) + (long)&init_stack,			\
Index: linux-2.6-x86/include/asm-x86/processor_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_64.h
+++ linux-2.6-x86/include/asm-x86/processor_64.h
@@ -117,14 +117,6 @@ struct orig_ist {
 };
 DECLARE_PER_CPU(struct orig_ist, orig_ist);
 
-#ifdef CONFIG_X86_VSMP
-#define ARCH_MIN_TASKALIGN	(1 << INTERNODE_CACHE_SHIFT)
-#define ARCH_MIN_MMSTRUCT_ALIGN	(1 << INTERNODE_CACHE_SHIFT)
-#else
-#define ARCH_MIN_TASKALIGN	16
-#define ARCH_MIN_MMSTRUCT_ALIGN	0
-#endif
-
 #define INIT_THREAD  { \
 	.sp0 = (unsigned long)&init_stack + sizeof(init_stack) \
 }
