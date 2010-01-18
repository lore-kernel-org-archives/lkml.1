Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142Ab0ARCK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab0ARCK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 21:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905Ab0ARCK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 21:10:58 -0500
Received: from mail-pz0-f190.google.com ([209.85.222.190]:37233 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab0ARCK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 21:10:57 -0500
X-Greylist: delayed 1417 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Jan 2010 21:10:57 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bUaEseAGxptUa39MWDTStQq6J4AgP/Aal+aLx/tBXA7I4zm04WRjSQbNYGgkb6Xyn3
         Otr+7Xrq2VZk2ncX2J5galxZkFhYd8RBmAvbAUmsZnUISDuM5YYYb0EK76XU4YPd+wOP
         6BSMDB9/IMYFNavsAf9ckVQ6AtrhZpfeyJjjE=
MIME-Version: 1.0
In-Reply-To: <20100118104910.AE2D.A69D9226@jp.fujitsu.com>
References: <20100118100359.AE22.A69D9226@jp.fujitsu.com>
	 <28c262361001171747w450c8fd8j4daf84b72fb68e1a@mail.gmail.com>
	 <20100118104910.AE2D.A69D9226@jp.fujitsu.com>
Date: Mon, 18 Jan 2010 11:10:56 +0900
Message-ID: <28c262361001171810w544614b7rdd3df0f984692f35@mail.gmail.com>
Subject: Re: [PATCH 2/3][v2] vmstat: add anon_scan_ratio field to zoneinfo
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I missed Cc.

On Mon, Jan 18, 2010 at 10:54 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> Hi, KOSAKI.
>>
>> On Mon, Jan 18, 2010 at 10:04 AM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> >> Hi, KOSAKI.
>> >>
>> >> On Thu, Jan 14, 2010 at 2:18 PM, KOSAKI Motohiro
>> >> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> >> >> > Well. zone->lock and zone->lru_lock should be not taked at the same time.
>> >> >>
>> >> >> I looked over the code since I am out of office.
>> >> >> I can't find any locking problem zone->lock and zone->lru_lock.
>> >> >> Do you know any locking order problem?
>> >> >> Could you explain it with call graph if you don't mind?
>> >> >>
>> >> >> I am out of office by tomorrow so I can't reply quickly.
>> >> >> Sorry for late reponse.
>> >> >
>> >> > This is not lock order issue. both zone->lock and zone->lru_lock are
>> >> > hotpath lock. then, same tame grabbing might cause performance impact.
>> >>
>> >> Sorry for late response.
>> >>
>> >> Your patch makes get_anon_scan_ratio of zoneinfo stale.
>> >> What you said about performance impact is effective when VM pressure high.
>> >> I think stale data is all right normally.
>> >> But when VM pressure is high and we want to see the information in zoneinfo(
>> >> this case is what you said), stale data is not a good, I think.
>> >>
>> >> If it's not a strong argue, I want to use old get_scan_ratio
>> >> in get_anon_scan_ratio.
>> >
>> > please looks such function again.
>> >
>> > usally we use recent_rotated/recent_scanned ratio. then following
>> > decreasing doesn't change any scan-ratio meaning. it only prevent
>> > stat overflow.
>>
>> It has a primary role that floating average as well as prevenitng overflow. :)
>> So, It's important.
>>
>> >
>> >        if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
>> >                spin_lock_irq(&zone->lru_lock);
>> >                reclaim_stat->recent_scanned[0] /= 2;
>> >                reclaim_stat->recent_rotated[0] /= 2;
>> >                spin_unlock_irq(&zone->lru_lock);
>> >        }
>> >
>> >
>> > So, I don't think current implementation can show stale data.
>>
>> It can make stale data when high memory pressure happens.
>
> ?? why? and when?
> I think it depend on what's stale mean.
>
> Currently(i.e. before the patch), get_scan_ratio have following fomula.
> in such region, recent_scanned is not protected by zone->lru_lock.
>
>        ap = (anon_prio + 1) * (reclaim_stat->recent_scanned[0] + 1);
>        ap /= reclaim_stat->recent_rotated[0] + 1;
>        fp = (file_prio + 1) * (reclaim_stat->recent_scanned[1] + 1);
>        fp /= reclaim_stat->recent_rotated[1] + 1;
>        percent[0] = 100 * ap / (ap + fp + 1);
>        percent[1] = 100 - percent[0];
>
> It mean, shrink_zone() doesn't use exactly recent_scanned value. then
> zoneinfo can use the same unexactly value.

Absoultely right. I missed that. Thanks.
get_scan_ratio used lru_lock to get reclaim_stat->recent_xxxx.
But, it doesn't used lru_lock to get ap/fp.

Is it intentional? I think you or Rik know it. :)
I think if we want to get exact value, we have to use lru_lock until
getting ap/fp.
If it isn't, we don't need lru_lock when we get the reclaim_stat->recent_xxxx.

What do you think about it?

>
>
>> Moreever, I don't want to make complicate thing(ie, need_update)
>> than old if it doesn't have some benefit.(I think lru_lock isn't big overhead)
>
> Hmm..
> I think lru_lock can makes big overhead.

I don't want to argue strongly about this.
That's because i don't have seen that.
If you have a conern about lru_lock, I don't opposed your patch.

-- 
Kind regards,
Minchan Kim
