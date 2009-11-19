Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbZKSNn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbZKSNn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756778AbZKSNnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:43:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbZKSNfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:07 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 08/35] KVM: x86: Harden against cpufreq
Date: Thu, 19 Nov 2009 15:34:44 +0200
Message-Id: <1258637711-11674-9-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zachary Amsden <zamsden@redhat.com>

If cpufreq can't determine the CPU khz, or cpufreq is not compiled in,
we should fallback to the measured TSC khz.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/x86.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 098e7f8..3cffa2c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1348,8 +1348,12 @@ out:
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
-	if (unlikely(per_cpu(cpu_tsc_khz, cpu) == 0))
-		per_cpu(cpu_tsc_khz, cpu) = cpufreq_quick_get(cpu);
+	if (unlikely(per_cpu(cpu_tsc_khz, cpu) == 0)) {
+		unsigned long khz = cpufreq_quick_get(cpu);
+		if (!khz)
+			khz = tsc_khz;
+		per_cpu(cpu_tsc_khz, cpu) = khz;
+	}
 	kvm_request_guest_time_update(vcpu);
 }
 
@@ -3144,8 +3148,12 @@ static void kvm_timer_init(void)
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
 		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
 					  CPUFREQ_TRANSITION_NOTIFIER);
-		for_each_online_cpu(cpu)
-			per_cpu(cpu_tsc_khz, cpu) = cpufreq_get(cpu);
+		for_each_online_cpu(cpu) {
+			unsigned long khz = cpufreq_get(cpu);
+			if (!khz)
+				khz = tsc_khz;
+			per_cpu(cpu_tsc_khz, cpu) = khz;
+		}
 	} else {
 		for_each_possible_cpu(cpu)
 			per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
-- 
1.6.5.2

