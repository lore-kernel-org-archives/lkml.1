Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbXCRI53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbXCRI53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 04:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXCRI53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 04:57:29 -0400
Received: from il.qumranet.com ([82.166.9.18]:48688 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbXCRI52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 04:57:28 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [GIT PULL][RESEND] KVM updates for Linux 2.6.21-rc4
Date: Sun, 18 Mar 2007 10:57:26 +0200
Message-Id: <11742082461490-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.3.355.g2f176
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the 'linus' branch of the git repository at

  git://kvm.qumranet.com/home/avi/kvm.git

containing the following kvm stability and correctness fixes:

Avi Kivity (4):
      KVM: Unset kvm_arch_ops if arch module loading failed
      KVM: Fix guest sysenter on vmx
      KVM: MMU: Fix guest writes to nonpae pde
      KVM: MMU: Fix host memory corruption on i386 with >= 4GB ram

 drivers/kvm/kvm_main.c |    4 ++-
 drivers/kvm/mmu.c      |   52 ++++++++++++++++++++++++++++++++++-------------
 drivers/kvm/vmx.c      |    8 +++---
 3 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index a163bca..dc7a8c7 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2464,7 +2464,7 @@ int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module)
 
 	r = kvm_arch_ops->hardware_setup();
 	if (r < 0)
-	    return r;
+		goto out;
 
 	on_each_cpu(kvm_arch_ops->hardware_enable, NULL, 0, 1);
 	r = register_cpu_notifier(&kvm_cpu_notifier);
@@ -2500,6 +2500,8 @@ out_free_2:
 out_free_1:
 	on_each_cpu(kvm_arch_ops->hardware_disable, NULL, 0, 1);
 	kvm_arch_ops->hardware_unsetup();
+out:
+	kvm_arch_ops = NULL;
 	return r;
 }
 
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index a1a9336..e85b4c7 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -131,7 +131,7 @@ static int dbg = 1;
 	(((address) >> PT32_LEVEL_SHIFT(level)) & ((1 << PT32_LEVEL_BITS) - 1))
 
 
-#define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & PAGE_MASK)
+#define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
 #define PT64_DIR_BASE_ADDR_MASK \
 	(PT64_BASE_ADDR_MASK & ~((1ULL << (PAGE_SHIFT + PT64_LEVEL_BITS)) - 1))
 
@@ -406,8 +406,8 @@ static void rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 			spte = desc->shadow_ptes[0];
 		}
 		BUG_ON(!spte);
-		BUG_ON((*spte & PT64_BASE_ADDR_MASK) !=
-		       page_to_pfn(page) << PAGE_SHIFT);
+		BUG_ON((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT
+		       != page_to_pfn(page));
 		BUG_ON(!(*spte & PT_PRESENT_MASK));
 		BUG_ON(!(*spte & PT_WRITABLE_MASK));
 		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
@@ -1093,22 +1093,40 @@ out:
 	return r;
 }
 
+static void mmu_pre_write_zap_pte(struct kvm_vcpu *vcpu,
+				  struct kvm_mmu_page *page,
+				  u64 *spte)
+{
+	u64 pte;
+	struct kvm_mmu_page *child;
+
+	pte = *spte;
+	if (is_present_pte(pte)) {
+		if (page->role.level == PT_PAGE_TABLE_LEVEL)
+			rmap_remove(vcpu, spte);
+		else {
+			child = page_header(pte & PT64_BASE_ADDR_MASK);
+			mmu_page_remove_parent_pte(vcpu, child, spte);
+		}
+	}
+	*spte = 0;
+}
+
 void kvm_mmu_pre_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes)
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	struct kvm_mmu_page *page;
-	struct kvm_mmu_page *child;
 	struct hlist_node *node, *n;
 	struct hlist_head *bucket;
 	unsigned index;
 	u64 *spte;
-	u64 pte;
 	unsigned offset = offset_in_page(gpa);
 	unsigned pte_size;
 	unsigned page_offset;
 	unsigned misaligned;
 	int level;
 	int flooded = 0;
+	int npte;
 
 	pgprintk("%s: gpa %llx bytes %d\n", __FUNCTION__, gpa, bytes);
 	if (gfn == vcpu->last_pt_write_gfn) {
@@ -1144,22 +1162,26 @@ void kvm_mmu_pre_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes)
 		}
 		page_offset = offset;
 		level = page->role.level;
+		npte = 1;
 		if (page->role.glevels == PT32_ROOT_LEVEL) {
-			page_offset <<= 1;          /* 32->64 */
+			page_offset <<= 1;	/* 32->64 */
+			/*
+			 * A 32-bit pde maps 4MB while the shadow pdes map
+			 * only 2MB.  So we need to double the offset again
+			 * and zap two pdes instead of one.
+			 */
+			if (level == PT32_ROOT_LEVEL) {
+				page_offset <<= 1;
+				npte = 2;
+			}
 			page_offset &= ~PAGE_MASK;
 		}
 		spte = __va(page->page_hpa);
 		spte += page_offset / sizeof(*spte);
-		pte = *spte;
-		if (is_present_pte(pte)) {
-			if (level == PT_PAGE_TABLE_LEVEL)
-				rmap_remove(vcpu, spte);
-			else {
-				child = page_header(pte & PT64_BASE_ADDR_MASK);
-				mmu_page_remove_parent_pte(vcpu, child, spte);
-			}
+		while (npte--) {
+			mmu_pre_write_zap_pte(vcpu, page, spte);
+			++spte;
 		}
-		*spte = 0;
 	}
 }
 
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index c07178e..bfa0ce4 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -371,10 +371,10 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 		data = vmcs_read32(GUEST_SYSENTER_CS);
 		break;
 	case MSR_IA32_SYSENTER_EIP:
-		data = vmcs_read32(GUEST_SYSENTER_EIP);
+		data = vmcs_readl(GUEST_SYSENTER_EIP);
 		break;
 	case MSR_IA32_SYSENTER_ESP:
-		data = vmcs_read32(GUEST_SYSENTER_ESP);
+		data = vmcs_readl(GUEST_SYSENTER_ESP);
 		break;
 	default:
 		msr = find_msr_entry(vcpu, msr_index);
@@ -412,10 +412,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 		vmcs_write32(GUEST_SYSENTER_CS, data);
 		break;
 	case MSR_IA32_SYSENTER_EIP:
-		vmcs_write32(GUEST_SYSENTER_EIP, data);
+		vmcs_writel(GUEST_SYSENTER_EIP, data);
 		break;
 	case MSR_IA32_SYSENTER_ESP:
-		vmcs_write32(GUEST_SYSENTER_ESP, data);
+		vmcs_writel(GUEST_SYSENTER_ESP, data);
 		break;
 	case MSR_IA32_TIME_STAMP_COUNTER:
 		guest_write_tsc(data);
