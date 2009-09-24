Return-Path: <linux-kernel-owner+w=401wt.eu-S1753090AbZIXDbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbZIXDbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 23:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbZIXDbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 23:31:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbZIXDb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 23:31:29 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@redhat.com>,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH: kvm 5/6] Don't unconditionally clear cpu_khz_tsc in hardware_enable.
Date: Wed, 23 Sep 2009 17:29:04 -1000
Message-Id: <1253762945-5750-5-git-send-email-zamsden@redhat.com>
In-Reply-To: <1253762945-5750-4-git-send-email-zamsden@redhat.com>
References: <1253762945-5750-1-git-send-email-zamsden@redhat.com>
 <1253762945-5750-2-git-send-email-zamsden@redhat.com>
 <1253762945-5750-3-git-send-email-zamsden@redhat.com>
 <1253762945-5750-4-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the non-hotplug case, this TSC speed should be available; instead, clear
cpu_khz_tsc when bringing down a CPU so it is recomputed at the next bringup.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 38ba4a6..f1470ce 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4721,18 +4721,16 @@ int kvm_arch_cpu_hotadd(int cpu)
 
 void kvm_arch_cpu_hotremove(int cpu)
 {
+	/*
+	 * Reset TSC khz to zero so it is recomputed on bringup
+	 */
+	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+		per_cpu(cpu_tsc_khz, cpu) = 0;
 	kvm_x86_ops->cpu_hotremove(cpu);
 }
 
 int kvm_arch_hardware_enable(void *garbage)
 {
-	/*
-	 * Notifier callback chain may not have called cpufreq code
-	 * yet, thus we must reset TSC khz to zero and recompute it
-	 * before entering.
-	 */
-	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
-		per_cpu(cpu_tsc_khz, raw_smp_processor_id()) = 0;
 	return kvm_x86_ops->hardware_enable(garbage);
 }
 
-- 
1.6.4.4

