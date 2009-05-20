Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbZETLVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbZETLVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbZETLTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:19:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55280 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643AbZETLSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:50 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 32/46] KVM: Replace kvmclock open-coded get_cpu_var() with the real thing
Date: Wed, 20 May 2009 14:18:29 +0300
Message-Id: <1242818323-10413-33-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested by Ingo Molnar.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c45df9..a7ea26e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -627,16 +627,17 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
 	unsigned long flags;
 	struct kvm_vcpu_arch *vcpu = &v->arch;
 	void *shared_kaddr;
+	unsigned long this_tsc_khz;
 
 	if ((!vcpu->time_page))
 		return;
 
-	preempt_disable();
-	if (unlikely(vcpu->hv_clock_tsc_khz != __get_cpu_var(cpu_tsc_khz))) {
-		kvm_set_time_scale(__get_cpu_var(cpu_tsc_khz), &vcpu->hv_clock);
-		vcpu->hv_clock_tsc_khz = __get_cpu_var(cpu_tsc_khz);
+	this_tsc_khz = get_cpu_var(cpu_tsc_khz);
+	if (unlikely(vcpu->hv_clock_tsc_khz != this_tsc_khz)) {
+		kvm_set_time_scale(this_tsc_khz, &vcpu->hv_clock);
+		vcpu->hv_clock_tsc_khz = this_tsc_khz;
 	}
-	preempt_enable();
+	put_cpu_var(cpu_tsc_khz);
 
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
-- 
1.6.0.6

