Return-Path: <linux-kernel-owner+w=401wt.eu-S1759331AbYFZMj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331AbYFZMj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbYFZM3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:25 -0400
Received: from il.qumranet.com ([212.179.150.194]:32343 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbYFZM2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:47 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 41/50] KVM: Use printk_rlimit() instead of reporting emulation failures just once
Date: Thu, 26 Jun 2008 15:28:23 +0300
Message-Id: <1214483312-9265-42-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emulation failure reports are useful, so allow more than one per the lifetime
of the module.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 82196c3..ccb4e1e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2076,12 +2076,11 @@ int emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr, unsigned long value)
 
 void kvm_report_emulation_failure(struct kvm_vcpu *vcpu, const char *context)
 {
-	static int reported;
 	u8 opcodes[4];
 	unsigned long rip = vcpu->arch.rip;
 	unsigned long rip_linear;
 
-	if (reported)
+	if (!printk_ratelimit())
 		return;
 
 	rip_linear = rip + get_segment_base(vcpu, VCPU_SREG_CS);
@@ -2090,7 +2089,6 @@ void kvm_report_emulation_failure(struct kvm_vcpu *vcpu, const char *context)
 
 	printk(KERN_ERR "emulation failed (%s) rip %lx %02x %02x %02x %02x\n",
 	       context, rip, opcodes[0], opcodes[1], opcodes[2], opcodes[3]);
-	reported = 1;
 }
 EXPORT_SYMBOL_GPL(kvm_report_emulation_failure);
 
-- 
1.5.6

