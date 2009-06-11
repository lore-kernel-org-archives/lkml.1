Return-Path: <linux-kernel-owner+w=401wt.eu-S1763515AbZFKL7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763515AbZFKL7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbZFKL71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:59:27 -0400
Received: from mail-yx0-f203.google.com ([209.85.210.203]:35021 "EHLO
	mail-yx0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbZFKL70 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:59:26 -0400
X-Greylist: delayed 2325 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Jun 2009 07:59:26 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XI9TF1ur0r18jLyYmNPsrZQarscCAePQtTjgRAFYbBRJZpHQpjbVEHYkrp04Com11m
         GKx6UrHEpyUuHkFVeMVeG9UMsdXta3NAA4pSUQsjX2Mv+dC5CxvOKzpdEzXWfvLnRjee
         uUbZBKhtG6SGMh6q+nu5Excu1ASC83iOgDt1E=
MIME-Version: 1.0
In-Reply-To: <9d4a7c0691aa5e13247f694f2dfe55ad.squirrel@webmail-b.css.fujitsu.com>
References: <20090611165535.cf46bf29.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090611170152.7a43b13b.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090611172249.6D3C.A69D9226@jp.fujitsu.com>
	 <20090611173819.0f76e431.kamezawa.hiroyu@jp.fujitsu.com>
	 <28c262360906110237u1f3d1877hae54a51575955549@mail.gmail.com>
	 <9d4a7c0691aa5e13247f694f2dfe55ad.squirrel@webmail-b.css.fujitsu.com>
Date: Thu, 11 Jun 2009 20:59:28 +0900
Message-ID: <28c262360906110459s923d7a6p4e555344e8bbd265@mail.gmail.com>
Subject: Re: [PATCH 2/3] check unevictable flag in lumy reclaim v2
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       apw@canonical.com, riel@redhat.com, mel@csn.ul.ie,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/11 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> Minchan Kim さん wrote:
>> On Thu, Jun 11, 2009 at 5:38 PM, KAMEZAWA
>> Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>> How about this ?
>>>
>>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>>
>>> Lumpy reclaim check pages from their pfn. Then, it can find unevictable
>>> pages
>>> in its loop.
>>> Abort lumpy reclaim when we find Unevictable page, we never get a lump
>>> of pages for requested order.
>>>
>>> Changelog: v1->v2
>>> ?- rewrote commet.
>>>
>>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>> ---
>>> ?mm/vmscan.c | ? ?9 +++++++++
>>> ?1 file changed, 9 insertions(+)
>>>
>>> Index: lumpy-reclaim-trial/mm/vmscan.c
>>> ===================================================================
>>> --- lumpy-reclaim-trial.orig/mm/vmscan.c
>>> +++ lumpy-reclaim-trial/mm/vmscan.c
>>> @@ -936,6 +936,15 @@ static unsigned long isolate_lru_pages(u
>>> ? ? ? ? ? ? ? ? ? ? ? ?/* Check that we have not crossed a zone
>>> boundary. */
>>> ? ? ? ? ? ? ? ? ? ? ? ?if (unlikely(page_zone_id(cursor_page) !=
>>> zone_id))
>>> ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?continue;
>>> + ? ? ? ? ? ? ? ? ? ? ? /*
>>> + ? ? ? ? ? ? ? ? ? ? ? ?* We tries to free all pages in this range to
>>> create
>>> + ? ? ? ? ? ? ? ? ? ? ? ?* a free large page. Then, if the range
>>> includes a page
>>> + ? ? ? ? ? ? ? ? ? ? ? ?* never be reclaimed, we have no reason to do
>>> more.
>>> + ? ? ? ? ? ? ? ? ? ? ? ?* PageUnevictable page is not a page which can
>>> be
>>> + ? ? ? ? ? ? ? ? ? ? ? ?* easily freed. Abort this scan now.
>>> + ? ? ? ? ? ? ? ? ? ? ? ?*/
>>> + ? ? ? ? ? ? ? ? ? ? ? if (unlikely(PageUnevictable(cursor_page)))
>>> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? break;
>>
>> __isolate_lru_pages already checked PageUnevictable to return error.
>> I want to remove repeated check although it is trivial.
>>
>> By your patch, It seems to remove PageUnevictable check in
>> __isolate_lru_pages.
>>
> yes.
>
>> But I know that. If we remove PageUnevictable check in
>> __isolate_lru_pages, it can't go into BUG in non-lumpy case. ( I
>> mentioned following as code)
>>
> In non-lumpy case, we'll never see Unevictable, maybe.

I think so if it doesn't happen RAM failure.
AFAIK, Unevictable check didn't related with RAM failure.

>
>>                 case -EBUSY:
>>                         /* else it is being freed elsewhere */
>>                         list_move(&page->lru, src);
>>                         continue;
>>
>>                 default:
>>                         BUG();
>>                 }
>>
>>
>> It means we can remove BUG in non-lumpy case and then add BUG into
>> __isolate_lru_pages directly.
>>
>> If we can do it, we can remove unnecessary PageUnevictable check in
>> __isolate_lru_page.
>>
> Hmm, but Unevicable check had tons of troubles at its implementation
> and I don't want to do it at once.

I think it's not a big problem.
As comment said, the check's goal is to prevent in lumpy case.
        /*
         * When this function is being called for lumpy reclaim, we
         * initially look into all LRU pages, active, inactive and
         * unevictable; only give shrink_page_list evictable pages.
         */
        if (PageUnevictable(page))
                return ret;

So I think we can remove this check.

>> I am not sure this is right in case of memcg.
>>
> I think we don't see Unevictable in memcg's path if my memcg-lru code
> works as designed.
>
> I'll postpone this patch for a while until my brain works well.

If you have a concern about that, how about this ?
(This code will be hunk since gmail webserver always mangle. Pz,forgive me)
Also, we can CC original authors.

--- a/mm/vmscan.c
++ b/mm/vmscan.c
@@ -936,19 +936,20 @@ static unsigned long isolate_lru_pages(unsigned
long nr_to_scan,
                        /* Check that we have not crossed a zone boundary. */
                        if (unlikely(page_zone_id(cursor_page) != zone_id))
                                continue;
-                       switch (__isolate_lru_page(cursor_page, mode, file)) {
-                       case 0:
+                       if (__isolate_lru_page(cursor_page, mode, file) == 0) {
                                list_move(&cursor_page->lru, dst);
                                nr_taken++;
                                scan++;
-                               break;
-
-                       case -EBUSY:
-                               /* else it is being freed elsewhere */
-                               list_move(&cursor_page->lru, src);
-                       default:
-                               break;  /* ! on LRU or wrong list */
                        }
+                       else if (PageUnevictable(cursor_page))
+                                       /*
+                                * We tries to free all pages in this
range to create
+                                * a free large page. Then, if the
range includes a page
+                                * never be reclaimed, we have no
reason to do more.
+                                * PageUnevictable page is not a page
which can be
+                                * easily freed. Abort this scan now.
+                                */
+                               break
                }
        }


> Thanks,
> -Kame
>
>



-- 
Kinds regards,
Minchan Kim
