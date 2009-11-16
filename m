Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbZKPMUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbZKPMUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbZKPMUC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbZKPMTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:42 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 29/42] KVM: Separate timer intialization into an indepedent function
Date: Mon, 16 Nov 2009 14:19:30 +0200
Message-Id: <1258373983-8693-30-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zachary Amsden <zamsden@redhat.com>

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/x86.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3d83de8..6a31dfb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3118,9 +3118,22 @@ static struct notifier_block kvmclock_cpufreq_notifier_block = {
         .notifier_call  = kvmclock_cpufreq_notifier
 };
 
+static void kvm_timer_init(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
+	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
+		tsc_khz_ref = tsc_khz;
+		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
+					  CPUFREQ_TRANSITION_NOTIFIER);
+	}
+}
+
 int kvm_arch_init(void *opaque)
 {
-	int r, cpu;
+	int r;
 	struct kvm_x86_ops *ops = (struct kvm_x86_ops *)opaque;
 
 	if (kvm_x86_ops) {
@@ -3152,13 +3165,7 @@ int kvm_arch_init(void *opaque)
 	kvm_mmu_set_mask_ptes(PT_USER_MASK, PT_ACCESSED_MASK,
 			PT_DIRTY_MASK, PT64_NX_MASK, 0);
 
-	for_each_possible_cpu(cpu)
-		per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
-	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
-		tsc_khz_ref = tsc_khz;
-		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
-					  CPUFREQ_TRANSITION_NOTIFIER);
-	}
+	kvm_timer_init();
 
 	return 0;
 
-- 
1.6.5.2

