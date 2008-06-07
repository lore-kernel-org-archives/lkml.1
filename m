Return-Path: <linux-kernel-owner+w=401wt.eu-S1759822AbYFGXjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759822AbYFGXjq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 19:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbYFGXjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 19:39:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690AbYFGXji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 19:39:38 -0400
Date: Sat, 7 Jun 2008 19:38:54 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com
Subject: Re: [PATCH -mm 05/25] define page_file_cache() function
Message-ID: <20080607193854.3a47463b@bree.surriel.com>
In-Reply-To: <20080606180434.f9558bab.akpm@linux-foundation.org>
References: <20080606202838.390050172@redhat.com>
	<20080606202858.624305330@redhat.com>
	<20080606180434.f9558bab.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 18:04:34 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > Unfortunately this needs to use a page flag, since the
> > PG_swapbacked state needs to be preserved all the way
> > to the point where the page is last removed from the
> > LRU.  Trying to derive the status from other info in
> > the page resulted in wrong VM statistics in earlier
> > split VM patchsets.
> 
> argh.  How many are left?

After this patch, 19 are in use.  I believe the way we
keep track of zones means we have 24 total on i386, but
the exact value depends on CONFIG_NODES_SHIFT, which
determines the maximum number of NUMA nodes supported.

The code in include/linux/mm.h makes sure the user
cannot compile the kernel with too high a NODES_SHIFT
value.

On 64 bits, we have more than enough flags.

> > +static inline int page_file_cache(struct page *page)
> > +{
> > +	if (PageSwapBacked(page))
> > +		return 0;
> > +
> > +	/* The page is page cache backed by a normal filesystem. */
> > +	return 2;
> 
> 2?
> 
> Maybe bool would suit here.

It will be replaced with LRU_FILE in a later patch.  I'll change it
to 1 in this patch.
 
> Maybe a better name would be page_is_file_cache().  The gnu (gcc?)
> convention of putting _p at the end of predicate functions' names makes
> heaps of sense.

I'll change it to page_is_file_cache()

> This function doesn't do enough stuff to do that which it says it does.
> There must be a whole pile of preconditions which the caller must
> evaluate before this function can be usefully used.  I mean, it would
> be a bug to pass an anonymous page or a slab page or whatever into
> here?

Passing in a slab page would indeed not give a useful result.  This
function is meant to help functions that manipulate the LRU lists
(which already know the page is or should be an LRU page) sort the
page onto the right list.

I have amended the comment to reflect this.

-- 
All rights reversed.
