Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbZBKMnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbZBKMnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbZBKMnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:43:37 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:13089 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbZBKMng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:43:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=hwOZ3wQsJFBVDR5SWnOIz0a1qBfA98b6Rspk+axflVmqTRuTMMl4FVWKZXfw5d7dxu
         eV/v93CfHTJPqeTe2HE8tFRhSFxTaqwjwEOWtoE4Z01tSo14cj77sskbYeQQ6CiGnebg
         Vacky7CK8G5pV/S/Y8/VbNnv5xFlzkOIOA+fs=
Date: Wed, 11 Feb 2009 21:43:24 +0900
From: MinChan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: MinChan Kim <minchan.kim@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Rik van Riel <riel@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       William Lee Irwin III <wli@movementarian.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] shrink_all_memory() use sc.nr_reclaimed
Message-Id: <20090211214324.6a9cfb58.minchan.kim@barrios-desktop>
In-Reply-To: <20090211204453.C3C3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <2f11576a0902101241j5a006e09w46ecdbdb9c77e081@mail.gmail.com>
	<20090211003715.GB6422@barrios-desktop>
	<20090211204453.C3C3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Feb 2009 20:50:37 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > On Wed, Feb 11, 2009 at 05:41:21AM +0900, KOSAKI Motohiro wrote:
> > > >>  {
> > > >>       struct zone *zone;
> > > >> -     unsigned long nr_to_scan, ret = 0;
> > > >> +     unsigned long nr_to_scan;
> > > >>       enum lru_list l;
> > > >
> > > > Basing it on swsusp-clean-up-shrink_all_zones.patch probably makes it
> > > > easier for Andrew to pick it up.
> > > 
> > > ok, thanks.
> > > 
> > > >>                       reclaim_state.reclaimed_slab = 0;
> > > >> -                     shrink_slab(nr_pages, sc.gfp_mask, global_lru_pages());
> > > >> -                     ret += reclaim_state.reclaimed_slab;
> > > >> -             } while (ret < nr_pages && reclaim_state.reclaimed_slab > 0);
> > > >> +                     shrink_slab(nr_pages, sc.gfp_mask,
> > > >> +                                 global_lru_pages());
> > > >> +                     sc.nr_reclaimed += reclaim_state.reclaimed_slab;
> > > >> +             } while (sc.nr_reclaimed < nr_pages &&
> > > >> +                      reclaim_state.reclaimed_slab > 0);
> > > >
> > > > :(
> > > >
> > > > Is this really an improvement?  `ret' is better to read than
> > > > `sc.nr_reclaimed'.
> > > 
> > > I know it's debetable thing.
> > > but I still think code consistency is important than variable name preference.
> > 
> > How about this ?
> > 
> > I followed do_try_to_free_pages coding style.
> > It use both 'sc->nr_reclaimed' and 'ret'.
> > It can support code consistency and readability. 
> > 
> > So, I think it would be better.  
> > If you don't mind, I will resend with your sign-off.
> 
> looks good. thanks.
> 
> 
> > -static unsigned long shrink_all_zones(unsigned long nr_pages, int prio,
> > +static void shrink_all_zones(unsigned long nr_pages, int prio,
> >  				      int pass, struct scan_control *sc)
> >  {
> >  	struct zone *zone;
> >  	unsigned long nr_to_scan, ret = 0;
> > +	unsigned long nr_reclaimed = sc->nr_reclaimed;
> >  	enum lru_list l;
> 
> and, please changelog change.
> this patch have behavior change.
> 
> old bale-out checking didn't checked properly.
> it's because shrink_all_memory() has five pass. but shrink_all_zones()
> initialize ret = 0 every time.
> 
> then, at pass 1-4, if(ret >= nr_pages) don't judge reclaimed enough page or not.
> 

Hmm, I think old bale-out code is right. 
In shrink_all_memory, As more reclaiming with pass progressing, 
the smaller nr_to_scan is. The nr_to_scan is the number of page shrinking which
user want. 
The shrink_all_zones have to reclaim nr_to_scan's page by doing best effort.
So, If you use accumulation of reclaim, it can break bale-out in shrink_all_zones.
I mean here.

'
              NR_LRU_BASE + l)); 
        ret += shrink_list(l, nr_to_scan, zone,
                sc, prio);
        if (ret >= nr_pages)
          return ret; 
      }    
'

I have to make patch again so that it will keep on old bale-out behavior. 

-- 
Kinds Regards
MinChan Kim
