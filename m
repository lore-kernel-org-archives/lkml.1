Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975Ab0BYKR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:17:59 -0500
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:37645 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756652Ab0BYKR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:17:56 -0500
Subject: [PATCH] tracing: add event power_frequency to powernow-k8 driver
From: Robert =?ISO-8859-1?Q?Sch=F6ne?= <robert.schoene@tu-dresden.de>
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Feb 2010 11:17:55 +0100
Message-ID: <1267093075.3369.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds frequency tracing to the powernow-k8 cpufreq driver

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 6e44519..99034e7 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -37,6 +37,10 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 
+#ifdef CONFIG_POWER_TRACER
+#include <trace/events/power.h> /* tracing power events */
+# endif /* CONFIG_POWER_TRACER */
+
 #include <asm/msr.h>
 
 #include <linux/acpi.h>
@@ -54,6 +58,25 @@ static DEFINE_PER_CPU(struct powernow_k8_data *,
powernow_data);
 
 static int cpu_family = CPU_OPTERON;
 
+
+/* only trace power if it is selected */
+#ifdef CONFIG_POWER_TRACER
+       /* trace power event on a specific cpu/core */
+       static void trace_power_event(unsigned int *freq){
+               trace_power_frequency(POWER_PSTATE, *freq);
+       }
+
+       #define TRACE_POWER_FREQUENCY_EVENT(i,avail_cores, frequency)
\
+        for_each_cpu(i,avail_cores)
\
+               smp_call_function_single(i, trace_power_event,
&frequency, 1);
+
+#else /* !CONFIG_POWER_TRACER */
+
+       #define TRACE_POWER_FREQUENCY_EVENT(i,avail_cores, frequency) ;
+
+# endif /* end CONFIG_POWER_TRACER */
+
+
 #ifndef CONFIG_SMP
 static inline const struct cpumask *cpu_core_mask(int cpu)
 {
@@ -1074,6 +1097,8 @@ static int transition_frequency_fidvid(struct
powernow_k8_data *data,
        res = transition_fid_vid(data, fid, vid);
        freqs.new = find_khz_freq_from_fid(data->currfid);
 
+       TRACE_POWER_FREQUENCY_EVENT(i,data->available_cores, freqs.new);
+
        for_each_cpu(i, data->available_cores) {
                freqs.cpu = i;
                cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
@@ -1107,6 +1132,8 @@ static int transition_frequency_pstate(struct
powernow_k8_data *data,
        res = transition_pstate(data, pstate);
        freqs.new = find_khz_freq_from_pstate(data->powernow_table,
pstate);
 
+       TRACE_POWER_FREQUENCY_EVENT(i,data->available_cores, freqs.new);
+
        for_each_cpu(i, data->available_cores) {
                freqs.cpu = i;
                cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);




-- 
Robert Schoene
Technische Universitaet Dresden
Zentrum fuer Informationsdienste und Hochleistungsrechnen
01062 Dresden

Tel.: (0351) 463-42483, Fax: (0351) 463-37773
E-Mail: Robert.Schoene@tu-dresden.de

