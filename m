Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbXFDJfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbXFDJfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 05:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbXFDJfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 05:35:41 -0400
Received: from il.qumranet.com ([82.166.9.18]:59834 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbXFDJfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 05:35:40 -0400
Message-ID: <4663DCE9.3000107@qumranet.com>
Date: Mon, 04 Jun 2007 12:35:37 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [BUG] Oops with KVM-27
References: <20070603213432.GA3075@dreamland.darkstar.lan>
In-Reply-To: <20070603213432.GA3075@dreamland.darkstar.lan>
Content-Type: multipart/mixed;
 boundary="------------030502050401050706070602"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030502050401050706070602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Luca Tettamanti wrote:
> Hello,
> my kernel just exploded :)
>
> The host is running 2.6-git-current, with KVM modules from KVM-27
> package. kernel is 32bit, SMP, with PREEMPT enabled, no HIGHMEM (but I'm
> using CONFIG_VMSPLIT_3G_OPT=y). The CPU is a Core2 (hence I'm using
> kvm-intel).
> Guest was a Fedora7 setup DVD, which died somewhere during the
> installation (anaconda was already active at that point). Bad news is
> that I cannot reproduce the bug :|
>   
Fortunately the trace clearly shows the problem (out of mmu working 
memory on guest context switch).  The attached patch should fix it.  Let 
me know if it works for you.


-- 
error compiling committee.c: too many arguments to function


--------------030502050401050706070602
Content-Type: text/x-patch;
 name="kvm-fix-oops-on-guest-context-switch.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kvm-fix-oops-on-guest-context-switch.patch"

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 0632d0b..0fdd5a6 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -543,6 +543,8 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		       const u8 *old, const u8 *new, int bytes);
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
+int kvm_mmu_load(struct kvm_vcpu *vcpu);
+void kvm_mmu_unload(struct kvm_vcpu *vcpu);
 
 int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run);
 
@@ -554,6 +556,14 @@ static inline int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	return vcpu->mmu.page_fault(vcpu, gva, error_code);
 }
 
+static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
+{
+	if (likely(vcpu->mmu.root_hpa != INVALID_PAGE))
+		return 0;
+
+	return kvm_mmu_load(vcpu);
+}
+
 static inline int is_long_mode(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_X86_64
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 283df03..5915d7a 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -949,9 +949,7 @@ static int nonpaging_init_context(struct kvm_vcpu *vcpu)
 	context->free = nonpaging_free;
 	context->root_level = 0;
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
-	mmu_alloc_roots(vcpu);
-	ASSERT(VALID_PAGE(context->root_hpa));
-	kvm_arch_ops->set_cr3(vcpu, context->root_hpa);
+	context->root_hpa = INVALID_PAGE;
 	return 0;
 }
 
@@ -965,11 +963,6 @@ static void paging_new_cr3(struct kvm_vcpu *vcpu)
 {
 	pgprintk("%s: cr3 %lx\n", __FUNCTION__, vcpu->cr3);
 	mmu_free_roots(vcpu);
-	if (unlikely(vcpu->kvm->n_free_mmu_pages < KVM_MIN_FREE_MMU_PAGES))
-		kvm_mmu_free_some_pages(vcpu);
-	mmu_alloc_roots(vcpu);
-	kvm_mmu_flush_tlb(vcpu);
-	kvm_arch_ops->set_cr3(vcpu, vcpu->mmu.root_hpa);
 }
 
 static void inject_page_fault(struct kvm_vcpu *vcpu,
@@ -1003,10 +996,7 @@ static int paging64_init_context_common(struct kvm_vcpu *vcpu, int level)
 	context->free = paging_free;
 	context->root_level = level;
 	context->shadow_root_level = level;
-	mmu_alloc_roots(vcpu);
-	ASSERT(VALID_PAGE(context->root_hpa));
-	kvm_arch_ops->set_cr3(vcpu, context->root_hpa |
-		    (vcpu->cr3 & (CR3_PCD_MASK | CR3_WPT_MASK)));
+	context->root_hpa = INVALID_PAGE;
 	return 0;
 }
 
@@ -1025,10 +1015,7 @@ static int paging32_init_context(struct kvm_vcpu *vcpu)
 	context->free = paging_free;
 	context->root_level = PT32_ROOT_LEVEL;
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
-	mmu_alloc_roots(vcpu);
-	ASSERT(VALID_PAGE(context->root_hpa));
-	kvm_arch_ops->set_cr3(vcpu, context->root_hpa |
-		    (vcpu->cr3 & (CR3_PCD_MASK | CR3_WPT_MASK)));
+	context->root_hpa = INVALID_PAGE;
 	return 0;
 }
 
@@ -1042,7 +1029,6 @@ static int init_kvm_mmu(struct kvm_vcpu *vcpu)
 	ASSERT(vcpu);
 	ASSERT(!VALID_PAGE(vcpu->mmu.root_hpa));
 
-	mmu_topup_memory_caches(vcpu);
 	if (!is_paging(vcpu))
 		return nonpaging_init_context(vcpu);
 	else if (is_long_mode(vcpu))
@@ -1064,16 +1050,31 @@ static void destroy_kvm_mmu(struct kvm_vcpu *vcpu)
 
 int kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
 {
+	destroy_kvm_mmu(vcpu);
+	return init_kvm_mmu(vcpu);
+}
+
+int kvm_mmu_load(struct kvm_vcpu *vcpu)
+{
 	int r;
 
-	destroy_kvm_mmu(vcpu);
-	r = init_kvm_mmu(vcpu);
-	if (r < 0)
-		goto out;
+	spin_lock(&vcpu->kvm->lock);
 	r = mmu_topup_memory_caches(vcpu);
+	if (r)
+		goto out;
+	mmu_alloc_roots(vcpu);
+	kvm_arch_ops->set_cr3(vcpu, vcpu->mmu.root_hpa);
+	kvm_mmu_flush_tlb(vcpu);
 out:
+	spin_unlock(&vcpu->kvm->lock);
 	return r;
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_load);
+
+void kvm_mmu_unload(struct kvm_vcpu *vcpu)
+{
+	mmu_free_roots(vcpu);
+}
 
 static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
 				  struct kvm_mmu_page *page,
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index b621403..ed33f59 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1482,6 +1482,10 @@ static int svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	int r;
 
 again:
+	r = kvm_mmu_reload(vcpu);
+	if (unlikely(r))
+		return r;
+
 	if (!vcpu->mmio_read_completed)
 		do_interrupt_requests(vcpu, kvm_run);
 
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 09e3609..a499989 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1987,6 +1987,10 @@ again:
 	vmx_save_host_state(vcpu);
 	kvm_load_guest_fpu(vcpu);
 
+	r = kvm_mmu_reload(vcpu);
+	if (unlikely(r))
+		goto out;
+
 	/*
 	 * Loading guest fpu may have cleared host cr0.ts
 	 */

--------------030502050401050706070602--
