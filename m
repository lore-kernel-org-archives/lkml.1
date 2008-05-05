Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbYEEFV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbYEEFV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 01:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbYEEFVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 01:21:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:2915 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbYEEFVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 01:21:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tXU3ahx3NnJLGgyWYYsdJ3nYVd5Bz8gzSdc6pb2oUqhy3AZ3GJ72t0+VA6EhJbSfkLx7JuFut0SWqS4VtCX2RFdIpnLIo8eW2FkQoCKwYiQYyJy+S0tS/Za8Ve/A21/A6Fiq222vUCF6Cy/ssK4zbtBpN95FQ6S4X6SzBS1i3N4=
Message-ID: <44c63dc40805042221s4eb347acu6e7d86310696825f@mail.gmail.com>
Date: Mon, 5 May 2008 14:21:15 +0900
From: "minchan Kim" <barrioskmc@gmail.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 4/5] core of reclaim throttle
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080504221043.8F64.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080504201343.8F52.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080504215819.8F5E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080504221043.8F64.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  @@ -120,6 +125,7 @@ struct scan_control {
>   int vm_swappiness = 60;
>   long vm_total_pages;   /* The total number of pages which the VM controls */
>
>  +#define MAX_RECLAIM_TASKS CONFIG_NR_MAX_RECLAIM_TASKS_PER_ZONE
>   static LIST_HEAD(shrinker_list);
>   static DECLARE_RWSEM(shrinker_rwsem);
>
>  @@ -1187,7 +1193,46 @@ static int shrink_zone(int priority, str
>
>         unsigned long nr_inactive;
>         unsigned long nr_to_scan;
>         unsigned long nr_reclaimed = 0;
>  +       int ret = 0;
>  +       int throttle_on = 0;
>  +       unsigned long freed;
>  +       unsigned long threshold;
>
> +
>  +       /* avoid recursing wait_evnet */
>  +       if (current->flags & PF_RECLAIMING)
>  +               goto shrinking;
>  +
>  +       throttle_on = 1;
>  +       current->flags |= PF_RECLAIMING;
>  +       wait_event(zone->reclaim_throttle_waitq,
>  +                atomic_add_unless(&zone->nr_reclaimers, 1, MAX_RECLAIM_TASKS));
>  +
>  +       /* in some situation (e.g. hibernation), shrink processing shouldn't be
>  +          cut off even though large memory freeded.  */
>  +       if (!sc->may_cut_off)
>  +               goto shrinking;
>  +

where do you initialize may_cut_off ?
Current Implementation, may_cut_off is always "0" so always goto shrinking
-- 
Thanks,
barrios
