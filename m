Return-Path: <linux-kernel-owner+w=401wt.eu-S1760099AbXFQJ7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099AbXFQJ7X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758010AbXFQJpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:35 -0400
Received: from il.qumranet.com ([82.166.9.18]:55190 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759475AbXFQJov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:51 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 58/58] KVM: VMX: Ensure vcpu time stamp counter is monotonous
Date: Sun, 17 Jun 2007 12:44:39 +0300
Message-Id: <1182073482118-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If the time stamp counter goes backwards, a guest delay loop can become
infinite.  This can happen if a vcpu is migrated to another cpu, where
the counter has a lower value than the first cpu.

Since we're doing an IPI to the first cpu anyway, we can use that to pick
up the old tsc, and use that to calculate the adjustment we need to make
to the tsc offset.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 0b2aace..d06c362 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -160,6 +160,7 @@ static void __vcpu_clear(void *arg)
 		vmcs_clear(vcpu->vmcs);
 	if (per_cpu(current_vmcs, cpu) == vcpu->vmcs)
 		per_cpu(current_vmcs, cpu) = NULL;
+	rdtscll(vcpu->host_tsc);
 }
 
 static void vcpu_clear(struct kvm_vcpu *vcpu)
@@ -376,6 +377,7 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu)
 {
 	u64 phys_addr = __pa(vcpu->vmcs);
 	int cpu;
+	u64 tsc_this, delta;
 
 	cpu = get_cpu();
 
@@ -409,6 +411,13 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu)
 
 		rdmsrl(MSR_IA32_SYSENTER_ESP, sysenter_esp);
 		vmcs_writel(HOST_IA32_SYSENTER_ESP, sysenter_esp); /* 22.2.3 */
+
+		/*
+		 * Make sure the time stamp counter is monotonous.
+		 */
+		rdtscll(tsc_this);
+		delta = vcpu->host_tsc - tsc_this;
+		vmcs_write64(TSC_OFFSET, vmcs_read64(TSC_OFFSET) + delta);
 	}
 }
 
-- 
1.5.0.6

