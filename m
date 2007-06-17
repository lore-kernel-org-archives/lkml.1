Return-Path: <linux-kernel-owner+w=401wt.eu-S1760514AbXFQJte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760514AbXFQJte (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759525AbXFQJow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:44:52 -0400
Received: from il.qumranet.com ([82.166.9.18]:55154 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758220AbXFQJon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:43 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 15/58] KVM: Consolidate guest fpu activation and deactivation
Date: Sun, 17 Jun 2007 12:43:56 +0300
Message-Id: <11820734803186-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Easier to keep track of where the fpu is this way.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |    2 +-
 drivers/kvm/vmx.c |   50 +++++++++++++++++++++++++++++++-------------------
 2 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index bb32383..4724087 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -42,7 +42,7 @@
 	(CR0_PG_MASK | CR0_PE_MASK | CR0_WP_MASK | CR0_NE_MASK \
 	 | CR0_NW_MASK | CR0_CD_MASK)
 #define KVM_VM_CR0_ALWAYS_ON \
-	(CR0_PG_MASK | CR0_PE_MASK | CR0_WP_MASK | CR0_NE_MASK)
+	(CR0_PG_MASK | CR0_PE_MASK | CR0_WP_MASK | CR0_NE_MASK | CR0_TS_MASK)
 #define KVM_GUEST_CR4_MASK \
 	(CR4_PSE_MASK | CR4_PAE_MASK | CR4_PGE_MASK | CR4_VMXE_MASK | CR4_VME_MASK)
 #define KVM_PMODE_VM_CR4_ALWAYS_ON (CR4_VMXE_MASK | CR4_PAE_MASK)
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 2190020..096cb6a 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -396,6 +396,26 @@ static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 	put_cpu();
 }
 
+static void vmx_fpu_activate(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->fpu_active)
+		return;
+	vcpu->fpu_active = 1;
+	vmcs_clear_bits(GUEST_CR0, CR0_TS_MASK);
+	if (vcpu->cr0 & CR0_TS_MASK)
+		vmcs_set_bits(GUEST_CR0, CR0_TS_MASK);
+	update_exception_bitmap(vcpu);
+}
+
+static void vmx_fpu_deactivate(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu->fpu_active)
+		return;
+	vcpu->fpu_active = 0;
+	vmcs_set_bits(GUEST_CR0, CR0_TS_MASK);
+	update_exception_bitmap(vcpu);
+}
+
 static void vmx_vcpu_decache(struct kvm_vcpu *vcpu)
 {
 	vcpu_clear(vcpu);
@@ -925,6 +945,8 @@ static void vmx_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
 
 static void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
+	vmx_fpu_deactivate(vcpu);
+
 	if (vcpu->rmode.active && (cr0 & CR0_PE_MASK))
 		enter_pmode(vcpu);
 
@@ -940,26 +962,20 @@ static void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	}
 #endif
 
-	if (!(cr0 & CR0_TS_MASK)) {
-		vcpu->fpu_active = 1;
-		update_exception_bitmap(vcpu);
-	}
-
 	vmcs_writel(CR0_READ_SHADOW, cr0);
 	vmcs_writel(GUEST_CR0,
 		    (cr0 & ~KVM_GUEST_CR0_MASK) | KVM_VM_CR0_ALWAYS_ON);
 	vcpu->cr0 = cr0;
+
+	if (!(cr0 & CR0_TS_MASK) || !(cr0 & CR0_PE_MASK))
+		vmx_fpu_activate(vcpu);
 }
 
 static void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	vmcs_writel(GUEST_CR3, cr3);
-
-	if (!(vcpu->cr0 & CR0_TS_MASK)) {
-		vcpu->fpu_active = 0;
-		vmcs_set_bits(GUEST_CR0, CR0_TS_MASK);
-		update_exception_bitmap(vcpu);
-	}
+	if (vcpu->cr0 & CR0_PE_MASK)
+		vmx_fpu_deactivate(vcpu);
 }
 
 static void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
@@ -1328,6 +1344,7 @@ static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 #ifdef CONFIG_X86_64
 	vmx_set_efer(vcpu, 0);
 #endif
+	vmx_fpu_activate(vcpu);
 	update_exception_bitmap(vcpu);
 
 	return 0;
@@ -1488,10 +1505,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	}
 
 	if (is_no_device(intr_info)) {
-		vcpu->fpu_active = 1;
-		update_exception_bitmap(vcpu);
-		if (!(vcpu->cr0 & CR0_TS_MASK))
-			vmcs_clear_bits(GUEST_CR0, CR0_TS_MASK);
+		vmx_fpu_activate(vcpu);
 		return 1;
 	}
 
@@ -1683,11 +1697,10 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		break;
 	case 2: /* clts */
 		vcpu_load_rsp_rip(vcpu);
-		vcpu->fpu_active = 1;
-		update_exception_bitmap(vcpu);
-		vmcs_clear_bits(GUEST_CR0, CR0_TS_MASK);
+		vmx_fpu_deactivate(vcpu);
 		vcpu->cr0 &= ~CR0_TS_MASK;
 		vmcs_writel(CR0_READ_SHADOW, vcpu->cr0);
+		vmx_fpu_activate(vcpu);
 		skip_emulated_instruction(vcpu);
 		return 1;
 	case 1: /*mov from cr*/
@@ -2158,7 +2171,6 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	vmcs_clear(vmcs);
 	vcpu->vmcs = vmcs;
 	vcpu->launched = 0;
-	vcpu->fpu_active = 1;
 
 	return 0;
 
-- 
1.5.0.6

