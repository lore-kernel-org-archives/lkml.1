Return-Path: <linux-kernel-owner+w=401wt.eu-S933351AbXDAOlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351AbXDAOlN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933106AbXDAOjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:39:54 -0400
Received: from il.qumranet.com ([82.166.9.18]:47564 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933222AbXDAOfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:44 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 20/41] KVM: Avoid guest virtual addresses in string pio userspace interface
Date: Sun,  1 Apr 2007 17:35:17 +0300
Message-Id: <11754381393061-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <117543813978-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com> <11754381392921-git-send-email-avi@qumranet.com> <117543813978-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The current string pio interface communicates using guest virtual addresses,
relying on userspace to translate addresses and to check permissions.  This
interface cannot fully support guest smp, as the check needs to take into
account two pages at one in case an unaligned string transfer straddles a
page boundary.

Change the interface not to communicate guest addresses at all; instead use
a buffer page (mmaped by userspace) and do transfers there.  The kernel
manages the virtual to physical translation and can perform the checks
atomically by taking the appropriate locks.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |   21 ++++++-
 drivers/kvm/kvm_main.c |  174 +++++++++++++++++++++++++++++++++++++++++++----
 drivers/kvm/mmu.c      |    9 +++
 drivers/kvm/svm.c      |   40 +++++------
 drivers/kvm/vmx.c      |   40 ++++++------
 include/linux/kvm.h    |   11 +---
 6 files changed, 229 insertions(+), 66 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 1c4a581..7866b34 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -74,6 +74,8 @@
 
 #define IOPL_SHIFT 12
 
+#define KVM_PIO_PAGE_OFFSET 1
+
 /*
  * Address types:
  *
@@ -220,6 +222,18 @@ enum {
 	VCPU_SREG_LDTR,
 };
 
+struct kvm_pio_request {
+	unsigned long count;
+	int cur_count;
+	struct page *guest_pages[2];
+	unsigned guest_page_offset;
+	int in;
+	int size;
+	int string;
+	int down;
+	int rep;
+};
+
 struct kvm_vcpu {
 	struct kvm *kvm;
 	union {
@@ -275,7 +289,8 @@ struct kvm_vcpu {
 	int mmio_size;
 	unsigned char mmio_data[8];
 	gpa_t mmio_phys_addr;
-	int pio_pending;
+	struct kvm_pio_request pio;
+	void *pio_data;
 
 	int sigset_active;
 	sigset_t sigset;
@@ -421,6 +436,7 @@ hpa_t gpa_to_hpa(struct kvm_vcpu *vcpu, gpa_t gpa);
 #define HPA_ERR_MASK ((hpa_t)1 << HPA_MSB)
 static inline int is_error_hpa(hpa_t hpa) { return hpa >> HPA_MSB; }
 hpa_t gva_to_hpa(struct kvm_vcpu *vcpu, gva_t gva);
+struct page *gva_to_page(struct kvm_vcpu *vcpu, gva_t gva);
 
 void kvm_emulator_want_group7_invlpg(void);
 
@@ -453,6 +469,9 @@ void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long value,
 
 struct x86_emulate_ctxt;
 
+int kvm_setup_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
+		  int size, unsigned long count, int string, int down,
+		  gva_t address, int rep, unsigned port);
 void kvm_emulate_cpuid(struct kvm_vcpu *vcpu);
 int emulate_invlpg(struct kvm_vcpu *vcpu, gva_t address);
 int emulate_clts(struct kvm_vcpu *vcpu);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index ba7f43a..0c30e1b 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -346,6 +346,17 @@ static void kvm_free_physmem(struct kvm *kvm)
 		kvm_free_physmem_slot(&kvm->memslots[i], NULL);
 }
 
+static void free_pio_guest_pages(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+	for (i = 0; i < 2; ++i)
+		if (vcpu->pio.guest_pages[i]) {
+			__free_page(vcpu->pio.guest_pages[i]);
+			vcpu->pio.guest_pages[i] = NULL;
+		}
+}
+
 static void kvm_free_vcpu(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu->vmcs)
@@ -357,6 +368,9 @@ static void kvm_free_vcpu(struct kvm_vcpu *vcpu)
 	kvm_arch_ops->vcpu_free(vcpu);
 	free_page((unsigned long)vcpu->run);
 	vcpu->run = NULL;
+	free_page((unsigned long)vcpu->pio_data);
+	vcpu->pio_data = NULL;
+	free_pio_guest_pages(vcpu);
 }
 
 static void kvm_free_vcpus(struct kvm *kvm)
@@ -1550,44 +1564,159 @@ void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_cpuid);
 
-static void complete_pio(struct kvm_vcpu *vcpu)
+static int pio_copy_data(struct kvm_vcpu *vcpu)
+{
+	void *p = vcpu->pio_data;
+	void *q;
+	unsigned bytes;
+	int nr_pages = vcpu->pio.guest_pages[1] ? 2 : 1;
+
+	kvm_arch_ops->vcpu_put(vcpu);
+	q = vmap(vcpu->pio.guest_pages, nr_pages, VM_READ|VM_WRITE,
+		 PAGE_KERNEL);
+	if (!q) {
+		kvm_arch_ops->vcpu_load(vcpu);
+		return -ENOMEM;
+	}
+	q += vcpu->pio.guest_page_offset;
+	bytes = vcpu->pio.size * vcpu->pio.cur_count;
+	if (vcpu->pio.in)
+		memcpy(q, p, bytes);
+	else
+		memcpy(p, q, bytes);
+	q -= vcpu->pio.guest_page_offset;
+	vunmap(q);
+	kvm_arch_ops->vcpu_load(vcpu);
+	return 0;
+}
+
+static int complete_pio(struct kvm_vcpu *vcpu)
 {
-	struct kvm_io *io = &vcpu->run->io;
+	struct kvm_pio_request *io = &vcpu->pio;
 	long delta;
+	int r;
 
 	kvm_arch_ops->cache_regs(vcpu);
 
+	io->count -= io->cur_count;
 	if (!io->string) {
-		if (io->direction == KVM_EXIT_IO_IN)
-			memcpy(&vcpu->regs[VCPU_REGS_RAX], &io->value,
+		if (io->in)
+			memcpy(&vcpu->regs[VCPU_REGS_RAX], vcpu->pio_data,
 			       io->size);
 	} else {
+		if (io->in) {
+			r = pio_copy_data(vcpu);
+			if (r) {
+				kvm_arch_ops->cache_regs(vcpu);
+				return r;
+			}
+		}
+
 		delta = 1;
 		if (io->rep) {
-			delta *= io->count;
+			delta *= io->cur_count;
 			/*
 			 * The size of the register should really depend on
 			 * current address size.
 			 */
 			vcpu->regs[VCPU_REGS_RCX] -= delta;
 		}
-		if (io->string_down)
+		if (io->down)
 			delta = -delta;
 		delta *= io->size;
-		if (io->direction == KVM_EXIT_IO_IN)
+		if (io->in)
 			vcpu->regs[VCPU_REGS_RDI] += delta;
 		else
 			vcpu->regs[VCPU_REGS_RSI] += delta;
 	}
 
-	vcpu->pio_pending = 0;
 	vcpu->run->io_completed = 0;
 
 	kvm_arch_ops->decache_regs(vcpu);
 
-	kvm_arch_ops->skip_emulated_instruction(vcpu);
+	if (!io->count)
+		kvm_arch_ops->skip_emulated_instruction(vcpu);
+	return 0;
 }
 
+int kvm_setup_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
+		  int size, unsigned long count, int string, int down,
+		  gva_t address, int rep, unsigned port)
+{
+	unsigned now, in_page;
+	int i;
+	int nr_pages = 1;
+	struct page *page;
+
+	vcpu->run->exit_reason = KVM_EXIT_IO;
+	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
+	vcpu->run->io.size = size;
+	vcpu->run->io.data_offset = KVM_PIO_PAGE_OFFSET * PAGE_SIZE;
+	vcpu->run->io.count = count;
+	vcpu->run->io.port = port;
+	vcpu->pio.count = count;
+	vcpu->pio.cur_count = count;
+	vcpu->pio.size = size;
+	vcpu->pio.in = in;
+	vcpu->pio.string = string;
+	vcpu->pio.down = down;
+	vcpu->pio.guest_page_offset = offset_in_page(address);
+	vcpu->pio.rep = rep;
+
+	if (!string) {
+		kvm_arch_ops->cache_regs(vcpu);
+		memcpy(vcpu->pio_data, &vcpu->regs[VCPU_REGS_RAX], 4);
+		kvm_arch_ops->decache_regs(vcpu);
+		return 0;
+	}
+
+	now = min(count, PAGE_SIZE / size);
+
+	if (!down)
+		in_page = PAGE_SIZE - offset_in_page(address);
+	else
+		in_page = offset_in_page(address) + size;
+	now = min(count, (unsigned long)in_page / size);
+	if (!now) {
+		/*
+		 * String I/O straddles page boundary.  Pin two guest pages
+		 * so that we satisfy atomicity constraints.  Do just one
+		 * transaction to avoid complexity.
+		 */
+		nr_pages = 2;
+		now = 1;
+	}
+	if (down) {
+		/*
+		 * String I/O in reverse.  Yuck.  Kill the guest, fix later.
+		 */
+		printk(KERN_ERR "kvm: guest string pio down\n");
+		inject_gp(vcpu);
+		return 1;
+	}
+	vcpu->run->io.count = now;
+	vcpu->pio.cur_count = now;
+
+	for (i = 0; i < nr_pages; ++i) {
+		spin_lock(&vcpu->kvm->lock);
+		page = gva_to_page(vcpu, address + i * PAGE_SIZE);
+		if (page)
+			get_page(page);
+		vcpu->pio.guest_pages[i] = page;
+		spin_unlock(&vcpu->kvm->lock);
+		if (!page) {
+			inject_gp(vcpu);
+			free_pio_guest_pages(vcpu);
+			return 1;
+		}
+	}
+
+	if (!vcpu->pio.in)
+		return pio_copy_data(vcpu);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_setup_pio);
+
 static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	int r;
@@ -1602,9 +1731,11 @@ static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	vcpu->cr8 = kvm_run->cr8;
 
 	if (kvm_run->io_completed) {
-		if (vcpu->pio_pending)
-			complete_pio(vcpu);
-		else {
+		if (vcpu->pio.count) {
+			r = complete_pio(vcpu);
+			if (r)
+				goto out;
+		} else {
 			memcpy(vcpu->mmio_data, kvm_run->mmio.data, 8);
 			vcpu->mmio_read_completed = 1;
 		}
@@ -1620,6 +1751,7 @@ static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	r = kvm_arch_ops->run(vcpu, kvm_run);
 
+out:
 	if (vcpu->sigset_active)
 		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
 
@@ -1995,9 +2127,12 @@ static struct page *kvm_vcpu_nopage(struct vm_area_struct *vma,
 
 	*type = VM_FAULT_MINOR;
 	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-	if (pgoff != 0)
+	if (pgoff == 0)
+		page = virt_to_page(vcpu->run);
+	else if (pgoff == KVM_PIO_PAGE_OFFSET)
+		page = virt_to_page(vcpu->pio_data);
+	else
 		return NOPAGE_SIGBUS;
-	page = virt_to_page(vcpu->run);
 	get_page(page);
 	return page;
 }
@@ -2094,6 +2229,12 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 		goto out_unlock;
 	vcpu->run = page_address(page);
 
+	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	r = -ENOMEM;
+	if (!page)
+		goto out_free_run;
+	vcpu->pio_data = page_address(page);
+
 	vcpu->host_fx_image = (char*)ALIGN((hva_t)vcpu->fx_buf,
 					   FX_IMAGE_ALIGN);
 	vcpu->guest_fx_image = vcpu->host_fx_image + FX_IMAGE_SIZE;
@@ -2123,6 +2264,9 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 
 out_free_vcpus:
 	kvm_free_vcpu(vcpu);
+out_free_run:
+	free_page((unsigned long)vcpu->run);
+	vcpu->run = NULL;
 out_unlock:
 	mutex_unlock(&vcpu->mutex);
 out:
@@ -2491,7 +2635,7 @@ static long kvm_dev_ioctl(struct file *filp,
 		r = -EINVAL;
 		if (arg)
 			goto out;
-		r = PAGE_SIZE;
+		r = 2 * PAGE_SIZE;
 		break;
 	default:
 		;
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 266444a..e8e2750 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -735,6 +735,15 @@ hpa_t gva_to_hpa(struct kvm_vcpu *vcpu, gva_t gva)
 	return gpa_to_hpa(vcpu, gpa);
 }
 
+struct page *gva_to_page(struct kvm_vcpu *vcpu, gva_t gva)
+{
+	gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, gva);
+
+	if (gpa == UNMAPPED_GVA)
+		return NULL;
+	return pfn_to_page(gpa_to_hpa(vcpu, gpa) >> PAGE_SHIFT);
+}
+
 static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 {
 }
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 2396ada..64afc5c 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -984,7 +984,7 @@ static int io_get_override(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static unsigned long io_adress(struct kvm_vcpu *vcpu, int ins, u64 *address)
+static unsigned long io_adress(struct kvm_vcpu *vcpu, int ins, gva_t *address)
 {
 	unsigned long addr_mask;
 	unsigned long *reg;
@@ -1028,40 +1028,38 @@ static unsigned long io_adress(struct kvm_vcpu *vcpu, int ins, u64 *address)
 static int io_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	u32 io_info = vcpu->svm->vmcb->control.exit_info_1; //address size bug?
-	int _in = io_info & SVM_IOIO_TYPE_MASK;
+	int size, down, in, string, rep;
+	unsigned port;
+	unsigned long count;
+	gva_t address = 0;
 
 	++kvm_stat.io_exits;
 
 	vcpu->svm->next_rip = vcpu->svm->vmcb->control.exit_info_2;
 
-	kvm_run->exit_reason = KVM_EXIT_IO;
-	kvm_run->io.port = io_info >> 16;
-	kvm_run->io.direction = (_in) ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
-	kvm_run->io.size = ((io_info & SVM_IOIO_SIZE_MASK) >> SVM_IOIO_SIZE_SHIFT);
-	kvm_run->io.string = (io_info & SVM_IOIO_STR_MASK) != 0;
-	kvm_run->io.rep = (io_info & SVM_IOIO_REP_MASK) != 0;
-	kvm_run->io.count = 1;
+	in = (io_info & SVM_IOIO_TYPE_MASK) != 0;
+	port = io_info >> 16;
+	size = (io_info & SVM_IOIO_SIZE_MASK) >> SVM_IOIO_SIZE_SHIFT;
+	string = (io_info & SVM_IOIO_STR_MASK) != 0;
+	rep = (io_info & SVM_IOIO_REP_MASK) != 0;
+	count = 1;
+	down = (vcpu->svm->vmcb->save.rflags & X86_EFLAGS_DF) != 0;
 
-	if (kvm_run->io.string) {
+	if (string) {
 		unsigned addr_mask;
 
-		addr_mask = io_adress(vcpu, _in, &kvm_run->io.address);
+		addr_mask = io_adress(vcpu, in, &address);
 		if (!addr_mask) {
 			printk(KERN_DEBUG "%s: get io address failed\n",
 			       __FUNCTION__);
 			return 1;
 		}
 
-		if (kvm_run->io.rep) {
-			kvm_run->io.count
-				= vcpu->regs[VCPU_REGS_RCX] & addr_mask;
-			kvm_run->io.string_down = (vcpu->svm->vmcb->save.rflags
-						   & X86_EFLAGS_DF) != 0;
-		}
-	} else
-		kvm_run->io.value = vcpu->svm->vmcb->save.rax;
-	vcpu->pio_pending = 1;
-	return 0;
+		if (rep)
+			count = vcpu->regs[VCPU_REGS_RCX] & addr_mask;
+	}
+	return kvm_setup_pio(vcpu, kvm_run, in, size, count, string, down,
+			     address, rep, port);
 }
 
 static int nop_on_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index e69bab6..0d9bf0b 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1394,7 +1394,7 @@ static int handle_triple_fault(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	return 0;
 }
 
-static int get_io_count(struct kvm_vcpu *vcpu, u64 *count)
+static int get_io_count(struct kvm_vcpu *vcpu, unsigned long *count)
 {
 	u64 inst;
 	gva_t rip;
@@ -1439,35 +1439,35 @@ static int get_io_count(struct kvm_vcpu *vcpu, u64 *count)
 done:
 	countr_size *= 8;
 	*count = vcpu->regs[VCPU_REGS_RCX] & (~0ULL >> (64 - countr_size));
+	//printk("cx: %lx\n", vcpu->regs[VCPU_REGS_RCX]);
 	return 1;
 }
 
 static int handle_io(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	u64 exit_qualification;
+	int size, down, in, string, rep;
+	unsigned port;
+	unsigned long count;
+	gva_t address;
 
 	++kvm_stat.io_exits;
 	exit_qualification = vmcs_read64(EXIT_QUALIFICATION);
-	kvm_run->exit_reason = KVM_EXIT_IO;
-	if (exit_qualification & 8)
-		kvm_run->io.direction = KVM_EXIT_IO_IN;
-	else
-		kvm_run->io.direction = KVM_EXIT_IO_OUT;
-	kvm_run->io.size = (exit_qualification & 7) + 1;
-	kvm_run->io.string = (exit_qualification & 16) != 0;
-	kvm_run->io.string_down
-		= (vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_DF) != 0;
-	kvm_run->io.rep = (exit_qualification & 32) != 0;
-	kvm_run->io.port = exit_qualification >> 16;
-	kvm_run->io.count = 1;
-	if (kvm_run->io.string) {
-		if (!get_io_count(vcpu, &kvm_run->io.count))
+	in = (exit_qualification & 8) != 0;
+	size = (exit_qualification & 7) + 1;
+	string = (exit_qualification & 16) != 0;
+	down = (vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_DF) != 0;
+	count = 1;
+	rep = (exit_qualification & 32) != 0;
+	port = exit_qualification >> 16;
+	address = 0;
+	if (string) {
+		if (rep && !get_io_count(vcpu, &count))
 			return 1;
-		kvm_run->io.address = vmcs_readl(GUEST_LINEAR_ADDRESS);
-	} else
-		kvm_run->io.value = vcpu->regs[VCPU_REGS_RAX]; /* rax */
-	vcpu->pio_pending = 1;
-	return 0;
+		address = vmcs_readl(GUEST_LINEAR_ADDRESS);
+	}
+	return kvm_setup_pio(vcpu, kvm_run, in, size, count, string, down,
+			     address, rep, port);
 }
 
 static void
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index dad9081..728b24c 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -86,16 +86,9 @@ struct kvm_run {
 #define KVM_EXIT_IO_OUT 1
 			__u8 direction;
 			__u8 size; /* bytes */
-			__u8 string;
-			__u8 string_down;
-			__u8 rep;
-			__u8 pad;
 			__u16 port;
-			__u64 count;
-			union {
-				__u64 address;
-				__u32 value;
-			};
+			__u32 count;
+			__u64 data_offset; /* relative to kvm_run start */
 		} io;
 		struct {
 		} debug;
-- 
1.5.0.5

