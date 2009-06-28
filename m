Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbZF1PBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbZF1PBp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 11:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbZF1PBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 11:01:38 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:62821 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbZF1PBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 11:01:37 -0400
X-Greylist: delayed 707 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Jun 2009 11:01:37 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sxrlRY061SBbqRn4ZoRyh3k92H5PvHIonlGzBVheMyobP9msoDPPeluEQyOxTzrabi
         spDMvx2BoTkjDUcW0qKEdpDf9DDhEwnfWPRwd44LfATba8YAy+mI4BSSU+vRhi7XrLgx
         qlHdKX/cpU0tZZTFBXdKzvyCF/F4TSvMlD6ws=
MIME-Version: 1.0
In-Reply-To: <20090628142239.GA20986@localhost>
References: <32411.1245336412@redhat.com> <2015.1245341938@redhat.com>
	 <20090618095729.d2f27896.akpm@linux-foundation.org>
	 <7561.1245768237@redhat.com> <26537.1246086769@redhat.com>
	 <20090627125412.GA1667@cmpxchg.org> <20090628113246.GA18409@localhost>
	 <28c262360906280630n557bb182n5079e33d21ea4a83@mail.gmail.com>
	 <28c262360906280636l93130ffk14086314e2a6dcb7@mail.gmail.com>
	 <20090628142239.GA20986@localhost>
Date: Mon, 29 Jun 2009 00:01:40 +0900
X-Google-Sender-Auth: 5d16f3f9924a87f2
Message-ID: <2f11576a0906280801w417d1b9fpe10585b7a641d41b@mail.gmail.com>
Subject: Re: Found the commit that causes the OOMs
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
       David Howells <dhowells@redhat.com>,
       "riel@redhat.com" <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, smaller inactive_anon means smaller (pointless) nr_scanned,
> and therefore less slab scans. Strictly speaking, it's not the fault
> of your patch. It indicates that the slab scan ratio algorithm should
> be updated too :)

I don't think this patch is related to minchan's patch.
but I think this patch is good.


> We could refine the estimation of "reclaimable" pages like this:

hmhm, reasonable idea.

>
> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> index 416f748..e9c5b0e 100644
> --- a/include/linux/vmstat.h
> +++ b/include/linux/vmstat.h
> @@ -167,14 +167,7 @@ static inline unsigned long zone_page_state(struct zone *zone,
>  }
>
>  extern unsigned long global_lru_pages(void);
> -
> -static inline unsigned long zone_lru_pages(struct zone *zone)
> -{
> -       return (zone_page_state(zone, NR_ACTIVE_ANON)
> -               + zone_page_state(zone, NR_ACTIVE_FILE)
> -               + zone_page_state(zone, NR_INACTIVE_ANON)
> -               + zone_page_state(zone, NR_INACTIVE_FILE));
> -}
> +extern unsigned long zone_lru_pages(void);
>
>  #ifdef CONFIG_NUMA
>  /*
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 026f452..4281c6f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2123,10 +2123,31 @@ void wakeup_kswapd(struct zone *zone, int order)
>
>  unsigned long global_lru_pages(void)
>  {
> -       return global_page_state(NR_ACTIVE_ANON)
> -               + global_page_state(NR_ACTIVE_FILE)
> -               + global_page_state(NR_INACTIVE_ANON)
> -               + global_page_state(NR_INACTIVE_FILE);
> +       int nr;
> +
> +       nr = global_page_state(zone, NR_ACTIVE_FILE) +
> +            global_page_state(zone, NR_INACTIVE_FILE);
> +
> +       if (total_swap_pages)
> +               nr += global_page_state(zone, NR_ACTIVE_ANON) +
> +                     global_page_state(zone, NR_INACTIVE_ANON);
> +
> +       return nr;
> +}

Please change function name too.
Now, this function only account reclaimable pages.

Plus, total_swap_pages is bad. if we need to concern "reclaimable
pages", we should use nr_swap_pages.
I mean, swap-full also makes anon is unreclaimable althouth system
have sone swap device.



> +
> +
> +unsigned long zone_lru_pages(struct zone *zone)
> +{
> +       int nr;
> +
> +       nr = zone_page_state(zone, NR_ACTIVE_FILE) +
> +            zone_page_state(zone, NR_INACTIVE_FILE);
> +
> +       if (total_swap_pages)
> +               nr += zone_page_state(zone, NR_ACTIVE_ANON) +
> +                     zone_page_state(zone, NR_INACTIVE_ANON);
> +
> +       return nr;
>  }
>
>  #ifdef CONFIG_HIBERNATION
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
