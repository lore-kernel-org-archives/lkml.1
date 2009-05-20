Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbZETWUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbZETWUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 18:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755380AbZETWUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 18:20:32 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:19702 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754957AbZETWUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 18:20:31 -0400
X-BigFish: VPS-2(zzef8Kzz1202hzzz32i6bh)
X-FB-SS: 5,13,
X-WSS-ID: 0KJYRDN-02-016-01
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: Joerg Roedel <joerg.roedel@amd.com>, peterz@infradead.org,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH][KVM][retry 4] Add support for Pause Filtering to AMD SVM
Date: Wed, 20 May 2009 17:25:17 -0500
User-Agent: KMail/1.9.10
CC: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200905050909.58583.mark.langsdorf@amd.com> <200905081203.55484.mark.langsdorf@amd.com> <200905191356.37071.mark.langsdorf@amd.com>
In-Reply-To: <200905191356.37071.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200905201725.18046.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 20 May 2009 22:20:23.0456 (UTC) FILETIME=[2B300200:01C9D999]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 arch/x86/kvm/svm.c         |   13 +++++++++++++
 include/linux/sched.h      |    7 +++++++
 kernel/sched.c             |   18 ++++++++++++++++++
 4 files changed, 40 insertions(+), 1 deletions(-)

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
index ef43a18..dad6c4b 100644
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
+	sched_delay_yield(1000000);
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
index b4c38bc..9cde585 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2283,6 +2283,9 @@ static inline unsigned int task_cpu(const struct task_struct *p)
 	return task_thread_info(p)->cpu;
 }
 
+extern void sched_delay_yield(unsigned long ns);
+
+
 extern void set_task_cpu(struct task_struct *p, unsigned int cpu);
 
 #else
@@ -2292,6 +2295,10 @@ static inline unsigned int task_cpu(const struct task_struct *p)
 	return 0;
 }
 
+void sched_delay_yield(struct task_struct *p, unsigned int delay)
+{
+}
+
 static inline void set_task_cpu(struct task_struct *p, unsigned int cpu)
 {
 }
diff --git a/kernel/sched.c b/kernel/sched.c
index b902e58..3aed2f6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1947,6 +1947,24 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	return delta < (s64)sysctl_sched_migration_cost;
 }
 
+/*
+ * Interface for yielding a thread by delaying it for a known
+ * interval.  Use at your own risk and not with real-time.
+ *
+ * Like yield, except for SCHED_OTHER/BATCH, where it will
+ * give us @ns time for the 'good' cause.
+ */
+void sched_delay_yield(unsigned long ns)
+{
+	struct task_struct *curr = current;
+	if (curr->sched_class == &fair_sched_class) {
+		struct sched_entity *se = &curr->se;
+		__update_curr(cfs_rq_of(se), se, ns);
+		schedule();
+	} else
+		yield();
+}
+EXPORT_SYMBOL_GPL(sched_delay_yield);
 
 void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 {
-- 
1.6.0.2


