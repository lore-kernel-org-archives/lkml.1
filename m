Return-Path: <linux-kernel-owner+w=401wt.eu-S1760281AbYFZMos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281AbYFZMos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbYFZM3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:55 -0400
Received: from il.qumranet.com ([212.179.150.194]:32381 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbYFZM2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:39 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 16/50] KVM: Remove decache_vcpus_on_cpu() and related callbacks
Date: Thu, 26 Jun 2008 15:27:58 +0300
Message-Id: <1214483312-9265-17-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Obsoleted by the vmx-specific per-cpu list.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/ia64/kvm/kvm-ia64.c   |    8 --------
 arch/powerpc/kvm/powerpc.c |    4 ----
 arch/s390/kvm/kvm-s390.c   |    4 ----
 arch/x86/kvm/svm.c         |    5 -----
 arch/x86/kvm/vmx.c         |    6 ------
 arch/x86/kvm/x86.c         |    8 --------
 include/asm-x86/kvm_host.h |    1 -
 include/linux/kvm_host.h   |    3 ---
 virt/kvm/kvm_main.c        |    1 -
 9 files changed, 0 insertions(+), 40 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 318b811..adb74f7 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1035,14 +1035,6 @@ static void kvm_free_vmm_area(void)
 	}
 }
 
-/*
- * Make sure that a cpu that is being hot-unplugged does not have any vcpus
- * cached on it. Leave it as blank for IA64.
- */
-void decache_vcpus_on_cpu(int cpu)
-{
-}
-
 static void vti_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 }
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 777e0f3..0513b35 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -240,10 +240,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 }
 
-void decache_vcpus_on_cpu(int cpu)
-{
-}
-
 int kvm_arch_vcpu_ioctl_debug_guest(struct kvm_vcpu *vcpu,
                                     struct kvm_debug_guest *dbg)
 {
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6558b09..4585c8a 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -79,10 +79,6 @@ void kvm_arch_hardware_disable(void *garbage)
 {
 }
 
-void decache_vcpus_on_cpu(int cpu)
-{
-}
-
 int kvm_arch_hardware_setup(void)
 {
 	return 0;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 9390a31..238e8f3 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -709,10 +709,6 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 	rdtscll(vcpu->arch.host_tsc);
 }
 
-static void svm_vcpu_decache(struct kvm_vcpu *vcpu)
-{
-}
-
 static void svm_cache_regs(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1933,7 +1929,6 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.prepare_guest_switch = svm_prepare_guest_switch,
 	.vcpu_load = svm_vcpu_load,
 	.vcpu_put = svm_vcpu_put,
-	.vcpu_decache = svm_vcpu_decache,
 
 	.set_guest_debug = svm_guest_debug,
 	.get_msr = svm_get_msr,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index b99d045..96377bf 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -692,11 +692,6 @@ static void vmx_fpu_deactivate(struct kvm_vcpu *vcpu)
 	update_exception_bitmap(vcpu);
 }
 
-static void vmx_vcpu_decache(struct kvm_vcpu *vcpu)
-{
-	vcpu_clear(to_vmx(vcpu));
-}
-
 static unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
 {
 	return vmcs_readl(GUEST_RFLAGS);
@@ -3114,7 +3109,6 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.prepare_guest_switch = vmx_save_host_state,
 	.vcpu_load = vmx_vcpu_load,
 	.vcpu_put = vmx_vcpu_put,
-	.vcpu_decache = vmx_vcpu_decache,
 
 	.set_guest_debug = set_guest_debug,
 	.guest_debug_pre = kvm_guest_debug_pre,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 111f432..9156d63 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -817,14 +817,6 @@ out:
 	return r;
 }
 
-/*
- * Make sure that a cpu that is being hot-unplugged does not have any vcpus
- * cached on it.
- */
-void decache_vcpus_on_cpu(int cpu)
-{
-}
-
 int kvm_dev_ioctl_check_extension(long ext)
 {
 	int r;
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 0df9d5f..4bcdc7d 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -380,7 +380,6 @@ struct kvm_x86_ops {
 	void (*prepare_guest_switch)(struct kvm_vcpu *vcpu);
 	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
-	void (*vcpu_decache)(struct kvm_vcpu *vcpu);
 
 	int (*set_guest_debug)(struct kvm_vcpu *vcpu,
 			       struct kvm_debug_guest *dbg);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index de9d1df..865dcbc 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -135,9 +135,6 @@ void kvm_vcpu_uninit(struct kvm_vcpu *vcpu);
 void vcpu_load(struct kvm_vcpu *vcpu);
 void vcpu_put(struct kvm_vcpu *vcpu);
 
-void decache_vcpus_on_cpu(int cpu);
-
-
 int kvm_init(void *opaque, unsigned int vcpu_size,
 		  struct module *module);
 void kvm_exit(void);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 67af90c..e8f9fda 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1273,7 +1273,6 @@ static void hardware_disable(void *junk)
 	if (!cpu_isset(cpu, cpus_hardware_enabled))
 		return;
 	cpu_clear(cpu, cpus_hardware_enabled);
-	decache_vcpus_on_cpu(cpu);
 	kvm_arch_hardware_disable(NULL);
 }
 
-- 
1.5.6

