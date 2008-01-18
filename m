Return-Path: <linux-kernel-owner+w=401wt.eu-S1759478AbYARAh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbYARAh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759804AbYARAgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:36:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759768AbYARAgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:36:04 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org
Subject: [PATCH 0/7] More lguest massage.
Date: Thu, 17 Jan 2008 22:35:48 -0200
Message-Id: <12006165743557-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12006165701019-git-send-email-gcosta@redhat.com>
References: <1200616550283-git-send-email-gcosta@redhat.com> <12006165571406-git-send-email-gcosta@redhat.com> <1200616561270-git-send-email-gcosta@redhat.com> <12006165651341-git-send-email-gcosta@redhat.com> <12006165701019-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpte_addr()does not depend on any guest information. So we wipe out
thelg parameter from it completely.

Signed-off-by:Glauber de Oliveira Costa <gcosta@redhat.com>
---
drivers/lguest/page_tables.c |    7 +++----
1 files changed, 3 insertions(+), 4 deletions(-)

diff--git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
indexc4b8eaf..c9acafc 100644
---a/drivers/lguest/page_tables.c
+++b/drivers/lguest/page_tables.c
@@-100,8 +100,7 @@ static unsigned long gpgd_addr(struct lg_cpu *cpu, unsigned long vaddr)
	return cpu->lg->pgdirs[cpu->cpu_pgd].gpgdir + index * sizeof(pgd_t);
}

-staticunsigned long gpte_addr(struct lguest *lg,
-			      pgd_t gpgd, unsigned long vaddr)
+staticunsigned long gpte_addr(pgd_t gpgd, unsigned long vaddr)
{
	unsigned long gpage = pgd_pfn(gpgd) << PAGE_SHIFT;
	BUG_ON(!(pgd_flags(gpgd) & _PAGE_PRESENT));
@@-235,7 +234,7 @@ int demand_page(struct lg_cpu *cpu, unsigned long vaddr, int errcode)

	/* OK, now we look at the lower level in the Guest page table: keep its
	 * address, because we might update it later. */
-	gpte_ptr= gpte_addr(lg, gpgd, vaddr);
+	gpte_ptr= gpte_addr(gpgd, vaddr);
	gpte = lgread(lg, gpte_ptr, pte_t);

	/* If this page isn't in the Guest page tables, we can't page it in. */
@@-378,7 +377,7 @@ unsigned long guest_pa(struct lg_cpu *cpu, unsigned long vaddr)
	if (!(pgd_flags(gpgd) & _PAGE_PRESENT))
		kill_guest(cpu->lg, "Bad address %#lx", vaddr);

-	gpte= lgread(cpu->lg, gpte_addr(cpu->lg, gpgd, vaddr), pte_t);
+	gpte= lgread(cpu->lg, gpte_addr(gpgd, vaddr), pte_t);
	if (!(pte_flags(gpte) & _PAGE_PRESENT))
		kill_guest(cpu->lg, "Bad address %#lx", vaddr);

--
1.5.0.6

