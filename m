Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbZC2UV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbZC2UV6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 16:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbZC2UVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 16:21:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:47870 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbZC2UVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 16:21:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=CADQ+xtPYg+7txEfOP0xXQff6CwskrEkJ4SZ1y+W3xy0H3ubHI0i+kxR3Tt6N25hVN
         7FcHG68iqOGd5/oJ1P0/kI5v8O1ssK/IqnSs7bTdEZ5B7wW3pCToOUWSHLxuRn51/fMs
         YrE/bkyWVBQer/hpO7/2SGTyXR+EuRN04vJH4=
Message-Id: <20090329202208.009637910@openvz.org>
User-Agent: quilt/0.47-1
Date: Mon, 30 Mar 2009 00:15:48 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, xemul@openvz.org, yhlu.kernel@gmail.com,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 3/6] x86: irqinit - merge apic_intr_init
References: <20090329201545.470255691@openvz.org>
Content-Disposition: inline; filename=x86-irqinit-apic_intr_init
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/irqinit_32.c |    8 +++++++-
 arch/x86/kernel/irqinit_64.c |   18 ++++++++++++++----
 2 files changed, 21 insertions(+), 5 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/irqinit_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irqinit_32.c
+++ linux-2.6.git/arch/x86/kernel/irqinit_32.c
@@ -183,13 +183,19 @@ static void __init apic_intr_init(void)
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
 # ifdef CONFIG_PERF_COUNTERS
+	/* Performance monitoring interrupt */
 	alloc_intr_gate(LOCAL_PERF_VECTOR, perf_counter_interrupt);
 # endif
 
-# ifdef CONFIG_X86_MCE_P4THERMAL
+#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_64)
 	/* thermal monitor LVT interrupt */
 	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 # endif
+
+# ifdef CONFIG_X86_64
+	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
+# endif
+
 #endif
 }
 
Index: linux-2.6.git/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irqinit_64.c
+++ linux-2.6.git/arch/x86/kernel/irqinit_64.c
@@ -141,8 +141,7 @@ static void __init apic_intr_init(void)
 {
 	smp_intr_init();
 
-	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
-	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
+#ifdef CONFIG_X86_LOCAL_APIC
 
 	/* self generated IPI for local APIC timer */
 	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
@@ -154,9 +153,20 @@ static void __init apic_intr_init(void)
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
 
-	/* Performance monitoring interrupt: */
-#ifdef CONFIG_PERF_COUNTERS
+# ifdef CONFIG_PERF_COUNTERS
+	/* Performance monitoring interrupt */
 	alloc_intr_gate(LOCAL_PERF_VECTOR, perf_counter_interrupt);
+# endif
+
+#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_64)
+	/* thermal monitor LVT interrupt */
+	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
+# endif
+
+# ifdef CONFIG_X86_64
+	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
+# endif
+
 #endif
 }
 

