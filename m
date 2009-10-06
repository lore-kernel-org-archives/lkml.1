Return-Path: <linux-kernel-owner+w=401wt.eu-S933099AbZJFTZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbZJFTZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 15:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933069AbZJFTZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 15:25:31 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:47858 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933067AbZJFTZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 15:25:30 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KR3XWS-02-GHV-02
X-M-MSG: 
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH][retry 3] Support Pause Filter in AMD processors
Date: Tue, 6 Oct 2009 14:25:02 -0500
User-Agent: KMail/1.9.10
CC: avi@qumranet.com, avi@redhat.com, kvm@vger.kernel.org
References: <200910021449.59284.mark.langsdorf@amd.com>
In-Reply-To: <200910021449.59284.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-ID: <200910061425.03191.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 06 Oct 2009 19:24:32.0590 (UTC) FILETIME=[A1CCDEE0:01CA46BA]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8ec340648103510095ff339b914706c81e9d815d Mon Sep 17 00:00:00 2001
From: Mark Langsdorf <mark.langsdorf@amd.com>
Date: Wed, 9 Sep 2009 22:12:51 -0500
Subject: [PATCH] [PATCH] Support Pause Filter in AMD processors

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
"KVM:VMX: Add support for Pause Loop Exiting"
http://www.mail-archive.com/kvm@vger.kernel.org/msg23089.html

-Mark Langsdorf
Operating System Research Center
AMD

Signed-of-by: Mark Langsdorf <mark.langsdorf@amd.com>
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
index 279a2ae..a07f969 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -46,6 +46,7 @@ MODULE_LICENSE("GPL");
 #define SVM_FEATURE_NPT  (1 << 0)
 #define SVM_FEATURE_LBRV (1 << 1)
 #define SVM_FEATURE_SVML (1 << 2)
+#define SVM_FEATURE_PAUSE_FILTER (1 << 10)
 
 #define NESTED_EXIT_HOST	0	/* Exit handled on host level */
 #define NESTED_EXIT_DONE	1	/* Exit caused nested vmexit  */
@@ -660,6 +661,11 @@ static void init_vmcb(struct vcpu_svm *svm)
 	svm->nested.vmcb = 0;
 	svm->vcpu.arch.hflags = 0;
 
+	if (svm_has(SVM_FEATURE_PAUSE_FILTER)) {
+		control->pause_filter_count = 3000;
+		control->intercept |= (1ULL << INTERCEPT_PAUSE);
+	}
+
 	enable_gif(svm);
 }
 
@@ -2261,6 +2267,12 @@ static int interrupt_window_interception(struct vcpu_svm *svm)
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
@@ -2296,6 +2308,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_CPUID]			= cpuid_interception,
 	[SVM_EXIT_IRET]                         = iret_interception,
 	[SVM_EXIT_INVD]                         = emulate_on_interception,
+	[SVM_EXIT_PAUSE]			= pause_interception,
 	[SVM_EXIT_HLT]				= halt_interception,
 	[SVM_EXIT_INVLPG]			= invlpg_interception,
 	[SVM_EXIT_INVLPGA]			= invlpga_interception,
-- 
1.6.0.2


