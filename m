Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbYLIUY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbYLIUY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbYLIUXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:23:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34842 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635AbYLIUXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:06 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 03/44] KVM: ppc: optimize kvm stat handling
Date: Tue,  9 Dec 2008 22:22:18 +0200
Message-Id: <1228854179-23002-4-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Currently we use an unnecessary if&switch to detect some cases.
To be honest we don't need the ligh_exits counter anyway, because we can
calculate it out of others. Sum_exits can also be calculated, so we can
remove that too.
MMIO, DCR  and INTR can be counted on other places without these
additional control structures (The INTR case was never hit anyway).

The handling of BOOKE_INTERRUPT_EXTERNAL/BOOKE_INTERRUPT_DECREMENTER is
similar, but we can avoid the additional if when copying 3 lines of code.
I thought about a goto there to prevent duplicate lines, but rewriting three
lines should be better style than a goto cross switch/case statements (its
also not enough code to justify a new inline function).

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/booke.c |   32 +++++++++-----------------------
 1 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index dec3f50..b285e3d 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -38,11 +38,9 @@ unsigned long kvmppc_booke_handlers;
 #define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU
 
 struct kvm_stats_debugfs_item debugfs_entries[] = {
-	{ "exits",      VCPU_STAT(sum_exits) },
 	{ "mmio",       VCPU_STAT(mmio_exits) },
 	{ "dcr",        VCPU_STAT(dcr_exits) },
 	{ "sig",        VCPU_STAT(signal_exits) },
-	{ "light",      VCPU_STAT(light_exits) },
 	{ "itlb_r",     VCPU_STAT(itlb_real_miss_exits) },
 	{ "itlb_v",     VCPU_STAT(itlb_virt_miss_exits) },
 	{ "dtlb_r",     VCPU_STAT(dtlb_real_miss_exits) },
@@ -263,6 +261,12 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		break;
 
 	case BOOKE_INTERRUPT_EXTERNAL:
+		vcpu->stat.ext_intr_exits++;
+		if (need_resched())
+			cond_resched();
+		r = RESUME_GUEST;
+		break;
+
 	case BOOKE_INTERRUPT_DECREMENTER:
 		/* Since we switched IVPR back to the host's value, the host
 		 * handled this interrupt the moment we enabled interrupts.
@@ -272,12 +276,9 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		 * we do reschedule the host will fault over it. Perhaps we
 		 * should politely restore the host's entries to minimize
 		 * misses before ceding control. */
+		vcpu->stat.dec_exits++;
 		if (need_resched())
 			cond_resched();
-		if (exit_nr == BOOKE_INTERRUPT_DECREMENTER)
-			vcpu->stat.dec_exits++;
-		else
-			vcpu->stat.ext_intr_exits++;
 		r = RESUME_GUEST;
 		break;
 
@@ -301,6 +302,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			break;
 		case EMULATE_DO_DCR:
 			run->exit_reason = KVM_EXIT_DCR;
+			vcpu->stat.dcr_exits++;
 			r = RESUME_HOST;
 			break;
 		case EMULATE_FAIL:
@@ -379,6 +381,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			/* Guest has mapped and accessed a page which is not
 			 * actually RAM. */
 			r = kvmppc_emulate_mmio(run, vcpu);
+			vcpu->stat.mmio_exits++;
 		}
 
 		break;
@@ -445,8 +448,6 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 
 	kvmppc_core_deliver_interrupts(vcpu);
 
-	/* Do some exit accounting. */
-	vcpu->stat.sum_exits++;
 	if (!(r & RESUME_HOST)) {
 		/* To avoid clobbering exit_reason, only check for signals if
 		 * we aren't already exiting to userspace for some other
@@ -454,22 +455,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		if (signal_pending(current)) {
 			run->exit_reason = KVM_EXIT_INTR;
 			r = (-EINTR << 2) | RESUME_HOST | (r & RESUME_FLAG_NV);
-
 			vcpu->stat.signal_exits++;
-		} else {
-			vcpu->stat.light_exits++;
-		}
-	} else {
-		switch (run->exit_reason) {
-		case KVM_EXIT_MMIO:
-			vcpu->stat.mmio_exits++;
-			break;
-		case KVM_EXIT_DCR:
-			vcpu->stat.dcr_exits++;
-			break;
-		case KVM_EXIT_INTR:
-			vcpu->stat.signal_exits++;
-			break;
 		}
 	}
 
-- 
1.6.0.3

