Return-Path: <linux-kernel-owner+w=401wt.eu-S1760774AbXFQJvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760774AbXFQJvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759597AbXFQJo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:44:56 -0400
Received: from il.qumranet.com ([82.166.9.18]:55188 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758357AbXFQJon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:43 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 14/58] KVM: Rationalize exception bitmap usage
Date: Sun, 17 Jun 2007 12:43:55 +0300
Message-Id: <1182073480457-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Everyone owns a piece of the exception bitmap, but they happily write to
the entire thing like there's no tomorrow.  Centralize handling in
update_exception_bitmap() and have everyone call that.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   42 +++++++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 93c3abf..2190020 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -237,6 +237,20 @@ static void vmcs_set_bits(unsigned long field, u32 mask)
 	vmcs_writel(field, vmcs_readl(field) | mask);
 }
 
+static void update_exception_bitmap(struct kvm_vcpu *vcpu)
+{
+	u32 eb;
+
+	eb = 1u << PF_VECTOR;
+	if (!vcpu->fpu_active)
+		eb |= 1u << NM_VECTOR;
+	if (vcpu->guest_debug.enabled)
+		eb |= 1u << 1;
+	if (vcpu->rmode.active)
+		eb = ~0;
+	vmcs_write32(EXCEPTION_BITMAP, eb);
+}
+
 static void reload_tss(void)
 {
 #ifndef CONFIG_X86_64
@@ -618,10 +632,8 @@ static void vcpu_put_rsp_rip(struct kvm_vcpu *vcpu)
 static int set_guest_debug(struct kvm_vcpu *vcpu, struct kvm_debug_guest *dbg)
 {
 	unsigned long dr7 = 0x400;
-	u32 exception_bitmap;
 	int old_singlestep;
 
-	exception_bitmap = vmcs_read32(EXCEPTION_BITMAP);
 	old_singlestep = vcpu->guest_debug.singlestep;
 
 	vcpu->guest_debug.enabled = dbg->enabled;
@@ -637,13 +649,9 @@ static int set_guest_debug(struct kvm_vcpu *vcpu, struct kvm_debug_guest *dbg)
 			dr7 |= 0 << (i*4+16); /* execution breakpoint */
 		}
 
-		exception_bitmap |= (1u << 1);  /* Trap debug exceptions */
-
 		vcpu->guest_debug.singlestep = dbg->singlestep;
-	} else {
-		exception_bitmap &= ~(1u << 1); /* Ignore debug exceptions */
+	} else
 		vcpu->guest_debug.singlestep = 0;
-	}
 
 	if (old_singlestep && !vcpu->guest_debug.singlestep) {
 		unsigned long flags;
@@ -653,7 +661,7 @@ static int set_guest_debug(struct kvm_vcpu *vcpu, struct kvm_debug_guest *dbg)
 		vmcs_writel(GUEST_RFLAGS, flags);
 	}
 
-	vmcs_write32(EXCEPTION_BITMAP, exception_bitmap);
+	update_exception_bitmap(vcpu);
 	vmcs_writel(GUEST_DR7, dr7);
 
 	return 0;
@@ -767,14 +775,6 @@ static __exit void hardware_unsetup(void)
 	free_kvm_area();
 }
 
-static void update_exception_bitmap(struct kvm_vcpu *vcpu)
-{
-	if (vcpu->rmode.active)
-		vmcs_write32(EXCEPTION_BITMAP, ~0);
-	else
-		vmcs_write32(EXCEPTION_BITMAP, 1 << PF_VECTOR);
-}
-
 static void fix_pmode_dataseg(int seg, struct kvm_save_segment *save)
 {
 	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
@@ -942,7 +942,7 @@ static void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
 	if (!(cr0 & CR0_TS_MASK)) {
 		vcpu->fpu_active = 1;
-		vmcs_clear_bits(EXCEPTION_BITMAP, CR0_TS_MASK);
+		update_exception_bitmap(vcpu);
 	}
 
 	vmcs_writel(CR0_READ_SHADOW, cr0);
@@ -958,7 +958,7 @@ static void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	if (!(vcpu->cr0 & CR0_TS_MASK)) {
 		vcpu->fpu_active = 0;
 		vmcs_set_bits(GUEST_CR0, CR0_TS_MASK);
-		vmcs_set_bits(EXCEPTION_BITMAP, 1 << NM_VECTOR);
+		update_exception_bitmap(vcpu);
 	}
 }
 
@@ -1243,7 +1243,6 @@ static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 			       | CPU_BASED_USE_TSC_OFFSETING   /* 21.3 */
 			);
 
-	vmcs_write32(EXCEPTION_BITMAP, 1 << PF_VECTOR);
 	vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, 0);
 	vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, 0);
 	vmcs_write32(CR3_TARGET_COUNT, 0);           /* 22.2.1 */
@@ -1329,6 +1328,7 @@ static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 #ifdef CONFIG_X86_64
 	vmx_set_efer(vcpu, 0);
 #endif
+	update_exception_bitmap(vcpu);
 
 	return 0;
 
@@ -1489,7 +1489,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	if (is_no_device(intr_info)) {
 		vcpu->fpu_active = 1;
-		vmcs_clear_bits(EXCEPTION_BITMAP, 1 << NM_VECTOR);
+		update_exception_bitmap(vcpu);
 		if (!(vcpu->cr0 & CR0_TS_MASK))
 			vmcs_clear_bits(GUEST_CR0, CR0_TS_MASK);
 		return 1;
@@ -1684,7 +1684,7 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	case 2: /* clts */
 		vcpu_load_rsp_rip(vcpu);
 		vcpu->fpu_active = 1;
-		vmcs_clear_bits(EXCEPTION_BITMAP, 1 << NM_VECTOR);
+		update_exception_bitmap(vcpu);
 		vmcs_clear_bits(GUEST_CR0, CR0_TS_MASK);
 		vcpu->cr0 &= ~CR0_TS_MASK;
 		vmcs_writel(CR0_READ_SHADOW, vcpu->cr0);
-- 
1.5.0.6

