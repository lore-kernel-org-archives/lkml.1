Return-Path: <linux-kernel-owner+w=401wt.eu-S1763786AbYEHXkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763786AbYEHXkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbYEHXkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:40:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:46327 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbYEHXkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:40:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,456,1204531200"; 
   d="scan'208";a="562481116"
Date: Thu, 8 May 2008 16:40:17 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rufus & Azrael <rufus-azrael@numericable.fr>, Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem error
Message-ID: <20080508234016.GA14169@linux-os.sc.intel.com>
References: <924EFEDD5F540B4284297C4DC59F3DEE010050B6@orsmsx423.amr.corp.intel.com> <482217F3.2040900@numericable.fr> <924EFEDD5F540B4284297C4DC59F3DEE010057B4@orsmsx423.amr.corp.intel.com> <4822A6F7.7010704@numericable.fr> <B5B0CFF685D7DF46A05CF1678CFB42ED20E04609@orsmsx423.amr.corp.intel.com> <20080508192555.GA8643@linux-os.sc.intel.com> <48235DA1.5060809@numericable.fr> <20080508213722.GA28372@linux-os.sc.intel.com> <482373C5.1060202@zytor.com> <20080508215931.GA5035@jamoon.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508215931.GA5035@jamoon.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 02:59:31PM -0700, Venkatesh Pallipadi wrote:
> On Thu, May 08, 2008 at 02:42:29PM -0700, H. Peter Anvin wrote:
> > Venki Pallipadi wrote:
> > >On Thu, May 08, 2008 at 01:08:01PM -0700, Rufus & Azrael wrote:
> > >>   Venki Pallipadi a ecrit :
> > >>   >
> > >>   > Use UC_MINUS in reserve_memtype call with -1, when MTRR lookup fails 
> > >>   for
> > >>   any
> > >>   > reason.
> > >>   >
> > >>   > Change the logic in mtrr_type_lookup to just get the type from the 
> > >>   start
> > >>   > address. Using start and end adddress is not right/complete as start 
> > >>   and
> > >>   > end can be covered by different mtrr (where old code will fail) or
> > >>   > start and end can be in same mtrr, but still have some different
> > >>   > memory type region in between. Using only start is less restrictive 
> > >>   and
> > >>   > deterministic.
> > >>   >
> > >>   > Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > >>   >
> > >>   > ---
> > >>   >  arch/x86/kernel/cpu/mtrr/generic.c |    7 ++-----
> > >>   >  arch/x86/mm/pat.c                  |    8 +-------
> > >>   >  2 files changed, 3 insertions(+), 12 deletions(-)
> > >>   >
> > >>
> > 
> > Hm...
> > 
> > I have *serious* concerns about this; this might paper over this 
> > particular problem, but it just isn't *correct*.
> > 
> > The fact that the range check is implemented incorrectly is not an 
> > excuse to just dump it and ignore the problem; it should be fixed instead.
> > 
> 
> I agree we need a better range check in place. But, the current one was not
> really doing anything useful and actually causing the side-effect
> regression. So, I felt not having it is better solution for now.
> 
> Other solution is to stay with start and end range check and just ignore the
> range check error with WC overlap in case where UC_MINUS is requested.
> 
> Given the way MTRRs are defined, the only way to do the full range check
> seems to be to go over page by page (from start to end), and check which
> variable range MTTR it matches with, which is obviously very excessive. As,
> this is not a problem in typical usage scenario.
> 

Also, note that we only look for start while looking at fixed range MTRRs.
This is not as scary as it seems. We are finding the effective memory type
by just looking at the start of the address range. We still go through
the PAT reserve free mechanism, once we find the effective memory type
and that list will catch any other users with conflicting type anywhere
in the start to end range. And we will still keep effective type consistent
across all mappings.

For example:
0xf0000000-0xf1000000 is mapped WC by one user with appropriate MTRR setting
0xf2000000-0xf3000000 is mapped UC by another user with appropriate MTRR setting

Now if there is a request to map
0xf0000000-0xf4000000, we do mtrr_lookup and assume effective type for the
whole range is WC. Then we go through PAT list to see any conflicts. And
while parsing the list, we will find there is an overlap with conflicting
attributes and we fail the reserve.

In case the second UC mapping above is not present, we use effective memory
type for the whole range 0xf0000000-0xf4000000 as WC and track it in our list
that way.

Thanks,
Venki
