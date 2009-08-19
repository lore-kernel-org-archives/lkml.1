Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539AbZHSNJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbZHSNJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbZHSNJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:09:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50559 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751932AbZHSNCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:47 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 17/47] KVM: Drop useless atomic test from timer function
Date: Wed, 19 Aug 2009 16:02:13 +0300
Message-Id: <1250686963-8357-18-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

The current code tries to optimize the setting of
KVM_REQ_PENDING_TIMER but used atomic_inc_and_test - which always
returns true unless pending had the invalid value of -1 on entry. This
patch drops the test part preserving the original semantic but
expressing it less confusingly.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/timer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/timer.c b/arch/x86/kvm/timer.c
index 1baed41..eea4043 100644
--- a/arch/x86/kvm/timer.c
+++ b/arch/x86/kvm/timer.c
@@ -15,9 +15,9 @@ static int __kvm_timer_fn(struct kvm_vcpu *vcpu, struct kvm_timer *ktimer)
 	 * case anyway.
 	 */
 	if (ktimer->reinject || !atomic_read(&ktimer->pending)) {
+		atomic_inc(&ktimer->pending);
 		/* FIXME: this code should not know anything about vcpus */
-		if (!atomic_inc_and_test(&ktimer->pending))
-			set_bit(KVM_REQ_PENDING_TIMER, &vcpu->requests);
+		set_bit(KVM_REQ_PENDING_TIMER, &vcpu->requests);
 	}
 
 	if (waitqueue_active(q))
-- 
1.6.3.3

