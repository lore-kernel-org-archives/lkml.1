Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbYGCRsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbYGCRsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 13:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbYGCRsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 13:48:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753019AbYGCRsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 13:48:10 -0400
Date: Thu, 3 Jul 2008 10:46:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       apw@shadowen.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [BUILD-FAILURE] 2.6.26-rc8-mm1 - x86 -
 __ptep_modify_prot_start() missing
Message-Id: <20080703104643.04ea2acb.akpm@linux-foundation.org>
In-Reply-To: <20080703122943.GB6451@linux.vnet.ibm.com>
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>
	<20080703122943.GB6451@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2008 17:59:43 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 
> 2.6.26-rc8-mm1 kernel build fails on the x86
> 
>   CC      arch/x86/kernel/paravirt.o
> arch/x86/kernel/paravirt.c:383: error: _____ptep_modify_prot_start___ undeclared here (not in a function)
> make[1]: *** [arch/x86/kernel/paravirt.o] Error 1
> make: *** [arch/x86/kernel] Error 2
> 
> linux-next patches has the changes to the adds the function
> __ptep_modify_prot_start as inline, the patch s390-build-fixes.patch
> is coverting it into macro. Reverting the s390-build-fixes.patch
> fixes the build failure.

grump.  Who did all this stuff?

I dunno.  I'll drop s390-build-fixes.patch, add some ccs and stomp off.


From: Andrew Morton <akpm@linux-foundation.org>

In file included from include/asm/pgtable.h:1087,
                 from include/linux/mm.h:39,
                 from arch/s390/mm/hugetlbpage.c:8:
include/asm-generic/pgtable.h: In function '__ptep_modify_prot_start':
include/asm-generic/pgtable.h:209: error: dereferencing pointer to incomplete type

Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |   26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff -puN include/asm-generic/pgtable.h~s390-build-fixes include/asm-generic/pgtable.h
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


