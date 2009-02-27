Return-Path: <linux-kernel-owner+w=401wt.eu-S1757517AbZB0N1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbZB0N1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 08:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbZB0N1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 08:27:36 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44521 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699AbZB0N1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 08:27:35 -0500
Date: Fri, 27 Feb 2009 14:27:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, kosaki.motohiro@jp.fujitsu.com,
       rjw@sisk.pl, riel@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 3/3][RFC] swsusp: shrink file cache first
Message-ID: <20090227132726.GE1482@ucw.cz>
References: <20090206031125.693559239@cmpxchg.org> <20090206031324.004715023@cmpxchg.org> <20090206122129.79CC.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090206044907.GA18467@cmpxchg.org> <20090206130009.99400d43.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206130009.99400d43.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-02-06 13:00:09, Andrew Morton wrote:
> On Fri, 6 Feb 2009 05:49:07 +0100
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > > and, I think you should mesure performence result.
> > 
> > Yes, I'm still thinking about ideas how to quantify it properly.  I
> > have not yet found a reliable way to check for whether the working set
> > is intact besides seeing whether the resumed applications are
> > responsive right away or if they first have to swap in their pages
> > again.
> 
> Describing your subjective non-quantitative impressions would be better
> than nothing...
> 
> The patch bugs me.
> 
> The whole darn point behind the whole darn page reclaim is "reclaim the
> pages which we aren't likely to need soon".  There's nothing special
> about the swsusp code at all!  We want it to do exactly what page
> reclaim normally does, only faster.
> 
> So why do we need to write special hand-rolled code to implement
> something which we've already spent ten years writing?
> 
> hm?  And if this approach leads to less-than-optimum performance after
> resume then the fault lies with core page reclaim - it reclaimed the
> wrong pages!
> 
> That actually was my thinking when I first worked on
> shrink_all_memory() and it did turn out to be surprisingly hard to
> simply reuse the existing reclaim code for this application.  Things
> kept on going wrong.  IIRC this was because we were freeing pages as we
> were reclaiming, so the page reclaim logic kept on seeing all these
> free pages and kept on wanting to bale out.
> 
> Now, the simple and obvious fix to this is not to free the pages - just
> keep on allocating pages and storing them locally until we have
> "enough" memory.  Then when we're all done, dump them all straight onto
> to the freelists.
> 
> But for some reason which I do not recall, we couldn't do that.

We used to do that. I remember having loop doing get_free_page and
doing linklist of them. I believe it was considered quite an hack.

.....one reason is that ee don't want to OOMkill anything if memory is
low, we want to abort the hibernation...

Sorry for being late.....


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
