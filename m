Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbZDTGs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbZDTGs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 02:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbZDTGsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 02:48:16 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:59972 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZDTGsQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 02:48:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wprv8FZ8C5pw0BrB6oQLTX6BMmUnE679GeKFFI+RHCxgwiGJQd9KGNvROC3E9agnmy
         ax2naHsfs0aqmrjdKL8x3jQK2SOjjVFrFutbzoBCknb1vAKCi/j5yCSv4ZpBC6EF10BL
         wevWywcPidq7tIYweTYzy24D1b/+DXVUcXeps=
MIME-Version: 1.0
In-Reply-To: <20090420061602.GO4593@kernel.dk>
References: <ed038eb20904191756y5a5bcf8fn53473405b3929de6@mail.gmail.com>
	 <20090420061602.GO4593@kernel.dk>
Date: Mon, 20 Apr 2009 08:48:14 +0200
X-Google-Sender-Auth: 246e913c7459c5c4
Message-ID: <ed038eb20904192348m7f9f630q395baf123c3fd2ba@mail.gmail.com>
Subject: Re: CFQ: Preemption/timeout logic reversed?
From: Carl Henrik Lunde <chlunde@ping.uio.no>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 08:16, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Mon, Apr 20 2009, Carl Henrik Lunde wrote:
>> Hi!
>>
>> It seems the preemption "bonus" logic in CFQ is reversed, a preempted
>> process is given an additional delay in start time instead of a bonus.
>>  This seems unfair.  I'm not sure if it's a good idea to let
>
> Hmm? ->slice_resid is a long, so if we preempt the process 10 jiffies
> before it was supposed to end, the resid will be -10. So it'll not
> increase the rb_key, it'll decrease it.

OK, so maybe I'm tired (I am!), but I don't get it. :)

{
        if (... busy_rt_queues)
               cfq_slice_expire(timed_out=1)
}

cfq_slice_expire() {
{
        if (timed_out)
                slice_resid = slice_end - jiffies;
}

if preempted it would be 100 - 90 = +10?

>
>> slice_resid grow without limit as shown below, but isn't this more
>> like the way it was intended to work?  Or did I misunderstand
>> something?
>
> ->slice_resid is reset when it gets repositioned in the rb tree. The
> intent was not to increase the slice length, but instead allow it sooner
> service again.

Fair enough

>> PS! The comment above cfq_preempt_queue seems outdated too.
>
> Yep, the slice length comment is out dated indeed.
>
>> Code not tested, just showing what I mean:
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 664ebfd..ea18d45 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -292,7 +292,8 @@ cfq_prio_to_slice(struct cfq_data *cfqd, struct
>> cfq_queue *cfqq)
>>  static inline void
>>  cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>>  {
>> -       cfqq->slice_end = cfq_prio_to_slice(cfqd, cfqq) + jiffies;
>> +       cfqq->slice_end = cfq_prio_to_slice(cfqd, cfqq) +
>> cfqq->slice_resid + jiffies;
>
> So if ->slice_resid is negative because we preempted this queue, it'll
> now get a shorter slice. That's not very nice :-)
>
> --
> Jens Axboe
>
>



-- 
mvh
Carl Henrik
