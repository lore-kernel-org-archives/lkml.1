Return-Path: <linux-kernel-owner+w=401wt.eu-S1760680AbYBKTuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680AbYBKTuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbYBKTuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:50:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:61055 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756511AbYBKTuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:50:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,334,1199692800"; 
   d="scan'208";a="338243024"
Date: Mon, 11 Feb 2008 11:47:12 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, tglx@linutronix.de,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com
Subject: Re: [PATCH] [7/8] CPA: Don't flush caches on CPUs that support self-snoop
Message-ID: <20080211194712.GA21118@linux-os.sc.intel.com>
References: <200802111050.372086035@suse.de> <200802111627.23751.ak@suse.de> <20080211173606.GB21564@linux-os.sc.intel.com> <200802111858.46200.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802111858.46200.ak@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 06:58:46PM +0100, Andi Kleen wrote:
> On Monday 11 February 2008 18:36:06 Siddha, Suresh B wrote:
> > On Mon, Feb 11, 2008 at 04:27:23PM +0100, Andi Kleen wrote:
> > > 
> > > > > That is exactly the situation in pageattr.c. You're saying the manual
> > > > > is wrong here?
> > > > 
> > > > I'm saying that we are not following step 2 (marking the pages not present) 
> > > 
> > > Yes that's true. It's one of the design problems of the intent API that makes
> > > fixing this hard unfortunately.
> > 
> > BTW, making pages not present is required only while changing the attribute
> > from WB to WC or WC to WB. I think this step is for avoiding attribute aliasing
> > for speculative accesses. For UC, we don't have speculative accesses and such we
> > probably don't need it.
> 
> Ok that would imply that my patch is ok for all current in tree users at least
> (none of them ever set WC currently, only UC). It might not be safe for
> the out of tree WC users though.
> 
> So it should be ok to apply according to standard policy :)

There is atleast one issue though. For an I/O device which is not capable of
snooping the caches, if the driver model assumes that ioremap_nocache() will flush
the cpu caches(before initiating DMA), then the lack of cache flush in cpa() might
cause some breakages.

If there are any such usages, we should fix the driver models with a new API.

> 
> > So WC support through PAT should take care of it.
> 
> You mean the PAT patch should do something about it? Yes probably, but what?

marking the pages not present etc..

> > > (intent API assumes that the caller doesn't fully own the page to change, and
> > > if you can't control it 100% it is not possible to unmap it temporarily) 
> > 
> > True. Perhaps for WC chages we can assume the ownership?
> 
> Not assuming owner ship was the main reason why the intent change was originally
> submitted. I personally never quite understood the rationale for that,
> but the submitter and the maintainers apparently thought it a valuable
> thing to have, otherwise the patch would not have been written and included. 
> 
> You'll need to ask them if that has changed now.
> 
> At least if that requirement was dropped it would be possible to remove
> quite a lot of code from pageattr.c

I don't think we can drop that requirement for UC atleast. For WC, probably yes.

thanks,
suresh
