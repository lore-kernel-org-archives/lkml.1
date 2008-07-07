Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbYGGKkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbYGGKkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 06:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYGGKkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 06:40:41 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:50884 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbYGGKkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 06:40:41 -0400
Date: Mon, 7 Jul 2008 11:39:28 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: benh@kernel.crashing.org, cotte@de.ibm.com, Zan Lynx <zlynx@acm.org>,
       Ryan Hope <rmh3093@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Lockless/Get_User_Pages_Fast causes Xorg 1.4.99.* to lock
In-Reply-To: <200807071806.11630.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0807071134090.21480@blonde.site>
References: <48f7fe350807032326l1d68c94l531e44c09693b989@mail.gmail.com>
 <486E4FD8.4010102@acm.org> <Pine.LNX.4.64.0807042112130.16912@blonde.site>
 <200807071806.11630.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008, Nick Piggin wrote:
> 
> I think we need a similar fix for s390 too. If so, then it really should
> get into 2.6.26, but this late in the release, I hope an s390 maintainer
> might be able to test and verify the fix?

Wow, yes, I hadn't realized s390 is ahead of the game there: glad you're
back to spot that.  But yes, we'd prefer maintainer to confirm and push.


[PATCH]] s390: protect _PAGE_SPECIAL bit against mprotect

Stop mprotect's pte_modify from wiping out the s390 pte_special bit, which
caused oops thereafter when vm_normal_page thought X's abnormal was normal.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Hugh Dickins <hugh@veritas.com>
---
Index: linux-2.6/include/asm-s390/pgtable.h
===================================================================
--- linux-2.6.orig/include/asm-s390/pgtable.h
+++ linux-2.6/include/asm-s390/pgtable.h
@@ -223,6 +223,9 @@ extern char empty_zero_page[PAGE_SIZE];
 #define _PAGE_SPECIAL	0x004		/* SW associated with special page */
 #define __HAVE_ARCH_PTE_SPECIAL
 
+/* Set of bits not changed in pte_modify */
+#define _PAGE_CHG_MASK	(PAGE_MASK | _PAGE_SPECIAL)
+
 /* Six different types of pages. */
 #define _PAGE_TYPE_EMPTY	0x400
 #define _PAGE_TYPE_NONE		0x401
@@ -681,7 +684,7 @@ static inline void pte_clear(struct mm_s
  */
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
-	pte_val(pte) &= PAGE_MASK;
+	pte_val(pte) &= _PAGE_CHG_MASK;
 	pte_val(pte) |= pgprot_val(newprot);
 	return pte;
 }
