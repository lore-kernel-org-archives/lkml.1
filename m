Return-Path: <linux-kernel-owner+w=401wt.eu-S1761997AbYCFRq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761997AbYCFRq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 12:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbYCFRqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 12:46:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59540 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbYCFRqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 12:46:16 -0500
Date: Thu, 6 Mar 2008 18:45:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Adam Litke <agl@us.ibm.com>, Nishanth Aravamudan <nacc@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Eric Whitney <eric.whitney@hp.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG] 2.6.25-rc4 hang/softlockups after freeing hugepages
Message-ID: <20080306174520.GA29047@elte.hu>
References: <1204824183.5294.62.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204824183.5294.62.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> Test platform: HP Proliant DL585 server - 4 socket, dual core AMD with 
> 32GB memory.

does the patch below change the problem in any way? (it fixes a rare 
hugetlbfs related memory leak)

	Ingo

------------------>
Subject: x86: redo cded932b75ab0a5f9181e
From: Ingo Molnar <mingo@elte.hu>
Date: Mon Mar 03 13:55:32 CET 2008

redo commit cded932b75ab0a5f9181e.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/pgtable_32.h |    4 +++-
 include/asm-x86/pgtable_64.h |    6 ++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

Index: linux-x86.q/include/asm-x86/pgtable_32.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/pgtable_32.h
+++ linux-x86.q/include/asm-x86/pgtable_32.h
@@ -91,7 +91,9 @@ extern unsigned long pg0[];
 /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
 #define pmd_none(x)	(!(unsigned long)pmd_val(x))
 #define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
-#define	pmd_bad(x)	((pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
+#define	pmd_bad(x)	((pmd_val(x) \
+			  & ~(PAGE_MASK | _PAGE_USER | _PAGE_PSE | _PAGE_NX)) \
+			 != _KERNPG_TABLE)
 
 
 #define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))
Index: linux-x86.q/include/asm-x86/pgtable_64.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/pgtable_64.h
+++ linux-x86.q/include/asm-x86/pgtable_64.h
@@ -153,12 +153,14 @@ static inline unsigned long pgd_bad(pgd_
 
 static inline unsigned long pud_bad(pud_t pud)
 {
-	return pud_val(pud) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER);
+	return pud_val(pud) &
+		~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER | _PAGE_PSE | _PAGE_NX);
 }
 
 static inline unsigned long pmd_bad(pmd_t pmd)
 {
-	return pmd_val(pmd) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER);
+	return pmd_val(pmd) &
+		~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER | _PAGE_PSE | _PAGE_NX);
 }
 
 #define pte_none(x)	(!pte_val(x))
