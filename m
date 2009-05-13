Return-Path: <linux-kernel-owner+w=401wt.eu-S1757612AbZEMIEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbZEMIEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 04:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757911AbZEMIEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 04:04:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34471 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758102AbZEMIEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 04:04:11 -0400
From: Avi Kivity <avi@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 2.6.30rc3
Date: Wed, 13 May 2009 11:03:02 +0300
Message-Id: <1242201782-7039-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull repo and branch at

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.30

To receive the following KVM fixes.  Interetingly, there is a replay of
the port 80 debacle where writing to the BIOS debug port kills the machine;
KVM allowed the guest to write to the port to speed up their delays.

Andre Przywara (1):
      KVM: SVM: Fix cross vendor migration issue with unusable bit

Avi Kivity (3):
      KVM: Fix NX support reporting
      KVM: Make EFER reads safe when EFER does not exist
      KVM: SVM: Remove port 80 passthrough

 arch/x86/kvm/svm.c |    8 +++++---
 arch/x86/kvm/x86.c |    6 +++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1821c20..1f8510c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -411,7 +411,6 @@ static __init int svm_hardware_setup(void)
 
 	iopm_va = page_address(iopm_pages);
 	memset(iopm_va, 0xff, PAGE_SIZE * (1 << IOPM_ALLOC_ORDER));
-	clear_bit(0x80, iopm_va); /* allow direct access to PC debug port */
 	iopm_base = page_to_pfn(iopm_pages) << PAGE_SHIFT;
 
 	if (boot_cpu_has(X86_FEATURE_NX))
@@ -796,6 +795,11 @@ static void svm_get_segment(struct kvm_vcpu *vcpu,
 	var->db = (s->attrib >> SVM_SELECTOR_DB_SHIFT) & 1;
 	var->g = (s->attrib >> SVM_SELECTOR_G_SHIFT) & 1;
 
+	/* AMD's VMCB does not have an explicit unusable field, so emulate it
+	 * for cross vendor migration purposes by "not present"
+	 */
+	var->unusable = !var->present || (var->type == 0);
+
 	switch (seg) {
 	case VCPU_SREG_CS:
 		/*
@@ -827,8 +831,6 @@ static void svm_get_segment(struct kvm_vcpu *vcpu,
 			var->type |= 0x1;
 		break;
 	}
-
-	var->unusable = !var->present;
 }
 
 static int svm_get_cpl(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7c1ce5a..49079a4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1121,9 +1121,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
 static int is_efer_nx(void)
 {
-	u64 efer;
+	unsigned long long efer = 0;
 
-	rdmsrl(MSR_EFER, efer);
+	rdmsrl_safe(MSR_EFER, &efer);
 	return efer & EFER_NX;
 }
 
@@ -1259,7 +1259,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		bit(X86_FEATURE_CMOV) | bit(X86_FEATURE_PSE36) |
 		bit(X86_FEATURE_MMX) | bit(X86_FEATURE_FXSR) |
 		bit(X86_FEATURE_SYSCALL) |
-		(bit(X86_FEATURE_NX) && is_efer_nx()) |
+		(is_efer_nx() ? bit(X86_FEATURE_NX) : 0) |
 #ifdef CONFIG_X86_64
 		bit(X86_FEATURE_LM) |
 #endif
