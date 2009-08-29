Return-Path: <linux-kernel-owner+w=401wt.eu-S1752231AbZH2MWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbZH2MWt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 08:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbZH2MWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 08:22:48 -0400
Received: from cmpxchg.org ([85.214.51.133]:47722 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbZH2MWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 08:22:48 -0400
Date: Sat, 29 Aug 2009 14:22:18 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH mmotm] vmscan move pgdeactivate modification to shrink_active_list fix
Message-ID: <20090829122217.GA17448@cmpxchg.org>
References: <Pine.LNX.4.64.0908282034240.19475@sister.anvils> <2f11576a0908290300h155596e1y730c355ade7a671e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2f11576a0908290300h155596e1y730c355ade7a671e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 29, 2009 at 07:00:47PM +0900, KOSAKI Motohiro wrote:
> Hi Hugh
> 
> 2009/8/29 Hugh Dickins <hugh.dickins@tiscali.co.uk>:
> > mmotm 2009-08-27-16-51 lets the OOM killer loose on my loads even
> > quicker than last time: one bug fixed but another bug introduced.
> > vmscan-move-pgdeactivate-modification-to-shrink_active_list.patch
> > forgot to add NR_LRU_BASE to lru index to make zone_page_state index.
> >
> > Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> 
> Can I use your test case?
> Currently LRU_BASE is 0. it mean
> 
> LRU_BASE == NR_INACTIVE_ANON == 0
> LRU_ACTIVE == NR_ACTIVE_ANON == 1

The zone counters are

	NR_FREE_PAGES = 0
	NR_INACTIVE_ANON = NR_LRU_BASE = 1
	NR_ACTIVE_ANON = 2
	...,

and NR_LRU_BASE is the offset of the LRU items within the zone stat
items.  You missed this offset, so accounting to LRU_BASE + 0 *
LRU_FILE actually accounts to NR_FREE_PAGES, not to NR_INACTIVE_ANON.

I get the feeling we should make this thing more robust...

	Hannes

> Therefore, I doubt there are another issue in current mmotm.
> Can I join your strange oom fixing works?
> 
> 
> > ---
> >
> >  mm/vmscan.c |    6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > --- mmotm/mm/vmscan.c   2009-08-28 10:07:57.000000000 +0100
> > +++ linux/mm/vmscan.c   2009-08-28 18:30:33.000000000 +0100
> > @@ -1381,8 +1381,10 @@ static void shrink_active_list(unsigned
> >        reclaim_stat->recent_rotated[file] += nr_rotated;
> >        __count_vm_events(PGDEACTIVATE, nr_deactivated);
> >        __mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
> > -       __mod_zone_page_state(zone, LRU_ACTIVE + file * LRU_FILE, nr_rotated);
> > -       __mod_zone_page_state(zone, LRU_BASE + file * LRU_FILE, nr_deactivated);
> > +       __mod_zone_page_state(zone, NR_ACTIVE_ANON + file * LRU_FILE,
> > +                                                       nr_rotated);
> > +       __mod_zone_page_state(zone, NR_INACTIVE_ANON + file * LRU_FILE,
> > +                                                       nr_deactivated);
> >        spin_unlock_irq(&zone->lru_lock);
> >  }
