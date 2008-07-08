Return-Path: <linux-kernel-owner+w=401wt.eu-S1760157AbYGHXYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbYGHXYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757497AbYGHXPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:00 -0400
Received: from gw.goop.org ([64.81.55.164]:51228 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757410AbYGHXOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:45 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 37 of 55] xen64: xen_write_idt_entry() and cvt_gate_to_trap()
X-Mercurial-Node: 3eaa40381cdc251dbaab99c83f10bc90367989f4
Message-Id: <3eaa40381cdc251dbaab.1215554819@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@Rawhide-64.localdomain>

Changed to use the (to-be-)unified descriptor structs.

Signed-off-by: Eduardo Habkost <ehabkost@Rawhide-64.localdomain>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -401,23 +401,18 @@
 	preempt_enable();
 }
 
-static int cvt_gate_to_trap(int vector, u32 low, u32 high,
+static int cvt_gate_to_trap(int vector, const gate_desc *val,
 			    struct trap_info *info)
 {
-	u8 type, dpl;
-
-	type = (high >> 8) & 0x1f;
-	dpl = (high >> 13) & 3;
-
-	if (type != 0xf && type != 0xe)
+	if (val->type != 0xf && val->type != 0xe)
 		return 0;
 
 	info->vector = vector;
-	info->address = (high & 0xffff0000) | (low & 0x0000ffff);
-	info->cs = low >> 16;
-	info->flags = dpl;
+	info->address = gate_offset(*val);
+	info->cs = gate_segment(*val);
+	info->flags = val->dpl;
 	/* interrupt gates clear IF */
-	if (type == 0xe)
+	if (val->type == 0xe)
 		info->flags |= 4;
 
 	return 1;
@@ -444,11 +439,10 @@
 
 	if (p >= start && (p + 8) <= end) {
 		struct trap_info info[2];
-		u32 *desc = (u32 *)g;
 
 		info[1].address = 0;
 
-		if (cvt_gate_to_trap(entrynum, desc[0], desc[1], &info[0]))
+		if (cvt_gate_to_trap(entrynum, g, &info[0]))
 			if (HYPERVISOR_set_trap_table(info))
 				BUG();
 	}
@@ -461,13 +455,13 @@
 {
 	unsigned in, out, count;
 
-	count = (desc->size+1) / 8;
+	count = (desc->size+1) / sizeof(gate_desc);
 	BUG_ON(count > 256);
 
 	for (in = out = 0; in < count; in++) {
-		const u32 *entry = (u32 *)(desc->address + in * 8);
+		gate_desc *entry = (gate_desc*)(desc->address) + in;
 
-		if (cvt_gate_to_trap(in, entry[0], entry[1], &traps[out]))
+		if (cvt_gate_to_trap(in, entry, &traps[out]))
 			out++;
 	}
 	traps[out].address = 0;


