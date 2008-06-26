Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbYFZMcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbYFZMcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbYFZM2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:28:45 -0400
Received: from il.qumranet.com ([212.179.150.194]:32339 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbYFZM2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:38 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/50] KVM: VMX: Add list of potentially locally cached vcpus
Date: Thu, 26 Jun 2008 15:27:57 +0300
Message-Id: <1214483312-9265-16-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VMX hardware can cache the contents of a vcpu's vmcs.  This cache needs
to be flushed when migrating a vcpu to another cpu, or (which is the case
that interests us here) when disabling hardware virtualization on a cpu.

The current implementation of decaching iterates over the list of all vcpus,
picks the ones that are potentially cached on the cpu that is being offlined,
and flushes the cache.  The problem is that it uses mutex_trylock() to gain
exclusive access to the vcpu, which fires off a (benign) warning about using
the mutex in an interrupt context.

To avoid this, and to make things generally nicer, add a new per-cpu list
of potentially cached vcus.  This makes the decaching code much simpler.  The
list is vmx-specific since other hardware doesn't have this issue.

[andrea: fix crash on suspend/resume]

Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |   24 ++++++++++++++++++++++--
 arch/x86/kvm/x86.c |   27 ---------------------------
 2 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index fa4ea2e..b99d045 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -55,6 +55,7 @@ struct vmcs {
 
 struct vcpu_vmx {
 	struct kvm_vcpu       vcpu;
+	struct list_head      local_vcpus_link;
 	int                   launched;
 	u8                    fail;
 	u32                   idt_vectoring_info;
@@ -93,6 +94,7 @@ static int init_rmode(struct kvm *kvm);
 
 static DEFINE_PER_CPU(struct vmcs *, vmxarea);
 static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
+static DEFINE_PER_CPU(struct list_head, vcpus_on_cpu);
 
 static struct page *vmx_io_bitmap_a;
 static struct page *vmx_io_bitmap_b;
@@ -331,6 +333,9 @@ static void __vcpu_clear(void *arg)
 	if (per_cpu(current_vmcs, cpu) == vmx->vmcs)
 		per_cpu(current_vmcs, cpu) = NULL;
 	rdtscll(vmx->vcpu.arch.host_tsc);
+	list_del(&vmx->local_vcpus_link);
+	vmx->vcpu.cpu = -1;
+	vmx->launched = 0;
 }
 
 static void vcpu_clear(struct vcpu_vmx *vmx)
@@ -338,7 +343,6 @@ static void vcpu_clear(struct vcpu_vmx *vmx)
 	if (vmx->vcpu.cpu == -1)
 		return;
 	smp_call_function_single(vmx->vcpu.cpu, __vcpu_clear, vmx, 0, 1);
-	vmx->launched = 0;
 }
 
 static inline void vpid_sync_vcpu_all(struct vcpu_vmx *vmx)
@@ -617,6 +621,10 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		vcpu_clear(vmx);
 		kvm_migrate_timers(vcpu);
 		vpid_sync_vcpu_all(vmx);
+		local_irq_disable();
+		list_add(&vmx->local_vcpus_link,
+			 &per_cpu(vcpus_on_cpu, cpu));
+		local_irq_enable();
 	}
 
 	if (per_cpu(current_vmcs, cpu) != vmx->vmcs) {
@@ -1022,6 +1030,7 @@ static void hardware_enable(void *garbage)
 	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
 	u64 old;
 
+	INIT_LIST_HEAD(&per_cpu(vcpus_on_cpu, cpu));
 	rdmsrl(MSR_IA32_FEATURE_CONTROL, old);
 	if ((old & (MSR_IA32_FEATURE_CONTROL_LOCKED |
 		    MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED))
@@ -1037,8 +1046,19 @@ static void hardware_enable(void *garbage)
 		      : "memory", "cc");
 }
 
+static void vmclear_local_vcpus(void)
+{
+	int cpu = raw_smp_processor_id();
+	struct vcpu_vmx *vmx, *n;
+
+	list_for_each_entry_safe(vmx, n, &per_cpu(vcpus_on_cpu, cpu),
+				 local_vcpus_link)
+		__vcpu_clear(vmx);
+}
+
 static void hardware_disable(void *garbage)
 {
+	vmclear_local_vcpus();
 	asm volatile (__ex(ASM_VMX_VMXOFF) : : : "cc");
 	write_cr4(read_cr4() & ~X86_CR4_VMXE);
 }
@@ -2967,7 +2987,7 @@ static void vmx_free_vmcs(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	if (vmx->vmcs) {
-		on_each_cpu(__vcpu_clear, vmx, 0, 1);
+		vcpu_clear(vmx);
 		free_vmcs(vmx->vmcs);
 		vmx->vmcs = NULL;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cc5b0d3..111f432 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -823,33 +823,6 @@ out:
  */
 void decache_vcpus_on_cpu(int cpu)
 {
-	struct kvm *vm;
-	struct kvm_vcpu *vcpu;
-	int i;
-
-	spin_lock(&kvm_lock);
-	list_for_each_entry(vm, &vm_list, vm_list)
-		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-			vcpu = vm->vcpus[i];
-			if (!vcpu)
-				continue;
-			/*
-			 * If the vcpu is locked, then it is running on some
-			 * other cpu and therefore it is not cached on the
-			 * cpu in question.
-			 *
-			 * If it's not locked, check the last cpu it executed
-			 * on.
-			 */
-			if (mutex_trylock(&vcpu->mutex)) {
-				if (vcpu->cpu == cpu) {
-					kvm_x86_ops->vcpu_decache(vcpu);
-					vcpu->cpu = -1;
-				}
-				mutex_unlock(&vcpu->mutex);
-			}
-		}
-	spin_unlock(&kvm_lock);
 }
 
 int kvm_dev_ioctl_check_extension(long ext)
-- 
1.5.6

