Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZBOKgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZBOKgl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 05:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbZBOKf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 05:35:58 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:33394 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbZBOKf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 05:35:57 -0500
Date: Sun, 15 Feb 2009 16:05:46 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>, richardj_moore@uk.ibm.com,
       jason.wessel@windriver.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [Patch 9/10] Cleanup HW Breakpoint registers before kexec
Message-ID: <20090215103546.GJ6855@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090215103008.GA6855@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090215103008.GA6855@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cleanup HW Breakpoint registers before kexec

From: Alan Stern <stern@rowland.harvard.edu>

This patch disables Hardware breakpoints before doing a 'kexec' on the machine.

[K.Prasad: Split-out from the bigger patch and minor changes following
           re-basing]

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/machine_kexec_32.c |    2 ++
 arch/x86/kernel/machine_kexec_64.c |    2 ++
 2 files changed, 4 insertions(+)

Index: linux-2.6-tip.hbkpt/arch/x86/kernel/machine_kexec_32.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/machine_kexec_32.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/machine_kexec_32.c
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
Index: linux-2.6-tip.hbkpt/arch/x86/kernel/machine_kexec_64.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/machine_kexec_64.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/machine_kexec_64.c
@@ -17,6 +17,7 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
+#include <asm/debugreg.h>
 
 static void init_level2_page(pmd_t *level2p, unsigned long addr)
 {
@@ -234,6 +235,7 @@ void machine_kexec(struct kimage *image)
 
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
+	disable_debug_registers();
 
 	control_page = page_address(image->control_code_page) + PAGE_SIZE;
 	memcpy(control_page, relocate_kernel, PAGE_SIZE);
