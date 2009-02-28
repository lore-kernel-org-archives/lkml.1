Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbZB1BqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbZB1BqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:46:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbZB1BmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41766 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246AbZB1Bl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:57 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/30] KVM: Add FFXSR support
Date: Sat, 28 Feb 2009 03:41:29 +0200
Message-Id: <1235785309-12835-11-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

AMD K10 CPUs implement the FFXSR feature that gets enabled using
EFER. Let's check if the virtual CPU description includes that
CPUID feature bit and allow enabling it then.

This is required for Windows Server 2008 in Hyper-V mode.

v2 adds CPUID capability exposure

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    3 +++
 arch/x86/kvm/x86.c |   12 ++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index db5021b..1c4a018 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -417,6 +417,9 @@ static __init int svm_hardware_setup(void)
 	if (boot_cpu_has(X86_FEATURE_NX))
 		kvm_enable_efer_bits(EFER_NX);
 
+	if (boot_cpu_has(X86_FEATURE_FXSR_OPT))
+		kvm_enable_efer_bits(EFER_FFXSR);
+
 	if (nested) {
 		printk(KERN_INFO "kvm: Nested Virtualization enabled\n");
 		kvm_enable_efer_bits(EFER_SVME);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 32e3a7e..8f83590 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -490,6 +490,17 @@ static void set_efer(struct kvm_vcpu *vcpu, u64 efer)
 		return;
 	}
 
+	if (efer & EFER_FFXSR) {
+		struct kvm_cpuid_entry2 *feat;
+
+		feat = kvm_find_cpuid_entry(vcpu, 0x80000001, 0);
+		if (!feat || !(feat->edx & bit(X86_FEATURE_FXSR_OPT))) {
+			printk(KERN_DEBUG "set_efer: #GP, enable FFXSR w/o CPUID capability\n");
+			kvm_inject_gp(vcpu, 0);
+			return;
+		}
+	}
+
 	if (efer & EFER_SVME) {
 		struct kvm_cpuid_entry2 *feat;
 
@@ -1240,6 +1251,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 #ifdef CONFIG_X86_64
 		bit(X86_FEATURE_LM) |
 #endif
+		bit(X86_FEATURE_FXSR_OPT) |
 		bit(X86_FEATURE_MMXEXT) |
 		bit(X86_FEATURE_3DNOWEXT) |
 		bit(X86_FEATURE_3DNOW);
-- 
1.6.0.6

