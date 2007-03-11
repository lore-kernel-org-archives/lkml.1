Return-Path: <linux-kernel-owner+w=401wt.eu-S933594AbXCKN5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594AbXCKN5B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 09:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933592AbXCKNyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 09:54:23 -0400
Received: from il.qumranet.com ([82.166.9.18]:43441 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933578AbXCKNxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 09:53:32 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 10/15] KVM: Fold kvm_run::exit_type into kvm_run::exit_reason
Date: Sun, 11 Mar 2007 15:53:22 +0200
Message-Id: <11736212073791-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <11736212072915-git-send-email-avi@qumranet.com>
References: <11736212072915-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, userspace is told about the nature of the last exit from the
guest using two fields, exit_type and exit_reason, where exit_type has
just two enumerations (and no need for more).  So fold exit_type into
exit_reason, reducing the complexity of determining what really happened.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    3 +--
 drivers/kvm/svm.c      |    7 +++----
 drivers/kvm/vmx.c      |    7 +++----
 include/linux/kvm.h    |   15 ++++++++-------
 4 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 2220e49..0e28f58 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1608,8 +1608,7 @@ static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	vcpu->mmio_needed = 0;
 
-	if (kvm_run->exit_type == KVM_EXIT_TYPE_VM_EXIT
-	    && kvm_run->exit_type == KVM_EXIT_HYPERCALL) {
+	if (kvm_run->exit_reason == KVM_EXIT_HYPERCALL) {
 		kvm_arch_ops->cache_regs(vcpu);
 		vcpu->regs[VCPU_REGS_RAX] = kvm_run->hypercall.ret;
 		kvm_arch_ops->decache_regs(vcpu);
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index d4b2936..b09928f 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1298,8 +1298,6 @@ static int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	u32 exit_code = vcpu->svm->vmcb->control.exit_code;
 
-	kvm_run->exit_type = KVM_EXIT_TYPE_VM_EXIT;
-
 	if (is_external_interrupt(vcpu->svm->vmcb->control.exit_int_info) &&
 	    exit_code != SVM_EXIT_EXCP_BASE + PF_VECTOR)
 		printk(KERN_ERR "%s: unexpected exit_ini_info 0x%x "
@@ -1609,8 +1607,9 @@ again:
 	vcpu->svm->next_rip = 0;
 
 	if (vcpu->svm->vmcb->control.exit_code == SVM_EXIT_ERR) {
-		kvm_run->exit_type = KVM_EXIT_TYPE_FAIL_ENTRY;
-		kvm_run->exit_reason = vcpu->svm->vmcb->control.exit_code;
+		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
+		kvm_run->fail_entry.hardware_entry_failure_reason
+			= vcpu->svm->vmcb->control.exit_code;
 		post_kvm_run_save(vcpu, kvm_run);
 		return 0;
 	}
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index e093892..ba7a98b 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1901,10 +1901,10 @@ again:
 
 	asm ("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
 
-	kvm_run->exit_type = 0;
 	if (fail) {
-		kvm_run->exit_type = KVM_EXIT_TYPE_FAIL_ENTRY;
-		kvm_run->exit_reason = vmcs_read32(VM_INSTRUCTION_ERROR);
+		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
+		kvm_run->fail_entry.hardware_entry_failure_reason
+			= vmcs_read32(VM_INSTRUCTION_ERROR);
 		r = 0;
 	} else {
 		if (fs_gs_ldt_reload_needed) {
@@ -1930,7 +1930,6 @@ again:
 			profile_hit(KVM_PROFILING, (void *)vmcs_readl(GUEST_RIP));
 
 		vcpu->launched = 1;
-		kvm_run->exit_type = KVM_EXIT_TYPE_VM_EXIT;
 		r = kvm_handle_exit(kvm_run, vcpu);
 		if (r > 0) {
 			/* Give scheduler a change to reschedule. */
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 9151ebf..57f47ef 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -11,7 +11,7 @@
 #include <asm/types.h>
 #include <linux/ioctl.h>
 
-#define KVM_API_VERSION 7
+#define KVM_API_VERSION 8
 
 /*
  * Architectural interrupt line count, and the size of the bitmap needed
@@ -34,9 +34,6 @@ struct kvm_memory_region {
 #define KVM_MEM_LOG_DIRTY_PAGES  1UL
 
 
-#define KVM_EXIT_TYPE_FAIL_ENTRY 1
-#define KVM_EXIT_TYPE_VM_EXIT    2
-
 enum kvm_exit_reason {
 	KVM_EXIT_UNKNOWN          = 0,
 	KVM_EXIT_EXCEPTION        = 1,
@@ -47,6 +44,7 @@ enum kvm_exit_reason {
 	KVM_EXIT_MMIO             = 6,
 	KVM_EXIT_IRQ_WINDOW_OPEN  = 7,
 	KVM_EXIT_SHUTDOWN         = 8,
+	KVM_EXIT_FAIL_ENTRY       = 9,
 };
 
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
@@ -57,12 +55,11 @@ struct kvm_run {
 	__u8 padding1[3];
 
 	/* out */
-	__u32 exit_type;
 	__u32 exit_reason;
 	__u32 instruction_length;
 	__u8 ready_for_interrupt_injection;
 	__u8 if_flag;
-	__u16 padding2;
+	__u8 padding2[6];
 
 	/* in (pre_kvm_run), out (post_kvm_run) */
 	__u64 cr8;
@@ -71,8 +68,12 @@ struct kvm_run {
 	union {
 		/* KVM_EXIT_UNKNOWN */
 		struct {
-			__u32 hardware_exit_reason;
+			__u64 hardware_exit_reason;
 		} hw;
+		/* KVM_EXIT_FAIL_ENTRY */
+		struct {
+			__u64 hardware_entry_failure_reason;
+		} fail_entry;
 		/* KVM_EXIT_EXCEPTION */
 		struct {
 			__u32 exception;
-- 
1.5.0.2

