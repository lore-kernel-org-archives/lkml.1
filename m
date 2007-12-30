Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbXL3HWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbXL3HWr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:22:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756537AbXL3HL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:27 -0500
Received: from il.qumranet.com ([82.166.9.18]:59494 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755609AbXL3HKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:50 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 43/52] KVM: Don't bother the mmu if cr3 load doesn't change cr3
Date: Sun, 30 Dec 2007 09:10:29 +0200
Message-Id: <1198998638-22713-44-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the guest requests just a tlb flush, don't take the vm lock and
drop the mmu context pointlessly.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |    2 +-
 drivers/kvm/x86.c |   25 +++++++++++++++++++++++++
 drivers/kvm/x86.h |    1 +
 3 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 281dd5f..346aa65 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -1086,7 +1086,7 @@ static int nonpaging_init_context(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu)
+void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.tlb_flush;
 	kvm_x86_ops->tlb_flush(vcpu);
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index ac09f38..15e1203 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -166,6 +166,26 @@ out:
 	return ret;
 }
 
+static bool pdptrs_changed(struct kvm_vcpu *vcpu)
+{
+	u64 pdpte[ARRAY_SIZE(vcpu->pdptrs)];
+	bool changed = true;
+	int r;
+
+	if (is_long_mode(vcpu) || !is_pae(vcpu))
+		return false;
+
+	mutex_lock(&vcpu->kvm->lock);
+	r = kvm_read_guest(vcpu->kvm, vcpu->cr3 & ~31u, pdpte, sizeof(pdpte));
+	if (r < 0)
+		goto out;
+	changed = memcmp(pdpte, vcpu->pdptrs, sizeof(pdpte)) != 0;
+out:
+	mutex_unlock(&vcpu->kvm->lock);
+
+	return changed;
+}
+
 void set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	if (cr0 & CR0_RESERVED_BITS) {
@@ -271,6 +291,11 @@ EXPORT_SYMBOL_GPL(set_cr4);
 
 void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
+	if (cr3 == vcpu->cr3 && !pdptrs_changed(vcpu)) {
+		kvm_mmu_flush_tlb(vcpu);
+		return;
+	}
+
 	if (is_long_mode(vcpu)) {
 		if (cr3 & CR3_L_MODE_RESERVED_BITS) {
 			printk(KERN_DEBUG "set_cr3: #GP, reserved bits\n");
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index 71f2477..b1528c9 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -299,6 +299,7 @@ int emulator_write_emulated(unsigned long addr,
 
 unsigned long segment_base(u16 selector);
 
+void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu);
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		       const u8 *new, int bytes);
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
-- 
1.5.3.7

