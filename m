Return-Path: <linux-kernel-owner+w=401wt.eu-S1752709AbZHSNJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbZHSNJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbZHSNJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:09:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50561 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751942AbZHSNCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:47 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/47] KVM: Optimize searching for highest IRR
Date: Wed, 19 Aug 2009 16:02:11 +0300
Message-Id: <1250686963-8357-16-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Most of the time IRR is empty, so instead of scanning the whole IRR on
each VM entry keep a variable that tells us if IRR is not empty. IRR
will have to be scanned twice on each IRQ delivery, but this is much
more rare than VM entry.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/lapic.c |   24 +++++++++++++++++++++---
 arch/x86/kvm/lapic.h |    1 +
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index b1694dc..3bde43c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -165,29 +165,46 @@ static int find_highest_vector(void *bitmap)
 
 static inline int apic_test_and_set_irr(int vec, struct kvm_lapic *apic)
 {
+	apic->irr_pending = true;
 	return apic_test_and_set_vector(vec, apic->regs + APIC_IRR);
 }
 
-static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
+static inline int apic_search_irr(struct kvm_lapic *apic)
 {
-	apic_clear_vector(vec, apic->regs + APIC_IRR);
+	return find_highest_vector(apic->regs + APIC_IRR);
 }
 
 static inline int apic_find_highest_irr(struct kvm_lapic *apic)
 {
 	int result;
 
-	result = find_highest_vector(apic->regs + APIC_IRR);
+	if (!apic->irr_pending)
+		return -1;
+
+	result = apic_search_irr(apic);
 	ASSERT(result == -1 || result >= 16);
 
 	return result;
 }
 
+static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
+{
+	apic->irr_pending = false;
+	apic_clear_vector(vec, apic->regs + APIC_IRR);
+	if (apic_search_irr(apic) != -1)
+		apic->irr_pending = true;
+}
+
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	int highest_irr;
 
+	/* This may race with setting of irr in __apic_accept_irq() and
+	 * value returned may be wrong, but kvm_vcpu_kick() in __apic_accept_irq
+	 * will cause vmexit immediately and the value will be recalculated
+	 * on the next vmentry.
+	 */
 	if (!apic)
 		return 0;
 	highest_irr = apic_find_highest_irr(apic);
@@ -843,6 +860,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
 		apic_set_reg(apic, APIC_ISR + 0x10 * i, 0);
 		apic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
 	}
+	apic->irr_pending = false;
 	update_divide_count(apic);
 	atomic_set(&apic->lapic_timer.pending, 0);
 	if (kvm_vcpu_is_bsp(vcpu))
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index a587f83..3f3ecc6 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -12,6 +12,7 @@ struct kvm_lapic {
 	struct kvm_timer lapic_timer;
 	u32 divide_count;
 	struct kvm_vcpu *vcpu;
+	bool irr_pending;
 	struct page *regs_page;
 	void *regs;
 	gpa_t vapic_addr;
-- 
1.6.3.3

