Return-Path: <linux-kernel-owner+w=401wt.eu-S1765495AbZCaXke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765495AbZCaXke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763725AbZCaXXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:23:00 -0400
Received: from sous-sol.org ([216.99.217.87]:52980 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757936AbZCaXW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:22:59 -0400
Message-Id: <20090331231809.935405052@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:28 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 43/45] lguest: fix spurious BUG_ON() on invalid guest stack.
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=lguest-fix-spurious-bug_on-on-invalid-guest-stack.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Rusty Russell <rusty@rustcorp.com.au>

upstream commit: 6afbdd059c27330eccbd85943354f94c2b83a7fe

Impact: fix crash on misbehaving guest

gpte_addr() contains a BUG_ON(), insisting that the present flag is
set.  We need to return before we call it if that isn't the case.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: stable@kernel.org
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/lguest/page_tables.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

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

