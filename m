Return-Path: <linux-kernel-owner+w=401wt.eu-S1752419AbZA2ANu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbZA2ANu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758085AbZA1XqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:46:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:53174 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758213AbZA1XqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:46:05 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 072/114] x86, smp: refactor ->wake_cpu
Date: Wed, 28 Jan 2009 23:42:18 +0000
Message-Id: <1233186180-29883-73-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove macro wrappers

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/mach-default/mach_apic.h |    2 --
 arch/x86/include/asm/mach-generic/mach_apic.h |    2 --
 arch/x86/kernel/setup.c                       |    5 ++---
 arch/x86/kernel/smpboot.c                     |    4 ++--
 4 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index b60b767..bae053c 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -19,10 +19,8 @@ static inline const struct cpumask *default_target_cpus(void)
 #ifdef CONFIG_X86_64
 #include <asm/genapic.h>
 #define read_apic_id()  (apic->get_apic_id(apic_read(APIC_ID)))
-#define wakeup_secondary_cpu (apic->wakeup_cpu)
 extern void default_setup_apic_routing(void);
 #else
-#define wakeup_secondary_cpu wakeup_secondary_cpu_via_init
 /*
  * Set up the logical destination ID.
  *
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index ca460e4..96f217f 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -3,8 +3,6 @@
 
 #include <asm/genapic.h>
 
-#define wakeup_secondary_cpu (apic->wakeup_cpu)
-
 extern void generic_bigsmp_probe(void);
 
 #endif /* _ASM_X86_MACH_GENERIC_MACH_APIC_H */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index a58e9f5..6b27f6d 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -589,9 +589,8 @@ early_param("elfcorehdr", setup_elfcorehdr);
 static int __init default_update_genapic(void)
 {
 #ifdef CONFIG_X86_SMP
-# if defined(CONFIG_X86_GENERICARCH) || defined(CONFIG_X86_64)
-	apic->wakeup_cpu = wakeup_secondary_cpu_via_init;
-# endif
+	if (!apic->wakeup_cpu)
+		apic->wakeup_cpu = wakeup_secondary_cpu_via_init;
 #endif
 
 	return 0;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 1fdc1a7..3fed177 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -750,7 +750,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 /*
  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
  * (ie clustered apic addressing mode), this is a LOGICAL apic ID.
- * Returns zero if CPU booted OK, else error code from wakeup_secondary_cpu.
+ * Returns zero if CPU booted OK, else error code from ->wakeup_cpu.
  */
 {
 	unsigned long boot_error = 0;
@@ -841,7 +841,7 @@ do_rest:
 	/*
 	 * Starting actual IPI sequence...
 	 */
-	boot_error = wakeup_secondary_cpu(apicid, start_ip);
+	boot_error = apic->wakeup_cpu(apicid, start_ip);
 
 	if (!boot_error) {
 		/*
-- 
1.6.0.2

