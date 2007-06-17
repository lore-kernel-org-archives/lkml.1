Return-Path: <linux-kernel-owner+w=401wt.eu-S1762795AbXFQKEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762795AbXFQKEP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 06:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759829AbXFQJpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:55 -0400
Received: from il.qumranet.com ([82.166.9.18]:55167 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758736AbXFQJop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:45 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Nitin A Kamble <nitin.a.kamble@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 24/58] KVM: VMX: Handle #SS faults from real mode
Date: Sun, 17 Jun 2007 12:44:05 +0300
Message-Id: <11820734803179-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

Instructions with address size override prefix opcode 0x67
Cause the #SS fault with 0 error code in VM86 mode.  Forward
them to the emulator.

Signed-Off-By: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index c4c5535..a05bfa0 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1488,7 +1488,11 @@ static int handle_rmode_exception(struct kvm_vcpu *vcpu,
 	if (!vcpu->rmode.active)
 		return 0;
 
-	if (vec == GP_VECTOR && err_code == 0)
+	/*
+	 * Instruction with address size override prefix opcode 0x67
+	 * Cause the #SS fault with 0 error code in VM86 mode.
+	 */
+	if (((vec == GP_VECTOR) || (vec == SS_VECTOR)) && err_code == 0)
 		if (emulate_instruction(vcpu, NULL, 0, 0) == EMULATE_DONE)
 			return 1;
 	return 0;
-- 
1.5.0.6

