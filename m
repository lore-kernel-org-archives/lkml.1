Return-Path: <linux-kernel-owner+w=401wt.eu-S1761617AbZCZXwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761617AbZCZXwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756993AbZCZXvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:51:50 -0400
Received: from ozlabs.org ([203.10.76.45]:59935 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754447AbZCZXvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:51:50 -0400
To: lguest@ozlabs.org
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 27 Mar 2009 10:21:40 +1030
Subject: [PATCH 1/5] lguest: fix spurious BUG_ON() on invalid guest stack.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903271021.41091.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix crash on misbehaving guest

gpte_addr() contains a BUG_ON(), insisting that the present flag is
set.  We need to return before we call it if that isn't the case.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/page_tables.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
--- a/drivers/lguest/page_tables.c
+++ b/drivers/lguest/page_tables.c
@@ -373,8 +373,10 @@ unsigned long guest_pa(struct lg_cpu *cp
 	/* First step: get the top-level Guest page table entry. */
 	gpgd = lgread(cpu, gpgd_addr(cpu, vaddr), pgd_t);
 	/* Toplevel not present?  We can't map it in. */
-	if (!(pgd_flags(gpgd) & _PAGE_PRESENT))
+	if (!(pgd_flags(gpgd) & _PAGE_PRESENT)) {
 		kill_guest(cpu, "Bad address %#lx", vaddr);
+		return -1UL;
+	}
 
 	gpte = lgread(cpu, gpte_addr(gpgd, vaddr), pte_t);
 	if (!(pte_flags(gpte) & _PAGE_PRESENT))

