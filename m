Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbYAONxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbYAONxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 08:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbYAONxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 08:53:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35642 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbYAONxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 08:53:30 -0500
Date: Tue, 15 Jan 2008 14:53:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: unify pagetable accessors patch causes double fault II
Message-ID: <20080115135317.GA13493@elte.hu>
References: <20080114094814.GA28300@basil.nowhere.org> <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu> <20080114135811.GA16190@one.firstfloor.org> <478BDC43.6050105@goop.org> <20080114222349.GA23409@one.firstfloor.org> <478BE628.7090008@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478BE628.7090008@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Can you try this out?  It applies after "x86: move all asm/pgtable 
> constants into one place".

and here's the patch

Subject: Re: unify pagetable accessors patch causes double fault II
From: Jeremy Fitzhardinge <jeremy@goop.org>

Andi Kleen wrote:
>> OK, I see the problem.  The problem is that the _PAGE_X defines are
>> defined with _AC(UL, 1 << _PAGE_BIT_X), which has unsigned long type.
>> This means that ~_PAGE_X also has unsigned long type, and so when cast
>> to 64-bit in pte_mkX, it ends up &ing the pte with 0x00000000ffffffxxx,
>> with predictable results.
>>
>
> Actually I fixed some of that -- see the pgtable-nx patch on firstfloor -- but
> it still doesn't work. Or maybe my patch was not complete.
>

Yeah, that looks like the right sort of thing, but I wonder if there's
other places doing an open-coded "pte_val(pte) & ~_PAGE_FOO".  My patch
changes the definition of _PAGE_FOO so it should be OK everywhere.

>> The original code just used signed constants for the _PAGE_X
>> definitions, which will sign-extend when cast to 64-bit, and so have the
>> upper bits set when masking.  (Well, actually, the old code just
>> operated on pte_low, so the problem didn't arise; however, pgtable_64.h
>> also uses integers for its _PAGE_X, which has the same sign-extended
>> 32->64 casting property).
>>
>> I'll put together a fixup patch now.
>>
>
> I'm leaving now but can test later.

and below is the fix against full x86.git#mm.

	Ingo

----------->
Subject: x86/pgtable: fix constant sign extension problem
From: Jeremy Fitzhardinge <jeremy@goop.org>

When the _PAGE_FOO constants are defined as (1ul << _PAGE_BIT_FOO), they
become unsigned longs.  In 32-bit PAE mode, these end up being
implicitly cast to 64-bit types when used to manipulate a pte, and
because they're unsigned the top 32-bits are 0, destroying the upper
bits of the pte.

When _PAGE_FOO constants are given a signed integer type, the cast to
64-bits will sign-extend so that the upper bits are all ones,
preserving the upper pte bits in manipulations.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/pgtable.h |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

===================================================================
Index: linux-x86.q/include/asm-x86/pgtable.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/pgtable.h
+++ linux-x86.q/include/asm-x86/pgtable.h
@@ -19,21 +19,26 @@
 #define _PAGE_BIT_UNUSED3	11
 #define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
 
-#define _PAGE_PRESENT	(_AC(1, UL)<<_PAGE_BIT_PRESENT)
-#define _PAGE_RW	(_AC(1, UL)<<_PAGE_BIT_RW)
-#define _PAGE_USER	(_AC(1, UL)<<_PAGE_BIT_USER)
-#define _PAGE_PWT	(_AC(1, UL)<<_PAGE_BIT_PWT)
-#define _PAGE_PCD	((_AC(1, UL)<<_PAGE_BIT_PCD) | _PAGE_PWT)
-#define _PAGE_ACCESSED	(_AC(1, UL)<<_PAGE_BIT_ACCESSED)
-#define _PAGE_DIRTY	(_AC(1, UL)<<_PAGE_BIT_DIRTY)
-#define _PAGE_PSE	(_AC(1, UL)<<_PAGE_BIT_PSE)	/* 2MB page */
-#define _PAGE_GLOBAL	(_AC(1, UL)<<_PAGE_BIT_GLOBAL)	/* Global TLB entry */
+/*
+ * Note: we use _AC(1, L) instead of _AC(1, UL) so that we get a
+ * sign-extended value on 32-bit with all 1's in the upper word,
+ * which preserves the upper pte values on 64-bit ptes:
+ */
+#define _PAGE_PRESENT	(_AC(1, L)<<_PAGE_BIT_PRESENT)
+#define _PAGE_RW	(_AC(1, L)<<_PAGE_BIT_RW)
+#define _PAGE_USER	(_AC(1, L)<<_PAGE_BIT_USER)
+#define _PAGE_PWT	(_AC(1, L)<<_PAGE_BIT_PWT)
+#define _PAGE_PCD	((_AC(1, L)<<_PAGE_BIT_PCD) | _PAGE_PWT)
+#define _PAGE_ACCESSED	(_AC(1, L)<<_PAGE_BIT_ACCESSED)
+#define _PAGE_DIRTY	(_AC(1, L)<<_PAGE_BIT_DIRTY)
+#define _PAGE_PSE	(_AC(1, L)<<_PAGE_BIT_PSE)	/* 2MB page */
+#define _PAGE_GLOBAL	(_AC(1, L)<<_PAGE_BIT_GLOBAL)	/* Global TLB entry */
 /* We redefine PCD to be write combining. PAT bit is not used */
-#define _PAGE_WC	((_AC(1, UL)<<_PAGE_BIT_PCD))
+#define _PAGE_WC	((_AC(1, L)<<_PAGE_BIT_PCD))
 #define _PAGE_CACHE_MASK (_PAGE_PCD)
-#define _PAGE_UNUSED1	(_AC(1, UL)<<_PAGE_BIT_UNUSED1)
-#define _PAGE_UNUSED2	(_AC(1, UL)<<_PAGE_BIT_UNUSED2)
-#define _PAGE_UNUSED3	(_AC(1, UL)<<_PAGE_BIT_UNUSED3)
+#define _PAGE_UNUSED1	(_AC(1, L)<<_PAGE_BIT_UNUSED1)
+#define _PAGE_UNUSED2	(_AC(1, L)<<_PAGE_BIT_UNUSED2)
+#define _PAGE_UNUSED3	(_AC(1, L)<<_PAGE_BIT_UNUSED3)
 
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 #define _PAGE_NX	(_AC(1, ULL) << _PAGE_BIT_NX)
