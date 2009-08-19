Return-Path: <linux-kernel-owner+w=401wt.eu-S1752466AbZHSNIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbZHSNIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZHSNIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:08:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50571 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751974AbZHSNCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:48 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 16/47] KVM: Fix racy event propagation in timer
Date: Wed, 19 Aug 2009 16:02:12 +0300
Message-Id: <1250686963-8357-17-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Minor issue that likely had no practical relevance: the kvm timer
function so far incremented the pending counter and then may reset it
again to 1 in case reinjection was disabled. This opened a small racy
window with the corresponding VCPU loop that may have happened to run
on another (real) CPU and already consumed the value.

Fix it by skipping the incrementation in case pending is already > 0.
This opens a different race windows, but may only rarely cause lost
events in case we do not care about them anyway (!reinject).

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/timer.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/timer.c b/arch/x86/kvm/timer.c
index 85cc743..1baed41 100644
--- a/arch/x86/kvm/timer.c
+++ b/arch/x86/kvm/timer.c
@@ -9,12 +9,16 @@ static int __kvm_timer_fn(struct kvm_vcpu *vcpu, struct kvm_timer *ktimer)
 	int restart_timer = 0;
 	wait_queue_head_t *q = &vcpu->wq;
 
-	/* FIXME: this code should not know anything about vcpus */
-	if (!atomic_inc_and_test(&ktimer->pending))
-		set_bit(KVM_REQ_PENDING_TIMER, &vcpu->requests);
-
-	if (!ktimer->reinject)
-		atomic_set(&ktimer->pending, 1);
+	/*
+	 * There is a race window between reading and incrementing, but we do
+	 * not care about potentially loosing timer events in the !reinject
+	 * case anyway.
+	 */
+	if (ktimer->reinject || !atomic_read(&ktimer->pending)) {
+		/* FIXME: this code should not know anything about vcpus */
+		if (!atomic_inc_and_test(&ktimer->pending))
+			set_bit(KVM_REQ_PENDING_TIMER, &vcpu->requests);
+	}
 
 	if (waitqueue_active(q))
 		wake_up_interruptible(q);
-- 
1.6.3.3

