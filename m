Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbXIQImh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbXIQImh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbXIQIcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:52 -0400
Received: from il.qumranet.com ([82.166.9.18]:45319 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbXIQIca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:30 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 048/104] KVM: Add and use pr_unimpl for standard formatting of unimplemented features
Date: Mon, 17 Sep 2007 10:31:30 +0200
Message-Id: <11900179481707-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

All guest-invokable printks should be ratelimited to prevent malicious
guests from flooding logs.  This is a start.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    8 ++++++++
 drivers/kvm/kvm_main.c |   18 ++++++++----------
 drivers/kvm/svm.c      |    4 ++--
 drivers/kvm/vmx.c      |    2 +-
 4 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index cfda3ab..6d25826 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -474,6 +474,14 @@ struct kvm_arch_ops {
 
 extern struct kvm_arch_ops *kvm_arch_ops;
 
+/* The guest did something we don't support. */
+#define pr_unimpl(vcpu, fmt, ...)					\
+ do {									\
+	if (printk_ratelimit())						\
+		printk(KERN_ERR "kvm: %i: cpu%i " fmt,			\
+		       current->tgid, (vcpu)->vcpu_id , ## __VA_ARGS__); \
+ } while(0)
+
 #define kvm_printf(kvm, fmt ...) printk(KERN_DEBUG fmt)
 #define vcpu_printf(vcpu, fmt...) kvm_printf(vcpu->kvm, fmt)
 
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 9de3b1a..1b86ab0 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -962,8 +962,7 @@ static int emulator_write_std(unsigned long addr,
 			      unsigned int bytes,
 			      struct kvm_vcpu *vcpu)
 {
-	printk(KERN_ERR "emulator_write_std: addr %lx n %d\n",
-	       addr, bytes);
+	pr_unimpl(vcpu, "emulator_write_std: addr %lx n %d\n", addr, bytes);
 	return X86EMUL_UNHANDLEABLE;
 }
 
@@ -1138,8 +1137,7 @@ int emulator_get_dr(struct x86_emulate_ctxt* ctxt, int dr, unsigned long *dest)
 		*dest = kvm_arch_ops->get_dr(vcpu, dr);
 		return X86EMUL_CONTINUE;
 	default:
-		printk(KERN_DEBUG "%s: unexpected dr %u\n",
-		       __FUNCTION__, dr);
+		pr_unimpl(vcpu, "%s: unexpected dr %u\n", __FUNCTION__, dr);
 		return X86EMUL_UNHANDLEABLE;
 	}
 }
@@ -1488,7 +1486,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 		break;
 #endif
 	default:
-		printk(KERN_ERR "kvm: unhandled rdmsr: 0x%x\n", msr);
+		pr_unimpl(vcpu, "unhandled rdmsr: 0x%x\n", msr);
 		return 1;
 	}
 	*pdata = data;
@@ -1543,11 +1541,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		break;
 #endif
 	case MSR_IA32_MC0_STATUS:
-		printk(KERN_WARNING "%s: MSR_IA32_MC0_STATUS 0x%llx, nop\n",
+		pr_unimpl(vcpu, "%s: MSR_IA32_MC0_STATUS 0x%llx, nop\n",
 		       __FUNCTION__, data);
 		break;
 	case MSR_IA32_MCG_STATUS:
-		printk(KERN_WARNING "%s: MSR_IA32_MCG_STATUS 0x%llx, nop\n",
+		pr_unimpl(vcpu, "%s: MSR_IA32_MCG_STATUS 0x%llx, nop\n",
 			__FUNCTION__, data);
 		break;
 	case MSR_IA32_UCODE_REV:
@@ -1567,7 +1565,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		return vcpu_register_para(vcpu, data);
 
 	default:
-		printk(KERN_ERR "kvm: unhandled wrmsr: 0x%x\n", msr);
+		pr_unimpl(vcpu, "unhandled wrmsr: 0x%x\n", msr);
 		return 1;
 	}
 	return 0;
@@ -1798,7 +1796,7 @@ int kvm_setup_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 		/*
 		 * String I/O in reverse.  Yuck.  Kill the guest, fix later.
 		 */
-		printk(KERN_ERR "kvm: guest string pio down\n");
+		pr_unimpl(vcpu, "guest string pio down\n");
 		inject_gp(vcpu);
 		return 1;
 	}
@@ -1829,7 +1827,7 @@ int kvm_setup_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 				ret = 1;
 		}
 	} else if (pio_dev)
-		printk(KERN_ERR "no string pio read support yet, "
+		pr_unimpl(vcpu, "no string pio read support yet, "
 		       "port %x size %d count %ld\n",
 			port, size, count);
 
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 7beaff1..3ec30d7 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1167,7 +1167,7 @@ static int invalid_op_interception(struct vcpu_svm *svm,
 static int task_switch_interception(struct vcpu_svm *svm,
 				    struct kvm_run *kvm_run)
 {
-	printk(KERN_DEBUG "%s: task swiche is unsupported\n", __FUNCTION__);
+	pr_unimpl(&svm->vcpu, "%s: task switch is unsupported\n", __FUNCTION__);
 	kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
 	return 0;
 }
@@ -1183,7 +1183,7 @@ static int emulate_on_interception(struct vcpu_svm *svm,
 				   struct kvm_run *kvm_run)
 {
 	if (emulate_instruction(&svm->vcpu, NULL, 0, 0) != EMULATE_DONE)
-		printk(KERN_ERR "%s: failed\n", __FUNCTION__);
+		pr_unimpl(&svm->vcpu, "%s: failed\n", __FUNCTION__);
 	return 1;
 }
 
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 3bf3650..ae54d9a 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1920,7 +1920,7 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		break;
 	}
 	kvm_run->exit_reason = 0;
-	printk(KERN_ERR "kvm: unhandled control register: op %d cr %d\n",
+	pr_unimpl(vcpu, "unhandled control register: op %d cr %d\n",
 	       (int)(exit_qualification >> 4) & 3, cr);
 	return 0;
 }
-- 
1.5.3

