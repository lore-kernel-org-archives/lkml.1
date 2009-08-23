Return-Path: <linux-kernel-owner+w=401wt.eu-S933862AbZHWMGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862AbZHWMGM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933519AbZHWMGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:06:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933522AbZHWL4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:47 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/46] KVM: Trace mmio
Date: Sun, 23 Aug 2009 14:56:02 +0300
Message-Id: <1251028605-31977-4-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c         |   11 ++++++++++-
 include/trace/events/kvm.h |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index af40e23..d32e3c6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -37,6 +37,8 @@
 #include <linux/iommu.h>
 #include <linux/intel-iommu.h>
 #include <linux/cpufreq.h>
+#include <trace/events/kvm.h>
+#undef TRACE_INCLUDE_FILE
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
@@ -2425,6 +2427,8 @@ static int emulator_read_emulated(unsigned long addr,
 
 	if (vcpu->mmio_read_completed) {
 		memcpy(val, vcpu->mmio_data, bytes);
+		trace_kvm_mmio(KVM_TRACE_MMIO_READ, bytes,
+			       vcpu->mmio_phys_addr, *(u64 *)val);
 		vcpu->mmio_read_completed = 0;
 		return X86EMUL_CONTINUE;
 	}
@@ -2445,8 +2449,12 @@ mmio:
 	/*
 	 * Is this MMIO handled locally?
 	 */
-	if (!vcpu_mmio_read(vcpu, gpa, bytes, val))
+	if (!vcpu_mmio_read(vcpu, gpa, bytes, val)) {
+		trace_kvm_mmio(KVM_TRACE_MMIO_READ, bytes, gpa, *(u64 *)val);
 		return X86EMUL_CONTINUE;
+	}
+
+	trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, bytes, gpa, 0);
 
 	vcpu->mmio_needed = 1;
 	vcpu->mmio_phys_addr = gpa;
@@ -2490,6 +2498,7 @@ static int emulator_write_emulated_onepage(unsigned long addr,
 		return X86EMUL_CONTINUE;
 
 mmio:
+	trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, bytes, gpa, *(u64 *)val);
 	/*
 	 * Is this MMIO handled locally?
 	 */
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 035232d..77022af 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -56,6 +56,39 @@ TRACE_EVENT(kvm_ack_irq,
 
 
 #endif /* defined(__KVM_HAVE_IOAPIC) */
+
+#define KVM_TRACE_MMIO_READ_UNSATISFIED 0
+#define KVM_TRACE_MMIO_READ 1
+#define KVM_TRACE_MMIO_WRITE 2
+
+#define kvm_trace_symbol_mmio \
+	{ KVM_TRACE_MMIO_READ_UNSATISFIED, "unsatisfied-read" }, \
+	{ KVM_TRACE_MMIO_READ, "read" }, \
+	{ KVM_TRACE_MMIO_WRITE, "write" }
+
+TRACE_EVENT(kvm_mmio,
+	TP_PROTO(int type, int len, u64 gpa, u64 val),
+	TP_ARGS(type, len, gpa, val),
+
+	TP_STRUCT__entry(
+		__field(	u32,	type		)
+		__field(	u32,	len		)
+		__field(	u64,	gpa		)
+		__field(	u64,	val		)
+	),
+
+	TP_fast_assign(
+		__entry->type		= type;
+		__entry->len		= len;
+		__entry->gpa		= gpa;
+		__entry->val		= val;
+	),
+
+	TP_printk("mmio %s len %u gpa 0x%llx val 0x%llx",
+		  __print_symbolic(__entry->type, kvm_trace_symbol_mmio),
+		  __entry->len, __entry->gpa, __entry->val)
+);
+
 #endif /* _TRACE_KVM_MAIN_H */
 
 /* This part must be outside protection */
-- 
1.6.4.1

