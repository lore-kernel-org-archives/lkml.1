Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab0BPKiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:38:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932823Ab0BPKfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 28/38] KVM: Trace failed msr reads and writes
Date: Tue, 16 Feb 2010 12:35:26 +0200
Message-Id: <1266316536-28936-29-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Record failed msrs reads and writes, and the fact that they failed as well.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/svm.c   |   13 ++++++++-----
 arch/x86/kvm/trace.h |   17 +++++++++++------
 arch/x86/kvm/vmx.c   |    5 +++--
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 9596cc8..52f78dd 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2177,9 +2177,10 @@ static int rdmsr_interception(struct vcpu_svm *svm)
 	u32 ecx = svm->vcpu.arch.regs[VCPU_REGS_RCX];
 	u64 data;
 
-	if (svm_get_msr(&svm->vcpu, ecx, &data))
+	if (svm_get_msr(&svm->vcpu, ecx, &data)) {
+		trace_kvm_msr_read_ex(ecx);
 		kvm_inject_gp(&svm->vcpu, 0);
-	else {
+	} else {
 		trace_kvm_msr_read(ecx, data);
 
 		svm->vcpu.arch.regs[VCPU_REGS_RAX] = data & 0xffffffff;
@@ -2271,13 +2272,15 @@ static int wrmsr_interception(struct vcpu_svm *svm)
 	u64 data = (svm->vcpu.arch.regs[VCPU_REGS_RAX] & -1u)
 		| ((u64)(svm->vcpu.arch.regs[VCPU_REGS_RDX] & -1u) << 32);
 
-	trace_kvm_msr_write(ecx, data);
 
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
-	if (svm_set_msr(&svm->vcpu, ecx, data))
+	if (svm_set_msr(&svm->vcpu, ecx, data)) {
+		trace_kvm_msr_write_ex(ecx, data);
 		kvm_inject_gp(&svm->vcpu, 0);
-	else
+	} else {
+		trace_kvm_msr_write(ecx, data);
 		skip_emulated_instruction(&svm->vcpu);
+	}
 	return 1;
 }
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 45903a9..6ad30a2 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -246,28 +246,33 @@ TRACE_EVENT(kvm_page_fault,
  * Tracepoint for guest MSR access.
  */
 TRACE_EVENT(kvm_msr,
-	TP_PROTO(unsigned write, u32 ecx, u64 data),
-	TP_ARGS(write, ecx, data),
+	TP_PROTO(unsigned write, u32 ecx, u64 data, bool exception),
+	TP_ARGS(write, ecx, data, exception),
 
 	TP_STRUCT__entry(
 		__field(	unsigned,	write		)
 		__field(	u32,		ecx		)
 		__field(	u64,		data		)
+		__field(	u8,		exception	)
 	),
 
 	TP_fast_assign(
 		__entry->write		= write;
 		__entry->ecx		= ecx;
 		__entry->data		= data;
+		__entry->exception	= exception;
 	),
 
-	TP_printk("msr_%s %x = 0x%llx",
+	TP_printk("msr_%s %x = 0x%llx%s",
 		  __entry->write ? "write" : "read",
-		  __entry->ecx, __entry->data)
+		  __entry->ecx, __entry->data,
+		  __entry->exception ? " (#GP)" : "")
 );
 
-#define trace_kvm_msr_read(ecx, data)		trace_kvm_msr(0, ecx, data)
-#define trace_kvm_msr_write(ecx, data)		trace_kvm_msr(1, ecx, data)
+#define trace_kvm_msr_read(ecx, data)      trace_kvm_msr(0, ecx, data, false)
+#define trace_kvm_msr_write(ecx, data)     trace_kvm_msr(1, ecx, data, false)
+#define trace_kvm_msr_read_ex(ecx)         trace_kvm_msr(0, ecx, 0, true)
+#define trace_kvm_msr_write_ex(ecx, data)  trace_kvm_msr(1, ecx, data, true)
 
 /*
  * Tracepoint for guest CR access.
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 7a56879..334b016 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3158,6 +3158,7 @@ static int handle_rdmsr(struct kvm_vcpu *vcpu)
 	u64 data;
 
 	if (vmx_get_msr(vcpu, ecx, &data)) {
+		trace_kvm_msr_read_ex(ecx);
 		kvm_inject_gp(vcpu, 0);
 		return 1;
 	}
@@ -3177,13 +3178,13 @@ static int handle_wrmsr(struct kvm_vcpu *vcpu)
 	u64 data = (vcpu->arch.regs[VCPU_REGS_RAX] & -1u)
 		| ((u64)(vcpu->arch.regs[VCPU_REGS_RDX] & -1u) << 32);
 
-	trace_kvm_msr_write(ecx, data);
-
 	if (vmx_set_msr(vcpu, ecx, data) != 0) {
+		trace_kvm_msr_write_ex(ecx, data);
 		kvm_inject_gp(vcpu, 0);
 		return 1;
 	}
 
+	trace_kvm_msr_write(ecx, data);
 	skip_emulated_instruction(vcpu);
 	return 1;
 }
-- 
1.6.5.3

