Return-Path: <linux-kernel-owner+w=401wt.eu-S932294AbZLOBNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294AbZLOBNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 20:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758927AbZLOBNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 20:13:50 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:51427 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758434AbZLOBNt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 20:13:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MzCP2Hj/oElbIHx3KzQgS7OhtTYnILnk0aKpfqlfW900lFKp+573XEG20gU/YxnDfN
         fiJ/HCjPW25O5W9eySg5+Ds84fAB5Iz7ysxEve6+RHxTrK1b9C9K6GbtPurXlwr1E1UY
         SQH0CPpBpfccZaJQqc9/iQqCkb8Vjci7VDyh4=
MIME-Version: 1.0
In-Reply-To: <20091215090441.CDB0.A69D9226@jp.fujitsu.com>
References: <20091214213026.BBBD.A69D9226@jp.fujitsu.com>
	 <20091215084636.c7790658.minchan.kim@barrios-desktop>
	 <20091215090441.CDB0.A69D9226@jp.fujitsu.com>
Date: Tue, 15 Dec 2009 10:13:48 +0900
Message-ID: <28c262360912141713t6e0e5915m3bb30aa099914c40@mail.gmail.com>
Subject: Re: [PATCH 5/8] Use io_schedule() instead schedule()
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, lwoodman@redhat.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 9:56 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Mon, 14 Dec 2009 21:30:54 +0900 (JST)
>> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>>
>> > All task sleeping point in vmscan (e.g. congestion_wait) use
>> > io_schedule. then shrink_zone_begin use it too.
>> >
>> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> > ---
>> >  mm/vmscan.c |    2 +-
>> >  1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/mm/vmscan.c b/mm/vmscan.c
>> > index 3562a2d..0880668 100644
>> > --- a/mm/vmscan.c
>> > +++ b/mm/vmscan.c
>> > @@ -1624,7 +1624,7 @@ static int shrink_zone_begin(struct zone *zone, struct scan_control *sc)
>> >                 max_zone_concurrent_reclaimers)
>> >                     break;
>> >
>> > -           schedule();
>> > +           io_schedule();
>>
>> Hmm. We have many cond_resched which is not io_schedule in vmscan.c.
>
> cond_resched don't mean sleep on wait queue. it's similar to yield.

I confused it.
Thanks for correcting me. :)

>
>> In addition, if system doesn't have swap device space and out of page cache
>> due to heavy memory pressue, VM might scan & drop pages until priority is zero
>> or zone is unreclaimable.
>>
>> I think it would be not a IO wait.
>
> two point.
> 1. For long time, Administrator usually watch iowait% at heavy memory pressure. I
> don't hope change this without reasonable reason. 2. iowait makes scheduler
> bonus a bit, vmscan task should have many time slice than memory consume
> task. it improve VM stabilization.

AFAIK, CFS scheduler doesn't give the bonus to I/O wait task any more.

>
> but I agree the benefit isn't so big. if we have reasonable reason, I
> don't oppose use schedule().
>
>
>
>



-- 
Kind regards,
Minchan Kim
