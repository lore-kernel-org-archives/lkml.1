Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbYFSAb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbYFSAb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757998AbYFSAan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 20:30:43 -0400
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:61745 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103AbYFSAam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 20:30:42 -0400
From: Nathan Lynch <ntl@pobox.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Anton Blanchard <anton@samba.org>
Subject: [RFC/PATCH 3/3] adjust cpu power for secondary threads on POWER6
Date: Wed, 18 Jun 2008 19:29:34 -0500
Message-Id: <1213835374-10868-4-git-send-email-ntl@pobox.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1213835374-10868-1-git-send-email-ntl@pobox.com>
References: <1213835374-10868-1-git-send-email-ntl@pobox.com>
X-Pobox-Relay-ID: F1156892-3D96-11DD-B891-3113EBD4C077-04752483!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On POWER6 processors, cpu-bound programs generally perform better on
the primary thread when the secondary thread is idle than they do on
the secondary thread while the primary thread is idle.  This
difference can be observed by timing a simple shell loop:

for cpumask in 0x1 0x2 ; do
	taskset $cpumask /usr/bin/time -f "%e elapsed, %U user, %S sys" \
		/bin/sh -c "i=1000000 ; while (( i-- )) ; do : ; done"
done

17.05 elapsed, 16.83 user, 0.22 sys
17.54 elapsed, 17.32 user, 0.22 sys

(The first result is for a primary thread; the second result for a
secondary thread.)

So we want the CPU scheduler to slightly favor primary threads on
POWER6.

Add a new cpu feature bit which indicates the need to override the
scheduler's cpu power calculation.

Implement ppc_md.cpu_power for the pseries platform, and scale
secondary threads' cpu power to 97% of the (default) primary threads'
cpu power.  Allow this percentage to be overriden on the kernel
command line via "sec_thread_power_scale=".

Signed-off-by: Nathan Lynch <ntl@pobox.com>
---
 arch/powerpc/platforms/pseries/setup.c |   37 ++++++++++++++++++++++++++++++++
 include/asm-powerpc/cputable.h         |    3 +-
 2 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index f5d29f5..a1141c0 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -501,6 +501,42 @@ void pSeries_power_off(void)
 	for (;;);
 }
 
+/* Percentage by which the cpu power of secondary threads is adjusted */
+static unsigned int sec_thread_power_scale = 97;
+static int __init setup_sec_thread_power_scale(char *str)
+{
+	int power;
+
+	if (get_option(&str, &power) && power > 0 && power <= 100)
+		sec_thread_power_scale = power;
+
+	return 1;
+}
+__setup("sec_thread_power_scale=", setup_sec_thread_power_scale);
+
+static unsigned int pseries_cpu_power(int cpu, unsigned int default_power)
+{
+	struct device_node *np;
+	unsigned int thread, power;
+
+	if (!cpu_has_feature(CPU_FTR_ASYM_POWER))
+		return default_power;
+
+	power = default_power;
+
+	np = of_get_cpu_node(cpu, &thread);
+	WARN_ON(!np);
+	if (!np)
+		goto out;
+
+	/* If this isn't a primary thread, scale the power */
+	if (thread != 0)
+		power = default_power * sec_thread_power_scale / 100;
+out:
+	of_node_put(np);
+	return power;
+}
+
 #ifndef CONFIG_PCI
 void pSeries_final_fixup(void) { }
 #endif
@@ -525,4 +561,5 @@ define_machine(pseries) {
 	.progress		= rtas_progress,
 	.system_reset_exception = pSeries_system_reset_exception,
 	.machine_check_exception = pSeries_machine_check_exception,
+	.cpu_power = pseries_cpu_power,
 };
diff --git a/include/asm-powerpc/cputable.h b/include/asm-powerpc/cputable.h
index 1e79673..eb886a9 100644
--- a/include/asm-powerpc/cputable.h
+++ b/include/asm-powerpc/cputable.h
@@ -152,6 +152,7 @@ extern void do_feature_fixups(unsigned long value, void *fixup_start,
 #define CPU_FTR_UNIFIED_ID_CACHE	ASM_CONST(0x0000000001000000)
 #define CPU_FTR_SPE			ASM_CONST(0x0000000002000000)
 #define CPU_FTR_NEED_PAIRED_STWCX	ASM_CONST(0x0000000004000000)
+#define CPU_FTR_ASYM_POWER		ASM_CONST(0x0000000008000000)
 
 /*
  * Add the 64-bit processor unique features in the top half of the word;
@@ -375,7 +376,7 @@ extern void do_feature_fixups(unsigned long value, void *fixup_start,
 	    CPU_FTR_MMCRA | CPU_FTR_SMT | \
 	    CPU_FTR_COHERENT_ICACHE | CPU_FTR_LOCKLESS_TLBIE | \
 	    CPU_FTR_PURR | CPU_FTR_SPURR | CPU_FTR_REAL_LE | \
-	    CPU_FTR_DSCR)
+	    CPU_FTR_DSCR | CPU_FTR_ASYM_POWER)
 #define CPU_FTRS_CELL	(CPU_FTR_USE_TB | \
 	    CPU_FTR_HPTE_TABLE | CPU_FTR_PPCAS_ARCH_V2 | CPU_FTR_CTRL | \
 	    CPU_FTR_ALTIVEC_COMP | CPU_FTR_MMCRA | CPU_FTR_SMT | \
-- 
1.5.5

