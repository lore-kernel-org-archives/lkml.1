Return-Path: <linux-kernel-owner+w=401wt.eu-S1762092AbXGPTZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762092AbXGPTZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 15:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760169AbXGPTZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 15:25:14 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:34508 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160AbXGPTZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 15:25:07 -0400
Date: Mon, 16 Jul 2007 15:24:46 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Avi Kivity <avi@qumranet.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       KVM devel <kvm-devel@lists.sourceforge.net>
Subject: [PATCH 1/3] KVM - Add missing kvm_run initializations
Message-ID: <20070716192446.GA16243@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are a bunch of missing initializations of run->exit_reason and
associated data.

kvm_hypercall wasn't setting exit_reason at all.

When exit_reason is KVM_EXIT_MMIO, the mmio data isn't initialized.  I
don't know what it should be, so I just stuck a FIXME in there.

There were some missing initializations of hardware_exit_reason with
KVM_EXIT_UNKNOWN, so I added those.  One case had exit_reason = 0,
which I changed to KVM_EXIT_UNKNOWN.

I did a pass over all of the return 0 paths in the exit handler
callbacks, so this should cover everything.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 drivers/kvm/kvm_main.c |    3 +++
 drivers/kvm/svm.c      |    3 +++
 drivers/kvm/vmx.c      |    4 +++-
 3 files changed, 9 insertions(+), 1 deletion(-)

Index: kvm/drivers/kvm/kvm_main.c
===================================================================
--- kvm.orig/drivers/kvm/kvm_main.c
+++ kvm/drivers/kvm/kvm_main.c
@@ -1370,6 +1370,7 @@ int kvm_hypercall(struct kvm_vcpu *vcpu,
 		run->hypercall.ret = ret;
 		run->hypercall.longmode = is_long_mode(vcpu);
 		kvm_arch_ops->decache_regs(vcpu);
+		run->exit_reason = KVM_EXIT_HYPERCALL;
 		return 0;
 	}
 	vcpu->regs[VCPU_REGS_RAX] = ret;
@@ -1928,6 +1929,8 @@ static int kvm_vcpu_ioctl_run(struct kvm
 		if (r == EMULATE_DO_MMIO) {
 			/*
 			 * Read-modify-write.  Back to userspace.
+			 *
+			 * FIXME - kvm_run->mmio not initialized
 			 */
 			kvm_run->exit_reason = KVM_EXIT_MMIO;
 			r = 0;
Index: kvm/drivers/kvm/svm.c
===================================================================
--- kvm.orig/drivers/kvm/svm.c
+++ kvm/drivers/kvm/svm.c
@@ -929,6 +929,7 @@ static int pf_interception(struct kvm_vc
 		return 1;
 	case EMULATE_DO_MMIO:
 		++vcpu->stat.mmio_exits;
+		/* FIXME - kvm_run->mmio not initialized */
 		kvm_run->exit_reason = KVM_EXIT_MMIO;
 		return 0;
 	case EMULATE_FAIL:
@@ -938,6 +939,7 @@ static int pf_interception(struct kvm_vc
 		BUG();
 	}
 
+	kvm_run->hw.hardware_exit_reason = vcpu->svm->vmcb->control.exit_code;
 	kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
 	return 0;
 }
@@ -1135,6 +1137,7 @@ static int invalid_op_interception(struc
 static int task_switch_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	printk(KERN_DEBUG "%s: task swiche is unsupported\n", __FUNCTION__);
+	kvm_run->hw.hardware_exit_reason = vcpu->svm->vmcb->control.exit_code;
 	kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
 	return 0;
 }
Index: kvm/drivers/kvm/vmx.c
===================================================================
--- kvm.orig/drivers/kvm/vmx.c
+++ kvm/drivers/kvm/vmx.c
@@ -1610,6 +1610,7 @@ static int handle_exception(struct kvm_v
 			return 1;
 		case EMULATE_DO_MMIO:
 			++vcpu->stat.mmio_exits;
+			/* FIXME - kvm_run->mmio not initialized */
 			kvm_run->exit_reason = KVM_EXIT_MMIO;
 			return 0;
 		 case EMULATE_FAIL:
@@ -1807,7 +1808,8 @@ static int handle_cr(struct kvm_vcpu *vc
 	default:
 		break;
 	}
-	kvm_run->exit_reason = 0;
+	kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
+	kvm_run->hw.hardware_exit_reason = vmcs_read32(VM_EXIT_REASON);
 	printk(KERN_ERR "kvm: unhandled control register: op %d cr %d\n",
 	       (int)(exit_qualification >> 4) & 3, cr);
 	return 0;
