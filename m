Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbZBFF7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbZBFF7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 00:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbZBFF7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 00:59:42 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36341 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZBFF7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 00:59:41 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 3/3][RFC] swsusp: shrink file cache first
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20090206044907.GA18467@cmpxchg.org>
References: <20090206122129.79CC.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090206044907.GA18467@cmpxchg.org>
Message-Id: <20090206135302.628E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri,  6 Feb 2009 14:59:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > if we think suspend performance, we should consider swap device and file-backed device
> > are different block device.
> > the interleave of file-backed page out and swap out can improve total write out performce.
> 
> Hm, good point.  We could probably improve that but I don't think it's
> too pressing because at least on my test boxen, actual shrinking time
> is really short compared to the total of suspending to disk.

ok.
only remain problem is mesurement result posting :)


> > if we think resume performance, we shold how think the on-disk contenious of the swap consist
> > process's virtual address contenious.
> > it cause to reduce unnecessary seek.
> > but your patch doesn't this.
> > 
> > Could you explain this patch benefit?
> 
> The patch tries to shrink those pages first that are most unlikely to
> be needed again after resume.  It assumes that active anon pages are
> immediately needed after resume while inactive file pages are not.  So
> it defers shrinking anon pages after file cache.

hmm, I'm confusing.
I agree active anon is important than inactive file.
but I don't understand why scanning order at suspend change resume order.


> But I just noticed that the old behaviour defers it as well, because
> even if it does scan anon pages from the beginning, it allows writing
> only starting from pass 3.

Ah, I see.
it's obiously wrong.

> I couldn't quite understand what you wrote about on-disk
> contiguousness, but that claim still stands: faulting in contiguous
> pages from swap can be much slower than faulting file pages.  And my
> patch prefers mapped file pages over anon pages.  This is probably
> where I have seen the improvements after resume in my tests.

sorry, I don't understand yet.
Why "prefers mapped file pages over anon pages" makes large improvement?


> So assuming that we can not save the whole working set, it's better to
> preserve as much as possible of those pages that are the most
> expensive ones to refault.
>
> > and, I think you should mesure performence result.
> 
> Yes, I'm still thinking about ideas how to quantify it properly.  I
> have not yet found a reliable way to check for whether the working set
> is intact besides seeing whether the resumed applications are
> responsive right away or if they first have to swap in their pages
> again.

thanks.
I'm looking for this :)



> > > @@ -2134,17 +2144,17 @@ unsigned long shrink_all_memory(unsigned
> > >  
> > >  	/*
> > >  	 * We try to shrink LRUs in 5 passes:
> > > -	 * 0 = Reclaim from inactive_list only
> > > -	 * 1 = Reclaim from active list but don't reclaim mapped
> > > -	 * 2 = 2nd pass of type 1
> > > -	 * 3 = Reclaim mapped (normal reclaim)
> > > -	 * 4 = 2nd pass of type 3
> > > +	 * 0 = Reclaim unmapped inactive file pages
> > > +	 * 1 = Reclaim unmapped file pages
> > 
> > I think your patch reclaim mapped file at priority 0 and 1 too.
> 
> Doesn't the following check in shrink_page_list prevent this:
> 
>                 if (!sc->may_swap && page_mapped(page))
>                         goto keep_locked;
> 
> ?

Grr, you are right.
I agree, currently may_swap doesn't control swap out or not.
so I think we should change it correct name ;)



