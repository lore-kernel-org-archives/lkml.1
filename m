Return-Path: <linux-kernel-owner+w=401wt.eu-S1760143AbZDGSSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760143AbZDGSSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 14:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbZDGSSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 14:18:22 -0400
Received: from sh.osrg.net ([192.16.179.4]:47845 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757044AbZDGSSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 14:18:21 -0400
Date: Wed, 8 Apr 2009 03:18:00 +0900
To: galak@kernel.crashing.org
Cc: fujita.tomonori@lab.ntt.co.jp, beckyb@kernel.crashing.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, jeremy@goop.org,
       ian.campbell@citrix.com
Subject: Re: [PATCH 5/7] swiotlb: (re)Create swiotlb_unmap_single
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <726BF449-4F7A-472D-AC5A-D8218B61210B@kernel.crashing.org>
References: <77EA4458-602F-4DA9-B7E7-E48B5B0DCF91@kernel.crashing.org>
	<20090408022241U.fujita.tomonori@lab.ntt.co.jp>
	<726BF449-4F7A-472D-AC5A-D8218B61210B@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090408031541G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 08 Apr 2009 03:18:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009 12:32:12 -0500
Kumar Gala <galak@kernel.crashing.org> wrote:

> 
> On Apr 7, 2009, at 12:22 PM, FUJITA Tomonori wrote:
> 
> > On Tue, 7 Apr 2009 11:50:56 -0500
> > Kumar Gala <galak@kernel.crashing.org> wrote:
> >
> >>
> >> On Apr 7, 2009, at 11:37 AM, FUJITA Tomonori wrote:
> >>
> >>> On Tue, 7 Apr 2009 10:32:20 -0500
> >>> Kumar Gala <galak@kernel.crashing.org> wrote:
> >>>
> >>>>
> >>>> On Apr 7, 2009, at 4:09 AM, FUJITA Tomonori wrote:
> >>>>
> >>>>> On Tue, 7 Apr 2009 01:34:44 -0500
> >>>>> Kumar Gala <galak@kernel.crashing.org> wrote:
> >>>>>
> >>>>>>
> >>>>>> On Apr 6, 2009, at 9:24 PM, FUJITA Tomonori wrote:
> >>>>>>
> >>>>>>> On Fri,  3 Apr 2009 20:56:47 -0500
> >>>>>>> Becky Bruce <beckyb@kernel.crashing.org> wrote:
> >>>>>>>
> >>>>>>>> This mirrors the current swiotlb_sync_single() setup
> >>>>>>>> where the swiotlb_unmap_single() function is static to this
> >>>>>>>> file and contains the logic required to determine if we need
> >>>>>>>> to call actual sync_single.  Previously, swiotlb_unmap_page
> >>>>>>>> and swiotlb_unmap_sg were duplicating very similar code.
> >>>>>>>> The duplicated code has also been reformatted for
> >>>>>>>> readability.
> >>>>>>>>
> >>>>>>>> Note that the swiotlb_unmap_sg code was previously doing
> >>>>>>>> a complicated comparison to determine if an addresses needed
> >>>>>>>> to be unmapped where a simple is_swiotlb_buffer() call
> >>>>>>>> would have sufficed.
> >>>>>>>>
> >>>>>>>> Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
> >>>>>>>> ---
> >>>>>>>> lib/swiotlb.c |   36 +++++++++++++++++++++++-------------
> >>>>>>>> 1 files changed, 23 insertions(+), 13 deletions(-)
> >>>>>>>>
> >>>>>>>> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> >>>>>>>> index af2ec25..602315b 100644
> >>>>>>>> --- a/lib/swiotlb.c
> >>>>>>>> +++ b/lib/swiotlb.c
> >>>>>>>
> >>>>>>> I don't think 'swiotlb_unmap_single' name is appropriate.
> >>>>>>>
> >>>>>>> swiotlb_unmap_single sounds like an exported function that  
> >>>>>>> IOMMUs
> >>>>>>> can
> >>>>>>> use (and it was) however it should not be.
> >>>>>>
> >>>>>> What do you suggest we call it?  __swiotlb_unmap_single.
> >>>>>
> >>>>> I think that __swiotlb_unmap_single is better because the name
> >>>>> implies
> >>>>> that it's an internal function. It's fine by me.
> >>>>>
> >>>>> If it is odd that __swiotlb_unmap_single() is just a wrapper
> >>>>> function
> >>>>> of unmap_single(), which does the real job to unmap a dma mapping,
> >>>>> it
> >>>>> might be another possible option to rename unmap_single to
> >>>>> do_unamp_single and use unmap_single.
> >>>>
> >>>> I think you lost me here.  I'd prefer to just use
> >>>> __swiotlb_unmap_single at this point and get this code into the  
> >>>> tree
> >>>> and work on such renaming after the fact (if that's ok).
> >>>
> >>> If you are rushing to merge this right now, the original patchset is
> >>> fine by me (I thought that you missed this merge window). I'll  
> >>> rename
> >>> it later.
> >>
> >> We probably did, but one can never tell with these things.  It seemed
> >> like Ingo merged and pushed some swiotlb changes late in the game  
> >> for .
> >> 29
> >
> > Well, merging patches that have not been tested linux-next late is
> > what we should not do, I guess. I like to see Becky's patch in 2.6.30
> > because I have some swiotlb changes for 2.6.31 though.
> 
> Same here.  It makes it easier for us to work on the powerpc arch  
> specific changes for .31 if we can get these into .30.  What are you  
> looking at for .31?

I need to finish the dma_mapping_ops cleanups and cross-arch
unification stuff:

http://marc.info/?l=linux-kernel&m=123827903216314&w=2

But the changes to swiotlb is minor. BTW, I have the patches for
powerpc too.


> Ingo, any comments on that?
