Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbZKSNgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbZKSNgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZKSNgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:36:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663AbZKSNfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:09 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 31/35] KVM: x86: Polish exception injection via KVM_SET_GUEST_DEBUG
Date: Thu, 19 Nov 2009 15:35:07 +0200
Message-Id: <1258637711-11674-32-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Decouple KVM_GUESTDBG_INJECT_DB and KVM_GUESTDBG_INJECT_BP from
KVM_GUESTDBG_ENABLE, their are actually orthogonal. At this chance,
avoid triggering the WARN_ON in kvm_queue_exception if there is already
an exception pending and reject such invalid requests.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/x86.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cd6fe0a..ba8958d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4656,10 +4656,20 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 					struct kvm_guest_debug *dbg)
 {
 	unsigned long rflags;
-	int i;
+	int i, r;
 
 	vcpu_load(vcpu);
 
+	if (dbg->control & (KVM_GUESTDBG_INJECT_DB | KVM_GUESTDBG_INJECT_BP)) {
+		r = -EBUSY;
+		if (vcpu->arch.exception.pending)
+			goto unlock_out;
+		if (dbg->control & KVM_GUESTDBG_INJECT_DB)
+			kvm_queue_exception(vcpu, DB_VECTOR);
+		else
+			kvm_queue_exception(vcpu, BP_VECTOR);
+	}
+
 	/*
 	 * Read rflags as long as potentially injected trace flags are still
 	 * filtered out.
@@ -4695,14 +4705,12 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 
 	kvm_x86_ops->set_guest_debug(vcpu, dbg);
 
-	if (vcpu->guest_debug & KVM_GUESTDBG_INJECT_DB)
-		kvm_queue_exception(vcpu, DB_VECTOR);
-	else if (vcpu->guest_debug & KVM_GUESTDBG_INJECT_BP)
-		kvm_queue_exception(vcpu, BP_VECTOR);
+	r = 0;
 
+unlock_out:
 	vcpu_put(vcpu);
 
-	return 0;
+	return r;
 }
 
 /*
-- 
1.6.5.2

