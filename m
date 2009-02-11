Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbZBKLuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbZBKLuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 06:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbZBKLuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 06:50:44 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48822 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbZBKLun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 06:50:43 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: MinChan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] shrink_all_memory() use sc.nr_reclaimed
Cc: kosaki.motohiro@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>,
       Rik van Riel <riel@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       William Lee Irwin III <wli@movementarian.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20090211003715.GB6422@barrios-desktop>
References: <2f11576a0902101241j5a006e09w46ecdbdb9c77e081@mail.gmail.com> <20090211003715.GB6422@barrios-desktop>
Message-Id: <20090211204453.C3C3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed, 11 Feb 2009 20:50:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Feb 11, 2009 at 05:41:21AM +0900, KOSAKI Motohiro wrote:
> > >>  {
> > >>       struct zone *zone;
> > >> -     unsigned long nr_to_scan, ret = 0;
> > >> +     unsigned long nr_to_scan;
> > >>       enum lru_list l;
> > >
> > > Basing it on swsusp-clean-up-shrink_all_zones.patch probably makes it
> > > easier for Andrew to pick it up.
> > 
> > ok, thanks.
> > 
> > >>                       reclaim_state.reclaimed_slab = 0;
> > >> -                     shrink_slab(nr_pages, sc.gfp_mask, global_lru_pages());
> > >> -                     ret += reclaim_state.reclaimed_slab;
> > >> -             } while (ret < nr_pages && reclaim_state.reclaimed_slab > 0);
> > >> +                     shrink_slab(nr_pages, sc.gfp_mask,
> > >> +                                 global_lru_pages());
> > >> +                     sc.nr_reclaimed += reclaim_state.reclaimed_slab;
> > >> +             } while (sc.nr_reclaimed < nr_pages &&
> > >> +                      reclaim_state.reclaimed_slab > 0);
> > >
> > > :(
> > >
> > > Is this really an improvement?  `ret' is better to read than
> > > `sc.nr_reclaimed'.
> > 
> > I know it's debetable thing.
> > but I still think code consistency is important than variable name preference.
> 
> How about this ?
> 
> I followed do_try_to_free_pages coding style.
> It use both 'sc->nr_reclaimed' and 'ret'.
> It can support code consistency and readability. 
> 
> So, I think it would be better.  
> If you don't mind, I will resend with your sign-off.

looks good. thanks.


> -static unsigned long shrink_all_zones(unsigned long nr_pages, int prio,
> +static void shrink_all_zones(unsigned long nr_pages, int prio,
>  				      int pass, struct scan_control *sc)
>  {
>  	struct zone *zone;
>  	unsigned long nr_to_scan, ret = 0;
> +	unsigned long nr_reclaimed = sc->nr_reclaimed;
>  	enum lru_list l;

and, please changelog change.
this patch have behavior change.

old bale-out checking didn't checked properly.
it's because shrink_all_memory() has five pass. but shrink_all_zones()
initialize ret = 0 every time.

then, at pass 1-4, if(ret >= nr_pages) don't judge reclaimed enough page or not.




