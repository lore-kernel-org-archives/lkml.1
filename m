Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbZHSNLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbZHSNLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbZHSNJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:09:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50565 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751964AbZHSNCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:47 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 27/47] KVM: x86 emulator: Prepare for emulation of syscall instructions
Date: Wed, 19 Aug 2009 16:02:23 +0300
Message-Id: <1250686963-8357-28-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Przywara <andre.przywara@amd.com>

Add the flags needed for syscall, sysenter and sysexit to the opcode table.
Catch (but for now ignore) the opcodes in the emulation switch/case.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Christoph Egger <christoph.egger@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 67af33a..b0da29d 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -32,6 +32,8 @@
 #include <linux/module.h>
 #include <asm/kvm_x86_emulate.h>
 
+#include "mmu.h"		/* for is_long_mode() */
+
 /*
  * Opcode effective-address decode tables.
  * Note that we only emulate instructions that have at least one memory
@@ -209,7 +211,7 @@ static u32 opcode_table[256] = {
 
 static u32 twobyte_table[256] = {
 	/* 0x00 - 0x0F */
-	0, Group | GroupDual | Group7, 0, 0, 0, 0, ImplicitOps, 0,
+	0, Group | GroupDual | Group7, 0, 0, 0, ImplicitOps, ImplicitOps, 0,
 	ImplicitOps, ImplicitOps, 0, 0, 0, ImplicitOps | ModRM, 0, 0,
 	/* 0x10 - 0x1F */
 	0, 0, 0, 0, 0, 0, 0, 0, ImplicitOps | ModRM, 0, 0, 0, 0, 0, 0, 0,
@@ -217,7 +219,9 @@ static u32 twobyte_table[256] = {
 	ModRM | ImplicitOps, ModRM, ModRM | ImplicitOps, ModRM, 0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x30 - 0x3F */
-	ImplicitOps, 0, ImplicitOps, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	ImplicitOps, 0, ImplicitOps, 0,
+	ImplicitOps, ImplicitOps, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x40 - 0x47 */
 	DstReg | SrcMem | ModRM | Mov, DstReg | SrcMem | ModRM | Mov,
 	DstReg | SrcMem | ModRM | Mov, DstReg | SrcMem | ModRM | Mov,
@@ -1988,6 +1992,9 @@ twobyte_insn:
 			goto cannot_emulate;
 		}
 		break;
+	case 0x05: 		/* syscall */
+		goto cannot_emulate;
+		break;
 	case 0x06:
 		emulate_clts(ctxt->vcpu);
 		c->dst.type = OP_NONE;
@@ -2054,6 +2061,12 @@ twobyte_insn:
 		rc = X86EMUL_CONTINUE;
 		c->dst.type = OP_NONE;
 		break;
+	case 0x34:		/* sysenter */
+		goto cannot_emulate;
+		break;
+	case 0x35:		/* sysexit */
+		goto cannot_emulate;
+		break;
 	case 0x40 ... 0x4f:	/* cmov */
 		c->dst.val = c->dst.orig_val = c->src.val;
 		if (!test_cc(c->b, ctxt->eflags))
-- 
1.6.3.3

