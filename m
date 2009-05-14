Return-Path: <linux-kernel-owner+w=401wt.eu-S1757087AbZENQnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbZENQnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 12:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZENQnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 12:43:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:34210 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbZENQnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 12:43:40 -0400
Message-ID: <4A0C4A02.7050401@kernel.org>
Date: Thu, 14 May 2009 09:42:42 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Jack Steiner <steiner@sgi.com>,
       David Rientjes <rientjes@google.com>
Subject: [PATCH 4/5] x86: fix system without memory on node0 -v2
References: <4A05269D.8000701@kernel.org> <20090512111623.GG25923@csn.ul.ie> <4A0A64FB.4080504@kernel.org> <20090513145950.GB28097@csn.ul.ie> <4A0C4910.7090508@kernel.org>
In-Reply-To: <4A0C4910.7090508@kernel.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jack found that crash with doesn't have memory on node0.

it turns out with per_cpu changeset, node_number for BSP will be alway 0,
and it is not consistent to cpu_to_node() that is to near node already.
aka when numa_set_node() for node0 is called early before per_cpu area is
setup

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
for AP: start_secondary=>smp_callin=>smp_store_cpu_info()=>identify_secondary_cpu ==> identify_cpu()

so only try to set that for BP more early in setup_per_cpu_areas, and
don't bother set that for APs there (it will be updated later and used later)
(and don't mess the 0 before the copying BP per_cpu data to APs)

v2: updated changelog with detailed reason

[ Impact: fix crashing on memoryless node 0]

Reported-and-tested-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/setup_percpu.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6/arch/x86/kernel/setup_percpu.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6/arch/x86/kernel/setup_percpu.c
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
 
