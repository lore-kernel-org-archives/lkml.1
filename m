Return-Path: <linux-kernel-owner+w=401wt.eu-S1758923AbYBEBXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923AbYBEBXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 20:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757146AbYBEBXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 20:23:00 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:9191 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597AbYBEBW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 20:22:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=V0evCMUKna0tezADF/K2UsvzqYHYTShYrK2WFjCp3JlAeUo2W7QnWuawJaYPtsLOLoL4ok+jEIxcMDzA7Z0iGAK8h73eqsRu7F1j4oHv22568gBhCxlRkl9OGGfwff9WhGTr9GZNr8yaNw0EtNUPS2bK2I8ymHULXApR8Y69iLY=
Subject: [PATCH 1/2] kvm: move address_mask define to static function
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Avi Kivity <avi@qumranet.com>, Yaniv Kamay <yaniv@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 17:22:57 -0800
Message-Id: <1202174577.6452.7.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kvm/x86_emulate.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 7958600..649e14d 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -427,11 +427,21 @@ static u16 twobyte_table[256] = {
 })
 
 /* Access/update address held in a register, based on addressing mode. */
-#define address_mask(reg)						\
-	((c->ad_bytes == sizeof(unsigned long)) ? 			\
-		(reg) :	((reg) & ((1UL << (c->ad_bytes << 3)) - 1)))
+static inline unsigned long ad_mask(struct decode_cache *c)
+{
+	return (1UL << (c->ad_bytes << 3)) - 1;
+}
+
+static unsigned long address_mask(struct decode_cache *c, unsigned long reg)
+{
+	if (c->ad_bytes == sizeof(unsigned long))
+		return reg;
+	else
+		return reg & ad_mask(c);
+}
+
 #define register_address(base, reg)                                     \
-	((base) + address_mask(reg))
+	((base) + address_mask(c, reg))
 #define register_address_increment(reg, inc)                            \
 	do {								\
 		/* signed type ensures sign extension to long */        \
@@ -1393,7 +1403,7 @@ special_insn:
 				1,
 				(c->d & ByteOp) ? 1 : c->op_bytes,
 				c->rep_prefix ?
-				address_mask(c->regs[VCPU_REGS_RCX]) : 1,
+				address_mask(c, c->regs[VCPU_REGS_RCX]) : 1,
 				(ctxt->eflags & EFLG_DF),
 				register_address(ctxt->es_base,
 						 c->regs[VCPU_REGS_RDI]),
@@ -1409,7 +1419,7 @@ special_insn:
 				0,
 				(c->d & ByteOp) ? 1 : c->op_bytes,
 				c->rep_prefix ?
-				address_mask(c->regs[VCPU_REGS_RCX]) : 1,
+				address_mask(c, c->regs[VCPU_REGS_RCX]) : 1,
 				(ctxt->eflags & EFLG_DF),
 				register_address(c->override_base ?
 							*c->override_base :
-- 
1.5.4.rc5.1138.g2602


