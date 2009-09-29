Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbZI2VYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbZI2VYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 17:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZI2VYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 17:24:45 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:34476
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751609AbZI2VYo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 17:24:44 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KQR4ST-02-NO2-02
X-M-MSG: 
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: linux-kernel@vger.kernel.org, bhavna.sarathy@amd.com, davej@redhat.com
Subject: [PATCH] Option to synchronize P-states for  AMD family 0xf
Date: Tue, 29 Sep 2009 16:23:55 -0500
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <200909291623.56130.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 29 Sep 2009 21:24:29.0658 (UTC) FILETIME=[3AB20BA0:01CA414B]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 32ff8fa36d4ef680d512430b0e2ac008d76b06b9 Mon Sep 17 00:00:00 2001
From: Mark Langsdorf <mark.langsdorf@amd.com>
Date: Tue, 29 Sep 2009 15:50:41 -0500
Subject: [PATCH] Option to synchronize P-states for  AMD family 0xf

AMD Family 0xf processors (Athlon 64s and Opterons) do not
have P-State or C-State invariant TSCs.  Instead, the TSC
increments at the current processor frequency, which makes
it unstable and unreliable if cpufreq is enabled.

This patch introduces a new command parameter for the
PowerNow! driver called "tscsync".  When tscsync is
set to 1, the driver forces all processors in the system
to change frequency as the same time to the same frequency.
This unified change means that all the TSCs in the system
increment at the same rate.

The patch also automatically turns off the C1 clocking
ramping in some family 0xf processors when "tscsync" is
enabled.

If tscsync is enabled, the TSCs appear to monotonically
increment if the TSC clocksource is enabled with
"clocksource=tsc".  There is still some drift compared
to wall clock, on the order of a second per hour.

AMD customers have requested the ability to use TSC for
time-stamping on large databases while still having
cpufreq style power management.  Other clocksources
cause serious performance issues on large databases
that attempt gtod 10s of 1000s of times per second.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |  129 +++++++++++++++++++++++++++--
 1 files changed, 123 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 6394aa5..fd12291 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -37,6 +37,10 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 
+#include <linux/pci_ids.h>
+#include <linux/pci.h>
+#include <asm/k8.h>
+
 #include <asm/msr.h>
 
 #include <linux/acpi.h>
@@ -53,6 +57,8 @@ static DEFINE_MUTEX(fidvid_mutex);
 static DEFINE_PER_CPU(struct powernow_k8_data *, powernow_data);
 
 static int cpu_family = CPU_OPTERON;
+static int *req_state;
+static int tscsync;
 
 #ifndef CONFIG_SMP
 static inline const struct cpumask *cpu_core_mask(int cpu)
@@ -193,6 +199,16 @@ static int write_new_fid(struct powernow_k8_data *data, u32 fid)
 	dprintk("writing fid 0x%x, lo 0x%x, hi 0x%x\n",
 		fid, lo, data->plllock * PLL_LOCK_CONVERSION);
 
+	if (unlikely(tscsync)) {
+		int i;
+		cpumask_t oldmask = current->cpus_allowed;
+		for_each_online_cpu(i) {
+			set_cpus_allowed_ptr(current, &cpumask_of_cpu(i));
+			wrmsr(MSR_FIDVID_CTL, lo & ~MSR_C_LO_INIT_FID_VID,
+				data->plllock * PLL_LOCK_CONVERSION);
+		}
+		set_cpus_allowed_ptr(current, &oldmask);
+	}
 	do {
 		wrmsr(MSR_FIDVID_CTL, lo, data->plllock * PLL_LOCK_CONVERSION);
 		if (i++ > 100) {
@@ -241,6 +257,17 @@ static int write_new_vid(struct powernow_k8_data *data, u32 vid)
 	dprintk("writing vid 0x%x, lo 0x%x, hi 0x%x\n",
 		vid, lo, STOP_GRANT_5NS);
 
+	if (unlikely(tscsync)) {
+		int i;
+		cpumask_t oldmask = current->cpus_allowed;
+		for_each_online_cpu(i) {
+			set_cpus_allowed_ptr(current, &cpumask_of_cpu(i));
+			wrmsr(MSR_FIDVID_CTL, lo & ~MSR_C_LO_INIT_FID_VID,
+				STOP_GRANT_5NS);
+		}
+		set_cpus_allowed_ptr(current, &oldmask);
+	}
+
 	do {
 		wrmsr(MSR_FIDVID_CTL, lo, STOP_GRANT_5NS);
 		if (i++ > 100) {
@@ -389,7 +416,8 @@ static int core_frequency_transition(struct powernow_k8_data *data, u32 reqfid)
 	u32 fid_interval, savevid = data->currvid;
 
 	if (data->currfid == reqfid) {
-		printk(KERN_ERR PFX "ph2 null fid transition 0x%x\n",
+		if (!tscsync)
+			printk(KERN_ERR PFX "ph2 null fid transition 0x%x\n",
 				data->currfid);
 		return 0;
 	}
@@ -1039,9 +1067,21 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data,
 	u32 vid = 0;
 	int res, i;
 	struct cpufreq_freqs freqs;
+	cpumask_t changing_cores;
 
 	dprintk("cpu %d transition to index %u\n", smp_processor_id(), index);
 
+	/* if all the processors are transitioning in sync, find the
+	 * high current state and go to that
+	 */
+	if (tscsync && req_state) {
+		for_each_cpu(i, cpu_core_mask(smp_processor_id()))
+			req_state[i] = index;
+		for_each_online_cpu(i)
+			if (req_state[i] < index)
+				index = req_state[i];
+	}
+
 	/* fid/vid correctness check for k8 */
 	/* fid are the lower 8 bits of the index we stored into
 	 * the cpufreq frequency table in find_psb_table, vid
@@ -1066,7 +1106,11 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data,
 	freqs.old = find_khz_freq_from_fid(data->currfid);
 	freqs.new = find_khz_freq_from_fid(fid);
 
-	for_each_cpu(i, data->available_cores) {
+	if (tscsync)
+		changing_cores = *cpu_online_mask;
+	else
+		changing_cores = *data->available_cores;
+	for_each_cpu(i, &changing_cores) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -1074,9 +1118,17 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data,
 	res = transition_fid_vid(data, fid, vid);
 	freqs.new = find_khz_freq_from_fid(data->currfid);
 
-	for_each_cpu(i, data->available_cores) {
+	for_each_cpu(i, &changing_cores) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
+		if (tscsync) {
+			struct powernow_k8_data *tsc_data = NULL;
+			tsc_data = per_cpu(powernow_data, i);
+			if (!tsc_data)
+				continue;
+			tsc_data->currfid = data->currfid;
+			tsc_data->currvid = data->currvid;
+		}
 	}
 	return res;
 }
@@ -1155,10 +1207,11 @@ static int powernowk8_target(struct cpufreq_policy *pol,
 		dprintk("targ: curr fid 0x%x, vid 0x%x\n",
 		data->currfid, data->currvid);
 
-		if ((checkvid != data->currvid) ||
-		    (checkfid != data->currfid)) {
+		if (!tscsync &&
+		    ((checkvid != data->currvid) ||
+		     (checkfid != data->currfid))) {
 			printk(KERN_INFO PFX
-				"error - out of sync, fix 0x%x 0x%x, "
+				"error - out of sync, fid 0x%x 0x%x, "
 				"vid 0x%x 0x%x\n",
 				checkfid, data->currfid,
 				checkvid, data->currvid);
@@ -1177,6 +1230,7 @@ static int powernowk8_target(struct cpufreq_policy *pol,
 		ret = transition_frequency_pstate(data, newstate);
 	else
 		ret = transition_frequency_fidvid(data, newstate);
+
 	if (ret) {
 		printk(KERN_ERR PFX "transition frequency failed\n");
 		ret = 1;
@@ -1208,6 +1262,39 @@ static int powernowk8_verify(struct cpufreq_policy *pol)
 	return cpufreq_frequency_table_verify(pol, data->powernow_table);
 }
 
+/*
+ * On a family 0xf MP system that is transitioning in sync, adjust
+ * the vids for each frequency to the highest vid for that frequency
+ * on all cores.  Otherwise, systems with different steppings in
+ * them may fail due to under voltage.
+ */
+static void sync_tables(int curcpu)
+{
+	int j;
+	struct powernow_k8_data *idata = NULL;
+	struct powernow_k8_data *jdata = per_cpu(powernow_data, curcpu);
+	for (j = 0; j < jdata->numps; j++) {
+		int i;
+		int maxvid = 0;
+		for_each_online_cpu(i) {
+			int testvid;
+			idata = per_cpu(powernow_data, i);
+			if (!idata || !idata->powernow_table)
+				continue;
+			testvid = idata->powernow_table[j].index & 0xff00;
+			if (testvid > maxvid)
+				maxvid = testvid;
+		}
+		for_each_online_cpu(i) {
+			idata = per_cpu(powernow_data, i);
+			if (!idata || idata->powernow_table)
+				continue;
+			idata->powernow_table[j].index &= 0xff00;
+			idata->powernow_table[j].index |= maxvid;
+		}
+	}
+}
+
 struct init_on_cpu {
 	struct powernow_k8_data *data;
 	int rc;
@@ -1327,6 +1414,19 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 			data->currfid, data->currvid);
 
 	per_cpu(powernow_data, pol->cpu) = data;
+	if (tscsync && (cpu_family == CPU_OPTERON)) {
+		u32 i;
+		sync_tables(pol->cpu);
+
+		for (i = 0; i < num_k8_northbridges; i++) {
+			struct pci_dev *dev = k8_northbridges[i];
+			u8 tmp;
+
+			pci_read_config_byte(dev, 0x87, &tmp);
+			tmp &= 0xFC;
+			pci_write_config_byte(dev, 0x87, tmp);
+		}
+	}
 
 	return 0;
 
@@ -1416,6 +1516,17 @@ static int __cpuinit powernowk8_init(void)
 	}
 
 	if (supported_cpus == num_online_cpus()) {
+		if (tscsync) {
+			printk(KERN_INFO PFX "Enabling synchronized switching for TSC support.\n");
+			req_state = kzalloc(sizeof(int) * 
+				supported_cpus, GFP_KERNEL);
+			for (i = 0; i < supported_cpus; i++)
+				req_state[i] = 10;
+			if (!req_state) {
+				printk(KERN_ERR PFX "Unable to allocate mem\n");
+				return -ENOMEM;
+			}
+		}
 		printk(KERN_INFO PFX "Found %d %s "
 			"processors (%d cpu cores) (" VERSION ")\n",
 			num_online_nodes(),
@@ -1431,6 +1542,9 @@ static void __exit powernowk8_exit(void)
 {
 	dprintk("exit\n");
 
+	if (tscsync)
+		kfree(req_state);
+
 	cpufreq_unregister_driver(&cpufreq_amd64_driver);
 }
 
@@ -1441,3 +1555,6 @@ MODULE_LICENSE("GPL");
 
 late_initcall(powernowk8_init);
 module_exit(powernowk8_exit);
+
+module_param(tscsync, int, 0444);
+MODULE_PARM_DESC(tscsync, "Synchronize PowerNow! changes so as to allow the TSC to be used even though it isn't actually P-state invariant");
-- 
1.6.0.2


