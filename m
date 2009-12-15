Return-Path: <linux-kernel-owner+w=401wt.eu-S932497AbZLOEH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497AbZLOEH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758218AbZLOEHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:07:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758543AbZLOEHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:07:15 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: [PATCH RFC: kvm tsc virtualization 10/20] Add a stat counter for RDTSC exits
Date: Mon, 14 Dec 2009 18:08:37 -1000
Message-Id: <1260850127-9766-11-git-send-email-zamsden@redhat.com>
In-Reply-To: <1260850127-9766-10-git-send-email-zamsden@redhat.com>
References: <1260850127-9766-1-git-send-email-zamsden@redhat.com>
 <1260850127-9766-2-git-send-email-zamsden@redhat.com>
 <1260850127-9766-3-git-send-email-zamsden@redhat.com>
 <1260850127-9766-4-git-send-email-zamsden@redhat.com>
 <1260850127-9766-5-git-send-email-zamsden@redhat.com>
 <1260850127-9766-6-git-send-email-zamsden@redhat.com>
 <1260850127-9766-7-git-send-email-zamsden@redhat.com>
 <1260850127-9766-8-git-send-email-zamsden@redhat.com>
 <1260850127-9766-9-git-send-email-zamsden@redhat.com>
 <1260850127-9766-10-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    4 ++++
 arch/x86/kvm/svm.c              |    1 +
 arch/x86/kvm/x86.c              |    3 +++
 include/linux/kvm_host.h        |   12 ++++++++++++
 virt/kvm/kvm_main.c             |   18 ++++++++++++++++--
 5 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 26acb4c..8e4d606 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -421,6 +421,9 @@ struct kvm_arch{
 	struct kvm_xen_hvm_config xen_hvm_config;
 };
 
+#define KVM_ARCH_STAT \
+	u32 tsc_resync;
+
 struct kvm_vm_stat {
 	u32 mmu_shadow_zapped;
 	u32 mmu_pte_write;
@@ -450,6 +453,7 @@ struct kvm_vcpu_stat {
 	u32 halt_wakeup;
 	u32 request_irq_exits;
 	u32 irq_exits;
+	u32 rdtsc_exits;
 	u32 host_state_reload;
 	u32 efer_reload;
 	u32 fpu_reload;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 29e88e5..91eb263 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2036,6 +2036,7 @@ static int rdtsc_interception(struct vcpu_svm *svm)
 	kvm_register_write(&svm->vcpu, VCPU_REGS_RAX, tsc & 0xffffffff);
 	tsc >>= 32;
 	kvm_register_write(&svm->vcpu, VCPU_REGS_RDX, tsc & 0xffffffff);
+	++svm->vcpu.stat.rdtsc_exits;
 	skip_emulated_instruction(&svm->vcpu);
 	return 1;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cb323f7..520ea6a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -129,6 +129,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "hypercalls", VCPU_STAT(hypercalls) },
 	{ "request_irq", VCPU_STAT(request_irq_exits) },
 	{ "irq_exits", VCPU_STAT(irq_exits) },
+	{ "rdtsc_exits", VCPU_STAT(rdtsc_exits) },
 	{ "host_state_reload", VCPU_STAT(host_state_reload) },
 	{ "efer_reload", VCPU_STAT(efer_reload) },
 	{ "fpu_reload", VCPU_STAT(fpu_reload) },
@@ -146,6 +147,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "mmu_unsync", VM_STAT(mmu_unsync) },
 	{ "remote_tlb_flush", VM_STAT(remote_tlb_flush) },
 	{ "largepages", VM_STAT(lpages) },
+	{ "tsc_resync", KVM_STAT(tsc_resync) },
 	{ NULL }
 };
 
@@ -977,6 +979,7 @@ static void kvm_do_sync_tsc(int cpu)
 		smp_call_function_single(tsc_base_cpu, kvm_sync_tsc,
 					 (void *)&cpu, 1);
 	}
+	++kvm_stats.tsc_resync;
 
 out_unlock:
 	spin_unlock(&kvm_tsc_lock);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bd5a616..dc5e1d6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -503,6 +503,7 @@ static inline void kvm_migrate_timers(struct kvm_vcpu *vcpu)
 enum kvm_stat_kind {
 	KVM_STAT_VM,
 	KVM_STAT_VCPU,
+	KVM_STAT_GLOBAL
 };
 
 struct kvm_stats_debugfs_item {
@@ -514,6 +515,17 @@ struct kvm_stats_debugfs_item {
 extern struct kvm_stats_debugfs_item debugfs_entries[];
 extern struct dentry *kvm_debugfs_dir;
 
+#ifndef KVM_ARCH_STAT
+#define KVM_ARCH_STAT
+#endif
+
+struct kvm_stat {
+	KVM_ARCH_STAT
+};
+
+extern struct kvm_stat kvm_stats;
+#define KVM_STAT(x) offsetof(struct kvm_stat, x), KVM_STAT_GLOBAL
+
 #ifdef KVM_ARCH_WANT_MMU_NOTIFIER
 static inline int mmu_notifier_retry(struct kvm_vcpu *vcpu, unsigned long mmu_seq)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index bd44fb4..6fc54a5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1971,9 +1971,23 @@ static int vcpu_stat_get(void *_offset, u64 *val)
 
 DEFINE_SIMPLE_ATTRIBUTE(vcpu_stat_fops, vcpu_stat_get, NULL, "%llu\n");
 
+struct kvm_stat kvm_stats;
+EXPORT_SYMBOL_GPL(kvm_stats);
+
+static int kvm_stat_get(void *_offset, u64 *val)
+{
+	unsigned offset = (long)_offset;
+
+	*val = *(u32 *)((void *)&kvm_stats + offset);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(kvm_stat_fops, kvm_stat_get, NULL, "%llu\n");
+
 static const struct file_operations *stat_fops[] = {
-	[KVM_STAT_VCPU] = &vcpu_stat_fops,
-	[KVM_STAT_VM]   = &vm_stat_fops,
+	[KVM_STAT_VCPU]	  = &vcpu_stat_fops,
+	[KVM_STAT_VM]     = &vm_stat_fops,
+	[KVM_STAT_GLOBAL] = &kvm_stat_fops,
 };
 
 static void kvm_init_debug(void)
-- 
1.6.5.2

