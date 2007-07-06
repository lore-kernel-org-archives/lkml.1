Return-Path: <linux-kernel-owner+w=401wt.eu-S1764190AbXGFV0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764190AbXGFV0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 17:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761848AbXGFV0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 17:26:44 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:42029 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752567AbXGFV0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 17:26:43 -0400
Message-ID: <468EB162.5080006@vmware.com>
Date: Fri, 06 Jul 2007 14:17:22 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Carsten Otte <cotte@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] VMI: remove CONFIG_DEBUG_PAGE_TYPE and associated	bitrotted
 code
References: <Pine.LNX.4.64.0707060847470.23786@localhost.localdomain>	<468E890A.1070504@s5r6.in-berlin.de>	<20070706201625.GT4306@sequoia.sous-sol.org> <468EA27C.9060401@vmware.com> <468EA5E0.4070501@goop.org> <468EA74D.7010706@vmware.com> <468EADB9.9050802@goop.org>
In-Reply-To: <468EADB9.9050802@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Zachary Amsden wrote:
>> I though about it, but it gets really ugly.  You need wrappers for 
>> all the MMU ops in pvops generic code, which means either another 
>> layer of wrappers or a bunch of CONFIG_DEBUG_PARAVIRT
>
> Oh, yes, more wrappers please!  We could do it at the paravirt_ops 
> level: set up your pv_ops, then call paravirt_debug_mmuops(), which 
> would save away your ops and replace them with wrappers.  That basic 
> structure would lend itself to all kinds of paravirt-level debugging 
> tools.
>
> It would be a bit more elegant if we had mmu_ops.  Maybe we should do 
> that splitup before 64bit?

zamsden strongly agrees jsgf.

>> only things that are easy to break because they also depend on PAE 
>> vs. non-PAE.
>
> Hm, would they?  Would they need to inspect the content of the pte_t 
> (etc), or just look at the struct page for the page being updated?  
> (pmd operations being a bit more awkward, of course.)

No, but there are different sets of operations and different sets of 
validation rules (for example, multiple PGDs per page for PAE, depending 
on pgd allocation size).

> Well, I have to say that keeping the hypervisor hints in sync with the 
> actual kernel-level page state worries me, so any debug tools which 
> could help there would be good.  This seems like it should be the 
> right place to do it, but I can't say I've thought about it in any 
> detail.

Yes, these things are subtle and easy to break.  In fact, still broken 
(although in a different way) - check out this naked write to a pte:

arch/i386/mm/init.c:            pte->pte_high &= ~(1 << (_PAGE_BIT_NX - 
32));
arch/i386/mm/init.c:            pte->pte_high |= 1 << (_PAGE_BIT_NX - 32);

Not only has page typing created a dependence on the guest accurately 
representing page state to the hypervisor, it also requires the guest to 
use proper APIs for access to those pages.  That is much harder to 
enforce - perhaps static checking can get some of the way there.

The page type debugging is certainly a start in a good direction.

> Of course, if it *is* helpful to the page hinting patches, then it 
> suggests that it's a facility with wider scope than pv-ops.

I certainly think it's not wide enough to justify a new struct page 
field, but perhaps a debug-only field is commonly useful; those pg bits 
are getting quite crammed.

Zach
