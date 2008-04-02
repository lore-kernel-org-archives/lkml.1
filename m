Return-Path: <linux-kernel-owner+w=401wt.eu-S1761150AbYDBSkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761150AbYDBSkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757969AbYDBSfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:35:44 -0400
Received: from 21.sub-75-208-3.myvzw.com ([75.208.3.21]:38414 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757305AbYDBSfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:35:40 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 21 of 24] xen: allow set_pte_at on init_mm to be lockless
X-Mercurial-Node: 3d98a7a43a629aa069cc8391cd93859e0db9d84b
Message-Id: <3d98a7a43a629aa069cc.1207158850@localhost>
In-Reply-To: <patchbomb.1207158829@localhost>
Date: Wed, 02 Apr 2008 10:54:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usual pagetable locking protocol doesn't seem to apply to updates
to init_mm, so don't rely on preemption being disabled in xen_set_pte_at
on init_mm.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -156,6 +156,10 @@
 void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
 		    pte_t *ptep, pte_t pteval)
 {
+	/* updates to init_mm may be done without lock */
+	if (mm == &init_mm)
+		preempt_disable();
+
 	if (mm == current->mm || mm == &init_mm) {
 		if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU) {
 			struct multicall_space mcs;
@@ -163,12 +167,16 @@
 
 			MULTI_update_va_mapping(mcs.mc, addr, pteval, 0);
 			xen_mc_issue(PARAVIRT_LAZY_MMU);
-			return;
+			goto out;
 		} else
 			if (HYPERVISOR_update_va_mapping(addr, pteval, 0) == 0)
-				return;
+				goto out;
 	}
 	xen_set_pte(ptep, pteval);
+
+out:
+	if (mm == &init_mm)
+		preempt_enable();
 }
 
 pteval_t xen_pte_val(pte_t pte)


