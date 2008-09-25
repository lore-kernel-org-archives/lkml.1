Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbYIYL4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbYIYL4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbYIYLzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:55:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48517 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720AbYIYLzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:55:22 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 03/39] KVM: set debug registers after "schedulable" section
Date: Thu, 25 Sep 2008 14:54:35 +0300
Message-Id: <1222343711-12508-4-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

The vcpu thread can be preempted after the guest_debug_pre() callback,
resulting in invalid debug registers on the new vcpu.

Move it inside the non-preemptable section.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f1b0223..4a03375 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3113,10 +3113,6 @@ static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	down_read(&vcpu->kvm->slots_lock);
 	vapic_enter(vcpu);
 
-preempted:
-	if (vcpu->guest_debug.enabled)
-		kvm_x86_ops->guest_debug_pre(vcpu);
-
 again:
 	if (vcpu->requests)
 		if (test_and_clear_bit(KVM_REQ_MMU_RELOAD, &vcpu->requests))
@@ -3170,6 +3166,9 @@ again:
 		goto out;
 	}
 
+	if (vcpu->guest_debug.enabled)
+		kvm_x86_ops->guest_debug_pre(vcpu);
+
 	vcpu->guest_mode = 1;
 	/*
 	 * Make sure that guest_mode assignment won't happen after
@@ -3244,7 +3243,7 @@ out:
 	if (r > 0) {
 		kvm_resched(vcpu);
 		down_read(&vcpu->kvm->slots_lock);
-		goto preempted;
+		goto again;
 	}
 
 	post_kvm_run_save(vcpu, kvm_run);
-- 
1.6.0.1

