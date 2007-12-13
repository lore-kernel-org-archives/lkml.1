Return-Path: <linux-kernel-owner+w=401wt.eu-S1759977AbXLMEtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977AbXLMEtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 23:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758814AbXLMErI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 23:47:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758824AbXLMErG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 23:47:06 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 16/19] modify get_desc_base
Date: Thu, 13 Dec 2007 00:01:49 -0200
Message-Id: <11975113923422-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11975113873364-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11975113122984-git-send-email-gcosta@redhat.com> <11975113194101-git-send-email-gcosta@redhat.com> <11975113243875-git-send-email-gcosta@redhat.com> <11975113291722-git-send-email-gcosta@redhat.com> <1197511334416-git-send-email-gcosta@redhat.com> <1197511338810-git-send-email-gcosta@redhat.com> <1197511343355-git-send-email-gcosta@redhat.com> <11975113484194-git-send-email-gcosta@redhat.com> <11975113532186-git-send-email-gcosta@redhat.com> <11975113583644-git-send-email-gcosta@redhat.com> <1197511363887-git-send-email-gcosta@redhat.com> <11975113672937-git-send-email-gcosta@redhat.com> <11975113721808-git-send-email-gcosta@redhat.com> <11975113771692-git-send-email-gcosta@redhat.com> <11975113821418-git-send-email-gcosta@redhat.com> <11975113873364-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes get_desc_base() receive a struct desc_struct,
and then uses its internal fields to compute the base address.
This is done at both i386 and x86_64, and then it is moved
to common header

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/tls.c  |    2 +-
 arch/x86/mm/fault_32.c |    2 +-
 include/asm-x86/desc.h |    8 ++------
 3 files changed, 4 insertions(+), 8 deletions(-)

Index: linux-2.6-x86/arch/x86/kernel/tls.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/tls.c
+++ linux-2.6-x86/arch/x86/kernel/tls.c
@@ -112,7 +112,7 @@ int do_get_thread_area(struct task_struc
 
 	memset(&info, 0, sizeof(struct user_desc));
 	info.entry_number = idx;
-	info.base_addr = get_desc_base((void *)desc);
+	info.base_addr = get_desc_base((struct desc_struct *)desc);
 	info.limit = GET_LIMIT(desc);
 	info.seg_32bit = GET_32BIT(desc);
 	info.contents = GET_CONTENTS(desc);
Index: linux-2.6-x86/arch/x86/mm/fault_32.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/mm/fault_32.c
+++ linux-2.6-x86/arch/x86/mm/fault_32.c
@@ -115,7 +115,7 @@ static inline unsigned long get_segment_
 	}
 
 	/* Decode the code segment base from the descriptor */
-	base = get_desc_base((unsigned long *)desc);
+	base = get_desc_base((struct desc_struct *)desc);
 
 	if (seg & (1<<2)) { 
 		mutex_unlock(&current->mm->context.lock);
Index: linux-2.6-x86/include/asm-x86/desc.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/desc.h
+++ linux-2.6-x86/include/asm-x86/desc.h
@@ -69,6 +69,11 @@ static inline void load_LDT(mm_context_t
 	preempt_enable();
 }
 
+static inline unsigned long get_desc_base(struct desc_struct *desc)
+{
+	return desc->base0 | ((desc->base1) << 16) | ((desc->base2) << 24);
+}
+
 #else
 /*
  * GET_DESC_BASE reads the descriptor base of the specified segment.
Index: linux-2.6-x86/include/asm-x86/desc_32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/desc_32.h
+++ linux-2.6-x86/include/asm-x86/desc_32.h
@@ -168,14 +168,6 @@ static inline void __set_tss_desc(unsign
 
 #define set_tss_desc(cpu,addr) __set_tss_desc(cpu, GDT_ENTRY_TSS, addr)
 
-static inline unsigned long get_desc_base(unsigned long *desc)
-{
-	unsigned long base;
-	base = ((desc[0] >> 16)  & 0x0000ffff) |
-		((desc[1] << 16) & 0x00ff0000) |
-		(desc[1] & 0xff000000);
-	return base;
-}
 #endif /* !__ASSEMBLY__ */
 
 #endif
Index: linux-2.6-x86/include/asm-x86/desc_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/desc_64.h
+++ linux-2.6-x86/include/asm-x86/desc_64.h
@@ -156,15 +156,6 @@ static inline void load_TLS(struct threa
 		gdt[i] = t->tls_array[i];
 }
 
-static inline unsigned long get_desc_base(const void *ptr)
-{
-	const u32 *desc = ptr;
-	unsigned long base;
-	base = ((desc[0] >> 16)  & 0x0000ffff) |
-		((desc[1] << 16) & 0x00ff0000) |
-		(desc[1] & 0xff000000);
-	return base;
-}
 #endif /* !__ASSEMBLY__ */
 
 #endif
