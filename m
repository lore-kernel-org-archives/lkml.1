Return-Path: <linux-kernel-owner+w=401wt.eu-S1761247AbYDBSkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761247AbYDBSkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758046AbYDBSfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:35:46 -0400
Received: from 21.sub-75-208-3.myvzw.com ([75.208.3.21]:38415 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757315AbYDBSfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:35:40 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 20 of 24] xen: disable preemption during tlb flush
X-Mercurial-Node: 31e6dbedc4a20899f686541506b3696a77396af4
Message-Id: <31e6dbedc4a20899f686.1207158849@localhost>
In-Reply-To: <patchbomb.1207158829@localhost>
Date: Wed, 02 Apr 2008 10:54:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various places in the kernel flush the tlb even though preemption doens't
guarantee the tlb flush is happening on any particular CPU.  In many cases
this doesn't seem to matter, so don't make a fuss about it.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -532,26 +532,37 @@
 static void xen_flush_tlb(void)
 {
 	struct mmuext_op *op;
-	struct multicall_space mcs = xen_mc_entry(sizeof(*op));
+	struct multicall_space mcs;
+
+	preempt_disable();
+
+	mcs = xen_mc_entry(sizeof(*op));
 
 	op = mcs.args;
 	op->cmd = MMUEXT_TLB_FLUSH_LOCAL;
 	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
 
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
+
+	preempt_enable();
 }
 
 static void xen_flush_tlb_single(unsigned long addr)
 {
 	struct mmuext_op *op;
-	struct multicall_space mcs = xen_mc_entry(sizeof(*op));
+	struct multicall_space mcs;
 
+	preempt_disable();
+
+	mcs = xen_mc_entry(sizeof(*op));
 	op = mcs.args;
 	op->cmd = MMUEXT_INVLPG_LOCAL;
 	op->arg1.linear_addr = addr & PAGE_MASK;
 	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
 
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
+
+	preempt_enable();
 }
 
 static void xen_flush_tlb_others(const cpumask_t *cpus, struct mm_struct *mm,


