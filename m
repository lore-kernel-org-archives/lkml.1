Return-Path: <linux-kernel-owner+w=401wt.eu-S1760060AbZDWHzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060AbZDWHzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757058AbZDWHeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:34:05 -0400
Received: from sous-sol.org ([216.99.217.87]:51023 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753895AbZDWHeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:34:03 -0400
Message-Id: <20090423073018.652954795@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:48 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, chrisw@redhat.com
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com,
       Amit Shah <amit.shah@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 088/100] KVM: VMX: Update necessary state when guest enters long mode
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=kvm-vmx-update-necessary-state-when-guest-enters-long-mode.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Amit Shah <amit.shah@redhat.com>

upstream commit: 401d10dee083bda281f2fdcdf654080313ba30ec

setup_msrs() should be called when entering long mode to save the
shadow state for the 64-bit guest state.

Using vmx_set_efer() in enter_lmode() removes some duplicated code
and also ensures we call setup_msrs(). We can safely pass the value
of shadow_efer to vmx_set_efer() as no other bits in the efer change
while enabling long mode (guest first sets EFER.LME, then sets CR0.PG
which causes a vmexit where we activate long mode).

With this fix, is_long_mode() can check for EFER.LMA set instead of
EFER.LME and 5e23049e86dd298b72e206b420513dbc3a240cd9 can be reverted.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kvm/vmx.c |   54 +++++++++++++++++++++++------------------------------
 1 file changed, 24 insertions(+), 30 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1433,6 +1433,29 @@ continue_rmode:
 	init_rmode(vcpu->kvm);
 }
 
+static void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct kvm_msr_entry *msr = find_msr_entry(vmx, MSR_EFER);
+
+	vcpu->arch.shadow_efer = efer;
+	if (!msr)
+		return;
+	if (efer & EFER_LMA) {
+		vmcs_write32(VM_ENTRY_CONTROLS,
+			     vmcs_read32(VM_ENTRY_CONTROLS) |
+			     VM_ENTRY_IA32E_MODE);
+		msr->data = efer;
+	} else {
+		vmcs_write32(VM_ENTRY_CONTROLS,
+			     vmcs_read32(VM_ENTRY_CONTROLS) &
+			     ~VM_ENTRY_IA32E_MODE);
+
+		msr->data = efer & ~EFER_LME;
+	}
+	setup_msrs(vmx);
+}
+
 #ifdef CONFIG_X86_64
 
 static void enter_lmode(struct kvm_vcpu *vcpu)
@@ -1447,13 +1470,8 @@ static void enter_lmode(struct kvm_vcpu 
 			     (guest_tr_ar & ~AR_TYPE_MASK)
 			     | AR_TYPE_BUSY_64_TSS);
 	}
-
 	vcpu->arch.shadow_efer |= EFER_LMA;
-
-	find_msr_entry(to_vmx(vcpu), MSR_EFER)->data |= EFER_LMA | EFER_LME;
-	vmcs_write32(VM_ENTRY_CONTROLS,
-		     vmcs_read32(VM_ENTRY_CONTROLS)
-		     | VM_ENTRY_IA32E_MODE);
+	vmx_set_efer(vcpu, vcpu->arch.shadow_efer);
 }
 
 static void exit_lmode(struct kvm_vcpu *vcpu)
@@ -1612,30 +1630,6 @@ static void vmx_set_cr4(struct kvm_vcpu 
 	vmcs_writel(GUEST_CR4, hw_cr4);
 }
 
-static void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct kvm_msr_entry *msr = find_msr_entry(vmx, MSR_EFER);
-
-	vcpu->arch.shadow_efer = efer;
-	if (!msr)
-		return;
-	if (efer & EFER_LMA) {
-		vmcs_write32(VM_ENTRY_CONTROLS,
-				     vmcs_read32(VM_ENTRY_CONTROLS) |
-				     VM_ENTRY_IA32E_MODE);
-		msr->data = efer;
-
-	} else {
-		vmcs_write32(VM_ENTRY_CONTROLS,
-				     vmcs_read32(VM_ENTRY_CONTROLS) &
-				     ~VM_ENTRY_IA32E_MODE);
-
-		msr->data = efer & ~EFER_LME;
-	}
-	setup_msrs(vmx);
-}
-
 static u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
 {
 	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];

