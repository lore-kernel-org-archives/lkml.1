Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbZHSNIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbZHSNIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZHSNIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:08:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50572 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751978AbZHSNCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:48 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 25/47] KVM: Allow emulation of syscalls instructions on #UD
Date: Wed, 19 Aug 2009 16:02:21 +0300
Message-Id: <1250686963-8357-26-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Przywara <andre.przywara@amd.com>

Add the opcodes for syscall, sysenter and sysexit to the list of instructions
handled by the undefined opcode handler.

Signed-off-by: Christoph Egger <christoph.egger@amd.com>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |   33 ++++++++++++++++++++++++++-------
 1 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 892a7a6..57e76b3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2667,14 +2667,33 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 
 		r = x86_decode_insn(&vcpu->arch.emulate_ctxt, &emulate_ops);
 
-		/* Reject the instructions other than VMCALL/VMMCALL when
-		 * try to emulate invalid opcode */
+		/* Only allow emulation of specific instructions on #UD
+		 * (namely VMMCALL, sysenter, sysexit, syscall)*/
 		c = &vcpu->arch.emulate_ctxt.decode;
-		if ((emulation_type & EMULTYPE_TRAP_UD) &&
-		    (!(c->twobyte && c->b == 0x01 &&
-		      (c->modrm_reg == 0 || c->modrm_reg == 3) &&
-		       c->modrm_mod == 3 && c->modrm_rm == 1)))
-			return EMULATE_FAIL;
+		if (emulation_type & EMULTYPE_TRAP_UD) {
+			if (!c->twobyte)
+				return EMULATE_FAIL;
+			switch (c->b) {
+			case 0x01: /* VMMCALL */
+				if (c->modrm_mod != 3 || c->modrm_rm != 1)
+					return EMULATE_FAIL;
+				break;
+			case 0x34: /* sysenter */
+			case 0x35: /* sysexit */
+				if (c->modrm_mod != 0 || c->modrm_rm != 0)
+					return EMULATE_FAIL;
+				break;
+			case 0x05: /* syscall */
+				if (c->modrm_mod != 0 || c->modrm_rm != 0)
+					return EMULATE_FAIL;
+				break;
+			default:
+				return EMULATE_FAIL;
+			}
+
+			if (!(c->modrm_reg == 0 || c->modrm_reg == 3))
+				return EMULATE_FAIL;
+		}
 
 		++vcpu->stat.insn_emulation;
 		if (r)  {
-- 
1.6.3.3

