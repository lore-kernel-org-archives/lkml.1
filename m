Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbZBGEkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbZBGEkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 23:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbZBGEkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 23:40:24 -0500
Received: from mail.crca.org.au ([67.207.131.56]:38322 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbZBGEkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 23:40:23 -0500
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [PATCH 3/3][RFC] swsusp: shrink file cache first
From: Nigel Cunningham <ncunningham-lkml@crca.org.au>
Reply-To: ncunningham-lkml@crca.org.au
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, kosaki.motohiro@jp.fujitsu.com,
       rjw@sisk.pl, riel@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20090206130009.99400d43.akpm@linux-foundation.org>
References: <20090206031125.693559239@cmpxchg.org>
	 <20090206031324.004715023@cmpxchg.org>
	 <20090206122129.79CC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20090206044907.GA18467@cmpxchg.org>
	 <20090206130009.99400d43.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 07 Feb 2009 15:41:00 +1100
Message-Id: <1233981660.12224.1.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, 2009-02-06 at 13:00 -0800, Andrew Morton wrote:
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
> 
> It would be good to revisit all this.

It would be. It would be good, too, if 'we' could make it actually free
the number of pages it's asked for, too. At the moment, you generally
get something like 90% of what you ask for. Makes carefully calculating
how much you need to ask for a bit pointless :\

Nigel

