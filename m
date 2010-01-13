Return-Path: <linux-kernel-owner+w=401wt.eu-S1756377Ab0AMVa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab0AMVa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755787Ab0AMVa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:30:56 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:43198 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab0AMVaz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:30:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dJdNSCEahrhI+ymKF7CleWVRD1UlzKTjvBPc/AqH/tOh+7R+r+7zg0rznPtMwh3i66
         YF3CZ2v7dHnByAt/05gXoyASV76wSdoiGhG4kO3q3ba6ZDpaDVBi0g/Wv8Hzi0LhOxPV
         SspYTWENNMkthIaTWSkM/3y08aO0cw0FnMcrU=
MIME-Version: 1.0
In-Reply-To: <20100113111005.GA3087@redhat.com>
References: <20100113074442.GA10492@sli10-desk.sh.intel.com>
	 <20100113111005.GA3087@redhat.com>
Date: Wed, 13 Jan 2010 22:30:52 +0100
Message-ID: <4e5e476b1001131330l75f5d949u13b615d408206c92@mail.gmail.com>
Subject: Re: [PATCH]cfq-iosched: don't stop async queue with async requests 
	pending
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Shaohua Li <shaohua.li@intel.com>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, jmoyer@redhat.com,
       guijianfeng@cn.fujitsu.com, yanmin_zhang@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 12:10 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Jan 13, 2010 at 03:44:42PM +0800, Shaohua Li wrote:
>> My SSD speed of direct write is about 80m/s, while I test page writeback,
>> the speed can only go to 68m/s. Below patch fixes this.
>> It appears we missused cfq_should_idle in cfq_may_dispatch. cfq_should_idle
>> means a queue should idle because it's seekless sync queue or it's the last queue,
>> which is to maintain service tree time slice. So it doesn't mean the
>> last queue is always a sync queue. If the last queue is asyn queue,
>> we definitely shouldn't stop dispatch requests because of pending async
>> requests.
>>
>> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 918c7fd..8198079 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -2222,7 +2222,8 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>>       /*
>>        * Drain async requests before we start sync IO
>>        */
>> -     if (cfq_should_idle(cfqd, cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])
>> +     if (cfq_cfqq_sync(cfqq) && cfq_should_idle(cfqd, cfqq)
>> +             && cfqd->rq_in_driver[BLK_RW_ASYNC])
>>               return false;
>
> So are we driving queue depth as 1 when pure buffered writes are going on?
> Because in that case service_tree->count=1 and cfq_should_idle() will
> return 1 and looks like we will not dispatch next write till previous
> write is over?

Yes, it seems so. It has to be fixed.

>
> A general question. Why do we need to drain async requests before we start
> sync IO? How does that help?
>
> A related question, even if we have to do that, why do we check for
> cfq_should_idle()? Why can't we just do following.
>
>        if (cfq_cfqq_sync(cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])
>
This would wait also for seeky queues. I think we drain to avoid
disrupting a sync
stream with far writes, but it is not needed when the queues are already seeky.

Thanks,
Corrado
> Thanks
> Vivek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
