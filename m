Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYI1Prx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYI1Prx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbYI1Pp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:45:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50847 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbYI1PpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:45:18 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 08/25] KVM: x86: unhalt vcpu0 on reset
Date: Sun, 28 Sep 2008 18:44:44 +0300
Message-Id: <1222616701-1206-9-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Since "KVM: x86: do not execute halted vcpus", HLT by vcpu0 before system
reset by the IO thread will hang the guest.

Mark vcpu as runnable in such case.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bf98d40..2134f3e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3959,6 +3959,12 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	kvm_set_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
 	kvm_set_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
 
+	/* Older userspace won't unhalt the vcpu on reset. */
+	if (vcpu->vcpu_id == 0 && kvm_rip_read(vcpu) == 0xfff0 &&
+	    sregs->cs.selector == 0xf000 && sregs->cs.base == 0xffff0000 &&
+	    !(vcpu->arch.cr0 & X86_CR0_PE))
+		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+
 	vcpu_put(vcpu);
 
 	return 0;
-- 
1.6.0.1

