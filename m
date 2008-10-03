Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbYJCNyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbYJCNyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 09:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbYJCNxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 09:53:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbYJCNxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 09:53:54 -0400
Date: Fri, 3 Oct 2008 09:53:15 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
Subject: Re: [PATCH] Memory management livelock
In-Reply-To: <200810032227.50892.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0810030951060.27239@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
 <20081002205604.47910d6d.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0810030729290.4875@hs20-bc2-1.build.redhat.com>
 <200810032227.50892.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > So the possible solutions are:
> >
> > 1. Add jiffies when the page was diried and wroteback to struct page
> > + no impact on locking and concurrency
> > - increases the structure by 8 bytes
> 
> This one is not practical.
> 
> 
> > 2. Stop the writers when the starvation happens (what I did)
> > + doesn't do any locking if the livelock doesn't happen
> > - locks writers when the livelock happens (I think it's not really serious
> > --- because very few people complained about the livelock, very few people
> > will see performance degradation from blocking the writers).
> 
> Maybe it is because not much actually does sequential writes to a massive
> file or block device while trying to fsync it as well? I don't know. You
> could still have cases where fsync takes much longer than expected but it
> is still not long enough for a user to report it as a "livelock" bug.

At most twice the time it would normally take (one loop of writeback queue 
until it detects the livelock and the other loop until it drains all the 
new pages that were created during the first loop).

While with solution (3) it would take only once for the whole writeback 
queue.

Mikulas

> > 3. Add another bit to radix tree (what Nick did)
> > + doesn't ever block writers
> > - unconditionally takes the lock on fsync path and serializates concurrent
> > syncs/fsyncs. Probably low overhead too ... or I don't know, is there any
> > possible situation when more processes execute sync() in parallel and user
> > would see degradations if those syncs were serialized?
