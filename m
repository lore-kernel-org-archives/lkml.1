Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbZK0Bqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbZK0Bqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 20:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbZK0Bqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 20:46:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52506 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbZK0Bql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 20:46:41 -0500
Message-ID: <4B0F2E8F.9090105@cn.fujitsu.com>
Date: Fri, 27 Nov 2009 09:42:39 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Corrado Zoccolo <czoccolo@gmail.com>
CC: Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq: Make use of service count to estimate the rb_key
 	offset
References: <4B0E1E2F.9080604@cn.fujitsu.com> <4e5e476b0911260108s2fe4cd86lcb32c7be76b4f75c@mail.gmail.com>
In-Reply-To: <4e5e476b0911260108s2fe4cd86lcb32c7be76b4f75c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo wrote:
> Hi Gui, Jens
> On Thu, Nov 26, 2009 at 7:20 AM, Gui Jianfeng
> <guijianfeng@cn.fujitsu.com> wrote:
>> Hi Jens, Czoccolo
>>
>> For the moment, different workload cfq queues are put into different
>> service trees. But CFQ still uses "busy_queues" to estimate rb_key
>> offset when inserting a cfq queue into a service tree. I think this
>> isn't appropriate, and it should make use of service tree count to do
>> this estimation. This patch is for for-2.6.33 branch.
> 
> In cfq_choose_wl, we rely on consistency of rb_keys across service
> trees to compute the next workload to be serviced.
>         for (i = 0; i < 3; ++i) {
>                 /* otherwise, select the one with lowest rb_key */
>                 queue = cfq_rb_first(service_tree_for(prio, i, cfqd));
>                 if (queue &&
>                     (!key_valid || time_before(queue->rb_key, lowest_key))) {
>                         lowest_key = queue->rb_key;
> 			cur_best = i;
> 			key_valid = true;
> 		}
>         }
> 
> If you change how the rb_key is computed (so it is no longer
> consistent across service trees) without changing how it is used can
> introduce problems.

  Ok, I think I was missing this part. This part still behaves like old CFQ regardless
  of workload type. I'm wondering why you prefer starting from sync no-idle only when 
  priorities switched, after that, you do it like old CFQ behavior? In order to improve
  latency for sync no-idle workload, is it possible to take workload type into account,
  not only rely on rb_keys across service trees?

  Thanks,
  Gui
> 
> Thanks,
> Corrado
> 
>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
>> ---
>>  block/cfq-iosched.c |    8 ++++++--
>>  1 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 1bcbd8c..467981e 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -600,11 +600,15 @@ cfq_find_next_rq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>>  static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
>>                                      struct cfq_queue *cfqq)
>>  {
>> +       struct cfq_rb_root *service_tree;
>> +
>> +       service_tree = service_tree_for(cfqq_prio(cfqq), cfqq_type(cfqq), cfqd);
>> +
>>        /*
>>         * just an approximation, should be ok.
>>         */
>> -       return (cfqd->busy_queues - 1) * (cfq_prio_slice(cfqd, 1, 0) -
>> -                      cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
>> +       return  service_tree->count * (cfq_prio_slice(cfqd, 1, 0) -
>> +                  cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
>>  }
>>
>>  /*
>> --
>> 1.5.4.rc3
>>
>> --
>> Regards
>> Gui Jianfeng
>>
>>
> 
> 
> 



