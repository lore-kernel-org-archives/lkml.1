Return-Path: <linux-kernel-owner+w=401wt.eu-S1751716AbXLZLNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbXLZLNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbXLZLGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:38 -0500
Received: from il.qumranet.com ([82.166.9.18]:50465 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbXLZLGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:06 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 21/55] KVM: Portability: Move control register helper functions to x86.c
Date: Wed, 26 Dec 2007 13:05:26 +0200
Message-Id: <1198667160-22953-22-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

This patch moves the definitions of CR0_RESERVED_BITS,
CR4_RESERVED_BITS, and CR8_RESERVED_BITS along with the following
functions from kvm_main.c to x86.c:
set_cr0(), set_cr3(), set_cr4(), set_cr8(), get_cr8(), lmsw(),
load_pdptrs()
The static function wrapper inject_gp is duplicated in kvm_main.c and
x86.c for now, the version in kvm_main.c should disappear once the last
user of it is gone too.
The function load_pdptrs is no longer static, and now defined in x86.h
for the time being, until the last user of it is gone from kvm_main.c.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |  219 ----------------------------------------------
 drivers/kvm/x86.c      |  224 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/kvm/x86.h      |    2 +-
 3 files changed, 225 insertions(+), 220 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index d6545a7..af4b470 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -90,17 +90,6 @@ static struct kvm_stats_debugfs_item {
 
 static struct dentry *debugfs_dir;
 
-#define CR0_RESERVED_BITS						\
-	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
-			  | X86_CR0_ET | X86_CR0_NE | X86_CR0_WP | X86_CR0_AM \
-			  | X86_CR0_NW | X86_CR0_CD | X86_CR0_PG))
-#define CR4_RESERVED_BITS						\
-	(~(unsigned long)(X86_CR4_VME | X86_CR4_PVI | X86_CR4_TSD | X86_CR4_DE\
-			  | X86_CR4_PSE | X86_CR4_PAE | X86_CR4_MCE	\
-			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR	\
-			  | X86_CR4_OSXMMEXCPT | X86_CR4_VMXE))
-
-#define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 #define EFER_RESERVED_BITS 0xfffffffffffff2fe
 
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
@@ -348,214 +337,6 @@ static void inject_gp(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->inject_gp(vcpu, 0);
 }
 
-/*
- * Load the pae pdptrs.  Return true is they are all valid.
- */
-static int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
-{
-	gfn_t pdpt_gfn = cr3 >> PAGE_SHIFT;
-	unsigned offset = ((cr3 & (PAGE_SIZE-1)) >> 5) << 2;
-	int i;
-	int ret;
-	u64 pdpte[ARRAY_SIZE(vcpu->pdptrs)];
-
-	mutex_lock(&vcpu->kvm->lock);
-	ret = kvm_read_guest_page(vcpu->kvm, pdpt_gfn, pdpte,
-				  offset * sizeof(u64), sizeof(pdpte));
-	if (ret < 0) {
-		ret = 0;
-		goto out;
-	}
-	for (i = 0; i < ARRAY_SIZE(pdpte); ++i) {
-		if ((pdpte[i] & 1) && (pdpte[i] & 0xfffffff0000001e6ull)) {
-			ret = 0;
-			goto out;
-		}
-	}
-	ret = 1;
-
-	memcpy(vcpu->pdptrs, pdpte, sizeof(vcpu->pdptrs));
-out:
-	mutex_unlock(&vcpu->kvm->lock);
-
-	return ret;
-}
-
-void set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
-{
-	if (cr0 & CR0_RESERVED_BITS) {
-		printk(KERN_DEBUG "set_cr0: 0x%lx #GP, reserved bits 0x%lx\n",
-		       cr0, vcpu->cr0);
-		inject_gp(vcpu);
-		return;
-	}
-
-	if ((cr0 & X86_CR0_NW) && !(cr0 & X86_CR0_CD)) {
-		printk(KERN_DEBUG "set_cr0: #GP, CD == 0 && NW == 1\n");
-		inject_gp(vcpu);
-		return;
-	}
-
-	if ((cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PE)) {
-		printk(KERN_DEBUG "set_cr0: #GP, set PG flag "
-		       "and a clear PE flag\n");
-		inject_gp(vcpu);
-		return;
-	}
-
-	if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
-#ifdef CONFIG_X86_64
-		if ((vcpu->shadow_efer & EFER_LME)) {
-			int cs_db, cs_l;
-
-			if (!is_pae(vcpu)) {
-				printk(KERN_DEBUG "set_cr0: #GP, start paging "
-				       "in long mode while PAE is disabled\n");
-				inject_gp(vcpu);
-				return;
-			}
-			kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
-			if (cs_l) {
-				printk(KERN_DEBUG "set_cr0: #GP, start paging "
-				       "in long mode while CS.L == 1\n");
-				inject_gp(vcpu);
-				return;
-
-			}
-		} else
-#endif
-		if (is_pae(vcpu) && !load_pdptrs(vcpu, vcpu->cr3)) {
-			printk(KERN_DEBUG "set_cr0: #GP, pdptrs "
-			       "reserved bits\n");
-			inject_gp(vcpu);
-			return;
-		}
-
-	}
-
-	kvm_x86_ops->set_cr0(vcpu, cr0);
-	vcpu->cr0 = cr0;
-
-	mutex_lock(&vcpu->kvm->lock);
-	kvm_mmu_reset_context(vcpu);
-	mutex_unlock(&vcpu->kvm->lock);
-	return;
-}
-EXPORT_SYMBOL_GPL(set_cr0);
-
-void lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
-{
-	set_cr0(vcpu, (vcpu->cr0 & ~0x0ful) | (msw & 0x0f));
-}
-EXPORT_SYMBOL_GPL(lmsw);
-
-void set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
-{
-	if (cr4 & CR4_RESERVED_BITS) {
-		printk(KERN_DEBUG "set_cr4: #GP, reserved bits\n");
-		inject_gp(vcpu);
-		return;
-	}
-
-	if (is_long_mode(vcpu)) {
-		if (!(cr4 & X86_CR4_PAE)) {
-			printk(KERN_DEBUG "set_cr4: #GP, clearing PAE while "
-			       "in long mode\n");
-			inject_gp(vcpu);
-			return;
-		}
-	} else if (is_paging(vcpu) && !is_pae(vcpu) && (cr4 & X86_CR4_PAE)
-		   && !load_pdptrs(vcpu, vcpu->cr3)) {
-		printk(KERN_DEBUG "set_cr4: #GP, pdptrs reserved bits\n");
-		inject_gp(vcpu);
-		return;
-	}
-
-	if (cr4 & X86_CR4_VMXE) {
-		printk(KERN_DEBUG "set_cr4: #GP, setting VMXE\n");
-		inject_gp(vcpu);
-		return;
-	}
-	kvm_x86_ops->set_cr4(vcpu, cr4);
-	vcpu->cr4 = cr4;
-	mutex_lock(&vcpu->kvm->lock);
-	kvm_mmu_reset_context(vcpu);
-	mutex_unlock(&vcpu->kvm->lock);
-}
-EXPORT_SYMBOL_GPL(set_cr4);
-
-void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
-{
-	if (is_long_mode(vcpu)) {
-		if (cr3 & CR3_L_MODE_RESERVED_BITS) {
-			printk(KERN_DEBUG "set_cr3: #GP, reserved bits\n");
-			inject_gp(vcpu);
-			return;
-		}
-	} else {
-		if (is_pae(vcpu)) {
-			if (cr3 & CR3_PAE_RESERVED_BITS) {
-				printk(KERN_DEBUG
-				       "set_cr3: #GP, reserved bits\n");
-				inject_gp(vcpu);
-				return;
-			}
-			if (is_paging(vcpu) && !load_pdptrs(vcpu, cr3)) {
-				printk(KERN_DEBUG "set_cr3: #GP, pdptrs "
-				       "reserved bits\n");
-				inject_gp(vcpu);
-				return;
-			}
-		}
-		/*
-		 * We don't check reserved bits in nonpae mode, because
-		 * this isn't enforced, and VMware depends on this.
-		 */
-	}
-
-	mutex_lock(&vcpu->kvm->lock);
-	/*
-	 * Does the new cr3 value map to physical memory? (Note, we
-	 * catch an invalid cr3 even in real-mode, because it would
-	 * cause trouble later on when we turn on paging anyway.)
-	 *
-	 * A real CPU would silently accept an invalid cr3 and would
-	 * attempt to use it - with largely undefined (and often hard
-	 * to debug) behavior on the guest side.
-	 */
-	if (unlikely(!gfn_to_memslot(vcpu->kvm, cr3 >> PAGE_SHIFT)))
-		inject_gp(vcpu);
-	else {
-		vcpu->cr3 = cr3;
-		vcpu->mmu.new_cr3(vcpu);
-	}
-	mutex_unlock(&vcpu->kvm->lock);
-}
-EXPORT_SYMBOL_GPL(set_cr3);
-
-void set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8)
-{
-	if (cr8 & CR8_RESERVED_BITS) {
-		printk(KERN_DEBUG "set_cr8: #GP, reserved bits 0x%lx\n", cr8);
-		inject_gp(vcpu);
-		return;
-	}
-	if (irqchip_in_kernel(vcpu->kvm))
-		kvm_lapic_set_tpr(vcpu, cr8);
-	else
-		vcpu->cr8 = cr8;
-}
-EXPORT_SYMBOL_GPL(set_cr8);
-
-unsigned long get_cr8(struct kvm_vcpu *vcpu)
-{
-	if (irqchip_in_kernel(vcpu->kvm))
-		return kvm_lapic_get_cr8(vcpu);
-	else
-		return vcpu->cr8;
-}
-EXPORT_SYMBOL_GPL(get_cr8);
-
 void fx_init(struct kvm_vcpu *vcpu)
 {
 	unsigned after_mxcsr_mask;
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index c26e371..a728af8 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -27,6 +27,17 @@
 #include <asm/uaccess.h>
 
 #define MAX_IO_MSRS 256
+#define CR0_RESERVED_BITS						\
+	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
+			  | X86_CR0_ET | X86_CR0_NE | X86_CR0_WP | X86_CR0_AM \
+			  | X86_CR0_NW | X86_CR0_CD | X86_CR0_PG))
+#define CR4_RESERVED_BITS						\
+	(~(unsigned long)(X86_CR4_VME | X86_CR4_PVI | X86_CR4_TSD | X86_CR4_DE\
+			  | X86_CR4_PSE | X86_CR4_PAE | X86_CR4_MCE	\
+			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR	\
+			  | X86_CR4_OSXMMEXCPT | X86_CR4_VMXE))
+
+#define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
 unsigned long segment_base(u16 selector)
 {
@@ -78,6 +89,219 @@ void kvm_set_apic_base(struct kvm_vcpu *vcpu, u64 data)
 }
 EXPORT_SYMBOL_GPL(kvm_set_apic_base);
 
+static void inject_gp(struct kvm_vcpu *vcpu)
+{
+	kvm_x86_ops->inject_gp(vcpu, 0);
+}
+
+/*
+ * Load the pae pdptrs.  Return true is they are all valid.
+ */
+int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
+{
+	gfn_t pdpt_gfn = cr3 >> PAGE_SHIFT;
+	unsigned offset = ((cr3 & (PAGE_SIZE-1)) >> 5) << 2;
+	int i;
+	int ret;
+	u64 pdpte[ARRAY_SIZE(vcpu->pdptrs)];
+
+	mutex_lock(&vcpu->kvm->lock);
+	ret = kvm_read_guest_page(vcpu->kvm, pdpt_gfn, pdpte,
+				  offset * sizeof(u64), sizeof(pdpte));
+	if (ret < 0) {
+		ret = 0;
+		goto out;
+	}
+	for (i = 0; i < ARRAY_SIZE(pdpte); ++i) {
+		if ((pdpte[i] & 1) && (pdpte[i] & 0xfffffff0000001e6ull)) {
+			ret = 0;
+			goto out;
+		}
+	}
+	ret = 1;
+
+	memcpy(vcpu->pdptrs, pdpte, sizeof(vcpu->pdptrs));
+out:
+	mutex_unlock(&vcpu->kvm->lock);
+
+	return ret;
+}
+
+void set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
+{
+	if (cr0 & CR0_RESERVED_BITS) {
+		printk(KERN_DEBUG "set_cr0: 0x%lx #GP, reserved bits 0x%lx\n",
+		       cr0, vcpu->cr0);
+		inject_gp(vcpu);
+		return;
+	}
+
+	if ((cr0 & X86_CR0_NW) && !(cr0 & X86_CR0_CD)) {
+		printk(KERN_DEBUG "set_cr0: #GP, CD == 0 && NW == 1\n");
+		inject_gp(vcpu);
+		return;
+	}
+
+	if ((cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PE)) {
+		printk(KERN_DEBUG "set_cr0: #GP, set PG flag "
+		       "and a clear PE flag\n");
+		inject_gp(vcpu);
+		return;
+	}
+
+	if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
+#ifdef CONFIG_X86_64
+		if ((vcpu->shadow_efer & EFER_LME)) {
+			int cs_db, cs_l;
+
+			if (!is_pae(vcpu)) {
+				printk(KERN_DEBUG "set_cr0: #GP, start paging "
+				       "in long mode while PAE is disabled\n");
+				inject_gp(vcpu);
+				return;
+			}
+			kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
+			if (cs_l) {
+				printk(KERN_DEBUG "set_cr0: #GP, start paging "
+				       "in long mode while CS.L == 1\n");
+				inject_gp(vcpu);
+				return;
+
+			}
+		} else
+#endif
+		if (is_pae(vcpu) && !load_pdptrs(vcpu, vcpu->cr3)) {
+			printk(KERN_DEBUG "set_cr0: #GP, pdptrs "
+			       "reserved bits\n");
+			inject_gp(vcpu);
+			return;
+		}
+
+	}
+
+	kvm_x86_ops->set_cr0(vcpu, cr0);
+	vcpu->cr0 = cr0;
+
+	mutex_lock(&vcpu->kvm->lock);
+	kvm_mmu_reset_context(vcpu);
+	mutex_unlock(&vcpu->kvm->lock);
+	return;
+}
+EXPORT_SYMBOL_GPL(set_cr0);
+
+void lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
+{
+	set_cr0(vcpu, (vcpu->cr0 & ~0x0ful) | (msw & 0x0f));
+}
+EXPORT_SYMBOL_GPL(lmsw);
+
+void set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+{
+	if (cr4 & CR4_RESERVED_BITS) {
+		printk(KERN_DEBUG "set_cr4: #GP, reserved bits\n");
+		inject_gp(vcpu);
+		return;
+	}
+
+	if (is_long_mode(vcpu)) {
+		if (!(cr4 & X86_CR4_PAE)) {
+			printk(KERN_DEBUG "set_cr4: #GP, clearing PAE while "
+			       "in long mode\n");
+			inject_gp(vcpu);
+			return;
+		}
+	} else if (is_paging(vcpu) && !is_pae(vcpu) && (cr4 & X86_CR4_PAE)
+		   && !load_pdptrs(vcpu, vcpu->cr3)) {
+		printk(KERN_DEBUG "set_cr4: #GP, pdptrs reserved bits\n");
+		inject_gp(vcpu);
+		return;
+	}
+
+	if (cr4 & X86_CR4_VMXE) {
+		printk(KERN_DEBUG "set_cr4: #GP, setting VMXE\n");
+		inject_gp(vcpu);
+		return;
+	}
+	kvm_x86_ops->set_cr4(vcpu, cr4);
+	vcpu->cr4 = cr4;
+	mutex_lock(&vcpu->kvm->lock);
+	kvm_mmu_reset_context(vcpu);
+	mutex_unlock(&vcpu->kvm->lock);
+}
+EXPORT_SYMBOL_GPL(set_cr4);
+
+void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
+{
+	if (is_long_mode(vcpu)) {
+		if (cr3 & CR3_L_MODE_RESERVED_BITS) {
+			printk(KERN_DEBUG "set_cr3: #GP, reserved bits\n");
+			inject_gp(vcpu);
+			return;
+		}
+	} else {
+		if (is_pae(vcpu)) {
+			if (cr3 & CR3_PAE_RESERVED_BITS) {
+				printk(KERN_DEBUG
+				       "set_cr3: #GP, reserved bits\n");
+				inject_gp(vcpu);
+				return;
+			}
+			if (is_paging(vcpu) && !load_pdptrs(vcpu, cr3)) {
+				printk(KERN_DEBUG "set_cr3: #GP, pdptrs "
+				       "reserved bits\n");
+				inject_gp(vcpu);
+				return;
+			}
+		}
+		/*
+		 * We don't check reserved bits in nonpae mode, because
+		 * this isn't enforced, and VMware depends on this.
+		 */
+	}
+
+	mutex_lock(&vcpu->kvm->lock);
+	/*
+	 * Does the new cr3 value map to physical memory? (Note, we
+	 * catch an invalid cr3 even in real-mode, because it would
+	 * cause trouble later on when we turn on paging anyway.)
+	 *
+	 * A real CPU would silently accept an invalid cr3 and would
+	 * attempt to use it - with largely undefined (and often hard
+	 * to debug) behavior on the guest side.
+	 */
+	if (unlikely(!gfn_to_memslot(vcpu->kvm, cr3 >> PAGE_SHIFT)))
+		inject_gp(vcpu);
+	else {
+		vcpu->cr3 = cr3;
+		vcpu->mmu.new_cr3(vcpu);
+	}
+	mutex_unlock(&vcpu->kvm->lock);
+}
+EXPORT_SYMBOL_GPL(set_cr3);
+
+void set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8)
+{
+	if (cr8 & CR8_RESERVED_BITS) {
+		printk(KERN_DEBUG "set_cr8: #GP, reserved bits 0x%lx\n", cr8);
+		inject_gp(vcpu);
+		return;
+	}
+	if (irqchip_in_kernel(vcpu->kvm))
+		kvm_lapic_set_tpr(vcpu, cr8);
+	else
+		vcpu->cr8 = cr8;
+}
+EXPORT_SYMBOL_GPL(set_cr8);
+
+unsigned long get_cr8(struct kvm_vcpu *vcpu)
+{
+	if (irqchip_in_kernel(vcpu->kvm))
+		return kvm_lapic_get_cr8(vcpu);
+	else
+		return vcpu->cr8;
+}
+EXPORT_SYMBOL_GPL(get_cr8);
+
 /*
  * List of msr numbers which we expose to userspace through KVM_GET_MSRS
  * and KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index 20da8e9..5592456 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -125,5 +125,5 @@ static inline int is_paging(struct kvm_vcpu *vcpu)
 	return vcpu->cr0 & X86_CR0_PG;
 }
 
-
+int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 #endif
-- 
1.5.3.7

