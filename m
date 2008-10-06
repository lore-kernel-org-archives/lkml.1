Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbYJFAFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbYJFAFQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 20:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750817AbYJFAFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 20:05:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbYJFAFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 20:05:01 -0400
Date: Sun, 5 Oct 2008 20:04:43 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: david@lang.hm
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
Subject: Re: application syncing options (was Re: [PATCH] Memory management
 livelock)
In-Reply-To: <alpine.DEB.1.10.0810030845070.14680@asgard.lang.hm>
Message-ID: <Pine.LNX.4.64.0810052002520.5798@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
 <20080923154905.50d4b0fa.akpm@linux-foundation.org> <200810031232.23836.nickpiggin@yahoo.com.au>
 <200810031254.29121.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0810030845070.14680@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Oct 2008, david@lang.hm wrote:

> On Fri, 3 Oct 2008, Nick Piggin wrote:
> 
> > > *What* is, forever? Data integrity syncs should have pages operated on
> > > in-order, until we get to the end of the range. Circular writeback could
> > > go through again, possibly, but no more than once.
> > 
> > OK, I have been able to reproduce it somewhat. It is not a livelock,
> > but what is happening is that direct IO read basically does an fsync
> > on the file before performing the IO. The fsync gets stuck behind the
> > dd that is dirtying the pages, and ends up following behind it and
> > doing all its IO for it.
> > 
> > The following patch avoids the issue for direct IO, by using the range
> > syncs rather than trying to sync the whole file.
> > 
> > The underlying problem I guess is unchanged. Is it really a problem,
> > though? The way I'd love to solve it is actually by adding another bit
> > or two to the pagecache radix tree,  that can be used to transiently tag
> > the tree for future operations. That way we could record the dirty and
> > writeback pages up front, and then only bother with operating on them.
> > 
> > That's *if* it really is a problem. I don't have much pity for someone
> > doing buffered IO and direct IO to the same pages of the same file :)
> 
> I've seen lots of discussions here about different options in syncing. in this
> case a fix is to do a fsync of a range.

It fixes the bug in concurrent direct read+buffed write, but won't fix the 
bug with concurrent sync+buffered write.

> I've also seen discussions of how the
> kernel filesystem code can do ordered writes without having to wait for them
> with the use of barriers, is this capability exported to userspace? if so,
> could you point me at documentation for it?

It isn't. And it is good that it isn't --- the more complicated API, the 
more maintenance work.

Mikulas

> David Lang
> 
