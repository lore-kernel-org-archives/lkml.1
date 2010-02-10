Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab0BJRan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:30:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437Ab0BJRXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:13 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/40] KVM: SVM: Adjust tsc_offset only if tsc_unstable
Date: Wed, 10 Feb 2010 19:22:44 +0200
Message-Id: <1265822589-11155-16-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

The tsc_offset adjustment in svm_vcpu_load is executed
unconditionally even if Linux considers the host tsc as
stable. This causes a Linux guest detecting an unstable tsc
in any case.
This patch removes the tsc_offset adjustment if the host tsc
is stable. The guest will now get the benefit of a stable
tsc too.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 7f4e225..b373ae6 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -765,14 +765,16 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (unlikely(cpu != vcpu->cpu)) {
 		u64 delta;
 
-		/*
-		 * Make sure that the guest sees a monotonically
-		 * increasing TSC.
-		 */
-		delta = vcpu->arch.host_tsc - native_read_tsc();
-		svm->vmcb->control.tsc_offset += delta;
-		if (is_nested(svm))
-			svm->nested.hsave->control.tsc_offset += delta;
+		if (check_tsc_unstable()) {
+			/*
+			 * Make sure that the guest sees a monotonically
+			 * increasing TSC.
+			 */
+			delta = vcpu->arch.host_tsc - native_read_tsc();
+			svm->vmcb->control.tsc_offset += delta;
+			if (is_nested(svm))
+				svm->nested.hsave->control.tsc_offset += delta;
+		}
 		vcpu->cpu = cpu;
 		kvm_migrate_timers(vcpu);
 		svm->asid_generation = 0;
-- 
1.6.5.3

