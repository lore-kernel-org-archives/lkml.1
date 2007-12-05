Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbXLERyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbXLERyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 12:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbXLERxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 12:53:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbXLERx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 12:53:28 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 4/9] remove references to cr8 register
Date: Wed,  5 Dec 2007 13:08:28 -0200
Message-Id: <1196867333728-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11968673291072-git-send-email-gcosta@redhat.com>
References: 20071204204931.GC32018@elte.hu <1196867313972-git-send-email-gcosta@redhat.com> <1196867319253-git-send-email-gcosta@redhat.com> <11968673241599-git-send-email-gcosta@redhat.com> <11968673291072-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by Andi, linux never really uses this register
so saving and restoring is not really necessary. This patch
removes all references to it.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/asm-offsets_64.c |    1 -
 arch/x86/kernel/suspend_64.c     |    2 --
 include/asm-x86/suspend_64.h     |    2 +-
 include/asm-x86/system_64.h      |   12 ------------
 4 files changed, 1 insertions(+), 16 deletions(-)

Index: linux-2.6-x86/arch/x86/kernel/asm-offsets_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/asm-offsets_64.c
+++ linux-2.6-x86/arch/x86/kernel/asm-offsets_64.c
@@ -107,7 +107,6 @@ int main(void)
 	ENTRY(cr2);
 	ENTRY(cr3);
 	ENTRY(cr4);
-	ENTRY(cr8);
 	BLANK();
 #undef ENTRY
 	DEFINE(TSS_ist, offsetof(struct tss_struct, ist));
Index: linux-2.6-x86/arch/x86/kernel/suspend_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/suspend_64.c
+++ linux-2.6-x86/arch/x86/kernel/suspend_64.c
@@ -53,7 +53,6 @@ void __save_processor_state(struct saved
 	ctxt->cr2 = read_cr2();
 	ctxt->cr3 = read_cr3();
 	ctxt->cr4 = read_cr4();
-	ctxt->cr8 = read_cr8();
 }
 
 void save_processor_state(void)
@@ -75,7 +74,6 @@ void __restore_processor_state(struct sa
 	 * control registers
 	 */
 	wrmsrl(MSR_EFER, ctxt->efer);
-	write_cr8(ctxt->cr8);
 	write_cr4(ctxt->cr4);
 	write_cr3(ctxt->cr3);
 	write_cr2(ctxt->cr2);
Index: linux-2.6-x86/include/asm-x86/suspend_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/suspend_64.h
+++ linux-2.6-x86/include/asm-x86/suspend_64.h
@@ -20,7 +20,7 @@ struct saved_context {
 	struct pt_regs regs;
   	u16 ds, es, fs, gs, ss;
 	unsigned long gs_base, gs_kernel_base, fs_base;
-	unsigned long cr0, cr2, cr3, cr4, cr8;
+	unsigned long cr0, cr2, cr3, cr4;
 	unsigned long efer;
 	u16 gdt_pad;
 	u16 gdt_limit;
Index: linux-2.6-x86/include/asm-x86/system_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/system_64.h
+++ linux-2.6-x86/include/asm-x86/system_64.h
@@ -95,18 +95,6 @@ static inline void write_cr4(unsigned lo
 	asm volatile("movq %0,%%cr4" :: "r" (val) : "memory");
 }
 
-static inline unsigned long read_cr8(void)
-{
-	unsigned long cr8;
-	asm volatile("movq %%cr8,%0" : "=r" (cr8));
-	return cr8;
-}
-
-static inline void write_cr8(unsigned long val)
-{
-	asm volatile("movq %0,%%cr8" :: "r" (val) : "memory");
-}
-
 #define stts() write_cr0(8 | read_cr0())
 
 #define wbinvd() \
