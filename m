Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbZB1BpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbZB1BpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbZB1BmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41768 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531AbZB1Bl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:57 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/30] KVM: ia64: dynamic nr online cpus
Date: Sat, 28 Feb 2009 03:41:26 +0200
Message-Id: <1235785309-12835-8-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jes Sorensen <jes@sgi.com>

Account for number of online cpus and use that in loops iterating over
the list of vpus instead of scanning the full array unconditionally.
This patch is a building block to facilitate allowing to bump up
the size of MAX_VCPUS significantly.

Signed-off-by: Jes Sorensen <jes@sgi.com>
Acked-by : Xiantao Zhang  <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/include/asm/kvm_host.h |   10 ++++++----
 arch/ia64/kvm/kvm-ia64.c         |   12 ++++++++----
 arch/ia64/kvm/vcpu.c             |    5 ++++-
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index 46f8b0e..4542651 100644
--- a/arch/ia64/include/asm/kvm_host.h
+++ b/arch/ia64/include/asm/kvm_host.h
@@ -157,10 +157,10 @@ struct kvm_vm_data {
 	struct kvm_vcpu_data vcpu_data[KVM_MAX_VCPUS];
 };
 
-#define VCPU_BASE(n)	KVM_VM_DATA_BASE + \
-				offsetof(struct kvm_vm_data, vcpu_data[n])
-#define VM_BASE		KVM_VM_DATA_BASE + \
-				offsetof(struct kvm_vm_data, kvm_vm_struct)
+#define VCPU_BASE(n)	(KVM_VM_DATA_BASE + \
+				offsetof(struct kvm_vm_data, vcpu_data[n]))
+#define KVM_VM_BASE	(KVM_VM_DATA_BASE + \
+				offsetof(struct kvm_vm_data, kvm_vm_struct))
 #define KVM_MEM_DIRTY_LOG_BASE	KVM_VM_DATA_BASE + \
 				offsetof(struct kvm_vm_data, kvm_mem_dirty_log)
 
@@ -464,6 +464,8 @@ struct kvm_arch {
 	unsigned long	metaphysical_rr4;
 	unsigned long	vmm_init_rr;
 
+	int		online_vcpus;
+
 	struct kvm_ioapic *vioapic;
 	struct kvm_vm_stat stat;
 	struct kvm_sal_data rdv_sal_data;
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index dbf527a..9c77e39 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -314,7 +314,7 @@ static struct kvm_vcpu *lid_to_vcpu(struct kvm *kvm, unsigned long id,
 	union ia64_lid lid;
 	int i;
 
-	for (i = 0; i < KVM_MAX_VCPUS; i++) {
+	for (i = 0; i < kvm->arch.online_vcpus; i++) {
 		if (kvm->vcpus[i]) {
 			lid.val = VCPU_LID(kvm->vcpus[i]);
 			if (lid.id == id && lid.eid == eid)
@@ -388,7 +388,7 @@ static int handle_global_purge(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	call_data.ptc_g_data = p->u.ptc_g_data;
 
-	for (i = 0; i < KVM_MAX_VCPUS; i++) {
+	for (i = 0; i < kvm->arch.online_vcpus; i++) {
 		if (!kvm->vcpus[i] || kvm->vcpus[i]->arch.mp_state ==
 						KVM_MP_STATE_UNINITIALIZED ||
 					vcpu == kvm->vcpus[i])
@@ -788,6 +788,8 @@ struct  kvm *kvm_arch_create_vm(void)
 		return ERR_PTR(-ENOMEM);
 	kvm_init_vm(kvm);
 
+	kvm->arch.online_vcpus = 0;
+
 	return kvm;
 
 }
@@ -1154,7 +1156,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 
 		/*Initialize itc offset for vcpus*/
 		itc_offset = 0UL - ia64_getreg(_IA64_REG_AR_ITC);
-		for (i = 0; i < KVM_MAX_VCPUS; i++) {
+		for (i = 0; i < kvm->arch.online_vcpus; i++) {
 			v = (struct kvm_vcpu *)((char *)vcpu +
 					sizeof(struct kvm_vcpu_data) * i);
 			v->arch.itc_offset = itc_offset;
@@ -1288,6 +1290,8 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 		goto fail;
 	}
 
+	kvm->arch.online_vcpus++;
+
 	return vcpu;
 fail:
 	return ERR_PTR(r);
@@ -1828,7 +1832,7 @@ struct kvm_vcpu *kvm_get_lowest_prio_vcpu(struct kvm *kvm, u8 vector,
 	struct kvm_vcpu *lvcpu = kvm->vcpus[0];
 	int i;
 
-	for (i = 1; i < KVM_MAX_VCPUS; i++) {
+	for (i = 1; i < kvm->arch.online_vcpus; i++) {
 		if (!kvm->vcpus[i])
 			continue;
 		if (lvcpu->arch.xtp > kvm->vcpus[i]->arch.xtp)
diff --git a/arch/ia64/kvm/vcpu.c b/arch/ia64/kvm/vcpu.c
index 4d8be4c..d4d2805 100644
--- a/arch/ia64/kvm/vcpu.c
+++ b/arch/ia64/kvm/vcpu.c
@@ -807,12 +807,15 @@ static inline void vcpu_set_itm(struct kvm_vcpu *vcpu, u64 val);
 static void vcpu_set_itc(struct kvm_vcpu *vcpu, u64 val)
 {
 	struct kvm_vcpu *v;
+	struct kvm *kvm;
 	int i;
 	long itc_offset = val - ia64_getreg(_IA64_REG_AR_ITC);
 	unsigned long vitv = VCPU(vcpu, itv);
 
+	kvm = (struct kvm *)KVM_VM_BASE;
+
 	if (vcpu->vcpu_id == 0) {
-		for (i = 0; i < KVM_MAX_VCPUS; i++) {
+		for (i = 0; i < kvm->arch.online_vcpus; i++) {
 			v = (struct kvm_vcpu *)((char *)vcpu +
 					sizeof(struct kvm_vcpu_data) * i);
 			VMX(v, itc_offset) = itc_offset;
-- 
1.6.0.6

