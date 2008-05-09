Return-Path: <linux-kernel-owner+w=401wt.eu-S934569AbYEIAek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934569AbYEIAek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 20:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbYEIAe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 20:34:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:62373 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbYEIAe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 20:34:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,457,1204531200"; 
   d="scan'208";a="244161382"
Date: Thu, 8 May 2008 17:34:24 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Rufus & Azrael <rufus-azrael@numericable.fr>,
       Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem error
Message-ID: <20080509003424.GA19710@linux-os.sc.intel.com>
References: <924EFEDD5F540B4284297C4DC59F3DEE010057B4@orsmsx423.amr.corp.intel.com> <4822A6F7.7010704@numericable.fr> <B5B0CFF685D7DF46A05CF1678CFB42ED20E04609@orsmsx423.amr.corp.intel.com> <20080508192555.GA8643@linux-os.sc.intel.com> <48235DA1.5060809@numericable.fr> <20080508213722.GA28372@linux-os.sc.intel.com> <482373C5.1060202@zytor.com> <20080508215931.GA5035@jamoon.sc.intel.com> <20080508234016.GA14169@linux-os.sc.intel.com> <482392C4.7080901@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482392C4.7080901@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 04:54:44PM -0700, H. Peter Anvin wrote:
> Venki Pallipadi wrote:
> >On Thu, May 08, 2008 at 02:59:31PM -0700, Venkatesh Pallipadi wrote:
> >>>
> >>I agree we need a better range check in place. But, the current one was 
> >>not
> >>really doing anything useful and actually causing the side-effect
> >>regression. So, I felt not having it is better solution for now.
> >>
> >>Other solution is to stay with start and end range check and just ignore 
> >>the
> >>range check error with WC overlap in case where UC_MINUS is requested.
> >>
> >>Given the way MTRRs are defined, the only way to do the full range check
> >>seems to be to go over page by page (from start to end), and check which
> >>variable range MTTR it matches with, which is obviously very excessive. 
> >>As,
> >>this is not a problem in typical usage scenario.
> >>
> 
> I don't believe that is true in the slightest.  You can iterate over the 
> variable MTRRs and see if any part of them overlaps the target range; 
> doing exhaustive enumeration is clearly bogus, especially on 64-bit 
> platforms.

What I meant was:
MTRRs are not really base and size. They are defined as base and mask.
Any addr is affected by mtrr if addr & mask == base & mask.
So, MTRR entry like
base = 0xf00000, mask = 0xff00000 with 36 bit physical address covers
0xf00000-0xffffff, 0x10f00000-0x10ffffff, 0x20f00000-0x20ffffff, ....

In this case if user is trying to mmap 0x1a000000-0x2a000000, we cannot really
cover this case with single parsing of variable address ranges. We will have
to go through the sub-ranges withing single variable range, which can be page
by page in worst case.
 
> >
> >Also, note that we only look for start while looking at fixed range MTRRs.
> >This is not as scary as it seems. We are finding the effective memory type
> >by just looking at the start of the address range. We still go through
> >the PAT reserve free mechanism, once we find the effective memory type
> >and that list will catch any other users with conflicting type anywhere
> >in the start to end range. And we will still keep effective type consistent
> >across all mappings.
> >
> 
> So what you're saying here is "it's bogus, but it doesn't really matter 
> anyway?"  Why bother having it at all, then?
> 
> Seriously, if it's not unconditionally correct, then:
> 
> a. it should be *clearly* labelled a heuristic.
> b. it should be *clearly* explained why having the heuristic is much 
> better than not having anything.
> 
> In this case, neither of those conditions appear to be addressed.

Agree that is has to be called a heuristic. Yes. Not having that will work
may be not as optimially. Having it gives us better starting point when we
start to find a proper memory type for requests, especially when there are
no other overlapping mappings in PAT list.

One of the reason for heristic was to get proper type for /dev/mem maps for WB
region (ACPI and BIOS area). /dev/mem checks to see the mtrr type of the start
address and starts with that type for the request. As long as there are no
other conflict in PAT list, we can give WB to this /dev/mem request. Not
having this heuristic we will have to most probably default to UC.

When there are overlapping PAT list entries, the mtrr_lookup does not matter
as we have to inherit things from those PAT entries or conflicting with them.

This discussion points to - code is not sufficiently commented and/or needs
some refactoring. Will look at this afresh tomorrow morning and see whether
I can some up with some better alternative.

Thanks,
Venki
Thanks,
Venki
