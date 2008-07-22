Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbYGVTA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbYGVTA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbYGVTAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:00:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:38373 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbYGVTAu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:00:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=Wlxo5vlUYuDQxslxuIxajiPvPPtYLzyIlER8PXiTw2uUqTd4TWB3PTF9N7BOB25Hi6
         Y5Wc0G58cPRW2ckKGT1avLhqUbZKVoevARNblYCiJtZs26i973SRtYy7oORrmZckIvNr
         szSF8o5050siydq+QrTZT80KGlSADa1QU0ghk=
Date: Tue, 22 Jul 2008 22:00:35 +0300
From: Pekka Paalanen <pq@iki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       "Steven Rostedt" <srostedt@redhat.com>, proski@gnu.org,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: [PATCH] x86: fix mmiotrace 8-bit register decoding
Message-ID: <20080722220035.0c193738@ct200006>
In-Reply-To: <19f34abd0806301441w52a9d9e7h42336e05e10f32a9@mail.gmail.com>
References: <20080628214626.5f9199d7@daedalus.pq.iki.fi>
	<20080630123736.GA4011@elte.hu>
	<20080630234837.118fff8c@daedalus.pq.iki.fi>
	<19f34abd0806301441w52a9d9e7h42336e05e10f32a9@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8321edde04244cc91470da5a7a71b79b704b0da1 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Mon, 21 Jul 2008 18:49:56 +0300
Subject: [PATCH] x86: fix mmiotrace 8-bit register decoding

When SIL, DIL, BPL or SPL registers were used in MMIO, the datum
was extracted from AH, BH, CH, or DH, which are incorrect.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---

This patch was cooked in Linus' tree because I couldn't get
linux-next to boot properly at the time. It applies cleanly to
tip/master though. Another problem I noticed is with non-page-aligned
mappings, but that's a different story.

 arch/x86/mm/pf_in.c |  121 +++++++++++++++++++++++++++++++++++----------------
 1 files changed, 84 insertions(+), 37 deletions(-)

diff --git a/arch/x86/mm/pf_in.c b/arch/x86/mm/pf_in.c
index efa1911..4d0bf36 100644
--- a/arch/x86/mm/pf_in.c
+++ b/arch/x86/mm/pf_in.c
@@ -79,25 +79,34 @@ static unsigned int mw32[] = { 0xC7 };
 static unsigned int mw64[] = { 0x89, 0x8B };
 #endif /* not __i386__ */
 
-static int skip_prefix(unsigned char *addr, int *shorted, int *enlarged,
-								int *rexr)
+struct prefix_bits {
+	unsigned shorted:1;
+	unsigned enlarged:1;
+	unsigned rexr:1;
+	unsigned rex:1;
+};
+
+static int skip_prefix(unsigned char *addr, struct prefix_bits *prf)
 {
 	int i;
 	unsigned char *p = addr;
-	*shorted = 0;
-	*enlarged = 0;
-	*rexr = 0;
+	prf->shorted = 0;
+	prf->enlarged = 0;
+	prf->rexr = 0;
+	prf->rex = 0;
 
 restart:
 	for (i = 0; i < ARRAY_SIZE(prefix_codes); i++) {
 		if (*p == prefix_codes[i]) {
 			if (*p == 0x66)
-				*shorted = 1;
+				prf->shorted = 1;
 #ifdef __amd64__
 			if ((*p & 0xf8) == 0x48)
-				*enlarged = 1;
+				prf->enlarged = 1;
 			if ((*p & 0xf4) == 0x44)
-				*rexr = 1;
+				prf->rexr = 1;
+			if ((*p & 0xf0) == 0x40)
+				prf->rex = 1;
 #endif
 			p++;
 			goto restart;
@@ -135,12 +144,12 @@ enum reason_type get_ins_type(unsigned long ins_addr)
 {
 	unsigned int opcode;
 	unsigned char *p;
-	int shorted, enlarged, rexr;
+	struct prefix_bits prf;
 	int i;
 	enum reason_type rv = OTHERS;
 
 	p = (unsigned char *)ins_addr;
-	p += skip_prefix(p, &shorted, &enlarged, &rexr);
+	p += skip_prefix(p, &prf);
 	p += get_opcode(p, &opcode);
 
 	CHECK_OP_TYPE(opcode, reg_rop, REG_READ);
@@ -156,10 +165,11 @@ static unsigned int get_ins_reg_width(unsigned long ins_addr)
 {
 	unsigned int opcode;
 	unsigned char *p;
-	int i, shorted, enlarged, rexr;
+	struct prefix_bits prf;
+	int i;
 
 	p = (unsigned char *)ins_addr;
-	p += skip_prefix(p, &shorted, &enlarged, &rexr);
+	p += skip_prefix(p, &prf);
 	p += get_opcode(p, &opcode);
 
 	for (i = 0; i < ARRAY_SIZE(rw8); i++)
@@ -168,7 +178,7 @@ static unsigned int get_ins_reg_width(unsigned long ins_addr)
 
 	for (i = 0; i < ARRAY_SIZE(rw32); i++)
 		if (rw32[i] == opcode)
-			return (shorted ? 2 : (enlarged ? 8 : 4));
+			return (prf.shorted ? 2 : (prf.enlarged ? 8 : 4));
 
 	printk(KERN_ERR "mmiotrace: Unknown opcode 0x%02x\n", opcode);
 	return 0;
@@ -178,10 +188,11 @@ unsigned int get_ins_mem_width(unsigned long ins_addr)
 {
 	unsigned int opcode;
 	unsigned char *p;
-	int i, shorted, enlarged, rexr;
+	struct prefix_bits prf;
+	int i;
 
 	p = (unsigned char *)ins_addr;
-	p += skip_prefix(p, &shorted, &enlarged, &rexr);
+	p += skip_prefix(p, &prf);
 	p += get_opcode(p, &opcode);
 
 	for (i = 0; i < ARRAY_SIZE(mw8); i++)
@@ -194,11 +205,11 @@ unsigned int get_ins_mem_width(unsigned long ins_addr)
 
 	for (i = 0; i < ARRAY_SIZE(mw32); i++)
 		if (mw32[i] == opcode)
-			return shorted ? 2 : 4;
+			return prf.shorted ? 2 : 4;
 
 	for (i = 0; i < ARRAY_SIZE(mw64); i++)
 		if (mw64[i] == opcode)
-			return shorted ? 2 : (enlarged ? 8 : 4);
+			return prf.shorted ? 2 : (prf.enlarged ? 8 : 4);
 
 	printk(KERN_ERR "mmiotrace: Unknown opcode 0x%02x\n", opcode);
 	return 0;
@@ -238,7 +249,7 @@ enum {
 #endif
 };
 
-static unsigned char *get_reg_w8(int no, struct pt_regs *regs)
+static unsigned char *get_reg_w8(int no, int rex, struct pt_regs *regs)
 {
 	unsigned char *rv = NULL;
 
@@ -255,18 +266,6 @@ static unsigned char *get_reg_w8(int no, struct pt_regs *regs)
 	case arg_DL:
 		rv = (unsigned char *)&regs->dx;
 		break;
-	case arg_AH:
-		rv = 1 + (unsigned char *)&regs->ax;
-		break;
-	case arg_BH:
-		rv = 1 + (unsigned char *)&regs->bx;
-		break;
-	case arg_CH:
-		rv = 1 + (unsigned char *)&regs->cx;
-		break;
-	case arg_DH:
-		rv = 1 + (unsigned char *)&regs->dx;
-		break;
 #ifdef __amd64__
 	case arg_R8:
 		rv = (unsigned char *)&regs->r8;
@@ -294,9 +293,55 @@ static unsigned char *get_reg_w8(int no, struct pt_regs *regs)
 		break;
 #endif
 	default:
-		printk(KERN_ERR "mmiotrace: Error reg no# %d\n", no);
 		break;
 	}
+
+	if (rv)
+		return rv;
+
+	if (rex) {
+		/*
+		 * If REX prefix exists, access low bytes of SI etc.
+		 * instead of AH etc.
+		 */
+		switch (no) {
+		case arg_SI:
+			rv = (unsigned char *)&regs->si;
+			break;
+		case arg_DI:
+			rv = (unsigned char *)&regs->di;
+			break;
+		case arg_BP:
+			rv = (unsigned char *)&regs->bp;
+			break;
+		case arg_SP:
+			rv = (unsigned char *)&regs->sp;
+			break;
+		default:
+			break;
+		}
+	} else {
+		switch (no) {
+		case arg_AH:
+			rv = 1 + (unsigned char *)&regs->ax;
+			break;
+		case arg_BH:
+			rv = 1 + (unsigned char *)&regs->bx;
+			break;
+		case arg_CH:
+			rv = 1 + (unsigned char *)&regs->cx;
+			break;
+		case arg_DH:
+			rv = 1 + (unsigned char *)&regs->dx;
+			break;
+		default:
+			break;
+		}
+	}
+
+	if (!rv)
+		printk(KERN_ERR "mmiotrace: Error reg no# %d\n", no);
+
 	return rv;
 }
 
@@ -368,11 +413,12 @@ unsigned long get_ins_reg_val(unsigned long ins_addr, struct pt_regs *regs)
 	unsigned char mod_rm;
 	int reg;
 	unsigned char *p;
-	int i, shorted, enlarged, rexr;
+	struct prefix_bits prf;
+	int i;
 	unsigned long rv;
 
 	p = (unsigned char *)ins_addr;
-	p += skip_prefix(p, &shorted, &enlarged, &rexr);
+	p += skip_prefix(p, &prf);
 	p += get_opcode(p, &opcode);
 	for (i = 0; i < ARRAY_SIZE(reg_rop); i++)
 		if (reg_rop[i] == opcode) {
@@ -392,10 +438,10 @@ unsigned long get_ins_reg_val(unsigned long ins_addr, struct pt_regs *regs)
 
 do_work:
 	mod_rm = *p;
-	reg = ((mod_rm >> 3) & 0x7) | (rexr << 3);
+	reg = ((mod_rm >> 3) & 0x7) | (prf.rexr << 3);
 	switch (get_ins_reg_width(ins_addr)) {
 	case 1:
-		return *get_reg_w8(reg, regs);
+		return *get_reg_w8(reg, prf.rex, regs);
 
 	case 2:
 		return *(unsigned short *)get_reg_w32(reg, regs);
@@ -422,11 +468,12 @@ unsigned long get_ins_imm_val(unsigned long ins_addr)
 	unsigned char mod_rm;
 	unsigned char mod;
 	unsigned char *p;
-	int i, shorted, enlarged, rexr;
+	struct prefix_bits prf;
+	int i;
 	unsigned long rv;
 
 	p = (unsigned char *)ins_addr;
-	p += skip_prefix(p, &shorted, &enlarged, &rexr);
+	p += skip_prefix(p, &prf);
 	p += get_opcode(p, &opcode);
 	for (i = 0; i < ARRAY_SIZE(imm_wop); i++)
 		if (imm_wop[i] == opcode) {
-- 
1.5.4.5

