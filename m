Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab0BJR3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:29:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565Ab0BJRXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:13 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 23/40] KVM: powerpc: Remove AGGRESSIVE_DEC
Date: Wed, 10 Feb 2010 19:22:52 +0200
Message-Id: <1265822589-11155-24-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

Because we now emulate the DEC interrupt according to real life behavior,
there's no need to keep the AGGRESSIVE_DEC hack around.

Let's just remove it.

Signed-off-by: Alexander Graf <agraf@suse.de>
Acked-by: Acked-by: Hollis Blanchard <hollis@penguinppc.org>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/book3s.c |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index fd3ad6c..803505d 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -34,12 +34,6 @@
 /* #define EXIT_DEBUG */
 /* #define EXIT_DEBUG_SIMPLE */
 
-/* Without AGGRESSIVE_DEC we only fire off a DEC interrupt when DEC turns 0.
- * When set, we retrigger a DEC interrupt after that if DEC <= 0.
- * PPC32 Linux runs faster without AGGRESSIVE_DEC, PPC64 Linux requires it. */
-
-/* #define AGGRESSIVE_DEC */
-
 struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "exits",       VCPU_STAT(sum_exits) },
 	{ "mmio",        VCPU_STAT(mmio_exits) },
@@ -81,7 +75,7 @@ void kvmppc_core_vcpu_put(struct kvm_vcpu *vcpu)
 	to_book3s(vcpu)->slb_shadow_max = get_paca()->kvm_slb_max;
 }
 
-#if defined(AGGRESSIVE_DEC) || defined(EXIT_DEBUG)
+#if defined(EXIT_DEBUG)
 static u32 kvmppc_get_dec(struct kvm_vcpu *vcpu)
 {
 	u64 jd = mftb() - vcpu->arch.dec_jiffies;
@@ -273,14 +267,6 @@ void kvmppc_core_deliver_interrupts(struct kvm_vcpu *vcpu)
 	unsigned long *pending = &vcpu->arch.pending_exceptions;
 	unsigned int priority;
 
-	/* XXX be more clever here - no need to mftb() on every entry */
-	/* Issue DEC again if it's still active */
-#ifdef AGGRESSIVE_DEC
-	if (vcpu->arch.msr & MSR_EE)
-		if (kvmppc_get_dec(vcpu) & 0x80000000)
-			kvmppc_core_queue_dec(vcpu);
-#endif
-
 #ifdef EXIT_DEBUG
 	if (vcpu->arch.pending_exceptions)
 		printk(KERN_EMERG "KVM: Check pending: %lx\n", vcpu->arch.pending_exceptions);
-- 
1.6.5.3

