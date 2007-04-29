Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbXD2PvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbXD2PvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 11:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933332AbXD2Puw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 11:50:52 -0400
Received: from il.qumranet.com ([82.166.9.18]:34364 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756518AbXD2Pu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 11:50:26 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 6/7] KVM: Don't require explicit indication of completion of mmio or pio
Date: Sun, 29 Apr 2007 18:50:21 +0300
Message-Id: <11778618224034-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1177861822889-git-send-email-avi@qumranet.com>
References: <1177861822889-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It is illegal not to return from a pio or mmio request without completing
it, as mmio or pio is an atomic operation.  Therefore, we can simplify
the userspace interface by avoiding the completion indication.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   28 +++++++++++++---------------
 include/linux/kvm.h    |    5 ++---
 2 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index a9ba42f..4c5b8db 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1237,8 +1237,10 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 	kvm_arch_ops->decache_regs(vcpu);
 	kvm_arch_ops->set_rflags(vcpu, emulate_ctxt.eflags);
 
-	if (vcpu->mmio_is_write)
+	if (vcpu->mmio_is_write) {
+		vcpu->mmio_needed = 0;
 		return EMULATE_DO_MMIO;
+	}
 
 	return EMULATE_DONE;
 }
@@ -1692,8 +1694,6 @@ static int complete_pio(struct kvm_vcpu *vcpu)
 			vcpu->regs[VCPU_REGS_RSI] += delta;
 	}
 
-	vcpu->run->io_completed = 0;
-
 	kvm_arch_ops->decache_regs(vcpu);
 
 	io->count -= io->cur_count;
@@ -1800,20 +1800,18 @@ static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	/* re-sync apic's tpr */
 	vcpu->cr8 = kvm_run->cr8;
 
-	if (kvm_run->io_completed) {
-		if (vcpu->pio.cur_count) {
-			r = complete_pio(vcpu);
-			if (r)
-				goto out;
-		} else if (!vcpu->mmio_is_write) {
-			memcpy(vcpu->mmio_data, kvm_run->mmio.data, 8);
-			vcpu->mmio_read_completed = 1;
-			emulate_instruction(vcpu, kvm_run,
-					    vcpu->mmio_fault_cr2, 0);
-		}
+	if (vcpu->pio.cur_count) {
+		r = complete_pio(vcpu);
+		if (r)
+			goto out;
 	}
 
-	vcpu->mmio_needed = 0;
+	if (vcpu->mmio_needed) {
+		memcpy(vcpu->mmio_data, kvm_run->mmio.data, 8);
+		vcpu->mmio_read_completed = 1;
+		emulate_instruction(vcpu, kvm_run, vcpu->mmio_fault_cr2, 0);
+		vcpu->mmio_needed = 0;
+	}
 
 	if (kvm_run->exit_reason == KVM_EXIT_HYPERCALL) {
 		kvm_arch_ops->cache_regs(vcpu);
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 07bf353..738c2f5 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -11,7 +11,7 @@
 #include <asm/types.h>
 #include <linux/ioctl.h>
 
-#define KVM_API_VERSION 10
+#define KVM_API_VERSION 11
 
 /*
  * Architectural interrupt line count, and the size of the bitmap needed
@@ -58,9 +58,8 @@ enum kvm_exit_reason {
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
 	/* in */
-	__u32 io_completed; /* mmio/pio request completed */
 	__u8 request_interrupt_window;
-	__u8 padding1[3];
+	__u8 padding1[7];
 
 	/* out */
 	__u32 exit_reason;
-- 
1.5.0.6

