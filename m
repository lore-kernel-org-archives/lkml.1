Return-Path: <linux-kernel-owner+w=401wt.eu-S1763440AbZLQAaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763440AbZLQAaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763137AbZLQAaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:30:14 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:34239 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762942AbZLQAaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:30:11 -0500
Date: Thu, 17 Dec 2009 11:29:56 +1100
From: David Gibson <dwg@au1.ibm.com>
To: Benjamin Herrenschmidt <benh@au1.ibm.com>, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org
Cc: Sachin Sant <sachinp@in.ibm.com>,
       ". Jan-Bernd Themann" <THEMANN@de.ibm.com>,
       Thomas Q Klein <TKLEIN@de.ibm.com>
Subject: Fix stupid bug in subpge protection handling
Message-ID: <20091217002956.GQ9463@yookeroo>
Mail-Followup-To: David Gibson <dwg@au1.ibm.com>,
	Benjamin Herrenschmidt <benh@au1.ibm.com>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Sachin Sant <sachinp@in.ibm.com>,
	". Jan-Bernd Themann" <THEMANN@de.ibm.com>,
	Thomas Q Klein <TKLEIN@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d28513bc7f675d28b479db666d572e078ecf182d ("Fix bug in pagetable
cache cleanup with CONFIG_PPC_SUBPAGE_PROT"), itself a fix for
breakage caused by an earlier clean up patch of mine, contains a
stupid bug.  I changed the parameters of the subpage_protection()
function, but failed to update one of the callers.

This patch fixes it, and replaces a void * with a typed pointer so
that the compiler will warn on such an error in future.

Signed-off-by: David Gibson <dwg@au1.ibm.com>

Index: working-2.6/arch/powerpc/mm/hash_utils_64.c
===================================================================
--- working-2.6.orig/arch/powerpc/mm/hash_utils_64.c	2009-12-16 11:43:51.357324268 +1100
+++ working-2.6/arch/powerpc/mm/hash_utils_64.c	2009-12-16 11:44:35.473351990 +1100
@@ -879,7 +879,7 @@ static inline int subpage_protection(str
  */
 int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 {
-	void *pgdir;
+	pgd_t *pgdir;
 	unsigned long vsid;
 	struct mm_struct *mm;
 	pte_t *ptep;
@@ -1025,7 +1025,7 @@ int hash_page(unsigned long ea, unsigned
 	else
 #endif /* CONFIG_PPC_HAS_HASH_64K */
 	{
-		int spp = subpage_protection(pgdir, ea);
+		int spp = subpage_protection(mm, ea);
 		if (access & spp)
 			rc = -2;
 		else


-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
