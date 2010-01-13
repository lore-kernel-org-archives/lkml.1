Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982Ab0AMAOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab0AMAOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 19:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475Ab0AMAOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 19:14:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:13248 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab0AMAOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 19:14:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,264,1262592000"; 
   d="scan'208";a="586615094"
Date: Tue, 12 Jan 2010 16:14:01 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Wrong cpumask_of_node usage in kernel/smp.c
Message-ID: <20100113001401.GA26192@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am getting dump_stack from cpumask_of_node() with recent kernels.
Dump stack msg that repeats few times
[    6.504569] cpumask_of_node(2): node > nr_node_ids(1)
[    6.504692] Pid: 1, comm: swapper Not tainted 2.6.33-rc3-00294-g99ad0b4 #1223
[    6.504819] Call Trace:
[    6.504937]  [<ffffffff81026628>] cpumask_of_node+0x28/0x5c
[    6.505063]  [<ffffffff81071ad8>] smp_call_function_any+0x6a/0xff
[    6.505193]  [<ffffffff81016c15>] ? do_drv_read+0x0/0x34
[    6.505315]  [<ffffffff81016af9>] get_cur_val+0xb5/0x107
[    6.505437]  [<ffffffff81016bc4>] get_cur_freq_on_cpu+0x79/0xca
[    6.505561]  [<ffffffff8101747b>] acpi_cpufreq_cpu_init+0x463/0x561
[    6.505689]  [<ffffffff814f8353>] cpufreq_add_dev+0x317/0x66d
[    6.505813]  [<ffffffff8136fbaa>] sysdev_driver_register+0xcb/0x125
[    6.505938]  [<ffffffff814f6a7c>] cpufreq_register_driver+0xcc/0x1ea
[    6.506065]  [<ffffffff81c42962>] ? acpi_cpufreq_init+0x0/0x128
[    6.506193]  [<ffffffff81c42a78>] acpi_cpufreq_init+0x116/0x128
[    6.506318]  [<ffffffff81c42962>] ? acpi_cpufreq_init+0x0/0x128
[    6.506443]  [<ffffffff810001fa>] do_one_initcall+0x5f/0x154
[    6.506569]  [<ffffffff81c3a6a3>] kernel_init+0x198/0x1ed
[    6.506690]  [<ffffffff81003014>] kernel_thread_helper+0x4/0x10
[    6.506816]  [<ffffffff815f41fc>] ? restore_args+0x0/0x30
[    6.506938]  [<ffffffff81c3a50b>] ? kernel_init+0x0/0x1ed
[    6.507060]  [<ffffffff81003010>] ? kernel_thread_helper+0x0/0x10

Looks like a bug from changeset
commit 2ea6dec4a22a6f66f6633876212fd4d195cf8277
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Nov 17 14:27:27 2009 -0800

    generic-ipi: Add smp_call_function_any()
    
    Andrew points out that acpi-cpufreq uses cpumask_any, when it really
    would prefer to use the same CPU if possible (to avoid an IPI).  In
    general, this seems a good idea to offer.
    

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 kernel/smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index de735a6..f104084 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -347,7 +347,7 @@ int smp_call_function_any(const struct cpumask *mask,
 		goto call;
 
 	/* Try for same node. */
-	nodemask = cpumask_of_node(cpu);
+	nodemask = cpumask_of_node(cpu_to_node(cpu));
 	for (cpu = cpumask_first_and(nodemask, mask); cpu < nr_cpu_ids;
 	     cpu = cpumask_next_and(cpu, nodemask, mask)) {
 		if (cpu_online(cpu))
-- 
1.6.0.6

