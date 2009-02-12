Return-Path: <linux-kernel-owner+w=401wt.eu-S1760887AbZBLMxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887AbZBLMxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759383AbZBLMup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:50:45 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54476 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759317AbZBLMuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:50:44 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212149.227733077@firstfloor.org>
In-Reply-To: <20090212149.227733077@firstfloor.org>
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [9/9] x86: CMCI: Recheck CMCI banks after APIC has been enabled on CPU #0
Message-Id: <20090212124938.657A73E666E@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:49:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One the first CPU the machine checks are enabled early before
the local APIC is enabled. This could in theory lead 
to some lost CMCI events very early during boot because
CMCIs cannot be delivered with disabled LAPIC. 

The poller also doesn't recover from this because it doesn't
check CMCI banks.

Add an explicit CMCI banks check after the LAPIC is enabled.
This is only done for CPU #0, the other CPUs only initialize
machine checks after the LAPIC is on.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/apic.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux/arch/x86/kernel/apic.c
===================================================================
--- linux.orig/arch/x86/kernel/apic.c	2009-02-12 12:03:15.000000000 +0100
+++ linux/arch/x86/kernel/apic.c	2009-02-12 12:03:15.000000000 +0100
@@ -48,6 +48,7 @@
 #include <asm/apic.h>
 #include <asm/i8259.h>
 #include <asm/smp.h>
+#include <asm/mce.h>
 
 #include <mach_apic.h>
 #include <mach_apicdef.h>
@@ -1270,6 +1271,12 @@
 	apic_write(APIC_LVT1, value);
 
 	preempt_enable();
+
+#ifdef CONFIG_X86_MCE_INTEL
+	/* Recheck CMCI information after local APIC is up on CPU #0 */
+	if (smp_processor_id() == 0)
+		cmci_recheck();
+#endif
 }
 
 void __cpuinit end_local_APIC_setup(void)
