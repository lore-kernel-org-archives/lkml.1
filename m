Return-Path: <linux-kernel-owner+w=401wt.eu-S1760859AbYDQJTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760859AbYDQJTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756448AbYDQJLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:21 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:59027
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760121AbYDQJLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:11:00 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>
Subject: [PATCH 18/45] KVM: MMU: unify slots_lock usage
Date: Thu, 17 Apr 2008 12:10:23 +0300
Message-Id: <1208423450-29415-19-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <marcelo@kvack.org>

Unify slots_lock acquision around vcpu_run(). This is simpler and less
error-prone.

Also fix some callsites that were not grabbing the lock properly.

[avi: drop slots_lock while in guest mode to avoid holding the lock
      for indefinite periods]

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c         |   13 +---------
 arch/x86/kvm/paging_tmpl.h |    4 ---
 arch/x86/kvm/vmx.c         |    6 ++--
 arch/x86/kvm/x86.c         |   53 ++++++++++++++++---------------------------
 include/asm-x86/kvm_host.h |    2 +-
 5 files changed, 26 insertions(+), 52 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 6fc3421..c563283 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1204,8 +1204,6 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 
 	struct page *page;
 
-	down_read(&vcpu->kvm->slots_lock);
-
 	down_read(&current->mm->mmap_sem);
 	if (is_largepage_backed(vcpu, gfn & ~(KVM_PAGES_PER_HPAGE-1))) {
 		gfn &= ~(KVM_PAGES_PER_HPAGE-1);
@@ -1218,7 +1216,6 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 	/* mmio */
 	if (is_error_page(page)) {
 		kvm_release_page_clean(page);
-		up_read(&vcpu->kvm->slots_lock);
 		return 1;
 	}
 
@@ -1228,7 +1225,6 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 			 PT32E_ROOT_LEVEL);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
-	up_read(&vcpu->kvm->slots_lock);
 
 	return r;
 }
@@ -1376,9 +1372,9 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
 		largepage = 1;
 	}
 	page = gfn_to_page(vcpu->kvm, gfn);
+	up_read(&current->mm->mmap_sem);
 	if (is_error_page(page)) {
 		kvm_release_page_clean(page);
-		up_read(&current->mm->mmap_sem);
 		return 1;
 	}
 	spin_lock(&vcpu->kvm->mmu_lock);
@@ -1386,7 +1382,6 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
 	r = __direct_map(vcpu, gpa, error_code & PFERR_WRITE_MASK,
 			 largepage, gfn, page, TDP_ROOT_LEVEL);
 	spin_unlock(&vcpu->kvm->mmu_lock);
-	up_read(&current->mm->mmap_sem);
 
 	return r;
 }
@@ -1808,9 +1803,7 @@ int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 	gpa_t gpa;
 	int r;
 
-	down_read(&vcpu->kvm->slots_lock);
 	gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, gva);
-	up_read(&vcpu->kvm->slots_lock);
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 	r = kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
@@ -2063,7 +2056,7 @@ static int kvm_pv_mmu_write(struct kvm_vcpu *vcpu,
 	if (r)
 		return r;
 
-	if (!__emulator_write_phys(vcpu, addr, &value, bytes))
+	if (!emulator_write_phys(vcpu, addr, &value, bytes))
 		return -EFAULT;
 
 	return 1;
@@ -2127,7 +2120,6 @@ int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
 	int r;
 	struct kvm_pv_mmu_op_buffer buffer;
 
-	down_read(&vcpu->kvm->slots_lock);
 	down_read(&current->mm->mmap_sem);
 
 	buffer.ptr = buffer.buf;
@@ -2150,7 +2142,6 @@ int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
 out:
 	*ret = buffer.processed;
 	up_read(&current->mm->mmap_sem);
-	up_read(&vcpu->kvm->slots_lock);
 	return r;
 }
 
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index e9ae5db..57d872a 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -388,7 +388,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	if (r)
 		return r;
 
-	down_read(&vcpu->kvm->slots_lock);
 	/*
 	 * Look up the shadow pte for the faulting address.
 	 */
@@ -402,7 +401,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 		pgprintk("%s: guest page fault\n", __func__);
 		inject_page_fault(vcpu, addr, walker.error_code);
 		vcpu->arch.last_pt_write_count = 0; /* reset fork detector */
-		up_read(&vcpu->kvm->slots_lock);
 		return 0;
 	}
 
@@ -422,7 +420,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	if (is_error_page(page)) {
 		pgprintk("gfn %x is mmio\n", walker.gfn);
 		kvm_release_page_clean(page);
-		up_read(&vcpu->kvm->slots_lock);
 		return 1;
 	}
 
@@ -440,7 +437,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	++vcpu->stat.pf_fixed;
 	kvm_mmu_audit(vcpu, "post page fault (fixed)");
 	spin_unlock(&vcpu->kvm->mmu_lock);
-	up_read(&vcpu->kvm->slots_lock);
 
 	return write_pt;
 }
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 87eee7a..6249810 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1505,7 +1505,6 @@ static int init_rmode_tss(struct kvm *kvm)
 	int ret = 0;
 	int r;
 
-	down_read(&kvm->slots_lock);
 	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE);
 	if (r < 0)
 		goto out;
@@ -1528,7 +1527,6 @@ static int init_rmode_tss(struct kvm *kvm)
 
 	ret = 1;
 out:
-	up_read(&kvm->slots_lock);
 	return ret;
 }
 
@@ -1730,6 +1728,7 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	u64 msr;
 	int ret;
 
+	down_read(&vcpu->kvm->slots_lock);
 	if (!init_rmode_tss(vmx->vcpu.kvm)) {
 		ret = -ENOMEM;
 		goto out;
@@ -1833,9 +1832,10 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 
 	vpid_sync_vcpu_all(vmx);
 
-	return 0;
+	ret = 0;
 
 out:
+	up_read(&vcpu->kvm->slots_lock);
 	return ret;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 32d9100..e6a38bf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -201,7 +201,6 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 	int ret;
 	u64 pdpte[ARRAY_SIZE(vcpu->arch.pdptrs)];
 
-	down_read(&vcpu->kvm->slots_lock);
 	ret = kvm_read_guest_page(vcpu->kvm, pdpt_gfn, pdpte,
 				  offset * sizeof(u64), sizeof(pdpte));
 	if (ret < 0) {
@@ -218,7 +217,6 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 
 	memcpy(vcpu->arch.pdptrs, pdpte, sizeof(vcpu->arch.pdptrs));
 out:
-	up_read(&vcpu->kvm->slots_lock);
 
 	return ret;
 }
@@ -233,13 +231,11 @@ static bool pdptrs_changed(struct kvm_vcpu *vcpu)
 	if (is_long_mode(vcpu) || !is_pae(vcpu))
 		return false;
 
-	down_read(&vcpu->kvm->slots_lock);
 	r = kvm_read_guest(vcpu->kvm, vcpu->arch.cr3 & ~31u, pdpte, sizeof(pdpte));
 	if (r < 0)
 		goto out;
 	changed = memcmp(pdpte, vcpu->arch.pdptrs, sizeof(pdpte)) != 0;
 out:
-	up_read(&vcpu->kvm->slots_lock);
 
 	return changed;
 }
@@ -377,7 +373,6 @@ void kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		 */
 	}
 
-	down_read(&vcpu->kvm->slots_lock);
 	/*
 	 * Does the new cr3 value map to physical memory? (Note, we
 	 * catch an invalid cr3 even in real-mode, because it would
@@ -393,7 +388,6 @@ void kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		vcpu->arch.cr3 = cr3;
 		vcpu->arch.mmu.new_cr3(vcpu);
 	}
-	up_read(&vcpu->kvm->slots_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_set_cr3);
 
@@ -503,7 +497,6 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
 
 	version++;
 
-	down_read(&kvm->slots_lock);
 	kvm_write_guest(kvm, wall_clock, &version, sizeof(version));
 
 	wc_ts = current_kernel_time();
@@ -515,7 +508,6 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
 
 	version++;
 	kvm_write_guest(kvm, wall_clock, &version, sizeof(version));
-	up_read(&kvm->slots_lock);
 }
 
 static void kvm_write_guest_time(struct kvm_vcpu *v)
@@ -609,10 +601,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		vcpu->arch.hv_clock.tsc_shift = 22;
 
 		down_read(&current->mm->mmap_sem);
-		down_read(&vcpu->kvm->slots_lock);
 		vcpu->arch.time_page =
 				gfn_to_page(vcpu->kvm, data >> PAGE_SHIFT);
-		up_read(&vcpu->kvm->slots_lock);
 		up_read(&current->mm->mmap_sem);
 
 		if (is_error_page(vcpu->arch.time_page)) {
@@ -715,9 +705,11 @@ static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
 
 	vcpu_load(vcpu);
 
+	down_read(&vcpu->kvm->slots_lock);
 	for (i = 0; i < msrs->nmsrs; ++i)
 		if (do_msr(vcpu, entries[i].index, &entries[i].data))
 			break;
+	up_read(&vcpu->kvm->slots_lock);
 
 	vcpu_put(vcpu);
 
@@ -1768,7 +1760,6 @@ int emulator_read_std(unsigned long addr,
 	void *data = val;
 	int r = X86EMUL_CONTINUE;
 
-	down_read(&vcpu->kvm->slots_lock);
 	while (bytes) {
 		gpa_t gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, addr);
 		unsigned offset = addr & (PAGE_SIZE-1);
@@ -1790,7 +1781,6 @@ int emulator_read_std(unsigned long addr,
 		addr += tocopy;
 	}
 out:
-	up_read(&vcpu->kvm->slots_lock);
 	return r;
 }
 EXPORT_SYMBOL_GPL(emulator_read_std);
@@ -1809,9 +1799,7 @@ static int emulator_read_emulated(unsigned long addr,
 		return X86EMUL_CONTINUE;
 	}
 
-	down_read(&vcpu->kvm->slots_lock);
 	gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, addr);
-	up_read(&vcpu->kvm->slots_lock);
 
 	/* For APIC access vmexit */
 	if ((gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
@@ -1844,7 +1832,7 @@ mmio:
 	return X86EMUL_UNHANDLEABLE;
 }
 
-int __emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
+int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 			  const void *val, int bytes)
 {
 	int ret;
@@ -1856,17 +1844,6 @@ int __emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 	return 1;
 }
 
-static int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
-			const void *val, int bytes)
-{
-	int ret;
-
-	down_read(&vcpu->kvm->slots_lock);
-	ret =__emulator_write_phys(vcpu, gpa, val, bytes);
-	up_read(&vcpu->kvm->slots_lock);
-	return ret;
-}
-
 static int emulator_write_emulated_onepage(unsigned long addr,
 					   const void *val,
 					   unsigned int bytes,
@@ -1875,9 +1852,7 @@ static int emulator_write_emulated_onepage(unsigned long addr,
 	struct kvm_io_device *mmio_dev;
 	gpa_t                 gpa;
 
-	down_read(&vcpu->kvm->slots_lock);
 	gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, addr);
-	up_read(&vcpu->kvm->slots_lock);
 
 	if (gpa == UNMAPPED_GVA) {
 		kvm_inject_page_fault(vcpu, addr, 2);
@@ -1954,7 +1929,6 @@ static int emulator_cmpxchg_emulated(unsigned long addr,
 		char *kaddr;
 		u64 val;
 
-		down_read(&vcpu->kvm->slots_lock);
 		gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, addr);
 
 		if (gpa == UNMAPPED_GVA ||
@@ -1974,9 +1948,8 @@ static int emulator_cmpxchg_emulated(unsigned long addr,
 		set_64bit((u64 *)(kaddr + offset_in_page(gpa)), val);
 		kunmap_atomic(kaddr, KM_USER0);
 		kvm_release_page_dirty(page);
-	emul_write:
-		up_read(&vcpu->kvm->slots_lock);
 	}
+emul_write:
 #endif
 
 	return emulator_write_emulated(addr, new, bytes, vcpu);
@@ -2368,10 +2341,8 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 		kvm_x86_ops->skip_emulated_instruction(vcpu);
 
 	for (i = 0; i < nr_pages; ++i) {
-		down_read(&vcpu->kvm->slots_lock);
 		page = gva_to_page(vcpu, address + i * PAGE_SIZE);
 		vcpu->arch.pio.guest_pages[i] = page;
-		up_read(&vcpu->kvm->slots_lock);
 		if (!page) {
 			kvm_inject_gp(vcpu, 0);
 			free_pio_guest_pages(vcpu);
@@ -2445,7 +2416,9 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 	++vcpu->stat.halt_exits;
 	if (irqchip_in_kernel(vcpu->kvm)) {
 		vcpu->arch.mp_state = VCPU_MP_STATE_HALTED;
+		up_read(&vcpu->kvm->slots_lock);
 		kvm_vcpu_block(vcpu);
+		down_read(&vcpu->kvm->slots_lock);
 		if (vcpu->arch.mp_state != VCPU_MP_STATE_RUNNABLE)
 			return -EINTR;
 		return 1;
@@ -2738,6 +2711,7 @@ static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		vcpu->arch.mp_state = VCPU_MP_STATE_RUNNABLE;
 	}
 
+	down_read(&vcpu->kvm->slots_lock);
 	vapic_enter(vcpu);
 
 preempted:
@@ -2811,6 +2785,8 @@ again:
 
 	kvm_lapic_sync_to_vapic(vcpu);
 
+	up_read(&vcpu->kvm->slots_lock);
+
 	vcpu->guest_mode = 1;
 	kvm_guest_enter();
 
@@ -2837,6 +2813,8 @@ again:
 
 	preempt_enable();
 
+	down_read(&vcpu->kvm->slots_lock);
+
 	/*
 	 * Profile KVM exit RIPs:
 	 */
@@ -2864,14 +2842,18 @@ again:
 	}
 
 out:
+	up_read(&vcpu->kvm->slots_lock);
 	if (r > 0) {
 		kvm_resched(vcpu);
+		down_read(&vcpu->kvm->slots_lock);
 		goto preempted;
 	}
 
 	post_kvm_run_save(vcpu, kvm_run);
 
+	down_read(&vcpu->kvm->slots_lock);
 	vapic_exit(vcpu);
+	up_read(&vcpu->kvm->slots_lock);
 
 	return r;
 }
@@ -2906,9 +2888,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		memcpy(vcpu->mmio_data, kvm_run->mmio.data, 8);
 		vcpu->mmio_read_completed = 1;
 		vcpu->mmio_needed = 0;
+
+		down_read(&vcpu->kvm->slots_lock);
 		r = emulate_instruction(vcpu, kvm_run,
 					vcpu->arch.mmio_fault_cr2, 0,
 					EMULTYPE_NO_DECODE);
+		up_read(&vcpu->kvm->slots_lock);
 		if (r == EMULATE_DO_MMIO) {
 			/*
 			 * Read-modify-write.  Back to userspace.
@@ -3817,7 +3802,9 @@ fail:
 void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
 	kvm_free_lapic(vcpu);
+	down_read(&vcpu->kvm->slots_lock);
 	kvm_mmu_destroy(vcpu);
+	up_read(&vcpu->kvm->slots_lock);
 	free_page((unsigned long)vcpu->arch.pio_data);
 }
 
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 4382ca0..e6d8df6 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -445,7 +445,7 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);
 
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 
-int __emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
+int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 			  const void *val, int bytes);
 int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
 		  gpa_t addr, unsigned long *ret);
-- 
1.5.5

