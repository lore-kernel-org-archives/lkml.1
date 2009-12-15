Return-Path: <linux-kernel-owner+w=401wt.eu-S1759245AbZLOEJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245AbZLOEJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932431AbZLOEHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:07:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758537AbZLOEHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:07:18 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: [PATCH RFC: kvm tsc virtualization 11/20] Use highest TSC frequency as reference clock
Date: Mon, 14 Dec 2009 18:08:38 -1000
Message-Id: <1260850127-9766-12-git-send-email-zamsden@redhat.com>
In-Reply-To: <1260850127-9766-11-git-send-email-zamsden@redhat.com>
References: <1260850127-9766-1-git-send-email-zamsden@redhat.com>
 <1260850127-9766-2-git-send-email-zamsden@redhat.com>
 <1260850127-9766-3-git-send-email-zamsden@redhat.com>
 <1260850127-9766-4-git-send-email-zamsden@redhat.com>
 <1260850127-9766-5-git-send-email-zamsden@redhat.com>
 <1260850127-9766-6-git-send-email-zamsden@redhat.com>
 <1260850127-9766-7-git-send-email-zamsden@redhat.com>
 <1260850127-9766-8-git-send-email-zamsden@redhat.com>
 <1260850127-9766-9-git-send-email-zamsden@redhat.com>
 <1260850127-9766-10-git-send-email-zamsden@redhat.com>
 <1260850127-9766-11-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CPU frequency governors can change the TSC frequency, use
the highest possible frequency as the reference.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 520ea6a..3c4266f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3701,7 +3701,15 @@ static void kvm_timer_init(void)
 	 * can change at any time.
 	 */
 	register_cpu_notifier(&kvm_x86_cpu_notifier);
+	ref_tsc_khz = tsc_khz;
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
+#ifdef CONFIG_CPU_FREQ
+		struct cpufreq_policy policy;
+
+		cpufreq_get_policy(&policy, get_cpu());
+		ref_tsc_khz = policy.cpuinfo.max_freq;
+		put_cpu();
+#endif
 		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
 					  CPUFREQ_TRANSITION_NOTIFIER);
 		for_each_online_cpu(cpu) {
@@ -3718,7 +3726,6 @@ static void kvm_timer_init(void)
 			per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
 	}
 	tsc_base_cpu = get_cpu();
-	ref_tsc_khz = per_cpu(cpu_tsc_khz, tsc_base_cpu);
 	resync(NULL);
 	put_cpu();
 }
-- 
1.6.5.2

