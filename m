Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbZKSNno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbZKSNno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbZKSNnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:43:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298AbZKSNfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:07 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 07/35] KVM: SVM: Support Pause Filter in AMD processors
Date: Thu, 19 Nov 2009 15:34:43 +0200
Message-Id: <1258637711-11674-8-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Langsdorf <mark.langsdorf@amd.com>

New AMD processors (Family 0x10 models 8+) support the Pause
Filter Feature.  This feature creates a new field in the VMCB
called Pause Filter Count.  If Pause Filter Count is greater
than 0 and intercepting PAUSEs is enabled, the processor will
increment an internal counter when a PAUSE instruction occurs
instead of intercepting.  When the internal counter reaches the
Pause Filter Count value, a PAUSE intercept will occur.

This feature can be used to detect contended spinlocks,
especially when the lock holding VCPU is not scheduled.
Rescheduling another VCPU prevents the VCPU seeking the
lock from wasting its quantum by spinning idly.

Experimental results show that most spinlocks are held
for less than 1000 PAUSE cycles or more than a few
thousand.  Default the Pause Filter Counter to 3000 to
detect the contended spinlocks.

Processor support for this feature is indicated by a CPUID
bit.

On a 24 core system running 4 guests each with 16 VCPUs,
this patch improved overall performance of each guest's
32 job kernbench by approximately 3-5% when combined
with a scheduler algorithm thati caused the VCPU to
sleep for a brief period. Further performance improvement
may be possible with a more sophisticated yield algorithm.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/include/asm/svm.h |    3 ++-
 arch/x86/kvm/svm.c         |   13 +++++++++++++
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 85574b7..1fecb7e 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -57,7 +57,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u16 intercept_dr_write;
 	u32 intercept_exceptions;
 	u64 intercept;
-	u8 reserved_1[44];
+	u8 reserved_1[42];
+	u16 pause_filter_count;
 	u64 iopm_base_pa;
 	u64 msrpm_base_pa;
 	u64 tsc_offset;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 69610c5..170b2d9 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -46,6 +46,7 @@ MODULE_LICENSE("GPL");
 #define SVM_FEATURE_NPT  (1 << 0)
 #define SVM_FEATURE_LBRV (1 << 1)
 #define SVM_FEATURE_SVML (1 << 2)
+#define SVM_FEATURE_PAUSE_FILTER (1 << 10)
 
 #define NESTED_EXIT_HOST	0	/* Exit handled on host level */
 #define NESTED_EXIT_DONE	1	/* Exit caused nested vmexit  */
@@ -654,6 +655,11 @@ static void init_vmcb(struct vcpu_svm *svm)
 	svm->nested.vmcb = 0;
 	svm->vcpu.arch.hflags = 0;
 
+	if (svm_has(SVM_FEATURE_PAUSE_FILTER)) {
+		control->pause_filter_count = 3000;
+		control->intercept |= (1ULL << INTERCEPT_PAUSE);
+	}
+
 	enable_gif(svm);
 }
 
@@ -2281,6 +2287,12 @@ static int interrupt_window_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
+static int pause_interception(struct vcpu_svm *svm)
+{
+	kvm_vcpu_on_spin(&(svm->vcpu));
+	return 1;
+}
+
 static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_READ_CR0]           		= emulate_on_interception,
 	[SVM_EXIT_READ_CR3]           		= emulate_on_interception,
@@ -2316,6 +2328,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_CPUID]			= cpuid_interception,
 	[SVM_EXIT_IRET]                         = iret_interception,
 	[SVM_EXIT_INVD]                         = emulate_on_interception,
+	[SVM_EXIT_PAUSE]			= pause_interception,
 	[SVM_EXIT_HLT]				= halt_interception,
 	[SVM_EXIT_INVLPG]			= invlpg_interception,
 	[SVM_EXIT_INVLPGA]			= invlpga_interception,
-- 
1.6.5.2

