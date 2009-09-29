Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbZI2Vk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbZI2Vk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 17:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbZI2Vk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 17:40:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbZI2Vkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 17:40:55 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@redhat.com>,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v4: kvm 1/4] Code motion.  Separate timer intialization into an indepedent function.
Date: Tue, 29 Sep 2009 11:38:34 -1000
Message-Id: <1254260317-3490-1-git-send-email-zamsden@redhat.com>
In-Reply-To: <4AC1C59F.6010703@redhat.com>
References: <4AC1C59F.6010703@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fedac9d..15d2ace 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3116,9 +3116,22 @@ static struct notifier_block kvmclock_cpufreq_notifier_block = {
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
@@ -3150,13 +3163,7 @@ int kvm_arch_init(void *opaque)
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
1.6.4.4

