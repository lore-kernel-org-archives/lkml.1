Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbYHXJHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbYHXJHT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbYHXJDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:03:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:44109 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbYHXJDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:03:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=N6bqCR8coOXLGhYmGPTJeukndUhlL4l/BcvX/Rv2EkfaedN4q3THuiX6Oe1wa5AFr9
         iPZCPUhos3FOXjHg2rUPhJWtiVzxXEdFDforEjzeRO/zaVrdaQpu6LfTBW6L0tdteO2V
         iF1NeLR/TwT7cEtXsaAawA2GKauxrA0LhSbIk=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 12/18] x86: merge APIC_init_uniprocessor
Date: Sun, 24 Aug 2008 02:01:50 -0700
Message-Id: <1219568516-681-13-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
References: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/apic_32.c |   51 +++++++++++++++++++++++++++++++++++++++-----
 arch/x86/kernel/apic_64.c |   48 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 90 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 294256f..0d9c000 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1355,6 +1355,17 @@ int apic_version[MAX_APICS];
 
 int __init APIC_init_uniprocessor(void)
 {
+#ifdef CONFIG_X86_64
+	if (disable_apic) {
+		printk(KERN_INFO "Apic disabled\n");
+		return -1;
+	}
+	if (!cpu_has_apic) {
+		disable_apic = 1;
+		printk(KERN_INFO "Apic disabled by BIOS\n");
+		return -1;
+	}
+#else
 	if (!smp_found_config && !cpu_has_apic)
 		return -1;
 
@@ -1368,34 +1379,62 @@ int __init APIC_init_uniprocessor(void)
 		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
 		return -1;
 	}
+#endif
 
+#ifdef HAVE_X2APIC
+	enable_IR_x2apic();
+#endif
+#ifdef CONFIG_X86_64
+	setup_apic_routing();
+#endif
 	verify_local_APIC();
-
 	connect_bsp_APIC();
 
+#ifdef CONFIG_X86_64
+	apic_write(APIC_ID, SET_APIC_ID(boot_cpu_physical_apicid));
+#else
 	/*
 	 * Hack: In case of kdump, after a crash, kernel might be booting
 	 * on a cpu with non-zero lapic id. But boot_cpu_physical_apicid
 	 * might be zero if read from MP tables. Get it from LAPIC.
 	 */
-#ifdef CONFIG_CRASH_DUMP
+# ifdef CONFIG_CRASH_DUMP
 	boot_cpu_physical_apicid = read_apic_id();
+# endif
 #endif
 	physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
-
 	setup_local_APIC();
 
+#ifdef CONFIG_X86_64
+	/*
+	 * Now enable IO-APICs, actually call clear_IO_APIC
+	 * We need clear_IO_APIC before enabling vector on BP
+	 */
+	if (!skip_ioapic_setup && nr_ioapics)
+		enable_IO_APIC();
+#endif
+
 #ifdef CONFIG_X86_IO_APIC
 	if (!smp_found_config || skip_ioapic_setup || !nr_ioapics)
 #endif
 		localise_nmi_watchdog();
 	end_local_APIC_setup();
+
 #ifdef CONFIG_X86_IO_APIC
-	if (smp_found_config)
-		if (!skip_ioapic_setup && nr_ioapics)
-			setup_IO_APIC();
+	if (smp_found_config && !skip_ioapic_setup && nr_ioapics)
+		setup_IO_APIC();
+# ifdef CONFIG_X86_64
+	else
+		nr_ioapics = 0;
+# endif
 #endif
+
+#ifdef CONFIG_X86_64
+	setup_boot_APIC_clock();
+	check_nmi_watchdog();
+#else
 	setup_boot_clock();
+#endif
 
 	return 0;
 }
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index dca6c24..16a30c2 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1351,6 +1351,7 @@ int apic_version[MAX_APICS];
 
 int __init APIC_init_uniprocessor(void)
 {
+#ifdef CONFIG_X86_64
 	if (disable_apic) {
 		printk(KERN_INFO "Apic disabled\n");
 		return -1;
@@ -1360,37 +1361,78 @@ int __init APIC_init_uniprocessor(void)
 		printk(KERN_INFO "Apic disabled by BIOS\n");
 		return -1;
 	}
+#else
+	if (!smp_found_config && !cpu_has_apic)
+		return -1;
+
+	/*
+	 * Complain if the BIOS pretends there is one.
+	 */
+	if (!cpu_has_apic &&
+	    APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
+		printk(KERN_ERR "BIOS bug, local APIC #%d not detected!...\n",
+		       boot_cpu_physical_apicid);
+		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
+		return -1;
+	}
+#endif
+
 #ifdef HAVE_X2APIC
 	enable_IR_x2apic();
 #endif
+#ifdef CONFIG_X86_64
 	setup_apic_routing();
+#endif
 
 	verify_local_APIC();
-
 	connect_bsp_APIC();
 
-	physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
+#ifdef CONFIG_X86_64
 	apic_write(APIC_ID, SET_APIC_ID(boot_cpu_physical_apicid));
-
+#else
+	/*
+	 * Hack: In case of kdump, after a crash, kernel might be booting
+	 * on a cpu with non-zero lapic id. But boot_cpu_physical_apicid
+	 * might be zero if read from MP tables. Get it from LAPIC.
+	 */
+# ifdef CONFIG_CRASH_DUMP
+	boot_cpu_physical_apicid = read_apic_id();
+# endif
+#endif
+	physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
 	setup_local_APIC();
 
+#ifdef CONFIG_X86_64
 	/*
 	 * Now enable IO-APICs, actually call clear_IO_APIC
 	 * We need clear_IO_APIC before enabling vector on BP
 	 */
 	if (!skip_ioapic_setup && nr_ioapics)
 		enable_IO_APIC();
+#endif
 
+#ifdef CONFIG_X86_IO_APIC
 	if (!smp_found_config || skip_ioapic_setup || !nr_ioapics)
+#endif
 		localise_nmi_watchdog();
 	end_local_APIC_setup();
 
+#ifdef CONFIG_X86_IO_APIC
 	if (smp_found_config && !skip_ioapic_setup && nr_ioapics)
 		setup_IO_APIC();
+# ifdef CONFIG_X86_64
 	else
 		nr_ioapics = 0;
+# endif
+#endif
+
+#ifdef CONFIG_X86_64
 	setup_boot_APIC_clock();
 	check_nmi_watchdog();
+#else
+	setup_boot_clock();
+#endif
+
 	return 0;
 }
 
-- 
1.5.4.5

