Return-Path: <linux-kernel-owner+w=401wt.eu-S1759013AbZFNNPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013AbZFNNPA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 09:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbZFNNOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 09:14:51 -0400
Received: from mail-px0-f187.google.com ([209.85.216.187]:48753 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbZFNNOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 09:14:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JJFhpTYrLYbA49e8XabKe8uk+qaD1UDtRUVsw8AL7YMbYAT1RtAAdZWCarG8vGHqie
         rIVTiIZ+hRhwrgxV9E0jDfEOZiUT0QmHw19JtO0VkBcamQCbeVfD/nLcQYVe8IU0/p1s
         J6+BEQ8AOCqybNrdsjpLnHcvc2UFac2Mv9Yes=
MIME-Version: 1.0
Date: Sun, 14 Jun 2009 19:14:52 +0600
Message-ID: <b9df5fa10906140614k7ed62d6ewbf2076119e9d7522@mail.gmail.com>
Subject: [Resend][PATCH] v2 x86, APIC: Detect lapic_is_integrated() once - use 
	on and on.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Cyrill Gorcunov <gorcunov@openvz.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Impact: Taking simple approach in checking apic integrity.

 Currently we use lapic_is_integrated() to check whether we've a
integrated apic or not.So we call lapic_is_integrated() on and on.
This patch shows a more simpler approach by - calling
lapic_is_integrated() once and keeping it in a variable in case of
!CONFIG_X86_64.Later on to check apic integrity we've to check
integrated_lapic. When we've CONFIG_X86_64, we define integrated_lapic
as integrated - since latest processors have apic integrated, so we
don't need to call lapic_is_integrated().

Thanks,

---
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/arch/x86/kernel/apic/apic.c	2009-06-14 09:20:57.000000000 +0600
+++ rakib/arch/x86/kernel/apic/apic.c	2009-06-14 09:44:54.771238608 +0600
@@ -127,6 +127,13 @@ early_param("nox2apic", setup_nox2apic);

 unsigned long mp_lapic_addr;
 int disable_apic;
+
+#ifdef	CONFIG_X86_64
+# define integrated_lapic (1)
+#else
+static int integrated_lapic __read_mostly;
+#endif
+
 /* Disable local APIC timer from the kernel commandline or via dmi quirk */
 static int disable_apic_timer __cpuinitdata;
 /* Local APIC timer works in C2 */
@@ -188,12 +195,10 @@ static inline int lapic_get_version(void
 /*
  * Check, if the APIC is integrated or a separate chip
  */
-static inline int lapic_is_integrated(void)
+static inline void lapic_is_integrated(void)
 {
-#ifdef CONFIG_X86_64
-	return 1;
-#else
-	return APIC_INTEGRATED(lapic_get_version());
+#ifdef CONFIG_X86_32
+	integrated_lapic = APIC_INTEGRATED(lapic_get_version());
 #endif
 }

@@ -258,7 +263,7 @@ void __cpuinit enable_NMI_through_LVT0(v
 	v = APIC_DM_NMI;

 	/* Level triggered for 82489DX (32bit mode) */
-	if (!lapic_is_integrated())
+	if (!integrated_lapic)
 		v |= APIC_LVT_LEVEL_TRIGGER;

 	apic_write(APIC_LVT0, v);
@@ -313,7 +318,7 @@ static void __setup_APIC_LVTT(unsigned i
 	lvtt_value = LOCAL_TIMER_VECTOR;
 	if (!oneshot)
 		lvtt_value |= APIC_LVT_TIMER_PERIODIC;
-	if (!lapic_is_integrated())
+	if (!integrated_lapic)
 		lvtt_value |= SET_APIC_TIMER_BASE(APIC_TIMER_BASE_DIV);

 	if (!irqen)
@@ -869,7 +874,7 @@ void clear_local_APIC(void)
 		apic_write(APIC_LVTPC, APIC_LVT_MASKED);

 	/* Integrated APIC (!82489DX) ? */
-	if (lapic_is_integrated()) {
+	if (integrated_lapic) {
 		if (maxlvt > 3)
 			/* Clear ESR due to Pentium errata 3AP and 11AP */
 			apic_write(APIC_ESR, 0);
@@ -1064,7 +1069,7 @@ void __init init_bsp_APIC(void)
 	 */
 	apic_write(APIC_LVT0, APIC_DM_EXTINT);
 	value = APIC_DM_NMI;
-	if (!lapic_is_integrated())		/* 82489DX */
+	if (!integrated_lapic)		/* 82489DX */
 		value |= APIC_LVT_LEVEL_TRIGGER;
 	apic_write(APIC_LVT1, value);
 }
@@ -1073,7 +1078,7 @@ static void __cpuinit lapic_setup_esr(vo
 {
 	unsigned int oldvalue, value, maxlvt;

-	if (!lapic_is_integrated()) {
+	if (!integrated_lapic) {
 		pr_info("No ESR for 82489DX.\n");
 		return;
 	}
@@ -1126,7 +1131,7 @@ void __cpuinit setup_local_APIC(void)

 #ifdef CONFIG_X86_32
 	/* Pound the ESR really hard over the head with a big hammer - mbligh */
-	if (lapic_is_integrated() && apic->disable_esr) {
+	if (integrated_lapic && apic->disable_esr) {
 		apic_write(APIC_ESR, 0);
 		apic_write(APIC_ESR, 0);
 		apic_write(APIC_ESR, 0);
@@ -1251,7 +1256,7 @@ void __cpuinit setup_local_APIC(void)
 		value = APIC_DM_NMI;
 	else
 		value = APIC_DM_NMI | APIC_LVT_MASKED;
-	if (!lapic_is_integrated())		/* 82489DX */
+	if (!integrated_lapic)		/* 82489DX */
 		value |= APIC_LVT_LEVEL_TRIGGER;
 	apic_write(APIC_LVT1, value);

@@ -1599,6 +1604,8 @@ int __init APIC_init_uniprocessor(void)
 		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
 		return -1;
 	}
+	/* Determine APIC is integrated or not.	*/
+	lapic_is_integrated();
 #endif

 	enable_IR_x2apic();
