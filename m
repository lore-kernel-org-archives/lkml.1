Return-Path: <linux-kernel-owner+w=401wt.eu-S1760332AbYDQJPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760332AbYDQJPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763268AbYDQJLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:08 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58967
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757228AbYDQJK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:10:57 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 08/45] KVM: s390: interrupt subsystem, cpu timer, waitpsw
Date: Thu, 17 Apr 2008 12:10:13 +0300
Message-Id: <1208423450-29415-9-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

This patch contains the s390 interrupt subsystem (similar to in kernel apic)
including timer interrupts (similar to in-kernel-pit) and enabled wait
(similar to in kernel hlt).

In order to achieve that, this patch also introduces intercept handling
for instruction intercepts, and it implements load control instructions.

This patch introduces an ioctl KVM_S390_INTERRUPT which is valid for both
the vm file descriptors and the vcpu file descriptors. In case this ioctl is
issued against a vm file descriptor, the interrupt is considered floating.
Floating interrupts may be delivered to any virtual cpu in the configuration.

The following interrupts are supported:
SIGP STOP       - interprocessor signal that stops a remote cpu
SIGP SET PREFIX - interprocessor signal that sets the prefix register of a
                  (stopped) remote cpu
INT EMERGENCY   - interprocessor interrupt, usually used to signal need_reshed
                  and for smp_call_function() in the guest.
PROGRAM INT     - exception during program execution such as page fault, illegal
                  instruction and friends
RESTART         - interprocessor signal that starts a stopped cpu
INT VIRTIO      - floating interrupt for virtio signalisation
INT SERVICE     - floating interrupt for signalisations from the system
                  service processor

struct kvm_s390_interrupt, which is submitted as ioctl parameter when injecting
an interrupt, also carrys parameter data for interrupts along with the interrupt
type. Interrupts on s390 usually have a state that represents the current
operation, or identifies which device has caused the interruption on s390.

kvm_s390_handle_wait() does handle waitpsw in two flavors: in case of a
disabled wait (that is, disabled for interrupts), we exit to userspace. In case
of an enabled wait we set up a timer that equals the cpu clock comparator value
and sleep on a wait queue.

[christian: change virtio interrupt to 0x2603]

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/s390/kvm/Makefile      |    2 +-
 arch/s390/kvm/intercept.c   |  116 +++++++++
 arch/s390/kvm/interrupt.c   |  587 +++++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.c    |   48 ++++-
 arch/s390/kvm/kvm-s390.h    |   15 ++
 include/asm-s390/kvm_host.h |   75 ++++++
 include/linux/kvm.h         |   17 ++
 7 files changed, 857 insertions(+), 3 deletions(-)
 create mode 100644 arch/s390/kvm/interrupt.c

diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index 27882b3..7275a1a 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -10,5 +10,5 @@ common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o)
 
 EXTRA_CFLAGS += -Ivirt/kvm -Iarch/s390/kvm
 
-kvm-objs := $(common-objs) kvm-s390.o sie64a.o intercept.o
+kvm-objs := $(common-objs) kvm-s390.o sie64a.o intercept.o interrupt.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index e757230..7f7347b 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -18,6 +18,86 @@
 #include <asm/kvm_host.h>
 
 #include "kvm-s390.h"
+#include "gaccess.h"
+
+static int handle_lctg(struct kvm_vcpu *vcpu)
+{
+	int reg1 = (vcpu->arch.sie_block->ipa & 0x00f0) >> 4;
+	int reg3 = vcpu->arch.sie_block->ipa & 0x000f;
+	int base2 = vcpu->arch.sie_block->ipb >> 28;
+	int disp2 = ((vcpu->arch.sie_block->ipb & 0x0fff0000) >> 16) +
+			((vcpu->arch.sie_block->ipb & 0xff00) << 4);
+	u64 useraddr;
+	int reg, rc;
+
+	vcpu->stat.instruction_lctg++;
+	if ((vcpu->arch.sie_block->ipb & 0xff) != 0x2f)
+		return -ENOTSUPP;
+
+	useraddr = disp2;
+	if (base2)
+		useraddr += vcpu->arch.guest_gprs[base2];
+
+	reg = reg1;
+
+	VCPU_EVENT(vcpu, 5, "lctg r1:%x, r3:%x,b2:%x,d2:%x", reg1, reg3, base2,
+		   disp2);
+
+	do {
+		rc = get_guest_u64(vcpu, useraddr,
+				   &vcpu->arch.sie_block->gcr[reg]);
+		if (rc == -EFAULT) {
+			kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
+			break;
+		}
+		useraddr += 8;
+		if (reg == reg3)
+			break;
+		reg = (reg + 1) % 16;
+	} while (1);
+	return 0;
+}
+
+static int handle_lctl(struct kvm_vcpu *vcpu)
+{
+	int reg1 = (vcpu->arch.sie_block->ipa & 0x00f0) >> 4;
+	int reg3 = vcpu->arch.sie_block->ipa & 0x000f;
+	int base2 = vcpu->arch.sie_block->ipb >> 28;
+	int disp2 = ((vcpu->arch.sie_block->ipb & 0x0fff0000) >> 16);
+	u64 useraddr;
+	u32 val = 0;
+	int reg, rc;
+
+	vcpu->stat.instruction_lctl++;
+
+	useraddr = disp2;
+	if (base2)
+		useraddr += vcpu->arch.guest_gprs[base2];
+
+	VCPU_EVENT(vcpu, 5, "lctl r1:%x, r3:%x,b2:%x,d2:%x", reg1, reg3, base2,
+		   disp2);
+
+	reg = reg1;
+	do {
+		rc = get_guest_u32(vcpu, useraddr, &val);
+		if (rc == -EFAULT) {
+			kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
+			break;
+		}
+		vcpu->arch.sie_block->gcr[reg] &= 0xffffffff00000000ul;
+		vcpu->arch.sie_block->gcr[reg] |= val;
+		useraddr += 4;
+		if (reg == reg3)
+			break;
+		reg = (reg + 1) % 16;
+	} while (1);
+	return 0;
+}
+
+static intercept_handler_t instruction_handlers[256] = {
+	[0xb7] = handle_lctl,
+	[0xeb] = handle_lctg,
+};
 
 static int handle_noop(struct kvm_vcpu *vcpu)
 {
@@ -58,10 +138,46 @@ static int handle_validity(struct kvm_vcpu *vcpu)
 	return -ENOTSUPP;
 }
 
+static int handle_instruction(struct kvm_vcpu *vcpu)
+{
+	intercept_handler_t handler;
+
+	vcpu->stat.exit_instruction++;
+	handler = instruction_handlers[vcpu->arch.sie_block->ipa >> 8];
+	if (handler)
+		return handler(vcpu);
+	return -ENOTSUPP;
+}
+
+static int handle_prog(struct kvm_vcpu *vcpu)
+{
+	vcpu->stat.exit_program_interruption++;
+	return kvm_s390_inject_program_int(vcpu, vcpu->arch.sie_block->iprcc);
+}
+
+static int handle_instruction_and_prog(struct kvm_vcpu *vcpu)
+{
+	int rc, rc2;
+
+	vcpu->stat.exit_instr_and_program++;
+	rc = handle_instruction(vcpu);
+	rc2 = handle_prog(vcpu);
+
+	if (rc == -ENOTSUPP)
+		vcpu->arch.sie_block->icptcode = 0x04;
+	if (rc)
+		return rc;
+	return rc2;
+}
+
 static const intercept_handler_t intercept_funcs[0x48 >> 2] = {
 	[0x00 >> 2] = handle_noop,
+	[0x04 >> 2] = handle_instruction,
+	[0x08 >> 2] = handle_prog,
+	[0x0C >> 2] = handle_instruction_and_prog,
 	[0x10 >> 2] = handle_noop,
 	[0x14 >> 2] = handle_noop,
+	[0x1C >> 2] = kvm_s390_handle_wait,
 	[0x20 >> 2] = handle_validity,
 	[0x28 >> 2] = handle_stop,
 };
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
new file mode 100644
index 0000000..a6c6ebc
--- /dev/null
+++ b/arch/s390/kvm/interrupt.c
@@ -0,0 +1,587 @@
+/*
+ * interrupt.c - handling kvm guest interrupts
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ *
+ *    Author(s): Carsten Otte <cotte@de.ibm.com>
+ */
+
+#include <asm/lowcore.h>
+#include <asm/uaccess.h>
+#include <linux/kvm_host.h>
+#include "kvm-s390.h"
+#include "gaccess.h"
+
+static int psw_extint_disabled(struct kvm_vcpu *vcpu)
+{
+	return !(vcpu->arch.sie_block->gpsw.mask & PSW_MASK_EXT);
+}
+
+static int psw_interrupts_disabled(struct kvm_vcpu *vcpu)
+{
+	if ((vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PER) ||
+	    (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_IO) ||
+	    (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_EXT))
+		return 0;
+	return 1;
+}
+
+static int __interrupt_is_deliverable(struct kvm_vcpu *vcpu,
+				      struct interrupt_info *inti)
+{
+	switch (inti->type) {
+	case KVM_S390_INT_EMERGENCY:
+		if (psw_extint_disabled(vcpu))
+			return 0;
+		if (vcpu->arch.sie_block->gcr[0] & 0x4000ul)
+			return 1;
+		return 0;
+	case KVM_S390_INT_SERVICE:
+		if (psw_extint_disabled(vcpu))
+			return 0;
+		if (vcpu->arch.sie_block->gcr[0] & 0x200ul)
+			return 1;
+		return 0;
+	case KVM_S390_INT_VIRTIO:
+		if (psw_extint_disabled(vcpu))
+			return 0;
+		if (vcpu->arch.sie_block->gcr[0] & 0x200ul)
+			return 1; /*FIXME virtio control register bit */
+		return 0;
+	case KVM_S390_PROGRAM_INT:
+	case KVM_S390_SIGP_STOP:
+	case KVM_S390_SIGP_SET_PREFIX:
+	case KVM_S390_RESTART:
+		return 1;
+	default:
+		BUG();
+	}
+	return 0;
+}
+
+static void __set_cpu_idle(struct kvm_vcpu *vcpu)
+{
+	BUG_ON(vcpu->vcpu_id > KVM_MAX_VCPUS - 1);
+	atomic_set_mask(CPUSTAT_WAIT, &vcpu->arch.sie_block->cpuflags);
+	set_bit(vcpu->vcpu_id, vcpu->arch.local_int.float_int->idle_mask);
+}
+
+static void __unset_cpu_idle(struct kvm_vcpu *vcpu)
+{
+	BUG_ON(vcpu->vcpu_id > KVM_MAX_VCPUS - 1);
+	atomic_clear_mask(CPUSTAT_WAIT, &vcpu->arch.sie_block->cpuflags);
+	clear_bit(vcpu->vcpu_id, vcpu->arch.local_int.float_int->idle_mask);
+}
+
+static void __reset_intercept_indicators(struct kvm_vcpu *vcpu)
+{
+	atomic_clear_mask(CPUSTAT_ECALL_PEND |
+		CPUSTAT_IO_INT | CPUSTAT_EXT_INT | CPUSTAT_STOP_INT,
+		&vcpu->arch.sie_block->cpuflags);
+	vcpu->arch.sie_block->lctl = 0x0000;
+}
+
+static void __set_cpuflag(struct kvm_vcpu *vcpu, u32 flag)
+{
+	atomic_set_mask(flag, &vcpu->arch.sie_block->cpuflags);
+}
+
+static void __set_intercept_indicator(struct kvm_vcpu *vcpu,
+				      struct interrupt_info *inti)
+{
+	switch (inti->type) {
+	case KVM_S390_INT_EMERGENCY:
+	case KVM_S390_INT_SERVICE:
+	case KVM_S390_INT_VIRTIO:
+		if (psw_extint_disabled(vcpu))
+			__set_cpuflag(vcpu, CPUSTAT_EXT_INT);
+		else
+			vcpu->arch.sie_block->lctl |= LCTL_CR0;
+		break;
+	case KVM_S390_SIGP_STOP:
+		__set_cpuflag(vcpu, CPUSTAT_STOP_INT);
+		break;
+	default:
+		BUG();
+	}
+}
+
+static void __do_deliver_interrupt(struct kvm_vcpu *vcpu,
+				   struct interrupt_info *inti)
+{
+	const unsigned short table[] = { 2, 4, 4, 6 };
+	int rc, exception = 0;
+
+	switch (inti->type) {
+	case KVM_S390_INT_EMERGENCY:
+		VCPU_EVENT(vcpu, 4, "%s", "interrupt: sigp emerg");
+		vcpu->stat.deliver_emergency_signal++;
+		rc = put_guest_u16(vcpu, __LC_EXT_INT_CODE, 0x1201);
+		if (rc == -EFAULT)
+			exception = 1;
+
+		rc = copy_to_guest(vcpu, __LC_EXT_OLD_PSW,
+			 &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
+		if (rc == -EFAULT)
+			exception = 1;
+
+		rc = copy_from_guest(vcpu, &vcpu->arch.sie_block->gpsw,
+			__LC_EXT_NEW_PSW, sizeof(psw_t));
+		if (rc == -EFAULT)
+			exception = 1;
+		break;
+
+	case KVM_S390_INT_SERVICE:
+		VCPU_EVENT(vcpu, 4, "interrupt: sclp parm:%x",
+			   inti->ext.ext_params);
+		vcpu->stat.deliver_service_signal++;
+		rc = put_guest_u16(vcpu, __LC_EXT_INT_CODE, 0x2401);
+		if (rc == -EFAULT)
+			exception = 1;
+
+		rc = copy_to_guest(vcpu, __LC_EXT_OLD_PSW,
+			 &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
+		if (rc == -EFAULT)
+			exception = 1;
+
+		rc = copy_from_guest(vcpu, &vcpu->arch.sie_block->gpsw,
+			__LC_EXT_NEW_PSW, sizeof(psw_t));
+		if (rc == -EFAULT)
+			exception = 1;
+
+		rc = put_guest_u32(vcpu, __LC_EXT_PARAMS, inti->ext.ext_params);
+		if (rc == -EFAULT)
+			exception = 1;
+		break;
+
+	case KVM_S390_INT_VIRTIO:
+		VCPU_EVENT(vcpu, 4, "interrupt: virtio parm:%x,parm64:%lx",
+			   inti->ext.ext_params, inti->ext.ext_params2);
+		vcpu->stat.deliver_virtio_interrupt++;
+		rc = put_guest_u16(vcpu, __LC_EXT_INT_CODE, 0x2603);
+		if (rc == -EFAULT)
+			exception = 1;
+
+		rc = put_guest_u16(vcpu, __LC_CPU_ADDRESS, 0x0d00);
+		if (rc == -EFAULT)
+			exception = 1;
+
+		rc = copy_to_guest(vcpu, __LC_EXT_OLD_PSW,
+			 &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
+		if (rc == -EFAULT)
+			exception = 1;
+
+		rc = copy_from_guest(vcpu, &vcpu->arch.sie_block->gpsw,
+			__LC_EXT_NEW_PSW, sizeof(psw_t));
+		if (rc == -EFAULT)
+			exception = 1;
+
+		rc = put_guest_u32(vcpu, __LC_EXT_PARAMS, inti->ext.ext_params);
+		if (rc == -EFAULT)
+			exception = 1;
+
+		rc = put_guest_u64(vcpu, __LC_PFAULT_INTPARM,
+			inti->ext.ext_params2);
+		if (rc == -EFAULT)
+			exception = 1;
+		break;
+
+	case KVM_S390_SIGP_STOP:
+		VCPU_EVENT(vcpu, 4, "%s", "interrupt: cpu stop");
+		vcpu->stat.deliver_stop_signal++;
+		__set_intercept_indicator(vcpu, inti);
+		break;
+
+	case KVM_S390_SIGP_SET_PREFIX:
+		VCPU_EVENT(vcpu, 4, "interrupt: set prefix to %x",
+			   inti->prefix.address);
+		vcpu->stat.deliver_prefix_signal++;
+		vcpu->arch.sie_block->prefix = inti->prefix.address;
+		vcpu->arch.sie_block->ihcpu = 0xffff;
+		break;
+
+	case KVM_S390_RESTART:
+		VCPU_EVENT(vcpu, 4, "%s", "interrupt: cpu restart");
+		vcpu->stat.deliver_restart_signal++;
+		rc = copy_to_guest(vcpu, offsetof(struct _lowcore,
+		  restart_old_psw), &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
+		if (rc == -EFAULT)
+			exception = 1;
+
+		rc = copy_from_guest(vcpu, &vcpu->arch.sie_block->gpsw,
+			offsetof(struct _lowcore, restart_psw), sizeof(psw_t));
+		if (rc == -EFAULT)
+			exception = 1;
+		break;
+
+	case KVM_S390_PROGRAM_INT:
+		VCPU_EVENT(vcpu, 4, "interrupt: pgm check code:%x, ilc:%x",
+			   inti->pgm.code,
+			   table[vcpu->arch.sie_block->ipa >> 14]);
+		vcpu->stat.deliver_program_int++;
+		rc = put_guest_u16(vcpu, __LC_PGM_INT_CODE, inti->pgm.code);
+		if (rc == -EFAULT)
+			exception = 1;
+
+		rc = put_guest_u16(vcpu, __LC_PGM_ILC,
+			table[vcpu->arch.sie_block->ipa >> 14]);
+		if (rc == -EFAULT)
+			exception = 1;
+
+		rc = copy_to_guest(vcpu, __LC_PGM_OLD_PSW,
+			 &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
+		if (rc == -EFAULT)
+			exception = 1;
+
+		rc = copy_from_guest(vcpu, &vcpu->arch.sie_block->gpsw,
+			__LC_PGM_NEW_PSW, sizeof(psw_t));
+		if (rc == -EFAULT)
+			exception = 1;
+		break;
+
+	default:
+		BUG();
+	}
+
+	if (exception) {
+		VCPU_EVENT(vcpu, 1, "%s", "program exception while delivering"
+			   " interrupt");
+		kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
+		if (inti->type == KVM_S390_PROGRAM_INT) {
+			printk(KERN_WARNING "kvm: recursive program check\n");
+			BUG();
+		}
+	}
+}
+
+static int __try_deliver_ckc_interrupt(struct kvm_vcpu *vcpu)
+{
+	int rc, exception = 0;
+
+	if (psw_extint_disabled(vcpu))
+		return 0;
+	if (!(vcpu->arch.sie_block->gcr[0] & 0x800ul))
+		return 0;
+	rc = put_guest_u16(vcpu, __LC_EXT_INT_CODE, 0x1004);
+	if (rc == -EFAULT)
+		exception = 1;
+	rc = copy_to_guest(vcpu, __LC_EXT_OLD_PSW,
+		 &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
+	if (rc == -EFAULT)
+		exception = 1;
+	rc = copy_from_guest(vcpu, &vcpu->arch.sie_block->gpsw,
+		__LC_EXT_NEW_PSW, sizeof(psw_t));
+	if (rc == -EFAULT)
+		exception = 1;
+
+	if (exception) {
+		VCPU_EVENT(vcpu, 1, "%s", "program exception while delivering" \
+			   " ckc interrupt");
+		kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
+		return 0;
+	}
+
+	return 1;
+}
+
+int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu)
+{
+	struct local_interrupt *li = &vcpu->arch.local_int;
+	struct float_interrupt *fi = vcpu->arch.local_int.float_int;
+	struct interrupt_info  *inti;
+	int rc = 0;
+
+	if (atomic_read(&li->active)) {
+		spin_lock_bh(&li->lock);
+		list_for_each_entry(inti, &li->list, list)
+			if (__interrupt_is_deliverable(vcpu, inti)) {
+				rc = 1;
+				break;
+			}
+		spin_unlock_bh(&li->lock);
+	}
+
+	if ((!rc) && atomic_read(&fi->active)) {
+		spin_lock_bh(&fi->lock);
+		list_for_each_entry(inti, &fi->list, list)
+			if (__interrupt_is_deliverable(vcpu, inti)) {
+				rc = 1;
+				break;
+			}
+		spin_unlock_bh(&fi->lock);
+	}
+
+	if ((!rc) && (vcpu->arch.sie_block->ckc <
+		get_clock() + vcpu->arch.sie_block->epoch)) {
+		if ((!psw_extint_disabled(vcpu)) &&
+			(vcpu->arch.sie_block->gcr[0] & 0x800ul))
+			rc = 1;
+	}
+
+	return rc;
+}
+
+int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
+{
+	u64 now, sltime;
+	DECLARE_WAITQUEUE(wait, current);
+
+	vcpu->stat.exit_wait_state++;
+	if (kvm_cpu_has_interrupt(vcpu))
+		return 0;
+
+	if (psw_interrupts_disabled(vcpu)) {
+		VCPU_EVENT(vcpu, 3, "%s", "disabled wait");
+		__unset_cpu_idle(vcpu);
+		return -ENOTSUPP; /* disabled wait */
+	}
+
+	if (psw_extint_disabled(vcpu) ||
+	    (!(vcpu->arch.sie_block->gcr[0] & 0x800ul))) {
+		VCPU_EVENT(vcpu, 3, "%s", "enabled wait w/o timer");
+		goto no_timer;
+	}
+
+	now = get_clock() + vcpu->arch.sie_block->epoch;
+	if (vcpu->arch.sie_block->ckc < now) {
+		__unset_cpu_idle(vcpu);
+		return 0;
+	}
+
+	sltime = (vcpu->arch.sie_block->ckc - now) / (0xf4240000ul / HZ) + 1;
+
+	vcpu->arch.ckc_timer.expires = jiffies + sltime;
+
+	add_timer(&vcpu->arch.ckc_timer);
+	VCPU_EVENT(vcpu, 5, "enabled wait timer:%lx jiffies", sltime);
+no_timer:
+	spin_lock_bh(&vcpu->arch.local_int.float_int->lock);
+	spin_lock_bh(&vcpu->arch.local_int.lock);
+	__set_cpu_idle(vcpu);
+	vcpu->arch.local_int.timer_due = 0;
+	add_wait_queue(&vcpu->arch.local_int.wq, &wait);
+	while (list_empty(&vcpu->arch.local_int.list) &&
+		list_empty(&vcpu->arch.local_int.float_int->list) &&
+		(!vcpu->arch.local_int.timer_due) &&
+		!signal_pending(current)) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		spin_unlock_bh(&vcpu->arch.local_int.lock);
+		spin_unlock_bh(&vcpu->arch.local_int.float_int->lock);
+		vcpu_put(vcpu);
+		schedule();
+		vcpu_load(vcpu);
+		spin_lock_bh(&vcpu->arch.local_int.float_int->lock);
+		spin_lock_bh(&vcpu->arch.local_int.lock);
+	}
+	__unset_cpu_idle(vcpu);
+	__set_current_state(TASK_RUNNING);
+	remove_wait_queue(&vcpu->wq, &wait);
+	spin_unlock_bh(&vcpu->arch.local_int.lock);
+	spin_unlock_bh(&vcpu->arch.local_int.float_int->lock);
+	del_timer(&vcpu->arch.ckc_timer);
+	return 0;
+}
+
+void kvm_s390_idle_wakeup(unsigned long data)
+{
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)data;
+
+	spin_lock_bh(&vcpu->arch.local_int.lock);
+	vcpu->arch.local_int.timer_due = 1;
+	if (waitqueue_active(&vcpu->arch.local_int.wq))
+		wake_up_interruptible(&vcpu->arch.local_int.wq);
+	spin_unlock_bh(&vcpu->arch.local_int.lock);
+}
+
+
+void kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu)
+{
+	struct local_interrupt *li = &vcpu->arch.local_int;
+	struct float_interrupt *fi = vcpu->arch.local_int.float_int;
+	struct interrupt_info  *n, *inti = NULL;
+	int deliver;
+
+	__reset_intercept_indicators(vcpu);
+	if (atomic_read(&li->active)) {
+		do {
+			deliver = 0;
+			spin_lock_bh(&li->lock);
+			list_for_each_entry_safe(inti, n, &li->list, list) {
+				if (__interrupt_is_deliverable(vcpu, inti)) {
+					list_del(&inti->list);
+					deliver = 1;
+					break;
+				}
+				__set_intercept_indicator(vcpu, inti);
+			}
+			if (list_empty(&li->list))
+				atomic_set(&li->active, 0);
+			spin_unlock_bh(&li->lock);
+			if (deliver) {
+				__do_deliver_interrupt(vcpu, inti);
+				kfree(inti);
+			}
+		} while (deliver);
+	}
+
+	if ((vcpu->arch.sie_block->ckc <
+		get_clock() + vcpu->arch.sie_block->epoch))
+		__try_deliver_ckc_interrupt(vcpu);
+
+	if (atomic_read(&fi->active)) {
+		do {
+			deliver = 0;
+			spin_lock_bh(&fi->lock);
+			list_for_each_entry_safe(inti, n, &fi->list, list) {
+				if (__interrupt_is_deliverable(vcpu, inti)) {
+					list_del(&inti->list);
+					deliver = 1;
+					break;
+				}
+				__set_intercept_indicator(vcpu, inti);
+			}
+			if (list_empty(&fi->list))
+				atomic_set(&fi->active, 0);
+			spin_unlock_bh(&fi->lock);
+			if (deliver) {
+				__do_deliver_interrupt(vcpu, inti);
+				kfree(inti);
+			}
+		} while (deliver);
+	}
+}
+
+int kvm_s390_inject_program_int(struct kvm_vcpu *vcpu, u16 code)
+{
+	struct local_interrupt *li = &vcpu->arch.local_int;
+	struct interrupt_info *inti;
+
+	inti = kzalloc(sizeof(*inti), GFP_KERNEL);
+	if (!inti)
+		return -ENOMEM;
+
+	inti->type = KVM_S390_PROGRAM_INT;;
+	inti->pgm.code = code;
+
+	VCPU_EVENT(vcpu, 3, "inject: program check %d (from kernel)", code);
+	spin_lock_bh(&li->lock);
+	list_add(&inti->list, &li->list);
+	atomic_set(&li->active, 1);
+	BUG_ON(waitqueue_active(&li->wq));
+	spin_unlock_bh(&li->lock);
+	return 0;
+}
+
+int kvm_s390_inject_vm(struct kvm *kvm,
+		       struct kvm_s390_interrupt *s390int)
+{
+	struct local_interrupt *li;
+	struct float_interrupt *fi;
+	struct interrupt_info *inti;
+	int sigcpu;
+
+	inti = kzalloc(sizeof(*inti), GFP_KERNEL);
+	if (!inti)
+		return -ENOMEM;
+
+	switch (s390int->type) {
+	case KVM_S390_INT_VIRTIO:
+		VM_EVENT(kvm, 5, "inject: virtio parm:%x,parm64:%lx",
+			 s390int->parm, s390int->parm64);
+		inti->type = s390int->type;
+		inti->ext.ext_params = s390int->parm;
+		inti->ext.ext_params2 = s390int->parm64;
+		break;
+	case KVM_S390_INT_SERVICE:
+		VM_EVENT(kvm, 5, "inject: sclp parm:%x", s390int->parm);
+		inti->type = s390int->type;
+		inti->ext.ext_params = s390int->parm;
+		break;
+	case KVM_S390_PROGRAM_INT:
+	case KVM_S390_SIGP_STOP:
+	case KVM_S390_INT_EMERGENCY:
+	default:
+		kfree(inti);
+		return -EINVAL;
+	}
+
+	mutex_lock(&kvm->lock);
+	fi = &kvm->arch.float_int;
+	spin_lock_bh(&fi->lock);
+	list_add_tail(&inti->list, &fi->list);
+	atomic_set(&fi->active, 1);
+	sigcpu = find_first_bit(fi->idle_mask, KVM_MAX_VCPUS);
+	if (sigcpu == KVM_MAX_VCPUS) {
+		do {
+			sigcpu = fi->next_rr_cpu++;
+			if (sigcpu == KVM_MAX_VCPUS)
+				sigcpu = fi->next_rr_cpu = 0;
+		} while (fi->local_int[sigcpu] == NULL);
+	}
+	li = fi->local_int[sigcpu];
+	spin_lock_bh(&li->lock);
+	atomic_set_mask(CPUSTAT_EXT_INT, li->cpuflags);
+	if (waitqueue_active(&li->wq))
+		wake_up_interruptible(&li->wq);
+	spin_unlock_bh(&li->lock);
+	spin_unlock_bh(&fi->lock);
+	mutex_unlock(&kvm->lock);
+	return 0;
+}
+
+int kvm_s390_inject_vcpu(struct kvm_vcpu *vcpu,
+			 struct kvm_s390_interrupt *s390int)
+{
+	struct local_interrupt *li;
+	struct interrupt_info *inti;
+
+	inti = kzalloc(sizeof(*inti), GFP_KERNEL);
+	if (!inti)
+		return -ENOMEM;
+
+	switch (s390int->type) {
+	case KVM_S390_PROGRAM_INT:
+		if (s390int->parm & 0xffff0000) {
+			kfree(inti);
+			return -EINVAL;
+		}
+		inti->type = s390int->type;
+		inti->pgm.code = s390int->parm;
+		VCPU_EVENT(vcpu, 3, "inject: program check %d (from user)",
+			   s390int->parm);
+		break;
+	case KVM_S390_SIGP_STOP:
+	case KVM_S390_RESTART:
+	case KVM_S390_SIGP_SET_PREFIX:
+	case KVM_S390_INT_EMERGENCY:
+		VCPU_EVENT(vcpu, 3, "inject: type %x", s390int->type);
+		inti->type = s390int->type;
+		break;
+	case KVM_S390_INT_VIRTIO:
+	case KVM_S390_INT_SERVICE:
+	default:
+		kfree(inti);
+		return -EINVAL;
+	}
+
+	mutex_lock(&vcpu->kvm->lock);
+	li = &vcpu->arch.local_int;
+	spin_lock_bh(&li->lock);
+	if (inti->type == KVM_S390_PROGRAM_INT)
+		list_add(&inti->list, &li->list);
+	else
+		list_add_tail(&inti->list, &li->list);
+	atomic_set(&li->active, 1);
+	if (inti->type == KVM_S390_SIGP_STOP)
+		li->action_bits |= ACTION_STOP_ON_STOP;
+	atomic_set_mask(CPUSTAT_EXT_INT, li->cpuflags);
+	if (waitqueue_active(&li->wq))
+		wake_up_interruptible(&vcpu->arch.local_int.wq);
+	spin_unlock_bh(&li->lock);
+	mutex_unlock(&vcpu->kvm->lock);
+	return 0;
+}
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index a906499..5e3473c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -20,6 +20,7 @@
 #include <linux/kvm_host.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/timer.h>
 #include <asm/lowcore.h>
 #include <asm/pgtable.h>
 
@@ -34,6 +35,19 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "exit_stop_request", VCPU_STAT(exit_stop_request) },
 	{ "exit_external_request", VCPU_STAT(exit_external_request) },
 	{ "exit_external_interrupt", VCPU_STAT(exit_external_interrupt) },
+	{ "exit_instruction", VCPU_STAT(exit_instruction) },
+	{ "exit_program_interruption", VCPU_STAT(exit_program_interruption) },
+	{ "exit_instr_and_program_int", VCPU_STAT(exit_instr_and_program) },
+	{ "instruction_lctg", VCPU_STAT(instruction_lctg) },
+	{ "instruction_lctl", VCPU_STAT(instruction_lctl) },
+	{ "deliver_emergency_signal", VCPU_STAT(deliver_emergency_signal) },
+	{ "deliver_service_signal", VCPU_STAT(deliver_service_signal) },
+	{ "deliver_virtio_interrupt", VCPU_STAT(deliver_virtio_interrupt) },
+	{ "deliver_stop_signal", VCPU_STAT(deliver_stop_signal) },
+	{ "deliver_prefix_signal", VCPU_STAT(deliver_prefix_signal) },
+	{ "deliver_restart_signal", VCPU_STAT(deliver_restart_signal) },
+	{ "deliver_program_interruption", VCPU_STAT(deliver_program_int) },
+	{ "exit_wait_state", VCPU_STAT(exit_wait_state) },
 	{ NULL }
 };
 
@@ -106,6 +120,15 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	int r;
 
 	switch (ioctl) {
+	case KVM_S390_INTERRUPT: {
+		struct kvm_s390_interrupt s390int;
+
+		r = -EFAULT;
+		if (copy_from_user(&s390int, argp, sizeof(s390int)))
+			break;
+		r = kvm_s390_inject_vm(kvm, &s390int);
+		break;
+	}
 	default:
 		r = -EINVAL;
 	}
@@ -138,6 +161,9 @@ struct kvm *kvm_arch_create_vm(void)
 	if (!kvm->arch.dbf)
 		goto out_nodbf;
 
+	spin_lock_init(&kvm->arch.float_int.lock);
+	INIT_LIST_HEAD(&kvm->arch.float_int.list);
+
 	debug_register_view(kvm->arch.dbf, &debug_sprintf_view);
 	VM_EVENT(kvm, 3, "%s", "vm created");
 
@@ -218,7 +244,8 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 	vcpu->arch.sie_block->gmsor = 0x000000000000;
 	vcpu->arch.sie_block->ecb   = 2;
 	vcpu->arch.sie_block->eca   = 0xC1002001U;
-
+	setup_timer(&vcpu->arch.ckc_timer, kvm_s390_idle_wakeup,
+		 (unsigned long) vcpu);
 	return 0;
 }
 
@@ -243,6 +270,14 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 	vcpu->arch.sie_block->scaoh = (__u32)(((__u64)kvm->arch.sca) >> 32);
 	vcpu->arch.sie_block->scaol = (__u32)(__u64)kvm->arch.sca;
 
+	spin_lock_init(&vcpu->arch.local_int.lock);
+	INIT_LIST_HEAD(&vcpu->arch.local_int.list);
+	vcpu->arch.local_int.float_int = &kvm->arch.float_int;
+	spin_lock_bh(&kvm->arch.float_int.lock);
+	kvm->arch.float_int.local_int[id] = &vcpu->arch.local_int;
+	init_waitqueue_head(&vcpu->arch.local_int.wq);
+	spin_unlock_bh(&kvm->arch.float_int.lock);
+
 	rc = kvm_vcpu_init(vcpu, kvm, id);
 	if (rc)
 		goto out_free_cpu;
@@ -395,6 +430,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	atomic_set_mask(CPUSTAT_RUNNING, &vcpu->arch.sie_block->cpuflags);
 
+	BUG_ON(vcpu->kvm->arch.float_int.local_int[vcpu->vcpu_id] == NULL);
+
 	switch (kvm_run->exit_reason) {
 	case KVM_EXIT_S390_SIEIC:
 		vcpu->arch.sie_block->gpsw.mask = kvm_run->s390_sieic.mask;
@@ -410,8 +447,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	might_sleep();
 
 	do {
+		kvm_s390_deliver_pending_interrupts(vcpu);
 		__vcpu_run(vcpu);
-
 		rc = kvm_handle_sie_intercept(vcpu);
 	} while (!signal_pending(current) && !rc);
 
@@ -538,6 +575,13 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	void __user *argp = (void __user *)arg;
 
 	switch (ioctl) {
+	case KVM_S390_INTERRUPT: {
+		struct kvm_s390_interrupt s390int;
+
+		if (copy_from_user(&s390int, argp, sizeof(s390int)))
+			return -EFAULT;
+		return kvm_s390_inject_vcpu(vcpu, &s390int);
+	}
 	case KVM_S390_STORE_STATUS:
 		return kvm_s390_vcpu_store_status(vcpu, arg);
 	case KVM_S390_SET_INITIAL_PSW: {
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 5b82527..8df745b 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -14,6 +14,7 @@
 #ifndef ARCH_S390_KVM_S390_H
 #define ARCH_S390_KVM_S390_H
 
+#include <linux/kvm.h>
 #include <linux/kvm_host.h>
 
 typedef int (*intercept_handler_t)(struct kvm_vcpu *vcpu);
@@ -33,4 +34,18 @@ do { \
 	  d_vcpu->arch.sie_block->gpsw.mask, d_vcpu->arch.sie_block->gpsw.addr,\
 	  d_args); \
 } while (0)
+
+static inline int __cpu_is_stopped(struct kvm_vcpu *vcpu)
+{
+	return atomic_read(&vcpu->arch.sie_block->cpuflags) & CPUSTAT_STOP_INT;
+}
+
+int kvm_s390_handle_wait(struct kvm_vcpu *vcpu);
+void kvm_s390_idle_wakeup(unsigned long data);
+void kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu);
+int kvm_s390_inject_vm(struct kvm *kvm,
+		struct kvm_s390_interrupt *s390int);
+int kvm_s390_inject_vcpu(struct kvm_vcpu *vcpu,
+		struct kvm_s390_interrupt *s390int);
+int kvm_s390_inject_program_int(struct kvm_vcpu *vcpu, u16 code);
 #endif
diff --git a/include/asm-s390/kvm_host.h b/include/asm-s390/kvm_host.h
index 8965b38..4fe1930 100644
--- a/include/asm-s390/kvm_host.h
+++ b/include/asm-s390/kvm_host.h
@@ -70,6 +70,7 @@ struct sie_block {
 	__u64	ckc;			/* 0x0030 */
 	__u64	epoch;			/* 0x0038 */
 	__u8	reserved40[4];		/* 0x0040 */
+#define LCTL_CR0	0x8000
 	__u16   lctl;			/* 0x0044 */
 	__s16	icpua;			/* 0x0046 */
 	__u32	ictl;			/* 0x0048 */
@@ -105,8 +106,79 @@ struct kvm_vcpu_stat {
 	u32 exit_external_interrupt;
 	u32 exit_stop_request;
 	u32 exit_validity;
+	u32 exit_instruction;
+	u32 instruction_lctl;
+	u32 instruction_lctg;
+	u32 exit_program_interruption;
+	u32 exit_instr_and_program;
+	u32 deliver_emergency_signal;
+	u32 deliver_service_signal;
+	u32 deliver_virtio_interrupt;
+	u32 deliver_stop_signal;
+	u32 deliver_prefix_signal;
+	u32 deliver_restart_signal;
+	u32 deliver_program_int;
+	u32 exit_wait_state;
 };
 
+struct io_info {
+	__u16        subchannel_id;            /* 0x0b8 */
+	__u16        subchannel_nr;            /* 0x0ba */
+	__u32        io_int_parm;              /* 0x0bc */
+	__u32        io_int_word;              /* 0x0c0 */
+};
+
+struct ext_info {
+	__u32 ext_params;
+	__u64 ext_params2;
+};
+
+#define PGM_OPERATION            0x01
+#define PGM_PRIVILEGED_OPERATION 0x02
+#define PGM_EXECUTE              0x03
+#define PGM_PROTECTION           0x04
+#define PGM_ADDRESSING           0x05
+#define PGM_SPECIFICATION        0x06
+#define PGM_DATA                 0x07
+
+struct pgm_info {
+	__u16 code;
+};
+
+struct prefix_info {
+	__u32 address;
+};
+
+struct interrupt_info {
+	struct list_head list;
+	u64	type;
+	union {
+		struct io_info io;
+		struct ext_info ext;
+		struct pgm_info pgm;
+		struct prefix_info prefix;
+	};
+};
+
+struct local_interrupt {
+	spinlock_t lock;
+	struct list_head list;
+	atomic_t active;
+	struct float_interrupt *float_int;
+	int timer_due; /* event indicator for waitqueue below */
+	wait_queue_head_t wq;
+};
+
+struct float_interrupt {
+	spinlock_t lock;
+	struct list_head list;
+	atomic_t active;
+	int next_rr_cpu;
+	unsigned long idle_mask [(64 + sizeof(long) - 1) / sizeof(long)];
+	struct local_interrupt *local_int[64];
+};
+
+
 struct kvm_vcpu_arch {
 	struct sie_block *sie_block;
 	unsigned long	  guest_gprs[16];
@@ -114,6 +186,8 @@ struct kvm_vcpu_arch {
 	unsigned int      host_acrs[NUM_ACRS];
 	s390_fp_regs      guest_fpregs;
 	unsigned int      guest_acrs[NUM_ACRS];
+	struct local_interrupt local_int;
+	struct timer_list ckc_timer;
 };
 
 struct kvm_vm_stat {
@@ -125,6 +199,7 @@ struct kvm_arch{
 	unsigned long guest_memsize;
 	struct sca_block *sca;
 	debug_info_t *dbf;
+	struct float_interrupt float_int;
 };
 
 extern int sie64a(struct sie_block *, __u64 *);
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index f2acd6b..b0dea38 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -219,6 +219,21 @@ struct kvm_s390_psw {
 	__u64 addr;
 };
 
+/* valid values for type in kvm_s390_interrupt */
+#define KVM_S390_SIGP_STOP		0xfffe0000u
+#define KVM_S390_PROGRAM_INT		0xfffe0001u
+#define KVM_S390_SIGP_SET_PREFIX	0xfffe0002u
+#define KVM_S390_RESTART		0xfffe0003u
+#define KVM_S390_INT_VIRTIO		0xffff1237u /*FIXME arch number */
+#define KVM_S390_INT_SERVICE		0xffff2401u
+#define KVM_S390_INT_EMERGENCY		0xffff1201u
+
+struct kvm_s390_interrupt {
+	__u32 type;
+	__u32 parm;
+	__u64 parm64;
+};
+
 #define KVMIO 0xAE
 
 /*
@@ -307,6 +322,8 @@ struct kvm_s390_psw {
 #define KVM_TPR_ACCESS_REPORTING  _IOWR(KVMIO,  0x92, struct kvm_tpr_access_ctl)
 /* Available with KVM_CAP_VAPIC */
 #define KVM_SET_VAPIC_ADDR        _IOW(KVMIO,  0x93, struct kvm_vapic_addr)
+/* valid for virtual machine (for floating interrupt)_and_ vcpu */
+#define KVM_S390_INTERRUPT        _IOW(KVMIO,  0x94, struct kvm_s390_interrupt)
 /* store status for s390 */
 #define KVM_S390_STORE_STATUS_NOADDR    (-1ul)
 #define KVM_S390_STORE_STATUS_PREFIXED  (-2ul)
-- 
1.5.5

