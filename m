Return-Path: <linux-kernel-owner+w=401wt.eu-S1758873AbXIQI52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbXIQI52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbXIQIdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:41 -0400
Received: from il.qumranet.com ([82.166.9.18]:45244 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530AbXIQIce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:34 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 085/104] KVM: Keep control regs in sync
Date: Mon, 17 Sep 2007 10:32:07 +0200
Message-Id: <11900179493729-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

We don't update the vcpu control registers in various places.  We
should do so.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index f0a8780..07a6d97 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -543,6 +543,7 @@ void set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		return;
 	}
 	kvm_arch_ops->set_cr4(vcpu, cr4);
+	vcpu->cr4 = cr4;
 	mutex_lock(&vcpu->kvm->lock);
 	kvm_mmu_reset_context(vcpu);
 	mutex_unlock(&vcpu->kvm->lock);
@@ -1238,10 +1239,8 @@ int emulate_invlpg(struct kvm_vcpu *vcpu, gva_t address)
 
 int emulate_clts(struct kvm_vcpu *vcpu)
 {
-	unsigned long cr0;
-
-	cr0 = vcpu->cr0 & ~X86_CR0_TS;
-	kvm_arch_ops->set_cr0(vcpu, cr0);
+	vcpu->cr0 &= ~X86_CR0_TS;
+	kvm_arch_ops->set_cr0(vcpu, vcpu->cr0);
 	return X86EMUL_CONTINUE;
 }
 
@@ -2228,6 +2227,7 @@ static int kvm_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	kvm_arch_ops->decache_cr4_guest_bits(vcpu);
 
 	mmu_reset_needed |= vcpu->cr0 != sregs->cr0;
+	vcpu->cr0 = sregs->cr0;
 	kvm_arch_ops->set_cr0(vcpu, sregs->cr0);
 
 	mmu_reset_needed |= vcpu->cr4 != sregs->cr4;
-- 
1.5.3

