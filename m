Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbZFBOA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbZFBOA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbZFBOAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:00:48 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38476 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438AbZFBOAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:00:47 -0400
Subject: Performance regression in 2.6.30-rc1
From: poornima nayak <mpnayak@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, svaidy@linux.vnet.ibm.com, davej@redhat.com,
       ego@in.ibm.com
Content-Type: multipart/mixed; boundary="=-HwoJ+dvJ99MXrCoiRek1"
Date: Tue, 02 Jun 2009 16:30:19 +0530
Message-Id: <1243940419.6885.48.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HwoJ+dvJ99MXrCoiRek1
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi 

By executing kernbench on 2.6.30-rc1 we observed there is a performance
regression in 2.6.30-rc1. Then git-bisect was done between v2.6.29 and
v2.6.30-rc5, after 13 iterations identified the attached patch is
causing regression.

Performance data of 2.6.29 without applying the attached patch.
param-version
testname
elapsed-avg
elapsed-std
2.6.29'
pm_kernbench.Version-none-threads=2-sched_mc=2
             221.1
              0.81
2.6.29'
pm_kernbench.Version-none-threads=4-sched_mc=0
            115.09
               0.6
2.6.29'
pm_kernbench.Version-none-threads=4-sched_mc=2
            109.05
              0.25
2.6.29'
pm_kernbench.Version-none-threads=8-sched_mc=2
              60.4
              0.38
2.6.29'
pm_kernbench.Version-none-threads=8-sched_mc=0
             65.23
              0.34
2.6.29'
pm_kernbench.Version-none-threads=2-sched_mc=0
            231.61
              0.59

Performance data of 2.6.29 after applying the attached patch.
param-version
testname
elapsed-avg
elapsed-std
2.6.29'
pm_kernbench.Version-thir-bisect-threads=2-sched_mc=0
            203.77
              0.48
2.6.29'
pm_kernbench.Version-thir-bisect-threads=8-sched_mc=0
             64.38
              0.25
2.6.29'
pm_kernbench.Version-thir-bisect-threads=4-sched_mc=0
            102.46
               0.1
2.6.29'
pm_kernbench.Version-thir-bisect-threads=8-sched_mc=2
             59.94
              0.46
2.6.29'
pm_kernbench.Version-thir-bisect-threads=4-sched_mc=2
            106.84
              0.28
2.6.29'
pm_kernbench.Version-thir-bisect-threads=2-sched_mc=2
            199.44
              0.44

Performance issue here is when sched_mc_power_savings is set 2 and
kernbench is triggered with 4 threads the value of 'elapsed time' is
more then sched_mc_power_savings is set to 0. Expectation is elapsed
time should be less when sched_mc_power_savings set 2 compared to
sched_mc_power_savings set to 0.

Regds
Poornima

--=-HwoJ+dvJ99MXrCoiRek1
Content-Disposition: attachment; filename="performance_reg.patch"
Content-Type: text/x-patch; name="performance_reg.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 4b1c319..89c676d 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -680,6 +680,18 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 			    perf->states[i].transition_latency * 1000;
 	}
 
+	/* Check for high latency (>20uS) from buggy BIOSes, like on T42 */
+	if (perf->control_register.space_id == ACPI_ADR_SPACE_FIXED_HARDWARE &&
+	    policy->cpuinfo.transition_latency > 20 * 1000) {
+		static int print_once;
+		policy->cpuinfo.transition_latency = 20 * 1000;
+		if (!print_once) {
+			print_once = 1;
+			printk(KERN_INFO "Capping off P-state tranision latency"
+				" at 20 uS\n");
+		}
+	}
+
 	data->max_freq = perf->states[0].core_frequency * 1000;
 	/* table init */
 	for (i=0; i<perf->state_count; i++) {

--=-HwoJ+dvJ99MXrCoiRek1--

