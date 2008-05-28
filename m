Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbYE1QXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbYE1QXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 12:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYE1QXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 12:23:11 -0400
Received: from rcpt-mqugw.biglobe.ne.jp ([133.205.19.70]:48930 "EHLO
	rcpt-mqugw.biglobe.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbYE1QXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 12:23:10 -0400
X-Greylist: delayed 2365 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 May 2008 12:23:10 EDT
X-Biglobe-Sender: <d-nishimura@mtf.biglobe.ne.jp>
Message-ID: <483D7D7C.70607@mtf.biglobe.ne.jp>
Date: Thu, 29 May 2008 00:42:52 +0900
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>
Reply-To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm 07/16] second chance replacement for anonymous pages
References: <20080523195506.084894989@redhat.com>	<20080523195535.302440037@redhat.com>	<483CEF78.9050802@mxp.nes.nec.co.jp> <20080528093918.37660860@bree.surriel.com>
In-Reply-To: <20080528093918.37660860@bree.surriel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On Wed, 28 May 2008 14:36:56 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
>>>  	/*
>>> +	 * Count the referenced anon pages as rotated, to balance pageout
>>> +	 * scan pressure between file and anonymous pages in get_sacn_ratio.
>>> +	 */
>>> +	if (!file)
>>> +		zone->recent_rotated_anon += pgmoved;
>>> +
>> Shouldn't 'pgmoved' be cleared to 0 before scanning l_hold?
>> It's used to store the result of sc->isolate_pages() before
>> scanning l_hold.
> 
> It is zeroed 2 statements down.
> 
>         if (!file)
>                 zone->recent_rotated_anon += pgmoved;
> 
>         /*
>          * Now put the pages back on the appropriate [file or anon] inactive
>          * and active lists.
>          */
>         pagevec_init(&pvec, 1);
>         pgmoved = 0;
> 

When all the patches applied, shrink_active_list() looks like:

   1135         pgmoved = sc->isolate_pages(nr_pages, &l_hold, &pgscanned, sc->order,
   1136                                         ISOLATE_ACTIVE, zone,
   1137                                         sc->mem_cgroup, 1, file);
     :
   1150         if (file)
   1151                 __mod_zone_page_state(zone, NR_ACTIVE_FILE, -pgmoved);
   1152         else
   1153                 __mod_zone_page_state(zone, NR_ACTIVE_ANON, -pgmoved);
   1154         spin_unlock_irq(&zone->lru_lock);
   1155 
   1156         while (!list_empty(&l_hold)) {
     :
   1166                 if (page_referenced(page, 0, sc->mem_cgroup) && file) {
   1167                         /* Referenced file pages stay active. */
   1168                         list_add(&page->lru, &l_active);
   1169                 } else {
   1170                         list_add(&page->lru, &l_inactive);
   1171                         if (!file)
   1172                                 /* Anonymous pages always get deactivated. */
   1173                                 pgmoved++;
     :
   1178                 }
   1179         }
   1180 
   1181         /*
   1182          * Count the referenced anon pages as rotated, to balance pageout
   1183          * scan pressure between file and anonymous pages in get_sacn_ratio.
   1184          */
   1185         if (!file)
   1186                 zone->recent_rotated_anon += pgmoved;

So, I wondered that there is no need to clear pgmoved before 1156 line.


Thanks,
Daisuke Nishimura.


