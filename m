Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbZIRTxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbZIRTxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbZIRTxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:53:32 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:15165
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752223AbZIRTxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:53:31 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzef8Kzz1202hzzz32i6bh203h67h)
X-Spam-TCS-SCL: 6:0
X-FB-SS: 5,
X-WSS-ID: 0KQ6N8Y-01-FTM-02
X-M-MSG: 
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: linux-kernel@vger.kernel.org, avi@qumranet.com, kvm@vger.kernel.org
Subject: [PATCH][KVM][2/2] Support Pause Filter in AMD processors
Date: Fri, 18 Sep 2009 14:51:09 -0500
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200909181451.09942.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 18 Sep 2009 19:53:26.0117 (UTC) FILETIME=[AFA09950:01CA3899]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch depends on "[PATCH] Prevent immediate process rescheduling"
that I just submitted.

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
with a scheduler algorithm that guaranteed that yielding
proccess would not be immediately rescheduled.  Further
performance improvement may be possible with a more
sophisticated yield algorithm.

-Mark Langsdorf
Operating System Research Center
AMD

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
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
index a2f2d43..28c49d0 100644
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
 
@@ -2255,6 +2261,12 @@ static int interrupt_window_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
+static int pause_interception(struct vcpu_svm *svm)
+{
+	schedule();
+	return 1;
+}
+
 static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_READ_CR0]           		= emulate_on_interception,
 	[SVM_EXIT_READ_CR3]           		= emulate_on_interception,
@@ -2290,6 +2302,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_CPUID]			= cpuid_interception,
 	[SVM_EXIT_IRET]                         = iret_interception,
 	[SVM_EXIT_INVD]                         = emulate_on_interception,
+	[SVM_EXIT_PAUSE]			= pause_interception,
 	[SVM_EXIT_HLT]				= halt_interception,
 	[SVM_EXIT_INVLPG]			= invlpg_interception,
 	[SVM_EXIT_INVLPGA]			= invlpga_interception,
-- 
1.6.0.2



