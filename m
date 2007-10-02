Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbXJCBQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbXJCBQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 21:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbXJCBP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 21:15:58 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:33391 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753130AbXJCBP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 21:15:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=4Kd/Pd580X/jDidO6lQ7dxI+/JEZR17ElEStT/8eYmifUzK1ts4gQVV0qm4FvWhjyM31QCIOeeeyPfWJKce7/+xoHc7dm5463j5Rp44wOl0RTeYv7cbndcYlZf3dcL0/EtyBW8MRajc4fkK4bbJ/2KQ+RIegpjgX1OIF4gTWvus=  ;
X-YMail-OSG: 3xTDTmoVM1lo8pwLcK6K3AR6GCCUPFIAvuuSnkEzuvZYX47rPKtbBqlmHx3964iRWFSJYvyH2A--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 05/12] mm: trylock_page
Date: Tue, 2 Oct 2007 18:44:25 +1000
User-Agent: KMail/1.9.5
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org
References: <20070928074200.436463000@chello.nl> <200709281311.37616.nickpiggin@yahoo.com.au> <1191078095.18147.126.camel@lappy>
In-Reply-To: <1191078095.18147.126.camel@lappy>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200710021844.26118.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 September 2007 01:01, Peter Zijlstra wrote:
> On Fri, 2007-09-28 at 13:11 +1000, Nick Piggin wrote:
> > On Friday 28 September 2007 17:42, Peter Zijlstra wrote:
> > > Replace raw TestSetPageLocked() usage with trylock_page()
> >
> > I have such a thing queued too, for the lock bitops patches for when
> > 2.6.24 opens, Andrew promises me :).
> >
> > I guess they should be identical, except I don't like doing trylock_page
> > in place of SetPageLocked, for memory ordering performance and aesthetic
> > reasons... I've got an init_page_locked (or set_page_locked... I can't
> > remember, the patch is at home).
>
> Sure, that might work, or we could just make it so that add_to_*_cache
> is never passed an unlocked page. But sure...

It does kind of make sense to have it there (because you want the page
to be locked iff it gets inserted into pagecache). And wherever you lock
the page, we'll still want an init_page_locked to be able to lock it while we
are the only owner of it, for the same performance reason.


> > Fine idea to lockdep the page lock, anyway. Does it show up any of the
> > buffered write deadlock possibilities? :)
>
> Not yet, it might just be that the concessions done to annotate this
> type of lock were too severe.
>
> What I basically did was treat all the page locks as a single recursive
> lock.

Hmm, OK. There are a couple of page lock deadlocks there that wouldn't
be picked up, but the page lock vs mmap_sem one probably should be.


> > buffer lock is another notable bit-mutex that might be converted (I have
> > the patch to do the similar nice !tas->trylock conversion for that too).
> > I think it is used widely enough by tricky code that it would be useful
> > to annotate as well.
>
> Not at all familiar with that lock, but yeah, we could have a look at
> doing that too.

Should be pretty well identical to the page lock. I'll cc you on the patch
to do this equivalent API conversion, if you'd like.


> > Unfortunately we can't convert bit_spinlock.h easily, I guess?
>
> Yeah, the space constraints make that rather hard. Each of these locks
> needs some form of external meta-data.

Yeah.

> For the page lock I used one lock instance per file system type.

Seems OK.
