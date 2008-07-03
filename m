Return-Path: <linux-kernel-owner+w=401wt.eu-S934438AbYGCHKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934438AbYGCHKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYGCG6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752929AbYGCFAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 01:00:49 -0400
Date: Wed, 2 Jul 2008 21:58:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: inux-next: Tree for July 1
Message-Id: <20080702215846.f6b0491b.akpm@linux-foundation.org>
In-Reply-To: <20080702215306.61367733.akpm@linux-foundation.org>
References: <20080702011434.6fb403d5.sfr@canb.auug.org.au>
	<20080702215306.61367733.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 21:53:06 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> s390 allmodconfig:
> 
> In file included from include/asm/pgtable.h:1087,
>                  from include/linux/mm.h:39,
>                  from arch/s390/mm/hugetlbpage.c:8:
> include/asm-generic/pgtable.h: In function '__ptep_modify_prot_start':
> include/asm-generic/pgtable.h:209: error: dereferencing pointer to incomplete type

OK, this wasn't very pretty:

--- a/include/asm-generic/pgtable.h~s390-build-fixes
+++ a/include/asm-generic/pgtable.h
@@ -197,17 +197,13 @@ static inline int pmd_none_or_clear_bad(
 }
 #endif /* CONFIG_MMU */
 
-static inline pte_t __ptep_modify_prot_start(struct mm_struct *mm,
-					     unsigned long addr,
-					     pte_t *ptep)
-{
-	/*
-	 * Get the current pte state, but zero it out to make it
-	 * non-present, preventing the hardware from asynchronously
-	 * updating it.
-	 */
-	return ptep_get_and_clear(mm, addr, ptep);
-}
+/*
+ * Get the current pte state, but zero it out to make it
+ * non-present, preventing the hardware from asynchronously
+ * updating it.
+ */
+#define __ptep_modify_prot_start(mm, addr, ptep)	\
+	ptep_get_and_clear(mm, addr, ptep)
 
 static inline void __ptep_modify_prot_commit(struct mm_struct *mm,
 					     unsigned long addr,
@@ -235,12 +231,8 @@ static inline void __ptep_modify_prot_co
  * queue the update to be done at some later time.  The update must be
  * actually committed before the pte lock is released, however.
  */
-static inline pte_t ptep_modify_prot_start(struct mm_struct *mm,
-					   unsigned long addr,
-					   pte_t *ptep)
-{
-	return __ptep_modify_prot_start(mm, addr, ptep);
-}
+#define ptep_modify_prot_start(mm, addr, ptep)		\
+	__ptep_modify_prot_start(mm, addr, ptep)
 
 /*
  * Commit an update to a pte, leaving any hardware-controlled bits in
_

