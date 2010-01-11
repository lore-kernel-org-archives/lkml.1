Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418Ab0AKPF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab0AKPF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 10:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387Ab0AKPF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 10:05:26 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:56985 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab0AKPFY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 10:05:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vC3vsyXJontjAQ4Z0wEiuC//K1xqAIfMfumBwFu2pnW8WYHxQ5L6nIvUbO/2DKMx5Q
         IzsPiOfUDRu2CHEslXttT6bhl+ouZrH8c66KH6pPwYQJ4BAcMYc7c+Eo3fvhpCzoSZC7
         EguFo2TwgMhdKWs6mFkTn5+xSNCl61V6t/amo=
MIME-Version: 1.0
In-Reply-To: <1263187209.29897.33.camel@localhost>
References: <20091224005506.GA7879@sli10-desk.sh.intel.com>
	 <20091228020348.GB28115@sli10-desk.sh.intel.com>
	 <4e5e476b0912280036r6e55587dj66952fcd6ff4d08b@mail.gmail.com>
	 <20091228084659.GA31389@sli10-desk.sh.intel.com>
	 <4e5e476b0912280111s6a977251m3416341b4bd2c272@mail.gmail.com>
	 <20091228092844.GA9710@sli10-desk.sh.intel.com>
	 <x493a2k8d7x.fsf@segfault.boston.devel.redhat.com>
	 <4e5e476b1001070544w88a387dkfb48847f4f95a9b1@mail.gmail.com>
	 <x49hbqy3s3m.fsf@segfault.boston.devel.redhat.com>
	 <1263187209.29897.33.camel@localhost>
Date: Mon, 11 Jan 2010 16:05:21 +0100
Message-ID: <4e5e476b1001110705y6c3319ducf6a15c2a2be5670@mail.gmail.com>
Subject: Re: [PATCH]cfq-iosched: don't take requests with long distence as 
	close
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 6:20 AM, Zhang, Yanmin
<yanmin_zhang@linux.intel.com> wrote:
> On Thu, 2010-01-07 at 09:30 -0500, Jeff Moyer wrote:
>> Corrado Zoccolo <czoccolo@gmail.com> writes:
>>
>> > On Tue, Jan 5, 2010 at 10:16 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> >>
>> >> For now, I'm leaning towards asking Jens to revert this.  It may still
>> >> be worth making sure that we don't merge a seeky queue with a non-seeky
>> >> queue.  I have a patch for that if folks are interested.
>> > Jeff, can you send this patch to Yanmin, that is investigating a
>> > regression apparently caused by excessive queue merge?
>> >
>> > http://lkml.org/lkml/2010/1/4/194
>>
>>
>> You first have to back out Shaohua's patch, then apply this one.
> Thanks for forwarding me the patches.
> Actually, we found tiobench randread has about 20% regression since kernel
> 2.6.33-rc1, and fio randread has more than 40% regression.
>
>>
>> Cheers,
>> Jeff
>>
>> cfq-iosched: don't allow merging with seeky queues
> With your new patch applied on 2.6.33-rc1, I don't see improvement on
> both tiobench and fio randread regression. I know unexpected merge/unmerge
> is just one root cause of the regressions. A couple of other patches
> are also related to them.

Hi Yanmin,
are you testing Jeff's patch with your full fio script, instead of the
simplified one?
Since they are fixing the merging part, that happens only with the
full fio script.

>
> I also tried to apply both your patch and Corrado's patch at
> http://lkml.org/lkml/2010/1/9/57. The result seems like the one when I just apply
> Corrado's patch, with which regression almost disappears when low_latency=0. But
> when low_latency=1, there is still about 25% regression.
>
Yes, low_latency is supposed to bring some regression.
http://lkml.org/lkml/2009/12/30/47

Thanks,
Corrado
>
>>
>> Shaohua Li noticed that cfq currently can merge with seeky queues, which
>> causes unwanted merge/unmerge activity.  We already know that the
>> cur_cfqq is not seeky, so this patch just makes sure that the non-seeky
>> queue is not merged with a seeky one.
>>
>> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 8df4fe5..3db9050 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -1677,6 +1677,10 @@ static inline int cfq_rq_close(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>>       return cfq_dist_from_last(cfqd, rq) <= sdist;
>>  }
>>
>> +/*
>> + * Search for a cfqq that is issuing non-seeky I/Os within the seek
>> + * mean of the current cfqq.
>> + */
>>  static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
>>                                   struct cfq_queue *cur_cfqq)
>>  {
>> @@ -1701,7 +1705,14 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
>>        * will contain the closest sector.
>>        */
>>       __cfqq = rb_entry(parent, struct cfq_queue, p_node);
>> -     if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq))
>> +     /*
>> +      * If the cfqq does not have enough seek samples, assume it is
>> +      * sequential until proven otherwise.  If it is assumed that the
>> +      * queue is seeky first, then the close cooperator detection logic
>> +      * may never trigger as one queue strays further from the other(s).
>> +      */
>> +     if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq) &&
>> +         (!sample_valid(__cfqq->seek_samples) || !CFQQ_SEEKY(__cfqq)))
>>               return __cfqq;
>>
>>       if (blk_rq_pos(__cfqq->next_rq) < sector)
>> @@ -1712,7 +1723,8 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
>>               return NULL;
>>
>>       __cfqq = rb_entry(node, struct cfq_queue, p_node);
>> -     if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq))
>> +     if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq) &&
>> +         (!sample_valid(__cfqq->seek_samples) || !CFQQ_SEEKY(__cfqq)))
>>               return __cfqq;
>>
>>       return NULL;
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
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
