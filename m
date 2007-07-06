Return-Path: <linux-kernel-owner+w=401wt.eu-S1763769AbXGFVB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763769AbXGFVB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 17:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760058AbXGFVBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 17:01:49 -0400
Received: from gw.goop.org ([64.81.55.164]:58174 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759907AbXGFVBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 17:01:48 -0400
Message-ID: <468EADB9.9050802@goop.org>
Date: Fri, 06 Jul 2007 14:01:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
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
References: <Pine.LNX.4.64.0707060847470.23786@localhost.localdomain>	<468E890A.1070504@s5r6.in-berlin.de>	<20070706201625.GT4306@sequoia.sous-sol.org> <468EA27C.9060401@vmware.com> <468EA5E0.4070501@goop.org> <468EA74D.7010706@vmware.com>
In-Reply-To: <468EA74D.7010706@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> I though about it, but it gets really ugly.  You need wrappers for all 
> the MMU ops in pvops generic code, which means either another layer of 
> wrappers or a bunch of CONFIG_DEBUG_PARAVIRT

Oh, yes, more wrappers please!  We could do it at the paravirt_ops 
level: set up your pv_ops, then call paravirt_debug_mmuops(), which 
would save away your ops and replace them with wrappers.  That basic 
structure would lend itself to all kinds of paravirt-level debugging tools.

It would be a bit more elegant if we had mmu_ops.  Maybe we should do 
that splitup before 64bit?

> only things that are easy to break because they also depend on PAE vs. 
> non-PAE.

Hm, would they?  Would they need to inspect the content of the pte_t 
(etc), or just look at the struct page for the page being updated?  (pmd 
operations being a bit more awkward, of course.)

> It's doable, though, and might even be extensible to s390 for CMM page 
> type debugging, as well as descriptor type tracking and enforcement of 
> page isolation of GDTs.
>
> Page state tracking could track -
>
> PAGE_ZERO, PAGE_UNUSED, PAGE_STABLE, PAGE_VOLATILE, 
> PAGE_POTENTIALLY_VOLATILE, PAGE_L1{2/3/4}, PAGE_LDT, PAGE_GDT,
>
> actually, no this seems silly, since we'd just be duplicating bits for 
> the page types, so the only debug benefit is ensuring the intersection 
> of volatile and L{1/2/3/4} is nil, which is already trivially 
> verifiable by inspection. 

Well, I have to say that keeping the hypervisor hints in sync with the 
actual kernel-level page state worries me, so any debug tools which 
could help there would be good.  This seems like it should be the right 
place to do it, but I can't say I've thought about it in any detail.

Of course, if it *is* helpful to the page hinting patches, then it 
suggests that it's a facility with wider scope than pv-ops.

    J
