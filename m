Return-Path: <linux-kernel-owner+w=401wt.eu-S1751475Ab0AAKMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab0AAKMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 05:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220Ab0AAKMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 05:12:45 -0500
Received: from mga05.intel.com ([192.55.52.89]:63886 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751206Ab0AAKMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 05:12:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,484,1257148800"; 
   d="scan'208";a="527707656"
Subject: Re: fio mmap randread 64k more than 40% regression with 2.6.33-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Shaohua Li <shaohua.li@intel.com>,
       "jmoyer@redhat.com" <jmoyer@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4e5e476b0912310234mf9ccaadm771c637a3d107d18@mail.gmail.com>
References: <1262250960.1819.68.camel@localhost>
	 <4e5e476b0912310234mf9ccaadm771c637a3d107d18@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-rgEi9kepDfzaggF32Mki"
Date: Fri, 01 Jan 2010 18:12:10 +0800
Message-Id: <1262340730.19773.47.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rgEi9kepDfzaggF32Mki
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On Thu, 2009-12-31 at 11:34 +0100, Corrado Zoccolo wrote:
> Hi Yanmin,
> On Thu, Dec 31, 2009 at 10:16 AM, Zhang, Yanmin
> <yanmin_zhang@linux.intel.com> wrote:
> > Comparing with kernel 2.6.32, fio mmap randread 64k has more than 40% regression with
> > 2.6.33-rc1.
> 
Thanks for your timely reply. Some comments inlined below.

> Can you compare the performance also with 2.6.31?
We did. We run Linux kernel Performance Tracking project and run many benchmarks when a RC kernel
is released.

The result of 2.6.31 is quite similar to the one of 2.6.32. But the one of 2.6.30 is about
8% better than the one of 2.6.31.

> I think I understand what causes your problem.
> 2.6.32, with default settings, handled even random readers as
> sequential ones to provide fairness. This has benefits on single disks
> and JBODs, but causes harm on raids.
I didn't test RAID as that machine with hardware RAID HBA is crashed now. But if we turn on
hardware RAID in HBA, mostly we use noop io scheduler.

> For 2.6.33, we changed the way in which this is handled, restoring the
> enable_idle = 0 for seeky queues as it was in 2.6.31:
> @@ -2218,13 +2352,10 @@ cfq_update_idle_window(struct cfq_data *cfqd,
> struct cfq_queue *cfqq,
>        enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
> 
>        if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
> -           (!cfqd->cfq_latency && cfqd->hw_tag && CFQQ_SEEKY(cfqq)))
> +           (sample_valid(cfqq->seek_samples) && CFQQ_SEEKY(cfqq)))
>                enable_idle = 0;
> (compare with 2.6.31:
>         if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
>             (cfqd->hw_tag && CIC_SEEKY(cic)))
>                 enable_idle = 0;
> excluding the sample_valid check, it should be equivalent for you (I
> assume you have NCQ disks))
> and we provide fairness for them by servicing all seeky queues
> together, and then idling before switching to other ones.
As for function cfq_update_idle_window, you is right. But since
2.6.32, CFQ merges many patches and the patches have impact on each other.

> 
> The mmap 64k randreader will have a large seek_mean, resulting in
> being marked seeky, but will send 16 * 4k sequential requests one
> after the other, so alternating between those seeky queues will cause
> harm.
> 
> I'm working on a new way to compute seekiness of queues, that should
> fix your issue, correctly identifying those queues as non-seeky (for
> me, a queue should be considered seeky only if it submits more than 1
> seeky requests for 8 sequential ones).
> 
> >
> > The test scenario: 1 JBOD has 12 disks and every disk has 2 partitions. Create
> > 8 1-GB files per partition and start 8 processes to do rand read on the 8 files
> > per partitions. There are 8*24 processes totally. randread block size is 64K.
> >
> > We found the regression on 2 machines. One machine has 8GB memory and the other has
> > 6GB.
> >
> > Bisect is very unstable. The related patches are many instead of just one.
> >
> >
> > 1) commit 8e550632cccae34e265cb066691945515eaa7fb5
> > Author: Corrado Zoccolo <czoccolo@gmail.com>
> > Date:   Thu Nov 26 10:02:58 2009 +0100
> >
> >    cfq-iosched: fix corner cases in idling logic
> >
> >
> > This patch introduces about less than 20% regression. I just reverted below section
> > and this part regression disappear. It shows this regression is stable and not impacted
> > by other patches.
> >
> > @@ -1253,9 +1254,9 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
> >                return;
> >
> >        /*
> > -        * still requests with the driver, don't idle
> > +        * still active requests from this queue, don't idle
> >         */
> > -       if (rq_in_driver(cfqd))
> > +       if (cfqq->dispatched)
> >                return;
Although 5 patches are related to the regression, above line is quite
independent. Reverting above line could always improve the result for about
20%.

> >
> This shouldn't affect you if all queues are marked as idle.
Do you mean to use command ionice to mark it as idle class? I didn't try it.

>  Does just
> your patch:
> > -           (!cfq_cfqq_deep(cfqq) && sample_valid(cfqq->seek_samples)
> > -            && CFQQ_SEEKY(cfqq)))
> > +           (!cfqd->cfq_latency && !cfq_cfqq_deep(cfqq) &&
> > +               sample_valid(cfqq->seek_samples) && CFQQ_SEEKY(cfqq)))
> fix most of the regression without touching arm_slice_timer?
No. If to fix the regression completely, I need apply above patch plus
a debug patch. The debug patch is to just work around the 3 patches report by
Shaohua's tiobench regression report. Without the debug patch, the regression
isn't resolved.
Below is the debug patch.
diff -Nraup linux-2.6.33_rc1/block/cfq-iosched.c linux-2.6.33_rc1_randread64k/block/cfq-iosched.c
--- linux-2.6.33_rc1/block/cfq-iosched.c	2009-12-23 14:12:03.000000000 +0800
+++ linux-2.6.33_rc1_randread64k/block/cfq-iosched.c	2009-12-30 17:12:28.000000000 +0800
@@ -592,6 +592,9 @@ cfq_set_prio_slice(struct cfq_data *cfqd
 	cfqq->slice_start = jiffies;
 	cfqq->slice_end = jiffies + slice;
 	cfqq->allocated_slice = slice;
+/*YMZHANG*/
+	cfqq->slice_end = cfq_prio_to_slice(cfqd, cfqq) + jiffies;
+
 	cfq_log_cfqq(cfqd, cfqq, "set_slice=%lu", cfqq->slice_end - jiffies);
 }
 
@@ -1836,7 +1839,8 @@ static void cfq_arm_slice_timer(struct c
 	/*
 	 * still active requests from this queue, don't idle
 	 */
-	if (cfqq->dispatched)
+	//if (cfqq->dispatched)
+	if (rq_in_driver(cfqd))
 		return;
 
 	/*
@@ -1941,6 +1945,9 @@ static void cfq_setup_merge(struct cfq_q
 		new_cfqq = __cfqq;
 	}
 
+	/* YMZHANG debug */
+	return;
+
 	process_refs = cfqq_process_refs(cfqq);
 	/*
 	 * If the process for the cfqq has gone away, there is no


> 
> I guess
> > 5db5d64277bf390056b1a87d0bb288c8b8553f96.
> will still introduce a 10% regression, but this is needed to improve
> latency, and you can just disable low_latency to avoid it.
You are right. I did a quick testing. If my patch + revert 2 patches and keep
5db5d64, the regression is about 20%.

But low_latency=0 doesn't work like what we imagined. If patch + revert 2 patches
and keep 5db5d64 while set low_latency=0, the regression is still there. One
reason is my patch doesn't work when low_latency=0.

> 
> Thanks,
> Corrado
I attach the fio job file for your reference.

I got a cold and will continue to work on it next week.

Yanmin



--=-rgEi9kepDfzaggF32Mki
Content-Disposition: attachment; filename="fio_randread_job_file"
Content-Type: text/plain; name="fio_randread_job_file"; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

[global]
direct=0
ioengine=mmap
size=8G
bs=64k
numjobs=1
loops=5
runtime=300
group_reporting
invalidate=0
directory=/mnt/stp/fiodata
file_service_type=random:36

[job_sdb1_sub0]
startdelay=0
rw=randread
filename=data0/f1:data0/f2:data0/f3:data0/f4:data0/f5:data0/f6:data0/f7:data0/f8

[job_sdb1_sub1]
startdelay=0
rw=randread
filename=data0/f2:data0/f3:data0/f4:data0/f5:data0/f6:data0/f7:data0/f8:data0/f1

[job_sdb1_sub2]
startdelay=0
rw=randread
filename=data0/f3:data0/f4:data0/f5:data0/f6:data0/f7:data0/f8:data0/f1:data0/f2

[job_sdb1_sub3]
startdelay=0
rw=randread
filename=data0/f4:data0/f5:data0/f6:data0/f7:data0/f8:data0/f1:data0/f2:data0/f3

[job_sdb1_sub4]
startdelay=0
rw=randread
filename=data0/f5:data0/f6:data0/f7:data0/f8:data0/f1:data0/f2:data0/f3:data0/f4

[job_sdb1_sub5]
startdelay=0
rw=randread
filename=data0/f6:data0/f7:data0/f8:data0/f1:data0/f2:data0/f3:data0/f4:data0/f5

[job_sdb1_sub6]
startdelay=0
rw=randread
filename=data0/f7:data0/f8:data0/f1:data0/f2:data0/f3:data0/f4:data0/f5:data0/f6

[job_sdb1_sub7]
startdelay=0
rw=randread
filename=data0/f8:data0/f1:data0/f2:data0/f3:data0/f4:data0/f5:data0/f6:data0/f7

[job_sdb2_sub0]
startdelay=0
rw=randread
filename=data1/f1:data1/f2:data1/f3:data1/f4:data1/f5:data1/f6:data1/f7:data1/f8

[job_sdb2_sub1]
startdelay=0
rw=randread
filename=data1/f2:data1/f3:data1/f4:data1/f5:data1/f6:data1/f7:data1/f8:data1/f1

[job_sdb2_sub2]
startdelay=0
rw=randread
filename=data1/f3:data1/f4:data1/f5:data1/f6:data1/f7:data1/f8:data1/f1:data1/f2

[job_sdb2_sub3]
startdelay=0
rw=randread
filename=data1/f4:data1/f5:data1/f6:data1/f7:data1/f8:data1/f1:data1/f2:data1/f3

[job_sdb2_sub4]
startdelay=0
rw=randread
filename=data1/f5:data1/f6:data1/f7:data1/f8:data1/f1:data1/f2:data1/f3:data1/f4

[job_sdb2_sub5]
startdelay=0
rw=randread
filename=data1/f6:data1/f7:data1/f8:data1/f1:data1/f2:data1/f3:data1/f4:data1/f5

[job_sdb2_sub6]
startdelay=0
rw=randread
filename=data1/f7:data1/f8:data1/f1:data1/f2:data1/f3:data1/f4:data1/f5:data1/f6

[job_sdb2_sub7]
startdelay=0
rw=randread
filename=data1/f8:data1/f1:data1/f2:data1/f3:data1/f4:data1/f5:data1/f6:data1/f7

[job_sdc1_sub0]
startdelay=0
rw=randread
filename=data2/f1:data2/f2:data2/f3:data2/f4:data2/f5:data2/f6:data2/f7:data2/f8

[job_sdc1_sub1]
startdelay=0
rw=randread
filename=data2/f2:data2/f3:data2/f4:data2/f5:data2/f6:data2/f7:data2/f8:data2/f1

[job_sdc1_sub2]
startdelay=0
rw=randread
filename=data2/f3:data2/f4:data2/f5:data2/f6:data2/f7:data2/f8:data2/f1:data2/f2

[job_sdc1_sub3]
startdelay=0
rw=randread
filename=data2/f4:data2/f5:data2/f6:data2/f7:data2/f8:data2/f1:data2/f2:data2/f3

[job_sdc1_sub4]
startdelay=0
rw=randread
filename=data2/f5:data2/f6:data2/f7:data2/f8:data2/f1:data2/f2:data2/f3:data2/f4

[job_sdc1_sub5]
startdelay=0
rw=randread
filename=data2/f6:data2/f7:data2/f8:data2/f1:data2/f2:data2/f3:data2/f4:data2/f5

[job_sdc1_sub6]
startdelay=0
rw=randread
filename=data2/f7:data2/f8:data2/f1:data2/f2:data2/f3:data2/f4:data2/f5:data2/f6

[job_sdc1_sub7]
startdelay=0
rw=randread
filename=data2/f8:data2/f1:data2/f2:data2/f3:data2/f4:data2/f5:data2/f6:data2/f7

[job_sdc2_sub0]
startdelay=0
rw=randread
filename=data3/f1:data3/f2:data3/f3:data3/f4:data3/f5:data3/f6:data3/f7:data3/f8

[job_sdc2_sub1]
startdelay=0
rw=randread
filename=data3/f2:data3/f3:data3/f4:data3/f5:data3/f6:data3/f7:data3/f8:data3/f1

[job_sdc2_sub2]
startdelay=0
rw=randread
filename=data3/f3:data3/f4:data3/f5:data3/f6:data3/f7:data3/f8:data3/f1:data3/f2

[job_sdc2_sub3]
startdelay=0
rw=randread
filename=data3/f4:data3/f5:data3/f6:data3/f7:data3/f8:data3/f1:data3/f2:data3/f3

[job_sdc2_sub4]
startdelay=0
rw=randread
filename=data3/f5:data3/f6:data3/f7:data3/f8:data3/f1:data3/f2:data3/f3:data3/f4

[job_sdc2_sub5]
startdelay=0
rw=randread
filename=data3/f6:data3/f7:data3/f8:data3/f1:data3/f2:data3/f3:data3/f4:data3/f5

[job_sdc2_sub6]
startdelay=0
rw=randread
filename=data3/f7:data3/f8:data3/f1:data3/f2:data3/f3:data3/f4:data3/f5:data3/f6

[job_sdc2_sub7]
startdelay=0
rw=randread
filename=data3/f8:data3/f1:data3/f2:data3/f3:data3/f4:data3/f5:data3/f6:data3/f7

[job_sdd1_sub0]
startdelay=0
rw=randread
filename=data4/f1:data4/f2:data4/f3:data4/f4:data4/f5:data4/f6:data4/f7:data4/f8

[job_sdd1_sub1]
startdelay=0
rw=randread
filename=data4/f2:data4/f3:data4/f4:data4/f5:data4/f6:data4/f7:data4/f8:data4/f1

[job_sdd1_sub2]
startdelay=0
rw=randread
filename=data4/f3:data4/f4:data4/f5:data4/f6:data4/f7:data4/f8:data4/f1:data4/f2

[job_sdd1_sub3]
startdelay=0
rw=randread
filename=data4/f4:data4/f5:data4/f6:data4/f7:data4/f8:data4/f1:data4/f2:data4/f3

[job_sdd1_sub4]
startdelay=0
rw=randread
filename=data4/f5:data4/f6:data4/f7:data4/f8:data4/f1:data4/f2:data4/f3:data4/f4

[job_sdd1_sub5]
startdelay=0
rw=randread
filename=data4/f6:data4/f7:data4/f8:data4/f1:data4/f2:data4/f3:data4/f4:data4/f5

[job_sdd1_sub6]
startdelay=0
rw=randread
filename=data4/f7:data4/f8:data4/f1:data4/f2:data4/f3:data4/f4:data4/f5:data4/f6

[job_sdd1_sub7]
startdelay=0
rw=randread
filename=data4/f8:data4/f1:data4/f2:data4/f3:data4/f4:data4/f5:data4/f6:data4/f7

[job_sdd2_sub0]
startdelay=0
rw=randread
filename=data5/f1:data5/f2:data5/f3:data5/f4:data5/f5:data5/f6:data5/f7:data5/f8

[job_sdd2_sub1]
startdelay=0
rw=randread
filename=data5/f2:data5/f3:data5/f4:data5/f5:data5/f6:data5/f7:data5/f8:data5/f1

[job_sdd2_sub2]
startdelay=0
rw=randread
filename=data5/f3:data5/f4:data5/f5:data5/f6:data5/f7:data5/f8:data5/f1:data5/f2

[job_sdd2_sub3]
startdelay=0
rw=randread
filename=data5/f4:data5/f5:data5/f6:data5/f7:data5/f8:data5/f1:data5/f2:data5/f3

[job_sdd2_sub4]
startdelay=0
rw=randread
filename=data5/f5:data5/f6:data5/f7:data5/f8:data5/f1:data5/f2:data5/f3:data5/f4

[job_sdd2_sub5]
startdelay=0
rw=randread
filename=data5/f6:data5/f7:data5/f8:data5/f1:data5/f2:data5/f3:data5/f4:data5/f5

[job_sdd2_sub6]
startdelay=0
rw=randread
filename=data5/f7:data5/f8:data5/f1:data5/f2:data5/f3:data5/f4:data5/f5:data5/f6

[job_sdd2_sub7]
startdelay=0
rw=randread
filename=data5/f8:data5/f1:data5/f2:data5/f3:data5/f4:data5/f5:data5/f6:data5/f7

[job_sde1_sub0]
startdelay=0
rw=randread
filename=data6/f1:data6/f2:data6/f3:data6/f4:data6/f5:data6/f6:data6/f7:data6/f8

[job_sde1_sub1]
startdelay=0
rw=randread
filename=data6/f2:data6/f3:data6/f4:data6/f5:data6/f6:data6/f7:data6/f8:data6/f1

[job_sde1_sub2]
startdelay=0
rw=randread
filename=data6/f3:data6/f4:data6/f5:data6/f6:data6/f7:data6/f8:data6/f1:data6/f2

[job_sde1_sub3]
startdelay=0
rw=randread
filename=data6/f4:data6/f5:data6/f6:data6/f7:data6/f8:data6/f1:data6/f2:data6/f3

[job_sde1_sub4]
startdelay=0
rw=randread
filename=data6/f5:data6/f6:data6/f7:data6/f8:data6/f1:data6/f2:data6/f3:data6/f4

[job_sde1_sub5]
startdelay=0
rw=randread
filename=data6/f6:data6/f7:data6/f8:data6/f1:data6/f2:data6/f3:data6/f4:data6/f5

[job_sde1_sub6]
startdelay=0
rw=randread
filename=data6/f7:data6/f8:data6/f1:data6/f2:data6/f3:data6/f4:data6/f5:data6/f6

[job_sde1_sub7]
startdelay=0
rw=randread
filename=data6/f8:data6/f1:data6/f2:data6/f3:data6/f4:data6/f5:data6/f6:data6/f7

[job_sde2_sub0]
startdelay=0
rw=randread
filename=data7/f1:data7/f2:data7/f3:data7/f4:data7/f5:data7/f6:data7/f7:data7/f8

[job_sde2_sub1]
startdelay=0
rw=randread
filename=data7/f2:data7/f3:data7/f4:data7/f5:data7/f6:data7/f7:data7/f8:data7/f1

[job_sde2_sub2]
startdelay=0
rw=randread
filename=data7/f3:data7/f4:data7/f5:data7/f6:data7/f7:data7/f8:data7/f1:data7/f2

[job_sde2_sub3]
startdelay=0
rw=randread
filename=data7/f4:data7/f5:data7/f6:data7/f7:data7/f8:data7/f1:data7/f2:data7/f3

[job_sde2_sub4]
startdelay=0
rw=randread
filename=data7/f5:data7/f6:data7/f7:data7/f8:data7/f1:data7/f2:data7/f3:data7/f4

[job_sde2_sub5]
startdelay=0
rw=randread
filename=data7/f6:data7/f7:data7/f8:data7/f1:data7/f2:data7/f3:data7/f4:data7/f5

[job_sde2_sub6]
startdelay=0
rw=randread
filename=data7/f7:data7/f8:data7/f1:data7/f2:data7/f3:data7/f4:data7/f5:data7/f6

[job_sde2_sub7]
startdelay=0
rw=randread
filename=data7/f8:data7/f1:data7/f2:data7/f3:data7/f4:data7/f5:data7/f6:data7/f7

[job_sdf1_sub0]
startdelay=0
rw=randread
filename=data8/f1:data8/f2:data8/f3:data8/f4:data8/f5:data8/f6:data8/f7:data8/f8

[job_sdf1_sub1]
startdelay=0
rw=randread
filename=data8/f2:data8/f3:data8/f4:data8/f5:data8/f6:data8/f7:data8/f8:data8/f1

[job_sdf1_sub2]
startdelay=0
rw=randread
filename=data8/f3:data8/f4:data8/f5:data8/f6:data8/f7:data8/f8:data8/f1:data8/f2

[job_sdf1_sub3]
startdelay=0
rw=randread
filename=data8/f4:data8/f5:data8/f6:data8/f7:data8/f8:data8/f1:data8/f2:data8/f3

[job_sdf1_sub4]
startdelay=0
rw=randread
filename=data8/f5:data8/f6:data8/f7:data8/f8:data8/f1:data8/f2:data8/f3:data8/f4

[job_sdf1_sub5]
startdelay=0
rw=randread
filename=data8/f6:data8/f7:data8/f8:data8/f1:data8/f2:data8/f3:data8/f4:data8/f5

[job_sdf1_sub6]
startdelay=0
rw=randread
filename=data8/f7:data8/f8:data8/f1:data8/f2:data8/f3:data8/f4:data8/f5:data8/f6

[job_sdf1_sub7]
startdelay=0
rw=randread
filename=data8/f8:data8/f1:data8/f2:data8/f3:data8/f4:data8/f5:data8/f6:data8/f7

[job_sdf2_sub0]
startdelay=0
rw=randread
filename=data9/f1:data9/f2:data9/f3:data9/f4:data9/f5:data9/f6:data9/f7:data9/f8

[job_sdf2_sub1]
startdelay=0
rw=randread
filename=data9/f2:data9/f3:data9/f4:data9/f5:data9/f6:data9/f7:data9/f8:data9/f1

[job_sdf2_sub2]
startdelay=0
rw=randread
filename=data9/f3:data9/f4:data9/f5:data9/f6:data9/f7:data9/f8:data9/f1:data9/f2

[job_sdf2_sub3]
startdelay=0
rw=randread
filename=data9/f4:data9/f5:data9/f6:data9/f7:data9/f8:data9/f1:data9/f2:data9/f3

[job_sdf2_sub4]
startdelay=0
rw=randread
filename=data9/f5:data9/f6:data9/f7:data9/f8:data9/f1:data9/f2:data9/f3:data9/f4

[job_sdf2_sub5]
startdelay=0
rw=randread
filename=data9/f6:data9/f7:data9/f8:data9/f1:data9/f2:data9/f3:data9/f4:data9/f5

[job_sdf2_sub6]
startdelay=0
rw=randread
filename=data9/f7:data9/f8:data9/f1:data9/f2:data9/f3:data9/f4:data9/f5:data9/f6

[job_sdf2_sub7]
startdelay=0
rw=randread
filename=data9/f8:data9/f1:data9/f2:data9/f3:data9/f4:data9/f5:data9/f6:data9/f7

[job_sdg1_sub0]
startdelay=0
rw=randread
filename=data10/f1:data10/f2:data10/f3:data10/f4:data10/f5:data10/f6:data10/f7:data10/f8

[job_sdg1_sub1]
startdelay=0
rw=randread
filename=data10/f2:data10/f3:data10/f4:data10/f5:data10/f6:data10/f7:data10/f8:data10/f1

[job_sdg1_sub2]
startdelay=0
rw=randread
filename=data10/f3:data10/f4:data10/f5:data10/f6:data10/f7:data10/f8:data10/f1:data10/f2

[job_sdg1_sub3]
startdelay=0
rw=randread
filename=data10/f4:data10/f5:data10/f6:data10/f7:data10/f8:data10/f1:data10/f2:data10/f3

[job_sdg1_sub4]
startdelay=0
rw=randread
filename=data10/f5:data10/f6:data10/f7:data10/f8:data10/f1:data10/f2:data10/f3:data10/f4

[job_sdg1_sub5]
startdelay=0
rw=randread
filename=data10/f6:data10/f7:data10/f8:data10/f1:data10/f2:data10/f3:data10/f4:data10/f5

[job_sdg1_sub6]
startdelay=0
rw=randread
filename=data10/f7:data10/f8:data10/f1:data10/f2:data10/f3:data10/f4:data10/f5:data10/f6

[job_sdg1_sub7]
startdelay=0
rw=randread
filename=data10/f8:data10/f1:data10/f2:data10/f3:data10/f4:data10/f5:data10/f6:data10/f7

[job_sdg2_sub0]
startdelay=0
rw=randread
filename=data11/f1:data11/f2:data11/f3:data11/f4:data11/f5:data11/f6:data11/f7:data11/f8

[job_sdg2_sub1]
startdelay=0
rw=randread
filename=data11/f2:data11/f3:data11/f4:data11/f5:data11/f6:data11/f7:data11/f8:data11/f1

[job_sdg2_sub2]
startdelay=0
rw=randread
filename=data11/f3:data11/f4:data11/f5:data11/f6:data11/f7:data11/f8:data11/f1:data11/f2

[job_sdg2_sub3]
startdelay=0
rw=randread
filename=data11/f4:data11/f5:data11/f6:data11/f7:data11/f8:data11/f1:data11/f2:data11/f3

[job_sdg2_sub4]
startdelay=0
rw=randread
filename=data11/f5:data11/f6:data11/f7:data11/f8:data11/f1:data11/f2:data11/f3:data11/f4

[job_sdg2_sub5]
startdelay=0
rw=randread
filename=data11/f6:data11/f7:data11/f8:data11/f1:data11/f2:data11/f3:data11/f4:data11/f5

[job_sdg2_sub6]
startdelay=0
rw=randread
filename=data11/f7:data11/f8:data11/f1:data11/f2:data11/f3:data11/f4:data11/f5:data11/f6

[job_sdg2_sub7]
startdelay=0
rw=randread
filename=data11/f8:data11/f1:data11/f2:data11/f3:data11/f4:data11/f5:data11/f6:data11/f7

[job_sdh1_sub0]
startdelay=0
rw=randread
filename=data12/f1:data12/f2:data12/f3:data12/f4:data12/f5:data12/f6:data12/f7:data12/f8

[job_sdh1_sub1]
startdelay=0
rw=randread
filename=data12/f2:data12/f3:data12/f4:data12/f5:data12/f6:data12/f7:data12/f8:data12/f1

[job_sdh1_sub2]
startdelay=0
rw=randread
filename=data12/f3:data12/f4:data12/f5:data12/f6:data12/f7:data12/f8:data12/f1:data12/f2

[job_sdh1_sub3]
startdelay=0
rw=randread
filename=data12/f4:data12/f5:data12/f6:data12/f7:data12/f8:data12/f1:data12/f2:data12/f3

[job_sdh1_sub4]
startdelay=0
rw=randread
filename=data12/f5:data12/f6:data12/f7:data12/f8:data12/f1:data12/f2:data12/f3:data12/f4

[job_sdh1_sub5]
startdelay=0
rw=randread
filename=data12/f6:data12/f7:data12/f8:data12/f1:data12/f2:data12/f3:data12/f4:data12/f5

[job_sdh1_sub6]
startdelay=0
rw=randread
filename=data12/f7:data12/f8:data12/f1:data12/f2:data12/f3:data12/f4:data12/f5:data12/f6

[job_sdh1_sub7]
startdelay=0
rw=randread
filename=data12/f8:data12/f1:data12/f2:data12/f3:data12/f4:data12/f5:data12/f6:data12/f7

[job_sdh2_sub0]
startdelay=0
rw=randread
filename=data13/f1:data13/f2:data13/f3:data13/f4:data13/f5:data13/f6:data13/f7:data13/f8

[job_sdh2_sub1]
startdelay=0
rw=randread
filename=data13/f2:data13/f3:data13/f4:data13/f5:data13/f6:data13/f7:data13/f8:data13/f1

[job_sdh2_sub2]
startdelay=0
rw=randread
filename=data13/f3:data13/f4:data13/f5:data13/f6:data13/f7:data13/f8:data13/f1:data13/f2

[job_sdh2_sub3]
startdelay=0
rw=randread
filename=data13/f4:data13/f5:data13/f6:data13/f7:data13/f8:data13/f1:data13/f2:data13/f3

[job_sdh2_sub4]
startdelay=0
rw=randread
filename=data13/f5:data13/f6:data13/f7:data13/f8:data13/f1:data13/f2:data13/f3:data13/f4

[job_sdh2_sub5]
startdelay=0
rw=randread
filename=data13/f6:data13/f7:data13/f8:data13/f1:data13/f2:data13/f3:data13/f4:data13/f5

[job_sdh2_sub6]
startdelay=0
rw=randread
filename=data13/f7:data13/f8:data13/f1:data13/f2:data13/f3:data13/f4:data13/f5:data13/f6

[job_sdh2_sub7]
startdelay=0
rw=randread
filename=data13/f8:data13/f1:data13/f2:data13/f3:data13/f4:data13/f5:data13/f6:data13/f7

[job_sdi1_sub0]
startdelay=0
rw=randread
filename=data14/f1:data14/f2:data14/f3:data14/f4:data14/f5:data14/f6:data14/f7:data14/f8

[job_sdi1_sub1]
startdelay=0
rw=randread
filename=data14/f2:data14/f3:data14/f4:data14/f5:data14/f6:data14/f7:data14/f8:data14/f1

[job_sdi1_sub2]
startdelay=0
rw=randread
filename=data14/f3:data14/f4:data14/f5:data14/f6:data14/f7:data14/f8:data14/f1:data14/f2

[job_sdi1_sub3]
startdelay=0
rw=randread
filename=data14/f4:data14/f5:data14/f6:data14/f7:data14/f8:data14/f1:data14/f2:data14/f3

[job_sdi1_sub4]
startdelay=0
rw=randread
filename=data14/f5:data14/f6:data14/f7:data14/f8:data14/f1:data14/f2:data14/f3:data14/f4

[job_sdi1_sub5]
startdelay=0
rw=randread
filename=data14/f6:data14/f7:data14/f8:data14/f1:data14/f2:data14/f3:data14/f4:data14/f5

[job_sdi1_sub6]
startdelay=0
rw=randread
filename=data14/f7:data14/f8:data14/f1:data14/f2:data14/f3:data14/f4:data14/f5:data14/f6

[job_sdi1_sub7]
startdelay=0
rw=randread
filename=data14/f8:data14/f1:data14/f2:data14/f3:data14/f4:data14/f5:data14/f6:data14/f7

[job_sdi2_sub0]
startdelay=0
rw=randread
filename=data15/f1:data15/f2:data15/f3:data15/f4:data15/f5:data15/f6:data15/f7:data15/f8

[job_sdi2_sub1]
startdelay=0
rw=randread
filename=data15/f2:data15/f3:data15/f4:data15/f5:data15/f6:data15/f7:data15/f8:data15/f1

[job_sdi2_sub2]
startdelay=0
rw=randread
filename=data15/f3:data15/f4:data15/f5:data15/f6:data15/f7:data15/f8:data15/f1:data15/f2

[job_sdi2_sub3]
startdelay=0
rw=randread
filename=data15/f4:data15/f5:data15/f6:data15/f7:data15/f8:data15/f1:data15/f2:data15/f3

[job_sdi2_sub4]
startdelay=0
rw=randread
filename=data15/f5:data15/f6:data15/f7:data15/f8:data15/f1:data15/f2:data15/f3:data15/f4

[job_sdi2_sub5]
startdelay=0
rw=randread
filename=data15/f6:data15/f7:data15/f8:data15/f1:data15/f2:data15/f3:data15/f4:data15/f5

[job_sdi2_sub6]
startdelay=0
rw=randread
filename=data15/f7:data15/f8:data15/f1:data15/f2:data15/f3:data15/f4:data15/f5:data15/f6

[job_sdi2_sub7]
startdelay=0
rw=randread
filename=data15/f8:data15/f1:data15/f2:data15/f3:data15/f4:data15/f5:data15/f6:data15/f7

[job_sdj1_sub0]
startdelay=0
rw=randread
filename=data16/f1:data16/f2:data16/f3:data16/f4:data16/f5:data16/f6:data16/f7:data16/f8

[job_sdj1_sub1]
startdelay=0
rw=randread
filename=data16/f2:data16/f3:data16/f4:data16/f5:data16/f6:data16/f7:data16/f8:data16/f1

[job_sdj1_sub2]
startdelay=0
rw=randread
filename=data16/f3:data16/f4:data16/f5:data16/f6:data16/f7:data16/f8:data16/f1:data16/f2

[job_sdj1_sub3]
startdelay=0
rw=randread
filename=data16/f4:data16/f5:data16/f6:data16/f7:data16/f8:data16/f1:data16/f2:data16/f3

[job_sdj1_sub4]
startdelay=0
rw=randread
filename=data16/f5:data16/f6:data16/f7:data16/f8:data16/f1:data16/f2:data16/f3:data16/f4

[job_sdj1_sub5]
startdelay=0
rw=randread
filename=data16/f6:data16/f7:data16/f8:data16/f1:data16/f2:data16/f3:data16/f4:data16/f5

[job_sdj1_sub6]
startdelay=0
rw=randread
filename=data16/f7:data16/f8:data16/f1:data16/f2:data16/f3:data16/f4:data16/f5:data16/f6

[job_sdj1_sub7]
startdelay=0
rw=randread
filename=data16/f8:data16/f1:data16/f2:data16/f3:data16/f4:data16/f5:data16/f6:data16/f7

[job_sdj2_sub0]
startdelay=0
rw=randread
filename=data17/f1:data17/f2:data17/f3:data17/f4:data17/f5:data17/f6:data17/f7:data17/f8

[job_sdj2_sub1]
startdelay=0
rw=randread
filename=data17/f2:data17/f3:data17/f4:data17/f5:data17/f6:data17/f7:data17/f8:data17/f1

[job_sdj2_sub2]
startdelay=0
rw=randread
filename=data17/f3:data17/f4:data17/f5:data17/f6:data17/f7:data17/f8:data17/f1:data17/f2

[job_sdj2_sub3]
startdelay=0
rw=randread
filename=data17/f4:data17/f5:data17/f6:data17/f7:data17/f8:data17/f1:data17/f2:data17/f3

[job_sdj2_sub4]
startdelay=0
rw=randread
filename=data17/f5:data17/f6:data17/f7:data17/f8:data17/f1:data17/f2:data17/f3:data17/f4

[job_sdj2_sub5]
startdelay=0
rw=randread
filename=data17/f6:data17/f7:data17/f8:data17/f1:data17/f2:data17/f3:data17/f4:data17/f5

[job_sdj2_sub6]
startdelay=0
rw=randread
filename=data17/f7:data17/f8:data17/f1:data17/f2:data17/f3:data17/f4:data17/f5:data17/f6

[job_sdj2_sub7]
startdelay=0
rw=randread
filename=data17/f8:data17/f1:data17/f2:data17/f3:data17/f4:data17/f5:data17/f6:data17/f7

[job_sdk1_sub0]
startdelay=0
rw=randread
filename=data18/f1:data18/f2:data18/f3:data18/f4:data18/f5:data18/f6:data18/f7:data18/f8

[job_sdk1_sub1]
startdelay=0
rw=randread
filename=data18/f2:data18/f3:data18/f4:data18/f5:data18/f6:data18/f7:data18/f8:data18/f1

[job_sdk1_sub2]
startdelay=0
rw=randread
filename=data18/f3:data18/f4:data18/f5:data18/f6:data18/f7:data18/f8:data18/f1:data18/f2

[job_sdk1_sub3]
startdelay=0
rw=randread
filename=data18/f4:data18/f5:data18/f6:data18/f7:data18/f8:data18/f1:data18/f2:data18/f3

[job_sdk1_sub4]
startdelay=0
rw=randread
filename=data18/f5:data18/f6:data18/f7:data18/f8:data18/f1:data18/f2:data18/f3:data18/f4

[job_sdk1_sub5]
startdelay=0
rw=randread
filename=data18/f6:data18/f7:data18/f8:data18/f1:data18/f2:data18/f3:data18/f4:data18/f5

[job_sdk1_sub6]
startdelay=0
rw=randread
filename=data18/f7:data18/f8:data18/f1:data18/f2:data18/f3:data18/f4:data18/f5:data18/f6

[job_sdk1_sub7]
startdelay=0
rw=randread
filename=data18/f8:data18/f1:data18/f2:data18/f3:data18/f4:data18/f5:data18/f6:data18/f7

[job_sdk2_sub0]
startdelay=0
rw=randread
filename=data19/f1:data19/f2:data19/f3:data19/f4:data19/f5:data19/f6:data19/f7:data19/f8

[job_sdk2_sub1]
startdelay=0
rw=randread
filename=data19/f2:data19/f3:data19/f4:data19/f5:data19/f6:data19/f7:data19/f8:data19/f1

[job_sdk2_sub2]
startdelay=0
rw=randread
filename=data19/f3:data19/f4:data19/f5:data19/f6:data19/f7:data19/f8:data19/f1:data19/f2

[job_sdk2_sub3]
startdelay=0
rw=randread
filename=data19/f4:data19/f5:data19/f6:data19/f7:data19/f8:data19/f1:data19/f2:data19/f3

[job_sdk2_sub4]
startdelay=0
rw=randread
filename=data19/f5:data19/f6:data19/f7:data19/f8:data19/f1:data19/f2:data19/f3:data19/f4

[job_sdk2_sub5]
startdelay=0
rw=randread
filename=data19/f6:data19/f7:data19/f8:data19/f1:data19/f2:data19/f3:data19/f4:data19/f5

[job_sdk2_sub6]
startdelay=0
rw=randread
filename=data19/f7:data19/f8:data19/f1:data19/f2:data19/f3:data19/f4:data19/f5:data19/f6

[job_sdk2_sub7]
startdelay=0
rw=randread
filename=data19/f8:data19/f1:data19/f2:data19/f3:data19/f4:data19/f5:data19/f6:data19/f7

[job_sdl1_sub0]
startdelay=0
rw=randread
filename=data20/f1:data20/f2:data20/f3:data20/f4:data20/f5:data20/f6:data20/f7:data20/f8

[job_sdl1_sub1]
startdelay=0
rw=randread
filename=data20/f2:data20/f3:data20/f4:data20/f5:data20/f6:data20/f7:data20/f8:data20/f1

[job_sdl1_sub2]
startdelay=0
rw=randread
filename=data20/f3:data20/f4:data20/f5:data20/f6:data20/f7:data20/f8:data20/f1:data20/f2

[job_sdl1_sub3]
startdelay=0
rw=randread
filename=data20/f4:data20/f5:data20/f6:data20/f7:data20/f8:data20/f1:data20/f2:data20/f3

[job_sdl1_sub4]
startdelay=0
rw=randread
filename=data20/f5:data20/f6:data20/f7:data20/f8:data20/f1:data20/f2:data20/f3:data20/f4

[job_sdl1_sub5]
startdelay=0
rw=randread
filename=data20/f6:data20/f7:data20/f8:data20/f1:data20/f2:data20/f3:data20/f4:data20/f5

[job_sdl1_sub6]
startdelay=0
rw=randread
filename=data20/f7:data20/f8:data20/f1:data20/f2:data20/f3:data20/f4:data20/f5:data20/f6

[job_sdl1_sub7]
startdelay=0
rw=randread
filename=data20/f8:data20/f1:data20/f2:data20/f3:data20/f4:data20/f5:data20/f6:data20/f7

[job_sdl2_sub0]
startdelay=0
rw=randread
filename=data21/f1:data21/f2:data21/f3:data21/f4:data21/f5:data21/f6:data21/f7:data21/f8

[job_sdl2_sub1]
startdelay=0
rw=randread
filename=data21/f2:data21/f3:data21/f4:data21/f5:data21/f6:data21/f7:data21/f8:data21/f1

[job_sdl2_sub2]
startdelay=0
rw=randread
filename=data21/f3:data21/f4:data21/f5:data21/f6:data21/f7:data21/f8:data21/f1:data21/f2

[job_sdl2_sub3]
startdelay=0
rw=randread
filename=data21/f4:data21/f5:data21/f6:data21/f7:data21/f8:data21/f1:data21/f2:data21/f3

[job_sdl2_sub4]
startdelay=0
rw=randread
filename=data21/f5:data21/f6:data21/f7:data21/f8:data21/f1:data21/f2:data21/f3:data21/f4

[job_sdl2_sub5]
startdelay=0
rw=randread
filename=data21/f6:data21/f7:data21/f8:data21/f1:data21/f2:data21/f3:data21/f4:data21/f5

[job_sdl2_sub6]
startdelay=0
rw=randread
filename=data21/f7:data21/f8:data21/f1:data21/f2:data21/f3:data21/f4:data21/f5:data21/f6

[job_sdl2_sub7]
startdelay=0
rw=randread
filename=data21/f8:data21/f1:data21/f2:data21/f3:data21/f4:data21/f5:data21/f6:data21/f7

[job_sdm1_sub0]
startdelay=0
rw=randread
filename=data22/f1:data22/f2:data22/f3:data22/f4:data22/f5:data22/f6:data22/f7:data22/f8

[job_sdm1_sub1]
startdelay=0
rw=randread
filename=data22/f2:data22/f3:data22/f4:data22/f5:data22/f6:data22/f7:data22/f8:data22/f1

[job_sdm1_sub2]
startdelay=0
rw=randread
filename=data22/f3:data22/f4:data22/f5:data22/f6:data22/f7:data22/f8:data22/f1:data22/f2

[job_sdm1_sub3]
startdelay=0
rw=randread
filename=data22/f4:data22/f5:data22/f6:data22/f7:data22/f8:data22/f1:data22/f2:data22/f3

[job_sdm1_sub4]
startdelay=0
rw=randread
filename=data22/f5:data22/f6:data22/f7:data22/f8:data22/f1:data22/f2:data22/f3:data22/f4

[job_sdm1_sub5]
startdelay=0
rw=randread
filename=data22/f6:data22/f7:data22/f8:data22/f1:data22/f2:data22/f3:data22/f4:data22/f5

[job_sdm1_sub6]
startdelay=0
rw=randread
filename=data22/f7:data22/f8:data22/f1:data22/f2:data22/f3:data22/f4:data22/f5:data22/f6

[job_sdm1_sub7]
startdelay=0
rw=randread
filename=data22/f8:data22/f1:data22/f2:data22/f3:data22/f4:data22/f5:data22/f6:data22/f7

[job_sdm2_sub0]
startdelay=0
rw=randread
filename=data23/f1:data23/f2:data23/f3:data23/f4:data23/f5:data23/f6:data23/f7:data23/f8

[job_sdm2_sub1]
startdelay=0
rw=randread
filename=data23/f2:data23/f3:data23/f4:data23/f5:data23/f6:data23/f7:data23/f8:data23/f1

[job_sdm2_sub2]
startdelay=0
rw=randread
filename=data23/f3:data23/f4:data23/f5:data23/f6:data23/f7:data23/f8:data23/f1:data23/f2

[job_sdm2_sub3]
startdelay=0
rw=randread
filename=data23/f4:data23/f5:data23/f6:data23/f7:data23/f8:data23/f1:data23/f2:data23/f3

[job_sdm2_sub4]
startdelay=0
rw=randread
filename=data23/f5:data23/f6:data23/f7:data23/f8:data23/f1:data23/f2:data23/f3:data23/f4

[job_sdm2_sub5]
startdelay=0
rw=randread
filename=data23/f6:data23/f7:data23/f8:data23/f1:data23/f2:data23/f3:data23/f4:data23/f5

[job_sdm2_sub6]
startdelay=0
rw=randread
filename=data23/f7:data23/f8:data23/f1:data23/f2:data23/f3:data23/f4:data23/f5:data23/f6

[job_sdm2_sub7]
startdelay=0
rw=randread
filename=data23/f8:data23/f1:data23/f2:data23/f3:data23/f4:data23/f5:data23/f6:data23/f7


--=-rgEi9kepDfzaggF32Mki--

