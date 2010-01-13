Return-Path: <linux-kernel-owner+w=401wt.eu-S1751724Ab0AMFOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab0AMFOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 00:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278Ab0AMFOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 00:14:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:34844 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab0AMFOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 00:14:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,266,1262592000"; 
   d="scan'208";a="586671499"
Date: Wed, 13 Jan 2010 13:14:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Jones <davej@redhat.com>
Cc: Thomas Renninger <trenn@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [BUGFIX] cpufreq: dont BUG_ON uninitialized policy cpu
Message-ID: <20100113051438.GA32519@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a BUG_ON which is always triggered here after commit 0b19a310eebb93:

[    6.879063] kernel BUG at drivers/cpufreq/cpufreq.c:88!
[    6.879381] invalid opcode: 0000 [#1] SMP
[    6.879711] last sysfs file:
[    6.879918] CPU 3
[    6.880114] Pid: 1, comm: swapper Not tainted 2.6.33-rc3-next-20100112 #51 DX58SO/
[    6.880611] RIP: 0010:[<ffffffff81577729>]  [<ffffffff81577729>] lock_policy_rwsem_write+0x69/0x90
...
[    6.885630] Process swapper (pid: 1, threadinfo ffff8800bbbdc000, task ffff8800bbbe0000)
...
[    6.888135] Call Trace:
[    6.888318]  [<ffffffff8157851a>] cpufreq_update_policy+0x2a/0x110
...
[    6.892586]  [<ffffffff81c981e6>] cpufreq_stats_init+0x83/0xb5

CC: Thomas Renninger <trenn@suse.de>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/cpufreq/cpufreq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-mm.orig/drivers/cpufreq/cpufreq.c	2010-01-13 13:06:03.000000000 +0800
+++ linux-mm/drivers/cpufreq/cpufreq.c	2010-01-13 13:06:57.000000000 +0800
@@ -72,7 +72,8 @@ int lock_policy_rwsem_##mode						\
 (int cpu)								\
 {									\
 	int policy_cpu = per_cpu(cpufreq_policy_cpu, cpu);		\
-	BUG_ON(policy_cpu == -1);					\
+	if (policy_cpu == -1)						\
+		return -1;						\
 	down_##mode(&per_cpu(cpu_policy_rwsem, policy_cpu));		\
 	if (unlikely(!cpu_online(cpu))) {				\
 		up_##mode(&per_cpu(cpu_policy_rwsem, policy_cpu));	\
