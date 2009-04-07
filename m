Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbZDGSyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbZDGSyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 14:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZDGSyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 14:54:08 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:40592 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbZDGSyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 14:54:07 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: ming@elte.hu
Cc: penberg@cs.helsinki.fi, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/13] x86: unify apic_intr_init() in irqinit_{32,64}.c
Date: Tue,  7 Apr 2009 16:48:37 +0300
Message-Id: <1239112120-676-10-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/kernel/irqinit_32.c |    9 ++++++++-
 arch/x86/kernel/irqinit_64.c |   11 +++++++++++
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 72ce942..f3be5e9 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -180,7 +180,12 @@ static void __init apic_intr_init(void)
 {
 	smp_intr_init();
 
-#ifdef CONFIG_X86_LOCAL_APIC
+#ifdef CONFIG_X86_64
+	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
+	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
+#endif
+
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
 	/* self generated IPI for local APIC timer */
 	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
 
@@ -192,10 +197,12 @@ static void __init apic_intr_init(void)
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
 #endif
 
+#ifdef CONFIG_X86_32
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_MCE_P4THERMAL)
 	/* thermal monitor LVT interrupt */
 	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 #endif
+#endif
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 687b6c3..f3be5e9 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -180,9 +180,12 @@ static void __init apic_intr_init(void)
 {
 	smp_intr_init();
 
+#ifdef CONFIG_X86_64
 	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
+#endif
 
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
 	/* self generated IPI for local APIC timer */
 	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
 
@@ -192,6 +195,14 @@ static void __init apic_intr_init(void)
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
+#endif
+
+#ifdef CONFIG_X86_32
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_MCE_P4THERMAL)
+	/* thermal monitor LVT interrupt */
+	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
+#endif
+#endif
 }
 
 #ifdef CONFIG_X86_32
-- 
1.5.6.3

