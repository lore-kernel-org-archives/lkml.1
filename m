Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbYCCJNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbYCCJNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 04:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbYCCJNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 04:13:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57739 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595AbYCCJNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 04:13:23 -0500
Date: Mon, 3 Mar 2008 10:13:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: torvalds@linux-foundation.org, hans.rosenfeld@amd.com,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
Message-ID: <20080303091304.GA17911@elte.hu>
References: <20080301105646.2c8620d9@laptopd505.fenrus.org> <20080303074620.GC5934@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303074620.GC5934@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Could you try to hack up a debug patch perhaps? Uninline the 
> fucntion(s) then add two versions (one is that breaks on your box and 
> one is that works on your box) of this same pmd_bad()/pud_bad() 
> functions and do something like this (pseudocode):

i.e. something like the (tested) patch below. It is not clear whether 
your testcase is on 32-bit or 64-bit - so i went for the more likely 
32-bit case first.

	Ingo

------------------>
Subject: x86: patches/x86-debug-bad-page.patch
From: Ingo Molnar <mingo@elte.hu>
Date: Mon Mar 03 09:53:17 CET 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/pgtable_32.c     |    7 +++++++
 include/asm-x86/pgtable_32.h |    6 +++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

Index: linux-x86.q/arch/x86/mm/pgtable_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/pgtable_32.c
+++ linux-x86.q/arch/x86/mm/pgtable_32.c
@@ -381,3 +381,10 @@ void __pmd_free_tlb(struct mmu_gather *t
 }
 
 #endif
+
+int pmd_bad(pmd_t pmd)
+{
+	WARN_ON_ONCE(pmd_bad_v1(pmd) != pmd_bad_v2(pmd));
+
+	return pmd_bad_v1(pmd);
+}
Index: linux-x86.q/include/asm-x86/pgtable_32.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/pgtable_32.h
+++ linux-x86.q/include/asm-x86/pgtable_32.h
@@ -92,7 +92,11 @@ extern unsigned long pg0[];
 /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
 #define pmd_none(x)	(!(unsigned long)pmd_val(x))
 #define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
-#define	pmd_bad(x)	((pmd_val(x) \
+
+extern int pmd_bad(pmd_t pmd);
+
+#define pmd_bad_v1(x)	((pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
+#define	pmd_bad_v2(x)	((pmd_val(x) \
 			  & ~(PAGE_MASK | _PAGE_USER | _PAGE_PSE | _PAGE_NX)) \
 			 != _KERNPG_TABLE)
 
