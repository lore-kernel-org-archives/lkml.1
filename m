Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0AODUp (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 22:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674Ab0AODUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 22:20:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:39537 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab0AODUn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 22:20:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="232996532"
From: "Li, Shaohua" <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
CC: Corrado Zoccolo <czoccolo@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>
Date: Fri, 15 Jan 2010 11:20:28 +0800
Subject: RE: [RFC]cfq-iosched: quantum check tweak
Thread-Topic: [RFC]cfq-iosched: quantum check tweak
Thread-Index: AcqVDSDUz6zfdhzFT0C7Hoi+QCeRpgAg3maQ
Message-ID: <C8EDE645B81E5141A8C6B2F73FD926511497991F76@shzsmsx501.ccr.corp.intel.com>
References: <20100108171535.GC22219@redhat.com>
 <4e5e476b1001081235wc2784c1s87c0c70662b5e267@mail.gmail.com>
 <20100108205948.GH22219@redhat.com>
 <20100111023409.GE22362@sli10-desk.sh.intel.com>
 <20100111170339.GC22899@redhat.com>
 <20100112030756.GB22606@sli10-desk.sh.intel.com>
 <20100112154820.GB3065@redhat.com>
 <20100113081735.GD10492@sli10-desk.sh.intel.com>
 <20100113111807.GC3087@redhat.com>
 <20100114041624.GA10276@sli10-desk.sh.intel.com>
 <20100114113103.GB15559@redhat.com>
In-Reply-To: <20100114113103.GB15559@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Vivek Goyal [mailto:vgoyal@redhat.com]
>Sent: Thursday, January 14, 2010 7:31 PM
>To: Li, Shaohua
>Cc: Corrado Zoccolo; linux-kernel@vger.kernel.org; jens.axboe@oracle.com;
>Zhang, Yanmin
>Subject: Re: [RFC]cfq-iosched: quantum check tweak
>
>On Thu, Jan 14, 2010 at 12:16:24PM +0800, Shaohua Li wrote:
>> On Wed, Jan 13, 2010 at 07:18:07PM +0800, Vivek Goyal wrote:
>> > On Wed, Jan 13, 2010 at 04:17:35PM +0800, Shaohua Li wrote:
>> > [..]
>> > > > >  static bool cfq_may_dispatch(struct cfq_data *cfqd, struct
>cfq_queue *cfqq)
>> > > > >  {
>> > > > >  	unsigned int max_dispatch;
>> > > > > @@ -2258,7 +2273,10 @@ static bool cfq_may_dispatch(struct cfq_
>> > > > >  	if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
>> > > > >  		return false;
>> > > > >
>> > > > > -	max_dispatch = cfqd->cfq_quantum;
>> > > > > +	max_dispatch = cfqd->cfq_quantum / 2;
>> > > > > +	if (max_dispatch < CFQ_SOFT_QUANTUM)
>> > > >
>> > > > We don't have to hardcode CFQ_SOFT_QUANTUM or in fact we don't
>need it. We can
>> > > > derive the soft limit from hard limit (cfq_quantum). Say soft
>limit will be
>> > > > 50% of cfq_quantum value.
>> > > I'm hoping this doesn't give user a surprise. Say cfq_quantum sets
>to 7, then we
>> > > start doing throttling from 3 requests. Adding the CFQ_SOFT_QUANTUM
>gives a compatibility
>> > > against old behavior at least. Am I over thinking?
>> > >
>> >
>> > I would not worry too much about that. If you are really worried about
>> > that, then create one Documentation/block/cfq-iosched.txt and document
>> > how cfq_quantum works so that users know that cfq_quantum is upper
>hard
>> > limit and internal soft limit is cfq_quantum/2.
>> Good idea. Looks we don't document cfq tunnables, I'll try to do it
>later.
>>
>> Currently a queue can only dispatch up to 4 requests if there are other
>queues.
>> This isn't optimal, device can handle more requests, for example, AHCI
>can
>> handle 31 requests. I can understand the limit is for fairness, but we
>could
>> do a tweak: if the queue still has a lot of slice left, sounds we could
>> ignore the limit.
>
>Hi Shaohua,
>
>This looks much better. Though usage of "slice_idle" as measure of service
>times, I find little un-intutive. Especially, I do some testing with
>slice_idle=0, in that case, we will be allowing dispatch of 8 requests
>from each queue even if slice is about to expire.
>
>But I guess that's fine for the time being as upper limit is still
>controlld by cfq_quantum.
>
>> Test shows this boost my workload (two thread randread of a SSD) from
>78m/s
>> to 100m/s.
>
>Are these deep queue random reads (with higher iodepths, using libaio)?
>
>Have you done similar test on some slower NCQ rotational hardware also and
>seen the impact on throughput and *max latency* of readers, especially in
>the presence of buffered writers.
Tested in a 320g hardidisk (ST3320620AS). The throughput
improves about 6% and average latency drops 6% too. Below is the fio
output, I tested 3 run for each case, the result is similar.

No patch case:
sdb: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=32
sdb: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=32
Starting 2 processes

sdb: (groupid=0, jobs=2): err= 0: pid=3389
  read : io=90,900KiB, bw=755KiB/s, iops=188, runt=120336msec
    slat (usec): min=8, max=527K, avg=679.01, stdev=6101.05
    clat (usec): min=0, max=0, avg= 0.00, stdev= 0.00
    bw (KiB/s) : min=    0, max=  837, per=47.35%, avg=357.50, stdev=78.71
  cpu          : usr=0.02%, sys=0.13%, ctx=22661, majf=0, minf=169
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=99.7%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued r/w: total=22725/0, short=0/0

     lat (msec): 10=0.04%, 20=1.34%, 50=7.42%, 100=8.05%, 250=31.58%
     lat (msec): 500=30.38%, 750=13.79%, 1000=5.27%, 2000=2.14%

Run status group 0 (all jobs):
   READ: io=90,900KiB, aggrb=755KiB/s, minb=755KiB/s, maxb=755KiB/s, mint=120336msec, maxt=120336msec
--------------------------------------------------------------------------
Patched case:
sdb: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=32
sdb: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=32
Starting 2 processes

sdb: (groupid=0, jobs=2): err= 0: pid=4776
  read : io=98,140KiB, bw=815KiB/s, iops=203, runt=120323msec
    slat (usec): min=9, max=68, avg=11.23, stdev= 1.03
    clat (usec): min=0, max=0, avg= 0.00, stdev= 0.00
    bw (KiB/s) : min=    0, max=  534, per=47.28%, avg=385.32, stdev=74.37
  cpu          : usr=0.04%, sys=0.13%, ctx=24523, majf=0, minf=188
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=99.7%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued r/w: total=24535/0, short=0/0

     lat (msec): 10=0.01%, 20=0.93%, 50=6.50%, 100=7.65%, 250=36.40%
     lat (msec): 500=31.81%, 750=11.24%, 1000=4.08%, 2000=1.38%

Run status group 0 (all jobs):
   READ: io=98,140KiB, aggrb=815KiB/s, minb=815KiB/s, maxb=815KiB/s, mint=120323msec, maxt=120323msec
