Return-Path: <linux-kernel-owner+w=401wt.eu-S1763525AbYDCTkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763525AbYDCTkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761164AbYDCTdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:20 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:39117
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760720AbYDCTdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:33:02 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Izik Eidus <izike@qumranet.com>
Subject: [PATCH 34/35] KVM: x86: add functions to get the cpl of vcpu
Date: Thu,  3 Apr 2008 22:32:49 +0300
Message-Id: <1207251170-5013-35-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c         |    8 ++++++++
 arch/x86/kvm/vmx.c         |   15 +++++++++++++++
 include/asm-x86/kvm_host.h |    1 +
 3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 51741f9..c1c1b97 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -792,6 +792,13 @@ static void svm_get_segment(struct kvm_vcpu *vcpu,
 	var->unusable = !var->present;
 }
 
+static int svm_get_cpl(struct kvm_vcpu *vcpu)
+{
+	struct vmcb_save_area *save = &to_svm(vcpu)->vmcb->save;
+
+	return save->cpl;
+}
+
 static void svm_get_idt(struct kvm_vcpu *vcpu, struct descriptor_table *dt)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1822,6 +1829,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.get_segment_base = svm_get_segment_base,
 	.get_segment = svm_get_segment,
 	.set_segment = svm_set_segment,
+	.get_cpl = svm_get_cpl,
 	.get_cs_db_l_bits = kvm_get_cs_db_l_bits,
 	.decache_cr4_guest_bits = svm_decache_cr4_guest_bits,
 	.set_cr0 = svm_set_cr0,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 0155931..9b56032 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1395,6 +1395,20 @@ static void vmx_get_segment(struct kvm_vcpu *vcpu,
 	var->unusable = (ar >> 16) & 1;
 }
 
+static int vmx_get_cpl(struct kvm_vcpu *vcpu)
+{
+	struct kvm_segment kvm_seg;
+
+	if (!(vcpu->arch.cr0 & X86_CR0_PE)) /* if real mode */
+		return 0;
+
+	if (vmx_get_rflags(vcpu) & X86_EFLAGS_VM) /* if virtual 8086 */
+		return 3;
+
+	vmx_get_segment(vcpu, &kvm_seg, VCPU_SREG_CS);
+	return kvm_seg.selector & 3;
+}
+
 static u32 vmx_segment_access_rights(struct kvm_segment *var)
 {
 	u32 ar;
@@ -2665,6 +2679,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.get_segment_base = vmx_get_segment_base,
 	.get_segment = vmx_get_segment,
 	.set_segment = vmx_set_segment,
+	.get_cpl = vmx_get_cpl,
 	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
 	.decache_cr4_guest_bits = vmx_decache_cr4_guest_bits,
 	.set_cr0 = vmx_set_cr0,
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 2773f91..06bd154 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -387,6 +387,7 @@ struct kvm_x86_ops {
 	u64 (*get_segment_base)(struct kvm_vcpu *vcpu, int seg);
 	void (*get_segment)(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
+	int (*get_cpl)(struct kvm_vcpu *vcpu);
 	void (*set_segment)(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
 	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
-- 
1.5.4.5

