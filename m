Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbZBXHJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbZBXHJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 02:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbZBXHJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 02:09:07 -0500
Received: from hpsmtp-eml20.KPNXCHANGE.COM ([213.75.38.85]:46008 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754144AbZBXHJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 02:09:05 -0500
From: Frans Pop <elendil@planet.nl>
To: Dave Jones <davej@redhat.com>
Subject: [PATCH] p4-clockmod: Calculate frequency based on TSC value for P4 models 0 and 1
Date: Tue, 24 Feb 2009 08:08:58 +0100
User-Agent: KMail/1.9.9
Cc: Mattias-Christian Ott <ott@mirix.org>, Dominik Brodowski <linux@brodo.de>,
       Joerg Platte <jplatte@naasa.net>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902240809.01312.elendil@planet.nl>
X-OriginalArrivalTime: 24 Feb 2009 07:09:01.0718 (UTC) FILETIME=[C5383360:01C9964E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias-Christian Ott <ott@mirix.org>

Commit ed9cbcd40004904dbe61ccc16d6106a7de38c998 reverted an incorrect
change that resulted in random frequencies being displayed in some cases
for early P4 models because the MSR_FBC_REGISTER_ID ratio is undefined.
    
Result of the revert is that for some users the CPU frequency is displayed
multiplied by a factor 8 in /proc/cpuinfo when p4-clockmod is loaded.
    
Calculating the frequency from the TSC value should work in all cases.
    
Signed-off-by: Mattias-Christian Ott <ott@mirix.org>
Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: Dominik Brodowski <linux@brodo.de>
Tested-by: Joerg Platte <jplatte@naasa.net>
Cc: Dave Jones <davej@redhat.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
---
This patch has been submitted before, but seems to have gotten lost:
http://bugzilla.kernel.org/show_bug.cgi?id=10968

I'm resubmitting it as it has been verified to solve a post-2.6.24
regression reported by Joerg Platte:
http://www.gossamer-threads.com/lists/linux/kernel/1034291?page=last

I've been unable to find the actual submission mail, so I've created
a new patch description and added the appropriate signed-off lines.

diff --git a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
index b585e04..a4dcc65 100644
--- a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
+++ b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
@@ -30,6 +30,7 @@
 
 #include <asm/processor.h>
 #include <asm/msr.h>
+#include <asm/timer.h>
 #include <asm/timex.h>
 
 #include "speedstep-lib.h"
@@ -217,6 +218,11 @@ static int cpufreq_p4_cpu_init(struct cpufreq_policy *policy)
 		dprintk("has errata -- disabling low frequencies\n");
 	}
 
+	if (speedstep_detect_processor() == SPEEDSTEP_PROCESSOR_P4D && c->x86_model < 2) {
+		/* switch to maximum frequency and measure result */
+		cpufreq_p4_setdc(policy->cpu, DC_DISABLE);
+		recalibrate_cpu_khz();
+	}
 	/* get max frequency */
 	stock_freq = cpufreq_p4_get_frequency(c);
 	if (!stock_freq)
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-lib.c b/arch/x86/kernel/cpu/cpufreq/speedstep-lib.c
index cdac7d6..919644c 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-lib.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-lib.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 
 #include <asm/msr.h>
+#include <asm/tsc.h>
 #include "speedstep-lib.h"
 
 #define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "speedstep-lib", msg)
@@ -167,6 +168,15 @@ static unsigned int pentium4_get_frequency(void)
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 	u32 msr_lo, msr_hi, mult;
 	unsigned int fsb = 0;
+	u8 fsb_code;
+
+	/* Pentium 4 Model 0 and 1 do not have the Core Clock Frequency
+	 * to System Bus Frequency Ratio Field in the Processor Frequency
+	 * Configuration Register of the MSR. Therefore the current
+	 * frequency cannot be calculated and has to be measured.
+	 */
+	if (c->x86_model < 2)
+		return cpu_khz;
 
 	rdmsr(0x2c, msr_lo, msr_hi);
 
@@ -177,21 +187,17 @@ static unsigned int pentium4_get_frequency(void)
 	 * revision #12 in Table B-1: MSRs in the Pentium 4 and
 	 * Intel Xeon Processors, on page B-4 and B-5.
 	 */
-	if (c->x86_model < 2)
+	fsb_code = (msr_lo >> 16) & 0x7;
+	switch (fsb_code) {
+	case 0:
 		fsb = 100 * 1000;
-	else {
-		u8 fsb_code = (msr_lo >> 16) & 0x7;
-		switch (fsb_code) {
-		case 0:
-			fsb = 100 * 1000;
-			break;
-		case 1:
-			fsb = 13333 * 10;
-			break;
-		case 2:
-			fsb = 200 * 1000;
-			break;
-		}
+		break;
+	case 1:
+		fsb = 13333 * 10;
+		break;
+	case 2:
+		fsb = 200 * 1000;
+		break;
 	}
 
 	if (!fsb)
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 599e581..19ccb3b 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -524,7 +524,6 @@ unsigned long native_calibrate_tsc(void)
 }
 
 #ifdef CONFIG_X86_32
-/* Only called from the Powernow K7 cpu freq driver */
 int recalibrate_cpu_khz(void)
 {
 #ifndef CONFIG_SMP
