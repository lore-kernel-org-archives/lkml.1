Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbYFMRpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbYFMRpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 13:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYFMRpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 13:45:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbYFMRpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 13:45:45 -0400
Date: Fri, 13 Jun 2008 13:45:07 -0400
From: Rik van Riel <riel@redhat.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.26-rc5-mm2 (swap_state.c:77)
Message-ID: <20080613134507.3f08820e@cuia.bos.redhat.com>
In-Reply-To: <Pine.LNX.4.64.0806122131330.10415@blonde.site>
References: <20080609223145.5c9a2878.akpm@linux-foundation.org>
	<200806101848.22237.nickpiggin@yahoo.com.au>
	<20080611140902.544e59ec@bree.surriel.com>
	<200806120958.38545.nickpiggin@yahoo.com.au>
	<20080612152905.6cb294ae@cuia.bos.redhat.com>
	<Pine.LNX.4.64.0806122131330.10415@blonde.site>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008 22:15:54 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> > I'm trying to make sense of all the splice code now
> > and will send fix as soon as I know how to fix this
> > problem in a nice way.
> 
> There's no need to make sense of all the splice code, it's just
> that it's doing add_to_page_cache_lru (on a page not marked as
> SwapBacked), then shmem and swap_state consistency relies on it
> as having been marked as SwapBacked.  Normally, yes, shmem_getpage
> is the one that allocates the page, but in this case it's already
> been done outside, awkward (and long predates loop's use of splice).
> 
> It's remarkably hard to correct the LRU of a page once it's been
> launched towards one.  Is it still on this cpu's pagevec?  Have we
> been preempted and it's on another cpu's pagevec?  If it's reached
> the LRU, has vmscan whisked it off for a moment, even though it's
> PageLocked?  Until now it's been that the LRUs are self-correcting,
> but these patches move away from that.
> 
> I don't know how to fix this problem in a nice way.  For the moment,
> to proceed with testing, I'm using the hack below.  But perhaps that
> screws things up for the other !mapping_cap_account_dirty filesystems
> e.g. ramfs, I just haven't tried them yet - nor shall in the next
> couple of days.

Yeah, it will break ramfs.  Also, we need to take care of
splice going in the opposite direction (moving a page from
SwapBacked to filesystem backed).

I guess we'll need per-mapping flags to help determine where
a page goes at add_to_page_cache_lru() time.

This does not remove our need for the page flags, because
those need to survive until the del_page_from_lru() call
in __page_cache_release(), by which time the page->mapping
will be long gone.

> Am I right to think that the memcontrol stuff is now all broken,
> because memcontrol.c hasn't yet been converted to the more LRUs?
> Certainly I'm now hanging when trying to run in a restricted memcg.

I believe memcontrol has been converted.  Of course, maybe
they changed some stuff under me that I didn't notice :(
 
> Unrelated fix to compiler warning and silly /proc/meminfo numbers
> below too, that one raises fewer questions!

I sent the fix for that one to Andrew already.  I believe
it's in his mmotm tree.

-- 
All Rights Reversed
