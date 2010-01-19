Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235Ab0ASV6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab0ASV6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120Ab0ASV6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:58:30 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55045 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab0ASV62 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:58:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LAmuA9HkBaTLQnU9F6FAkZVGWdwX3X5AuVEKIWWINiZG6eQk7GlsJ29sZ1r2cLm9HG
         Sfn9tD/WD92tbPC58BIwyHcQ8olp2SGkUltkDX4nIAz7ccBsTfMfaej+RbIXNa3/Gs5n
         nk/Fjj7iy0lwvkYM3tj9bjtM37nuq5dHdrfHw=
MIME-Version: 1.0
In-Reply-To: <20100119214046.GB4992@redhat.com>
References: <4e5e476b0912310234mf9ccaadm771c637a3d107d18@mail.gmail.com>
	 <4e5e476b1001010832o24f6a0efudbfc36598bfc7c5e@mail.gmail.com>
	 <1262435612.19773.80.camel@localhost>
	 <4e5e476b1001021052u51a90a91qb2fbb4089498a3ca@mail.gmail.com>
	 <1262593090.29897.14.camel@localhost>
	 <4e5e476b1001041028v1f204834r1fa97e732a094210@mail.gmail.com>
	 <4e5e476b1001160827n6dc73b35vee8b46e541134c2@mail.gmail.com>
	 <1263783999.12893.2.camel@localhost>
	 <4e5e476b1001191210s37423e4av6673225d5078a88e@mail.gmail.com>
	 <20100119214046.GB4992@redhat.com>
Date: Tue, 19 Jan 2010 22:58:26 +0100
Message-ID: <4e5e476b1001191358i52f45608m187f0314af50e5c5@mail.gmail.com>
Subject: Re: fio mmap randread 64k more than 40% regression with 2.6.33-rc1
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "jmoyer@redhat.com" <jmoyer@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, Shaohua Li <shaohua.li@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 10:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Jan 19, 2010 at 09:10:33PM +0100, Corrado Zoccolo wrote:
>> On Mon, Jan 18, 2010 at 4:06 AM, Zhang, Yanmin
>> <yanmin_zhang@linux.intel.com> wrote:
>> > On Sat, 2010-01-16 at 17:27 +0100, Corrado Zoccolo wrote:
>> >> Hi Yanmin
>> >> On Mon, Jan 4, 2010 at 7:28 PM, Corrado Zoccolo <czoccolo@gmail.com> wrote:
>> >> > Hi Yanmin,
>> >> >> When low_latency=1, we get the biggest number with kernel 2.6.32.
>> >> >> Comparing with low_latency=0's result, the prior one is about 4% better.
>> >> > Ok, so 2.6.33 + corrado (with low_latency =0) is comparable with
>> >> > fastest 2.6.32, so we can consider the first part of the problem
>> >> > solved.
>> >> >
>> >> I think we can return now to your full script with queue merging.
>> >> I'm wondering if (in arm_slice_timer):
>> >> -       if (cfqq->dispatched)
>> >> +      if (cfqq->dispatched || (cfqq->new_cfqq && rq_in_driver(cfqd)))
>> >>                return;
>> >> gives the same improvement you were experiencing just reverting to rq_in_driver.
>> > I did a quick testing against 2.6.33-rc1. With the new method, fio mmap randread 46k
>> > has about 20% improvement. With just checking rq_in_driver(cfqd), it has
>> > about 33% improvement.
>> >
>> Jeff, do you have an idea why in arm_slice_timer, checking
>> rq_in_driver instead of cfqq->dispatched gives so much improvement in
>> presence of queue merging, while it doesn't have noticeable effect
>> when there are no merges?
>
> Performance improvement because of replacing cfqq->dispatched with
> rq_in_driver() is really strange. This will mean we will do even lesser
> idling on the cfqq. That means faster cfqq switching and that should mean more
> seeks (for this test case) and reduce throughput. This is just opposite to your approach of treating a random read mmap queue as sync where we will idle on
> the queue.
The tests (previous mails in this thread) show that, if no queue
merging is happening, handling the queue as sync_idle, and setting
low_latency = 0 to have bigger slices completely recovers the
regression.
If, though, we have queue merges, current arm_slice_timer shows
regression w.r.t. the rq_in_driver version (2.6.32).
I think a possible explanation is that we are idling instead of
switching to an other queue that would be merged with this one. In
fact, my half-backed try to have the rq_in_driver check conditional on
queue merging fixed part of the regression (not all, because queue
merges are not symmetrical, and I could be seeing the queue that is
'new_cfqq' for an other).

Thanks,
Corrado
>
> Thanks
> Vivek
>
>>
>> Thanks,
>> Corrado
>>
>> >
>> >>
>> >> We saw that cfqq->dispatched worked fine when there was no queue
>> >> merging happening, so it must be something concerning merging,
>> >> probably dispatched is not accurate when we set up for a merging, but
>> >> the merging was not yet done.
>> >
>> >
>> >
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
