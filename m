Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbXGWG50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbXGWG50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759052AbXGWG4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:56:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:55412 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756585AbXGWG4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:56:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,569,1175497200"; 
   d="scan'208";a="271462853"
Subject: [RFC 1/8]KVM: fix bugs in kvm sched integration patch
From: Shaohua Li <shaohua.li@intel.com>
To: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 14:51:32 +0800
Message-Id: <1185173492.2645.65.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fix some bugs in kvm-sch patch.
1. vmcs_readl/vmcs_writel are called with preempt enabled
2. preempt_count check doesn't make sense with preempt disabled
3. vmx_cpu_run doesn't handle error correctly and kvm_mmu_reload might
sleep with mutex changes, so I move it above.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/kvm/vmx.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

Index: linux/drivers/kvm/vmx.c
===================================================================
--- linux.orig/drivers/kvm/vmx.c	2007-07-18 16:11:22.000000000 +0800
+++ linux/drivers/kvm/vmx.c	2007-07-20 14:56:45.000000000 +0800
@@ -179,7 +179,6 @@ static unsigned long vmcs_readl(unsigned
 {
 	unsigned long value;
 
-	WARN_ON(raw_smp_processor_id() != current->kvm_vcpu->cpu);
 	asm volatile (ASM_VMX_VMREAD_RDX_RAX
 		      : "=a"(value) : "d"(field) : "cc");
 	return value;
@@ -215,7 +214,6 @@ static void vmcs_writel(unsigned long fi
 {
 	u8 error;
 
-	WARN_ON(raw_smp_processor_id() != current->kvm_vcpu->cpu);
 	asm volatile (ASM_VMX_VMWRITE_RAX_RDX "; setna %0"
 		       : "=q"(error) : "a"(value), "d"(field) : "cc" );
 	if (unlikely(error))
@@ -384,7 +382,6 @@ static void vmx_vcpu_load(struct kvm_vcp
 	u64 phys_addr = __pa(vcpu->vmcs);
 	u64 tsc_this, delta;
 
-	WARN_ON(!preempt_count());
 	if (vcpu->cpu != cpu)
 		vcpu_clear(vcpu);
 
@@ -427,7 +424,6 @@ static void vmx_vcpu_load(struct kvm_vcp
 
 static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	WARN_ON(!preempt_count());
 	vmx_load_host_state(vcpu);
 	kvm_put_guest_fpu(vcpu);
 }
@@ -2001,6 +1997,10 @@ preempted:
 		kvm_guest_debug_pre(vcpu);
 
 again:
+	r = kvm_mmu_reload(vcpu);
+	if (unlikely(r))
+		goto out;
+
 	preempt_disable();
 
 	if (!vcpu->mmio_read_completed)
@@ -2009,10 +2009,6 @@ again:
 	vmx_save_host_state(vcpu);
 	kvm_load_guest_fpu(vcpu);
 
-	r = kvm_mmu_reload(vcpu);
-	if (unlikely(r))
-		goto out;
-
 	/*
 	 * Loading guest fpu may have cleared host cr0.ts
 	 */
