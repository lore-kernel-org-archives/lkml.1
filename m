Return-Path: <linux-kernel-owner+w=401wt.eu-S933103AbXDAOtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbXDAOtc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933140AbXDAOtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:49:07 -0400
Received: from il.qumranet.com ([82.166.9.18]:47548 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933131AbXDAOfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:42 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 07/41] KVM: Do not communicate to userspace through cpu registers during PIO
Date: Sun,  1 Apr 2007 17:35:04 +0300
Message-Id: <11754381381597-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <11754381383144-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when passing the a PIO emulation request to userspace, we
rely on userspace updating %rax (on 'in' instructions) and %rsi/%rdi/%rcx
(on string instructions).  This (a) requires two extra ioctls for getting
and setting the registers and (b) is unfriendly to non-x86 archs, when
they get kvm ports.

So fix by doing the register fixups in the kernel and passing to userspace
only an abstract description of the PIO to be done.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |   48 +++++++++++++++++++++++++++++++++++++++++++++---
 drivers/kvm/svm.c      |    2 ++
 drivers/kvm/vmx.c      |    2 ++
 include/linux/kvm.h    |    6 +++---
 5 files changed, 53 insertions(+), 6 deletions(-)
 mode change 100755 => 100644 drivers/kvm/kvm_main.c

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 901b8d9..59cbc5b 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -274,6 +274,7 @@ struct kvm_vcpu {
 	int mmio_size;
 	unsigned char mmio_data[8];
 	gpa_t mmio_phys_addr;
+	int pio_pending;
 
 	struct {
 		int active;
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
old mode 100755
new mode 100644
index 42be8a8..ff8bcfe
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1504,6 +1504,44 @@ void save_msrs(struct vmx_msr_entry *e, int n)
 }
 EXPORT_SYMBOL_GPL(save_msrs);
 
+static void complete_pio(struct kvm_vcpu *vcpu)
+{
+	struct kvm_io *io = &vcpu->run->io;
+	long delta;
+
+	kvm_arch_ops->cache_regs(vcpu);
+
+	if (!io->string) {
+		if (io->direction == KVM_EXIT_IO_IN)
+			memcpy(&vcpu->regs[VCPU_REGS_RAX], &io->value,
+			       io->size);
+	} else {
+		delta = 1;
+		if (io->rep) {
+			delta *= io->count;
+			/*
+			 * The size of the register should really depend on
+			 * current address size.
+			 */
+			vcpu->regs[VCPU_REGS_RCX] -= delta;
+		}
+		if (io->string_down)
+			delta = -delta;
+		delta *= io->size;
+		if (io->direction == KVM_EXIT_IO_IN)
+			vcpu->regs[VCPU_REGS_RDI] += delta;
+		else
+			vcpu->regs[VCPU_REGS_RSI] += delta;
+	}
+
+	vcpu->pio_pending = 0;
+	vcpu->run->io_completed = 0;
+
+	kvm_arch_ops->decache_regs(vcpu);
+
+	kvm_arch_ops->skip_emulated_instruction(vcpu);
+}
+
 static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	int r;
@@ -1518,9 +1556,13 @@ static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		kvm_run->emulated = 0;
 	}
 
-	if (kvm_run->mmio_completed) {
-		memcpy(vcpu->mmio_data, kvm_run->mmio.data, 8);
-		vcpu->mmio_read_completed = 1;
+	if (kvm_run->io_completed) {
+		if (vcpu->pio_pending)
+			complete_pio(vcpu);
+		else {
+			memcpy(vcpu->mmio_data, kvm_run->mmio.data, 8);
+			vcpu->mmio_read_completed = 1;
+		}
 	}
 
 	vcpu->mmio_needed = 0;
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 6787f11..c35b8c8 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1037,6 +1037,7 @@ static int io_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	kvm_run->io.size = ((io_info & SVM_IOIO_SIZE_MASK) >> SVM_IOIO_SIZE_SHIFT);
 	kvm_run->io.string = (io_info & SVM_IOIO_STR_MASK) != 0;
 	kvm_run->io.rep = (io_info & SVM_IOIO_REP_MASK) != 0;
+	kvm_run->io.count = 1;
 
 	if (kvm_run->io.string) {
 		unsigned addr_mask;
@@ -1056,6 +1057,7 @@ static int io_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		}
 	} else
 		kvm_run->io.value = vcpu->svm->vmcb->save.rax;
+	vcpu->pio_pending = 1;
 	return 0;
 }
 
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index a721b60..4d5f40f 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1459,12 +1459,14 @@ static int handle_io(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		= (vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_DF) != 0;
 	kvm_run->io.rep = (exit_qualification & 32) != 0;
 	kvm_run->io.port = exit_qualification >> 16;
+	kvm_run->io.count = 1;
 	if (kvm_run->io.string) {
 		if (!get_io_count(vcpu, &kvm_run->io.count))
 			return 1;
 		kvm_run->io.address = vmcs_readl(GUEST_LINEAR_ADDRESS);
 	} else
 		kvm_run->io.value = vcpu->regs[VCPU_REGS_RAX]; /* rax */
+	vcpu->pio_pending = 1;
 	return 0;
 }
 
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index d88e750..19aeb33 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -11,7 +11,7 @@
 #include <asm/types.h>
 #include <linux/ioctl.h>
 
-#define KVM_API_VERSION 5
+#define KVM_API_VERSION 6
 
 /*
  * Architectural interrupt line count, and the size of the bitmap needed
@@ -53,7 +53,7 @@ enum kvm_exit_reason {
 struct kvm_run {
 	/* in */
 	__u32 emulated;  /* skip current instruction */
-	__u32 mmio_completed; /* mmio request completed */
+	__u32 io_completed; /* mmio/pio request completed */
 	__u8 request_interrupt_window;
 	__u8 padding1[7];
 
@@ -80,7 +80,7 @@ struct kvm_run {
 			__u32 error_code;
 		} ex;
 		/* KVM_EXIT_IO */
-		struct {
+		struct kvm_io {
 #define KVM_EXIT_IO_IN  0
 #define KVM_EXIT_IO_OUT 1
 			__u8 direction;
-- 
1.5.0.5

