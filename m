Return-Path: <linux-kernel-owner+w=401wt.eu-S1765114AbYDQJOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765114AbYDQJOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761778AbYDQJLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:00 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58975
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397AbYDQJKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:10:55 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 09/45] KVM: s390: intercepts for privileged instructions
Date: Thu, 17 Apr 2008 12:10:14 +0300
Message-Id: <1208423450-29415-10-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

From: Christian Borntraeger <borntraeger@de.ibm.com>

This patch introduces in-kernel handling of some intercepts for privileged
instructions:

handle_set_prefix()        sets the prefix register of the local cpu
handle_store_prefix()      stores the content of the prefix register to memory
handle_store_cpu_address() stores the cpu number of the current cpu to memory
handle_skey()              just decrements the instruction address and retries
handle_stsch()             delivers condition code 3 "operation not supported"
handle_chsc()              same here
handle_stfl()              stores the facility list which contains the
                           capabilities of the cpu
handle_stidp()             stores cpu type/model/revision and such
handle_stsi()              stores information about the system topology

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/s390/kvm/Makefile      |    2 +-
 arch/s390/kvm/intercept.c   |    1 +
 arch/s390/kvm/kvm-s390.c    |   11 ++
 arch/s390/kvm/kvm-s390.h    |    3 +
 arch/s390/kvm/priv.c        |  323 +++++++++++++++++++++++++++++++++++++++++++
 include/asm-s390/kvm_host.h |   13 ++
 6 files changed, 352 insertions(+), 1 deletions(-)
 create mode 100644 arch/s390/kvm/priv.c

diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index 7275a1a..82dde1e 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -10,5 +10,5 @@ common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o)
 
 EXTRA_CFLAGS += -Ivirt/kvm -Iarch/s390/kvm
 
-kvm-objs := $(common-objs) kvm-s390.o sie64a.o intercept.o interrupt.o
+kvm-objs := $(common-objs) kvm-s390.o sie64a.o intercept.o interrupt.o priv.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 7f7347b..7a20d63 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -95,6 +95,7 @@ static int handle_lctl(struct kvm_vcpu *vcpu)
 }
 
 static intercept_handler_t instruction_handlers[256] = {
+	[0xb2] = kvm_s390_handle_priv,
 	[0xb7] = handle_lctl,
 	[0xeb] = handle_lctg,
 };
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 5e3473c..5a17176 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -48,6 +48,15 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "deliver_restart_signal", VCPU_STAT(deliver_restart_signal) },
 	{ "deliver_program_interruption", VCPU_STAT(deliver_program_int) },
 	{ "exit_wait_state", VCPU_STAT(exit_wait_state) },
+	{ "instruction_stidp", VCPU_STAT(instruction_stidp) },
+	{ "instruction_spx", VCPU_STAT(instruction_spx) },
+	{ "instruction_stpx", VCPU_STAT(instruction_stpx) },
+	{ "instruction_stap", VCPU_STAT(instruction_stap) },
+	{ "instruction_storage_key", VCPU_STAT(instruction_storage_key) },
+	{ "instruction_stsch", VCPU_STAT(instruction_stsch) },
+	{ "instruction_chsc", VCPU_STAT(instruction_chsc) },
+	{ "instruction_stsi", VCPU_STAT(instruction_stsi) },
+	{ "instruction_stfl", VCPU_STAT(instruction_stfl) },
 	{ NULL }
 };
 
@@ -246,6 +255,8 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 	vcpu->arch.sie_block->eca   = 0xC1002001U;
 	setup_timer(&vcpu->arch.ckc_timer, kvm_s390_idle_wakeup,
 		 (unsigned long) vcpu);
+	get_cpu_id(&vcpu->arch.cpu_id);
+	vcpu->arch.cpu_id.version = 0xfe;
 	return 0;
 }
 
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 8df745b..50f96b3 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -48,4 +48,7 @@ int kvm_s390_inject_vm(struct kvm *kvm,
 int kvm_s390_inject_vcpu(struct kvm_vcpu *vcpu,
 		struct kvm_s390_interrupt *s390int);
 int kvm_s390_inject_program_int(struct kvm_vcpu *vcpu, u16 code);
+
+/* implemented in priv.c */
+int kvm_s390_handle_priv(struct kvm_vcpu *vcpu);
 #endif
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
new file mode 100644
index 0000000..c97e904
--- /dev/null
+++ b/arch/s390/kvm/priv.c
@@ -0,0 +1,323 @@
+/*
+ * priv.c - handling privileged instructions
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
+#include <linux/errno.h>
+#include <asm/current.h>
+#include <asm/debug.h>
+#include <asm/ebcdic.h>
+#include <asm/sysinfo.h>
+#include "gaccess.h"
+#include "kvm-s390.h"
+
+static int handle_set_prefix(struct kvm_vcpu *vcpu)
+{
+	int base2 = vcpu->arch.sie_block->ipb >> 28;
+	int disp2 = ((vcpu->arch.sie_block->ipb & 0x0fff0000) >> 16);
+	u64 operand2;
+	u32 address = 0;
+	u8 tmp;
+
+	vcpu->stat.instruction_spx++;
+
+	operand2 = disp2;
+	if (base2)
+		operand2 += vcpu->arch.guest_gprs[base2];
+
+	/* must be word boundary */
+	if (operand2 & 3) {
+		kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
+		goto out;
+	}
+
+	/* get the value */
+	if (get_guest_u32(vcpu, operand2, &address)) {
+		kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
+		goto out;
+	}
+
+	address = address & 0x7fffe000u;
+
+	/* make sure that the new value is valid memory */
+	if (copy_from_guest_absolute(vcpu, &tmp, address, 1) ||
+	   (copy_from_guest_absolute(vcpu, &tmp, address + PAGE_SIZE, 1))) {
+		kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
+		goto out;
+	}
+
+	vcpu->arch.sie_block->prefix = address;
+	vcpu->arch.sie_block->ihcpu = 0xffff;
+
+	VCPU_EVENT(vcpu, 5, "setting prefix to %x", address);
+out:
+	return 0;
+}
+
+static int handle_store_prefix(struct kvm_vcpu *vcpu)
+{
+	int base2 = vcpu->arch.sie_block->ipb >> 28;
+	int disp2 = ((vcpu->arch.sie_block->ipb & 0x0fff0000) >> 16);
+	u64 operand2;
+	u32 address;
+
+	vcpu->stat.instruction_stpx++;
+	operand2 = disp2;
+	if (base2)
+		operand2 += vcpu->arch.guest_gprs[base2];
+
+	/* must be word boundary */
+	if (operand2 & 3) {
+		kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
+		goto out;
+	}
+
+	address = vcpu->arch.sie_block->prefix;
+	address = address & 0x7fffe000u;
+
+	/* get the value */
+	if (put_guest_u32(vcpu, operand2, address)) {
+		kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
+		goto out;
+	}
+
+	VCPU_EVENT(vcpu, 5, "storing prefix to %x", address);
+out:
+	return 0;
+}
+
+static int handle_store_cpu_address(struct kvm_vcpu *vcpu)
+{
+	int base2 = vcpu->arch.sie_block->ipb >> 28;
+	int disp2 = ((vcpu->arch.sie_block->ipb & 0x0fff0000) >> 16);
+	u64 useraddr;
+	int rc;
+
+	vcpu->stat.instruction_stap++;
+	useraddr = disp2;
+	if (base2)
+		useraddr += vcpu->arch.guest_gprs[base2];
+
+	if (useraddr & 1) {
+		kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
+		goto out;
+	}
+
+	rc = put_guest_u16(vcpu, useraddr, vcpu->vcpu_id);
+	if (rc == -EFAULT) {
+		kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
+		goto out;
+	}
+
+	VCPU_EVENT(vcpu, 5, "storing cpu address to %lx", useraddr);
+out:
+	return 0;
+}
+
+static int handle_skey(struct kvm_vcpu *vcpu)
+{
+	vcpu->stat.instruction_storage_key++;
+	vcpu->arch.sie_block->gpsw.addr -= 4;
+	VCPU_EVENT(vcpu, 4, "%s", "retrying storage key operation");
+	return 0;
+}
+
+static int handle_stsch(struct kvm_vcpu *vcpu)
+{
+	vcpu->stat.instruction_stsch++;
+	VCPU_EVENT(vcpu, 4, "%s", "store subchannel - CC3");
+	/* condition code 3 */
+	vcpu->arch.sie_block->gpsw.mask &= ~(3ul << 44);
+	vcpu->arch.sie_block->gpsw.mask |= (3 & 3ul) << 44;
+	return 0;
+}
+
+static int handle_chsc(struct kvm_vcpu *vcpu)
+{
+	vcpu->stat.instruction_chsc++;
+	VCPU_EVENT(vcpu, 4, "%s", "channel subsystem call - CC3");
+	/* condition code 3 */
+	vcpu->arch.sie_block->gpsw.mask &= ~(3ul << 44);
+	vcpu->arch.sie_block->gpsw.mask |= (3 & 3ul) << 44;
+	return 0;
+}
+
+static unsigned int stfl(void)
+{
+	asm volatile(
+		"	.insn	s,0xb2b10000,0(0)\n" /* stfl */
+		"0:\n"
+		EX_TABLE(0b, 0b));
+	return S390_lowcore.stfl_fac_list;
+}
+
+static int handle_stfl(struct kvm_vcpu *vcpu)
+{
+	unsigned int facility_list = stfl();
+	int rc;
+
+	vcpu->stat.instruction_stfl++;
+	facility_list &= ~(1UL<<24); /* no stfle */
+
+	rc = copy_to_guest(vcpu, offsetof(struct _lowcore, stfl_fac_list),
+			   &facility_list, sizeof(facility_list));
+	if (rc == -EFAULT)
+		kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
+	else
+		VCPU_EVENT(vcpu, 5, "store facility list value %x",
+			   facility_list);
+	return 0;
+}
+
+static int handle_stidp(struct kvm_vcpu *vcpu)
+{
+	int base2 = vcpu->arch.sie_block->ipb >> 28;
+	int disp2 = ((vcpu->arch.sie_block->ipb & 0x0fff0000) >> 16);
+	u64 operand2;
+	int rc;
+
+	vcpu->stat.instruction_stidp++;
+	operand2 = disp2;
+	if (base2)
+		operand2 += vcpu->arch.guest_gprs[base2];
+
+	if (operand2 & 7) {
+		kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
+		goto out;
+	}
+
+	rc = put_guest_u64(vcpu, operand2, vcpu->arch.stidp_data);
+	if (rc == -EFAULT) {
+		kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
+		goto out;
+	}
+
+	VCPU_EVENT(vcpu, 5, "%s", "store cpu id");
+out:
+	return 0;
+}
+
+static void handle_stsi_3_2_2(struct kvm_vcpu *vcpu, struct sysinfo_3_2_2 *mem)
+{
+	struct float_interrupt *fi = &vcpu->kvm->arch.float_int;
+	int cpus = 0;
+	int n;
+
+	spin_lock_bh(&fi->lock);
+	for (n = 0; n < KVM_MAX_VCPUS; n++)
+		if (fi->local_int[n])
+			cpus++;
+	spin_unlock_bh(&fi->lock);
+
+	/* deal with other level 3 hypervisors */
+	if (stsi(mem, 3, 2, 2) == -ENOSYS)
+		mem->count = 0;
+	if (mem->count < 8)
+		mem->count++;
+	for (n = mem->count - 1; n > 0 ; n--)
+		memcpy(&mem->vm[n], &mem->vm[n - 1], sizeof(mem->vm[0]));
+
+	mem->vm[0].cpus_total = cpus;
+	mem->vm[0].cpus_configured = cpus;
+	mem->vm[0].cpus_standby = 0;
+	mem->vm[0].cpus_reserved = 0;
+	mem->vm[0].caf = 1000;
+	memcpy(mem->vm[0].name, "KVMguest", 8);
+	ASCEBC(mem->vm[0].name, 8);
+	memcpy(mem->vm[0].cpi, "KVM/Linux       ", 16);
+	ASCEBC(mem->vm[0].cpi, 16);
+}
+
+static int handle_stsi(struct kvm_vcpu *vcpu)
+{
+	int fc = (vcpu->arch.guest_gprs[0] & 0xf0000000) >> 28;
+	int sel1 = vcpu->arch.guest_gprs[0] & 0xff;
+	int sel2 = vcpu->arch.guest_gprs[1] & 0xffff;
+	int base2 = vcpu->arch.sie_block->ipb >> 28;
+	int disp2 = ((vcpu->arch.sie_block->ipb & 0x0fff0000) >> 16);
+	u64 operand2;
+	unsigned long mem;
+
+	vcpu->stat.instruction_stsi++;
+	VCPU_EVENT(vcpu, 4, "stsi: fc: %x sel1: %x sel2: %x", fc, sel1, sel2);
+
+	operand2 = disp2;
+	if (base2)
+		operand2 += vcpu->arch.guest_gprs[base2];
+
+	if (operand2 & 0xfff && fc > 0)
+		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
+
+	switch (fc) {
+	case 0:
+		vcpu->arch.guest_gprs[0] = 3 << 28;
+		vcpu->arch.sie_block->gpsw.mask &= ~(3ul << 44);
+		return 0;
+	case 1: /* same handling for 1 and 2 */
+	case 2:
+		mem = get_zeroed_page(GFP_KERNEL);
+		if (!mem)
+			goto out_fail;
+		if (stsi((void *) mem, fc, sel1, sel2) == -ENOSYS)
+			goto out_mem;
+		break;
+	case 3:
+		if (sel1 != 2 || sel2 != 2)
+			goto out_fail;
+		mem = get_zeroed_page(GFP_KERNEL);
+		if (!mem)
+			goto out_fail;
+		handle_stsi_3_2_2(vcpu, (void *) mem);
+		break;
+	default:
+		goto out_fail;
+	}
+
+	if (copy_to_guest_absolute(vcpu, operand2, (void *) mem, PAGE_SIZE)) {
+		kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
+		goto out_mem;
+	}
+	free_page(mem);
+	vcpu->arch.sie_block->gpsw.mask &= ~(3ul << 44);
+	vcpu->arch.guest_gprs[0] = 0;
+	return 0;
+out_mem:
+	free_page(mem);
+out_fail:
+	/* condition code 3 */
+	vcpu->arch.sie_block->gpsw.mask |= 3ul << 44;
+	return 0;
+}
+
+static intercept_handler_t priv_handlers[256] = {
+	[0x02] = handle_stidp,
+	[0x10] = handle_set_prefix,
+	[0x11] = handle_store_prefix,
+	[0x12] = handle_store_cpu_address,
+	[0x29] = handle_skey,
+	[0x2a] = handle_skey,
+	[0x2b] = handle_skey,
+	[0x34] = handle_stsch,
+	[0x5f] = handle_chsc,
+	[0x7d] = handle_stsi,
+	[0xb1] = handle_stfl,
+};
+
+int kvm_s390_handle_priv(struct kvm_vcpu *vcpu)
+{
+	intercept_handler_t handler;
+
+	handler = priv_handlers[vcpu->arch.sie_block->ipa & 0x00ff];
+	if (handler)
+		return handler(vcpu);
+	return -ENOTSUPP;
+}
diff --git a/include/asm-s390/kvm_host.h b/include/asm-s390/kvm_host.h
index 4fe1930..2eaf6fe 100644
--- a/include/asm-s390/kvm_host.h
+++ b/include/asm-s390/kvm_host.h
@@ -119,6 +119,15 @@ struct kvm_vcpu_stat {
 	u32 deliver_restart_signal;
 	u32 deliver_program_int;
 	u32 exit_wait_state;
+	u32 instruction_stidp;
+	u32 instruction_spx;
+	u32 instruction_stpx;
+	u32 instruction_stap;
+	u32 instruction_storage_key;
+	u32 instruction_stsch;
+	u32 instruction_chsc;
+	u32 instruction_stsi;
+	u32 instruction_stfl;
 };
 
 struct io_info {
@@ -188,6 +197,10 @@ struct kvm_vcpu_arch {
 	unsigned int      guest_acrs[NUM_ACRS];
 	struct local_interrupt local_int;
 	struct timer_list ckc_timer;
+	union  {
+		cpuid_t	  cpu_id;
+		u64	  stidp_data;
+	};
 };
 
 struct kvm_vm_stat {
-- 
1.5.5

