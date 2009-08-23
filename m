Return-Path: <linux-kernel-owner+w=401wt.eu-S933675AbZHWL66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675AbZHWL66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 07:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933656AbZHWL6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 07:58:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933556AbZHWL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 37/46] KVM: Align cr8 threshold when userspace changes cr8
Date: Sun, 23 Aug 2009 14:56:36 +0300
Message-Id: <1251028605-31977-38-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikhail Ershov <arcezed@gmail.com>

Commit f0a3602c20 ("KVM: Move interrupt injection logic to x86.c") does not
update the cr8 intercept if the lapic is disabled, so when userspace updates
cr8, the cr8 threshold control is not updated and we are left with illegal
control fields.

Fix by explicitly resetting the cr8 threshold.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2539e9a..d1bcc59 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4441,6 +4441,8 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	kvm_set_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
 	kvm_set_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
 
+	update_cr8_intercept(vcpu);
+
 	/* Older userspace won't unhalt the vcpu on reset. */
 	if (kvm_vcpu_is_bsp(vcpu) && kvm_rip_read(vcpu) == 0xfff0 &&
 	    sregs->cs.selector == 0xf000 && sregs->cs.base == 0xffff0000 &&
-- 
1.6.4.1

