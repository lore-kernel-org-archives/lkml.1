Return-Path: <linux-kernel-owner+w=401wt.eu-S933801AbXDZJZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801AbXDZJZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933827AbXDZJYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:24:01 -0400
Received: from il.qumranet.com ([82.166.9.18]:53030 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933798AbXDZJW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:22:27 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 15/18] KVM: Per-vcpu statistics
Date: Thu, 26 Apr 2007 12:22:15 +0300
Message-Id: <11775793381722-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11775793382353-git-send-email-avi@qumranet.com>
References: <11775793382353-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make the exit statistics per-vcpu instead of global.  This gives a 3.5%
boost when running one virtual machine per core on my two socket dual core
(4 cores total) machine.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h         |   35 +++++++++++++------------
 drivers/kvm/kvm_main.c    |   61 +++++++++++++++++++++++++++++++-------------
 drivers/kvm/mmu.c         |    2 +-
 drivers/kvm/paging_tmpl.h |    2 +-
 drivers/kvm/svm.c         |   14 +++++-----
 drivers/kvm/vmx.c         |   18 ++++++------
 6 files changed, 79 insertions(+), 53 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index b9c318a..d1a90c5 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -236,6 +236,22 @@ struct kvm_pio_request {
 	int rep;
 };
 
+struct kvm_stat {
+	u32 pf_fixed;
+	u32 pf_guest;
+	u32 tlb_flush;
+	u32 invlpg;
+
+	u32 exits;
+	u32 io_exits;
+	u32 mmio_exits;
+	u32 signal_exits;
+	u32 irq_window_exits;
+	u32 halt_exits;
+	u32 request_irq_exits;
+	u32 irq_exits;
+};
+
 struct kvm_vcpu {
 	struct kvm *kvm;
 	union {
@@ -298,6 +314,8 @@ struct kvm_vcpu {
 	int sigset_active;
 	sigset_t sigset;
 
+	struct kvm_stat stat;
+
 	struct {
 		int active;
 		u8 save_iopl;
@@ -347,22 +365,6 @@ struct kvm {
 	struct file *filp;
 };
 
-struct kvm_stat {
-	u32 pf_fixed;
-	u32 pf_guest;
-	u32 tlb_flush;
-	u32 invlpg;
-
-	u32 exits;
-	u32 io_exits;
-	u32 mmio_exits;
-	u32 signal_exits;
-	u32 irq_window_exits;
-	u32 halt_exits;
-	u32 request_irq_exits;
-	u32 irq_exits;
-};
-
 struct descriptor_table {
 	u16 limit;
 	unsigned long base;
@@ -424,7 +426,6 @@ struct kvm_arch_ops {
 				unsigned char *hypercall_addr);
 };
 
-extern struct kvm_stat kvm_stat;
 extern struct kvm_arch_ops *kvm_arch_ops;
 
 #define kvm_printf(kvm, fmt ...) printk(KERN_DEBUG fmt)
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index f535635..911c817 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -51,27 +51,27 @@ static DEFINE_SPINLOCK(kvm_lock);
 static LIST_HEAD(vm_list);
 
 struct kvm_arch_ops *kvm_arch_ops;
-struct kvm_stat kvm_stat;
-EXPORT_SYMBOL_GPL(kvm_stat);
+
+#define STAT_OFFSET(x) offsetof(struct kvm_vcpu, stat.x)
 
 static struct kvm_stats_debugfs_item {
 	const char *name;
-	u32 *data;
+	int offset;
 	struct dentry *dentry;
 } debugfs_entries[] = {
-	{ "pf_fixed", &kvm_stat.pf_fixed },
-	{ "pf_guest", &kvm_stat.pf_guest },
-	{ "tlb_flush", &kvm_stat.tlb_flush },
-	{ "invlpg", &kvm_stat.invlpg },
-	{ "exits", &kvm_stat.exits },
-	{ "io_exits", &kvm_stat.io_exits },
-	{ "mmio_exits", &kvm_stat.mmio_exits },
-	{ "signal_exits", &kvm_stat.signal_exits },
-	{ "irq_window", &kvm_stat.irq_window_exits },
-	{ "halt_exits", &kvm_stat.halt_exits },
-	{ "request_irq", &kvm_stat.request_irq_exits },
-	{ "irq_exits", &kvm_stat.irq_exits },
-	{ NULL, NULL }
+	{ "pf_fixed", STAT_OFFSET(pf_fixed) },
+	{ "pf_guest", STAT_OFFSET(pf_guest) },
+	{ "tlb_flush", STAT_OFFSET(tlb_flush) },
+	{ "invlpg", STAT_OFFSET(invlpg) },
+	{ "exits", STAT_OFFSET(exits) },
+	{ "io_exits", STAT_OFFSET(io_exits) },
+	{ "mmio_exits", STAT_OFFSET(mmio_exits) },
+	{ "signal_exits", STAT_OFFSET(signal_exits) },
+	{ "irq_window", STAT_OFFSET(irq_window_exits) },
+	{ "halt_exits", STAT_OFFSET(halt_exits) },
+	{ "request_irq", STAT_OFFSET(request_irq_exits) },
+	{ "irq_exits", STAT_OFFSET(irq_exits) },
+	{ NULL }
 };
 
 static struct dentry *debugfs_dir;
@@ -2930,14 +2930,39 @@ static struct notifier_block kvm_cpu_notifier = {
 	.priority = 20, /* must be > scheduler priority */
 };
 
+static u64 stat_get(void *_offset)
+{
+	unsigned offset = (long)_offset;
+	u64 total = 0;
+	struct kvm *kvm;
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	spin_lock(&kvm_lock);
+	list_for_each_entry(kvm, &vm_list, vm_list)
+		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+			vcpu = &kvm->vcpus[i];
+			total += *(u32 *)((void *)vcpu + offset);
+		}
+	spin_unlock(&kvm_lock);
+	return total;
+}
+
+static void stat_set(void *offset, u64 val)
+{
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(stat_fops, stat_get, stat_set, "%llu\n");
+
 static __init void kvm_init_debug(void)
 {
 	struct kvm_stats_debugfs_item *p;
 
 	debugfs_dir = debugfs_create_dir("kvm", NULL);
 	for (p = debugfs_entries; p->name; ++p)
-		p->dentry = debugfs_create_u32(p->name, 0444, debugfs_dir,
-					       p->data);
+		p->dentry = debugfs_create_file(p->name, 0444, debugfs_dir,
+						(void *)(long)p->offset,
+						&stat_fops);
 }
 
 static void kvm_exit_debug(void)
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 8ccf84e..32c64f6 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -936,7 +936,7 @@ static int nonpaging_init_context(struct kvm_vcpu *vcpu)
 
 static void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu)
 {
-	++kvm_stat.tlb_flush;
+	++vcpu->stat.tlb_flush;
 	kvm_arch_ops->tlb_flush(vcpu);
 }
 
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index b94010d..73ffbff 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -448,7 +448,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	if (is_io_pte(*shadow_pte))
 		return 1;
 
-	++kvm_stat.pf_fixed;
+	++vcpu->stat.pf_fixed;
 	kvm_mmu_audit(vcpu, "post page fault (fixed)");
 
 	return write_pt;
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 61ed735..644efc5 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -914,7 +914,7 @@ static int pf_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	case EMULATE_DONE:
 		return 1;
 	case EMULATE_DO_MMIO:
-		++kvm_stat.mmio_exits;
+		++vcpu->stat.mmio_exits;
 		kvm_run->exit_reason = KVM_EXIT_MMIO;
 		return 0;
 	case EMULATE_FAIL:
@@ -1054,7 +1054,7 @@ static int io_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	unsigned long count;
 	gva_t address = 0;
 
-	++kvm_stat.io_exits;
+	++vcpu->stat.io_exits;
 
 	vcpu->svm->next_rip = vcpu->svm->vmcb->control.exit_info_2;
 
@@ -1096,7 +1096,7 @@ static int halt_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		return 1;
 
 	kvm_run->exit_reason = KVM_EXIT_HLT;
-	++kvm_stat.halt_exits;
+	++vcpu->stat.halt_exits;
 	return 0;
 }
 
@@ -1264,7 +1264,7 @@ static int interrupt_window_interception(struct kvm_vcpu *vcpu,
 	 */
 	if (kvm_run->request_interrupt_window &&
 	    !vcpu->irq_summary) {
-		++kvm_stat.irq_window_exits;
+		++vcpu->stat.irq_window_exits;
 		kvm_run->exit_reason = KVM_EXIT_IRQ_WINDOW_OPEN;
 		return 0;
 	}
@@ -1636,14 +1636,14 @@ again:
 	r = handle_exit(vcpu, kvm_run);
 	if (r > 0) {
 		if (signal_pending(current)) {
-			++kvm_stat.signal_exits;
+			++vcpu->stat.signal_exits;
 			post_kvm_run_save(vcpu, kvm_run);
 			kvm_run->exit_reason = KVM_EXIT_INTR;
 			return -EINTR;
 		}
 
 		if (dm_request_for_irq_injection(vcpu, kvm_run)) {
-			++kvm_stat.request_irq_exits;
+			++vcpu->stat.request_irq_exits;
 			post_kvm_run_save(vcpu, kvm_run);
 			kvm_run->exit_reason = KVM_EXIT_INTR;
 			return -EINTR;
@@ -1672,7 +1672,7 @@ static void svm_inject_page_fault(struct kvm_vcpu *vcpu,
 {
 	uint32_t exit_int_info = vcpu->svm->vmcb->control.exit_int_info;
 
-	++kvm_stat.pf_guest;
+	++vcpu->stat.pf_guest;
 
 	if (is_page_fault(exit_int_info)) {
 
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 37537af..10845b7 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1396,7 +1396,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		case EMULATE_DONE:
 			return 1;
 		case EMULATE_DO_MMIO:
-			++kvm_stat.mmio_exits;
+			++vcpu->stat.mmio_exits;
 			kvm_run->exit_reason = KVM_EXIT_MMIO;
 			return 0;
 		 case EMULATE_FAIL:
@@ -1425,7 +1425,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 static int handle_external_interrupt(struct kvm_vcpu *vcpu,
 				     struct kvm_run *kvm_run)
 {
-	++kvm_stat.irq_exits;
+	++vcpu->stat.irq_exits;
 	return 1;
 }
 
@@ -1492,7 +1492,7 @@ static int handle_io(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	unsigned long count;
 	gva_t address;
 
-	++kvm_stat.io_exits;
+	++vcpu->stat.io_exits;
 	exit_qualification = vmcs_read64(EXIT_QUALIFICATION);
 	in = (exit_qualification & 8) != 0;
 	size = (exit_qualification & 7) + 1;
@@ -1682,7 +1682,7 @@ static int handle_interrupt_window(struct kvm_vcpu *vcpu,
 	if (kvm_run->request_interrupt_window &&
 	    !vcpu->irq_summary) {
 		kvm_run->exit_reason = KVM_EXIT_IRQ_WINDOW_OPEN;
-		++kvm_stat.irq_window_exits;
+		++vcpu->stat.irq_window_exits;
 		return 0;
 	}
 	return 1;
@@ -1695,7 +1695,7 @@ static int handle_halt(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		return 1;
 
 	kvm_run->exit_reason = KVM_EXIT_HLT;
-	++kvm_stat.halt_exits;
+	++vcpu->stat.halt_exits;
 	return 0;
 }
 
@@ -1956,7 +1956,7 @@ again:
 
 		reload_tss();
 	}
-	++kvm_stat.exits;
+	++vcpu->stat.exits;
 
 #ifdef CONFIG_X86_64
 	if (is_long_mode(vcpu)) {
@@ -1988,14 +1988,14 @@ again:
 		if (r > 0) {
 			/* Give scheduler a change to reschedule. */
 			if (signal_pending(current)) {
-				++kvm_stat.signal_exits;
+				++vcpu->stat.signal_exits;
 				post_kvm_run_save(vcpu, kvm_run);
 				kvm_run->exit_reason = KVM_EXIT_INTR;
 				return -EINTR;
 			}
 
 			if (dm_request_for_irq_injection(vcpu, kvm_run)) {
-				++kvm_stat.request_irq_exits;
+				++vcpu->stat.request_irq_exits;
 				post_kvm_run_save(vcpu, kvm_run);
 				kvm_run->exit_reason = KVM_EXIT_INTR;
 				return -EINTR;
@@ -2021,7 +2021,7 @@ static void vmx_inject_page_fault(struct kvm_vcpu *vcpu,
 {
 	u32 vect_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 
-	++kvm_stat.pf_guest;
+	++vcpu->stat.pf_guest;
 
 	if (is_page_fault(vect_info)) {
 		printk(KERN_DEBUG "inject_page_fault: "
-- 
1.5.0.6

