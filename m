Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbYFYNFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbYFYNFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 09:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbYFYNFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 09:05:42 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:39762 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbYFYNFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 09:05:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hdxIAp1R9+D5L1UzHyIi+Bq1J6G0WM1u9tHdOjnAYqC4KmWFcorMMg52E4RMI8htCH
         4dRBzW9nYLl5DQ8WcBlLF0u4tg5FudBzyPKcmTHIesP/qmllGywn1VUQpGEFx8+0swB6
         FSHoP3RrGbh9pzCgGpGTh/wj8bSWTuZkv//Ww=
Message-ID: <28c262360806250605le31ba48ma8bb16f996783142@mail.gmail.com>
Date: Wed, 25 Jun 2008 22:05:40 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [RFC][PATCH] prevent incorrect oom under split_lru
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Rik van Riel" <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>, akpm@linux-foundation.org,
       "Takenori Nagano" <t-nagano@ah.jp.nec.com>
In-Reply-To: <1214395885.15232.17.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080624092824.4f0440ca@bree.surriel.com>
	 <28c262360806242259k3ac308c4n7cee29b72456e95b@mail.gmail.com>
	 <20080625150141.D845.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <28c262360806242356n3f7e02abwfee1f6acf0fd2c61@mail.gmail.com>
	 <1214395885.15232.17.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 9:11 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2008-06-25 at 15:56 +0900, MinChan Kim wrote:
>> On Wed, Jun 25, 2008 at 3:08 PM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> > Hi Kim-san,
>> >
>> >> >> So, if priority==0, We should try to reclaim all page for prevent OOM.
>> >> >
>> >> > You are absolutely right.  Good catch.
>> >>
>> >> I have a concern about application latency.
>> >> If lru list have many pages, it take a very long time to scan pages.
>> >> More system have many ram, More many time to scan pages.
>> >
>> > No problem.
>> >
>> > priority==0 indicate emergency.
>> > it doesn't happend on typical workload.
>> >
>>
>> I see :)
>>
>> But if such emergency happen in embedded system, application can't be
>> executed for some time.
>> I am not sure how long time it take.
>> But In some application, schedule period is very important than memory
>> reclaim latency.
>>
>> Now, In your patch, when such emergency happen, it continue to reclaim
>> page until it will scan entire page of lru list.
>> It
>
> IMHO embedded real-time apps shoud mlockall() and not do anything that
> can result in memory allocations in their fast (deterministic) paths.
Hi peter,

I agree with you.  but if application's virtual address space is big,
we have a hard problem with mlockall since memory pressure might be a
big.
Of course, It will be a RT application design problem.

> The much more important case is desktop usage - that is where we run non
> real-time code, but do expect 'low' latency due to user-interaction.
>
> >From hitting swap on my 512M laptop (rather frequent occurance) I know
> we can do better here,..
>

Absolutely. It is another example. So, I suggest following patch.
It's based on idea of Takenori Nagano's memory reclaim more efficiently.

I expect It will reduce application latency and will not have a regression.
How about you ?

Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
---
 mm/vmscan.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9a5e423..07477cc 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1460,9 +1460,12 @@ static unsigned long shrink_zone(int priority,
struct zone *zone,
                         * kernel will slowly sift through each list.
                         */
                        scan = zone_page_state(zone, NR_LRU_BASE + l);
-                       scan >>= priority;
-                       scan = (scan * percent[file]) / 100;
+                       if (priority) {
+                               scan >>= priority;
+                               scan = (scan * percent[file])/10;
+                       }
                        zone->lru[l].nr_scan += scan + 1;
+
                        nr[l] = zone->lru[l].nr_scan;
                        if (nr[l] >= sc->swap_cluster_max)
                                zone->lru[l].nr_scan = 0;
@@ -1489,6 +1492,9 @@ static unsigned long shrink_zone(int priority,
struct zone *zone,

                                nr_reclaimed += shrink_list(l, nr_to_scan,
                                                        zone, sc, priority);
+                               if (priority == 0 && !current_is_kswapd() &&
+                                       nr_reclaimed >= sc->swap_cluster_max)
+                                       break;
                        }
                }
        }
-- 
1.5.4.3




-- 
Kinds regards,
MinChan Kim
