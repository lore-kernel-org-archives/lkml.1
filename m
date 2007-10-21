Return-Path: <linux-kernel-owner+w=401wt.eu-S1753236AbXJULLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbXJULLN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbXJULIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:08:00 -0400
Received: from il.qumranet.com ([82.166.9.18]:58448 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbXJULHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:07:55 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Kevin Pedretti <kevin.pedretti@gmail.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 10/11] KVM: Fix local apic timer divide by zero
Date: Sun, 21 Oct 2007 13:08:11 +0200
Message-Id: <11929648921713-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1192964892617-git-send-email-avi@qumranet.com>
References: <1192964892617-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Pedretti <kevin.pedretti@gmail.com>

kvm_lapic_reset() was initializing apic->timer.divide_count to 0,
which could potentially lead to a divide by zero error in
apic_get_tmcct().  Any guest that reads the APIC's CCR (current count)
register before setting DCR (divide configuration) would trigger a divide
by zero exception in the host kernel, leading to a host-OS crash.

This patch results in apic->timer.divide_count being initialized to
2 at reset, eliminating the bug (DCR=0 at reset, meaning divide by 2).

Signed-off-by: Kevin Pedretti <kevin.pedretti@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/lapic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/lapic.c b/drivers/kvm/lapic.c
index a190587..443730e 100644
--- a/drivers/kvm/lapic.c
+++ b/drivers/kvm/lapic.c
@@ -853,7 +853,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
 		apic_set_reg(apic, APIC_ISR + 0x10 * i, 0);
 		apic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
 	}
-	apic->timer.divide_count = 0;
+	update_divide_count(apic);
 	atomic_set(&apic->timer.pending, 0);
 	if (vcpu->vcpu_id == 0)
 		vcpu->apic_base |= MSR_IA32_APICBASE_BSP;
-- 
1.5.3

