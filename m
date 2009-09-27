Return-Path: <linux-kernel-owner+w=401wt.eu-S1751717AbZI0XBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbZI0XBU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 19:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbZI0XBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 19:01:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:41721 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbZI0XBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 19:01:19 -0400
Date: Mon, 28 Sep 2009 01:01:18 +0200
From: Nick Piggin <npiggin@suse.de>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] HWPOISON: remove the unsafe __set_page_locked()
Message-ID: <20090927230118.GH6327@wotan.suse.de>
References: <20090926031537.GA10176@localhost> <Pine.LNX.4.64.0909261115530.12927@sister.anvils> <20090926190645.GB14368@wotan.suse.de> <20090926213204.GX30185@one.firstfloor.org> <Pine.LNX.4.64.0909271714370.9097@sister.anvils> <20090927192251.GB6327@wotan.suse.de> <Pine.LNX.4.64.0909272251180.4402@sister.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0909272251180.4402@sister.anvils>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 10:57:29PM +0100, Hugh Dickins wrote:
> On Sun, 27 Sep 2009, Nick Piggin wrote:
> > On Sun, Sep 27, 2009 at 05:26:25PM +0100, Hugh Dickins wrote:
> > > 
> > > I don't particularly like adding a GFP_LOCKED just for this, and I
> > > don't particularly like having to remember to unlock the thing on the
> > > various(?) error paths between getting the page and adding it to cache.
> > 
> > God no, please no more crazy branches in the page allocator.
> > 
> > I'm going to resubmit my patches to allow 0-ref page allocations,
> > so the pagecache will be able to work with those to do what we
> > want here.
> >  
> > > But it is a good idea, and if doing it that way would really close a
> > > race window which checking page->mapping (or whatever) cannot (I'm
> > > simply not sure about that), then it would seem the best way to go.
> > 
> > Yep, seems reasonable: the ordering is no technical burden, and a
> > simple comment pointing to hwpoison will keep it maintainable.
> 
> You move from "God no" to "Yep, seems reasonable"!
> 
> I think perhaps you couldn't bring yourself to believe that I was
> giving any support to Andi's GFP_LOCKED idea.  Pretend I did not!
> 
> I'll assume we stick with the "God no", and we'll see how what
> you come up with affects what they want.

Well, yes, I mean "no" to a GFP_LOCKED... If you follow me :)

Reasonable being the basic idea of setting up our flags before we
increment page count, although of course we'd want to see how all
the error cases etc pan out.

There is no real rush AFAIKS to fix this one single pagecache site
while we have problems with slab allocators and all other unaudited
places that nonatomically modify page flags with an elevated
page reference ... just mark HWPOISON as broken for the moment, or
cut it down to do something much simpler I guess?

