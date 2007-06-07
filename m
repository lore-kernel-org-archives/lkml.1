Return-Path: <linux-kernel-owner+w=401wt.eu-S1764312AbXFGRah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764312AbXFGRah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbXFGRa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:30:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:41192 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbXFGRa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:30:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,395,1175497200"; 
   d="scan'208";a="236710720"
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Thu, 7 Jun 2007 10:30:14 -0700
User-Agent: KMail/1.9.6
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Justin Piszcz <jpiszcz@lucidpixels.com>
References: <200706061229.24486.jesse.barnes@intel.com> <m1wsygryw3.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1wsygryw3.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706071030.15317.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 7, 2007 12:45 am Eric W. Biederman wrote:
> Ok.  Overall this feels good but a few nits below.
> Would it make sense to split this into two patches.
> The first to just do the cleanup that removes the allocations
> for holding the mttr ranges?

I suppose we could split it, but it's small, and the only reason for 
removing the allocations was so that we could init it earlier.

> >  struct mtrr_state {
> > -	struct mtrr_var_range *var_ranges;
> > +	struct mtrr_var_range var_ranges[NUM_VAR_RANGES];
>
> Could we name it MAX_VAR_RANGES and not NUM_VAR_RANGES.
> In practices this is going to be 8 for every cpu I know of,
> so calling this NUM_VAR_RANGES may be a little confusing.

You're right, I should have kept the old name with MAX_ in it.  I'll fix 
it up.

> >  /* RED-PEN: this is accessed without any locking */
> > -extern unsigned int *usage_table;
> > +extern unsigned int usage_table[];
>
> I think that should be:
> > +extern unsigned int usage_table[NUM_VAR_RANGES];
>
> Or even better yet the declaration moved to a header file.

Oops, yeah, this should just be in mtrr.h.

> This looks like it will handle the common case, so I have no major
> objections to this code.
>
> At least in theory and possibly in practice there are a couple of
> corner cases we have missed her.
>
> - Overlapping MTRRs.

Overlapping should be ok, since that's usually intentional (e.g. one big 
wb range with a portion of uc space due to another mtrr).

> - What happens if we have uncached memory lower down?

Holes definitely aren't dealt with, but then we haven't seen any yet...

>   Except for performance problems I guess that case is relatively
> harmless. - Is it possible and worth it to amend the e820 map, so it
> shows the problem area as Reserved or otherwise not usable RAM?

That would be useful, but only if we moved the check to a little 
earlier, prior to the addition of the active ranges from the e820.  
Might be a little nicer than adjusting end_pfn, but will ultimately 
achieve the same thing...

Jesse
