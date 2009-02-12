Return-Path: <linux-kernel-owner+w=401wt.eu-S1759441AbZBLMkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbZBLMkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758790AbZBLMih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:38:37 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49215 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758760AbZBLMif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:38:35 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212137.750180365@firstfloor.org>
In-Reply-To: <20090212137.750180365@firstfloor.org>
To: akpm@linux-foundation.org, x86@firstfloor.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [6/10] x86: MCE: Disable machine checks on offlined CPUs.
Message-Id: <20090212123725.59A063E6671@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:37:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Lower priority bug fix

Offlined CPUs could still get machine checks, but the machine check handler
cannot handle them properly, leading to an unconditional crash. Disable 
machine checks on CPUs that are going down.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 12:10:54.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 12:12:26.000000000 +0100
@@ -881,6 +881,27 @@
 	cpu_clear(cpu, mce_device_initialized);
 }
 
+/* Make sure there are no machine checks on offlined CPUs. */
+static void __cpuexit mce_disable_cpu(void *h)
+{
+	int i;
+
+	if (!mce_available(&current_cpu_data))
+		return;
+	for (i = 0; i < banks; i++)
+		wrmsrl(MSR_IA32_MC0_CTL + i*4, 0);
+}
+
+static void __cpuexit mce_reenable_cpu(void *h)
+{
+	int i;
+
+	if (!mce_available(&current_cpu_data))
+		return;
+	for (i = 0; i < banks; i++)
+		wrmsrl(MSR_IA32_MC0_CTL + i*4, bank[i]);
+}
+
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
 static int __cpuinit mce_cpu_callback(struct notifier_block *nfb,
 				      unsigned long action, void *hcpu)
@@ -904,11 +925,13 @@
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
 		del_timer_sync(t);
+		smp_call_function_single(cpu, mce_disable_cpu, NULL, 1);
 		break;
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
 		t->expires = round_jiffies_relative(jiffies + next_interval);
 		add_timer_on(t, cpu);
+		smp_call_function_single(cpu, mce_reenable_cpu, NULL, 1);
 		break;
 	}
 	return NOTIFY_OK;
