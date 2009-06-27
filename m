Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbZF0Pk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbZF0Pk1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 11:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZF0PkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 11:40:17 -0400
Received: from cmpxchg.org ([85.214.51.133]:51269 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbZF0PkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 11:40:16 -0400
Date: Sat, 27 Jun 2009 17:36:30 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>,
       "riel@redhat.com" <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Subject: Re: Found the commit that causes the OOMs
Message-ID: <20090627153630.GA6803@cmpxchg.org>
References: <20090624023251.GA16483@localhost> <20090620043303.GA19855@localhost> <32411.1245336412@redhat.com> <20090517022327.280096109@intel.com> <2015.1245341938@redhat.com> <20090618095729.d2f27896.akpm@linux-foundation.org> <7561.1245768237@redhat.com> <26537.1246086769@redhat.com> <20090627125412.GA1667@cmpxchg.org> <28c262360906270650v6c276591u417d64573ecfba29@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <28c262360906270650v6c276591u417d64573ecfba29@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 27, 2009 at 10:50:25PM +0900, Minchan Kim wrote:
> Hi, Hannes.
> 
> On Sat, Jun 27, 2009 at 9:54 PM, Johannes Weiner<hannes@cmpxchg.org> wrote:
> > On Sat, Jun 27, 2009 at 08:12:49AM +0100, David Howells wrote:
> >>
> >> I've managed to bisect things to find the commit that causes the OOMs.  It's:
> >>
> >>       commit 69c854817566db82c362797b4a6521d0b00fe1d8
> >>       Author: MinChan Kim <minchan.kim@gmail.com>
> >>       Date:   Tue Jun 16 15:32:44 2009 -0700
> >>
> >>           vmscan: prevent shrinking of active anon lru list in case of no swap space V3
> >>
> >>           shrink_zone() can deactivate active anon pages even if we don't have a
> >>           swap device.  Many embedded products don't have a swap device.  So the
> >>           deactivation of anon pages is unnecessary.
> >>
> >>           This patch prevents unnecessary deactivation of anon lru pages.  But, it
> >>           don't prevent aging of anon pages to swap out.
> >>
> >>           Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> >>           Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> >>           Cc: Johannes Weiner <hannes@cmpxchg.org>
> >>           Acked-by: Rik van Riel <riel@redhat.com>
> >>           Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >>           Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> >>
> >> This exhibits the problem.  The previous commit:
> >>
> >>       commit 35282a2de4e5e4e173ab61aa9d7015886021a821
> >>       Author: Brice Goglin <Brice.Goglin@ens-lyon.org>
> >>       Date:   Tue Jun 16 15:32:43 2009 -0700
> >>
> >>           migration: only migrate_prep() once per move_pages()
> >>
> >> survives 16 iterations of the LTP syscall testsuite without exhibiting the
> >> problem.
> >
> > Here is the patch in question:
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 7592d8e..879d034 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1570,7 +1570,7 @@ static void shrink_zone(int priority, struct zone *zone,
> >         * Even if we did not try to evict anon pages at all, we want to
> >         * rebalance the anon lru active/inactive ratio.
> >         */
> > -       if (inactive_anon_is_low(zone, sc))
> > +       if (inactive_anon_is_low(zone, sc) && nr_swap_pages > 0)
> >                shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
> >
> >        throttle_vm_writeout(sc->gfp_mask);
> >
> > When this was discussed, I think we missed that nr_swap_pages can
> > actually get zero on swap systems as well and this should have been
> > total_swap_pages - otherwise we also stop balancing the two anon lists
> > when swap is _full_ which was not the intention of this change at all.
> 
> At that time we considered it so that we didn't prevent anon list
> aging for background reclaim.
> Do you think it is not enough ?

With a heavy multiprocess anon load, direct reclaimers will likely
reuse the reclaimed pages for anon mappings, so you have a handful of
processes shuffling pages on the active list and only one thread that
tries to balance.  I can imagine that it can not keep up for long.
