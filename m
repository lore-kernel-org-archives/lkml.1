Return-Path: <linux-kernel-owner+w=401wt.eu-S1769828AbYCSUYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1769828AbYCSUYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757336AbYCSTjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbYCSTjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:39:00 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 56/79] [PATCH] minor adjustments for do_boot_cpu
Date: Wed, 19 Mar 2008 14:25:51 -0300
Message-Id: <12059478283765-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1205947823284-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

This patch provides minor adjustments for do_boot_cpus
in both architectures to allow for integration

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c |   22 ++++++++++++++--------
 arch/x86/kernel/smpboot_64.c |   15 ++++++---------
 2 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index bd2f886..5165b11 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -556,7 +556,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
  * Returns zero if CPU booted OK, else error code from wakeup_secondary_cpu.
  */
 {
-	unsigned long boot_error;
+	unsigned long boot_error = 0;
 	int timeout;
 	unsigned long start_eip;
 	unsigned short nmi_high = 0, nmi_low = 0;
@@ -566,11 +566,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 	};
 	INIT_WORK(&c_idle.work, do_fork_idle);
 
-	/*
-	 * Save current MTRR state in case it was changed since early boot
-	 * (e.g. by the ACPI SMI) to initialize new CPUs with MTRRs in sync:
-	 */
-	mtrr_save_state();
+	alternatives_smp_switch(1);
 
 	c_idle.idle = get_idle_for_cpu(cpu);
 
@@ -607,8 +603,6 @@ do_rest:
 	/* start_eip had better be page-aligned! */
 	start_eip = setup_trampoline();
 
-	alternatives_smp_switch(1);
-
 	/* So we see what's up   */
 	printk("Booting processor %d/%d ip %lx\n", cpu, apicid, start_eip);
 	/* Stack for startup_32 can be just as for start_secondary onwards */
@@ -628,6 +622,12 @@ do_rest:
 	store_NMI_vector(&nmi_high, &nmi_low);
 
 	smpboot_setup_warm_reset_vector(start_eip);
+	/*
+	 * Be paranoid about clearing APIC errors.
+	 */
+	apic_write(APIC_ESR, 0);
+	apic_read(APIC_ESR);
+
 
 	/*
 	 * Starting actual IPI sequence...
@@ -864,6 +864,12 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 		return -EINVAL;
 	}
 
+	/*
+	 * Save current MTRR state in case it was changed since early boot
+	 * (e.g. by the ACPI SMI) to initialize new CPUs with MTRRs in sync:
+	 */
+	mtrr_save_state();
+
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 
 	__smp_prepare_cpu(cpu);
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index e93fff4..7d1b4cb 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -432,7 +432,7 @@ static void __cpuinit do_fork_idle(struct work_struct *work)
  */
 static int __cpuinit do_boot_cpu(int cpu, int apicid)
 {
-	unsigned long boot_error;
+	unsigned long boot_error = 0;
 	int timeout;
 	unsigned long start_rip;
 	struct create_idle c_idle = {
@@ -531,11 +531,6 @@ do_rest:
 	apic_read(APIC_ESR);
 
 	/*
-	 * Status is now clean
-	 */
-	boot_error = 0;
-
-	/*
 	 * Starting actual IPI sequence...
 	 */
 	boot_error = wakeup_secondary_via_INIT(apicid, start_rip);
@@ -564,7 +559,7 @@ do_rest:
 			print_cpu_info(&cpu_data(cpu));
 		} else {
 			boot_error = 1;
-			if (*((volatile unsigned char *)phys_to_virt(SMP_TRAMPOLINE_BASE))
+			if (*((volatile unsigned char *)trampoline_base)
 					== 0xA5)
 				/* trampoline started but...? */
 				printk("Stuck ??\n");
@@ -583,10 +578,12 @@ do_rest:
 		cpu_clear(cpu, cpu_present_map);
 		cpu_clear(cpu, cpu_possible_map);
 		per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
-		return -EIO;
 	}
 
-	return 0;
+	/* mark "stuck" area as not stuck */
+	*((volatile unsigned long *)trampoline_base) = 0;
+
+	return boot_error;
 }
 
 cycles_t cacheflush_time;
-- 
1.5.0.6

