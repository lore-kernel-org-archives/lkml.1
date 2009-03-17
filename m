Return-Path: <linux-kernel-owner+w=401wt.eu-S1762862AbZCQAck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762862AbZCQAck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbZCQA2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:28:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:57059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760782AbZCQA2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:28:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,375,1233561600"; 
   d="scan'208";a="498294270"
Message-Id: <20090317001320.838220000@linux-os.sc.intel.com>
References: <20090317000452.805772000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 16 Mar 2009 17:05:00 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org,
       yinghai@kernel.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 08/13] x86: fix clear_local_APIC() in the presence of x2apic
Content-Disposition: inline; filename=fix_clear_local_apic_with_x2apic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were not clearing the local APIC in clear_local_APIC() in the
presence of x2apic. Fix it.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -812,7 +812,7 @@ void clear_local_APIC(void)
 	u32 v;
 
 	/* APIC hasn't been mapped yet */
-	if (!apic_phys)
+	if (!x2apic && !apic_phys)
 		return;
 
 	maxlvt = lapic_get_maxlvt();
@@ -1527,12 +1527,10 @@ void __init early_init_lapic_mapping(voi
  */
 void __init init_apic_mappings(void)
 {
-#ifdef CONFIG_X86_X2APIC
 	if (x2apic) {
 		boot_cpu_physical_apicid = read_apic_id();
 		return;
 	}
-#endif
 
 	/*
 	 * If no local APIC can be found then set up a fake all
@@ -1976,12 +1974,9 @@ static int lapic_resume(struct sys_devic
 
 	local_irq_save(flags);
 
-#ifdef CONFIG_X86_X2APIC
 	if (x2apic)
 		enable_x2apic();
-	else
-#endif
-	{
+	else {
 		/*
 		 * Make sure the APICBASE points to the right address
 		 *
Index: tip/arch/x86/include/asm/apic.h
===================================================================
--- tip.orig/arch/x86/include/asm/apic.h
+++ tip/arch/x86/include/asm/apic.h
@@ -184,6 +184,9 @@ static inline int x2apic_enabled(void)
 {
 	return 0;
 }
+
+#define	x2apic	0
+
 #endif
 
 extern int get_physical_broadcast(void);
Index: tip/arch/x86/include/asm/irq_remapping.h
===================================================================
--- tip.orig/arch/x86/include/asm/irq_remapping.h
+++ tip/arch/x86/include/asm/irq_remapping.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_X86_IRQ_REMAPPING_H
 #define _ASM_X86_IRQ_REMAPPING_H
 
-extern int x2apic;
-
 #define IRTE_DEST(dest) ((x2apic) ? dest : dest << 8)
 
 #endif	/* _ASM_X86_IRQ_REMAPPING_H */

-- 

