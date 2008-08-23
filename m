Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbYHWNDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbYHWNDi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 09:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbYHWNBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 09:01:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:13629 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYHWNA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 09:00:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nrWGfA3MtMeZse9RY/9JqrE8NcLodX/GEJUtad5VHSngoKQdtW03JpsBpbVwwP7bDA
         Uy8YzfD0gbBhx9ZbJDdz5YLpvLdRrDwSgsh4kmIRsPlV+va3Zx4/f9QQ81/4ex67zy26
         vZzmc/H64xks8fAZYwU7pbymrAdnIakbawl2M=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: yhlu.kernel@gmail.com, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 6/8] x86: apic - unify setup_local_APIC
Date: Sat, 23 Aug 2008 17:01:23 +0400
Message-Id: <0f2a2ba7f587ded36f839110baa143ad95b922bf.1219491572.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.6.gc667
In-Reply-To: <1219496485-9513-1-git-send-email-gorcunov@gmail.com>
References: <1219496485-9513-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <a02f3dc9088b9b6c0d22fa77839fdd9d5309ec97.1219491572.git.gorcunov@gmail.com>
References: <a02f3dc9088b9b6c0d22fa77839fdd9d5309ec97.1219491572.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove useless read of APIC_LVR
- wrap with preempt_disable/enable
- check for integrated APIC just in place

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_32.c |   33 ++++++++++++++++++++----
 arch/x86/kernel/apic_64.c |   59 +++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 82 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index c71a77c..5340295 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -75,7 +75,9 @@ char system_vectors[NR_VECTORS] = { [0 ... NR_VECTORS-1] = SYS_VECTOR_FREE};
  */
 unsigned int apic_verbosity;
 
+#ifdef CONFIG_X86_32
 int pic_mode;
+#endif
 
 /* Have we found an MP table */
 int smp_found_config;
@@ -1031,9 +1033,10 @@ static void __cpuinit lapic_setup_esr(void)
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
@@ -1041,14 +1044,16 @@ void __cpuinit setup_local_APIC(void)
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
@@ -1094,6 +1099,7 @@ void __cpuinit setup_local_APIC(void)
 	 */
 	value |= APIC_SPIV_APIC_ENABLED;
 
+#ifdef CONFIG_X86_32
 	/*
 	 * Some unknown Intel IO/APIC (or APIC) errata is biting us with
 	 * certain networking cards. If high frequency interrupts are
@@ -1114,8 +1120,13 @@ void __cpuinit setup_local_APIC(void)
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
@@ -1134,7 +1145,15 @@ void __cpuinit setup_local_APIC(void)
 	 * TODO: set up through-local-APIC from through-I/O-APIC? --macro
 	 */
 	value = apic_read(APIC_LVT0) & APIC_LVT_MASKED;
-	if (!smp_processor_id() && (pic_mode || !value)) {
+#ifdef CONFIG_X86_32
+	/*
+	 * a bit strange form to reduce variables being
+	 * checked: it should be (pic_mode || !value)
+	 * so we swirl it
+	 */
+	value |= !!!pic_mode;
+#endif
+	if (!smp_processor_id() && !value) {
 		value = APIC_DM_EXTINT;
 		apic_printk(APIC_VERBOSE, "enabled ExtINT on CPU#%d\n",
 				smp_processor_id());
@@ -1152,9 +1171,11 @@ void __cpuinit setup_local_APIC(void)
 		value = APIC_DM_NMI;
 	else
 		value = APIC_DM_NMI | APIC_LVT_MASKED;
-	if (!integrated)		/* 82489DX */
+	if (lapic_is_integrated())		/* 82489DX */
 		value |= APIC_LVT_LEVEL_TRIGGER;
 	apic_write(APIC_LVT1, value);
+
+	preempt_enable();
 }
 
 void __cpuinit end_local_APIC_setup(void)
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index b220726..99b5f97 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -71,6 +71,10 @@ EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
  */
 unsigned int apic_verbosity;
 
+#ifdef CONFIG_X86_32
+int pic_mode;
+#endif
+
 /* Have we found an MP table */
 int smp_found_config;
 
@@ -933,8 +937,17 @@ void __cpuinit setup_local_APIC(void)
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
@@ -987,7 +1000,34 @@ void __cpuinit setup_local_APIC(void)
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
@@ -1006,14 +1046,22 @@ void __cpuinit setup_local_APIC(void)
 	 * TODO: set up through-local-APIC from through-I/O-APIC? --macro
 	 */
 	value = apic_read(APIC_LVT0) & APIC_LVT_MASKED;
+#ifdef CONFIG_X86_32
+	/*
+	 * a bit strange form to reduce variables being
+	 * checked: it should be (pic_mode || !value)
+	 * so we swirl it
+	 */
+	value |= !!!pic_mode;
+#endif
 	if (!smp_processor_id() && !value) {
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
 
@@ -1024,7 +1072,10 @@ void __cpuinit setup_local_APIC(void)
 		value = APIC_DM_NMI;
 	else
 		value = APIC_DM_NMI | APIC_LVT_MASKED;
+	if (lapic_is_integrated())		/* 82489DX */
+		value |= APIC_LVT_LEVEL_TRIGGER;
 	apic_write(APIC_LVT1, value);
+
 	preempt_enable();
 }
 
-- 
1.6.0.6.gc667

