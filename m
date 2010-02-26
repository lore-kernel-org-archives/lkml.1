Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934516Ab0BZLR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 06:17:59 -0500
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:33837 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934166Ab0BZLR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 06:17:57 -0500
Subject: Re: [PATCH] tracing: add event power_frequency to powernow-k8
 driver
From: Robert =?ISO-8859-1?Q?Sch=F6ne?= <robert.schoene@tu-dresden.de>
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, cpufreq@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Feb 2010 12:17:54 +0100
Message-ID: <1267183074.3648.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds frequency tracing to the powernow-k8 cpufreq driver.

Adapted due to comments by:
	* Li Zefan:	* now uses CONFIG_TRACING instead of POWER_TRACER
			* added space after ,
	smp_call_function_single has to be used, as I understand the code
	to be sure, that a frequency change is reported for all affected
	cpu cores. Since the tracing infrastructure always traces events for
	the cpu core reporting that event (one core can't report another cores
	event). Every core has to report this one itself.
	* Bert Wesarg:	* removed tailing ; in macros
			* fixed mail, which breaked long lines
			* added signed-of-by line to mail
	
Signed of by Robert Schoene <robert.schoene@tu-dresden.de>


diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 6e44519..db80be1 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -37,6 +37,10 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 
+#ifdef CONFIG_TRACING
+#include <trace/events/power.h> /* tracing power events */
+# endif /* CONFIG_TRACING */
+
 #include <asm/msr.h>
 
 #include <linux/acpi.h>
@@ -54,6 +58,25 @@ static DEFINE_PER_CPU(struct powernow_k8_data *, powernow_data);
 
 static int cpu_family = CPU_OPTERON;
 
+
+/* only trace power if it is selected */
+#ifdef CONFIG_TRACING
+       /* trace power event on a specific cpu/core */
+       static void trace_power_event(unsigned int *freq){
+               trace_power_frequency(POWER_PSTATE, *freq);
+       }
+
+       #define TRACE_POWER_FREQUENCY_EVENT(i, avail_cores, frequency)         \
+        for_each_cpu(i,avail_cores)                                            \
+               smp_call_function_single(i, trace_power_event, &frequency, 1)
+
+#else /* !CONFIG_TRACING */
+
+       #define TRACE_POWER_FREQUENCY_EVENT(i, avail_cores, frequency)
+
+# endif /* CONFIG_TRACING*/
+
+
 #ifndef CONFIG_SMP
 static inline const struct cpumask *cpu_core_mask(int cpu)
 {
@@ -1074,6 +1097,8 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data,
        res = transition_fid_vid(data, fid, vid);
        freqs.new = find_khz_freq_from_fid(data->currfid);
 
+       TRACE_POWER_FREQUENCY_EVENT(i,data->available_cores, freqs.new);
+
        for_each_cpu(i, data->available_cores) {
                freqs.cpu = i;
                cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
@@ -1107,6 +1132,8 @@ static int transition_frequency_pstate(struct powernow_k8_data *data,
        res = transition_pstate(data, pstate);
        freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);
 
+       TRACE_POWER_FREQUENCY_EVENT(i,data->available_cores, freqs.new);
+
        for_each_cpu(i, data->available_cores) {
                freqs.cpu = i;
                cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);









