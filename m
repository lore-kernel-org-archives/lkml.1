Return-Path: <linux-kernel-owner+w=401wt.eu-S1757103AbZDGS5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbZDGS5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 14:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755843AbZDGS4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 14:56:10 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:43532 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbZDGS4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 14:56:07 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: ming@elte.hu
Cc: penberg@cs.helsinki.fi, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/13] x86: introduce apic_intr_init() in irqinit_32.c
Date: Tue,  7 Apr 2009 16:48:31 +0300
Message-Id: <1239112120-676-4-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/kernel/irqinit_32.c |   40 ++++++++++++++++++++++------------------
 1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index df0aad5..9ba68c4 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -171,25 +171,8 @@ static void __init x86_quirk_pre_intr_init(void)
 	init_ISA_irqs();
 }
 
-void __init native_init_IRQ(void)
+static void __init apic_intr_init(void)
 {
-	int i;
-
-	/* Execute any quirks before the call gates are initialised: */
-	x86_quirk_pre_intr_init();
-
-	/*
-	 * Cover the whole vector space, no vector can escape
-	 * us. (some of these will be overridden and become
-	 * 'special' SMP interrupts)
-	 */
-	for (i =  FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
-		/* SYSCALL_VECTOR was reserved in trap_init. */
-		if (i != SYSCALL_VECTOR)
-			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
-	}
-
-
 	smp_intr_init();
 
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -208,6 +191,27 @@ void __init native_init_IRQ(void)
 	/* thermal monitor LVT interrupt */
 	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 #endif
+}
+
+void __init native_init_IRQ(void)
+{
+	int i;
+
+	/* Execute any quirks before the call gates are initialised: */
+	x86_quirk_pre_intr_init();
+
+	/*
+	 * Cover the whole vector space, no vector can escape
+	 * us. (some of these will be overridden and become
+	 * 'special' SMP interrupts)
+	 */
+	for (i =  FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
+		/* SYSCALL_VECTOR was reserved in trap_init. */
+		if (i != SYSCALL_VECTOR)
+			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
+	}
+
+	apic_intr_init();
 
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
-- 
1.5.6.3

