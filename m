Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbYHXJEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbYHXJEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbYHXJDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:03:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:44068 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbYHXJDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:03:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VEaN4W65UMGCvnGCheqgh+yx3wynY4oQoI8tX2tvFhRE7PzyoxFhDH1nPqlKzqGNyd
         OKPd7/inq2srgQr+32sv3QSs73OO5uw97loG9IXI09EYSvoOdqj8DjB2AGYkRGG1bnJW
         fDGCP9sdxM7W+FTnCpIIMxo2n4fCPSrRDvYZM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 05/18] x86: apic - unify setup_local_APIC
Date: Sun, 24 Aug 2008 02:01:43 -0700
Message-Id: <1219568516-681-6-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
References: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

- remove useless read of APIC_LVR
- wrap with preempt_disable/enable
- check for integrated APIC just in place

v2: fix by Yinghai Lu.
	fix lapic_is_intergrated using
	let 64bit to have pic_mode

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/apic_32.c |   21 ++++++++++++++----
 arch/x86/kernel/apic_64.c |   51 ++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 62 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index cca72da..42acb3a 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1033,9 +1033,10 @@ static void __cpuinit lapic_setup_esr(void)
  */
 void __cpuinit setup_local_APIC(void)
 {
-	unsigned long value, integrated;
+	unsigned int value;
 	int i, j;
 
+#ifdef CONFIG_X86_32
 	/* Pound the ESR really hard over the head with a big hammer - mbligh */
 	if (esr_disable) {
 		apic_write(APIC_ESR, 0);
@@ -1043,14 +1044,16 @@ void __cpuinit setup_local_APIC(void)
 		apic_write(APIC_ESR, 0);
 		apic_write(APIC_ESR, 0);
 	}
+#endif
 
-	integrated = lapic_is_integrated();
+	preempt_disable();
 
 	/*
 	 * Double-check whether this APIC is really registered.
+	 * This is meaningless in clustered apic mode, so we skip it.
 	 */
 	if (!apic_id_registered())
-		WARN_ON_ONCE(1);
+		BUG();
 
 	/*
 	 * Intel recommends to set DFR, LDR and TPR before enabling
@@ -1096,6 +1099,7 @@ void __cpuinit setup_local_APIC(void)
 	 */
 	value |= APIC_SPIV_APIC_ENABLED;
 
+#ifdef CONFIG_X86_32
 	/*
 	 * Some unknown Intel IO/APIC (or APIC) errata is biting us with
 	 * certain networking cards. If high frequency interrupts are
@@ -1116,8 +1120,13 @@ void __cpuinit setup_local_APIC(void)
 	 * See also the comment in end_level_ioapic_irq().  --macro
 	 */
 
-	/* Enable focus processor (bit==0) */
+	/*
+	 * - enable focus processor (bit==0)
+	 * - 64bit mode always use processor focus
+	 *   so no need to set it
+	 */
 	value &= ~APIC_SPIV_FOCUS_DISABLED;
+#endif
 
 	/*
 	 * Set spurious IRQ vector
@@ -1154,9 +1163,11 @@ void __cpuinit setup_local_APIC(void)
 		value = APIC_DM_NMI;
 	else
 		value = APIC_DM_NMI | APIC_LVT_MASKED;
-	if (!integrated)		/* 82489DX */
+	if (!lapic_is_integrated())		/* 82489DX */
 		value |= APIC_LVT_LEVEL_TRIGGER;
 	apic_write(APIC_LVT1, value);
+
+	preempt_enable();
 }
 
 void __cpuinit end_local_APIC_setup(void)
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 4587e16..283968d 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -76,6 +76,8 @@ char system_vectors[NR_VECTORS] = { [0 ... NR_VECTORS-1] = SYS_VECTOR_FREE};
  */
 unsigned int apic_verbosity;
 
+int pic_mode;
+
 /* Have we found an MP table */
 int smp_found_config;
 
@@ -943,8 +945,17 @@ void __cpuinit setup_local_APIC(void)
 	unsigned int value;
 	int i, j;
 
+#ifdef CONFIG_X86_32
+	/* Pound the ESR really hard over the head with a big hammer - mbligh */
+	if (esr_disable) {
+		apic_write(APIC_ESR, 0);
+		apic_write(APIC_ESR, 0);
+		apic_write(APIC_ESR, 0);
+		apic_write(APIC_ESR, 0);
+	}
+#endif
+
 	preempt_disable();
-	value = apic_read(APIC_LVR);
 
 	/*
 	 * Double-check whether this APIC is really registered.
@@ -997,7 +1008,34 @@ void __cpuinit setup_local_APIC(void)
 	 */
 	value |= APIC_SPIV_APIC_ENABLED;
 
-	/* We always use processor focus */
+#ifdef CONFIG_X86_32
+	/*
+	 * Some unknown Intel IO/APIC (or APIC) errata is biting us with
+	 * certain networking cards. If high frequency interrupts are
+	 * happening on a particular IOAPIC pin, plus the IOAPIC routing
+	 * entry is masked/unmasked at a high rate as well then sooner or
+	 * later IOAPIC line gets 'stuck', no more interrupts are received
+	 * from the device. If focus CPU is disabled then the hang goes
+	 * away, oh well :-(
+	 *
+	 * [ This bug can be reproduced easily with a level-triggered
+	 *   PCI Ne2000 networking cards and PII/PIII processors, dual
+	 *   BX chipset. ]
+	 */
+	/*
+	 * Actually disabling the focus CPU check just makes the hang less
+	 * frequent as it makes the interrupt distributon model be more
+	 * like LRU than MRU (the short-term load is more even across CPUs).
+	 * See also the comment in end_level_ioapic_irq().  --macro
+	 */
+
+	/*
+	 * - enable focus processor (bit==0)
+	 * - 64bit mode always use processor focus
+	 *   so no need to set it
+	 */
+	value &= ~APIC_SPIV_FOCUS_DISABLED;
+#endif
 
 	/*
 	 * Set spurious IRQ vector
@@ -1016,14 +1054,14 @@ void __cpuinit setup_local_APIC(void)
 	 * TODO: set up through-local-APIC from through-I/O-APIC? --macro
 	 */
 	value = apic_read(APIC_LVT0) & APIC_LVT_MASKED;
-	if (!smp_processor_id() && !value) {
+	if (!smp_processor_id() && (pic_mode || !value)) {
 		value = APIC_DM_EXTINT;
 		apic_printk(APIC_VERBOSE, "enabled ExtINT on CPU#%d\n",
-			    smp_processor_id());
+				smp_processor_id());
 	} else {
 		value = APIC_DM_EXTINT | APIC_LVT_MASKED;
 		apic_printk(APIC_VERBOSE, "masked ExtINT on CPU#%d\n",
-			    smp_processor_id());
+				smp_processor_id());
 	}
 	apic_write(APIC_LVT0, value);
 
@@ -1034,7 +1072,10 @@ void __cpuinit setup_local_APIC(void)
 		value = APIC_DM_NMI;
 	else
 		value = APIC_DM_NMI | APIC_LVT_MASKED;
+	if (!lapic_is_integrated())		/* 82489DX */
+		value |= APIC_LVT_LEVEL_TRIGGER;
 	apic_write(APIC_LVT1, value);
+
 	preempt_enable();
 }
 
-- 
1.5.4.5

