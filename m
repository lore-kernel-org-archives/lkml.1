Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbZEVNbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbZEVNbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 09:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZEVNbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 09:31:38 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:51585 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbZEVNbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 09:31:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FcTvd3Ou2ysZksTgPafkjJAv6SZ3vaTSzjV0+GyX1k8Omg2M8Xo6LsF1XHxY/YLwV2
         CIYE6VX+xAbHK6gqwFLdHfzq9JfXEM10nOwim4rmUGlGyd4EPeAu+HDiJTK0kLx44qS5
         kW5XgpSri9TnRPAIgIK2csCcz8VmsJcEpMrak=
MIME-Version: 1.0
Date: Fri, 22 May 2009 19:31:29 +0600
Message-ID: <b9df5fa10905220631y7b1a094dn9a6e13de1b9c43af@mail.gmail.com>
Subject: [PATCH] x86,APIC: Detect lapic_is_integrated() once - use on and on.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Impact: Reduce text space through efficient coding

 Determine apic is integrated or not - by calling
lapic_is_integrated() once from APIC_init_uniprocessor() and keep it
in a variable integrated_lapic. Thus we can determine apic is
integrated or not, by checking the variable instead of calling
lapic_is_integrated() on and on. Marking lapic_is_integrated() as
__init, which reduces some text space. Also allows us to get away from
messy #ifdef and inline.

---
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/arch/x86/kernel/apic/apic.c	2009-05-21 22:22:15.000000000 +0600
+++ rakib/arch/x86/kernel/apic/apic.c	2009-05-21 23:27:26.000000000 +0600
@@ -127,6 +127,9 @@ early_param("nox2apic", setup_nox2apic);

 unsigned long mp_lapic_addr;
 int disable_apic;
+
+static int integrated_lapic;
+
 /* Disable local APIC timer from the kernel commandline or via dmi quirk */
 static int disable_apic_timer __cpuinitdata;
 /* Local APIC timer works in C2 */
@@ -188,13 +191,12 @@ static inline int lapic_get_version(void
 /*
  * Check, if the APIC is integrated or a separate chip
  */
-static inline int lapic_is_integrated(void)
+void __init lapic_is_integrated(void)
 {
-#ifdef CONFIG_X86_64
-	return 1;
-#else
-	return APIC_INTEGRATED(lapic_get_version());
-#endif
+	if (APIC_INTEGRATED(lapic_get_version()))
+		integrated_lapic = 1;
+	else
+		integrated_lapic = 0;
 }

 /*
@@ -258,7 +260,7 @@ void __cpuinit enable_NMI_through_LVT0(v
 	v = APIC_DM_NMI;

 	/* Level triggered for 82489DX (32bit mode) */
-	if (!lapic_is_integrated())
+	if (!integrated_lapic)
 		v |= APIC_LVT_LEVEL_TRIGGER;

 	apic_write(APIC_LVT0, v);
@@ -313,7 +315,7 @@ static void __setup_APIC_LVTT(unsigned i
 	lvtt_value = LOCAL_TIMER_VECTOR;
 	if (!oneshot)
 		lvtt_value |= APIC_LVT_TIMER_PERIODIC;
-	if (!lapic_is_integrated())
+	if (!integrated_lapic)
 		lvtt_value |= SET_APIC_TIMER_BASE(APIC_TIMER_BASE_DIV);

 	if (!irqen)
@@ -869,7 +871,7 @@ void clear_local_APIC(void)
 		apic_write(APIC_LVTPC, APIC_LVT_MASKED);

 	/* Integrated APIC (!82489DX) ? */
-	if (lapic_is_integrated()) {
+	if (integrated_lapic) {
 		if (maxlvt > 3)
 			/* Clear ESR due to Pentium errata 3AP and 11AP */
 			apic_write(APIC_ESR, 0);
@@ -1064,7 +1066,7 @@ void __init init_bsp_APIC(void)
 	 */
 	apic_write(APIC_LVT0, APIC_DM_EXTINT);
 	value = APIC_DM_NMI;
-	if (!lapic_is_integrated())		/* 82489DX */
+	if (!integrated_lapic)		/* 82489DX */
 		value |= APIC_LVT_LEVEL_TRIGGER;
 	apic_write(APIC_LVT1, value);
 }
@@ -1073,7 +1075,7 @@ static void __cpuinit lapic_setup_esr(vo
 {
 	unsigned int oldvalue, value, maxlvt;

-	if (!lapic_is_integrated()) {
+	if (!integrated_lapic) {
 		pr_info("No ESR for 82489DX.\n");
 		return;
 	}
@@ -1126,7 +1128,7 @@ void __cpuinit setup_local_APIC(void)

 #ifdef CONFIG_X86_32
 	/* Pound the ESR really hard over the head with a big hammer - mbligh */
-	if (lapic_is_integrated() && apic->disable_esr) {
+	if (integrated_lapic && apic->disable_esr) {
 		apic_write(APIC_ESR, 0);
 		apic_write(APIC_ESR, 0);
 		apic_write(APIC_ESR, 0);
@@ -1251,7 +1253,7 @@ void __cpuinit setup_local_APIC(void)
 		value = APIC_DM_NMI;
 	else
 		value = APIC_DM_NMI | APIC_LVT_MASKED;
-	if (!lapic_is_integrated())		/* 82489DX */
+	if (!integrated_lapic)		/* 82489DX */
 		value |= APIC_LVT_LEVEL_TRIGGER;
 	apic_write(APIC_LVT1, value);

@@ -1585,6 +1587,8 @@ int __init APIC_init_uniprocessor(void)
 		pr_info("Apic disabled by BIOS\n");
 		return -1;
 	}
+	/* Since CONFIG_X86_64, so it's integrated.	*/
+	integrated_lapic = 1;
 #else
 	if (!smp_found_config && !cpu_has_apic)
 		return -1;
@@ -1599,6 +1603,8 @@ int __init APIC_init_uniprocessor(void)
 		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
 		return -1;
 	}
+	/* Determine APIC is integrated or not	*/
+	lapic_is_integrated();
 #endif

 	enable_IR_x2apic();
