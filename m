Return-Path: <linux-kernel-owner+w=401wt.eu-S964885AbXBYMzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964885AbXBYMzK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 07:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964888AbXBYMzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 07:55:10 -0500
Received: from il.qumranet.com ([82.166.9.18]:37857 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964892AbXBYMzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 07:55:09 -0500
Subject: [PATCH 1/4] KVM: Add missing calls to mark_page_dirty()
From: Avi Kivity <avi@qumranet.com>
Date: Sun, 25 Feb 2007 12:55:07 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45E186FE.2000909@qumranet.com>
In-Reply-To: <45E186FE.2000909@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20070225125507.1A4CF250196@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A few places where we modify guest memory fail to call mark_page_dirty(),
causing live migration to fail.  This adds the missing calls.

Signed-off-by: Uri Lublin <uril@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index a593d09..edff405 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -228,12 +228,15 @@ int kvm_write_guest(struct kvm_vcpu *vcpu, gva_t addr, unsigned long size,
 		unsigned now;
 		unsigned offset;
 		hva_t guest_buf;
+		gfn_t gfn;
 
 		paddr = gva_to_hpa(vcpu, addr);
 
 		if (is_error_hpa(paddr))
 			break;
 
+		gfn = vcpu->mmu.gva_to_gpa(vcpu, addr) >> PAGE_SHIFT;
+		mark_page_dirty(vcpu->kvm, gfn);
 		guest_buf = (hva_t)kmap_atomic(
 				pfn_to_page(paddr >> PAGE_SHIFT), KM_USER0);
 		offset = addr & ~PAGE_MASK;
@@ -953,6 +956,7 @@ static int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 		return 0;
 	page = gfn_to_page(m, gpa >> PAGE_SHIFT);
 	kvm_mmu_pre_write(vcpu, gpa, bytes);
+	mark_page_dirty(vcpu->kvm, gpa >> PAGE_SHIFT);
 	virt = kmap_atomic(page, KM_USER0);
 	memcpy(virt + offset_in_page(gpa), &val, bytes);
 	kunmap_atomic(virt, KM_USER0);
@@ -1294,6 +1298,7 @@ static int vcpu_register_para(struct kvm_vcpu *vcpu, gpa_t para_state_gpa)
 	if (is_error_hpa(para_state_hpa))
 		goto err_gp;
 
+	mark_page_dirty(vcpu->kvm, para_state_gpa >> PAGE_SHIFT);
 	para_state_page = pfn_to_page(para_state_hpa >> PAGE_SHIFT);
 	para_state = kmap_atomic(para_state_page, KM_USER0);
 
@@ -1323,6 +1328,7 @@ static int vcpu_register_para(struct kvm_vcpu *vcpu, gpa_t para_state_gpa)
 	vcpu->para_state_gpa = para_state_gpa;
 	vcpu->hypercall_gpa = hypercall_gpa;
 
+	mark_page_dirty(vcpu->kvm, hypercall_gpa >> PAGE_SHIFT);
 	hypercall = kmap_atomic(pfn_to_page(hypercall_hpa >> PAGE_SHIFT),
 				KM_USER1) + (hypercall_hpa & ~PAGE_MASK);
 	kvm_arch_ops->patch_hypercall(vcpu, hypercall);
