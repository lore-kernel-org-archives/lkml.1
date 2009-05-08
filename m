Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbZEHDrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbZEHDrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 23:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZEHDrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 23:47:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:1688 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787AbZEHDrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 23:47:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,314,1239001200"; 
   d="scan'208";a="410571179"
Subject: [PATCH] x86 MCE: shut up lockdep warning
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 08 May 2009 11:47:09 +0800
Message-Id: <1241754429.4444.12.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lockdep report below warning when I try to offline one cpu:
[  110.835487] =================================
[  110.835616] [ INFO: inconsistent lock state ]
[  110.835688] 2.6.30-rc4-00336-g8c9ed89 #52
[  110.835757] ---------------------------------
[  110.835828] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[  110.835908] swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
[  110.835982]  (cmci_discover_lock){?.+...}, at: [<ffffffff80236dc0>] cmci_clear+0x30/0x9b

smp_call_function_single() will disable interrupt. moving mce reenable/disable
to workqueue, so no irq is disabled.

Signed-off-by: Shaohua Li<shaohua.li@intel.com>
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 6fb0b35..739c824 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -1057,30 +1057,32 @@ static __cpuinit void mce_remove_device(unsigned int cpu)
 }
 
 /* Make sure there are no machine checks on offlined CPUs. */
-static void mce_disable_cpu(void *h)
+static long mce_disable_cpu(void *h)
 {
 	int i;
 	unsigned long action = *(unsigned long *)h;
 
 	if (!mce_available(&current_cpu_data))
-		return;
+		return 0;
 	if (!(action & CPU_TASKS_FROZEN))
 		cmci_clear();
 	for (i = 0; i < banks; i++)
 		wrmsrl(MSR_IA32_MC0_CTL + i*4, 0);
+	return 0;
 }
 
-static void mce_reenable_cpu(void *h)
+static long mce_reenable_cpu(void *h)
 {
 	int i;
 	unsigned long action = *(unsigned long *)h;
 
 	if (!mce_available(&current_cpu_data))
-		return;
+		return 0;
 	if (!(action & CPU_TASKS_FROZEN))
 		cmci_reenable();
 	for (i = 0; i < banks; i++)
 		wrmsrl(MSR_IA32_MC0_CTL + i*4, bank[i]);
+	return 0;
 }
 
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
@@ -1106,14 +1108,14 @@ static int __cpuinit mce_cpu_callback(struct notifier_block *nfb,
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
 		del_timer_sync(t);
-		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
+		work_on_cpu(cpu, mce_disable_cpu, &action);
 		break;
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
 		t->expires = round_jiffies(jiffies +
 						__get_cpu_var(next_interval));
 		add_timer_on(t, cpu);
-		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
+		work_on_cpu(cpu, mce_reenable_cpu, &action);
 		break;
 	case CPU_POST_DEAD:
 		/* intentionally ignoring frozen here */


