Return-Path: <linux-kernel-owner+w=401wt.eu-S1757586AbYAAPpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbYAAPpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:45:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbYAAPgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:46 -0500
Received: from il.qumranet.com ([82.166.9.18]:33786 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432AbYAAPg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:28 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Dan Kenigsberg <danken@qumranet.com>
Subject: [PATCH 06/54] KVM: Enhance guest cpuid management
Date: Tue,  1 Jan 2008 17:35:32 +0200
Message-Id: <1199201780-14001-7-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Kenigsberg <danken@qumranet.com>

The current cpuid management suffers from several problems, which inhibit
passing through the host feature set to the guest:

 - No way to tell which features the host supports

  While some features can be supported with no changes to kvm, others
  need explicit support.  That means kvm needs to vet the feature set
  before it is passed to the guest.

 - No support for indexed or stateful cpuid entries

  Some cpuid entries depend on ecx as well as on eax, or on internal
  state in the processor (running cpuid multiple times with the same
  input returns different output).  The current cpuid machinery only
  supports keying on eax.

 - No support for save/restore/migrate

  The internal state above needs to be exposed to userspace so it can
  be saved or migrated.

This patch adds extended cpuid support by means of three new ioctls:

 - KVM_GET_SUPPORTED_CPUID: get all cpuid entries the host (and kvm)
   supports

 - KVM_SET_CPUID2: sets the vcpu's cpuid table

 - KVM_GET_CPUID2: gets the vcpu's cpuid table, including hidden state

[avi: fix original KVM_SET_CPUID not removing nx on non-nx hosts as it did
      before]

Signed-off-by: Dan Kenigsberg <danken@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86.c     |  331 +++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/kvm/x86.h     |    2 +-
 include/asm-x86/kvm.h |   21 +++
 include/linux/kvm.h   |    4 +
 4 files changed, 348 insertions(+), 10 deletions(-)

diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 15e1203..7237cb2 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -646,6 +646,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_MMU_SHADOW_CACHE_CONTROL:
 	case KVM_CAP_USER_MEMORY:
 	case KVM_CAP_SET_TSS_ADDR:
+	case KVM_CAP_EXT_CPUID:
 		r = 1;
 		break;
 	default:
@@ -708,13 +709,19 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_put_guest_fpu(vcpu);
 }
 
-static void cpuid_fix_nx_cap(struct kvm_vcpu *vcpu)
+static int is_efer_nx(void)
 {
 	u64 efer;
-	int i;
-	struct kvm_cpuid_entry *e, *entry;
 
 	rdmsrl(MSR_EFER, efer);
+	return efer & EFER_NX;
+}
+
+static void cpuid_fix_nx_cap(struct kvm_vcpu *vcpu)
+{
+	int i;
+	struct kvm_cpuid_entry2 *e, *entry;
+
 	entry = NULL;
 	for (i = 0; i < vcpu->cpuid_nent; ++i) {
 		e = &vcpu->cpuid_entries[i];
@@ -723,16 +730,57 @@ static void cpuid_fix_nx_cap(struct kvm_vcpu *vcpu)
 			break;
 		}
 	}
-	if (entry && (entry->edx & (1 << 20)) && !(efer & EFER_NX)) {
+	if (entry && (entry->edx & (1 << 20)) && !is_efer_nx()) {
 		entry->edx &= ~(1 << 20);
 		printk(KERN_INFO "kvm: guest NX capability removed\n");
 	}
 }
 
+/* when an old userspace process fills a new kernel module */
 static int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 				    struct kvm_cpuid *cpuid,
 				    struct kvm_cpuid_entry __user *entries)
 {
+	int r, i;
+	struct kvm_cpuid_entry *cpuid_entries;
+
+	r = -E2BIG;
+	if (cpuid->nent > KVM_MAX_CPUID_ENTRIES)
+		goto out;
+	r = -ENOMEM;
+	cpuid_entries = vmalloc(sizeof(struct kvm_cpuid_entry) * cpuid->nent);
+	if (!cpuid_entries)
+		goto out;
+	r = -EFAULT;
+	if (copy_from_user(cpuid_entries, entries,
+			   cpuid->nent * sizeof(struct kvm_cpuid_entry)))
+		goto out_free;
+	for (i = 0; i < cpuid->nent; i++) {
+		vcpu->cpuid_entries[i].function = cpuid_entries[i].function;
+		vcpu->cpuid_entries[i].eax = cpuid_entries[i].eax;
+		vcpu->cpuid_entries[i].ebx = cpuid_entries[i].ebx;
+		vcpu->cpuid_entries[i].ecx = cpuid_entries[i].ecx;
+		vcpu->cpuid_entries[i].edx = cpuid_entries[i].edx;
+		vcpu->cpuid_entries[i].index = 0;
+		vcpu->cpuid_entries[i].flags = 0;
+		vcpu->cpuid_entries[i].padding[0] = 0;
+		vcpu->cpuid_entries[i].padding[1] = 0;
+		vcpu->cpuid_entries[i].padding[2] = 0;
+	}
+	vcpu->cpuid_nent = cpuid->nent;
+	cpuid_fix_nx_cap(vcpu);
+	r = 0;
+
+out_free:
+	vfree(cpuid_entries);
+out:
+	return r;
+}
+
+static int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
+				    struct kvm_cpuid2 *cpuid,
+				    struct kvm_cpuid_entry2 __user *entries)
+{
 	int r;
 
 	r = -E2BIG;
@@ -740,16 +788,198 @@ static int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 		goto out;
 	r = -EFAULT;
 	if (copy_from_user(&vcpu->cpuid_entries, entries,
-			   cpuid->nent * sizeof(struct kvm_cpuid_entry)))
+			   cpuid->nent * sizeof(struct kvm_cpuid_entry2)))
 		goto out;
 	vcpu->cpuid_nent = cpuid->nent;
-	cpuid_fix_nx_cap(vcpu);
 	return 0;
 
 out:
 	return r;
 }
 
+static int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
+				    struct kvm_cpuid2 *cpuid,
+				    struct kvm_cpuid_entry2 __user *entries)
+{
+	int r;
+
+	r = -E2BIG;
+	if (cpuid->nent < vcpu->cpuid_nent)
+		goto out;
+	r = -EFAULT;
+	if (copy_to_user(entries, &vcpu->cpuid_entries,
+			   vcpu->cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
+		goto out;
+	return 0;
+
+out:
+	cpuid->nent = vcpu->cpuid_nent;
+	return r;
+}
+
+static inline u32 bit(int bitno)
+{
+	return 1 << (bitno & 31);
+}
+
+static void do_cpuid_1_ent(struct kvm_cpuid_entry2 *entry, u32 function,
+			  u32 index)
+{
+	entry->function = function;
+	entry->index = index;
+	cpuid_count(entry->function, entry->index,
+		&entry->eax, &entry->ebx, &entry->ecx, &entry->edx);
+	entry->flags = 0;
+}
+
+static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
+			 u32 index, int *nent, int maxnent)
+{
+	const u32 kvm_supported_word0_x86_features = bit(X86_FEATURE_FPU) |
+		bit(X86_FEATURE_VME) | bit(X86_FEATURE_DE) |
+		bit(X86_FEATURE_PSE) | bit(X86_FEATURE_TSC) |
+		bit(X86_FEATURE_MSR) | bit(X86_FEATURE_PAE) |
+		bit(X86_FEATURE_CX8) | bit(X86_FEATURE_APIC) |
+		bit(X86_FEATURE_SEP) | bit(X86_FEATURE_PGE) |
+		bit(X86_FEATURE_CMOV) | bit(X86_FEATURE_PSE36) |
+		bit(X86_FEATURE_CLFLSH) | bit(X86_FEATURE_MMX) |
+		bit(X86_FEATURE_FXSR) | bit(X86_FEATURE_XMM) |
+		bit(X86_FEATURE_XMM2) | bit(X86_FEATURE_SELFSNOOP);
+	const u32 kvm_supported_word1_x86_features = bit(X86_FEATURE_FPU) |
+		bit(X86_FEATURE_VME) | bit(X86_FEATURE_DE) |
+		bit(X86_FEATURE_PSE) | bit(X86_FEATURE_TSC) |
+		bit(X86_FEATURE_MSR) | bit(X86_FEATURE_PAE) |
+		bit(X86_FEATURE_CX8) | bit(X86_FEATURE_APIC) |
+		bit(X86_FEATURE_PGE) |
+		bit(X86_FEATURE_CMOV) | bit(X86_FEATURE_PSE36) |
+		bit(X86_FEATURE_MMX) | bit(X86_FEATURE_FXSR) |
+		bit(X86_FEATURE_SYSCALL) |
+		(bit(X86_FEATURE_NX) && is_efer_nx()) |
+#ifdef CONFIG_X86_64
+		bit(X86_FEATURE_LM) |
+#endif
+		bit(X86_FEATURE_MMXEXT) |
+		bit(X86_FEATURE_3DNOWEXT) |
+		bit(X86_FEATURE_3DNOW);
+	const u32 kvm_supported_word3_x86_features =
+		bit(X86_FEATURE_XMM3) | bit(X86_FEATURE_CX16);
+	const u32 kvm_supported_word6_x86_features =
+		bit(X86_FEATURE_LAHF_LM) | bit(X86_FEATURE_CMP_LEGACY);
+
+	/* all func 2 cpuid_count() should be called on the same cpu */
+	get_cpu();
+	do_cpuid_1_ent(entry, function, index);
+	++*nent;
+
+	switch (function) {
+	case 0:
+		entry->eax = min(entry->eax, (u32)0xb);
+		break;
+	case 1:
+		entry->edx &= kvm_supported_word0_x86_features;
+		entry->ecx &= kvm_supported_word3_x86_features;
+		break;
+	/* function 2 entries are STATEFUL. That is, repeated cpuid commands
+	 * may return different values. This forces us to get_cpu() before
+	 * issuing the first command, and also to emulate this annoying behavior
+	 * in kvm_emulate_cpuid() using KVM_CPUID_FLAG_STATE_READ_NEXT */
+	case 2: {
+		int t, times = entry->eax & 0xff;
+
+		entry->flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
+		for (t = 1; t < times && *nent < maxnent; ++t) {
+			do_cpuid_1_ent(&entry[t], function, 0);
+			entry[t].flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
+			++*nent;
+		}
+		break;
+	}
+	/* function 4 and 0xb have additional index. */
+	case 4: {
+		int index, cache_type;
+
+		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+		/* read more entries until cache_type is zero */
+		for (index = 1; *nent < maxnent; ++index) {
+			cache_type = entry[index - 1].eax & 0x1f;
+			if (!cache_type)
+				break;
+			do_cpuid_1_ent(&entry[index], function, index);
+			entry[index].flags |=
+			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+			++*nent;
+		}
+		break;
+	}
+	case 0xb: {
+		int index, level_type;
+
+		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+		/* read more entries until level_type is zero */
+		for (index = 1; *nent < maxnent; ++index) {
+			level_type = entry[index - 1].ecx & 0xff;
+			if (!level_type)
+				break;
+			do_cpuid_1_ent(&entry[index], function, index);
+			entry[index].flags |=
+			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+			++*nent;
+		}
+		break;
+	}
+	case 0x80000000:
+		entry->eax = min(entry->eax, 0x8000001a);
+		break;
+	case 0x80000001:
+		entry->edx &= kvm_supported_word1_x86_features;
+		entry->ecx &= kvm_supported_word6_x86_features;
+		break;
+	}
+	put_cpu();
+}
+
+static int kvm_vm_ioctl_get_supported_cpuid(struct kvm *kvm,
+				    struct kvm_cpuid2 *cpuid,
+				    struct kvm_cpuid_entry2 __user *entries)
+{
+	struct kvm_cpuid_entry2 *cpuid_entries;
+	int limit, nent = 0, r = -E2BIG;
+	u32 func;
+
+	if (cpuid->nent < 1)
+		goto out;
+	r = -ENOMEM;
+	cpuid_entries = vmalloc(sizeof(struct kvm_cpuid_entry2) * cpuid->nent);
+	if (!cpuid_entries)
+		goto out;
+
+	do_cpuid_ent(&cpuid_entries[0], 0, 0, &nent, cpuid->nent);
+	limit = cpuid_entries[0].eax;
+	for (func = 1; func <= limit && nent < cpuid->nent; ++func)
+		do_cpuid_ent(&cpuid_entries[nent], func, 0,
+				&nent, cpuid->nent);
+	r = -E2BIG;
+	if (nent >= cpuid->nent)
+		goto out_free;
+
+	do_cpuid_ent(&cpuid_entries[nent], 0x80000000, 0, &nent, cpuid->nent);
+	limit = cpuid_entries[nent - 1].eax;
+	for (func = 0x80000001; func <= limit && nent < cpuid->nent; ++func)
+		do_cpuid_ent(&cpuid_entries[nent], func, 0,
+			       &nent, cpuid->nent);
+	r = -EFAULT;
+	if (copy_to_user(entries, cpuid_entries,
+			nent * sizeof(struct kvm_cpuid_entry2)))
+		goto out_free;
+	cpuid->nent = nent;
+	r = 0;
+
+out_free:
+	vfree(cpuid_entries);
+out:
+	return r;
+}
+
 static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
 				    struct kvm_lapic_state *s)
 {
@@ -816,6 +1046,36 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 			goto out;
 		break;
 	}
+	case KVM_SET_CPUID2: {
+		struct kvm_cpuid2 __user *cpuid_arg = argp;
+		struct kvm_cpuid2 cpuid;
+
+		r = -EFAULT;
+		if (copy_from_user(&cpuid, cpuid_arg, sizeof cpuid))
+			goto out;
+		r = kvm_vcpu_ioctl_set_cpuid2(vcpu, &cpuid,
+				cpuid_arg->entries);
+		if (r)
+			goto out;
+		break;
+	}
+	case KVM_GET_CPUID2: {
+		struct kvm_cpuid2 __user *cpuid_arg = argp;
+		struct kvm_cpuid2 cpuid;
+
+		r = -EFAULT;
+		if (copy_from_user(&cpuid, cpuid_arg, sizeof cpuid))
+			goto out;
+		r = kvm_vcpu_ioctl_get_cpuid2(vcpu, &cpuid,
+				cpuid_arg->entries);
+		if (r)
+			goto out;
+		r = -EFAULT;
+		if (copy_to_user(cpuid_arg, &cpuid, sizeof cpuid))
+			goto out;
+		r = 0;
+		break;
+	}
 	case KVM_GET_MSRS:
 		r = msr_io(vcpu, argp, kvm_get_msr, 1);
 		break;
@@ -1111,6 +1371,24 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_GET_SUPPORTED_CPUID: {
+		struct kvm_cpuid2 __user *cpuid_arg = argp;
+		struct kvm_cpuid2 cpuid;
+
+		r = -EFAULT;
+		if (copy_from_user(&cpuid, cpuid_arg, sizeof cpuid))
+			goto out;
+		r = kvm_vm_ioctl_get_supported_cpuid(kvm, &cpuid,
+			cpuid_arg->entries);
+		if (r)
+			goto out;
+
+		r = -EFAULT;
+		if (copy_to_user(cpuid_arg, &cpuid, sizeof cpuid))
+			goto out;
+		r = 0;
+		break;
+	}
 	default:
 		;
 	}
@@ -1908,14 +2186,47 @@ void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long val,
 	}
 }
 
+static int move_to_next_stateful_cpuid_entry(struct kvm_vcpu *vcpu, int i)
+{
+	struct kvm_cpuid_entry2 *e = &vcpu->cpuid_entries[i];
+	int j, nent = vcpu->cpuid_nent;
+
+	e->flags &= ~KVM_CPUID_FLAG_STATE_READ_NEXT;
+	/* when no next entry is found, the current entry[i] is reselected */
+	for (j = i + 1; j == i; j = (j + 1) % nent) {
+		struct kvm_cpuid_entry2 *ej = &vcpu->cpuid_entries[j];
+		if (ej->function == e->function) {
+			ej->flags |= KVM_CPUID_FLAG_STATE_READ_NEXT;
+			return j;
+		}
+	}
+	return 0; /* silence gcc, even though control never reaches here */
+}
+
+/* find an entry with matching function, matching index (if needed), and that
+ * should be read next (if it's stateful) */
+static int is_matching_cpuid_entry(struct kvm_cpuid_entry2 *e,
+	u32 function, u32 index)
+{
+	if (e->function != function)
+		return 0;
+	if ((e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX) && e->index != index)
+		return 0;
+	if ((e->flags & KVM_CPUID_FLAG_STATEFUL_FUNC) &&
+		!(e->flags & KVM_CPUID_FLAG_STATE_READ_NEXT))
+		return 0;
+	return 1;
+}
+
 void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 {
 	int i;
-	u32 function;
-	struct kvm_cpuid_entry *e, *best;
+	u32 function, index;
+	struct kvm_cpuid_entry2 *e, *best;
 
 	kvm_x86_ops->cache_regs(vcpu);
 	function = vcpu->regs[VCPU_REGS_RAX];
+	index = vcpu->regs[VCPU_REGS_RCX];
 	vcpu->regs[VCPU_REGS_RAX] = 0;
 	vcpu->regs[VCPU_REGS_RBX] = 0;
 	vcpu->regs[VCPU_REGS_RCX] = 0;
@@ -1923,7 +2234,9 @@ void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 	best = NULL;
 	for (i = 0; i < vcpu->cpuid_nent; ++i) {
 		e = &vcpu->cpuid_entries[i];
-		if (e->function == function) {
+		if (is_matching_cpuid_entry(e, function, index)) {
+			if (e->flags & KVM_CPUID_FLAG_STATEFUL_FUNC)
+				move_to_next_stateful_cpuid_entry(vcpu, i);
 			best = e;
 			break;
 		}
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index b1528c9..78ab1e1 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -149,7 +149,7 @@ struct kvm_vcpu {
 	int halt_request; /* real mode on Intel only */
 
 	int cpuid_nent;
-	struct kvm_cpuid_entry cpuid_entries[KVM_MAX_CPUID_ENTRIES];
+	struct kvm_cpuid_entry2 cpuid_entries[KVM_MAX_CPUID_ENTRIES];
 
 	/* emulate context */
 
diff --git a/include/asm-x86/kvm.h b/include/asm-x86/kvm.h
index 4837d75..17afa81 100644
--- a/include/asm-x86/kvm.h
+++ b/include/asm-x86/kvm.h
@@ -151,5 +151,26 @@ struct kvm_cpuid {
 	struct kvm_cpuid_entry entries[0];
 };
 
+struct kvm_cpuid_entry2 {
+	__u32 function;
+	__u32 index;
+	__u32 flags;
+	__u32 eax;
+	__u32 ebx;
+	__u32 ecx;
+	__u32 edx;
+	__u32 padding[3];
+};
+
+#define KVM_CPUID_FLAG_SIGNIFCANT_INDEX 1
+#define KVM_CPUID_FLAG_STATEFUL_FUNC    2
+#define KVM_CPUID_FLAG_STATE_READ_NEXT  4
+
+/* for KVM_SET_CPUID2 */
+struct kvm_cpuid2 {
+	__u32 nent;
+	__u32 padding;
+	struct kvm_cpuid_entry2 entries[0];
+};
 
 #endif
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index fd4f900..b751552 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -224,6 +224,7 @@ struct kvm_signal_mask {
 #define KVM_CAP_MMU_SHADOW_CACHE_CONTROL 2
 #define KVM_CAP_USER_MEMORY 3
 #define KVM_CAP_SET_TSS_ADDR 4
+#define KVM_CAP_EXT_CPUID 5
 
 /*
  * ioctls for VM fds
@@ -241,6 +242,7 @@ struct kvm_signal_mask {
 #define KVM_CREATE_VCPU           _IO(KVMIO,  0x41)
 #define KVM_GET_DIRTY_LOG         _IOW(KVMIO, 0x42, struct kvm_dirty_log)
 #define KVM_SET_MEMORY_ALIAS      _IOW(KVMIO, 0x43, struct kvm_memory_alias)
+#define KVM_GET_SUPPORTED_CPUID   _IOWR(KVMIO, 0x48, struct kvm_cpuid2)
 /* Device model IOC */
 #define KVM_CREATE_IRQCHIP	  _IO(KVMIO,  0x60)
 #define KVM_IRQ_LINE		  _IOW(KVMIO, 0x61, struct kvm_irq_level)
@@ -266,5 +268,7 @@ struct kvm_signal_mask {
 #define KVM_SET_FPU               _IOW(KVMIO,  0x8d, struct kvm_fpu)
 #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
 #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
+#define KVM_SET_CPUID2            _IOW(KVMIO,  0x90, struct kvm_cpuid2)
+#define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)
 
 #endif
-- 
1.5.3.7

