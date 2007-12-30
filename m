Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbXL3HNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbXL3HNb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbXL3HKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:10:55 -0500
Received: from il.qumranet.com ([82.166.9.18]:59482 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbXL3HKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:44 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 07/52] KVM: Extend stats support for VM stats
Date: Sun, 30 Dec 2007 09:09:53 +0200
Message-Id: <1198998638-22713-8-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in addition to the current virtual cpu statistics.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |   14 ++++++++++++--
 drivers/kvm/kvm_main.c |   26 +++++++++++++++++++++++---
 drivers/kvm/x86.c      |   39 ++++++++++++++++++++-------------------
 3 files changed, 55 insertions(+), 24 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 5a8a9af..d3171f9 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -231,7 +231,7 @@ struct kvm_pio_request {
 	int rep;
 };
 
-struct kvm_stat {
+struct kvm_vcpu_stat {
 	u32 pf_fixed;
 	u32 pf_guest;
 	u32 tlb_flush;
@@ -342,7 +342,7 @@ void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
 	wait_queue_head_t wq;				\
 	int sigset_active;				\
 	sigset_t sigset;				\
-	struct kvm_stat stat;				\
+	struct kvm_vcpu_stat stat;			\
 	KVM_VCPU_MMIO
 
 struct kvm_mem_alias {
@@ -361,6 +361,9 @@ struct kvm_memory_slot {
 	int user_alloc;
 };
 
+struct kvm_vm_stat {
+};
+
 struct kvm {
 	struct mutex lock; /* protects everything except vcpus */
 	int naliases;
@@ -387,6 +390,7 @@ struct kvm {
 	int round_robin_prev_vcpu;
 	unsigned int tss_addr;
 	struct page *apic_access_page;
+	struct kvm_vm_stat stat;
 };
 
 static inline struct kvm_pic *pic_irqchip(struct kvm *kvm)
@@ -809,9 +813,15 @@ static inline u32 get_rdx_init_val(void)
 #define TSS_REDIRECTION_SIZE (256 / 8)
 #define RMODE_TSS_SIZE (TSS_BASE_SIZE + TSS_REDIRECTION_SIZE + TSS_IOPB_SIZE + 1)
 
+enum kvm_stat_kind {
+	KVM_STAT_VM,
+	KVM_STAT_VCPU,
+};
+
 struct kvm_stats_debugfs_item {
 	const char *name;
 	int offset;
+	enum kvm_stat_kind kind;
 	struct dentry *dentry;
 };
 extern struct kvm_stats_debugfs_item debugfs_entries[];
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 3aa34de..1c4e950 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1281,7 +1281,22 @@ static struct notifier_block kvm_cpu_notifier = {
 	.priority = 20, /* must be > scheduler priority */
 };
 
-static u64 stat_get(void *_offset)
+static u64 vm_stat_get(void *_offset)
+{
+	unsigned offset = (long)_offset;
+	u64 total = 0;
+	struct kvm *kvm;
+
+	spin_lock(&kvm_lock);
+	list_for_each_entry(kvm, &vm_list, vm_list)
+		total += *(u32 *)((void *)kvm + offset);
+	spin_unlock(&kvm_lock);
+	return total;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(vm_stat_fops, vm_stat_get, NULL, "%llu\n");
+
+static u64 vcpu_stat_get(void *_offset)
 {
 	unsigned offset = (long)_offset;
 	u64 total = 0;
@@ -1300,7 +1315,12 @@ static u64 stat_get(void *_offset)
 	return total;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(stat_fops, stat_get, NULL, "%llu\n");
+DEFINE_SIMPLE_ATTRIBUTE(vcpu_stat_fops, vcpu_stat_get, NULL, "%llu\n");
+
+static struct file_operations *stat_fops[] = {
+	[KVM_STAT_VCPU] = &vcpu_stat_fops,
+	[KVM_STAT_VM]   = &vm_stat_fops,
+};
 
 static void kvm_init_debug(void)
 {
@@ -1310,7 +1330,7 @@ static void kvm_init_debug(void)
 	for (p = debugfs_entries; p->name; ++p)
 		p->dentry = debugfs_create_file(p->name, 0444, debugfs_dir,
 						(void *)(long)p->offset,
-						&stat_fops);
+						stat_fops[p->kind]);
 }
 
 static void kvm_exit_debug(void)
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index a46b95b..016abc3 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -42,29 +42,30 @@
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 #define EFER_RESERVED_BITS 0xfffffffffffff2fe
 
-#define STAT_OFFSET(x) offsetof(struct kvm_vcpu, stat.x)
+#define VM_STAT(x) offsetof(struct kvm, stat.x), KVM_STAT_VM
+#define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU
 
 struct kvm_x86_ops *kvm_x86_ops;
 
 struct kvm_stats_debugfs_item debugfs_entries[] = {
-	{ "pf_fixed", STAT_OFFSET(pf_fixed) },
-	{ "pf_guest", STAT_OFFSET(pf_guest) },
-	{ "tlb_flush", STAT_OFFSET(tlb_flush) },
-	{ "invlpg", STAT_OFFSET(invlpg) },
-	{ "exits", STAT_OFFSET(exits) },
-	{ "io_exits", STAT_OFFSET(io_exits) },
-	{ "mmio_exits", STAT_OFFSET(mmio_exits) },
-	{ "signal_exits", STAT_OFFSET(signal_exits) },
-	{ "irq_window", STAT_OFFSET(irq_window_exits) },
-	{ "halt_exits", STAT_OFFSET(halt_exits) },
-	{ "halt_wakeup", STAT_OFFSET(halt_wakeup) },
-	{ "request_irq", STAT_OFFSET(request_irq_exits) },
-	{ "irq_exits", STAT_OFFSET(irq_exits) },
-	{ "host_state_reload", STAT_OFFSET(host_state_reload) },
-	{ "efer_reload", STAT_OFFSET(efer_reload) },
-	{ "fpu_reload", STAT_OFFSET(fpu_reload) },
-	{ "insn_emulation", STAT_OFFSET(insn_emulation) },
-	{ "insn_emulation_fail", STAT_OFFSET(insn_emulation_fail) },
+	{ "pf_fixed", VCPU_STAT(pf_fixed) },
+	{ "pf_guest", VCPU_STAT(pf_guest) },
+	{ "tlb_flush", VCPU_STAT(tlb_flush) },
+	{ "invlpg", VCPU_STAT(invlpg) },
+	{ "exits", VCPU_STAT(exits) },
+	{ "io_exits", VCPU_STAT(io_exits) },
+	{ "mmio_exits", VCPU_STAT(mmio_exits) },
+	{ "signal_exits", VCPU_STAT(signal_exits) },
+	{ "irq_window", VCPU_STAT(irq_window_exits) },
+	{ "halt_exits", VCPU_STAT(halt_exits) },
+	{ "halt_wakeup", VCPU_STAT(halt_wakeup) },
+	{ "request_irq", VCPU_STAT(request_irq_exits) },
+	{ "irq_exits", VCPU_STAT(irq_exits) },
+	{ "host_state_reload", VCPU_STAT(host_state_reload) },
+	{ "efer_reload", VCPU_STAT(efer_reload) },
+	{ "fpu_reload", VCPU_STAT(fpu_reload) },
+	{ "insn_emulation", VCPU_STAT(insn_emulation) },
+	{ "insn_emulation_fail", VCPU_STAT(insn_emulation_fail) },
 	{ NULL }
 };
 
-- 
1.5.3.7

