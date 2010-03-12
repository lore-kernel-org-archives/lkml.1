Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858Ab0CLNSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 08:18:12 -0500
Received: from mailout2.zih.tu-dresden.de ([141.30.67.73]:35778 "EHLO
	mailout2.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932293Ab0CLNSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 08:18:09 -0500
Subject: [PATCH] trace power_frequency events on the correct cpu  (for
 Intel x86 CPUs)
From: Robert =?ISO-8859-1?Q?Sch=F6ne?= <robert.schoene@tu-dresden.de>
To: Dave Jones <davej@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       cpufreq <cpufreq@vger.kernel.org>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Mar 2010 14:17:43 +0100
Message-ID: <1268399863.3407.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-TUD-Virus-Scanned: mailout2.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following behaviour:
Currently, the power_frequency event is reported for the cpu (core) which initiated the frequency change.
It should be reported for the cpu that actually changes its frequency.

Example: when using 
 taskset -c 0 echo <new_frequency> > /sys/devices/system/cpu/cpu1/cpufreq/scaling_setspeed
cpu 0 is traced, instead of cpu 1

Signed of by Robert Schoene <robert.schoene@tu-dresden.de>


diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 1b1920f..0a47f10 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -174,6 +174,7 @@ static void do_drv_write(void *_cmd)
 
        switch (cmd->type) {
        case SYSTEM_INTEL_MSR_CAPABLE:
+               trace_power_frequency(POWER_PSTATE, cmd->val);
                rdmsr(cmd->addr.msr.reg, lo, hi);
                lo = (lo & ~INTEL_MSR_RANGE) | (cmd->val & INTEL_MSR_RANGE);
                wrmsr(cmd->addr.msr.reg, lo, hi);
@@ -363,7 +364,6 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
                }
        }
 
-       trace_power_frequency(POWER_PSTATE, data->freq_table[next_state].frequency);
 
        switch (data->cpu_feature) {
        case SYSTEM_INTEL_MSR_CAPABLE:


