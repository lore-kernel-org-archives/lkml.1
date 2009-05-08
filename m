Return-Path: <linux-kernel-owner+w=401wt.eu-S1763413AbZEHRDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763413AbZEHRDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 13:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756689AbZEHRC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 13:02:58 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:40640 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762859AbZEHRCz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 13:02:55 -0400
X-BigFish: VPS1(zz936fJzz1202hzzz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KJC4L9-02-CQC-01
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH][KVM][retry 2] Add support for Pause Filtering to AMD SVM
Date: Fri, 8 May 2009 12:03:55 -0500
User-Agent: KMail/1.9.10
CC: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200905050909.58583.mark.langsdorf@amd.com> <20090507135522.GJ4059@amd.com> <200905071000.14038.mark.langsdorf@amd.com>
In-Reply-To: <200905071000.14038.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-ID: <200905081203.55484.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 08 May 2009 17:00:53.0698 (UTC) FILETIME=[8C2A1220:01C9CFFE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 01813db8627e74018c8cec90df7e345839351f23 Mon Sep 17 00:00:00 2001
From: Mark Langsdorf <mark.langsdorf@amd.com>
Date: Thu, 7 May 2009 09:44:10 -0500
Subject: [PATCH] Add support for Pause Filtering to AMD SVM

This feature creates a new field in the VMCB called Pause
Filter Count.  If Pause Filter Count is greater than 0 and
intercepting PAUSEs is enabled, the processor will increment
an internal counter when a PAUSE instruction occurs instead
of intercepting.  When the internal counter reaches the
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
32 job kernbench by approximately 1%.  Further performance
improvement may be possible with a more sophisticated
yield algorithm.

-Mark Langsdorf
Operating System Research Center
AMD

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
---
 arch/x86/include/asm/svm.h |    3 ++-
 arch/x86/kvm/svm.c         |   17 +++++++++++++++++
 virt/kvm/kvm_main.c        |    2 ++
 3 files changed, 21 insertions(+), 1 deletions(-)

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
index ef43a18..4279141 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -45,6 +45,7 @@ MODULE_LICENSE("GPL");
 #define SVM_FEATURE_NPT  (1 << 0)
 #define SVM_FEATURE_LBRV (1 << 1)
 #define SVM_FEATURE_SVML (1 << 2)
+#define SVM_FEATURE_PAUSE_FILTER (1 << 10)
 
 #define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
 
@@ -575,6 +576,12 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	svm->nested_vmcb = 0;
 	svm->vcpu.arch.hflags = HF_GIF_MASK;
+
+	if (svm_has(SVM_FEATURE_PAUSE_FILTER)) {
+		control->pause_filter_count = 5000;
+		control->intercept |= (1ULL << INTERCEPT_PAUSE);
+	}
+
 }
 
 static int svm_vcpu_reset(struct kvm_vcpu *vcpu)
@@ -2087,6 +2094,15 @@ static int interrupt_window_interception(struct vcpu_svm *svm,
 	return 1;
 }
 
+static int pause_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
+{
+	/* Simple yield */
+	vcpu_put(&svm->vcpu);
+	schedule();
+	vcpu_load(&svm->vcpu);
+	return 1;
+}
+
 static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
 				      struct kvm_run *kvm_run) = {
 	[SVM_EXIT_READ_CR0]           		= emulate_on_interception,
@@ -2123,6 +2139,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
 	[SVM_EXIT_CPUID]			= cpuid_interception,
 	[SVM_EXIT_IRET]                         = iret_interception,
 	[SVM_EXIT_INVD]                         = emulate_on_interception,
+	[SVM_EXIT_PAUSE]			= pause_interception,
 	[SVM_EXIT_HLT]				= halt_interception,
 	[SVM_EXIT_INVLPG]			= invlpg_interception,
 	[SVM_EXIT_INVLPGA]			= invalid_op_interception,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2b73e19..e2b730d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -710,6 +710,7 @@ void vcpu_load(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_load(vcpu, cpu);
 	put_cpu();
 }
+EXPORT_SYMBOL_GPL(vcpu_load);
 
 void vcpu_put(struct kvm_vcpu *vcpu)
 {
@@ -719,6 +720,7 @@ void vcpu_put(struct kvm_vcpu *vcpu)
 	preempt_enable();
 	mutex_unlock(&vcpu->mutex);
 }
+EXPORT_SYMBOL_GPL(vcpu_put);
 
 static void ack_flush(void *_completed)
 {
-- 
1.6.0.2


