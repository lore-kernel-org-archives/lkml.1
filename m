Return-Path: <linux-kernel-owner+w=401wt.eu-S932454AbZJEJtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbZJEJtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 05:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932441AbZJEJti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 05:49:38 -0400
Received: from gir.skynet.ie ([193.1.99.77]:36652 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932412AbZJEJti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 05:49:38 -0400
Date: Mon, 5 Oct 2009 10:49:04 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 2/4] slqb: Record what node is local to a kmem_cache_cpu
Message-ID: <20091005094904.GC12681@csn.ul.ie>
References: <1253624054-10882-3-git-send-email-mel@csn.ul.ie> <84144f020909220638l79329905sf9a35286130e88d0@mail.gmail.com> <20090922135453.GF25965@csn.ul.ie> <84144f020909221154x820b287r2996480225692fad@mail.gmail.com> <20090922185608.GH25965@csn.ul.ie> <20090930144117.GA17906@csn.ul.ie> <alpine.DEB.1.10.0909301053550.9450@gentwo.org> <20090930220541.GA31530@csn.ul.ie> <alpine.DEB.1.10.0909301941570.11850@gentwo.org> <84144f020910040506l24a74660s508c828123c554cc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <84144f020910040506l24a74660s508c828123c554cc@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 04, 2009 at 03:06:45PM +0300, Pekka Enberg wrote:
> On Thu, Oct 1, 2009 at 2:45 AM, Christoph Lameter
> <cl@linux-foundation.org> wrote:
> >> This is essentially the "unqueued" nature of SLUB. It's objective "I have this
> >> page here which I'm going to use until I can't use it no more and will depend
> >> on the page allocator to sort my stuff out". I have to read up on SLUB up
> >> more to see if it's compatible with SLQB or not though. In particular, how
> >> does SLUB deal with frees from pages that are not the "current" page? SLQB
> >> does not care what page the object belongs to as long as it's node-local
> >> as the object is just shoved onto a LIFO for maximum hotness.
> >
> > Frees are done directly to the target slab page if they are not to the
> > current active slab page. No centralized locks. Concurrent frees from
> > processors on the same node to multiple other nodes (or different pages
> > on the same node) can occur.
> >
> >> > SLAB deals with it in fallback_alloc(). It scans the nodes in zonelist
> >> > order for free objects of the kmem_cache and then picks up from the
> >> > nearest node. Ugly but it works. SLQB would have to do something similar
> >> > since it also has the per node object bins that SLAB has.
> >> >
> >>
> >> In a real sense, this is what the patch ends up doing. When it fails to
> >> get something locally but sees that the local node is memoryless, it
> >> will check the remote node lists in zonelist order. I think that's
> >> reasonable behaviour but I'm biased because I just want the damn machine
> >> to boot again. What do you think? Pekka, Nick?
> >
> > Look at fallback_alloc() in slab. You can likely copy much of it. It
> > considers memory policies and cpuset constraints.
> 
> Sorry for the delay. I went ahead and merged Mel's patch to make
> things boot on PPC. Fallback policy needs a bit more work as Christoph
> says but I'd really love to have Nick's input on this.
> 
> Mel, do you have a Kconfig patch laying around somewhere to enable
> SLQB on PPC and S390?
> 

It's patch 4 of this series.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
