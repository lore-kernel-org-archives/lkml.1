Return-Path: <linux-kernel-owner+w=401wt.eu-S1760692AbZLOSIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692AbZLOSIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 13:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760057AbZLOSIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 13:08:43 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:13466 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbZLOSIm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 13:08:42 -0500
From: "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
CC: "davej@redhat.com" <davej@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "mjg@redhat.com" <mjg@redhat.com>, "trenn@suse.de" <trenn@suse.de>,
       "lenb@kernel.org" <lenb@kernel.org>
Date: Tue, 15 Dec 2009 18:08:08 +0000
Subject: RE: [PATCH] cpufreq: Processor Clocking Control interface driver
Thread-Topic: [PATCH] cpufreq: Processor Clocking Control interface driver
Thread-Index: Acp6t25fuUX9ge7TSNWagCVgfwYj3wC5SNqw
Message-ID: <66D9D2F0CDB5C9428E6166B01EC85EE161DEEE3CB7@GVW0676EXC.americas.hpqcorp.net>
References: <20091128034424.6796.75673.sendpatchset@localhost.localdomain>
 <20091211231233.GA4291@isilmar.linta.de>
In-Reply-To: <20091211231233.GA4291@isilmar.linta.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I have addressed your concerns below: 

>-----Original Message-----
>From: Dominik Brodowski [mailto:linux@dominikbrodowski.net] 
>Sent: Friday, December 11, 2009 5:13 PM
>To: Chumbalkar, Nagananda
>Cc: davej@redhat.com; linux-kernel@vger.kernel.org; 
>cpufreq@vger.kernel.org; linux-acpi@vger.kernel.org; 
>mjg@redhat.com; trenn@suse.de; lenb@kernel.org
>Subject: Re: [PATCH] cpufreq: Processor Clocking Control 
>interface driver
>
>Hey,
>
>On Fri, Dec 11, 2009 at 10:55:40PM +0000, Naga Chumbalkar wrote:
>> +The VERSION number for the driver will be of the format v.xy.ab.
>> +eg: 1.00.02
>> +   ----- --
>> +    |    |
>> +    |    -- this will increase with bug fixes/enhancements 
>to the driver
>> +    |-- this is the version of the PCC specification the 
>driver adheres to
>
>If this is _really_ necessary... Doesn't the driver version 
>relate to some
>Linux kernel version anyway?
>

If distros backport this driver to different kernel versions, it will be
easy to keep track of which driver version is in the distro.


>> +2.1 scaling_available_frequencies:
>> +----------------------------------
>> +scaling_available_frequencies indicates the minimum and 
>maximum speed
>> +the CPU can take as advertised by the BIOS. No intermediate 
>frequencies are
>> +listed because the BIOS will try to achieve any 
>intermediate frequency
>> +requested by the governor. An intermediate frequency does 
>not have to be
>> +strictly associated with a P-state.
>
>Why do you export scaling_available_frequencies anyway? It's 
>made available
>by the _optional_ freq-table helper module, which is wrong to 
>use in this
>case anyway.
>

You are correct. I don't need the dependency on CPU_FREQ_TABLE. I ripped
it out and made suitable changes:

diff -bur orig/pcc-cpufreq.c fix/pcc-cpufreq.c
--- orig/pcc-cpufreq.c	2009-11-30 20:05:23.000000000 -0600
+++ fix/pcc-cpufreq.c	2009-11-30 21:14:31.000000000 -0600
@@ -111,15 +111,11 @@
 
 static struct pcc_cpu *pcc_cpu_info;
 
-static struct cpufreq_frequency_table pcc_freq_table[] = {
-	{0x1, 0},
-	{0x2, 0},
-	{0, CPUFREQ_TABLE_END},
-};
-
 static int pcc_cpufreq_verify(struct cpufreq_policy *policy)
 {
-	return cpufreq_frequency_table_verify(policy, pcc_freq_table);
+	cpufreq_verify_within_limits(policy, policy->cpuinfo.min_freq,
+				     policy->cpuinfo.max_freq);
+	return 0;
 }
 
 static inline void pcc_cmd(void)
@@ -534,10 +530,6 @@
 		goto pcch_free;
 	}
 
-	pcc_freq_table[0].frequency =
-		ioread32(&pcch_hdr->minimum_frequency) * 1000;
-	pcc_freq_table[1].frequency = ioread32(&pcch_hdr->nominal) * 1000;
-
 	printk(KERN_DEBUG "pcc-cpufreq: (v%s) driver loaded with frequency"
 	       " limits: %d MHz, %d MHz\n", PCC_VERSION,
 	       ioread32(&pcch_hdr->minimum_frequency),
@@ -576,12 +568,6 @@
 	dprintk("init: policy->max is %d, policy->min is %d\n",
 		policy->max, policy->min);
 
-	result = cpufreq_frequency_table_cpuinfo(policy, pcc_freq_table);
-	if (result)
-		goto free;
-
-	cpufreq_frequency_table_get_attr(pcc_freq_table, policy->cpu);
-
 	return 0;
 free:
 	pcc_clear_mapping();
@@ -592,15 +578,9 @@
 
 static int pcc_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 {
-	cpufreq_frequency_table_put_attr(policy->cpu);
 	return 0;
 }
 
-static struct freq_attr *pcc_cpufreq_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
 static struct cpufreq_driver pcc_cpufreq_driver = {
 	.flags = CPUFREQ_CONST_LOOPS,
 	.get = pcc_get_freq,
@@ -610,7 +590,6 @@
 	.exit = pcc_cpufreq_cpu_exit,
 	.name = "pcc-cpufreq",
 	.owner = THIS_MODULE,
-	.attr = pcc_cpufreq_attr,
 };
 
 static int __init pcc_cpufreq_init(void)


diff -bur orig/pcc-cpufreq.txt fix/pcc-cpufreq.txt
--- orig/pcc-cpufreq.txt	2009-11-30 20:05:55.000000000 -0600
+++ fix/pcc-cpufreq.txt	2009-11-30 21:15:10.000000000 -0600
@@ -152,11 +152,10 @@
 
 2.1 scaling_available_frequencies:
 ----------------------------------
-scaling_available_frequencies indicates the minimum and maximum speed
-the CPU can take as advertised by the BIOS. No intermediate frequencies are
-listed because the BIOS will try to achieve any intermediate frequency
-requested by the governor. An intermediate frequency does not have to be
-strictly associated with a P-state.
+scaling_available_frequencies is not created in /sys. No intermediate
+frequencies need to be listed because the BIOS will try to achieve any
+frequency, within limits, requested by the governor. A frequency does not have
+to be strictly associated with a P-state.
 
 2.2 cpuinfo_transition_latency:
 -------------------------------
@@ -203,7 +202,7 @@
 
 3. Caveats:
 -----------
-Currently, the "cpufreq_stats" module in its present form cannot be loaded and
-expected to work with the PCC driver. A patch to cpufreq_stats will be
-submitted to fix this.
+The "cpufreq_stats" module in its present form cannot be loaded and
+expected to work with the PCC driver. Since the "cpufreq_stats" module
+provides information wrt each P-state, it is not applicable to the PCC driver.
 


>> +2.2 cpuinfo_transition_latency:
>> +-------------------------------
>> +The cpuinfo_transition_latency field is 0. The PCC 
>specification does
>> +not include a field to expose this value currently.
>
>Uh, bad specification... So does it work properly with ondemand and/or
>conservative (which read out this field, and if latency=0 use a minimum
>value)?
>

Yes, it works fine. Both "ondemand" and "conservative" sanitize the
latency value, and set it to a default value which is good.

>> +config X86_PCC_CPUFREQ
>> +	tristate "Processor Clocking Control interface driver"
>> +	select CPU_FREQ_TABLE
>Uh, see above.
>

diff -bur orig/Kconfig fix/Kconfig
--- orig/Kconfig	2009-11-30 20:05:32.000000000 -0600
+++ fix/Kconfig	2009-11-30 21:14:47.000000000 -0600
@@ -12,7 +12,6 @@
 
 config X86_PCC_CPUFREQ
 	tristate "Processor Clocking Control interface driver"
-	select CPU_FREQ_TABLE
 	depends on ACPI && ACPI_PROCESSOR
 	help
 	  This driver adds support for the PCC interface.


>> +static int pcc_cpufreq_verify(struct cpufreq_policy *policy)
>> +{
>> +	return cpufreq_frequency_table_verify(policy, pcc_freq_table);
>> +}
>
>Well, AFAICS, this limits the whole interface to two values: 
>min or max. So
>let's allow for any intermediate value:
>
>static int pcc_cpufreq_verify(struct cpufreq_policy *policy)
>{
>	cpufreq_verify_within_limits(policy, 
>policy->cpuinfo.min_freq, policy->cpuinfo.max_freq);
>}
>

Took this suggestion, (see the first "diff" changeset above), especially
since I cannot use the freq-table helper function anymore.


>but well... later on, you check this
>
>> +	if (target_freq <= 
>(ioread32(&pcch_hdr->minimum_frequency) * 1000)) {
>> +		target_freq = 
>ioread32(&pcch_hdr->minimum_frequency) * 1000;
>> +		dprintk("target: target_freq for cpu %d was 
>below limit, "
>> +			"converted it to %d\n", cpu, target_freq);
>> +	}
>
>why not do this in the _verify() step? Does pcch_hdr->minimum_frequency
>even change "on the fly"?

pcch_hdr->minimum_frequency does not change "on the fly". Also, there is no
need for those IO accesses:

diff -bur orig/pcc-cpufreq.c fix/pcc-cpufreq.c
--- orig/pcc-cpufreq.c	2009-12-15 10:52:01.000000000 -0600
+++ fix/pcc-cpufreq.c	2009-12-15 10:52:06.000000000 -0600
@@ -212,12 +212,18 @@
 
 	pcc_cpu_data = per_cpu_ptr(pcc_cpu_info, cpu);
 
-	if (target_freq <= (ioread32(&pcch_hdr->minimum_frequency) * 1000)) {
-		target_freq = ioread32(&pcch_hdr->minimum_frequency) * 1000;
+	if (target_freq < policy->min) {
+		target_freq = policy->min;
 		dprintk("target: target_freq for cpu %d was below limit, "
 			"converted it to %d\n", cpu, target_freq);
 	}
 
+	if (target_freq > policy->max) {
+		target_freq = policy->max;
+		dprintk("target: target_freq for cpu %d was above limit, "
+			"converted it to %d\n", cpu, target_freq);
+	}
+
 	dprintk("target: CPU %d should go to target freq: %d "
 		"(virtual) input_offset is 0x%x\n",
 		cpu, target_freq,

>
>So, I'd propose to NACK this patch at the moment.
>
>Best,
>	Dominik
>

If you are okay with the changes, I will send v2 of the patch.

Thanks,
- naga -

