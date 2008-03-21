Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbYCUAoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbYCUAoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 20:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYCUAn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 20:43:59 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40686 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbYCUAn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 20:43:58 -0400
Date: Thu, 20 Mar 2008 17:43:54 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: cpufreq@lists.linux.org.uk
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: [PATCH] cpufreq: Expose cpufreq coordination requirements
	regardless of coordination mechanism
Message-ID: <20080321004354.GQ5529@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, affected_cpus shows which CPUs need to have their frequency
coordinated in software.  When hardware coordination is in use, the
contents of this file appear the same as when no coordination is
required.  This can lead to some confusion among user-space programs,
for example, that do not know that extra coordination is required to
force a CPU core to a particular speed to control power consumption.

To fix this, create a "related_cpus" attribute that always displays
the coordination map regardless of whatever coordination strategy
the cpufreq driver uses (sw or hw).  If the cpufreq driver does not
provide a value, fall back to policy->cpus.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    1 +
 drivers/cpufreq/cpufreq.c                  |   29 +++++++++++++++++++++++-----
 include/linux/cpufreq.h                    |    3 ++-
 3 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index a962dcb..2e21d35 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -591,6 +591,7 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	    policy->shared_type == CPUFREQ_SHARED_TYPE_ANY) {
 		policy->cpus = perf->shared_cpu_map;
 	}
+	policy->related_cpus = perf->shared_cpu_map;
 
 #ifdef CONFIG_SMP
 	dmi_check_system(sw_any_bug_dmi_table);
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 35a26a3..38bf03f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -582,15 +582,13 @@ out:
 	i += sprintf(&buf[i], "\n");
 	return i;
 }
-/**
- * show_affected_cpus - show the CPUs affected by each transition
- */
-static ssize_t show_affected_cpus (struct cpufreq_policy * policy, char *buf)
+
+static ssize_t show_cpus(cpumask_t mask, char *buf)
 {
 	ssize_t i = 0;
 	unsigned int cpu;
 
-	for_each_cpu_mask(cpu, policy->cpus) {
+	for_each_cpu_mask(cpu, mask) {
 		if (i)
 			i += scnprintf(&buf[i], (PAGE_SIZE - i - 2), " ");
 		i += scnprintf(&buf[i], (PAGE_SIZE - i - 2), "%u", cpu);
@@ -601,6 +599,25 @@ static ssize_t show_affected_cpus (struct cpufreq_policy * policy, char *buf)
 	return i;
 }
 
+/**
+ * show_related_cpus - show the CPUs affected by each transition even if
+ * hw coordination is in use
+ */
+static ssize_t show_related_cpus(struct cpufreq_policy *policy, char *buf)
+{
+	if (cpus_empty(policy->related_cpus))
+		return show_cpus(policy->cpus, buf);
+	return show_cpus(policy->related_cpus, buf);
+}
+
+/**
+ * show_affected_cpus - show the CPUs affected by each transition
+ */
+static ssize_t show_affected_cpus(struct cpufreq_policy *policy, char *buf)
+{
+	return show_cpus(policy->cpus, buf);
+}
+
 static ssize_t store_scaling_setspeed(struct cpufreq_policy *policy,
 		const char *buf, size_t count)
 {
@@ -645,6 +662,7 @@ define_one_ro(cpuinfo_max_freq);
 define_one_ro(scaling_available_governors);
 define_one_ro(scaling_driver);
 define_one_ro(scaling_cur_freq);
+define_one_ro(related_cpus);
 define_one_ro(affected_cpus);
 define_one_rw(scaling_min_freq);
 define_one_rw(scaling_max_freq);
@@ -657,6 +675,7 @@ static struct attribute * default_attrs[] = {
 	&scaling_min_freq.attr,
 	&scaling_max_freq.attr,
 	&affected_cpus.attr,
+	&related_cpus.attr,
 	&scaling_governor.attr,
 	&scaling_driver.attr,
 	&scaling_available_governors.attr,
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index ddd8652..a881fd6 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -83,7 +83,8 @@ struct cpufreq_real_policy {
 };
 
 struct cpufreq_policy {
-	cpumask_t		cpus;	/* affected CPUs */
+	cpumask_t		cpus;	/* CPUs requiring sw coordination */
+	cpumask_t		related_cpus; /* CPUs with any coordination */
 	unsigned int		shared_type; /* ANY or ALL affected CPUs
 						should set cpufreq */
 	unsigned int		cpu;    /* cpu nr of registered CPU */
