Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbZJBTuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbZJBTuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 15:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbZJBTuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 15:50:18 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:9540 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750750AbZJBTuQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 15:50:16 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KQWKF8-02-H8J-02
X-M-MSG: 
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: linux-kernel@vger.kernel.org, avi@qumranet.com, avi@redhat.com,
       kvm@vger.kernel.org
Subject: [PATCH][retry 2] Support Pause Filter in AMD processors
Date: Fri, 2 Oct 2009 14:49:59 -0500
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <200910021449.59284.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 02 Oct 2009 19:50:06.0098 (UTC) FILETIME=[8A309F20:01CA4399]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 66741f741da741e58e8162ef7809dd7d6f8e01cf Mon Sep 17 00:00:00 2001
From: Mark Langsdorf <mark.langsdorf@amd.com>
Date: Fri, 2 Oct 2009 10:32:33 -0500
Subject: [PATCH] Support Pause Filter in AMD processors

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

This patch depends on the changes to the kvm code from
KVM:VMX: Add support for Pause Loop Exiting
http://www.mail-archive.com/kvm@vger.kernel.org/msg23089.html

-Mark Langsdorf
Operating System Research Center
AMD
---
 arch/x86/include/asm/svm.h |    3 ++-
 arch/x86/kvm/svm.c         |   16 ++++++++++++++++
 2 files changed, 18 insertions(+), 1 deletions(-)

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
index 9a4daca..d5d2e03 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -46,6 +46,7 @@ MODULE_LICENSE("GPL");
 #define SVM_FEATURE_NPT  (1 << 0)
 #define SVM_FEATURE_LBRV (1 << 1)
 #define SVM_FEATURE_SVML (1 << 2)
+#define SVM_FEATURE_PAUSE_FILTER (1 << 10)
 
 #define NESTED_EXIT_HOST	0	/* Exit handled on host level */
 #define NESTED_EXIT_DONE	1	/* Exit caused nested vmexit  */
@@ -659,6 +660,11 @@ static void init_vmcb(struct vcpu_svm *svm)
 	svm->nested.vmcb = 0;
 	svm->vcpu.arch.hflags = 0;
 
+	if (svm_has(SVM_FEATURE_PAUSE_FILTER)) {
+		control->pause_filter_count = 3000;
+		control->intercept |= (1ULL << INTERCEPT_PAUSE);
+	}
+
 	enable_gif(svm);
 }
 
@@ -2270,6 +2276,15 @@ static int interrupt_window_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
+static int pause_interception(struct vcpu_svm *svm)
+{
+	static int pause_count = 0;
+
+	kvm_vcpu_on_spin(&(svm->vcpu));
+printk(KERN_ERR "MJLL pause intercepted %d\n", ++pause_count);
+	return 1;
+}
+
 static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_READ_CR0]           		= emulate_on_interception,
 	[SVM_EXIT_READ_CR3]           		= emulate_on_interception,
@@ -2305,6 +2320,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_CPUID]			= cpuid_interception,
 	[SVM_EXIT_IRET]                         = iret_interception,
 	[SVM_EXIT_INVD]                         = emulate_on_interception,
+	[SVM_EXIT_PAUSE]			= pause_interception,
 	[SVM_EXIT_HLT]				= halt_interception,
 	[SVM_EXIT_INVLPG]			= invlpg_interception,
 	[SVM_EXIT_INVLPGA]			= invlpga_interception,
-- 
1.6.0.2


