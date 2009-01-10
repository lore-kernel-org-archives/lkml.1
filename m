Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZAJWCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZAJWCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbZAJWCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:02:09 -0500
Received: from lazybastard.de ([212.112.238.170]:38667 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbZAJWCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:02:07 -0500
Date: Sat, 10 Jan 2009 23:01:35 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add b+tree library
Message-ID: <20090110220135.GF20611@logfs.org>
References: <1231584446.3685.21.camel@johannes> <2f11576a0901100302s5132a1b9p11c62e27aa9a06f8@mail.gmail.com> <1231587428.3803.0.camel@johannes> <2f11576a0901100429h415d3a87o40ba4849120832c8@mail.gmail.com> <20090110183921.GD20611@logfs.org> <1231613042.3706.16.camel@johannes> <87fxjrgd9s.fsf@basil.nowhere.org> <20090110202315.GE20611@logfs.org> <20090110212740.GE31579@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090110212740.GE31579@mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 January 2009 16:27:40 -0500, Theodore Tso wrote:
> On Sat, Jan 10, 2009 at 09:23:16PM +0100, Jörn Engel wrote:
> > 
> > Key difference is the number of cachelines you need to find a particular
> > entry.  rbtrees have a fanout of sqrt(3), so for a million elements (to
> > pick a random example) you need about 25 cachelines with rbtrees and
> > about 5-16 with btrees.  Closer to 5 if keys and pointers are small and
> > cachelines are large, closer to 16 if keys and pointers are large and
> > cachelines are small.
> 
> Three questions....  is the number of cachelines in use going to make a
> measurable difference for your use case in the filesystem?  If the
> operation is going to involve disk access, trying to optimize for to
> improve cacheline utilization may not be the higher priority thing to
> worry about.

I don't really expect a big difference, even if the filesystem is
intended for flash, not disks.  Other overhead will dominate the
picture.  The situation may be different for Johannes, though.

> If you have a million elements, and assuming each element is but 4
> bytes (which seems unlikely; very likely you'd be indexing at least
> 8-12 bytes of data, right?) we're talking about 4 megabytes of
> non-swappable kernel memory.  Is that likely to be happen in your use
> case?

A million was picked because a) it is easy to calculate with and b) it
is sufficiently (insanely) large to illustrate the effect.  It is not
likely at all in my case.  With 1000 elements, which is much more
realistic, you can just halve the numbers above.

> Finally, are b+tree so much better than rbtrees that it would be
> worthwhile to just *replace* rbtrees with b+trees?  Or is the problem
> the overhead issue if the number of entries in an rbtree is relatively
> small?

Maybe and no.  The overhead for near-empty or completely empty trees is
fairly low.  At one point in time I had one btree for every indirect
block and every inode in the filesystem.  As a result, struct btree_head
contains just two pointers and an int.

One key difference is that rbtrees maintain the tree within objects and
btrees maintain the tree externally.  So btrees have to allocate memory
on insertion, where rbtrees have the necessary memory as part of the
object.  With mempools the memory allocation should be reasonably safe,
so maybe this is a bit of a red herring now.

Another difference is the locking.  The current implementation
completely ignores locking and depends on the callers to serialize
access to the btree.

Keeping all that in mind, I believe many rbtree users could be
converted.

Jörn

-- 
The competent programmer is fully aware of the strictly limited size of
his own skull; therefore he approaches the programming task in full
humility, and among other things he avoids clever tricks like the plague.
-- Edsger W. Dijkstra
