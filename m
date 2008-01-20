Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbYATSA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbYATSA1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 13:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbYATSAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 13:00:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49170 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357AbYATSAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 13:00:14 -0500
Date: Sun, 20 Jan 2008 18:59:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com
Subject: Re: [PATCH] Fix early_ioremap on x86-64
Message-ID: <20080120175955.GA4993@elte.hu>
References: <20080120172840.GA24608@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080120172840.GA24608@basil.nowhere.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> Fix early_ioremap on x86-64
> 
> [Venki, sorry for blaming PAT for this earlier. It was innocent.] 
> [Note the patch is on top of git-x86 + gbpages applied. I think there 
> will be an trivial reject without gbpages-direct applied first]
> 
> I had ACPI failures on several machines since a few days. Symptom was 
> NUMA nodes not getting detected or worse cores not getting detected. 
> They all came from ACPI not being able to read various of its tables. 
> I finally bisected it down to Jeremy's "put _PAGE_GLOBAL into 
> PAGE_KERNEL" change. With that the fix was fairly obvious. The problem 
> was that early_ioremap() didn't use a "_all" flush that would affect 
> the global PTEs too. So with global bits getting used everywhere now 
> an early_ioremap would not actually flush a mapping if something else 
> was mapped previously on that slot (which can happen with 
> early_iounmap inbetween)
> 
> This patch changes all flushes in init_64.c to be __flush_tlb_all() 
> and fixes the problem here.

ah, very nice! This is the bad commit:

  ------------------------->
  Subject:  x86: fold _PAGE_GLOBAL into __PAGE_KERNEL
  From: Jeremy Fitzhardinge <jeremy@goop.org>

  With the iounmap problem resolved, it should be OK to always set
  _PAGE_GLOBAL in __PAGE_KERNEL*.

  [ Did this patch cause problems before? ]
  <------------------------

Jeremy did suspect something about this change, as indicated in the 
changelog. But because the change was so finegrained, the bisection 
almost directly led to the fix. _That_ i think clearly demonstrates the 
power of bisection and finegrained changes.

but note what the fundamental problem is - we've turned a previously 
safe flushing API into an unsafe one - __flush_tlb() will only be safe 
in the rarest of circumstances. There are some other matches:

 ./mm/init_64.c: __flush_tlb();
 ./kernel/head64.c:      __flush_tlb();

The boot identity mappings zapped do not have PGE set at the moment, but 
they could in the future (once we do native pagetable setup straight 
from flat mode) - and this is not a performance critical path anyway.

 ./kernel/cpu/mtrr/generic.c:    __flush_tlb();
 ./kernel/cpu/mtrr/generic.c:    __flush_tlb();

these include an open-coded version of __flush_tlb_all() so they are 
safe.

and we might as well make the non-PGE flush the 'special API'. I.e. 
rename __flush_tlb() to __flush_tlb_partial() and rename 
__flush_tlb_all() to __flush_tlb(). This makes it very apparent which 
should be used by default and which does what.

	Ingo
