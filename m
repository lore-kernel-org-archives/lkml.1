Return-Path: <linux-kernel-owner+w=401wt.eu-S1762198AbYDCTgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762198AbYDCTgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760594AbYDCTdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:04 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53032
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760187AbYDCTc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:57 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/35] KVM: VMX: Don't adjust tsc offset forward
Date: Thu,  3 Apr 2008 22:32:28 +0300
Message-Id: <1207251170-5013-14-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most Intel hosts have a stable tsc, and playing with the offset only
reduces accuracy.  By limiting tsc offset adjustment only to forward updates,
we effectively disable tsc offset adjustment on these hosts.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 7ef710a..fb0389d 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -519,7 +519,7 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u64 phys_addr = __pa(vmx->vmcs);
-	u64 tsc_this, delta;
+	u64 tsc_this, delta, new_offset;
 
 	if (vcpu->cpu != cpu) {
 		vcpu_clear(vmx);
@@ -559,8 +559,11 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		 * Make sure the time stamp counter is monotonous.
 		 */
 		rdtscll(tsc_this);
-		delta = vcpu->arch.host_tsc - tsc_this;
-		vmcs_write64(TSC_OFFSET, vmcs_read64(TSC_OFFSET) + delta);
+		if (tsc_this < vcpu->arch.host_tsc) {
+			delta = vcpu->arch.host_tsc - tsc_this;
+			new_offset = vmcs_read64(TSC_OFFSET) + delta;
+			vmcs_write64(TSC_OFFSET, new_offset);
+		}
 	}
 }
 
-- 
1.5.4.5

