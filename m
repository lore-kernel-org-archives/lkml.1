Return-Path: <linux-kernel-owner+w=401wt.eu-S1751458AbXDHQn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbXDHQn5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 12:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbXDHQn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 12:43:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51754 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbXDHQn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 12:43:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: [RFC][PATCH -mm] swsusp: Use rbtree for tracking allocated swap
Date: Sun, 8 Apr 2007 18:47:16 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>
References: <200704072320.40238.rjw@sisk.pl> <200704080113.24171.rjw@sisk.pl> <1175989328.10725.59.camel@nigel.suspend2.net>
In-Reply-To: <1175989328.10725.59.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704081847.16738.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 8 April 2007 01:42, Nigel Cunningham wrote:
> Hi.
> 
> On Sun, 2007-04-08 at 01:13 +0200, Rafael J. Wysocki wrote:
> > On Sunday, 8 April 2007 00:31, Nigel Cunningham wrote:
> > > Hi.
> > > 
> > > On Sat, 2007-04-07 at 15:06 -0700, Andrew Morton wrote:
> > > > On Sat, 7 Apr 2007 23:20:39 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > 
> > > > > This should allow us to reduce the memory usage, practically always, and
> > > > > improve performance.
> > > > 
> > > > And does it?
> > 
> > Yes.  There are theoretical corner cases in which it may be less efficient
> > than the current approach, but in the usual situation it is _much_ better.
> > 
> > > It will. I've been using extents for ages, for the same reasons. I don't
> > > put them in an rb_tree because I view it as less than most efficient,
> > 
> > Actually, I don't agree with that.  In the normal situation (ie. one extent is
> > needed) there is no difference as far as the memory usage or performance
> > are concerned, but if there are more extents, the rbtree should be more
> > efficient.
> 
> I don't think it's worth having a big discussion over, but let me give
> you the details, which you can then feel free to ignore :)
> 
> The rb_node struct adds an unsigned long and two struct rb_node *
> pointers. My extents use one struct extent * pointer. The difference is
> thus 12/24 bytes per extent (32/64 bits) vs 20/40.

Well, you use open-coded lists.  If you used list.h lists, the numbers 
would be different. :-)

> In the normal situation, not worth worrying about, but I'm also using these for
> recording the sectors we write too, and thinking about swap files and
> multiple swap devices. Nearly double the memory use bites more as you
> get more extents.
>
> Insertion cost for rb_node includes keeping the tree balanced. For
> extents, I start with the location of the last insertion to minimise the
> cost, so insertion time is usually virtually zero (inc max of last
> extent or append a new one).

Isn't the appending one actually linear worst-case?

> If for some reason swap was allocated out of order, I might need to traverse
> the whole chain from the start. 

Exactly.

> Normal usage in both cases is simply iterating through the list, so I
> guess the cost would be approximately the same.
> 
> Deletion could would include rebalancing for the rb_nodes.

In swsusp the deletions are needed only if there's an error.

> Code cost is a gain for you - you're leveraging existing code, I'm
> adding a bit more. extent.c is 300 lines including code for serialising
> the chains in an image header and iterating through a group of chains
> (multiple swap devices support).
> 
> rb_nodes seem to be the wrong solution to me because we generally don't
> care about searching. We care about minimising memory usage and
> maximising the speed of iteration, insertion and deletion. I believe
> I've managed to do that with a singly linked, sorted list.

The insertion also uses searching and in fact I don't really care for anything
else.

Greetings,
Rafael
