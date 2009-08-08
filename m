Return-Path: <linux-kernel-owner+w=401wt.eu-S1751893AbZHHPWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbZHHPWK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbZHHPWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:22:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:49937 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbZHHPWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:22:08 -0400
Date: Sat, 8 Aug 2009 15:21:35 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A785AFF.3050902@kernel.org>
References: <4A785AFF.3050902@kernel.org>
Subject: [tip:x86/urgent] x86: Fix MSI-X initialization by using online_mask for x2apic target_cpus
Message-ID: <tip-087d7e56deffb611a098e7e257388a41edbeef1f@git.kernel.org>
Git-Commit-ID: 087d7e56deffb611a098e7e257388a41edbeef1f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 08 Aug 2009 15:21:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  087d7e56deffb611a098e7e257388a41edbeef1f
Gitweb:     http://git.kernel.org/tip/087d7e56deffb611a098e7e257388a41edbeef1f
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 4 Aug 2009 08:59:59 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 8 Aug 2009 17:04:58 +0200

x86: Fix MSI-X initialization by using online_mask for x2apic target_cpus

found a system where x2apic reports an MSI-X irq initialization
failure:

[  302.859446] igbvf 0000:81:10.4: enabling device (0000 -> 0002)
[  302.874369] igbvf 0000:81:10.4: using 64bit DMA mask
[  302.879023] igbvf 0000:81:10.4: using 64bit consistent DMA mask
[  302.894386] igbvf 0000:81:10.4: enabling bus mastering
[  302.898171] igbvf 0000:81:10.4: setting latency timer to 64
[  302.914050] reserve_memtype added 0xefb08000-0xefb0c000, track uncached-minus, req uncached-minus, ret uncached-minus
[  302.933839] reserve_memtype added 0xefb28000-0xefb29000, track uncached-minus, req uncached-minus, ret uncached-minus
[  302.940367]   alloc irq_desc for 265 on node 4
[  302.956874]   alloc kstat_irqs on node 4
[  302.959452] alloc irq_2_iommu on node 0
[  302.974328] igbvf 0000:81:10.4: irq 265 for MSI/MSI-X
[  302.977778]   alloc irq_desc for 266 on node 4
[  302.980347]   alloc kstat_irqs on node 4
[  302.995312] free_memtype request 0xefb28000-0xefb29000
[  302.998816] igbvf 0000:81:10.4: Failed to initialize MSI-X interrupts.

... it turns out that when trying to enable MSI-X,
__assign_irq_vector(new, cfg_new, apic->target_cpus()) can not
get vector because for x2apic target-cpus returns cpumask_of(0)

Update that to online_mask like xapic.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <4A785AFF.3050902@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/x2apic_cluster.c |    8 +++++---
 arch/x86/kernel/apic/x2apic_phys.c    |    8 +++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 2ed4e2b..a5371ec 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -17,11 +17,13 @@ static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return x2apic_enabled();
 }
 
-/* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
-
+/*
+ * need to use more than cpu 0, because we need more vectors when
+ * MSI-X are used.
+ */
 static const struct cpumask *x2apic_target_cpus(void)
 {
-	return cpumask_of(0);
+	return cpu_online_mask;
 }
 
 /*
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 0b631c6..a8989aa 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -27,11 +27,13 @@ static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 		return 0;
 }
 
-/* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
-
+/*
+ * need to use more than cpu 0, because we need more vectors when
+ * MSI-X are used.
+ */
 static const struct cpumask *x2apic_target_cpus(void)
 {
-	return cpumask_of(0);
+	return cpu_online_mask;
 }
 
 static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
