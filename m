Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbZIZTGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbZIZTGq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 15:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbZIZTGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 15:06:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58423 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbZIZTGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 15:06:45 -0400
Date: Sat, 26 Sep 2009 21:06:45 +0200
From: Nick Piggin <npiggin@suse.de>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] HWPOISON: remove the unsafe __set_page_locked()
Message-ID: <20090926190645.GB14368@wotan.suse.de>
References: <20090926031537.GA10176@localhost> <Pine.LNX.4.64.0909261115530.12927@sister.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0909261115530.12927@sister.anvils>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 12:09:21PM +0100, Hugh Dickins wrote:
> On Sat, 26 Sep 2009, Wu Fengguang wrote:
> 
> > The swap cache and page cache code assume that they 'own' the newly
> > allocated page and therefore can disregard the locking rules. However
> > now hwpoison can hit any time on any page.
> > 
> > So use the safer lock_page()/trylock_page(). The main intention is not
> > to close such a small time window of memory corruption. But to avoid
> > kernel oops that may result from such races, and also avoid raising
> > false alerts in hwpoison stress tests.
> > 
> > This in theory will slightly increase page cache/swap cache overheads,
> > however it seems to be too small to be measurable in benchmark.
> 
> No.
> 
> But I'd most certainly defer to Nick if he disagrees with me.
> 
> I don't think anyone would want to quarrel very long over the swap
> and migration mods alone, but add_to_page_cache() is of a higher
> order of magnitude.
> 
> I can't see any reason to surrender add_to_page_cache() optimizations
> to the remote possibility of hwpoison (infinitely remote for most of
> us); though I wouldn't myself want to run the benchmark to defend them.

Thanks Hugh, I definitely agree with you. And I agree the page lock
is a strange thing: it's only really well defined for some types of
pages (eg. pagecache pages), so it's not clear what it even really
means to take the page lock on non-pagecache or soon to be pagecache
pages.

We don't need to run benchmarks: it's unquestionably slower if we
have to go back to full atomic ops here. What we need to focus on
throughout the kernel is reducing atomic ops and unpredictable
branches rather than adding them, because our fastpaths are getting
monotonically slower *anyway*.

I would much prefer that hwpoison code first ensures it has a valid
pagecache page and is pinning it before it ever tries to do a
lock_page.

This is a bit tricky to do right now; you have a chicken and egg
problem between locking the page and pinning the inode mapping.
Possibly you could get the page ref, then check mapping != NULL,
and in that case lock the page. You'd just have to check ordering
on the other side... and if you do something crazy like that,
then please add comments in the core code saying that hwpoison
has added a particular dependency.


> I suspect if memory_failure() did something like:
> 	if (page->mapping)
> 		lock_page_nosync(p);
> then you'd be okay, perhaps with a few additional _inexpensive_
> tweaks here and there.  With the "necessary" memory barriers?
> no, we probably wouldn't want to be adding any in hot paths.

Ah, you came to the same idea. Yes memory barriers in the fastpath
are no good, but you can effectively have a memory barrier on
all other CPUs by doing a synchronize_rcu() with no cost to the
fastpaths.


