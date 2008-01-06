Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbYAFOnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbYAFOnX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758256AbYAFOj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:39:56 -0500
Received: from il.qumranet.com ([82.166.9.18]:46618 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166AbYAFOjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:43 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 12/33] KVM: Portability: Move round_robin_prev_vcpu and tss_addr to kvm_arch
Date: Sun,  6 Jan 2008 16:39:18 +0200
Message-Id: <1199630379-28638-13-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

This patches moves two fields round_robin_prev_vcpu and tss to kvm_arch.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h   |    3 ---
 drivers/kvm/lapic.c |    4 ++--
 drivers/kvm/vmx.c   |   12 ++++++------
 drivers/kvm/x86.h   |    4 ++++
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index d9ce916..ab9657a 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -124,9 +124,6 @@ struct kvm {
 	struct file *filp;
 	struct kvm_io_bus mmio_bus;
 	struct kvm_io_bus pio_bus;
-	int round_robin_prev_vcpu;
-	unsigned int tss_addr;
-	struct page *apic_access_page;
 	struct kvm_vm_stat stat;
 	struct kvm_arch arch;
 };
diff --git a/drivers/kvm/lapic.c b/drivers/kvm/lapic.c
index 5c9f467..8c74bf1 100644
--- a/drivers/kvm/lapic.c
+++ b/drivers/kvm/lapic.c
@@ -404,7 +404,7 @@ static struct kvm_lapic *kvm_apic_round_robin(struct kvm *kvm, u8 vector,
 	int next;
 	struct kvm_lapic *apic = NULL;
 
-	last = kvm->round_robin_prev_vcpu;
+	last = kvm->arch.round_robin_prev_vcpu;
 	next = last;
 
 	do {
@@ -417,7 +417,7 @@ static struct kvm_lapic *kvm_apic_round_robin(struct kvm *kvm, u8 vector,
 			break;
 		apic = NULL;
 	} while (next != last);
-	kvm->round_robin_prev_vcpu = next;
+	kvm->arch.round_robin_prev_vcpu = next;
 
 	if (!apic)
 		printk(KERN_DEBUG "vcpu not ready for apic_round_robin\n");
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 456eb9c..13c6a51 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1143,12 +1143,12 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
 
 static gva_t rmode_tss_base(struct kvm *kvm)
 {
-	if (!kvm->tss_addr) {
+	if (!kvm->arch.tss_addr) {
 		gfn_t base_gfn = kvm->memslots[0].base_gfn +
 				 kvm->memslots[0].npages - 3;
 		return base_gfn << PAGE_SHIFT;
 	}
-	return kvm->tss_addr;
+	return kvm->arch.tss_addr;
 }
 
 static void fix_rmode_seg(int seg, struct kvm_save_segment *save)
@@ -1472,7 +1472,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
 	int r = 0;
 
 	mutex_lock(&kvm->lock);
-	if (kvm->apic_access_page)
+	if (kvm->arch.apic_access_page)
 		goto out;
 	kvm_userspace_mem.slot = APIC_ACCESS_PAGE_PRIVATE_MEMSLOT;
 	kvm_userspace_mem.flags = 0;
@@ -1481,7 +1481,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
 	r = __kvm_set_memory_region(kvm, &kvm_userspace_mem, 0);
 	if (r)
 		goto out;
-	kvm->apic_access_page = gfn_to_page(kvm, 0xfee00);
+	kvm->arch.apic_access_page = gfn_to_page(kvm, 0xfee00);
 out:
 	mutex_unlock(&kvm->lock);
 	return r;
@@ -1698,7 +1698,7 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 
 	if (vm_need_virtualize_apic_accesses(vmx->vcpu.kvm))
 		vmcs_write64(APIC_ACCESS_ADDR,
-			     page_to_phys(vmx->vcpu.kvm->apic_access_page));
+			     page_to_phys(vmx->vcpu.kvm->arch.apic_access_page));
 
 	vmx->vcpu.arch.cr0 = 0x60000010;
 	vmx_set_cr0(&vmx->vcpu, vmx->vcpu.arch.cr0); /* enter rmode */
@@ -1788,7 +1788,7 @@ static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
 	ret = kvm_set_memory_region(kvm, &tss_mem, 0);
 	if (ret)
 		return ret;
-	kvm->tss_addr = addr;
+	kvm->arch.tss_addr = addr;
 	return 0;
 }
 
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index ef23a30..9455839 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -277,6 +277,10 @@ struct kvm_arch{
 	struct list_head active_mmu_pages;
 	struct kvm_pic *vpic;
 	struct kvm_ioapic *vioapic;
+
+	int round_robin_prev_vcpu;
+	unsigned int tss_addr;
+	struct page *apic_access_page;
 };
 
 struct kvm_vcpu_stat {
-- 
1.5.3.7

