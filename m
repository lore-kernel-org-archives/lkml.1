Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbXLZLWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbXLZLWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbXLZLHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:07:08 -0500
Received: from il.qumranet.com ([82.166.9.18]:50490 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193AbXLZLGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:11 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Sheng Yang <sheng.yang@intel.com>
Subject: [PATCH 52/55] KVM: x86 emulator: modify 'lods', and 'stos' not to depend on CR2
Date: Wed, 26 Dec 2007 13:05:57 +0200
Message-Id: <1198667160-22953-53-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng.yang@intel.com>

The current 'lods' and 'stos' is depending on incoming CR2 rather than decode
memory address from registers.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index e697947..8e2162f 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1528,7 +1528,9 @@ special_insn:
 	case 0xaa ... 0xab:	/* stos */
 		c->dst.type = OP_MEM;
 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
-		c->dst.ptr = (unsigned long *)cr2;
+		c->dst.ptr = (unsigned long *)register_address(
+						   ctxt->es_base,
+						   c->regs[VCPU_REGS_RDI]);
 		c->dst.val = c->regs[VCPU_REGS_RAX];
 		register_address_increment(c->regs[VCPU_REGS_RDI],
 				       (ctxt->eflags & EFLG_DF) ? -c->dst.bytes
@@ -1538,9 +1540,13 @@ special_insn:
 		c->dst.type = OP_REG;
 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
 		c->dst.ptr = (unsigned long *)&c->regs[VCPU_REGS_RAX];
-		if ((rc = ops->read_emulated(cr2, &c->dst.val,
-					     c->dst.bytes,
-					     ctxt->vcpu)) != 0)
+		if ((rc = ops->read_emulated(register_address(
+				c->override_base ? *c->override_base :
+						   ctxt->ds_base,
+						 c->regs[VCPU_REGS_RSI]),
+						 &c->dst.val,
+						 c->dst.bytes,
+						 ctxt->vcpu)) != 0)
 			goto done;
 		register_address_increment(c->regs[VCPU_REGS_RSI],
 				       (ctxt->eflags & EFLG_DF) ? -c->dst.bytes
-- 
1.5.3.7

