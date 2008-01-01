Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbYAAPp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbYAAPp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbYAAPgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:48 -0500
Received: from il.qumranet.com ([82.166.9.18]:33797 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbYAAPg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:28 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Subject: [PATCH 14/54] KVM: x86 emulator: cmps instruction
Date: Tue,  1 Jan 2008 17:35:40 +0200
Message-Id: <1199201780-14001-15-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>

Add emulation for the cmps instruction.  This lets OpenBSD boot on kvm.

Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   58 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 22fdf0a..84e5366 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1535,10 +1535,31 @@ special_insn:
 		break;
 	}
 	if (c->rep_prefix) {
+		/* All REP prefixes have the same first termination condition */
 		if (c->regs[VCPU_REGS_RCX] == 0) {
 			ctxt->vcpu->rip = c->eip;
 			goto done;
 		}
+		/* The second termination condition only applies for REPE
+		 * and REPNE. Test if the repeat string operation prefix is
+		 * REPE/REPZ or REPNE/REPNZ and if it's the case it tests the
+		 * corresponding termination condition according to:
+		 * 	- if REPE/REPZ and ZF = 0 then done
+		 * 	- if REPNE/REPNZ and ZF = 1 then done
+		 */
+		if ((c->b == 0xa6) || (c->b == 0xa7) ||
+				(c->b == 0xae) || (c->b == 0xaf)) {
+			if ((c->rep_prefix == REPE_PREFIX) &&
+				((ctxt->eflags & EFLG_ZF) == 0)) {
+					ctxt->vcpu->rip = c->eip;
+					goto done;
+			}
+			if ((c->rep_prefix == REPNE_PREFIX) &&
+				((ctxt->eflags & EFLG_ZF) == EFLG_ZF)) {
+				ctxt->vcpu->rip = c->eip;
+				goto done;
+			}
+		}
 		c->regs[VCPU_REGS_RCX]--;
 		c->eip = ctxt->vcpu->rip;
 	}
@@ -1564,8 +1585,41 @@ special_insn:
 							   : c->dst.bytes);
 		break;
 	case 0xa6 ... 0xa7:	/* cmps */
-		DPRINTF("Urk! I don't handle CMPS.\n");
-		goto cannot_emulate;
+		c->src.type = OP_NONE; /* Disable writeback. */
+		c->src.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
+		c->src.ptr = (unsigned long *)register_address(
+				c->override_base ? *c->override_base :
+						   ctxt->ds_base,
+						   c->regs[VCPU_REGS_RSI]);
+		if ((rc = ops->read_emulated((unsigned long)c->src.ptr,
+						&c->src.val,
+						c->src.bytes,
+						ctxt->vcpu)) != 0)
+			goto done;
+
+		c->dst.type = OP_NONE; /* Disable writeback. */
+		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
+		c->dst.ptr = (unsigned long *)register_address(
+						   ctxt->es_base,
+						   c->regs[VCPU_REGS_RDI]);
+		if ((rc = ops->read_emulated((unsigned long)c->dst.ptr,
+						&c->dst.val,
+						c->dst.bytes,
+						ctxt->vcpu)) != 0)
+			goto done;
+
+		DPRINTF("cmps: mem1=0x%p mem2=0x%p\n", c->src.ptr, c->dst.ptr);
+
+		emulate_2op_SrcV("cmp", c->src, c->dst, ctxt->eflags);
+
+		register_address_increment(c->regs[VCPU_REGS_RSI],
+				       (ctxt->eflags & EFLG_DF) ? -c->src.bytes
+								  : c->src.bytes);
+		register_address_increment(c->regs[VCPU_REGS_RDI],
+				       (ctxt->eflags & EFLG_DF) ? -c->dst.bytes
+								  : c->dst.bytes);
+
+		break;
 	case 0xaa ... 0xab:	/* stos */
 		c->dst.type = OP_MEM;
 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
-- 
1.5.3.7

