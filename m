Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbZLDSjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbZLDSjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 13:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbZLDSje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 13:39:34 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:60741 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbZLDSjd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 13:39:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dd1202Jm/ouVQer4L6Qm7Retpd1bghbe/MMbnuhIdxiCYKv/peOTjIb+dnK2izXCNj
         /m4aaEe/ClG3b9vzF2uo0PUwqn0cJRGTADoGyKANG6utr7d3R706arUNzT6oYLiXCtAv
         K52yaH+60wZO12Ef7tOtH4EgmJ5M2Vk/XePCQ=
MIME-Version: 1.0
In-Reply-To: <20091203115740.GM8742@kernel.dk>
References: <20091203035330.GB13165@sli10-desk.sh.intel.com>
	 <20091203115740.GM8742@kernel.dk>
Date: Fri, 4 Dec 2009 19:34:31 +0100
Message-ID: <4e5e476b0912041034h2a2c53fdh16ddb6523c4917cd@mail.gmail.com>
Subject: Re: [RFC]cfq-iosched: no dispatch limit for single queue
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Shaohua Li <shaohua.li@intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shaohua, Jens,
On Thu, Dec 3, 2009 at 12:57 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Thu, Dec 03 2009, Shaohua Li wrote:
>> Since commit 2f5cb7381b737e24c8046fd4aeab571fb71315f5, each queue can send
>> up to 4 * 4 requests if only one queue exists. I wonder why we have such limit.
>> Device supports tag can send more requests. For example, AHCI can send 31
>> requests. Test (direct aio randread) shows the limits reduce about 4% disk
>> thoughput.
>> On the other hand, since we send one request one time, if other queue
>> pop when current is sending more than cfq_quantum requests, current queue will
>> stop send requests soon after one request, so sounds there is no big latency.
>>
>> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index aa1e953..e05650f 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -1298,9 +1298,9 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>>                       return false;
>>
>>               /*
>> -              * Sole queue user, allow bigger slice
>> +              * Sole queue user, no limit
>>                */
>> -             max_dispatch *= 4;
>> +             max_dispatch = -1;
>>       }
>>
>>       /*
>
> As you mention, we do dispatches in bites of 1. In reality, there's
> going to be little difference when we get this far in the depth process,
> so I think the patch looks good. I have applied it, thanks.

I think the limit should be removed only for sync queues.
For async queues, if cfq_latency is not set, removing the limit here can
cause very high latencies to sync queues (almost 100% increase),
without a noticeable throughput gain.

Thanks,
Corrado
