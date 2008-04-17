Return-Path: <linux-kernel-owner+w=401wt.eu-S1765340AbYDQJPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765340AbYDQJPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762972AbYDQJLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:05 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58976
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429AbYDQJK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:10:56 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 10/45] KVM: s390: interprocessor communication via sigp
Date: Thu, 17 Apr 2008 12:10:15 +0300
Message-Id: <1208423450-29415-11-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

From: Christian Borntraeger <borntraeger@de.ibm.com>

This patch introduces in-kernel handling of _some_ sigp interprocessor
signals (similar to ipi).
kvm_s390_handle_sigp() decodes the sigp instruction and calls individual
handlers depending on the operation requested:
- sigp sense tries to retrieve information such as existence or running state
  of the remote cpu
- sigp emergency sends an external interrupt to the remove cpu
- sigp stop stops a remove cpu
- sigp stop store status stops a remote cpu, and stores its entire internal
  state to the cpus lowcore
- sigp set arch sets the architecture mode of the remote cpu. setting to
  ESAME (s390x 64bit) is accepted, setting to ESA/S390 (s390, 31 or 24 bit) is
  denied, all others are passed to userland
- sigp set prefix sets the prefix register of a remote cpu

For implementation of this, the stop intercept indication starts to get reused
on purpose: a set of action bits defines what to do once a cpu gets stopped:
ACTION_STOP_ON_STOP  really stops the cpu when a stop intercept is recognized
ACTION_STORE_ON_STOP stores the cpu status to lowcore when a stop intercept is
                     recognized

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/s390/kvm/Makefile      |    2 +-
 arch/s390/kvm/intercept.c   |   22 +++-
 arch/s390/kvm/kvm-s390.c    |    7 +
 arch/s390/kvm/kvm-s390.h    |    7 +
 arch/s390/kvm/sigp.c        |  288 +++++++++++++++++++++++++++++++++++++++++++
 include/asm-s390/kvm_host.h |   12 ++
 6 files changed, 335 insertions(+), 3 deletions(-)
 create mode 100644 arch/s390/kvm/sigp.c

diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index 82dde1e..f3bf11a 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -10,5 +10,5 @@ common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o)
 
 EXTRA_CFLAGS += -Ivirt/kvm -Iarch/s390/kvm
 
-kvm-objs := $(common-objs) kvm-s390.o sie64a.o intercept.o interrupt.o priv.o
+kvm-objs := $(common-objs) kvm-s390.o sie64a.o intercept.o interrupt.o priv.o sigp.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 7a20d63..9f0d8b2 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -95,6 +95,7 @@ static int handle_lctl(struct kvm_vcpu *vcpu)
 }
 
 static intercept_handler_t instruction_handlers[256] = {
+	[0xae] = kvm_s390_handle_sigp,
 	[0xb2] = kvm_s390_handle_priv,
 	[0xb7] = handle_lctl,
 	[0xeb] = handle_lctg,
@@ -117,10 +118,27 @@ static int handle_noop(struct kvm_vcpu *vcpu)
 
 static int handle_stop(struct kvm_vcpu *vcpu)
 {
+	int rc;
+
 	vcpu->stat.exit_stop_request++;
-	VCPU_EVENT(vcpu, 3, "%s", "cpu stopped");
 	atomic_clear_mask(CPUSTAT_RUNNING, &vcpu->arch.sie_block->cpuflags);
-	return -ENOTSUPP;
+	spin_lock_bh(&vcpu->arch.local_int.lock);
+	if (vcpu->arch.local_int.action_bits & ACTION_STORE_ON_STOP) {
+		vcpu->arch.local_int.action_bits &= ~ACTION_STORE_ON_STOP;
+		rc = __kvm_s390_vcpu_store_status(vcpu,
+						  KVM_S390_STORE_STATUS_NOADDR);
+		if (rc >= 0)
+			rc = -ENOTSUPP;
+	}
+
+	if (vcpu->arch.local_int.action_bits & ACTION_STOP_ON_STOP) {
+		vcpu->arch.local_int.action_bits &= ~ACTION_STOP_ON_STOP;
+		VCPU_EVENT(vcpu, 3, "%s", "cpu stopped");
+		rc = -ENOTSUPP;
+	} else
+		rc = 0;
+	spin_unlock_bh(&vcpu->arch.local_int.lock);
+	return rc;
 }
 
 static int handle_validity(struct kvm_vcpu *vcpu)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 5a17176..c632180 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -57,6 +57,12 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "instruction_chsc", VCPU_STAT(instruction_chsc) },
 	{ "instruction_stsi", VCPU_STAT(instruction_stsi) },
 	{ "instruction_stfl", VCPU_STAT(instruction_stfl) },
+	{ "instruction_sigp_sense", VCPU_STAT(instruction_sigp_sense) },
+	{ "instruction_sigp_emergency", VCPU_STAT(instruction_sigp_emergency) },
+	{ "instruction_sigp_stop", VCPU_STAT(instruction_sigp_stop) },
+	{ "instruction_sigp_set_arch", VCPU_STAT(instruction_sigp_arch) },
+	{ "instruction_sigp_set_prefix", VCPU_STAT(instruction_sigp_prefix) },
+	{ "instruction_sigp_restart", VCPU_STAT(instruction_sigp_restart) },
 	{ NULL }
 };
 
@@ -287,6 +293,7 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 	spin_lock_bh(&kvm->arch.float_int.lock);
 	kvm->arch.float_int.local_int[id] = &vcpu->arch.local_int;
 	init_waitqueue_head(&vcpu->arch.local_int.wq);
+	vcpu->arch.local_int.cpuflags = &vcpu->arch.sie_block->cpuflags;
 	spin_unlock_bh(&kvm->arch.float_int.lock);
 
 	rc = kvm_vcpu_init(vcpu, kvm, id);
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 50f96b3..e6e5756 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -51,4 +51,11 @@ int kvm_s390_inject_program_int(struct kvm_vcpu *vcpu, u16 code);
 
 /* implemented in priv.c */
 int kvm_s390_handle_priv(struct kvm_vcpu *vcpu);
+
+/* implemented in sigp.c */
+int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
+
+/* implemented in kvm-s390.c */
+int __kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu,
+				 unsigned long addr);
 #endif
diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
new file mode 100644
index 0000000..0a236ac
--- /dev/null
+++ b/arch/s390/kvm/sigp.c
@@ -0,0 +1,288 @@
+/*
+ * sigp.c - handlinge interprocessor communication
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ *
+ *    Author(s): Carsten Otte <cotte@de.ibm.com>
+ *               Christian Borntraeger <borntraeger@de.ibm.com>
+ */
+
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include "gaccess.h"
+#include "kvm-s390.h"
+
+/* sigp order codes */
+#define SIGP_SENSE             0x01
+#define SIGP_EXTERNAL_CALL     0x02
+#define SIGP_EMERGENCY         0x03
+#define SIGP_START             0x04
+#define SIGP_STOP              0x05
+#define SIGP_RESTART           0x06
+#define SIGP_STOP_STORE_STATUS 0x09
+#define SIGP_INITIAL_CPU_RESET 0x0b
+#define SIGP_CPU_RESET         0x0c
+#define SIGP_SET_PREFIX        0x0d
+#define SIGP_STORE_STATUS_ADDR 0x0e
+#define SIGP_SET_ARCH          0x12
+
+/* cpu status bits */
+#define SIGP_STAT_EQUIPMENT_CHECK   0x80000000UL
+#define SIGP_STAT_INCORRECT_STATE   0x00000200UL
+#define SIGP_STAT_INVALID_PARAMETER 0x00000100UL
+#define SIGP_STAT_EXT_CALL_PENDING  0x00000080UL
+#define SIGP_STAT_STOPPED           0x00000040UL
+#define SIGP_STAT_OPERATOR_INTERV   0x00000020UL
+#define SIGP_STAT_CHECK_STOP        0x00000010UL
+#define SIGP_STAT_INOPERATIVE       0x00000004UL
+#define SIGP_STAT_INVALID_ORDER     0x00000002UL
+#define SIGP_STAT_RECEIVER_CHECK    0x00000001UL
+
+
+static int __sigp_sense(struct kvm_vcpu *vcpu, u16 cpu_addr, u64 *reg)
+{
+	struct float_interrupt *fi = &vcpu->kvm->arch.float_int;
+	int rc;
+
+	if (cpu_addr >= KVM_MAX_VCPUS)
+		return 3; /* not operational */
+
+	spin_lock_bh(&fi->lock);
+	if (fi->local_int[cpu_addr] == NULL)
+		rc = 3; /* not operational */
+	else if (atomic_read(fi->local_int[cpu_addr]->cpuflags)
+		 & CPUSTAT_RUNNING) {
+		*reg &= 0xffffffff00000000UL;
+		rc = 1; /* status stored */
+	} else {
+		*reg &= 0xffffffff00000000UL;
+		*reg |= SIGP_STAT_STOPPED;
+		rc = 1; /* status stored */
+	}
+	spin_unlock_bh(&fi->lock);
+
+	VCPU_EVENT(vcpu, 4, "sensed status of cpu %x rc %x", cpu_addr, rc);
+	return rc;
+}
+
+static int __sigp_emergency(struct kvm_vcpu *vcpu, u16 cpu_addr)
+{
+	struct float_interrupt *fi = &vcpu->kvm->arch.float_int;
+	struct local_interrupt *li;
+	struct interrupt_info *inti;
+	int rc;
+
+	if (cpu_addr >= KVM_MAX_VCPUS)
+		return 3; /* not operational */
+
+	inti = kzalloc(sizeof(*inti), GFP_KERNEL);
+	if (!inti)
+		return -ENOMEM;
+
+	inti->type = KVM_S390_INT_EMERGENCY;
+
+	spin_lock_bh(&fi->lock);
+	li = fi->local_int[cpu_addr];
+	if (li == NULL) {
+		rc = 3; /* not operational */
+		kfree(inti);
+		goto unlock;
+	}
+	spin_lock_bh(&li->lock);
+	list_add_tail(&inti->list, &li->list);
+	atomic_set(&li->active, 1);
+	atomic_set_mask(CPUSTAT_EXT_INT, li->cpuflags);
+	if (waitqueue_active(&li->wq))
+		wake_up_interruptible(&li->wq);
+	spin_unlock_bh(&li->lock);
+	rc = 0; /* order accepted */
+unlock:
+	spin_unlock_bh(&fi->lock);
+	VCPU_EVENT(vcpu, 4, "sent sigp emerg to cpu %x", cpu_addr);
+	return rc;
+}
+
+static int __sigp_stop(struct kvm_vcpu *vcpu, u16 cpu_addr, int store)
+{
+	struct float_interrupt *fi = &vcpu->kvm->arch.float_int;
+	struct local_interrupt *li;
+	struct interrupt_info *inti;
+	int rc;
+
+	if (cpu_addr >= KVM_MAX_VCPUS)
+		return 3; /* not operational */
+
+	inti = kzalloc(sizeof(*inti), GFP_KERNEL);
+	if (!inti)
+		return -ENOMEM;
+
+	inti->type = KVM_S390_SIGP_STOP;
+
+	spin_lock_bh(&fi->lock);
+	li = fi->local_int[cpu_addr];
+	if (li == NULL) {
+		rc = 3; /* not operational */
+		kfree(inti);
+		goto unlock;
+	}
+	spin_lock_bh(&li->lock);
+	list_add_tail(&inti->list, &li->list);
+	atomic_set(&li->active, 1);
+	atomic_set_mask(CPUSTAT_STOP_INT, li->cpuflags);
+	if (store)
+		li->action_bits |= ACTION_STORE_ON_STOP;
+	li->action_bits |= ACTION_STOP_ON_STOP;
+	if (waitqueue_active(&li->wq))
+		wake_up_interruptible(&li->wq);
+	spin_unlock_bh(&li->lock);
+	rc = 0; /* order accepted */
+unlock:
+	spin_unlock_bh(&fi->lock);
+	VCPU_EVENT(vcpu, 4, "sent sigp stop to cpu %x", cpu_addr);
+	return rc;
+}
+
+static int __sigp_set_arch(struct kvm_vcpu *vcpu, u32 parameter)
+{
+	int rc;
+
+	switch (parameter & 0xff) {
+	case 0:
+		printk(KERN_WARNING "kvm: request to switch to ESA/390 mode"
+							" not supported");
+		rc = 3; /* not operational */
+		break;
+	case 1:
+	case 2:
+		rc = 0; /* order accepted */
+		break;
+	default:
+		rc = -ENOTSUPP;
+	}
+	return rc;
+}
+
+static int __sigp_set_prefix(struct kvm_vcpu *vcpu, u16 cpu_addr, u32 address,
+			     u64 *reg)
+{
+	struct float_interrupt *fi = &vcpu->kvm->arch.float_int;
+	struct local_interrupt *li;
+	struct interrupt_info *inti;
+	int rc;
+	u8 tmp;
+
+	/* make sure that the new value is valid memory */
+	address = address & 0x7fffe000u;
+	if ((copy_from_guest(vcpu, &tmp,
+		(u64) (address + vcpu->kvm->arch.guest_origin) , 1)) ||
+	   (copy_from_guest(vcpu, &tmp, (u64) (address +
+			vcpu->kvm->arch.guest_origin + PAGE_SIZE), 1))) {
+		*reg |= SIGP_STAT_INVALID_PARAMETER;
+		return 1; /* invalid parameter */
+	}
+
+	inti = kzalloc(sizeof(*inti), GFP_KERNEL);
+	if (!inti)
+		return 2; /* busy */
+
+	spin_lock_bh(&fi->lock);
+	li = fi->local_int[cpu_addr];
+
+	if ((cpu_addr >= KVM_MAX_VCPUS) || (li == NULL)) {
+		rc = 1; /* incorrect state */
+		*reg &= SIGP_STAT_INCORRECT_STATE;
+		kfree(inti);
+		goto out_fi;
+	}
+
+	spin_lock_bh(&li->lock);
+	/* cpu must be in stopped state */
+	if (atomic_read(li->cpuflags) & CPUSTAT_RUNNING) {
+		rc = 1; /* incorrect state */
+		*reg &= SIGP_STAT_INCORRECT_STATE;
+		kfree(inti);
+		goto out_li;
+	}
+
+	inti->type = KVM_S390_SIGP_SET_PREFIX;
+	inti->prefix.address = address;
+
+	list_add_tail(&inti->list, &li->list);
+	atomic_set(&li->active, 1);
+	if (waitqueue_active(&li->wq))
+		wake_up_interruptible(&li->wq);
+	rc = 0; /* order accepted */
+
+	VCPU_EVENT(vcpu, 4, "set prefix of cpu %02x to %x", cpu_addr, address);
+out_li:
+	spin_unlock_bh(&li->lock);
+out_fi:
+	spin_unlock_bh(&fi->lock);
+	return rc;
+}
+
+int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu)
+{
+	int r1 = (vcpu->arch.sie_block->ipa & 0x00f0) >> 4;
+	int r3 = vcpu->arch.sie_block->ipa & 0x000f;
+	int base2 = vcpu->arch.sie_block->ipb >> 28;
+	int disp2 = ((vcpu->arch.sie_block->ipb & 0x0fff0000) >> 16);
+	u32 parameter;
+	u16 cpu_addr = vcpu->arch.guest_gprs[r3];
+	u8 order_code;
+	int rc;
+
+	order_code = disp2;
+	if (base2)
+		order_code += vcpu->arch.guest_gprs[base2];
+
+	if (r1 % 2)
+		parameter = vcpu->arch.guest_gprs[r1];
+	else
+		parameter = vcpu->arch.guest_gprs[r1 + 1];
+
+	switch (order_code) {
+	case SIGP_SENSE:
+		vcpu->stat.instruction_sigp_sense++;
+		rc = __sigp_sense(vcpu, cpu_addr,
+				  &vcpu->arch.guest_gprs[r1]);
+		break;
+	case SIGP_EMERGENCY:
+		vcpu->stat.instruction_sigp_emergency++;
+		rc = __sigp_emergency(vcpu, cpu_addr);
+		break;
+	case SIGP_STOP:
+		vcpu->stat.instruction_sigp_stop++;
+		rc = __sigp_stop(vcpu, cpu_addr, 0);
+		break;
+	case SIGP_STOP_STORE_STATUS:
+		vcpu->stat.instruction_sigp_stop++;
+		rc = __sigp_stop(vcpu, cpu_addr, 1);
+		break;
+	case SIGP_SET_ARCH:
+		vcpu->stat.instruction_sigp_arch++;
+		rc = __sigp_set_arch(vcpu, parameter);
+		break;
+	case SIGP_SET_PREFIX:
+		vcpu->stat.instruction_sigp_prefix++;
+		rc = __sigp_set_prefix(vcpu, cpu_addr, parameter,
+				       &vcpu->arch.guest_gprs[r1]);
+		break;
+	case SIGP_RESTART:
+		vcpu->stat.instruction_sigp_restart++;
+		/* user space must know about restart */
+	default:
+		return -ENOTSUPP;
+	}
+
+	if (rc < 0)
+		return rc;
+
+	vcpu->arch.sie_block->gpsw.mask &= ~(3ul << 44);
+	vcpu->arch.sie_block->gpsw.mask |= (rc & 3ul) << 44;
+	return 0;
+}
diff --git a/include/asm-s390/kvm_host.h b/include/asm-s390/kvm_host.h
index 2eaf6fe..1c829bd 100644
--- a/include/asm-s390/kvm_host.h
+++ b/include/asm-s390/kvm_host.h
@@ -128,6 +128,12 @@ struct kvm_vcpu_stat {
 	u32 instruction_chsc;
 	u32 instruction_stsi;
 	u32 instruction_stfl;
+	u32 instruction_sigp_sense;
+	u32 instruction_sigp_emergency;
+	u32 instruction_sigp_stop;
+	u32 instruction_sigp_arch;
+	u32 instruction_sigp_prefix;
+	u32 instruction_sigp_restart;
 };
 
 struct io_info {
@@ -169,6 +175,10 @@ struct interrupt_info {
 	};
 };
 
+/* for local_interrupt.action_flags */
+#define ACTION_STORE_ON_STOP 1
+#define ACTION_STOP_ON_STOP  2
+
 struct local_interrupt {
 	spinlock_t lock;
 	struct list_head list;
@@ -176,6 +186,8 @@ struct local_interrupt {
 	struct float_interrupt *float_int;
 	int timer_due; /* event indicator for waitqueue below */
 	wait_queue_head_t wq;
+	atomic_t *cpuflags;
+	unsigned int action_bits;
 };
 
 struct float_interrupt {
-- 
1.5.5

