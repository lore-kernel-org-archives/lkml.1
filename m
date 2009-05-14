Return-Path: <linux-kernel-owner+w=401wt.eu-S1760353AbZENHkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353AbZENHkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 03:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757189AbZENHkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 03:40:23 -0400
Received: from mail-px0-f191.google.com ([209.85.216.191]:46589 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543AbZENHkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 03:40:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=ACavNvZsqmVQsb/3aaZDgLrAnHIHOd9WFr4oJEimocGHaf8LrmJu1OEJMa01oO7F96
         nv3x2xd54hpfDYntJbYmzLV/gy2vx08Z6lsYc6YNTEBgKdJ4yOW7FewCLWeDwFefpLzQ
         vjUI1j3BtOKslPNixXsW08MPiCzEsonxUmFQw=
Date: Thu, 14 May 2009 16:40:10 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] Prevent shrinking of active anon lru list in case of no
 swap space
Message-Id: <20090514164010.25335493.minchan.kim@barrios-desktop>
In-Reply-To: <20090514155504.9B66.A69D9226@jp.fujitsu.com>
References: <20090514141025.239cafe5.minchan.kim@barrios-desktop>
	<20090514155504.9B66.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009 16:19:52 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > 
> > Now shrink_active_list is called several places.
> > But if we don't have a swap space, we can't reclaim anon pages.
> > So, we don't need deactivating anon pages in anon lru list.
> > 
> > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> > Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Rik van Riel <riel@redhat.com>
> 
> hm, The analysis seems right. but
> 
> In general branch should put into non frequency path.
> why caller modification as following patch is wrong?

Yes. You're right. Firstly I though that. 
But there are a few place where inactve_anon_is_low is called.
In addition to it, we always have to call with (nr_swap_pages <= 0) with it. 
So alone inactive_anon_is_low is lost function's meaning.

I think it's meaningless. 
But We can improve one function wrapper.

/* I can't be remind proper function name. Can you suggest me ? */
if (do_we_have_to_shrink_list(zone, &sc))


int do_we_have_to_shrink_list(...)
{
   if (inactive_anon_is_low(zone, &sc) && (nr_swap_pages <= 0))
   
}

What do you think ?

> 
>                         /*
>                          * Do some background aging of the anon list, to give
>                          * pages a chance to be referenced before reclaiming.
>                          */
> -                        if (inactive_anon_is_low(zone, &sc))
> +                        if (inactive_anon_is_low(zone, &sc) && (nr_swap_pages <= 0))
>                                 shrink_active_list(SWAP_CLUSTER_MAX, zone,
>                                                         &sc, priority, 0);
> 
> 
> 
> 
> > ---
> >  mm/vmscan.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 2f9d555..e4d71f4 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1238,6 +1238,12 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
> >  	enum lru_list lru;
> >  	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
> >  
> > +	/* 
> > +	 * we can't shrink anon list in case of no swap space.
> > +	 */
> > +	if (file == 0 && nr_swap_pages <= 0)
> > +		return;
> > +
> >
> >  	lru_add_drain();
> >  	spin_lock_irq(&zone->lru_lock);
> >  	pgmoved = sc->isolate_pages(nr_pages, &l_hold, &pgscanned, sc->order,
> > -- 
> > 1.5.4.3
> > 
> > 
> > -- 
> > Kinds Regards
> > Minchan Kim
> 
> 
> 


-- 
Kinds Regards
Minchan Kim
