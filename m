Return-Path: <linux-kernel-owner+w=401wt.eu-S1757836AbZEXPv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbZEXPv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756401AbZEXPvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:51:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41864 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280AbZEXPuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:35 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 44/45] KVM: Disable CR8 intercept if tpr patching is active
Date: Sun, 24 May 2009 18:50:29 +0300
Message-Id: <1243180230-2480-45-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7037afa..44e87a5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3138,7 +3138,10 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 	if (!kvm_x86_ops->update_cr8_intercept)
 		return;
 
-	max_irr = kvm_lapic_find_highest_irr(vcpu);
+	if (!vcpu->arch.apic->vapic_addr)
+		max_irr = kvm_lapic_find_highest_irr(vcpu);
+	else
+		max_irr = -1;
 
 	if (max_irr != -1)
 		max_irr >>= 4;
@@ -3245,10 +3248,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		kvm_x86_ops->enable_irq_window(vcpu);
 
 	if (kvm_lapic_enabled(vcpu)) {
-		if (!vcpu->arch.apic->vapic_addr)
-			update_cr8_intercept(vcpu);
-		else
-			kvm_lapic_sync_to_vapic(vcpu);
+		update_cr8_intercept(vcpu);
+		kvm_lapic_sync_to_vapic(vcpu);
 	}
 
 	up_read(&vcpu->kvm->slots_lock);
-- 
1.6.0.6

