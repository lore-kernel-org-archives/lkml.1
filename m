Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbYANWqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbYANWqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYANWqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:46:44 -0500
Received: from gw.goop.org ([64.81.55.164]:40977 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbYANWqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:46:44 -0500
Message-ID: <478BE628.7090008@goop.org>
Date: Mon, 14 Jan 2008 14:46:00 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: unify pagetable accessors patch causes double fault II
References: <20080114094814.GA28300@basil.nowhere.org> <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu> <20080114135811.GA16190@one.firstfloor.org> <478BDC43.6050105@goop.org> <20080114222349.GA23409@one.firstfloor.org>
In-Reply-To: <20080114222349.GA23409@one.firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
>   

Can you try this out?  It applies after "x86: move all asm/pgtable 
constants into one place".


Subject: x86/pgtable: fix constant sign extension problem

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

---
 include/asm-x86/pgtable.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

===================================================================
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -19,18 +19,18 @@
 #define _PAGE_BIT_UNUSED3	11
 #define _PAGE_BIT_NX		63       /* No execute: only valid after cpuid check */
 
-#define _PAGE_PRESENT	(_AC(1, UL)<<_PAGE_BIT_PRESENT)
-#define _PAGE_RW	(_AC(1, UL)<<_PAGE_BIT_RW)
-#define _PAGE_USER	(_AC(1, UL)<<_PAGE_BIT_USER)
-#define _PAGE_PWT	(_AC(1, UL)<<_PAGE_BIT_PWT)
-#define _PAGE_PCD	(_AC(1, UL)<<_PAGE_BIT_PCD)
-#define _PAGE_ACCESSED	(_AC(1, UL)<<_PAGE_BIT_ACCESSED)
-#define _PAGE_DIRTY	(_AC(1, UL)<<_PAGE_BIT_DIRTY)
-#define _PAGE_PSE	(_AC(1, UL)<<_PAGE_BIT_PSE)	/* 2MB page */
-#define _PAGE_GLOBAL	(_AC(1, UL)<<_PAGE_BIT_GLOBAL)	/* Global TLB entry */
-#define _PAGE_UNUSED1	(_AC(1, UL)<<_PAGE_BIT_UNUSED1)
-#define _PAGE_UNUSED2	(_AC(1, UL)<<_PAGE_BIT_UNUSED2)
-#define _PAGE_UNUSED3	(_AC(1, UL)<<_PAGE_BIT_UNUSED3)
+#define _PAGE_PRESENT	(_AC(1, L)<<_PAGE_BIT_PRESENT)
+#define _PAGE_RW	(_AC(1, L)<<_PAGE_BIT_RW)
+#define _PAGE_USER	(_AC(1, L)<<_PAGE_BIT_USER)
+#define _PAGE_PWT	(_AC(1, L)<<_PAGE_BIT_PWT)
+#define _PAGE_PCD	(_AC(1, L)<<_PAGE_BIT_PCD)
+#define _PAGE_ACCESSED	(_AC(1, L)<<_PAGE_BIT_ACCESSED)
+#define _PAGE_DIRTY	(_AC(1, L)<<_PAGE_BIT_DIRTY)
+#define _PAGE_PSE	(_AC(1, L)<<_PAGE_BIT_PSE)	/* 2MB page */
+#define _PAGE_GLOBAL	(_AC(1, L)<<_PAGE_BIT_GLOBAL)	/* Global TLB entry */
+#define _PAGE_UNUSED1	(_AC(1, L)<<_PAGE_BIT_UNUSED1)
+#define _PAGE_UNUSED2	(_AC(1, L)<<_PAGE_BIT_UNUSED2)
+#define _PAGE_UNUSED3	(_AC(1, L)<<_PAGE_BIT_UNUSED3)
 
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 #define _PAGE_NX	(_AC(1, ULL) << _PAGE_BIT_NX)



