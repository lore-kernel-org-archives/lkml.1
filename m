Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbXFSUli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbXFSUli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757887AbXFSUlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:41:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:58673 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462AbXFSUlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:41:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=BkBnYFYDYugt72n15c8Vk6i7hac+qlkrDR3tQTpi9o5+vC4/NCLfLJyvlGPrWBudEFswHVKGNOLukE0inL4gAyG26toZkfjTRavwCZazT5BVTnPR/iDXXwIPAdZg6uDda4Sw5wnn+XW6wx6KXJiEdC3A/hPp+u0xSOLVQIgG3oQ=
Date: Tue, 19 Jun 2007 22:41:20 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: kvm-devel@lists.sourceforge.net
Cc: Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] kvm: Fix x86 emulator writeback
Message-ID: <20070619204120.GA18800@dreamland.darkstar.lan>
References: <68676e00706141627s3cb87391sa0ee6711d2f7933f@mail.gmail.com> <467256AA.1040001@qumranet.com> <20070615214915.GA10536@dreamland.darkstar.lan> <4673949B.1070505@qumranet.com> <20070617151452.GA21971@dreamland.darkstar.lan> <4675523C.9020703@qumranet.com> <20070617165201.GA23885@dreamland.darkstar.lan> <46765954.60102@qumranet.com> <46766D57.8040206@qumranet.com> <20070619202524.GA17672@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619202524.GA17672@dreamland.darkstar.lan>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When the old value and new one are the same the emulator skips the
write; this is undesiderable when the destination is a MMIO area and the
write shall be performed regardless of the previous value. This
optimization breaks e.g. a Linux guest APIC compiled without
X86_GOOD_APIC.

Remove the check and perform the writeback stage in the emulation unless
it's explicitly disabled (currently push and some 2 bytes instructions
may disable the writeback).

Signed-Off-By: Luca Tettamanti <kronos.it@gmail.com>

---

 Tested with Fedora7, Solaris10 and WinXP on a 32 bit host with Intel
 CPU.

 drivers/kvm/x86_emulate.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index a4a8481..eb10448 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -482,6 +482,7 @@ x86_emulate_memop(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	int mode = ctxt->mode;
 	unsigned long modrm_ea;
 	int use_modrm_ea, index_reg = 0, base_reg = 0, scale, rip_relative = 0;
+	int no_wb = 0;
 
 	/* Shadow copy of register state. Committed on successful emulation. */
 	unsigned long _regs[NR_VCPU_REGS];
@@ -1048,7 +1049,7 @@ done_prefixes:
 						      _regs[VCPU_REGS_RSP]),
 				     &dst.val, dst.bytes, ctxt)) != 0)
 				goto done;
-			dst.val = dst.orig_val;	/* skanky: disable writeback */
+			no_wb = 1;	/* skanky: disable writeback */
 			break;
 		default:
 			goto cannot_emulate;
@@ -1057,7 +1058,7 @@ done_prefixes:
 	}
 
 writeback:
-	if ((d & Mov) || (dst.orig_val != dst.val)) {
+	if (!no_wb) {
 		switch (dst.type) {
 		case OP_REG:
 			/* The 4-byte case *is* correct: in 64-bit mode we zero-extend. */
@@ -1306,7 +1307,7 @@ twobyte_insn:
 
 twobyte_special_insn:
 	/* Disable writeback. */
-	dst.orig_val = dst.val;
+	no_wb = 1;
 	switch (b) {
 	case 0x09:		/* wbinvd */
 		break;


Luca
-- 
Colui che sorride quando le cose vanno male ha pensato a qualcuno a cui
dare la colpa.
