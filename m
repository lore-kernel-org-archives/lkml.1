Return-Path: <linux-kernel-owner+w=401wt.eu-S1764049AbYDQJNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764049AbYDQJNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760312AbYDQJK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:10:59 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58966
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103AbYDQJKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:10:55 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 07/45] KVM: s390: sie intercept handling
Date: Thu, 17 Apr 2008 12:10:12 +0300
Message-Id: <1208423450-29415-8-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

From: Christian Borntraeger <borntraeger@de.ibm.com>

This path introduces handling of sie intercepts in three flavors: Intercepts
are either handled completely in-kernel by kvm_handle_sie_intercept(),
or passed to userspace with corresponding data in struct kvm_run in case
kvm_handle_sie_intercept() returns -ENOTSUPP.
In case of partial execution in kernel with the need of userspace support,
kvm_handle_sie_intercept() may choose to set up struct kvm_run and return
-EREMOTE.

The trivial intercept reasons are handled in this patch:
handle_noop() just does nothing for intercepts that don't require our support
  at all
handle_stop() is called when a cpu enters stopped state, and it drops out to
  userland after updating our vcpu state
handle_validity() faults in the cpu lowcore if needed, or passes the request
  to userland

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/s390/kvm/Makefile      |    2 +-
 arch/s390/kvm/intercept.c   |   80 +++++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.c    |   46 ++++++++++++++++++++++++-
 arch/s390/kvm/kvm-s390.h    |    7 ++++
 include/asm-s390/kvm_host.h |    4 ++
 include/linux/kvm.h         |    9 +++++
 6 files changed, 146 insertions(+), 2 deletions(-)
 create mode 100644 arch/s390/kvm/intercept.c

diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index 0d8d113..27882b3 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -10,5 +10,5 @@ common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o)
 
 EXTRA_CFLAGS += -Ivirt/kvm -Iarch/s390/kvm
 
-kvm-objs := $(common-objs) kvm-s390.o sie64a.o
+kvm-objs := $(common-objs) kvm-s390.o sie64a.o intercept.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
new file mode 100644
index 0000000..e757230
--- /dev/null
+++ b/arch/s390/kvm/intercept.c
@@ -0,0 +1,80 @@
+/*
+ * intercept.c - in-kernel handling for sie intercepts
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
+#include <linux/kvm_host.h>
+#include <linux/errno.h>
+#include <linux/pagemap.h>
+
+#include <asm/kvm_host.h>
+
+#include "kvm-s390.h"
+
+static int handle_noop(struct kvm_vcpu *vcpu)
+{
+	switch (vcpu->arch.sie_block->icptcode) {
+	case 0x10:
+		vcpu->stat.exit_external_request++;
+		break;
+	case 0x14:
+		vcpu->stat.exit_external_interrupt++;
+		break;
+	default:
+		break; /* nothing */
+	}
+	return 0;
+}
+
+static int handle_stop(struct kvm_vcpu *vcpu)
+{
+	vcpu->stat.exit_stop_request++;
+	VCPU_EVENT(vcpu, 3, "%s", "cpu stopped");
+	atomic_clear_mask(CPUSTAT_RUNNING, &vcpu->arch.sie_block->cpuflags);
+	return -ENOTSUPP;
+}
+
+static int handle_validity(struct kvm_vcpu *vcpu)
+{
+	int viwhy = vcpu->arch.sie_block->ipb >> 16;
+	vcpu->stat.exit_validity++;
+	if (viwhy == 0x37) {
+		fault_in_pages_writeable((char __user *)
+					 vcpu->kvm->arch.guest_origin +
+					 vcpu->arch.sie_block->prefix,
+					 PAGE_SIZE);
+		return 0;
+	}
+	VCPU_EVENT(vcpu, 2, "unhandled validity intercept code %d",
+		   viwhy);
+	return -ENOTSUPP;
+}
+
+static const intercept_handler_t intercept_funcs[0x48 >> 2] = {
+	[0x00 >> 2] = handle_noop,
+	[0x10 >> 2] = handle_noop,
+	[0x14 >> 2] = handle_noop,
+	[0x20 >> 2] = handle_validity,
+	[0x28 >> 2] = handle_stop,
+};
+
+int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
+{
+	intercept_handler_t func;
+	u8 code = vcpu->arch.sie_block->icptcode;
+
+	if (code & 3 || code > 0x48)
+		return -ENOTSUPP;
+	func = intercept_funcs[code >> 2];
+	if (func)
+		return func(vcpu);
+	return -ENOTSUPP;
+}
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6e1e1d3..a906499 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -23,12 +23,17 @@
 #include <asm/lowcore.h>
 #include <asm/pgtable.h>
 
+#include "kvm-s390.h"
 #include "gaccess.h"
 
 #define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU
 
 struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "userspace_handled", VCPU_STAT(exit_userspace) },
+	{ "exit_validity", VCPU_STAT(exit_validity) },
+	{ "exit_stop_request", VCPU_STAT(exit_stop_request) },
+	{ "exit_external_request", VCPU_STAT(exit_external_request) },
+	{ "exit_external_interrupt", VCPU_STAT(exit_external_interrupt) },
 	{ NULL }
 };
 
@@ -380,6 +385,7 @@ static void __vcpu_run(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
+	int rc;
 	sigset_t sigsaved;
 
 	vcpu_load(vcpu);
@@ -389,7 +395,45 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	atomic_set_mask(CPUSTAT_RUNNING, &vcpu->arch.sie_block->cpuflags);
 
-	__vcpu_run(vcpu);
+	switch (kvm_run->exit_reason) {
+	case KVM_EXIT_S390_SIEIC:
+		vcpu->arch.sie_block->gpsw.mask = kvm_run->s390_sieic.mask;
+		vcpu->arch.sie_block->gpsw.addr = kvm_run->s390_sieic.addr;
+		break;
+	case KVM_EXIT_UNKNOWN:
+	case KVM_EXIT_S390_RESET:
+		break;
+	default:
+		BUG();
+	}
+
+	might_sleep();
+
+	do {
+		__vcpu_run(vcpu);
+
+		rc = kvm_handle_sie_intercept(vcpu);
+	} while (!signal_pending(current) && !rc);
+
+	if (signal_pending(current) && !rc)
+		rc = -EINTR;
+
+	if (rc == -ENOTSUPP) {
+		/* intercept cannot be handled in-kernel, prepare kvm-run */
+		kvm_run->exit_reason         = KVM_EXIT_S390_SIEIC;
+		kvm_run->s390_sieic.icptcode = vcpu->arch.sie_block->icptcode;
+		kvm_run->s390_sieic.mask     = vcpu->arch.sie_block->gpsw.mask;
+		kvm_run->s390_sieic.addr     = vcpu->arch.sie_block->gpsw.addr;
+		kvm_run->s390_sieic.ipa      = vcpu->arch.sie_block->ipa;
+		kvm_run->s390_sieic.ipb      = vcpu->arch.sie_block->ipb;
+		rc = 0;
+	}
+
+	if (rc == -EREMOTE) {
+		/* intercept was handled, but userspace support is needed
+		 * kvm_run has been prepared by the handler */
+		rc = 0;
+	}
 
 	if (vcpu->sigset_active)
 		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index ed64a22..5b82527 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -13,6 +13,13 @@
 
 #ifndef ARCH_S390_KVM_S390_H
 #define ARCH_S390_KVM_S390_H
+
+#include <linux/kvm_host.h>
+
+typedef int (*intercept_handler_t)(struct kvm_vcpu *vcpu);
+
+int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu);
+
 #define VM_EVENT(d_kvm, d_loglevel, d_string, d_args...)\
 do { \
 	debug_sprintf_event(d_kvm->arch.dbf, d_loglevel, d_string "\n", \
diff --git a/include/asm-s390/kvm_host.h b/include/asm-s390/kvm_host.h
index c9d6533..8965b38 100644
--- a/include/asm-s390/kvm_host.h
+++ b/include/asm-s390/kvm_host.h
@@ -101,6 +101,10 @@ struct sie_block {
 
 struct kvm_vcpu_stat {
 	u32 exit_userspace;
+	u32 exit_external_request;
+	u32 exit_external_interrupt;
+	u32 exit_stop_request;
+	u32 exit_validity;
 };
 
 struct kvm_vcpu_arch {
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 2367ff0..f2acd6b 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -74,6 +74,7 @@ struct kvm_irqchip {
 #define KVM_EXIT_INTR             10
 #define KVM_EXIT_SET_TPR          11
 #define KVM_EXIT_TPR_ACCESS       12
+#define KVM_EXIT_S390_SIEIC       13
 
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
@@ -138,6 +139,14 @@ struct kvm_run {
 			__u32 is_write;
 			__u32 pad;
 		} tpr_access;
+		/* KVM_EXIT_S390_SIEIC */
+		struct {
+			__u8 icptcode;
+			__u64 mask; /* psw upper half */
+			__u64 addr; /* psw lower half */
+			__u16 ipa;
+			__u32 ipb;
+		} s390_sieic;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
1.5.5

