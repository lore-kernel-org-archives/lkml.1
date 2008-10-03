Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbYJCESl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbYJCESl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 00:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbYJCESd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 00:18:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750778AbYJCESd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 00:18:33 -0400
Date: Thu, 2 Oct 2008 21:17:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, agk@redhat.com, mbroz@redhat.com,
       chris@arachsys.com
Subject: Re: [PATCH] Memory management livelock
Message-Id: <20081002211752.68994206.akpm@linux-foundation.org>
In-Reply-To: <200810031407.55406.nickpiggin@yahoo.com.au>
References: <20080911101616.GA24064@agk.fab.redhat.com>
	<200810031347.21586.nickpiggin@yahoo.com.au>
	<20081002205604.47910d6d.akpm@linux-foundation.org>
	<200810031407.55406.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008 14:07:55 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Friday 03 October 2008 13:56, Andrew Morton wrote:
> > On Fri, 3 Oct 2008 13:47:21 +1000 Nick Piggin <nickpiggin@yahoo.com.au> 
> wrote:
> > > > I expect there's no solution which avoids blocking the writers at some
> > > > stage.
> > >
> > > See my other email. Something roughly like this would do the trick
> > > (hey, it actually boots and runs and does fix the problem too).
> >
> > It needs exclusion to protect all those temp tags.  Is do_fsync()'s
> > i_mutex sufficient?  It's qute unobvious (and unmaintainable?) that all
> > the callers of this stuff are running under that lock.
> 
> Yeah... it does need a lock, which I brushed under the carpet :P
> I was going to just say use i_mutex, but then we really would start
> impacting on other fastpaths (eg writers).
> 
> Possibly a new mutex in the address_space?

That's another, umm 24 bytes minimum in the address_space (and inode). 
That's fairly ouch, which is why Miklaus did that hokey bit-based
thing.

> That way we can say
> "anybody who holds this mutex is allowed to use the tag for anything"
> and it doesn't have to be fsync specific (whether that would be of
> any use to anything else, I don't know).
> 
> 
> > > It's ugly because we don't have quite the right radix tree operations
> > > yet (eg. lookup multiple tags, set tag X if tag Y was set, proper range
> > > lookups). But the theory is to up-front tag the pages that we need to
> > > get to disk.
> >
> > Perhaps some callback-calling radix tree walker.
> 
> Possibly, yes. That would make it fairly general. I'll have a look...
> 
> 
> > > Completely no impact or slowdown to any writers (although it does add
> > > 8 bytes of tags to the radix tree node... but doesn't increase memory
> > > footprint as such due to slab).
> >
> > Can we reduce the amount of copy-n-pasting here?
> 
> Yeah... I went to break the sync/async cases into two, but it looks like
> it may not have been worthwhile. Just another branch might be the best
> way to go.

Yup.  Could add another do-this flag in the writeback_control, perhaps.
Or even a function pointer.

> As far as the c&p in setting the FSYNC tag, yes that should all go away
> if the radix-tree is up to scratch. Basically:
> 
> radix_tree_tag_set_if_tagged(start, end, ifWRITEBACK|DIRTY, setFSYNC);
> 
> should be able to replace the whole thing, and we'd hold the tree_lock, so
> we would not have to take the page lock etc. Basically it would be much
> nicer... even somewhere close to a viable solution.
