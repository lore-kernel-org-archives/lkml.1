Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbZEJJg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbZEJJg0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 05:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbZEJJgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 05:36:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:41742 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbZEJJgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 05:36:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,323,1239001200"; 
   d="scan'208";a="141166554"
Date: Sun, 10 May 2009 17:35:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first
	class  citizen
Message-ID: <20090510093541.GB7651@localhost>
References: <20090503031539.GC5702@localhost> <1241432635.7620.4732.camel@twins> <20090507121101.GB20934@localhost> <20090507151039.GA2413@cmpxchg.org> <20090507134410.0618b308.akpm@linux-foundation.org> <20090508081608.GA25117@localhost> <20090508125859.210a2a25.akpm@linux-foundation.org> <20090508230045.5346bd32@lxorguk.ukuu.org.uk> <2f11576a0905100159m32c36a9ep9fb7cc5604c60b2@mail.gmail.com> <1241946446.6317.42.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241946446.6317.42.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 10, 2009 at 05:07:26PM +0800, Peter Zijlstra wrote:
> On Sun, 2009-05-10 at 17:59 +0900, KOSAKI Motohiro wrote:
> > 2009/5/9 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> > >> The patch seems reasonable but the changelog and the (non-existent)
> > >> design documentation could do with a touch-up.
> > >
> > > Is it right that I as a user can do things like mmap my database
> > > PROT_EXEC to get better database numbers by making other
> > > stuff swap first ?
> > >
> > > You seem to be giving everyone a "nice my process up" hack.
> > 
> > How about this?
> > if priority < DEF_PRIORITY-2, aggressive lumpy reclaim in
> > shrink_inactive_list() already
> > reclaim the active page forcely.
> > then, this patch don't change kernel reclaim policy.
> > 
> > anyway, user process non-changable preventing "nice my process up
> > hack" seems makes sense to me.
> > 
> > test result:
> > 
> > echo 100 > /proc/sys/vm/dirty_ratio
> > echo 100 > /proc/sys/vm/dirty_background_ratio
> > run modified qsbench (use mmap(PROT_EXEC) instead malloc)
> > 
> >            active2active vs active2inactive ratio
> > before    5:5
> > after       1:9
> > 
> > please don't ask performance number. I haven't reproduce Wu's patch
> > improvemnt ;)
> > 
> > Wu, What do you think?
> 
> I don't think this is desirable, like Andrew already said, there's tons
> of ways to defeat any of this and we've so far always priorized mappings
> over !mappings. Limiting this to only PROT_EXEC mappings is already less
> than it used to be.

Yeah. One thing I realized in readahead is that *anything* can happen.
When it comes to caching, app/user behaviors are *far more* unpredictable.
We can make the heuristics as large as 1000LOC (and leave users and
ourselves lost in the mist) or as simple as 100LOC (and make it happy
to hacking or even abuse).
