Return-Path: <linux-kernel-owner+w=401wt.eu-S933711AbZHWMBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711AbZHWMBN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933561AbZHWMAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:00:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933548AbZHWL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 33/46] KVM: VMX: Introduce KVM_SET_IDENTITY_MAP_ADDR ioctl
Date: Sun, 23 Aug 2009 14:56:32 +0300
Message-Id: <1251028605-31977-34-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Now KVM allow guest to modify guest's physical address of EPT's identity mapping page.

(change from v1, discard unnecessary check, change ioctl to accept parameter
address rather than value)

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/vmx.c              |   15 ++++++++++-----
 arch/x86/kvm/x86.c              |   19 +++++++++++++++++++
 include/linux/kvm.h             |    2 ++
 4 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 08732d7..e210b21 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -411,6 +411,7 @@ struct kvm_arch{
 
 	struct page *ept_identity_pagetable;
 	bool ept_identity_pagetable_done;
+	gpa_t ept_identity_map_addr;
 
 	unsigned long irq_sources_bitmap;
 	unsigned long irq_states[KVM_IOAPIC_NUM_PINS];
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c6256b9..686e1ab 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1719,7 +1719,7 @@ static void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		eptp = construct_eptp(cr3);
 		vmcs_write64(EPT_POINTER, eptp);
 		guest_cr3 = is_paging(vcpu) ? vcpu->arch.cr3 :
-			VMX_EPT_IDENTITY_PAGETABLE_ADDR;
+			vcpu->kvm->arch.ept_identity_map_addr;
 	}
 
 	vmx_flush_tlb(vcpu);
@@ -2122,7 +2122,7 @@ static int init_rmode_identity_map(struct kvm *kvm)
 	if (likely(kvm->arch.ept_identity_pagetable_done))
 		return 1;
 	ret = 0;
-	identity_map_pfn = VMX_EPT_IDENTITY_PAGETABLE_ADDR >> PAGE_SHIFT;
+	identity_map_pfn = kvm->arch.ept_identity_map_addr >> PAGE_SHIFT;
 	r = kvm_clear_guest_page(kvm, identity_map_pfn, 0, PAGE_SIZE);
 	if (r < 0)
 		goto out;
@@ -2191,14 +2191,15 @@ static int alloc_identity_pagetable(struct kvm *kvm)
 		goto out;
 	kvm_userspace_mem.slot = IDENTITY_PAGETABLE_PRIVATE_MEMSLOT;
 	kvm_userspace_mem.flags = 0;
-	kvm_userspace_mem.guest_phys_addr = VMX_EPT_IDENTITY_PAGETABLE_ADDR;
+	kvm_userspace_mem.guest_phys_addr =
+		kvm->arch.ept_identity_map_addr;
 	kvm_userspace_mem.memory_size = PAGE_SIZE;
 	r = __kvm_set_memory_region(kvm, &kvm_userspace_mem, 0);
 	if (r)
 		goto out;
 
 	kvm->arch.ept_identity_pagetable = gfn_to_page(kvm,
-			VMX_EPT_IDENTITY_PAGETABLE_ADDR >> PAGE_SHIFT);
+			kvm->arch.ept_identity_map_addr >> PAGE_SHIFT);
 out:
 	up_write(&kvm->slots_lock);
 	return r;
@@ -3814,9 +3815,13 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 		if (alloc_apic_access_page(kvm) != 0)
 			goto free_vmcs;
 
-	if (enable_ept)
+	if (enable_ept) {
+		if (!kvm->arch.ept_identity_map_addr)
+			kvm->arch.ept_identity_map_addr =
+				VMX_EPT_IDENTITY_PAGETABLE_ADDR;
 		if (alloc_identity_pagetable(kvm) != 0)
 			goto free_vmcs;
+	}
 
 	return &vmx->vcpu;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 18ce27f..2539e9a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1206,6 +1206,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_PIT2:
 	case KVM_CAP_PIT_STATE2:
+	case KVM_CAP_SET_IDENTITY_MAP_ADDR:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -1906,6 +1907,13 @@ static int kvm_vm_ioctl_set_tss_addr(struct kvm *kvm, unsigned long addr)
 	return ret;
 }
 
+static int kvm_vm_ioctl_set_identity_map_addr(struct kvm *kvm,
+					      u64 ident_addr)
+{
+	kvm->arch.ept_identity_map_addr = ident_addr;
+	return 0;
+}
+
 static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
 					  u32 kvm_nr_mmu_pages)
 {
@@ -2169,6 +2177,17 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		if (r < 0)
 			goto out;
 		break;
+	case KVM_SET_IDENTITY_MAP_ADDR: {
+		u64 ident_addr;
+
+		r = -EFAULT;
+		if (copy_from_user(&ident_addr, argp, sizeof ident_addr))
+			goto out;
+		r = kvm_vm_ioctl_set_identity_map_addr(kvm, ident_addr);
+		if (r < 0)
+			goto out;
+		break;
+	}
 	case KVM_SET_MEMORY_REGION: {
 		struct kvm_memory_region kvm_mem;
 		struct kvm_userspace_memory_region kvm_userspace_mem;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 230a91a..f8f8900 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -435,6 +435,7 @@ struct kvm_ioeventfd {
 #define KVM_CAP_PIT_STATE2 35
 #endif
 #define KVM_CAP_IOEVENTFD 36
+#define KVM_CAP_SET_IDENTITY_MAP_ADDR 37
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -512,6 +513,7 @@ struct kvm_irqfd {
 #define KVM_SET_USER_MEMORY_REGION _IOW(KVMIO, 0x46,\
 					struct kvm_userspace_memory_region)
 #define KVM_SET_TSS_ADDR          _IO(KVMIO, 0x47)
+#define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO, 0x48, __u64)
 /* Device model IOC */
 #define KVM_CREATE_IRQCHIP	  _IO(KVMIO,  0x60)
 #define KVM_IRQ_LINE		  _IOW(KVMIO, 0x61, struct kvm_irq_level)
-- 
1.6.4.1

