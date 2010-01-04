Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738Ab0ADS2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab0ADS2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 13:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528Ab0ADS23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 13:28:29 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:37870 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab0ADS22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 13:28:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JT76f2zmXJi8RoPStsh/2FbquJRAVy8z4tyjqJ/0s/PpCcOYgstO6VZId2pSdO4KBf
         Q40+frLCJchZn6exxeudjdexfhR2g6w99C/irtvzeP0HnCRJCK/7gFx2mgkgeo4hS0Cn
         TIzVoyKVbUyV7uKGbOT4Fu2q9CobtADxEXUCw=
MIME-Version: 1.0
In-Reply-To: <1262593090.29897.14.camel@localhost>
References: <1262250960.1819.68.camel@localhost>
	 <4e5e476b0912310234mf9ccaadm771c637a3d107d18@mail.gmail.com>
	 <1262340730.19773.47.camel@localhost>
	 <4e5e476b1001010832o24f6a0efudbfc36598bfc7c5e@mail.gmail.com>
	 <1262435612.19773.80.camel@localhost>
	 <4e5e476b1001021052u51a90a91qb2fbb4089498a3ca@mail.gmail.com>
	 <1262593090.29897.14.camel@localhost>
Date: Mon, 4 Jan 2010 19:28:26 +0100
Message-ID: <4e5e476b1001041028v1f204834r1fa97e732a094210@mail.gmail.com>
Subject: Re: fio mmap randread 64k more than 40% regression with 2.6.33-rc1
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "jmoyer@redhat.com" <jmoyer@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Shaohua Li <shaohua.li@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yanmin,
On Mon, Jan 4, 2010 at 9:18 AM, Zhang, Yanmin
<yanmin_zhang@linux.intel.com> wrote:
> On Sat, 2010-01-02 at 19:52 +0100, Corrado Zoccolo wrote:
>> Hi
>> On Sat, Jan 2, 2010 at 1:33 PM, Zhang, Yanmin
>> <yanmin_zhang@linux.intel.com> wrote:
>> > On Fri, 2010-01-01 at 17:32 +0100, Corrado Zoccolo wrote:
>> >> Hi Yanmin,
>> >> On Fri, Jan 1, 2010 at 11:12 AM, Zhang, Yanmin
>> >> <yanmin_zhang@linux.intel.com> wrote:
>> >> > On Thu, 2009-12-31 at 11:34 +0100, Corrado Zoccolo wrote:
>> >> >> Hi Yanmin,
>> >> >> On Thu, Dec 31, 2009 at 10:16 AM, Zhang, Yanmin
>> >> >> <yanmin_zhang@linux.intel.com> wrote:
>> >> >> > Comparing with kernel 2.6.32, fio mmap randread 64k has more than 40% regression with
>> >> >> > 2.6.33-rc1.
>> >> >>
>> >> > Thanks for your timely reply. Some comments inlined below.
>> >> >
>> >> >> Can you compare the performance also with 2.6.31?
>> >> > We did. We run Linux kernel Performance Tracking project and run many benchmarks when a RC kernel
>> >> > is released.
>> >> >
>> >> > The result of 2.6.31 is quite similar to the one of 2.6.32. But the one of 2.6.30 is about
>> >> > 8% better than the one of 2.6.31.
>> >> >
>> >> >> I think I understand what causes your problem.
>> >> >> 2.6.32, with default settings, handled even random readers as
>> >> >> sequential ones to provide fairness. This has benefits on single disks
>> >> >> and JBODs, but causes harm on raids.
>> >> > I didn't test RAID as that machine with hardware RAID HBA is crashed now. But if we turn on
>> >> > hardware RAID in HBA, mostly we use noop io scheduler.
>> >> I think you should start testing cfq with them, too. From 2.6.33, we
>> >> have some big improvements in this area.
>> > Great! I once compared cfq and noop against non-raid and raid0. One interesting finding
>> > about sequential read testing is when there are fewer processes to read files on the raid0
>> > JBOD, noop on raid0 is pretty good, but when there are lots of processes to do so on a non-raid
>> > JBOD, cfq is pretty better. I planed to investigate it, but too busy in other issues.
>> >
>> >> >
>> >> >> For 2.6.33, we changed the way in which this is handled, restoring the
>> >> >> enable_idle = 0 for seeky queues as it was in 2.6.31:
>> >> >> @@ -2218,13 +2352,10 @@ cfq_update_idle_window(struct cfq_data *cfqd,
>> >> >> struct cfq_queue *cfqq,
>> >> >>        enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
>> >> >>
>> >> >>        if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
>> >> >> -           (!cfqd->cfq_latency && cfqd->hw_tag && CFQQ_SEEKY(cfqq)))
>> >> >> +           (sample_valid(cfqq->seek_samples) && CFQQ_SEEKY(cfqq)))
>> >> >>                enable_idle = 0;
>> >> >> (compare with 2.6.31:
>> >> >>         if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
>> >> >>             (cfqd->hw_tag && CIC_SEEKY(cic)))
>> >> >>                 enable_idle = 0;
>> >> >> excluding the sample_valid check, it should be equivalent for you (I
>> >> >> assume you have NCQ disks))
>> >> >> and we provide fairness for them by servicing all seeky queues
>> >> >> together, and then idling before switching to other ones.
>> >> > As for function cfq_update_idle_window, you is right. But since
>> >> > 2.6.32, CFQ merges many patches and the patches have impact on each other.
>> >> >
>> >> >>
>> >> >> The mmap 64k randreader will have a large seek_mean, resulting in
>> >> >> being marked seeky, but will send 16 * 4k sequential requests one
>> >> >> after the other, so alternating between those seeky queues will cause
>> >> >> harm.
>> >> >>
>> >> >> I'm working on a new way to compute seekiness of queues, that should
>> >> >> fix your issue, correctly identifying those queues as non-seeky (for
>> >> >> me, a queue should be considered seeky only if it submits more than 1
>> >> >> seeky requests for 8 sequential ones).
>> >> >>
>> >> >> >
>> >> >> > The test scenario: 1 JBOD has 12 disks and every disk has 2 partitions. Create
>> >> >> > 8 1-GB files per partition and start 8 processes to do rand read on the 8 files
>> >> >> > per partitions. There are 8*24 processes totally. randread block size is 64K.
>> >> >> >
>> >> >> > We found the regression on 2 machines. One machine has 8GB memory and the other has
>> >> >> > 6GB.
>> >> >> >
>> >> >> > Bisect is very unstable. The related patches are many instead of just one.
>> >> >> >
>> >> >> >
>> >> >> > 1) commit 8e550632cccae34e265cb066691945515eaa7fb5
>> >> >> > Author: Corrado Zoccolo <czoccolo@gmail.com>
>> >> >> > Date:   Thu Nov 26 10:02:58 2009 +0100
>> >> >> >
>> >> >> >    cfq-iosched: fix corner cases in idling logic
>> >> >> >
>> >> >> >
>> >> >> > This patch introduces about less than 20% regression. I just reverted below section
>> >> >> > and this part regression disappear. It shows this regression is stable and not impacted
>> >> >> > by other patches.
>> >> >> >
>> >> >> > @@ -1253,9 +1254,9 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
>> >> >> >                return;
>> >> >> >
>> >> >> >        /*
>> >> >> > -        * still requests with the driver, don't idle
>> >> >> > +        * still active requests from this queue, don't idle
>> >> >> >         */
>> >> >> > -       if (rq_in_driver(cfqd))
>> >> >> > +       if (cfqq->dispatched)
>> >> >> >                return;
>> >> > Although 5 patches are related to the regression, above line is quite
>> >> > independent. Reverting above line could always improve the result for about
>> >> > 20%.
>> >> I've looked at your fio script, and it is quite complex,
>> > As we have about 40 fio sub cases, we have a script to create fio job file from
>> > a specific parameter list. So there are some superfluous parameters.
>> >
>> My point is that there are so many things going on, that is more
>> difficult to analyse the issues.
>> I prefer looking at one problem at a time, so (initially) removing the
>> possibility of queue merging, that Shaohua already investigated, can
>> help in spotting the still not-well-understood problem.
> Sounds reasonable.
>
>> Could you generate the same script, but with each process accessing
>> only one of the files, instead of chosing it at random?
> Ok. New testing starts 8 processes per partition and every process just works
> on one file.
Great, thanks.
>
>>
>> > Another point is we need stable result.
>> >
>> >> with lot of
>> >> things going on.
>> >> Let's keep this for last.
>> > Ok. But the change like what you do mostly reduces regresion.
>> >
>> >> I've created a smaller test, that already shows some regression:
>> >> [global]
>> >> direct=0
>> >> ioengine=mmap
>> >> size=8G
>> >> bs=64k
>> >> numjobs=1
>> >> loops=5
>> >> runtime=60
>> >> #group_reporting
>> >> invalidate=0
>> >> directory=/media/hd/cfq-tests
>> >>
>> >> [job0]
>> >> startdelay=0
>> >> rw=randread
>> >> filename=testfile1
>> >>
>> >> [job1]
>> >> startdelay=0
>> >> rw=randread
>> >> filename=testfile2
>> >>
>> >> [job2]
>> >> startdelay=0
>> >> rw=randread
>> >> filename=testfile3
>> >>
>> >> [job3]
>> >> startdelay=0
>> >> rw=randread
>> >> filename=testfile4
>> >>
>> >> The attached patches, in particular 0005 (that apply on top of
>> >> for-linus branch of Jen's tree
>> >> git://git.kernel.dk/linux-2.6-block.git) fix the regression on this
>> >> simplified workload.
>> > I didn't download the tree. I tested the 3 attached patches against 2.6.33-rc1. The
>> > result isn't resolved.
>> Can you quantify if there is an improvement, though?
>
> Ok. Because of company policy, I could only post percent instead of real number
Sure, it is fine.
>
>> Please, also include Shahoua's patches.
>> I'd like to see the comparison between (always with low_latency set to 0):
>> plain 2.6.33
>> plain 2.6.33 + shahoua's
>> plain 2.6.33 + shahoua's + my patch
>> plain 2.6.33 + shahoua's + my patch + rq_in_driver vs dispatched patch.
>
> 1) low_latency=0
> 2.6.32 kernel                                   0
> 2.6.33-rc1                                      -0.33
> 2.6.33-rc1_shaohua                              -0.33
> 2.6.33-rc1+corrado                              0.03
> 2.6.33-rc1_corrado+shaohua                      0.02
> 2.6.33-rc1_corrado+shaohua+rq_in_driver         0.01
>
So my patch fixes the situation for low_latency = 0, as I expected.
I'll send it to Jens with a proper changelog.

> 2) low_latency=1
> 2.6.32 kernel                                   0
> 2.6.33-rc1                                      -0.45
> 2.6.33-rc1+corrado                              -0.24
> 2.6.33-rc1_corrado+shaohua                      -0.23
> 2.6.33-rc1_corrado+shaohua+rq_in_driver         -0.23
The results are as expected. With each process working on a separate
file, Shahoua's patches do not influence the result sensibly.
Interestingly, even rq_in_driver doesn't improve in this case, so
maybe its effect is somewhat connected to queue merging.
The remaining -23% is due to timeslice shrinking, that is done to
reduce max latency when there are too many processes doing I/O, at the
expense of throughput. It is a documented change, and the suggested
way if you favor throughput over latency is to set low_latency = 0.

>
>
> When low_latency=1, we get the biggest number with kernel 2.6.32.
> Comparing with low_latency=0's result, the prior one is about 4% better.
Ok, so 2.6.33 + corrado (with low_latency =0) is comparable with
fastest 2.6.32, so we can consider the first part of the problem
solved.

For the queue merging issue, maybe Jeff has some improvements w.r.t
shaohua's approach.

Thanks,
Corrado
