Return-Path: <linux-kernel-owner+w=401wt.eu-S933127AbXDAOnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbXDAOnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933227AbXDAOm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:42:57 -0400
Received: from il.qumranet.com ([82.166.9.18]:47551 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933219AbXDAOfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:44 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 23/41] KVM: Workaround vmx inability to virtualize the reset state
Date: Sun,  1 Apr 2007 17:35:20 +0300
Message-Id: <1175438139530-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <117543813916-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com> <11754381392921-git-send-email-avi@qumranet.com> <117543813978-git-send-email-avi@qumranet.com> <117543
 81393061-git-send-email-avi@qumranet.com> <11754381392186-git-send-email-avi@qumranet.com> <117543813916-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The reset state has cs.selector == 0xf000 and cs.base == 0xffff0000,
which aren't compatible with vm86 mode, which is used for real mode
virtualization.

When we create a vcpu, we set cs.base to 0xf0000, but if we get there by
way of a reset, the values are inconsistent and vmx refuses to enter
guest mode.

Workaround by detecting the state and munging it appropriately.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 0d9bf0b..aa7e2ba 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -712,6 +712,8 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 
 	vmcs_write32(GUEST_CS_AR_BYTES, 0xf3);
 	vmcs_write32(GUEST_CS_LIMIT, 0xffff);
+	if (vmcs_readl(GUEST_CS_BASE) == 0xffff0000)
+		vmcs_writel(GUEST_CS_BASE, 0xf0000);
 	vmcs_write16(GUEST_CS_SELECTOR, vmcs_readl(GUEST_CS_BASE) >> 4);
 
 	fix_rmode_seg(VCPU_SREG_ES, &vcpu->rmode.es);
-- 
1.5.0.5

