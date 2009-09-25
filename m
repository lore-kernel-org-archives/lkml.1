Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbZIYAts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbZIYAts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 20:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbZIYAtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 20:49:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbZIYAtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 20:49:39 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@redhat.com>,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH: kvm 5/5] Math is hard; let's do some cooking.
Date: Thu, 24 Sep 2009 14:47:20 -1000
Message-Id: <1253839640-12695-6-git-send-email-zamsden@redhat.com>
In-Reply-To: <1253839640-12695-5-git-send-email-zamsden@redhat.com>
References: <20090924151049.GB14102@amt.cnet>
 <1253839640-12695-1-git-send-email-zamsden@redhat.com>
 <1253839640-12695-2-git-send-email-zamsden@redhat.com>
 <1253839640-12695-3-git-send-email-zamsden@redhat.com>
 <1253839640-12695-4-git-send-email-zamsden@redhat.com>
 <1253839640-12695-5-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU frequency change callback provides new TSC frequency for us, and in the
same units (kHz), so there is no reason to do any math.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 66c6bb9..60ae2c7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3070,15 +3070,12 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
 	int i, send_ipi = 0;
-	unsigned long old_khz;
 
 	if (val == CPUFREQ_PRECHANGE && freq->old > freq->new)
 		return 0;
 	if (val == CPUFREQ_POSTCHANGE && freq->old < freq->new)
 		return 0;
-	old_khz = per_cpu(cpu_tsc_khz, freq->cpu);
-	per_cpu(cpu_tsc_khz, freq->cpu) = cpufreq_scale(old_khz, freq->old,
-							freq->new);
+	per_cpu(cpu_tsc_khz, freq->cpu) = freq->new;
 
 	spin_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list) {
-- 
1.6.4.4

