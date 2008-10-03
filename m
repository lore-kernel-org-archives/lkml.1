Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbYJCLoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbYJCLoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 07:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYJCLoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 07:44:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbYJCLoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 07:44:02 -0400
Date: Fri, 3 Oct 2008 07:43:46 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
Subject: Re: [PATCH] Memory management livelock
In-Reply-To: <20081002205604.47910d6d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0810030729290.4875@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
 <200810031259.17527.nickpiggin@yahoo.com.au> <20081002201410.07afff73.akpm@linux-foundation.org>
 <200810031347.21586.nickpiggin@yahoo.com.au> <20081002205604.47910d6d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008, Andrew Morton wrote:

> On Fri, 3 Oct 2008 13:47:21 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> > > I expect there's no solution which avoids blocking the writers at some
> > > stage.
> > 
> > See my other email. Something roughly like this would do the trick
> > (hey, it actually boots and runs and does fix the problem too).
> 
> It needs exclusion to protect all those temp tags.  Is do_fsync()'s
> i_mutex sufficient?  It's qute unobvious (and unmaintainable?) that all
> the callers of this stuff are running under that lock.

That filemap_fdatawrite and filemap_fdatawait in fsync() aren't really 
called under i_mutex (see do_fsync).

So the possible solutions are:

1. Add jiffies when the page was diried and wroteback to struct page
+ no impact on locking and concurrency
- increases the structure by 8 bytes

2. Stop the writers when the starvation happens (what I did)
+ doesn't do any locking if the livelock doesn't happen
- locks writers when the livelock happens (I think it's not really serious 
--- because very few people complained about the livelock, very few people 
will see performance degradation from blocking the writers).

3. Add another bit to radix tree (what Nick did)
+ doesn't ever block writers
- unconditionally takes the lock on fsync path and serializates concurrent 
syncs/fsyncs. Probably low overhead too ... or I don't know, is there any 
possible situation when more processes execute sync() in parallel and user 
would see degradations if those syncs were serialized?

Mikulas
