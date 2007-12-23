Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbXLWOyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbXLWOyI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:54:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbXLWOvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:51:47 -0500
Received: from il.qumranet.com ([82.166.9.18]:35898 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbXLWOvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:39 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 08/50] KVM: VMX: Further reduce efer reloads
Date: Sun, 23 Dec 2007 16:50:53 +0200
Message-Id: <1198421495-31481-9-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM avoids reloading the efer msr when the difference between the guest
and host values consist of the long mode bits (which are switched by
hardware) and the NX bit (which is emulated by the KVM MMU).

This patch also allows KVM to ignore SCE (syscall enable) when the guest
is running in 32-bit mode.  This is because the syscall instruction is
not available in 32-bit mode on Intel processors, so the SCE bit is
effectively meaningless.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   61 ++++++++++++++++++++++++++++++++--------------------
 1 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index dcc0a84..f0f27a7 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -57,6 +57,7 @@ struct vcpu_vmx {
 		u16           fs_sel, gs_sel, ldt_sel;
 		int           gs_ldt_reload_needed;
 		int           fs_reload_needed;
+		int           guest_efer_loaded;
 	}host_state;
 
 };
@@ -74,8 +75,6 @@ static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
 static struct page *vmx_io_bitmap_a;
 static struct page *vmx_io_bitmap_b;
 
-#define EFER_SAVE_RESTORE_BITS ((u64)EFER_SCE)
-
 static struct vmcs_config {
 	int size;
 	int order;
@@ -138,18 +137,6 @@ static void save_msrs(struct kvm_msr_entry *e, int n)
 		rdmsrl(e[i].index, e[i].data);
 }
 
-static inline u64 msr_efer_save_restore_bits(struct kvm_msr_entry msr)
-{
-	return (u64)msr.data & EFER_SAVE_RESTORE_BITS;
-}
-
-static inline int msr_efer_need_save_restore(struct vcpu_vmx *vmx)
-{
-	int efer_offset = vmx->msr_offset_efer;
-	return msr_efer_save_restore_bits(vmx->host_msrs[efer_offset]) !=
-		msr_efer_save_restore_bits(vmx->guest_msrs[efer_offset]);
-}
-
 static inline int is_page_fault(u32 intr_info)
 {
 	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
@@ -351,16 +338,42 @@ static void reload_tss(void)
 
 static void load_transition_efer(struct vcpu_vmx *vmx)
 {
-	u64 trans_efer;
 	int efer_offset = vmx->msr_offset_efer;
+	u64 host_efer = vmx->host_msrs[efer_offset].data;
+	u64 guest_efer = vmx->guest_msrs[efer_offset].data;
+	u64 ignore_bits;
+
+	if (efer_offset < 0)
+		return;
+	/*
+	 * NX is emulated; LMA and LME handled by hardware; SCE meaninless
+	 * outside long mode
+	 */
+	ignore_bits = EFER_NX | EFER_SCE;
+#ifdef CONFIG_X86_64
+	ignore_bits |= EFER_LMA | EFER_LME;
+	/* SCE is meaningful only in long mode on Intel */
+	if (guest_efer & EFER_LMA)
+		ignore_bits &= ~(u64)EFER_SCE;
+#endif
+	if ((guest_efer & ~ignore_bits) == (host_efer & ~ignore_bits))
+		return;
 
-	trans_efer = vmx->host_msrs[efer_offset].data;
-	trans_efer &= ~EFER_SAVE_RESTORE_BITS;
-	trans_efer |= msr_efer_save_restore_bits(vmx->guest_msrs[efer_offset]);
-	wrmsrl(MSR_EFER, trans_efer);
+	vmx->host_state.guest_efer_loaded = 1;
+	guest_efer &= ~ignore_bits;
+	guest_efer |= host_efer & ignore_bits;
+	wrmsrl(MSR_EFER, guest_efer);
 	vmx->vcpu.stat.efer_reload++;
 }
 
+static void reload_host_efer(struct vcpu_vmx *vmx)
+{
+	if (vmx->host_state.guest_efer_loaded) {
+		vmx->host_state.guest_efer_loaded = 0;
+		load_msrs(vmx->host_msrs + vmx->msr_offset_efer, 1);
+	}
+}
+
 static void vmx_save_host_state(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -406,8 +419,7 @@ static void vmx_save_host_state(struct kvm_vcpu *vcpu)
 	}
 #endif
 	load_msrs(vmx->guest_msrs, vmx->save_nmsrs);
-	if (msr_efer_need_save_restore(vmx))
-		load_transition_efer(vmx);
+	load_transition_efer(vmx);
 }
 
 static void vmx_load_host_state(struct vcpu_vmx *vmx)
@@ -436,8 +448,7 @@ static void vmx_load_host_state(struct vcpu_vmx *vmx)
 	reload_tss();
 	save_msrs(vmx->guest_msrs, vmx->save_nmsrs);
 	load_msrs(vmx->host_msrs, vmx->save_nmsrs);
-	if (msr_efer_need_save_restore(vmx))
-		load_msrs(vmx->host_msrs + vmx->msr_offset_efer, 1);
+	reload_host_efer(vmx);
 }
 
 /*
@@ -727,8 +738,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 #ifdef CONFIG_X86_64
 	case MSR_EFER:
 		ret = kvm_set_msr_common(vcpu, msr_index, data);
-		if (vmx->host_state.loaded)
+		if (vmx->host_state.loaded) {
+			reload_host_efer(vmx);
 			load_transition_efer(vmx);
+		}
 		break;
 	case MSR_FS_BASE:
 		vmcs_writel(GUEST_FS_BASE, data);
-- 
1.5.3.7

