Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbXLZLQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbXLZLQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbXLZLGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:48 -0500
Received: from il.qumranet.com ([82.166.9.18]:50487 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbXLZLGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:07 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 26/55] KVM: Portability: Move pio emulation functions to x86.c
Date: Wed, 26 Dec 2007 13:05:31 +0200
Message-Id: <1198667160-22953-27-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

This patch moves implementation of the following functions from
kvm_main.c to x86.c:
free_pio_guest_pages, vcpu_find_pio_dev, pio_copy_data, complete_pio,
kernel_pio, pio_string_write, kvm_emulate_pio, kvm_emulate_pio_string

The function inject_gp, which was duplicated by yesterday's patch
series, is removed from kvm_main.c now because it is not needed anymore.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Acked-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |  248 ------------------------------------------------
 drivers/kvm/x86.c      |  243 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/kvm/x86.h      |    1 +
 3 files changed, 244 insertions(+), 248 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 2c5529c..27f3a6e 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -271,17 +271,6 @@ static void kvm_free_physmem(struct kvm *kvm)
 		kvm_free_physmem_slot(&kvm->memslots[i], NULL);
 }
 
-static void free_pio_guest_pages(struct kvm_vcpu *vcpu)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(vcpu->pio.guest_pages); ++i)
-		if (vcpu->pio.guest_pages[i]) {
-			kvm_release_page(vcpu->pio.guest_pages[i]);
-			vcpu->pio.guest_pages[i] = NULL;
-		}
-}
-
 static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
 {
 	vcpu_load(vcpu);
@@ -330,11 +319,6 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static void inject_gp(struct kvm_vcpu *vcpu)
-{
-	kvm_x86_ops->inject_gp(vcpu, 0);
-}
-
 void fx_init(struct kvm_vcpu *vcpu)
 {
 	unsigned after_mxcsr_mask;
@@ -827,12 +811,6 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 	}
 }
 
-static struct kvm_io_device *vcpu_find_pio_dev(struct kvm_vcpu *vcpu,
-					       gpa_t addr)
-{
-	return kvm_io_bus_find_dev(&vcpu->kvm->pio_bus, addr);
-}
-
 /*
  * The vCPU has executed a HLT instruction with in-kernel mode enabled.
  */
@@ -1042,232 +1020,6 @@ void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_cpuid);
 
-static int pio_copy_data(struct kvm_vcpu *vcpu)
-{
-	void *p = vcpu->pio_data;
-	void *q;
-	unsigned bytes;
-	int nr_pages = vcpu->pio.guest_pages[1] ? 2 : 1;
-
-	q = vmap(vcpu->pio.guest_pages, nr_pages, VM_READ|VM_WRITE,
-		 PAGE_KERNEL);
-	if (!q) {
-		free_pio_guest_pages(vcpu);
-		return -ENOMEM;
-	}
-	q += vcpu->pio.guest_page_offset;
-	bytes = vcpu->pio.size * vcpu->pio.cur_count;
-	if (vcpu->pio.in)
-		memcpy(q, p, bytes);
-	else
-		memcpy(p, q, bytes);
-	q -= vcpu->pio.guest_page_offset;
-	vunmap(q);
-	free_pio_guest_pages(vcpu);
-	return 0;
-}
-
-static int complete_pio(struct kvm_vcpu *vcpu)
-{
-	struct kvm_pio_request *io = &vcpu->pio;
-	long delta;
-	int r;
-
-	kvm_x86_ops->cache_regs(vcpu);
-
-	if (!io->string) {
-		if (io->in)
-			memcpy(&vcpu->regs[VCPU_REGS_RAX], vcpu->pio_data,
-			       io->size);
-	} else {
-		if (io->in) {
-			r = pio_copy_data(vcpu);
-			if (r) {
-				kvm_x86_ops->cache_regs(vcpu);
-				return r;
-			}
-		}
-
-		delta = 1;
-		if (io->rep) {
-			delta *= io->cur_count;
-			/*
-			 * The size of the register should really depend on
-			 * current address size.
-			 */
-			vcpu->regs[VCPU_REGS_RCX] -= delta;
-		}
-		if (io->down)
-			delta = -delta;
-		delta *= io->size;
-		if (io->in)
-			vcpu->regs[VCPU_REGS_RDI] += delta;
-		else
-			vcpu->regs[VCPU_REGS_RSI] += delta;
-	}
-
-	kvm_x86_ops->decache_regs(vcpu);
-
-	io->count -= io->cur_count;
-	io->cur_count = 0;
-
-	return 0;
-}
-
-static void kernel_pio(struct kvm_io_device *pio_dev,
-		       struct kvm_vcpu *vcpu,
-		       void *pd)
-{
-	/* TODO: String I/O for in kernel device */
-
-	mutex_lock(&vcpu->kvm->lock);
-	if (vcpu->pio.in)
-		kvm_iodevice_read(pio_dev, vcpu->pio.port,
-				  vcpu->pio.size,
-				  pd);
-	else
-		kvm_iodevice_write(pio_dev, vcpu->pio.port,
-				   vcpu->pio.size,
-				   pd);
-	mutex_unlock(&vcpu->kvm->lock);
-}
-
-static void pio_string_write(struct kvm_io_device *pio_dev,
-			     struct kvm_vcpu *vcpu)
-{
-	struct kvm_pio_request *io = &vcpu->pio;
-	void *pd = vcpu->pio_data;
-	int i;
-
-	mutex_lock(&vcpu->kvm->lock);
-	for (i = 0; i < io->cur_count; i++) {
-		kvm_iodevice_write(pio_dev, io->port,
-				   io->size,
-				   pd);
-		pd += io->size;
-	}
-	mutex_unlock(&vcpu->kvm->lock);
-}
-
-int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
-		  int size, unsigned port)
-{
-	struct kvm_io_device *pio_dev;
-
-	vcpu->run->exit_reason = KVM_EXIT_IO;
-	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
-	vcpu->run->io.size = vcpu->pio.size = size;
-	vcpu->run->io.data_offset = KVM_PIO_PAGE_OFFSET * PAGE_SIZE;
-	vcpu->run->io.count = vcpu->pio.count = vcpu->pio.cur_count = 1;
-	vcpu->run->io.port = vcpu->pio.port = port;
-	vcpu->pio.in = in;
-	vcpu->pio.string = 0;
-	vcpu->pio.down = 0;
-	vcpu->pio.guest_page_offset = 0;
-	vcpu->pio.rep = 0;
-
-	kvm_x86_ops->cache_regs(vcpu);
-	memcpy(vcpu->pio_data, &vcpu->regs[VCPU_REGS_RAX], 4);
-	kvm_x86_ops->decache_regs(vcpu);
-
-	kvm_x86_ops->skip_emulated_instruction(vcpu);
-
-	pio_dev = vcpu_find_pio_dev(vcpu, port);
-	if (pio_dev) {
-		kernel_pio(pio_dev, vcpu, vcpu->pio_data);
-		complete_pio(vcpu);
-		return 1;
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(kvm_emulate_pio);
-
-int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
-		  int size, unsigned long count, int down,
-		  gva_t address, int rep, unsigned port)
-{
-	unsigned now, in_page;
-	int i, ret = 0;
-	int nr_pages = 1;
-	struct page *page;
-	struct kvm_io_device *pio_dev;
-
-	vcpu->run->exit_reason = KVM_EXIT_IO;
-	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
-	vcpu->run->io.size = vcpu->pio.size = size;
-	vcpu->run->io.data_offset = KVM_PIO_PAGE_OFFSET * PAGE_SIZE;
-	vcpu->run->io.count = vcpu->pio.count = vcpu->pio.cur_count = count;
-	vcpu->run->io.port = vcpu->pio.port = port;
-	vcpu->pio.in = in;
-	vcpu->pio.string = 1;
-	vcpu->pio.down = down;
-	vcpu->pio.guest_page_offset = offset_in_page(address);
-	vcpu->pio.rep = rep;
-
-	if (!count) {
-		kvm_x86_ops->skip_emulated_instruction(vcpu);
-		return 1;
-	}
-
-	if (!down)
-		in_page = PAGE_SIZE - offset_in_page(address);
-	else
-		in_page = offset_in_page(address) + size;
-	now = min(count, (unsigned long)in_page / size);
-	if (!now) {
-		/*
-		 * String I/O straddles page boundary.  Pin two guest pages
-		 * so that we satisfy atomicity constraints.  Do just one
-		 * transaction to avoid complexity.
-		 */
-		nr_pages = 2;
-		now = 1;
-	}
-	if (down) {
-		/*
-		 * String I/O in reverse.  Yuck.  Kill the guest, fix later.
-		 */
-		pr_unimpl(vcpu, "guest string pio down\n");
-		inject_gp(vcpu);
-		return 1;
-	}
-	vcpu->run->io.count = now;
-	vcpu->pio.cur_count = now;
-
-	if (vcpu->pio.cur_count == vcpu->pio.count)
-		kvm_x86_ops->skip_emulated_instruction(vcpu);
-
-	for (i = 0; i < nr_pages; ++i) {
-		mutex_lock(&vcpu->kvm->lock);
-		page = gva_to_page(vcpu, address + i * PAGE_SIZE);
-		vcpu->pio.guest_pages[i] = page;
-		mutex_unlock(&vcpu->kvm->lock);
-		if (!page) {
-			inject_gp(vcpu);
-			free_pio_guest_pages(vcpu);
-			return 1;
-		}
-	}
-
-	pio_dev = vcpu_find_pio_dev(vcpu, port);
-	if (!vcpu->pio.in) {
-		/* string PIO write */
-		ret = pio_copy_data(vcpu);
-		if (ret >= 0 && pio_dev) {
-			pio_string_write(pio_dev, vcpu);
-			complete_pio(vcpu);
-			if (vcpu->pio.count == 0)
-				ret = 1;
-		}
-	} else if (pio_dev)
-		pr_unimpl(vcpu, "no string pio read support yet, "
-		       "port %x size %d count %ld\n",
-			port, size, count);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(kvm_emulate_pio_string);
-
 /*
  * Check if userspace requested an interrupt window, and that the
  * interrupt window is open.
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index fe3733d..f75e7d7 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -1341,6 +1341,249 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 }
 EXPORT_SYMBOL_GPL(emulate_instruction);
 
+static void free_pio_guest_pages(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(vcpu->pio.guest_pages); ++i)
+		if (vcpu->pio.guest_pages[i]) {
+			kvm_release_page(vcpu->pio.guest_pages[i]);
+			vcpu->pio.guest_pages[i] = NULL;
+		}
+}
+
+static int pio_copy_data(struct kvm_vcpu *vcpu)
+{
+	void *p = vcpu->pio_data;
+	void *q;
+	unsigned bytes;
+	int nr_pages = vcpu->pio.guest_pages[1] ? 2 : 1;
+
+	q = vmap(vcpu->pio.guest_pages, nr_pages, VM_READ|VM_WRITE,
+		 PAGE_KERNEL);
+	if (!q) {
+		free_pio_guest_pages(vcpu);
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
+	free_pio_guest_pages(vcpu);
+	return 0;
+}
+
+int complete_pio(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pio_request *io = &vcpu->pio;
+	long delta;
+	int r;
+
+	kvm_x86_ops->cache_regs(vcpu);
+
+	if (!io->string) {
+		if (io->in)
+			memcpy(&vcpu->regs[VCPU_REGS_RAX], vcpu->pio_data,
+			       io->size);
+	} else {
+		if (io->in) {
+			r = pio_copy_data(vcpu);
+			if (r) {
+				kvm_x86_ops->cache_regs(vcpu);
+				return r;
+			}
+		}
+
+		delta = 1;
+		if (io->rep) {
+			delta *= io->cur_count;
+			/*
+			 * The size of the register should really depend on
+			 * current address size.
+			 */
+			vcpu->regs[VCPU_REGS_RCX] -= delta;
+		}
+		if (io->down)
+			delta = -delta;
+		delta *= io->size;
+		if (io->in)
+			vcpu->regs[VCPU_REGS_RDI] += delta;
+		else
+			vcpu->regs[VCPU_REGS_RSI] += delta;
+	}
+
+	kvm_x86_ops->decache_regs(vcpu);
+
+	io->count -= io->cur_count;
+	io->cur_count = 0;
+
+	return 0;
+}
+
+static void kernel_pio(struct kvm_io_device *pio_dev,
+		       struct kvm_vcpu *vcpu,
+		       void *pd)
+{
+	/* TODO: String I/O for in kernel device */
+
+	mutex_lock(&vcpu->kvm->lock);
+	if (vcpu->pio.in)
+		kvm_iodevice_read(pio_dev, vcpu->pio.port,
+				  vcpu->pio.size,
+				  pd);
+	else
+		kvm_iodevice_write(pio_dev, vcpu->pio.port,
+				   vcpu->pio.size,
+				   pd);
+	mutex_unlock(&vcpu->kvm->lock);
+}
+
+static void pio_string_write(struct kvm_io_device *pio_dev,
+			     struct kvm_vcpu *vcpu)
+{
+	struct kvm_pio_request *io = &vcpu->pio;
+	void *pd = vcpu->pio_data;
+	int i;
+
+	mutex_lock(&vcpu->kvm->lock);
+	for (i = 0; i < io->cur_count; i++) {
+		kvm_iodevice_write(pio_dev, io->port,
+				   io->size,
+				   pd);
+		pd += io->size;
+	}
+	mutex_unlock(&vcpu->kvm->lock);
+}
+
+static struct kvm_io_device *vcpu_find_pio_dev(struct kvm_vcpu *vcpu,
+					       gpa_t addr)
+{
+	return kvm_io_bus_find_dev(&vcpu->kvm->pio_bus, addr);
+}
+
+int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
+		  int size, unsigned port)
+{
+	struct kvm_io_device *pio_dev;
+
+	vcpu->run->exit_reason = KVM_EXIT_IO;
+	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
+	vcpu->run->io.size = vcpu->pio.size = size;
+	vcpu->run->io.data_offset = KVM_PIO_PAGE_OFFSET * PAGE_SIZE;
+	vcpu->run->io.count = vcpu->pio.count = vcpu->pio.cur_count = 1;
+	vcpu->run->io.port = vcpu->pio.port = port;
+	vcpu->pio.in = in;
+	vcpu->pio.string = 0;
+	vcpu->pio.down = 0;
+	vcpu->pio.guest_page_offset = 0;
+	vcpu->pio.rep = 0;
+
+	kvm_x86_ops->cache_regs(vcpu);
+	memcpy(vcpu->pio_data, &vcpu->regs[VCPU_REGS_RAX], 4);
+	kvm_x86_ops->decache_regs(vcpu);
+
+	kvm_x86_ops->skip_emulated_instruction(vcpu);
+
+	pio_dev = vcpu_find_pio_dev(vcpu, port);
+	if (pio_dev) {
+		kernel_pio(pio_dev, vcpu, vcpu->pio_data);
+		complete_pio(vcpu);
+		return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_pio);
+
+int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
+		  int size, unsigned long count, int down,
+		  gva_t address, int rep, unsigned port)
+{
+	unsigned now, in_page;
+	int i, ret = 0;
+	int nr_pages = 1;
+	struct page *page;
+	struct kvm_io_device *pio_dev;
+
+	vcpu->run->exit_reason = KVM_EXIT_IO;
+	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
+	vcpu->run->io.size = vcpu->pio.size = size;
+	vcpu->run->io.data_offset = KVM_PIO_PAGE_OFFSET * PAGE_SIZE;
+	vcpu->run->io.count = vcpu->pio.count = vcpu->pio.cur_count = count;
+	vcpu->run->io.port = vcpu->pio.port = port;
+	vcpu->pio.in = in;
+	vcpu->pio.string = 1;
+	vcpu->pio.down = down;
+	vcpu->pio.guest_page_offset = offset_in_page(address);
+	vcpu->pio.rep = rep;
+
+	if (!count) {
+		kvm_x86_ops->skip_emulated_instruction(vcpu);
+		return 1;
+	}
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
+		pr_unimpl(vcpu, "guest string pio down\n");
+		inject_gp(vcpu);
+		return 1;
+	}
+	vcpu->run->io.count = now;
+	vcpu->pio.cur_count = now;
+
+	if (vcpu->pio.cur_count == vcpu->pio.count)
+		kvm_x86_ops->skip_emulated_instruction(vcpu);
+
+	for (i = 0; i < nr_pages; ++i) {
+		mutex_lock(&vcpu->kvm->lock);
+		page = gva_to_page(vcpu, address + i * PAGE_SIZE);
+		vcpu->pio.guest_pages[i] = page;
+		mutex_unlock(&vcpu->kvm->lock);
+		if (!page) {
+			inject_gp(vcpu);
+			free_pio_guest_pages(vcpu);
+			return 1;
+		}
+	}
+
+	pio_dev = vcpu_find_pio_dev(vcpu, port);
+	if (!vcpu->pio.in) {
+		/* string PIO write */
+		ret = pio_copy_data(vcpu);
+		if (ret >= 0 && pio_dev) {
+			pio_string_write(pio_dev, vcpu);
+			complete_pio(vcpu);
+			if (vcpu->pio.count == 0)
+				ret = 1;
+		}
+	} else if (pio_dev)
+		pr_unimpl(vcpu, "no string pio read support yet, "
+		       "port %x size %d count %ld\n",
+			port, size, count);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_pio_string);
+
 __init void kvm_arch_init(void)
 {
 	kvm_init_msr_list();
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index 5592456..663b822 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -126,4 +126,5 @@ static inline int is_paging(struct kvm_vcpu *vcpu)
 }
 
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
+int complete_pio(struct kvm_vcpu *vcpu);
 #endif
-- 
1.5.3.7

