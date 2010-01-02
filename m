Return-Path: <linux-kernel-owner+w=401wt.eu-S1751651Ab0ABSwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab0ABSwp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 13:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311Ab0ABSwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 13:52:45 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:46099 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab0ABSwo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 13:52:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KTq/pkrNpm+AGWQpBs2Uga966brds57254KJRka+Gd3f+tcZnx5gtezzz5aFmOcCkz
         WtOsPgO66HSNtT6WVGp3wIfmelwxyH1kb4KWw4A68zGZXHPBqEFkwCJ0R2bmsyxk47Ch
         3cTNwfpAe3uTz1djMcuaR+8U4FKjUSNCKVmrM=
MIME-Version: 1.0
In-Reply-To: <1262435612.19773.80.camel@localhost>
References: <1262250960.1819.68.camel@localhost>
	 <4e5e476b0912310234mf9ccaadm771c637a3d107d18@mail.gmail.com>
	 <1262340730.19773.47.camel@localhost>
	 <4e5e476b1001010832o24f6a0efudbfc36598bfc7c5e@mail.gmail.com>
	 <1262435612.19773.80.camel@localhost>
Date: Sat, 2 Jan 2010 19:52:42 +0100
Message-ID: <4e5e476b1001021052u51a90a91qb2fbb4089498a3ca@mail.gmail.com>
Subject: Re: fio mmap randread 64k more than 40% regression with 2.6.33-rc1
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Shaohua Li <shaohua.li@intel.com>,
       "jmoyer@redhat.com" <jmoyer@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
On Sat, Jan 2, 2010 at 1:33 PM, Zhang, Yanmin
<yanmin_zhang@linux.intel.com> wrote:
> On Fri, 2010-01-01 at 17:32 +0100, Corrado Zoccolo wrote:
>> Hi Yanmin,
>> On Fri, Jan 1, 2010 at 11:12 AM, Zhang, Yanmin
>> <yanmin_zhang@linux.intel.com> wrote:
>> > On Thu, 2009-12-31 at 11:34 +0100, Corrado Zoccolo wrote:
>> >> Hi Yanmin,
>> >> On Thu, Dec 31, 2009 at 10:16 AM, Zhang, Yanmin
>> >> <yanmin_zhang@linux.intel.com> wrote:
>> >> > Comparing with kernel 2.6.32, fio mmap randread 64k has more than 40% regression with
>> >> > 2.6.33-rc1.
>> >>
>> > Thanks for your timely reply. Some comments inlined below.
>> >
>> >> Can you compare the performance also with 2.6.31?
>> > We did. We run Linux kernel Performance Tracking project and run many benchmarks when a RC kernel
>> > is released.
>> >
>> > The result of 2.6.31 is quite similar to the one of 2.6.32. But the one of 2.6.30 is about
>> > 8% better than the one of 2.6.31.
>> >
>> >> I think I understand what causes your problem.
>> >> 2.6.32, with default settings, handled even random readers as
>> >> sequential ones to provide fairness. This has benefits on single disks
>> >> and JBODs, but causes harm on raids.
>> > I didn't test RAID as that machine with hardware RAID HBA is crashed now. But if we turn on
>> > hardware RAID in HBA, mostly we use noop io scheduler.
>> I think you should start testing cfq with them, too. From 2.6.33, we
>> have some big improvements in this area.
> Great! I once compared cfq and noop against non-raid and raid0. One interesting finding
> about sequential read testing is when there are fewer processes to read files on the raid0
> JBOD, noop on raid0 is pretty good, but when there are lots of processes to do so on a non-raid
> JBOD, cfq is pretty better. I planed to investigate it, but too busy in other issues.
>
>> >
>> >> For 2.6.33, we changed the way in which this is handled, restoring the
>> >> enable_idle = 0 for seeky queues as it was in 2.6.31:
>> >> @@ -2218,13 +2352,10 @@ cfq_update_idle_window(struct cfq_data *cfqd,
>> >> struct cfq_queue *cfqq,
>> >>        enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
>> >>
>> >>        if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
>> >> -           (!cfqd->cfq_latency && cfqd->hw_tag && CFQQ_SEEKY(cfqq)))
>> >> +           (sample_valid(cfqq->seek_samples) && CFQQ_SEEKY(cfqq)))
>> >>                enable_idle = 0;
>> >> (compare with 2.6.31:
>> >>         if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
>> >>             (cfqd->hw_tag && CIC_SEEKY(cic)))
>> >>                 enable_idle = 0;
>> >> excluding the sample_valid check, it should be equivalent for you (I
>> >> assume you have NCQ disks))
>> >> and we provide fairness for them by servicing all seeky queues
>> >> together, and then idling before switching to other ones.
>> > As for function cfq_update_idle_window, you is right. But since
>> > 2.6.32, CFQ merges many patches and the patches have impact on each other.
>> >
>> >>
>> >> The mmap 64k randreader will have a large seek_mean, resulting in
>> >> being marked seeky, but will send 16 * 4k sequential requests one
>> >> after the other, so alternating between those seeky queues will cause
>> >> harm.
>> >>
>> >> I'm working on a new way to compute seekiness of queues, that should
>> >> fix your issue, correctly identifying those queues as non-seeky (for
>> >> me, a queue should be considered seeky only if it submits more than 1
>> >> seeky requests for 8 sequential ones).
>> >>
>> >> >
>> >> > The test scenario: 1 JBOD has 12 disks and every disk has 2 partitions. Create
>> >> > 8 1-GB files per partition and start 8 processes to do rand read on the 8 files
>> >> > per partitions. There are 8*24 processes totally. randread block size is 64K.
>> >> >
>> >> > We found the regression on 2 machines. One machine has 8GB memory and the other has
>> >> > 6GB.
>> >> >
>> >> > Bisect is very unstable. The related patches are many instead of just one.
>> >> >
>> >> >
>> >> > 1) commit 8e550632cccae34e265cb066691945515eaa7fb5
>> >> > Author: Corrado Zoccolo <czoccolo@gmail.com>
>> >> > Date:   Thu Nov 26 10:02:58 2009 +0100
>> >> >
>> >> >    cfq-iosched: fix corner cases in idling logic
>> >> >
>> >> >
>> >> > This patch introduces about less than 20% regression. I just reverted below section
>> >> > and this part regression disappear. It shows this regression is stable and not impacted
>> >> > by other patches.
>> >> >
>> >> > @@ -1253,9 +1254,9 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
>> >> >                return;
>> >> >
>> >> >        /*
>> >> > -        * still requests with the driver, don't idle
>> >> > +        * still active requests from this queue, don't idle
>> >> >         */
>> >> > -       if (rq_in_driver(cfqd))
>> >> > +       if (cfqq->dispatched)
>> >> >                return;
>> > Although 5 patches are related to the regression, above line is quite
>> > independent. Reverting above line could always improve the result for about
>> > 20%.
>> I've looked at your fio script, and it is quite complex,
> As we have about 40 fio sub cases, we have a script to create fio job file from
> a specific parameter list. So there are some superfluous parameters.
>
My point is that there are so many things going on, that is more
difficult to analyse the issues.
I prefer looking at one problem at a time, so (initially) removing the
possibility of queue merging, that Shaohua already investigated, can
help in spotting the still not-well-understood problem.
Could you generate the same script, but with each process accessing
only one of the files, instead of chosing it at random?

> Another point is we need stable result.
>
>> with lot of
>> things going on.
>> Let's keep this for last.
> Ok. But the change like what you do mostly reduces regresion.
>
>> I've created a smaller test, that already shows some regression:
>> [global]
>> direct=0
>> ioengine=mmap
>> size=8G
>> bs=64k
>> numjobs=1
>> loops=5
>> runtime=60
>> #group_reporting
>> invalidate=0
>> directory=/media/hd/cfq-tests
>>
>> [job0]
>> startdelay=0
>> rw=randread
>> filename=testfile1
>>
>> [job1]
>> startdelay=0
>> rw=randread
>> filename=testfile2
>>
>> [job2]
>> startdelay=0
>> rw=randread
>> filename=testfile3
>>
>> [job3]
>> startdelay=0
>> rw=randread
>> filename=testfile4
>>
>> The attached patches, in particular 0005 (that apply on top of
>> for-linus branch of Jen's tree
>> git://git.kernel.dk/linux-2.6-block.git) fix the regression on this
>> simplified workload.
> I didn't download the tree. I tested the 3 attached patches against 2.6.33-rc1. The
> result isn't resolved.
Can you quantify if there is an improvement, though?
Please, also include Shahoua's patches.
I'd like to see the comparison between (always with low_latency set to 0):
plain 2.6.33
plain 2.6.33 + shahoua's
plain 2.6.33 + shahoua's + my patch
plain 2.6.33 + shahoua's + my patch + rq_in_driver vs dispatched patch.

>>
>> >
>> >> >
>> >> This shouldn't affect you if all queues are marked as idle.
>> > Do you mean to use command ionice to mark it as idle class? I didn't try it.
>> No. I meant forcing enable_idle = 1, as you were almost doing with
>> your patch, when cfq_latency was set.
>> With my above patch, this should not be needed any more, since the
>> queues should be seen as sequential.
>>
>> >
>> >>  Does just
>> >> your patch:
>> >> > -           (!cfq_cfqq_deep(cfqq) && sample_valid(cfqq->seek_samples)
>> >> > -            && CFQQ_SEEKY(cfqq)))
>> >> > +           (!cfqd->cfq_latency && !cfq_cfqq_deep(cfqq) &&
>> >> > +               sample_valid(cfqq->seek_samples) && CFQQ_SEEKY(cfqq)))
>> >> fix most of the regression without touching arm_slice_timer?
>> > No. If to fix the regression completely, I need apply above patch plus
>> > a debug patch. The debug patch is to just work around the 3 patches report by
>> > Shaohua's tiobench regression report. Without the debug patch, the regression
>> > isn't resolved.
>>
>> Jens already merged one of Shaohua's patches, that may fix the problem
>> with queue combining.
> I did another testing. Apply my debug patch+ the low_latency patch, but use
> Shaohua's 2 patches (improve merge and split), the regression disappears.
>
>>
>> > Below is the debug patch.
>> > diff -Nraup linux-2.6.33_rc1/block/cfq-iosched.c linux-2.6.33_rc1_randread64k/block/cfq-iosched.c
>> > --- linux-2.6.33_rc1/block/cfq-iosched.c        2009-12-23 14:12:03.000000000 +0800
>> > +++ linux-2.6.33_rc1_randread64k/block/cfq-iosched.c    2009-12-30 17:12:28.000000000 +0800
>> > @@ -592,6 +592,9 @@ cfq_set_prio_slice(struct cfq_data *cfqd
>> >        cfqq->slice_start = jiffies;
>> >        cfqq->slice_end = jiffies + slice;
>> >        cfqq->allocated_slice = slice;
>> > +/*YMZHANG*/
>> > +       cfqq->slice_end = cfq_prio_to_slice(cfqd, cfqq) + jiffies;
>> > +
>> This is disabled, on a vanilla 2.6.33 kernel, by setting low_latency = 0
>> >        cfq_log_cfqq(cfqd, cfqq, "set_slice=%lu", cfqq->slice_end - jiffies);
>> >  }
>> >
>> > @@ -1836,7 +1839,8 @@ static void cfq_arm_slice_timer(struct c
>> >        /*
>> >         * still active requests from this queue, don't idle
>> >         */
>> > -       if (cfqq->dispatched)
>> > +       //if (cfqq->dispatched)
>> > +       if (rq_in_driver(cfqd))
>> >                return;
>> >
>> >        /*
>> > @@ -1941,6 +1945,9 @@ static void cfq_setup_merge(struct cfq_q
>> >                new_cfqq = __cfqq;
>> >        }
>> >
>> > +       /* YMZHANG debug */
>> > +       return;
>> > +
>> This should be partially addressed by Shaohua's patch merged in Jens' tree.
>> But note that your 8 processes, can randomly start doing I/O on the
>> same file, so merging those queues is sometimes reasonable.
> Another reason is I start 8 processes per partition and every disk has 2 partitions,
> so there are 16 processes per disk. With another JBOD, I use one partition per disk,
> and the regression is only 8%.
With half of the processes, time slices are higher, and the disk cache
can do a better job when servicing interleaved sequential requests.
>
> >From this point, can CFQ do not merge request queues which access different partitions?
(puzzled: I didn't write this, and can't find a message in the thread
with this question.)
> As you know, it's unusual that a process accesses files across partitions. io scheduler
> is at low layer which doesn't know partition.
CFQ bases decision on distance between requests, and requests going to
different partitions will have much higher distance. So the associated
queues will be more likely marked as seeky.
>
>
>> The patch to split them quickly was still not merged, though, so you
>> will still see some regression due to this. In my simplified job file,
>> I removed the randomness to make sure this cannot happen.
>>
>> >        process_refs = cfqq_process_refs(cfqq);
>> >        /*
>> >         * If the process for the cfqq has gone away, there is no
>> >
>> >
>> >>
>> >> I guess
>> >> > 5db5d64277bf390056b1a87d0bb288c8b8553f96.
>> >> will still introduce a 10% regression, but this is needed to improve
>> >> latency, and you can just disable low_latency to avoid it.
>> > You are right. I did a quick testing. If my patch + revert 2 patches and keep
>> > 5db5d64, the regression is about 20%.
>> >
>> > But low_latency=0 doesn't work like what we imagined. If patch + revert 2 patches
>> > and keep 5db5d64 while set low_latency=0, the regression is still there. One
>> > reason is my patch doesn't work when low_latency=0.
>> Right. You can try with my patch, instead, that doesn't depend on
>> low_latency, and set it to 0 to remove this performance degradation.
>> My results:
>> 2.6.32.2:
>>    READ: io=146688KB, aggrb=2442KB/s, minb=602KB/s, maxb=639KB/s,
>> mint=60019msec, maxt=60067msec
>>
>> 2.6.33 - jens:
>>    READ: io=128512KB, aggrb=2140KB/s, minb=526KB/s, maxb=569KB/s,
>> mint=60004msec, maxt=60032msec
>>
>> 2.6.33 - jens + my patches :
>>    READ: io=143232KB, aggrb=2384KB/s, minb=595KB/s, maxb=624KB/s,
>> mint=60003msec, maxt=60072msec
>>
>> 2.6.33 - jens + my patches + low_lat = 0:
>>    READ: io=145216KB, aggrb=2416KB/s, minb=596KB/s, maxb=632KB/s,
>> mint=60027msec, maxt=60087msec
>>
>>
>> >>
>> >> Thanks,
>> >> Corrado
>> > I attach the fio job file for your reference.
>> >
>> > I got a cold and will continue to work on it next week.
>> >
>> > Yanmin
>> >
>>
>> Thanks,
>> Corrado
>
>
>
