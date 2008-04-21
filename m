Return-Path: <linux-kernel-owner+w=401wt.eu-S1759172AbYDUKis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172AbYDUKis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756732AbYDUKad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:33 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37873
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbYDUKaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:08 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 17/31] KVM: x86 emulator: fix smsw and lmsw with a memory operand
Date: Mon, 21 Apr 2008 13:29:43 +0300
Message-Id: <1208773797-7829-18-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lmsw and smsw were implemented only with a register operand.  Extend them
to support a memory operand as well.  Fixes Windows running some display
compatibility test on AMD hosts.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 8e1b32f..46ef78f 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -275,12 +275,15 @@ static u16 group_table[] = {
 	SrcMem | ModRM, 0, SrcMem | ModRM | Stack, 0,
 	[Group7*8] =
 	0, 0, ModRM | SrcMem, ModRM | SrcMem,
-	SrcNone | ModRM | DstMem, 0, SrcMem | ModRM, SrcMem | ModRM | ByteOp,
+	SrcNone | ModRM | DstMem | Mov, 0,
+	SrcMem16 | ModRM | Mov, SrcMem | ModRM | ByteOp,
 };
 
 static u16 group2_table[] = {
 	[Group7*8] =
-	SrcNone | ModRM, 0, 0, 0, SrcNone | ModRM | DstMem, 0, SrcMem | ModRM, 0,
+	SrcNone | ModRM, 0, 0, 0,
+	SrcNone | ModRM | DstMem | Mov, 0,
+	SrcMem16 | ModRM | Mov, 0,
 };
 
 /* EFLAGS bit definitions. */
@@ -1722,6 +1725,8 @@ twobyte_insn:
 				goto done;
 
 			kvm_emulate_hypercall(ctxt->vcpu);
+			/* Disable writeback. */
+			c->dst.type = OP_NONE;
 			break;
 		case 2: /* lgdt */
 			rc = read_descriptor(ctxt, ops, c->src.ptr,
@@ -1729,6 +1734,8 @@ twobyte_insn:
 			if (rc)
 				goto done;
 			realmode_lgdt(ctxt->vcpu, size, address);
+			/* Disable writeback. */
+			c->dst.type = OP_NONE;
 			break;
 		case 3: /* lidt/vmmcall */
 			if (c->modrm_mod == 3 && c->modrm_rm == 1) {
@@ -1744,27 +1751,25 @@ twobyte_insn:
 					goto done;
 				realmode_lidt(ctxt->vcpu, size, address);
 			}
+			/* Disable writeback. */
+			c->dst.type = OP_NONE;
 			break;
 		case 4: /* smsw */
-			if (c->modrm_mod != 3)
-				goto cannot_emulate;
-			*(u16 *)&c->regs[c->modrm_rm]
-				= realmode_get_cr(ctxt->vcpu, 0);
+			c->dst.bytes = 2;
+			c->dst.val = realmode_get_cr(ctxt->vcpu, 0);
 			break;
 		case 6: /* lmsw */
-			if (c->modrm_mod != 3)
-				goto cannot_emulate;
-			realmode_lmsw(ctxt->vcpu, (u16)c->modrm_val,
-						  &ctxt->eflags);
+			realmode_lmsw(ctxt->vcpu, (u16)c->src.val,
+				      &ctxt->eflags);
 			break;
 		case 7: /* invlpg*/
 			emulate_invlpg(ctxt->vcpu, memop);
+			/* Disable writeback. */
+			c->dst.type = OP_NONE;
 			break;
 		default:
 			goto cannot_emulate;
 		}
-		/* Disable writeback. */
-		c->dst.type = OP_NONE;
 		break;
 	case 0x06:
 		emulate_clts(ctxt->vcpu);
-- 
1.5.5

