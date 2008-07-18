Return-Path: <linux-kernel-owner+w=401wt.eu-S1758396AbYGRMra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396AbYGRMra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbYGRMrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:47:23 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:30956 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbYGRMrW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:47:22 -0400
Message-Id: <4880AD11.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 18 Jul 2008 13:47:45 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: clean up pgd_{c,d}tor
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giving pgd_ctor() a properly typed parameter allows eliminating a local
variable. Adjust pgd_dtor() to match.

Also, pgd_ctor()'s clearing of the memory is redundant with the
GFP_ZERO used for allocating it.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/pgtable.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- linux-2.6.26/arch/x86/mm/pgtable.c	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-x86-pgd-alloc-cleanup/arch/x86/mm/pgtable.c	2008-06-25 14:35:40.000000000 +0200
@@ -62,14 +62,10 @@ static inline void pgd_list_del(pgd_t *p
 #define UNSHARED_PTRS_PER_PGD				\
 	(SHARED_KERNEL_PMD ? KERNEL_PGD_BOUNDARY : PTRS_PER_PGD)
 
-static void pgd_ctor(void *p)
+static void pgd_ctor(pgd_t *pgd)
 {
-	pgd_t *pgd = p;
 	unsigned long flags;
 
-	/* Clear usermode parts of PGD */
-	memset(pgd, 0, KERNEL_PGD_BOUNDARY*sizeof(pgd_t));
-
 	spin_lock_irqsave(&pgd_lock, flags);
 
 	/* If the pgd points to a shared pagetable level (either the
@@ -94,7 +90,7 @@ static void pgd_ctor(void *p)
 	spin_unlock_irqrestore(&pgd_lock, flags);
 }
 
-static void pgd_dtor(void *pgd)
+static void pgd_dtor(pgd_t *pgd)
 {
 	unsigned long flags; /* can be called from interrupt context */
 



