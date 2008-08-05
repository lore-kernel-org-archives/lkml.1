Return-Path: <linux-kernel-owner+w=401wt.eu-S1763087AbYHERRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763087AbYHERRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760915AbYHERRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:17:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37698 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758092AbYHERRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:17:01 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080805717.971524000@firstfloor.org>
In-Reply-To: <20080805717.971524000@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/4] MCE: Fix ifdefs for Intel thermal handler
Message-Id: <20080805171735.517841AD0023@one.firstfloor.org>
Date: Tue,  5 Aug 2008 19:17:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I forgot to switch over some ifdefs during the machine check unification.
This broke the Intel thermal handler on 32bit with the new machine 
check code. Fix this.

This patch should be ideally folded into the earlier conversion one
("Use 64bit machine check code on 32bit")


Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux/arch/x86/kernel/apic_32.c
===================================================================
--- linux.orig/arch/x86/kernel/apic_32.c
+++ linux/arch/x86/kernel/apic_32.c
@@ -700,7 +700,7 @@ void clear_local_APIC(void)
 	}
 
 	/* lets not touch this if we didn't frob it */
-#ifdef CONFIG_X86_MCE_P4THERMAL
+#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_MCE_INTEL)
 	if (maxlvt >= 5) {
 		v = apic_read(APIC_LVTTHMR);
 		apic_write_around(APIC_LVTTHMR, v | APIC_LVT_MASKED);
@@ -717,7 +717,7 @@ void clear_local_APIC(void)
 	if (maxlvt >= 4)
 		apic_write_around(APIC_LVTPC, APIC_LVT_MASKED);
 
-#ifdef CONFIG_X86_MCE_P4THERMAL
+#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_MCE_INTEL)
 	if (maxlvt >= 5)
 		apic_write_around(APIC_LVTTHMR, APIC_LVT_MASKED);
 #endif
@@ -1377,7 +1377,7 @@ void __init apic_intr_init(void)
 	set_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
 
 	/* thermal monitor LVT interrupt */
-#ifdef CONFIG_X86_MCE_P4THERMAL
+#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_MCE_INTEL)
 	set_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 #endif
 }
@@ -1595,7 +1595,7 @@ static int lapic_suspend(struct sys_devi
 	apic_pm_state.apic_lvterr = apic_read(APIC_LVTERR);
 	apic_pm_state.apic_tmict = apic_read(APIC_TMICT);
 	apic_pm_state.apic_tdcr = apic_read(APIC_TDCR);
-#ifdef CONFIG_X86_MCE_P4THERMAL
+#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_MCE_INTEL)
 	if (maxlvt >= 5)
 		apic_pm_state.apic_thmr = apic_read(APIC_LVTTHMR);
 #endif
Index: linux/include/asm-x86/mach-default/entry_arch.h
===================================================================
--- linux.orig/include/asm-x86/mach-default/entry_arch.h
+++ linux/include/asm-x86/mach-default/entry_arch.h
@@ -27,7 +27,7 @@ BUILD_INTERRUPT(apic_timer_interrupt,LOC
 BUILD_INTERRUPT(error_interrupt,ERROR_APIC_VECTOR)
 BUILD_INTERRUPT(spurious_interrupt,SPURIOUS_APIC_VECTOR)
 
-#ifdef CONFIG_X86_MCE_P4THERMAL
+#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_MCE_INTEL)
 BUILD_INTERRUPT(thermal_interrupt,THERMAL_APIC_VECTOR)
 #endif
 
