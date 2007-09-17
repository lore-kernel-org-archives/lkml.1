Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbXIQInV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbXIQInV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbXIQIcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:54 -0400
Received: from il.qumranet.com ([82.166.9.18]:45258 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987AbXIQIca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:30 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 053/104] KVM: Clean up kvm_setup_pio()
Date: Mon, 17 Sep 2007 10:31:35 +0200
Message-Id: <11900179482737-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

Split kvm_setup_pio() into two functions, one to setup in/out pio
(kvm_emulate_pio()) and one to setup ins/outs pio (kvm_emulate_pio_string()).

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h         |    8 +++--
 drivers/kvm/kvm_main.c    |   63 +++++++++++++++++++++++++++-----------------
 drivers/kvm/svm.c         |    3 +-
 drivers/kvm/vmx.c         |    3 +-
 drivers/kvm/x86_emulate.c |    6 +---
 5 files changed, 48 insertions(+), 35 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 6d25826..2245bae 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -539,9 +539,11 @@ int kvm_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 
 struct x86_emulate_ctxt;
 
-int kvm_setup_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
-		  int size, unsigned long count, int string, int down,
-		  gva_t address, int rep, unsigned port);
+int kvm_emulate_pio (struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
+		     int size, unsigned port);
+int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
+			   int size, unsigned long count, int down,
+			    gva_t address, int rep, unsigned port);
 void kvm_emulate_cpuid(struct kvm_vcpu *vcpu);
 int kvm_emulate_halt(struct kvm_vcpu *vcpu);
 int emulate_invlpg(struct kvm_vcpu *vcpu, gva_t address);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 661d065..d154487 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1735,8 +1735,39 @@ static void pio_string_write(struct kvm_io_device *pio_dev,
 	}
 }
 
-int kvm_setup_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
-		  int size, unsigned long count, int string, int down,
+int kvm_emulate_pio (struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
+		  int size, unsigned port)
+{
+	struct kvm_io_device *pio_dev;
+
+	vcpu->run->exit_reason = KVM_EXIT_IO;
+	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
+	vcpu->run->io.size = vcpu->pio.size = size;
+	vcpu->run->io.data_offset = KVM_PIO_PAGE_OFFSET * PAGE_SIZE;
+	vcpu->run->io.count = vcpu->pio.count = vcpu->pio.cur_count = 1;
+	vcpu->run->io.port = vcpu->pio.port = port;
+	vcpu->pio.in = in;
+	vcpu->pio.string = 0;
+	vcpu->pio.down = 0;
+	vcpu->pio.guest_page_offset = 0;
+	vcpu->pio.rep = 0;
+
+	kvm_arch_ops->cache_regs(vcpu);
+	memcpy(vcpu->pio_data, &vcpu->regs[VCPU_REGS_RAX], 4);
+	kvm_arch_ops->decache_regs(vcpu);
+
+	pio_dev = vcpu_find_pio_dev(vcpu, port);
+	if (pio_dev) {
+		kernel_pio(pio_dev, vcpu, vcpu->pio_data);
+		complete_pio(vcpu);
+		return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_pio);
+
+int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
+		  int size, unsigned long count, int down,
 		  gva_t address, int rep, unsigned port)
 {
 	unsigned now, in_page;
@@ -1747,33 +1778,16 @@ int kvm_setup_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 
 	vcpu->run->exit_reason = KVM_EXIT_IO;
 	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
-	vcpu->run->io.size = size;
+	vcpu->run->io.size = vcpu->pio.size = size;
 	vcpu->run->io.data_offset = KVM_PIO_PAGE_OFFSET * PAGE_SIZE;
-	vcpu->run->io.count = count;
-	vcpu->run->io.port = port;
-	vcpu->pio.count = count;
-	vcpu->pio.cur_count = count;
-	vcpu->pio.size = size;
+	vcpu->run->io.count = vcpu->pio.count = vcpu->pio.cur_count = count;
+	vcpu->run->io.port = vcpu->pio.port = port;
 	vcpu->pio.in = in;
-	vcpu->pio.port = port;
-	vcpu->pio.string = string;
+	vcpu->pio.string = 1;
 	vcpu->pio.down = down;
 	vcpu->pio.guest_page_offset = offset_in_page(address);
 	vcpu->pio.rep = rep;
 
-	pio_dev = vcpu_find_pio_dev(vcpu, port);
-	if (!string) {
-		kvm_arch_ops->cache_regs(vcpu);
-		memcpy(vcpu->pio_data, &vcpu->regs[VCPU_REGS_RAX], 4);
-		kvm_arch_ops->decache_regs(vcpu);
-		if (pio_dev) {
-			kernel_pio(pio_dev, vcpu, vcpu->pio_data);
-			complete_pio(vcpu);
-			return 1;
-		}
-		return 0;
-	}
-
 	if (!count) {
 		kvm_arch_ops->skip_emulated_instruction(vcpu);
 		return 1;
@@ -1818,6 +1832,7 @@ int kvm_setup_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 		}
 	}
 
+	pio_dev = vcpu_find_pio_dev(vcpu, port);
 	if (!vcpu->pio.in) {
 		/* string PIO write */
 		ret = pio_copy_data(vcpu);
@@ -1834,7 +1849,7 @@ int kvm_setup_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(kvm_setup_pio);
+EXPORT_SYMBOL_GPL(kvm_emulate_pio_string);
 
 static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index a83ff01..e3c6d89 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1005,8 +1005,7 @@ static int io_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	rep = (io_info & SVM_IOIO_REP_MASK) != 0;
 	down = (svm->vmcb->save.rflags & X86_EFLAGS_DF) != 0;
 
-	return kvm_setup_pio(&svm->vcpu, kvm_run, in, size, 1, 0,
-			     down, 0, rep, port);
+	return kvm_emulate_pio(&svm->vcpu, kvm_run, in, size, port);
 }
 
 static int nop_on_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 044722b..906d4fa 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1785,8 +1785,7 @@ static int handle_io(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	rep = (exit_qualification & 32) != 0;
 	port = exit_qualification >> 16;
 
-	return kvm_setup_pio(vcpu, kvm_run, in, size, 1, 0, down,
-			     0, rep, port);
+	return kvm_emulate_pio(vcpu, kvm_run, in, size, port);
 }
 
 static void
diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index d553719..b4f439c 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1123,12 +1123,11 @@ special_insn:
 	switch(b) {
 	case 0x6c:		/* insb */
 	case 0x6d:		/* insw/insd */
-		 if (kvm_setup_pio(ctxt->vcpu, NULL,
+		 if (kvm_emulate_pio_string(ctxt->vcpu, NULL,
 				1, 					/* in */
 				(d & ByteOp) ? 1 : op_bytes, 		/* size */
 				rep_prefix ?
 				address_mask(_regs[VCPU_REGS_RCX]) : 1,	/* count */
-				1, 					/* strings */
 				(_eflags & EFLG_DF),			/* down */
 				register_address(ctxt->es_base,
 						 _regs[VCPU_REGS_RDI]),	/* address */
@@ -1139,12 +1138,11 @@ special_insn:
 		return 0;
 	case 0x6e:		/* outsb */
 	case 0x6f:		/* outsw/outsd */
-		if (kvm_setup_pio(ctxt->vcpu, NULL,
+		if (kvm_emulate_pio_string(ctxt->vcpu, NULL,
 				0, 					/* in */
 				(d & ByteOp) ? 1 : op_bytes, 		/* size */
 				rep_prefix ?
 				address_mask(_regs[VCPU_REGS_RCX]) : 1,	/* count */
-				1, 					/* strings */
 				(_eflags & EFLG_DF),			/* down */
 				register_address(override_base ?
 						 *override_base : ctxt->ds_base,
-- 
1.5.3

