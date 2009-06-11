Return-Path: <linux-kernel-owner+w=401wt.eu-S1761782AbZFKJjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761782AbZFKJjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 05:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758480AbZFKJi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 05:38:59 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:43486 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbZFKJi7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 05:38:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ggMTFtUqnAa0zXkNUFCsyRHubyXjeelM4+aUtwqKdnuU8SPAWtreNjA+nHrzHeLo0c
         pd3uB0PTf6Pe0P3f854wh50Ne3biRuPUqAmH7pnpkrfP0wFBvYuCv+8I2W8ayG2AytWT
         9eKqVXl7BPdueeT5cEA7/roCQBIq2ubOww7Lw=
MIME-Version: 1.0
In-Reply-To: <28c262360906110237u1f3d1877hae54a51575955549@mail.gmail.com>
References: <20090611165535.cf46bf29.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090611170152.7a43b13b.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090611172249.6D3C.A69D9226@jp.fujitsu.com>
	 <20090611173819.0f76e431.kamezawa.hiroyu@jp.fujitsu.com>
	 <28c262360906110237u1f3d1877hae54a51575955549@mail.gmail.com>
Date: Thu, 11 Jun 2009 18:39:01 +0900
Message-ID: <28c262360906110239g1e4d0fabg15dc33111014e96a@mail.gmail.com>
Subject: Re: [PATCH 2/3] check unevictable flag in lumy reclaim v2
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       apw@canonical.com, riel@redhat.com, mel@csn.ul.ie
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 6:37 PM, Minchan Kim<minchan.kim@gmail.com> wrote:
> On Thu, Jun 11, 2009 at 5:38 PM, KAMEZAWA
> Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> How about this ?
>>
>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>> Lumpy reclaim check pages from their pfn. Then, it can find unevictable pages
>> in its loop.
>> Abort lumpy reclaim when we find Unevictable page, we never get a lump
>> of pages for requested order.
>>
>> Changelog: v1->v2
>>  - rewrote commet.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> ---
>>  mm/vmscan.c |    9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> Index: lumpy-reclaim-trial/mm/vmscan.c
>> ===================================================================
>> --- lumpy-reclaim-trial.orig/mm/vmscan.c
>> +++ lumpy-reclaim-trial/mm/vmscan.c
>> @@ -936,6 +936,15 @@ static unsigned long isolate_lru_pages(u
>>                        /* Check that we have not crossed a zone boundary. */
>>                        if (unlikely(page_zone_id(cursor_page) != zone_id))
>>                                continue;
>> +                       /*
>> +                        * We tries to free all pages in this range to create
>> +                        * a free large page. Then, if the range includes a page
>> +                        * never be reclaimed, we have no reason to do more.
>> +                        * PageUnevictable page is not a page which can be
>> +                        * easily freed. Abort this scan now.
>> +                        */
>> +                       if (unlikely(PageUnevictable(cursor_page)))
>> +                               break;
>
> __isolate_lru_pages already checked PageUnevictable to return error.
> I want to remove repeated check although it is trivial.
>
> By your patch, It seems to remove PageUnevictable check in __isolate_lru_pages.

typo.

It seems we can remove PageUnevictable check in __isolate_lru_pages.
Sorry for noise.

> But I know that. If we remove PageUnevictable check in
> __isolate_lru_pages, it can't go into BUG in non-lumpy case. ( I
> mentioned following as code)
>
>                case -EBUSY:
>                        /* else it is being freed elsewhere */
>                        list_move(&page->lru, src);
>                        continue;
>
>                default:
>                        BUG();
>                }
>
>
> It means we can remove BUG in non-lumpy case and then add BUG into
> __isolate_lru_pages directly.
>
> If we can do it, we can remove unnecessary PageUnevictable check in
> __isolate_lru_page.
>
> I am not sure this is right in case of memcg.
>
> --
> Kinds regards,
> Minchan Kim
>



-- 
Kinds regards,
Minchan Kim
