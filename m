Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbYJCL0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbYJCL0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 07:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYJCL0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 07:26:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbYJCL0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 07:26:31 -0400
Date: Fri, 3 Oct 2008 07:26:07 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, agk@redhat.com, mbroz@redhat.com,
       chris@arachsys.com
Subject: Re: [PATCH] Memory management livelock
In-Reply-To: <200810031254.29121.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0810030716310.4875@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
 <20080923154905.50d4b0fa.akpm@linux-foundation.org> <200810031232.23836.nickpiggin@yahoo.com.au>
 <200810031254.29121.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > *What* is, forever? Data integrity syncs should have pages operated on
> > in-order, until we get to the end of the range. Circular writeback could
> > go through again, possibly, but no more than once.
> 
> OK, I have been able to reproduce it somewhat. It is not a livelock,
> but what is happening is that direct IO read basically does an fsync
> on the file before performing the IO. The fsync gets stuck behind the
> dd that is dirtying the pages, and ends up following behind it and
> doing all its IO for it.
> 
> The following patch avoids the issue for direct IO, by using the range
> syncs rather than trying to sync the whole file.
> 
> The underlying problem I guess is unchanged. Is it really a problem,
> though? The way I'd love to solve it is actually by adding another bit
> or two to the pagecache radix tree,  that can be used to transiently tag
> the tree for future operations. That way we could record the dirty and
> writeback pages up front, and then only bother with operating on them.
> 
> That's *if* it really is a problem. I don't have much pity for someone
> doing buffered IO and direct IO to the same pages of the same file :)

LVM does (that is where the bug was discovered). Basically, it scans all 
the block devices with direct IO and if someone else does buffered IO on 
any device simultaneously, it locks up.

That fsync-vs-write livelock is quite improbably (why would some 
application do it?) --- although it could be used as a DoS --- getting 
unkillable process.

But there is another possible real-world problem --- sync-vs-write --- 
i.e. admin plugs in two disks and copies data from one to the other. 
Meanwhile, some unrelated server process executes sync(). The server goes 
into coma until the copy finishes.

Mikulas
