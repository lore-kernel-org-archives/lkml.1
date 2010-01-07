Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383Ab0AGXsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab0AGXsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 18:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171Ab0AGXsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 18:48:12 -0500
Received: from mga03.intel.com ([143.182.124.21]:26951 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab0AGXsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 18:48:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="230446814"
Subject: [patch] generic-ipi: fix backtrace in smp_call_function_any()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 07 Jan 2010 15:46:59 -0800
Message-Id: <1262908019.2779.24.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my westmere box, I see this backtrace with 2.6.33-rc kernels:

> cpumask_of_node(3): node > nr_node_ids(1)
> Pid: 1, comm: swapper Not tainted 2.6.33-rc3-00097-g2c1f189 #223
> Call Trace:
>  [<ffffffff81028bb3>] cpumask_of_node+0x23/0x58
>  [<ffffffff81061f51>] smp_call_function_any+0x65/0xfa
>  [<ffffffff810160d1>] ? do_drv_read+0x0/0x2f
>  [<ffffffff81015fba>] get_cur_val+0xb0/0x102
>  [<ffffffff81016080>] get_cur_freq_on_cpu+0x74/0xc5
>  [<ffffffff810168a7>] acpi_cpufreq_cpu_init+0x417/0x515
>  [<ffffffff81562ce9>] ? __down_write+0xb/0xd
>  [<ffffffff8148055e>] cpufreq_add_dev+0x278/0x922

fix it by using the cpu_to_node() and using the node number instead
of the cpu for cpumask_of_node().

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

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


