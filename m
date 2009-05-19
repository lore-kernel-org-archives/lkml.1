Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbZESSwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbZESSwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 14:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbZESSwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 14:52:06 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:58632
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751713AbZESSwF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 14:52:05 -0400
X-BigFish: VPS0(zzef8Kzz1202hzzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KJWN28-01-POE-01
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH][KVM][retry 3] Add support for Pause Filtering to AMD SVM
Date: Tue, 19 May 2009 13:56:36 -0500
User-Agent: KMail/1.9.10
CC: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200905050909.58583.mark.langsdorf@amd.com> <200905071000.14038.mark.langsdorf@amd.com> <200905081203.55484.mark.langsdorf@amd.com>
In-Reply-To: <200905081203.55484.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-ID: <200905191356.37071.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 19 May 2009 18:51:52.0990 (UTC) FILETIME=[DFF4A3E0:01C9D8B2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 67f831e825b64be5dedae9936ff8a60b884959f2 Mon Sep 17 00:00:00 2001
From: mark.langsdorf@amd.com 
Date: Tue, 19 May 2009 07:46:11 -0500
Subject: [PATCH]

This feature creates a new field in the VMCB called Pause
Filter Count.  If Pause Filter Count is greater than 0 and
intercepting PAUSEs is enabled, the processor will increment
an internal counter when a PAUSE instruction occurs instead
of intercepting.  When the internal counter reaches the
Pause Filter Count value, a PAUSE intercept will occur.

This feature can be used to detect contended spinlocks,
especially when the lock holding VCPU is not scheduled.
Rescheduling another VCPU prevents the VCPU seeking the
lock from wasting its quantum by spinning idly.  Perform
the reschedule by increasing the the credited time on
the VCPU.

Experimental results show that most spinlocks are held
for less than 1000 PAUSE cycles or more than a few
thousand.  Default the Pause Filter Counter to 5000 to
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
 arch/x86/kvm/svm.c         |   13 +++++++++++++
 include/linux/sched.h      |    7 +++++++
 kernel/sched.c             |    5 +++++
 4 files changed, 27 insertions(+), 1 deletions(-)

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
index ef43a18..86df191 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -45,6 +45,7 @@ MODULE_LICENSE("GPL");
 #define SVM_FEATURE_NPT  (1 << 0)
 #define SVM_FEATURE_LBRV (1 << 1)
 #define SVM_FEATURE_SVML (1 << 2)
+#define SVM_FEATURE_PAUSE_FILTER (1 << 10)
 
 #define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
 
@@ -575,6 +576,11 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	svm->nested_vmcb = 0;
 	svm->vcpu.arch.hflags = HF_GIF_MASK;
+
+	if (svm_has(SVM_FEATURE_PAUSE_FILTER)) {
+		control->pause_filter_count = 3000;
+		control->intercept |= (1ULL << INTERCEPT_PAUSE);
+	}
 }
 
 static int svm_vcpu_reset(struct kvm_vcpu *vcpu)
@@ -2087,6 +2093,12 @@ static int interrupt_window_interception(struct vcpu_svm *svm,
 	return 1;
 }
 
+static int pause_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
+{
+	set_task_delay(current, 1000000);
+	return 1;
+}
+
 static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
 				      struct kvm_run *kvm_run) = {
 	[SVM_EXIT_READ_CR0]           		= emulate_on_interception,
@@ -2123,6 +2135,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
 	[SVM_EXIT_CPUID]			= cpuid_interception,
 	[SVM_EXIT_IRET]                         = iret_interception,
 	[SVM_EXIT_INVD]                         = emulate_on_interception,
+	[SVM_EXIT_PAUSE]			= pause_interception,
 	[SVM_EXIT_HLT]				= halt_interception,
 	[SVM_EXIT_INVLPG]			= invlpg_interception,
 	[SVM_EXIT_INVLPGA]			= invalid_op_interception,
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b4c38bc..683bc65 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2283,6 +2283,9 @@ static inline unsigned int task_cpu(const struct task_struct *p)
 	return task_thread_info(p)->cpu;
 }
 
+extern void set_task_delay(struct task_struct *p, unsigned int delay);
+
+
 extern void set_task_cpu(struct task_struct *p, unsigned int cpu);
 
 #else
@@ -2292,6 +2295,10 @@ static inline unsigned int task_cpu(const struct task_struct *p)
 	return 0;
 }
 
+void set_task_delay(struct task_struct *p, unsigned int delay)
+{
+}
+
 static inline void set_task_cpu(struct task_struct *p, unsigned int cpu)
 {
 }
diff --git a/kernel/sched.c b/kernel/sched.c
index b902e58..3174620 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1947,6 +1947,11 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	return delta < (s64)sysctl_sched_migration_cost;
 }
 
+void set_task_delay(struct task_struct *p, unsigned int delay)
+{
+	p->se.vruntime += delay;
+}
+EXPORT_SYMBOL(set_task_delay);
 
 void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 {
-- 
1.6.0.2


