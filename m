Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbZHPJip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbZHPJip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbZHPJim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:38:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45344 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989AbZHPJaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:11 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/48] KVM: s390: infrastructure to kick vcpus out of guest state
Date: Sun, 16 Aug 2009 12:29:34 +0300
Message-Id: <1250415008-17175-15-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

To ensure vcpu's come out of guest context in certain cases this patch adds a
s390 specific way to kick them out of guest context. Currently it kicks them
out to rerun the vcpu_run path in the s390 code, but the mechanism itself is
expandable and with a new flag we could also add e.g. kicks to userspace etc.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/s390/include/asm/kvm_host.h |    5 ++-
 arch/s390/kvm/intercept.c        |   12 ++++++--
 arch/s390/kvm/kvm-s390.c         |    5 +++
 arch/s390/kvm/kvm-s390.h         |    3 ++
 arch/s390/kvm/sigp.c             |   56 +++++++++++++++++++++++---------------
 5 files changed, 54 insertions(+), 27 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 1cd02f6..0a784f6 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -182,8 +182,9 @@ struct kvm_s390_interrupt_info {
 };
 
 /* for local_interrupt.action_flags */
-#define ACTION_STORE_ON_STOP 1
-#define ACTION_STOP_ON_STOP  2
+#define ACTION_STORE_ON_STOP		(1<<0)
+#define ACTION_STOP_ON_STOP		(1<<1)
+#define ACTION_RELOADVCPU_ON_STOP	(1<<2)
 
 struct kvm_s390_local_interrupt {
 	spinlock_t lock;
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 98997cc..0732ab4 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -128,7 +128,7 @@ static int handle_noop(struct kvm_vcpu *vcpu)
 
 static int handle_stop(struct kvm_vcpu *vcpu)
 {
-	int rc;
+	int rc = 0;
 
 	vcpu->stat.exit_stop_request++;
 	atomic_clear_mask(CPUSTAT_RUNNING, &vcpu->arch.sie_block->cpuflags);
@@ -141,12 +141,18 @@ static int handle_stop(struct kvm_vcpu *vcpu)
 			rc = -ENOTSUPP;
 	}
 
+	if (vcpu->arch.local_int.action_bits & ACTION_RELOADVCPU_ON_STOP) {
+		vcpu->arch.local_int.action_bits &= ~ACTION_RELOADVCPU_ON_STOP;
+		rc = SIE_INTERCEPT_RERUNVCPU;
+		vcpu->run->exit_reason = KVM_EXIT_INTR;
+	}
+
 	if (vcpu->arch.local_int.action_bits & ACTION_STOP_ON_STOP) {
 		vcpu->arch.local_int.action_bits &= ~ACTION_STOP_ON_STOP;
 		VCPU_EVENT(vcpu, 3, "%s", "cpu stopped");
 		rc = -ENOTSUPP;
-	} else
-		rc = 0;
+	}
+
 	spin_unlock_bh(&vcpu->arch.local_int.lock);
 	return rc;
 }
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 90d9d1b..1d65f62 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -490,6 +490,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	vcpu_load(vcpu);
 
+rerun_vcpu:
 	/* verify, that memory has been registered */
 	if (!vcpu->kvm->arch.guest_memsize) {
 		vcpu_put(vcpu);
@@ -509,6 +510,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		vcpu->arch.sie_block->gpsw.addr = kvm_run->s390_sieic.addr;
 		break;
 	case KVM_EXIT_UNKNOWN:
+	case KVM_EXIT_INTR:
 	case KVM_EXIT_S390_RESET:
 		break;
 	default:
@@ -522,6 +524,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		rc = kvm_handle_sie_intercept(vcpu);
 	} while (!signal_pending(current) && !rc);
 
+	if (rc == SIE_INTERCEPT_RERUNVCPU)
+		goto rerun_vcpu;
+
 	if (signal_pending(current) && !rc)
 		rc = -EINTR;
 
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 748fee8..2072cd4 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -20,6 +20,8 @@
 
 typedef int (*intercept_handler_t)(struct kvm_vcpu *vcpu);
 
+/* negativ values are error codes, positive values for internal conditions */
+#define SIE_INTERCEPT_RERUNVCPU		(1<<0)
 int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu);
 
 #define VM_EVENT(d_kvm, d_loglevel, d_string, d_args...)\
@@ -50,6 +52,7 @@ int kvm_s390_inject_vm(struct kvm *kvm,
 int kvm_s390_inject_vcpu(struct kvm_vcpu *vcpu,
 		struct kvm_s390_interrupt *s390int);
 int kvm_s390_inject_program_int(struct kvm_vcpu *vcpu, u16 code);
+int kvm_s390_inject_sigp_stop(struct kvm_vcpu *vcpu, int action);
 
 /* implemented in priv.c */
 int kvm_s390_handle_b2(struct kvm_vcpu *vcpu);
diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index 0ef81d6..21897b0 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -1,7 +1,7 @@
 /*
  * sigp.c - handlinge interprocessor communication
  *
- * Copyright IBM Corp. 2008
+ * Copyright IBM Corp. 2008,2009
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License (version 2 only)
@@ -9,6 +9,7 @@
  *
  *    Author(s): Carsten Otte <cotte@de.ibm.com>
  *               Christian Borntraeger <borntraeger@de.ibm.com>
+ *               Christian Ehrhardt <ehrhardt@de.ibm.com>
  */
 
 #include <linux/kvm.h>
@@ -107,46 +108,57 @@ unlock:
 	return rc;
 }
 
-static int __sigp_stop(struct kvm_vcpu *vcpu, u16 cpu_addr, int store)
+static int __inject_sigp_stop(struct kvm_s390_local_interrupt *li, int action)
 {
-	struct kvm_s390_float_interrupt *fi = &vcpu->kvm->arch.float_int;
-	struct kvm_s390_local_interrupt *li;
 	struct kvm_s390_interrupt_info *inti;
-	int rc;
-
-	if (cpu_addr >= KVM_MAX_VCPUS)
-		return 3; /* not operational */
 
 	inti = kzalloc(sizeof(*inti), GFP_KERNEL);
 	if (!inti)
 		return -ENOMEM;
-
 	inti->type = KVM_S390_SIGP_STOP;
 
-	spin_lock(&fi->lock);
-	li = fi->local_int[cpu_addr];
-	if (li == NULL) {
-		rc = 3; /* not operational */
-		kfree(inti);
-		goto unlock;
-	}
 	spin_lock_bh(&li->lock);
 	list_add_tail(&inti->list, &li->list);
 	atomic_set(&li->active, 1);
 	atomic_set_mask(CPUSTAT_STOP_INT, li->cpuflags);
-	if (store)
-		li->action_bits |= ACTION_STORE_ON_STOP;
-	li->action_bits |= ACTION_STOP_ON_STOP;
+	li->action_bits |= action;
 	if (waitqueue_active(&li->wq))
 		wake_up_interruptible(&li->wq);
 	spin_unlock_bh(&li->lock);
-	rc = 0; /* order accepted */
+
+	return 0; /* order accepted */
+}
+
+static int __sigp_stop(struct kvm_vcpu *vcpu, u16 cpu_addr, int action)
+{
+	struct kvm_s390_float_interrupt *fi = &vcpu->kvm->arch.float_int;
+	struct kvm_s390_local_interrupt *li;
+	int rc;
+
+	if (cpu_addr >= KVM_MAX_VCPUS)
+		return 3; /* not operational */
+
+	spin_lock(&fi->lock);
+	li = fi->local_int[cpu_addr];
+	if (li == NULL) {
+		rc = 3; /* not operational */
+		goto unlock;
+	}
+
+	rc = __inject_sigp_stop(li, action);
+
 unlock:
 	spin_unlock(&fi->lock);
 	VCPU_EVENT(vcpu, 4, "sent sigp stop to cpu %x", cpu_addr);
 	return rc;
 }
 
+int kvm_s390_inject_sigp_stop(struct kvm_vcpu *vcpu, int action)
+{
+	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
+	return __inject_sigp_stop(li, action);
+}
+
 static int __sigp_set_arch(struct kvm_vcpu *vcpu, u32 parameter)
 {
 	int rc;
@@ -262,11 +274,11 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu)
 		break;
 	case SIGP_STOP:
 		vcpu->stat.instruction_sigp_stop++;
-		rc = __sigp_stop(vcpu, cpu_addr, 0);
+		rc = __sigp_stop(vcpu, cpu_addr, ACTION_STOP_ON_STOP);
 		break;
 	case SIGP_STOP_STORE_STATUS:
 		vcpu->stat.instruction_sigp_stop++;
-		rc = __sigp_stop(vcpu, cpu_addr, 1);
+		rc = __sigp_stop(vcpu, cpu_addr, ACTION_STORE_ON_STOP);
 		break;
 	case SIGP_SET_ARCH:
 		vcpu->stat.instruction_sigp_arch++;
-- 
1.6.3.3

