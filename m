Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbXDHVH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbXDHVH0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 17:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbXDHVH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 17:07:26 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:56100 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbXDHVHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 17:07:25 -0400
Subject: Re: [RFC][PATCH -mm] swsusp: Use rbtree for tracking allocated swap
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200704081847.16738.rjw@sisk.pl>
References: <200704072320.40238.rjw@sisk.pl>
	 <200704080113.24171.rjw@sisk.pl>
	 <1175989328.10725.59.camel@nigel.suspend2.net>
	 <200704081847.16738.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 07:07:25 +1000
Message-Id: <1176066445.10725.123.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sun, 2007-04-08 at 18:47 +0200, Rafael J. Wysocki wrote:
> On Sunday, 8 April 2007 01:42, Nigel Cunningham wrote:
> > Hi.
> > 
> > On Sun, 2007-04-08 at 01:13 +0200, Rafael J. Wysocki wrote:
> > > On Sunday, 8 April 2007 00:31, Nigel Cunningham wrote:
> > > > Hi.
> > > > 
> > > > On Sat, 2007-04-07 at 15:06 -0700, Andrew Morton wrote:
> > > > > On Sat, 7 Apr 2007 23:20:39 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > > 
> > > > > > This should allow us to reduce the memory usage, practically always, and
> > > > > > improve performance.
> > > > > 
> > > > > And does it?
> > > 
> > > Yes.  There are theoretical corner cases in which it may be less efficient
> > > than the current approach, but in the usual situation it is _much_ better.
> > > 
> > > > It will. I've been using extents for ages, for the same reasons. I don't
> > > > put them in an rb_tree because I view it as less than most efficient,
> > > 
> > > Actually, I don't agree with that.  In the normal situation (ie. one extent is
> > > needed) there is no difference as far as the memory usage or performance
> > > are concerned, but if there are more extents, the rbtree should be more
> > > efficient.
> > 
> > I don't think it's worth having a big discussion over, but let me give
> > you the details, which you can then feel free to ignore :)
> > 
> > The rb_node struct adds an unsigned long and two struct rb_node *
> > pointers. My extents use one struct extent * pointer. The difference is
> > thus 12/24 bytes per extent (32/64 bits) vs 20/40.
> 
> Well, you use open-coded lists.  If you used list.h lists, the numbers 
> would be different. :-)

Yes, but I don't need doubly linked lists.

> > In the normal situation, not worth worrying about, but I'm also using these for
> > recording the sectors we write too, and thinking about swap files and
> > multiple swap devices. Nearly double the memory use bites more as you
> > get more extents.
> >
> > Insertion cost for rb_node includes keeping the tree balanced. For
> > extents, I start with the location of the last insertion to minimise the
> > cost, so insertion time is usually virtually zero (inc max of last
> > extent or append a new one).
> 
> Isn't the appending one actually linear worst-case?

Worst case would be the swap allocator returning swap pages in reverse
order. As you and I both know, that doesn't happen. I first implemented
this in 2003. If the worst case actually happened, I would have seen the
effect by now :)

> > If for some reason swap was allocated out of order, I might need to traverse
> > the whole chain from the start. 
> 
> Exactly.
> 
> > Normal usage in both cases is simply iterating through the list, so I
> > guess the cost would be approximately the same.
> > 
> > Deletion could would include rebalancing for the rb_nodes.
> 
> In swsusp the deletions are needed only if there's an error.

When freeing swap at the end of the cycle?

> > Code cost is a gain for you - you're leveraging existing code, I'm
> > adding a bit more. extent.c is 300 lines including code for serialising
> > the chains in an image header and iterating through a group of chains
> > (multiple swap devices support).
> > 
> > rb_nodes seem to be the wrong solution to me because we generally don't
> > care about searching. We care about minimising memory usage and
> > maximising the speed of iteration, insertion and deletion. I believe
> > I've managed to do that with a singly linked, sorted list.
> 
> The insertion also uses searching and in fact I don't really care for anything
> else.

Ok :)

Nigel

