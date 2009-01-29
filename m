Return-Path: <linux-kernel-owner+w=401wt.eu-S1756410AbZA2Ib6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410AbZA2Ib6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 03:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757968AbZA2Ibb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 03:31:31 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:37916 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757939AbZA2Ib3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 03:31:29 -0500
Date: Thu, 29 Jan 2009 14:01:23 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       mingo@elte.hu, richardj_moore@uk.ibm.com, jason.wessel@windriver.com
Subject: [Patch 9/10] Cleanup HW Breakpoint registers before kexec
Message-ID: <20090129083123.GF7750@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090129074845.GA5078@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129074845.GA5078@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch disables Hardware breakpoints before doing a 'kexec' on the machine.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/machine_kexec_32.c |    2 ++
 arch/x86/kernel/machine_kexec_64.c |    2 ++
 2 files changed, 4 insertions(+)

Index: linux-hbkpt-lkml-29-rc2/arch/x86/kernel/machine_kexec_32.c
===================================================================
--- linux-hbkpt-lkml-29-rc2.orig/arch/x86/kernel/machine_kexec_32.c
+++ linux-hbkpt-lkml-29-rc2/arch/x86/kernel/machine_kexec_32.c
@@ -25,6 +25,7 @@
 #include <asm/desc.h>
 #include <asm/system.h>
 #include <asm/cacheflush.h>
+#include <asm/debugreg.h>
 
 static void set_idt(void *newidt, __u16 limit)
 {
@@ -202,6 +203,7 @@ void machine_kexec(struct kimage *image)
 
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
+	disable_debug_registers();
 
 	if (image->preserve_context) {
 #ifdef CONFIG_X86_IO_APIC
Index: linux-hbkpt-lkml-29-rc2/arch/x86/kernel/machine_kexec_64.c
===================================================================
--- linux-hbkpt-lkml-29-rc2.orig/arch/x86/kernel/machine_kexec_64.c
+++ linux-hbkpt-lkml-29-rc2/arch/x86/kernel/machine_kexec_64.c
@@ -17,6 +17,7 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
+#include <asm/debugreg.h>
 
 #define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
 static u64 kexec_pgd[512] PAGE_ALIGNED;
@@ -190,6 +191,7 @@ void machine_kexec(struct kimage *image)
 
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
+	disable_debug_registers();
 
 	control_page = page_address(image->control_code_page) + PAGE_SIZE;
 	memcpy(control_page, relocate_kernel, PAGE_SIZE);
