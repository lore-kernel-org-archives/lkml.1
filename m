Return-Path: <linux-kernel-owner+w=401wt.eu-S932907AbZHDPdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907AbZHDPdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932823AbZHDPda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:33:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:40012 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932883AbZHDPdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:33:11 -0400
Date: Tue, 4 Aug 2009 15:32:01 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, akpm@linux-foundation.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, akpm@linux-foundation.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A6ADD0D.10002@kernel.org>
References: <4A6ADD0D.10002@kernel.org>
Subject: [tip:x86/urgent] x86: Don't use current_cpu_data in x2apic phys_pkg_id
Message-ID: <tip-d8c7eb34c2db6268909ae8c3958be63bde254292@git.kernel.org>
Git-Commit-ID: d8c7eb34c2db6268909ae8c3958be63bde254292
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 15:32:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8c7eb34c2db6268909ae8c3958be63bde254292
Gitweb:     http://git.kernel.org/tip/d8c7eb34c2db6268909ae8c3958be63bde254292
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sat, 25 Jul 2009 03:23:09 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Aug 2009 16:22:44 +0200

x86: Don't use current_cpu_data in x2apic phys_pkg_id

One system has socket 1 come up as BSP.

kexeced kernel reports BSP as:

[    1.524550] Initializing cgroup subsys cpuacct
[    1.536064] initial_apicid:20
[    1.537135] ht_mask_width:1
[    1.538128] core_select_mask:f
[    1.539126] core_plus_mask_width:5
[    1.558479] CPU: Physical Processor ID: 0
[    1.559501] CPU: Processor Core ID: 0
[    1.560539] CPU: L1 I cache: 32K, L1 D cache: 32K
[    1.579098] CPU: L2 cache: 256K
[    1.580085] CPU: L3 cache: 24576K
[    1.581108] CPU 0/0x20 -> Node 0
[    1.596193] CPU 0 microcode level: 0xffff0008

It doesn't have correct physical processor id and will get an
error:

[   38.840859] CPU0 attaching sched-domain:
[   38.848287]  domain 0: span 0,8,72 level SIBLING
[   38.851151]   groups: 0 8 72
[   38.858137]   domain 1: span 0,8-15,72-79 level MC
[   38.868944]    groups: 0,8,72 9,73 10,74 11,75 12,76 13,77 14,78 15,79
[   38.881383] ERROR: parent span is not a superset of domain->span
[   38.890724]    domain 2: span 0-7,64-71 level CPU
[   38.899237] ERROR: domain->groups does not contain CPU0
[   38.909229]     groups: 8-15,72-79
[   38.912547] ERROR: groups don't span domain->span
[   38.919665]     domain 3: span 0-127 level NODE
[   38.930739]      groups: 0-7,64-71 8-15,72-79 16-23,80-87 24-31,88-95 32-39,96-103 40-47,104-111 48-55,112-119 56-63,120-127

it turns out: we can not use current_cpu_data in phys_pgd_id
for x2apic.

identify_boot_cpu() is called by check_bugs() before
smp_prepare_cpus() and till smp_prepare_cpus() current_cpu_data
for bsp is assigned with boot_cpu_data.

Just make phys_pkg_id for x2apic is aligned to xapic.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <4A6ADD0D.10002@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
 arch/x86/kernel/apic/x2apic_phys.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 8e4cbb2..2ed4e2b 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -170,7 +170,7 @@ static unsigned long set_apic_id(unsigned int id)
 
 static int x2apic_cluster_phys_pkg_id(int initial_apicid, int index_msb)
 {
-	return current_cpu_data.initial_apicid >> index_msb;
+	return initial_apicid >> index_msb;
 }
 
 static void x2apic_send_IPI_self(int vector)
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index a284359..0b631c6 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -162,7 +162,7 @@ static unsigned long set_apic_id(unsigned int id)
 
 static int x2apic_phys_pkg_id(int initial_apicid, int index_msb)
 {
-	return current_cpu_data.initial_apicid >> index_msb;
+	return initial_apicid >> index_msb;
 }
 
 static void x2apic_send_IPI_self(int vector)
