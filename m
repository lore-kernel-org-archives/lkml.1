Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbYJVTX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbYJVTX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbYJVTXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:23:49 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:53126 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535AbYJVTXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:23:49 -0400
Subject: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is set.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <20081021192746.GJ12825@one.firstfloor.org>
References: <1224552902.2640.88.camel@alok-dev1>
	 <874p36fflp.fsf@basil.nowhere.org> <1224607284.6161.22.camel@alok-dev1>
	 <20081021174008.GH12825@one.firstfloor.org>
	 <1224612294.6161.43.camel@alok-dev1>
	 <20081021181536.GI12825@one.firstfloor.org>
	 <1224616236.6161.60.camel@alok-dev1>
	 <20081021192746.GJ12825@one.firstfloor.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 22 Oct 2008 12:23:47 -0700
Message-Id: <1224703427.13953.8.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Skip tsc synchronization checks if CONSTANT_TSC bit is set.

From: Alok N Kataria <akataria@vmware.com>

TSC synchronization checks between CPU's bail out even if we see
a distortion of a single cycle. This makes the TSC mostly unsuable
in a virtualized environment.

The CONSTANT_TSC bit tells us if the hardware exports a constant TSC,
we can use this bit to trust the hardware and skip the TSC sync checks
at bootup.

We also force set the CONSTANT_TSC capability bit if we are running on
VMware, since the VMware hypervisor exports a constant TSC to the guest.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Cc: Andi Kleen <andi@firstfloor.org>
---

 arch/x86/kernel/cpu/common.c |    1 +
 arch/x86/kernel/tsc_sync.c   |    8 +++++++-
 2 files changed, 8 insertions(+), 1 deletions(-)


diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a48cb0e..720b583 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -452,6 +452,7 @@ void __cpuinit detect_hypervisor_vendor(struct cpuinfo_x86 *c)
 {
 	if (vmware_platform()) {
 		c->x86_hyper_vendor = X86_HYPER_VENDOR_VMWARE;
+		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 	} else {
 		c->x86_hyper_vendor = X86_HYPER_VENDOR_NONE;
 	}
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 9ffb01c..c0c89b7 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -108,6 +108,12 @@ void __cpuinit check_tsc_sync_source(int cpu)
 	if (unsynchronized_tsc())
 		return;
 
+	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
+		printk(KERN_INFO
+		       "Skipping synchronization checks as TSC is constant.\n");
+		return;
+	}
+		
 	printk(KERN_INFO "checking TSC synchronization [CPU#%d -> CPU#%d]:",
 			  smp_processor_id(), cpu);
 
@@ -161,7 +167,7 @@ void __cpuinit check_tsc_sync_target(void)
 {
 	int cpus = 2;
 
-	if (unsynchronized_tsc())
+	if (unsynchronized_tsc() || boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
 		return;
 
 	/*


