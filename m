Return-Path: <linux-kernel-owner+w=401wt.eu-S932650AbZJGThF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650AbZJGThF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 15:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759919AbZJGThF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 15:37:05 -0400
Received: from mail-yw0-f196.google.com ([209.85.211.196]:56674 "EHLO
	mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759918AbZJGThD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 15:37:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JExrrw7LpsL5P4xd/sC5q4bw6RedQh79uxv5KOeS5g+2WJAE9B9HjeKbXYKqTGNn5H
         nuUDmcleLWTiJpxJSOlQ41G/339b+73A5Is1MzX0m4TXbOibzGUVC4JhiNvJ02c8CMb1
         8jXLhcMsyeRTdOP5oOULauMLub6PjYnWYr8fY=
MIME-Version: 1.0
In-Reply-To: <20091007175112.GI8703@kernel.dk>
References: <200910071059.01146.czoccolo@gmail.com>
	 <20091007175112.GI8703@kernel.dk>
Date: Wed, 7 Oct 2009 21:30:44 +0200
Message-ID: <4e5e476b0910071230x4adf48eava152bebb149d53e4@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: avoid slice overrun when idling
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 7, 2009 at 7:51 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Wed, Oct 07 2009, Corrado Zoccolo wrote:
>> Idle window for a queue is reduced when the queue is about to finish
>> its slice.
>>
>> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
>> ---
>>  block/cfq-iosched.c |    4 +++-
>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 4ab33d8..55bb8ca 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -1105,8 +1105,10 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
>>        * we don't want to idle for seeks, but we do want to allow
>>        * fair distribution of slice time for a process doing back-to-back
>>        * seeks. so allow a little bit of time for him to submit a new rq
>> +      * but avoid overrunning its timeslice
>>        */
>> -     sl = cfqd->cfq_slice_idle;
>> +     sl = min_t(unsigned long, cfqd->cfq_slice_idle,
>> +             cfqq->slice_end - jiffies);
>>       if (sample_valid(cic->seek_samples) && CIC_SEEKY(cic))
>>               sl = min(sl, msecs_to_jiffies(CFQ_MIN_TT));
>
> This was actually done this way on purpose, since shorter idling more
> often don't suceed. So the logic was rather overrun the slice slightly
> than wait shortly and just miss the incoming IO.
>
> Of course this will overrun the slice even more, which the above will
> also do since it wants to do IO within that time frame too.
>
> So I think we should either leave it as-is, OR simply not arm the idle
> timer when it has less than slice_idle time left and immediately select
> a new queue.

Maybe we can arm the timer only if the think time is less than the
remaining slice, otherwise skip it.

Corrado
>
> --
> Jens Axboe
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
