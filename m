Return-Path: <linux-kernel-owner+w=401wt.eu-S1755622AbZBJMo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbZBJMo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 07:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZBJMos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 07:44:48 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:43381 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbZBJMor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 07:44:47 -0500
Date: Tue, 10 Feb 2009 18:14:31 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       mingo@elte.hu, richardj_moore@uk.ibm.com, jason.wessel@windriver.com
Subject: [Patch 9/10] Cleanup HW Breakpoint registers before kexec
Message-ID: <20090210124431.GI14165@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090210123514.GA4199@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210123514.GA4199@in.ibm.com>
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

Index: mmotm/arch/x86/kernel/machine_kexec_32.c
===================================================================
--- mmotm.orig/arch/x86/kernel/machine_kexec_32.c
+++ mmotm/arch/x86/kernel/machine_kexec_32.c
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
Index: mmotm/arch/x86/kernel/machine_kexec_64.c
===================================================================
--- mmotm.orig/arch/x86/kernel/machine_kexec_64.c
+++ mmotm/arch/x86/kernel/machine_kexec_64.c
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
