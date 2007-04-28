Return-Path: <linux-kernel-owner+w=401wt.eu-S1163362AbXD1SAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163362AbXD1SAw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163338AbXD1R7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:59:18 -0400
Received: from ns2.suse.de ([195.135.220.15]:38952 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163313AbXD1R6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:58:55 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428758.455116000@suse.de>
In-Reply-To: <20070428758.455116000@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [8/22] x86_64: Add EFER to the register set saved by save_processor_state
Message-Id: <20070428175855.0F7E9151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:58:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Vivek Goyal <vgoyal@in.ibm.com>


EFER varies like %cr4 depending on the cpu capabilities, and which cpu
capabilities we want to make use of.  So save/restore it make certain
we have the same EFER value when we are done.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/suspend.c |    3 ++-
 include/asm-x86_64/suspend.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux/arch/x86_64/kernel/suspend.c
===================================================================
--- linux.orig/arch/x86_64/kernel/suspend.c
+++ linux/arch/x86_64/kernel/suspend.c
@@ -33,7 +33,6 @@ void __save_processor_state(struct saved
 	asm volatile ("str %0"  : "=m" (ctxt->tr));
 
 	/* XMM0..XMM15 should be handled by kernel_fpu_begin(). */
-	/* EFER should be constant for kernel version, no need to handle it. */
 	/*
 	 * segment registers
 	 */
@@ -50,6 +49,7 @@ void __save_processor_state(struct saved
 	/*
 	 * control registers 
 	 */
+	rdmsrl(MSR_EFER, ctxt->efer);
 	asm volatile ("movq %%cr0, %0" : "=r" (ctxt->cr0));
 	asm volatile ("movq %%cr2, %0" : "=r" (ctxt->cr2));
 	asm volatile ("movq %%cr3, %0" : "=r" (ctxt->cr3));
@@ -75,6 +75,7 @@ void __restore_processor_state(struct sa
 	/*
 	 * control registers
 	 */
+	wrmsrl(MSR_EFER, ctxt->efer);
 	asm volatile ("movq %0, %%cr8" :: "r" (ctxt->cr8));
 	asm volatile ("movq %0, %%cr4" :: "r" (ctxt->cr4));
 	asm volatile ("movq %0, %%cr3" :: "r" (ctxt->cr3));
Index: linux/include/asm-x86_64/suspend.h
===================================================================
--- linux.orig/include/asm-x86_64/suspend.h
+++ linux/include/asm-x86_64/suspend.h
@@ -17,6 +17,7 @@ struct saved_context {
   	u16 ds, es, fs, gs, ss;
 	unsigned long gs_base, gs_kernel_base, fs_base;
 	unsigned long cr0, cr2, cr3, cr4, cr8;
+	unsigned long efer;
 	u16 gdt_pad;
 	u16 gdt_limit;
 	unsigned long gdt_base;
