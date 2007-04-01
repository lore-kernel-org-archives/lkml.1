Return-Path: <linux-kernel-owner+w=401wt.eu-S933273AbXDAOkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273AbXDAOkT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933386AbXDAOj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:39:57 -0400
Received: from il.qumranet.com ([82.166.9.18]:47570 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933273AbXDAOfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:44 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 26/41] KVM: Hack real-mode segments on vmx from KVM_SET_SREGS
Date: Sun,  1 Apr 2007 17:35:23 +0300
Message-Id: <1175438139141-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <1175438139816-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com> <11754381392921-git-send-email-avi@qumranet.com> <117543813978-git-send-email-avi@qumranet.com> <117543
 81393061-git-send-email-avi@qumranet.com> <11754381392186-git-send-email-avi@qumranet.com> <117543813916-git-send-email-avi@qumranet.com> <1175438139530-git-send-email-avi@qumranet.com> <1175438139960-git-send-email-avi@qumranet.com> <1175438139816-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As usual, we need to mangle segment registers when emulating real mode
as vm86 has specific constraints.  We special case the reset segment base,
and set the "access rights" (or descriptor flags) to vm86 comaptible values.

This fixes reboot on vmx.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 027a962..578dff5 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -864,7 +864,14 @@ static void vmx_set_segment(struct kvm_vcpu *vcpu,
 	vmcs_writel(sf->base, var->base);
 	vmcs_write32(sf->limit, var->limit);
 	vmcs_write16(sf->selector, var->selector);
-	if (var->unusable)
+	if (vcpu->rmode.active && var->s) {
+		/*
+		 * Hack real-mode segments into vm86 compatibility.
+		 */
+		if (var->base == 0xffff0000 && var->selector == 0xf000)
+			vmcs_writel(sf->base, 0xf0000);
+		ar = 0xf3;
+	} else if (var->unusable)
 		ar = 1 << 16;
 	else {
 		ar = var->type & 15;
-- 
1.5.0.5

