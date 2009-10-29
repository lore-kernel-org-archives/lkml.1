Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbZJ2RMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbZJ2RMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 13:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbZJ2RMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 13:12:31 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:46096 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbZJ2RMb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 13:12:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gmIDVFfrgngFQojRcJV1Xy5OZ1lVCioSPWxxmdoZlzdBPjwAC9ZX6gk4MwBr4/fjz2
         bXtJ2yl8n9KbpeO588tniqoaCOq9D869EKbyWVgVFRJipnLYPmSA1T5pPW53cJ/VqTS0
         RZ7VnConxEusDJ+duJpPOMrbWQ41GxY0k1g0c=
MIME-Version: 1.0
In-Reply-To: <20091029131944.GN10727@kernel.dk>
References: <200910262136.03233.czoccolo@gmail.com>
	 <20091029131944.GN10727@kernel.dk>
Date: Thu, 29 Oct 2009 18:12:35 +0100
Message-ID: <4e5e476b0910291012k39c3b69byc84ab0d0b41bd616@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: simplify prio-unboost code
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 2:19 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Mon, Oct 26 2009, Corrado Zoccolo wrote:
>> Eliminate redundant checks.
>>
>> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
>> ---
>>  block/cfq-iosched.c |    8 +++-----
>>  1 files changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 6e9b395..244bc8a 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -2611,12 +2611,10 @@ static void cfq_prio_boost(struct cfq_queue *cfqq)
>>                       cfqq->ioprio = IOPRIO_NORM;
>>       } else {
>>               /*
>> -              * check if we need to unboost the queue
>> +              * unboost the queue (if needed)
>>                */
>> -             if (cfqq->ioprio_class != cfqq->org_ioprio_class)
>> -                     cfqq->ioprio_class = cfqq->org_ioprio_class;
>> -             if (cfqq->ioprio != cfqq->org_ioprio)
>> -                     cfqq->ioprio = cfqq->org_ioprio;
>> +             cfqq->ioprio_class = cfqq->org_ioprio_class;
>> +             cfqq->ioprio = cfqq->org_ioprio;
>>       }
>
> Not sure I see much gain in that, the previous code makes it explicit
> that it may not be different and avoid dirtying cfqq if it isn't.

>From readability p.o.v., it is simpler to understand the direct assignment.
The comment says that they might already be equal, but the code states
clearly what is the final state, i.e. they will surely be equal at the
end-

Moreover, using two branches to avoid dirtying a cache line is not a
win performance-wise, given the penalty on mispredicted branches, and
the fact that the interval between two executions of this code is
large, so the branch predictor entries for those would be already
replaced by userspace ones.

If on some exotic MP hardware dirtying a cache line could be very
expensive, a similar check could be done in hardware, and it would be
more efficient, in fact it could distinguish the 2 cases:
* we already have the shared cache line locally -> we can compare the
value and absorb the write if it doesn't change
* we don't have the cache line locally -> we acquire the cache line in
exclusive mode, so we can do the write directly (on the contrary, the
previous code would first acquire the cache line as shared, and if
necessary, upgrade it to exclusive, possibly increasing the traffic).

Corrado

>
> --
> Jens Axboe
>
>
