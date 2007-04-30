Return-Path: <linux-kernel-owner+w=401wt.eu-S1423224AbXD3NEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423224AbXD3NEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 09:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423227AbXD3NEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 09:04:37 -0400
Received: from ozlabs.org ([203.10.76.45]:45723 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423224AbXD3NEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 09:04:36 -0400
Subject: [PATCH] lguest: properly kill guest userspace programs accessing
	kernel mem
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: virtualization <virtualization@lists.linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 30 Apr 2007 23:04:19 +1000
Message-Id: <1177938259.30071.219.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel pages on x86 are protected by not having the _PAGE_USER bit
set.  When guest userspace accesses a kernel page, we didn't check
this, so we'd think we'd handled the fault and return to the guest,
causing the guest userspace program to loop instead of segfaulting.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/core.c        |    2 +-
 drivers/lguest/lg.h          |    2 +-
 drivers/lguest/page_tables.c |   12 ++++++++----
 3 files changed, 10 insertions(+), 6 deletions(-)

===================================================================
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -346,7 +346,7 @@ int run_guest(struct lguest *lg, char *_
 			}
 			break;
 		case 14: /* We've intercepted a page fault. */
-			if (demand_page(lg, cr2, lg->regs->errcode & 2))
+			if (demand_page(lg, cr2, lg->regs->errcode))
 				continue;
 
 			/* If lguest_data is NULL, this won't hurt. */
===================================================================
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -216,7 +216,7 @@ void guest_set_pte(struct lguest *lg, un
 void guest_set_pte(struct lguest *lg, unsigned long cr3,
 		   unsigned long vaddr, gpte_t val);
 void map_switcher_in_guest(struct lguest *lg, struct lguest_pages *pages);
-int demand_page(struct lguest *info, unsigned long cr2, int write);
+int demand_page(struct lguest *info, unsigned long cr2, int errcode);
 void pin_page(struct lguest *lg, unsigned long vaddr);
 
 /* lguest_user.c: */
===================================================================
--- a/drivers/lguest/page_tables.c
+++ b/drivers/lguest/page_tables.c
@@ -109,7 +109,7 @@ static void check_gpgd(struct lguest *lg
 
 /* We fault pages in, which allows us to update accessed/dirty bits.
  * Return true if we got page. */
-int demand_page(struct lguest *lg, unsigned long vaddr, int write)
+int demand_page(struct lguest *lg, unsigned long vaddr, int errcode)
 {
 	gpgd_t gpgd;
 	spgd_t *spgd;
@@ -138,12 +140,16 @@ int demand_page(struct lguest *lg, unsig
 		return 0;
 
 	/* Write to read-only page? */
-	if (write && !(gpte.flags & _PAGE_RW))
+	if ((errcode & 2) && !(gpte.flags & _PAGE_RW))
 		return 0;
+
+	/* User access to a non-user page? */
+	if ((errcode & 4) && !(gpte.flags & _PAGE_USER))
+		return 0;
 
 	check_gpte(lg, gpte);
 	gpte.flags |= _PAGE_ACCESSED;
-	if (write)
+	if (errcode & 2)
 		gpte.flags |= _PAGE_DIRTY;
 
 	/* We're done with the old pte. */
@@ -185,7 +200,7 @@ static int page_writable(struct lguest *
 
 void pin_page(struct lguest *lg, unsigned long vaddr)
 {
-	if (!page_writable(lg, vaddr) && !demand_page(lg, vaddr, 0))
+	if (!page_writable(lg, vaddr) && !demand_page(lg, vaddr, 2))
 		kill_guest(lg, "bad stack page %#lx", vaddr);
 }
 


