Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbYLHLk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbYLHLk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYLHLh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:37:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48258 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbYLHLhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiantao Zhang <xiantao.zhang@intel.com>
Subject: [PATCH 35/45] KVM: ia64: Remove lock held by halted vcpu
Date: Mon,  8 Dec 2008 13:36:46 +0200
Message-Id: <1228736216-15787-36-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

Remove the lock protection for kvm halt logic, otherwise,
once other vcpus want to acquire the lock, and they have to
wait all vcpus are waken up from halt.

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 43e45f6..70eb829 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -439,7 +439,6 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 		expires = div64_u64(itc_diff, cyc_per_usec);
 		kt = ktime_set(0, 1000 * expires);
 
-		down_read(&vcpu->kvm->slots_lock);
 		vcpu->arch.ht_active = 1;
 		hrtimer_start(p_ht, kt, HRTIMER_MODE_ABS);
 
@@ -452,7 +451,6 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 			if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED)
 				vcpu->arch.mp_state =
 					KVM_MP_STATE_RUNNABLE;
-		up_read(&vcpu->kvm->slots_lock);
 
 		if (vcpu->arch.mp_state != KVM_MP_STATE_RUNNABLE)
 			return -EINTR;
-- 
1.6.0.3

