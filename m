Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbYAPOXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbYAPOXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 09:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYAPOXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 09:23:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50299 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbYAPOXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 09:23:00 -0500
Date: Wed, 16 Jan 2008 15:22:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 0 of 4] x86: some more patches
Message-ID: <20080116142242.GA23993@elte.hu>
References: <patchbomb.1200435425@localhost> <20080115223534.GA20484@elte.hu> <478D4197.8060904@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478D4197.8060904@goop.org>
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

> Ingo Molnar wrote:
>> unfortunately they dont solve it:
>>
>>  [   92.042586] Freeing unused kernel memory: 328k freed
>>  [   92.091838] khelper used greatest stack depth: 6244 bytes left
>>  [   92.281738] init[1]: segfault at 00000004 ip 49471cbb sp bff8dbb0 error 4
>>  [   92.288761] init[1]: segfault at 00000004 ip 49471cbb sp bff8dbb0 error 4
>>  [   92.295763] init[1]: segfault at 00000004 ip 49471cbb sp bff8dbb0 error 4
>>  [...]
>>  [   97.312484] printk: 611046 messages suppressed.
>>
>> 32-bit, PAE and RAM above 4GB seems to be enough to trigger that bug.
>>   
>
> Bum.  We established that once you fix the accessors+sign extension 
> bug, there's another bug somewhere later on in the series.  Any chance 
> you could move "x86/pgtable: fix constant sign extension problem" to 
> be just after "x86/pgtable: unify pagetable accessors" and bisect the 
> following patches?

after a day of debugging i finally tracked it down to another 
unsigned-type and masking mismatch on PAE, caused by:

  Subject: x86: unify pgtable accessors which use supported_pte_mask
  From: Jeremy Fitzhardinge <jeremy@goop.org>

the fix is below.

I have to say, i'm less than impressed about the structure of that 
patch. The patch too was way too coarse for easy bisection. You did 
multiple nontrivial steps in the same patch.

I'm not going to apply such all-in-one patches to x86.git anymore, and 
will start straight with another patch you sent yesterday:

  Subject: x86: refactor mmu ops in paravirt.h
  2 files changed, 129 insertions(+), 88 deletions(-)

If anyone finds a problem in that patch we'll have a hard time figuring 
out what went wrong. Please split that patch up properly. To demonstrate 
the kind of splitup we need for such patches, i've done a sample splitup 
of the following patch in x86.git:

  Subject: x86/pgtable: unify pagetable accessors
  From: Jeremy Fitzhardinge <jeremy@goop.org>

and turned it into 6 easy-to-review and easy-to-validate patches. Each 
step is _provably trivial_, and even if something goes wrong, it's easy 
to figure out where the problem comes from. At each step, document in 
the patch description whether the patch is intended to cause any code 
changes or not.

	Ingo

Index: linux-x86.q/include/asm-x86/page.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/page.h
+++ linux-x86.q/include/asm-x86/page.h
@@ -11,7 +11,7 @@
 #ifdef __KERNEL__
 
 #define PHYSICAL_PAGE_MASK	(PAGE_MASK & __PHYSICAL_MASK)
-#define PTE_MASK		PHYSICAL_PAGE_MASK
+#define PTE_MASK		(_AT(long, PHYSICAL_PAGE_MASK))
 
 #define LARGE_PAGE_SIZE		(_AC(1,UL) << PMD_SHIFT)
 #define LARGE_PAGE_MASK		(~(LARGE_PAGE_SIZE-1))
