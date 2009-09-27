Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbZI0TWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbZI0TWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 15:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZI0TWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 15:22:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53732 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbZI0TWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 15:22:48 -0400
Date: Sun, 27 Sep 2009 21:22:51 +0200
From: Nick Piggin <npiggin@suse.de>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] HWPOISON: remove the unsafe __set_page_locked()
Message-ID: <20090927192251.GB6327@wotan.suse.de>
References: <20090926031537.GA10176@localhost> <Pine.LNX.4.64.0909261115530.12927@sister.anvils> <20090926190645.GB14368@wotan.suse.de> <20090926213204.GX30185@one.firstfloor.org> <Pine.LNX.4.64.0909271714370.9097@sister.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0909271714370.9097@sister.anvils>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 05:26:25PM +0100, Hugh Dickins wrote:
> On Sat, 26 Sep 2009, Andi Kleen wrote:
> > > This is a bit tricky to do right now; you have a chicken and egg
> > > problem between locking the page and pinning the inode mapping.
> > 
> > One possibly simple solution would be to just allocate the page
> > locked (GFP_LOCKED). When the allocator clears the flags it already
> > modifies the state, so it could as well set the lock bit too. No
> > atomics needed.  And then clearing it later is also atomic free.
> 
> That's a good idea.
> 
> I don't particularly like adding a GFP_LOCKED just for this, and I
> don't particularly like having to remember to unlock the thing on the
> various(?) error paths between getting the page and adding it to cache.

God no, please no more crazy branches in the page allocator.

I'm going to resubmit my patches to allow 0-ref page allocations,
so the pagecache will be able to work with those to do what we
want here.

 
> But it is a good idea, and if doing it that way would really close a
> race window which checking page->mapping (or whatever) cannot (I'm
> simply not sure about that), then it would seem the best way to go.

Yep, seems reasonable: the ordering is no technical burden, and a
simple comment pointing to hwpoison will keep it maintainable.

