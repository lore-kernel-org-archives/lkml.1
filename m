Return-Path: <linux-kernel-owner+w=401wt.eu-S932303AbXLOBEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbXLOBEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 20:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbXLOBEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 20:04:00 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:45424 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbXLOBD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 20:03:59 -0500
Subject: [PATCH] arch/x86/kernel/cpu/mcheck/p4.c, kernel 2.6.24-rc5
From: Min Zhang <mzhang@mvista.com>
Reply-To: mzhang@mvista.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Monta Vista
Date: Fri, 14 Dec 2007 17:03:56 -0800
Message-Id: <1197680636.24198.59.camel@dhcp140.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate printk and insert CPU id to cleanup SMP interleaved output.
In SMP, the machine check exception dispatches all logical processors
within a physical package to the machine-check exception handler, so the
printk within each handler outputs concurrently and makes the output
unreadable. Refer to Intel system programming guide Part 1 Section 7.8.5
http://developer.intel.com/design/processor/manuals/253668.pdf

Signed-off-by: Min Zhang <mzhang@mvista.com>

Index: linux-2.6.24-rc5/arch/x86/kernel/cpu/mcheck/p4.c
===================================================================
--- linux-2.6.24-rc5.orig/arch/x86/kernel/cpu/mcheck/p4.c
+++ linux-2.6.24-rc5/arch/x86/kernel/cpu/mcheck/p4.c
@@ -158,32 +158,35 @@ static fastcall void intel_machine_check
 	if (mce_num_extended_msrs > 0) {
 		struct intel_mce_extended_msrs dbg;
 		intel_get_extended_msrs(&dbg);
-		printk (KERN_DEBUG "CPU %d: EIP: %08x EFLAGS: %08x\n",
-			smp_processor_id(), dbg.eip, dbg.eflags);
-		printk (KERN_DEBUG "\teax: %08x ebx: %08x ecx: %08x edx: %08x\n",
-			dbg.eax, dbg.ebx, dbg.ecx, dbg.edx);
-		printk (KERN_DEBUG "\tesi: %08x edi: %08x ebp: %08x esp: %08x\n",
+		printk (KERN_DEBUG "CPU %d: EIP: %08x EFLAGS: %08x\n"
+			"\teax: %08x ebx: %08x ecx: %08x edx: %08x\n"
+			"\tesi: %08x edi: %08x ebp: %08x esp: %08x\n",
+			smp_processor_id(), dbg.eip, dbg.eflags,
+			dbg.eax, dbg.ebx, dbg.ecx, dbg.edx,
 			dbg.esi, dbg.edi, dbg.ebp, dbg.esp);
 	}
 
 	for (i=0; i<nr_mce_banks; i++) {
 		rdmsr (MSR_IA32_MC0_STATUS+i*4,low, high);
 		if (high & (1<<31)) {
+			char misc[20];
+			char addr[24];
+			misc[0] = addr[0] = '\0';
 			if (high & (1<<29))
 				recover |= 1;
 			if (high & (1<<25))
 				recover |= 2;
-			printk (KERN_EMERG "Bank %d: %08x%08x", i, high, low);
 			high &= ~(1<<31);
 			if (high & (1<<27)) {
 				rdmsr (MSR_IA32_MC0_MISC+i*4, alow, ahigh);
-				printk ("[%08x%08x]", ahigh, alow);
+				snprintf (misc, 20, "[%08x%08x]", ahigh, alow);
 			}
 			if (high & (1<<26)) {
 				rdmsr (MSR_IA32_MC0_ADDR+i*4, alow, ahigh);
-				printk (" at %08x%08x", ahigh, alow);
+				snprintf (addr, 24, " at %08x%08x", ahigh, alow);
 			}
-			printk ("\n");
+			printk (KERN_EMERG "CPU %d: Bank %d: %08x%08x%s%s\n",
+				smp_processor_id(), i, high, low, misc, addr);
 		}
 	}
 
Index: linux-2.6.24-rc5/arch/x86/kernel/cpu/mcheck/p6.c
===================================================================
--- linux-2.6.24-rc5.orig/arch/x86/kernel/cpu/mcheck/p6.c
+++ linux-2.6.24-rc5/arch/x86/kernel/cpu/mcheck/p6.c
@@ -33,21 +33,24 @@ static fastcall void intel_machine_check
 	for (i=0; i<nr_mce_banks; i++) {
 		rdmsr (MSR_IA32_MC0_STATUS+i*4,low, high);
 		if (high & (1<<31)) {
+			char misc[20];
+			char addr[24];
+			misc[0] = addr[0] = '\0';
 			if (high & (1<<29))
 				recover |= 1;
 			if (high & (1<<25))
 				recover |= 2;
-			printk (KERN_EMERG "Bank %d: %08x%08x", i, high, low);
 			high &= ~(1<<31);
 			if (high & (1<<27)) {
 				rdmsr (MSR_IA32_MC0_MISC+i*4, alow, ahigh);
-				printk ("[%08x%08x]", ahigh, alow);
+				snprintf (misc, 20, "[%08x%08x]", ahigh, alow);
 			}
 			if (high & (1<<26)) {
 				rdmsr (MSR_IA32_MC0_ADDR+i*4, alow, ahigh);
-				printk (" at %08x%08x", ahigh, alow);
+				snprintf (addr, 24, " at %08x%08x", ahigh, alow);
 			}
-			printk ("\n");
+			printk (KERN_EMERG "CPU %d: Bank %d: %08x%08x%s%s\n",
+				smp_processor_id(), i, high, low, misc, addr);
 		}
 	}
 
Index: linux-2.6.24-rc5/arch/x86/kernel/cpu/mcheck/k7.c
===================================================================
--- linux-2.6.24-rc5.orig/arch/x86/kernel/cpu/mcheck/k7.c
+++ linux-2.6.24-rc5/arch/x86/kernel/cpu/mcheck/k7.c
@@ -33,21 +33,24 @@ static fastcall void k7_machine_check(st
 	for (i=1; i<nr_mce_banks; i++) {
 		rdmsr (MSR_IA32_MC0_STATUS+i*4,low, high);
 		if (high&(1<<31)) {
+			char misc[20];
+			char addr[24];
+			misc[0] = addr[0] = '\0';
 			if (high & (1<<29))
 				recover |= 1;
 			if (high & (1<<25))
 				recover |= 2;
-			printk (KERN_EMERG "Bank %d: %08x%08x", i, high, low);
 			high &= ~(1<<31);
 			if (high & (1<<27)) {
 				rdmsr (MSR_IA32_MC0_MISC+i*4, alow, ahigh);
-				printk ("[%08x%08x]", ahigh, alow);
+				snprintf (misc, 20, "[%08x%08x]", ahigh, alow);
 			}
 			if (high & (1<<26)) {
 				rdmsr (MSR_IA32_MC0_ADDR+i*4, alow, ahigh);
-				printk (" at %08x%08x", ahigh, alow);
+				snprintf (addr, 24, " at %08x%08x", ahigh, alow);
 			}
-			printk ("\n");
+			printk (KERN_EMERG "CPU %d: Bank %d: %08x%08x%s%s\n",
+				smp_processor_id(), i, high, low, misc, addr);
 			/* Clear it */
 			wrmsr (MSR_IA32_MC0_STATUS+i*4, 0UL, 0UL);
 			/* Serialize */


