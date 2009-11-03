Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbZKCVuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbZKCVuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 16:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbZKCVuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 16:50:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46199 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbZKCVuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 16:50:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCHv2 2/5] vmscan: Kill hibernation specific reclaim logic and unify it
Date: Tue, 3 Nov 2009 22:52:44 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
       "linux-mm" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20091103002520.886C.A69D9226@jp.fujitsu.com> <4AEF4CF1.3020500@crca.org.au> <20091103150928.0B42.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091103150928.0B42.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911032252.44175.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 November 2009, KOSAKI Motohiro wrote:
> > Hi.
> > 
> > KOSAKI Motohiro wrote:
> > >> I haven't given much thought to numa awareness in hibernate code, but I
> > >> can say that the shrink_all_memory interface is woefully inadequate as
> > >> far as zone awareness goes. Since lowmem needs to be atomically restored
> > >> before we can restore highmem, we really need to be able to ask for a
> > >> particular number of pages of a particular zone type to be freed.
> > > 
> > > Honestly, I am not suspend/hibernation expert. Can I ask why caller need to know
> > > per-zone number of freed pages information? if hibernation don't need highmem.
> > > following incremental patch prevent highmem reclaim perfectly. Is it enough?
> > 
> > (Disclaimer: I don't think about highmem a lot any more, and might have
> > forgotten some of the details, or swsusp's algorithms might have
> > changed. Rafael might need to correct some of this...)
> > 
> > Imagine that you have a system with 1000 pages of lowmem and 5000 pages
> > of highmem. Of these, 950 lowmem pages are in use and 500 highmem pages
> > are in use.
> > 
> > In order to to be able to save an image, we need to be able to do an
> > atomic copy of those lowmem pages.
> > 
> > You might think that we could just copy everything into the spare
> > highmem pages, but we can't because mapping and unmapping the highmem
> > pages as we copy the data will leave us with an inconsistent copy.
> > Depending on the configuration, it might (for example) have one page -
> > say on in the pagetables - reflecting one page being kmapped and another
> > page - containing the variables that record what kmap slots are used,
> > for example - recording a different page being kmapped.
> > 
> > What we do, then, is seek to atomically copy the lowmem pages to lowmem.
> > That requires, however, that we have at least half of the lowmem pages
> > free. So, then, we need a function that lets us free lowmem pages only.
> > 
> > I hope that makes it clearer.
> > 
> > > ---
> > >  mm/vmscan.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index e6ea011..7fb3435 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -2265,7 +2265,7 @@ unsigned long shrink_all_memory(unsigned long nr_to_reclaim)
> > >  {
> > >  	struct reclaim_state reclaim_state;
> > >  	struct scan_control sc = {
> > > -		.gfp_mask = GFP_HIGHUSER_MOVABLE,
> > > +		.gfp_mask = GFP_KERNEL,
> > >  		.may_swap = 1,
> > >  		.may_unmap = 1,
> > >  		.may_writepage = 1,
> > 
> > I don't think so. I think what we really need is:
> > 
> > shrink_memory_type(gfp_mask, pages_needed)
> > 
> > That is, a function that would let us say "Free 489 pages of lowmem" or
> > "Free 983 pages of highmem" or "Free 340 pages of any kind of memory".
> > (The later might be used if we just want to free some pages because the
> > image as it stands is too big for the storage available).
> 
> I can add gfp_mask argument to shrink_all_memory(). it's easy.
> but I obviously need to help from PM folks for meaningful change. I'm not sure
> How should we calculate required free memory for hibernation.
> 
> Sidenote, current reclaim logic can't do  "Free 983 pages of highmem".
> but I doubt it's really necessary. I guess we only need "reclaim lowmem" and/or
> "reclaim any kind of memory".

The latter.

Thanks,
Rafael
