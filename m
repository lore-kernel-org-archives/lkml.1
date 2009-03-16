Return-Path: <linux-kernel-owner+w=401wt.eu-S1760366AbZCPNEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366AbZCPNEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 09:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbZCPNEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 09:04:10 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:34434
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756566AbZCPNEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 09:04:08 -0400
X-BigFish: VPS11(z1857rzzz1202hzzz32i63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KGLOA7-04-BNC-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] kvm/x86: check KVM_REQ_TLB_FLUSH with irqs disabled
Date: Mon, 16 Mar 2009 14:03:45 +0100
Message-ID: <1237208625-2657-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
X-OriginalArrivalTime: 16 Mar 2009 13:03:45.0291 (UTC) FILETIME=[A37AB5B0:01C9A637]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For KVM remote TLB flushes we need to check the KVM_REQ_TLB_FLUSH
request flag when the irqs are already disabled. Otherwise there is a
small window of time for a race condition where we may enter a guest
without doing a requested TLB flush.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/x86.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b556b6a..301660a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3108,8 +3108,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 			kvm_write_guest_time(vcpu);
 		if (test_and_clear_bit(KVM_REQ_MMU_SYNC, &vcpu->requests))
 			kvm_mmu_sync_roots(vcpu);
-		if (test_and_clear_bit(KVM_REQ_TLB_FLUSH, &vcpu->requests))
-			kvm_x86_ops->tlb_flush(vcpu);
 		if (test_and_clear_bit(KVM_REQ_REPORT_TPR_ACCESS,
 				       &vcpu->requests)) {
 			kvm_run->exit_reason = KVM_EXIT_TPR_ACCESS;
@@ -3133,6 +3131,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	local_irq_disable();
 
+	if (test_and_clear_bit(KVM_REQ_TLB_FLUSH, &vcpu->requests))
+		kvm_x86_ops->tlb_flush(vcpu);
+
 	if (vcpu->requests || need_resched() || signal_pending(current)) {
 		local_irq_enable();
 		preempt_enable();
-- 
1.5.6.4


