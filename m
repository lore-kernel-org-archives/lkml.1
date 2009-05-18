Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZERHlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZERHlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756282AbZERHk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:40:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:48971 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756446AbZERHkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:40:55 -0400
Date: Mon, 18 May 2009 07:40:16 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, htejun@gmail.com, hpa@zytor.com,
       mingo@redhat.com, yinghai@kernel.org, steiner@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, htejun@gmail.com,
       linux-kernel@vger.kernel.org, yinghai@kernel.org, steiner@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A0C4A02.7050401@kernel.org>
References: <4A0C4A02.7050401@kernel.org>
Subject: [tip:x86/mm] x86: fix system without memory on node0
Message-ID: <tip-35d5a9a61490bf39d2e48d7f499c8c801a39ebe9@git.kernel.org>
Git-Commit-ID: 35d5a9a61490bf39d2e48d7f499c8c801a39ebe9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 18 May 2009 07:40:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35d5a9a61490bf39d2e48d7f499c8c801a39ebe9
Gitweb:     http://git.kernel.org/tip/35d5a9a61490bf39d2e48d7f499c8c801a39ebe9
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 15 May 2009 13:59:37 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 May 2009 09:27:09 +0200

x86: fix system without memory on node0

Jack found a boot crash on a system which doesn't have memory on node0.

It turns out with recent per_cpu changes, node_number for BSP will always
be 0, and it is not consistent to cpu_to_node() that might set it to a
different (nearer) node already.

aka when numa_set_node() for node0 is called early before per_cpu area is
setup:

two places touched that per_cpu(node_number,):

1. in cpu/common.c::cpu_init() and it is not for BP
| #ifdef CONFIG_NUMA
|        if (cpu != 0 && percpu_read(node_number) == 0 &&
|            cpu_to_node(cpu) != NUMA_NO_NODE)
|                percpu_write(node_number, cpu_to_node(cpu));
| #endif
for BP: traps_init ==> cpu_init
for AP: start_secondary ==> cpu_init

2. cpu/intel.c or amd.c::srat_detect_node via numa_set_node()
for BP: check_bugs ==> identify_boot_cpu ==> identify_cpu()
	 that is rather later before numa_node_id() is used for BP...
for AP: start_secondary => smp_callin => smp_store_cpu_info() =>
	=> identify_secondary_cpu => identify_cpu()

so try to set that for BP earlier in setup_per_cpu_areas(), and
don't bother to set that for APs there (it will be updated later
and will be used later)

(and don't mess the 0 before the copying BP per_cpu data to APs)

[ Impact: fix boot crash on memoryless node-0 ]

Reported-and-tested-by: Jack Steiner <steiner@sgi.com>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4A0C4A02.7050401@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/setup_percpu.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 3a97a4c..3b5f327 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -423,6 +423,14 @@ void __init setup_per_cpu_areas(void)
 	early_per_cpu_ptr(x86_cpu_to_node_map) = NULL;
 #endif
 
+#if defined(CONFIG_X86_64) && defined(CONFIG_NUMA)
+	/*
+	 * make sure boot cpu node_number is right, when boot cpu is on the
+	 * node that doesn't have mem installed
+	 */
+	per_cpu(node_number, boot_cpu_id) = cpu_to_node(boot_cpu_id);
+#endif
+
 	/* Setup node to cpumask map */
 	setup_node_to_cpumask_map();
 
