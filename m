Return-Path: <linux-kernel-owner+w=401wt.eu-S1758445AbZLKSBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758445AbZLKSBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 13:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757011AbZLKSBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 13:01:09 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:37549 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693AbZLKSBI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 13:01:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DIdMO0GEcUjgWxdBZngr3wgdF6bq8PxMqA1WTukdxzhA3Xj/rvncwFOllbVcv0rGva
         Icv1m8WBX9fHASxqXiKmP68ps1mwnV/LYasAfunvaStkj4rl6ftfO2JIvf0VroH3h5E9
         PGX5eRTVtcLF+npYUPcOvz43vVjjZ6Glr0Ev0=
MIME-Version: 1.0
In-Reply-To: <20091211150727.GB2756@redhat.com>
References: <4B21D252.1060902@cn.fujitsu.com>
	 <20091211150727.GB2756@redhat.com>
Date: Fri, 11 Dec 2009 19:01:14 +0100
Message-ID: <4e5e476b0912111001h3c0b9798u2a2b25c9fcc39504@mail.gmail.com>
Subject: Re: [PATCH] cfq: Take whether cfq group is changed into account when 
	choosing service tree
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,
On Fri, Dec 11, 2009 at 4:07 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Dec 11, 2009 at 01:02:10PM +0800, Gui Jianfeng wrote:
>> Currently, with IO Controller introduced, CFQ chooses cfq group
>> at the top, and then choose service tree. So we need to take
>> whether cfq group is changed into account to decide whether we
>> should choose service tree start from scratch.
>>
>
> I am not able to understand the need/purpose of this patch. Once we
> switched the group during scheduling, why should we reset the order
> of workload with-in group.

I understand it, and in fact I was thinking about this.
The idea is the same as with priorities. If we have not serviced a group
for a while, we want to start with the no-idle workload to reduce its latency.

Unfortunately, a group may have a too small share, that could cause some
workloads to be starved, as Vivek correctly points out, and we should
avoid this.
It should be easily reproducible testing a "many groups with mixed workloads"
scenario with group_isolation=1.

Moreover, even if the approach is groups on top, when group isolation
is not set (i.e. the default), in the non-root groups you will only
have the sync-idle
queues, so it is much more similar (logically) to a workload on top
than it appears
from the code.

I think the net result of this patch is, when group isolation is not
set, to select no-idle
workload first only when entering the root group, thus a slight
penalization of the
async workload.
Gui, if you observed improvements with this patch, probably you can obtain them
without the starvation drawback by making it conditional to !group_isolation.

BTW, since you always use cfqg_changed and prio_changed OR-ed together, you
can have just one argument, called e.g. boost_no_idle, and you pass
(!group_isolation && cfqg_changed) || prio_changed.

> In fact we don't want to do that and we
> want to start from where we left so that no workload with-in group is
> starved.

Agreed.

Thanks,
Corrado

>
> When a group is resumed, choose_service_tree() always checks if any RT
> queue got backlogged or not. If yes, it does choose that first.
>
> Can you give more details why do you want to do this change?
>
> Thanks
> Vivek
>
>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
>> ---
>>  block/cfq-iosched.c |   27 ++++++++++++++++++---------
>>  1 files changed, 18 insertions(+), 9 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index f3f6239..16084ca 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -1964,7 +1964,7 @@ static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
>>
>>  static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
>>                               struct cfq_group *cfqg, enum wl_prio_t prio,
>> -                             bool prio_changed)
>> +                             bool cfqg_changed, bool prio_changed)
>>  {
>>       struct cfq_queue *queue;
>>       int i;
>> @@ -1972,7 +1972,7 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
>>       unsigned long lowest_key = 0;
>>       enum wl_type_t cur_best = SYNC_NOIDLE_WORKLOAD;
>>
>> -     if (prio_changed) {
>> +     if (cfqg_changed || prio_changed) {
>>               /*
>>                * When priorities switched, we prefer starting
>>                * from SYNC_NOIDLE (first choice), or just SYNC
>> @@ -2001,7 +2001,8 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
>>       return cur_best;
>>  }
>>
>> -static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
>> +static void choose_service_tree(struct cfq_data *cfqd,
>> +                             struct cfq_group *cfqg, bool cfqg_changed)
>>  {
>>       enum wl_prio_t previous_prio = cfqd->serving_prio;
>>       bool prio_changed;
>> @@ -2033,21 +2034,22 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
>>        * expiration time
>>        */
>>       prio_changed = (cfqd->serving_prio != previous_prio);
>> -     st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type,
>> -                             cfqd);
>> +     st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type,
>> +                           cfqd);
>>       count = st->count;
>>
>>       /*
>>        * If priority didn't change, check workload expiration,
>>        * and that we still have other queues ready
>>        */
>> -     if (!prio_changed && count &&
>> +     if (!cfqg_changed && !prio_changed && count &&
>>           !time_after(jiffies, cfqd->workload_expires))
>>               return;
>>
>>       /* otherwise select new workload type */
>>       cfqd->serving_type =
>> -             cfq_choose_wl(cfqd, cfqg, cfqd->serving_prio, prio_changed);
>> +             cfq_choose_wl(cfqd, cfqg, cfqd->serving_prio,
>> +                           cfqg_changed, prio_changed);
>>       st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type,
>>                               cfqd);
>>       count = st->count;
>> @@ -2104,9 +2106,16 @@ static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
>>
>>  static void cfq_choose_cfqg(struct cfq_data *cfqd)
>>  {
>> +     bool cfqg_changed = false;
>> +
>> +     struct cfq_group *orig_cfqg = cfqd->serving_group;
>> +
>>       struct cfq_group *cfqg = cfq_get_next_cfqg(cfqd);
>>
>> -     cfqd->serving_group = cfqg;
>> +     if (orig_cfqg != cfqg) {
>> +             cfqg_changed = 1;
>> +             cfqd->serving_group = cfqg;
>> +     }
>>
>>       /* Restore the workload type data */
>>       if (cfqg->saved_workload_slice) {
>> @@ -2114,7 +2123,7 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
>>               cfqd->serving_type = cfqg->saved_workload;
>>               cfqd->serving_prio = cfqg->saved_serving_prio;
>>       }
>> -     choose_service_tree(cfqd, cfqg);
>> +     choose_service_tree(cfqd, cfqg, cfqg_changed);
>>  }
>>
>>  /*
>> --
>> 1.5.4.rc3
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
