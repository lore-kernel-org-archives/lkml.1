Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab0CCVVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:21:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab0CCVVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:21:23 -0500
Date: Wed, 3 Mar 2010 16:21:12 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] cfq-iosched: rethink seeky detection for SSDs
Message-ID: <20100303212112.GB2974@redhat.com>
References: <1267296340-3820-1-git-send-email-czoccolo@gmail.com> <1267296340-3820-2-git-send-email-czoccolo@gmail.com> <1267296340-3820-3-git-send-email-czoccolo@gmail.com> <20100301142553.GB8878@redhat.com> <4e5e476b1003031147n6a53b646k418483a93013d77c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b1003031147n6a53b646k418483a93013d77c@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 08:47:31PM +0100, Corrado Zoccolo wrote:
> Hi Vivek,
> On Mon, Mar 1, 2010 at 3:25 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Sat, Feb 27, 2010 at 07:45:40PM +0100, Corrado Zoccolo wrote:
> >> CFQ currently applies the same logic of detecting seeky queues and
> >> grouping them together for rotational disks as well as SSDs.
> >> For SSDs, the time to complete a request doesn't depend on the
> >> request location, but only on the size.
> >> This patch therefore changes the criterion to group queues by
> >> request size in case of SSDs, in order to achieve better fairness.
> >
> > Hi Corrado,
> >
> > Can you give some numbers regarding how are you measuring fairness and
> > how did you decide that we achieve better fairness?
> >
> Please, see the attached fio script. It benchmarks pairs of processes
> performing direct random I/O.
> One is always fixed at bs=4k , while I vary the other from 8K to 64K
> test00: (g=0): rw=randread, bs=8K-8K/8K-8K, ioengine=sync, iodepth=1
> test01: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
> test10: (g=1): rw=randread, bs=16K-16K/16K-16K, ioengine=sync, iodepth=1
> test11: (g=1): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
> test20: (g=2): rw=randread, bs=32K-32K/32K-32K, ioengine=sync, iodepth=1
> test21: (g=2): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
> test30: (g=3): rw=randread, bs=64K-64K/64K-64K, ioengine=sync, iodepth=1
> test31: (g=3): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
> 
> With unpatched cfq (2.6.33), on a flash card (non-ncq), after running
> a fio script with high number of parallel readers to make sure ncq
> detection is stabilized, I get the following:
> Run status group 0 (all jobs):
>    READ: io=21528KiB, aggrb=4406KiB/s, minb=1485KiB/s, maxb=2922KiB/s,
> mint=5001msec, maxt=5003msec
> 
> Run status group 1 (all jobs):
>    READ: io=31524KiB, aggrb=6452KiB/s, minb=1327KiB/s, maxb=5126KiB/s,
> mint=5002msec, maxt=5003msec
> 
> Run status group 2 (all jobs):
>    READ: io=46544KiB, aggrb=9524KiB/s, minb=1031KiB/s, maxb=8493KiB/s,
> mint=5001msec, maxt=5004msec
> 
> Run status group 3 (all jobs):
>    READ: io=64712KiB, aggrb=13242KiB/s, minb=761KiB/s,
> maxb=12486KiB/s, mint=5002msec, maxt=5004msec
> 
> As you can see from minb, the process with smallest I/O size is
> penalized (the fact is that being both marked as noidle, they both end
> up in the noidle tree, where they are serviced round robin, so they
> get fairness in term of IOPS, but bandwidth varies a lot.
> 
> With my patches in place, I get:
> Run status group 0 (all jobs):
>    READ: io=21544KiB, aggrb=4409KiB/s, minb=1511KiB/s, maxb=2898KiB/s,
> mint=5002msec, maxt=5003msec
> 
> Run status group 1 (all jobs):
>    READ: io=32000KiB, aggrb=6549KiB/s, minb=1277KiB/s, maxb=5274KiB/s,
> mint=5001msec, maxt=5003msec
> 
> Run status group 2 (all jobs):
>    READ: io=39444KiB, aggrb=8073KiB/s, minb=1576KiB/s, maxb=6498KiB/s,
> mint=5002msec, maxt=5003msec
> 
> Run status group 3 (all jobs):
>    READ: io=49180KiB, aggrb=10059KiB/s, minb=1512KiB/s,
> maxb=8548KiB/s, mint=5001msec, maxt=5006msec
> 
> The process doing smaller requests is now not penalized by the fact
> that it is run concurrently with the other one, and the other still
> benefits from larger requests because it uses better its time slice.

Ok, so with this patch, higher size requests will be marked as sync-idle
so that now 4K size process and 64K size processes will be on separate
service tree.

But this will work only if we were idling on service tree (on SSD). I
thought in SSD we will not idle even on service tree. But looks like
we have left a bug somewhere. Otherwise on NCQ SSD we will suffer
in terms of performance in this kind of setup. Especially if you
increase number of readers. I will do run your fio script on my NCQ SSD.

Or it is intentional that idle on service tree with hw_tag=1 but don't
idle with NCQ hard disk. That makes sense though. 

But looking at cfq_should_idle(), looks like we will always on a service
tree even on NCQ SSD even if cfq_cfqq_idle_window=0. I think if I run the
same test on NCQ SSD, now bigger size process should loose because we will
idle on sync-noidle service tree but not on sync-idle service tree.

> 
> > In case of SSDs with NCQ, we will not idle on any of the queues (either
> > sync or sync-noidle (seeky queues)). So w.r.t code, what behavior changes
> > if we mark a queue as seeky/non-seeky on SSD?
> >
> 
> I've not tested on NCQ SSD, but I think at worst it will not harm, and
> at best, it will provide similar fairness improvements when the queue
> of processes submitting requests grows above the available NCQ slots.
> 
> > IOW, looking at this patch, now any queue doing IO in smaller chunks than
> > 32K on SSD will be marked as seeky. How does that change the behavior in
> > terms of fairness for the queue?
> >
> Basically, we will have IOPS based fairness for small requests, and
> time based fairness for larger requests.
> 
> Thanks,
> Corrado
> 
> > Thanks
> > Vivek
> >
> >>
> >> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
> >> ---
> >>  block/cfq-iosched.c |    7 ++++++-
> >>  1 files changed, 6 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> >> index 806d30b..f27e535 100644
> >> --- a/block/cfq-iosched.c
> >> +++ b/block/cfq-iosched.c
> >> @@ -47,6 +47,7 @@ static const int cfq_hist_divisor = 4;
> >>  #define CFQ_SERVICE_SHIFT       12
> >>
> >>  #define CFQQ_SEEK_THR                (sector_t)(8 * 100)
> >> +#define CFQQ_SECT_THR_NONROT (sector_t)(2 * 32)
> >>  #define CFQQ_SEEKY(cfqq)     (hweight32(cfqq->seek_history) > 32/8)
> >>
> >>  #define RQ_CIC(rq)           \
> >> @@ -2958,6 +2959,7 @@ cfq_update_io_seektime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> >>                      struct request *rq)
> >>  {
> >>       sector_t sdist = 0;
> >> +     sector_t n_sec = blk_rq_sectors(rq);
> >>       if (cfqq->last_request_pos) {
> >>               if (cfqq->last_request_pos < blk_rq_pos(rq))
> >>                       sdist = blk_rq_pos(rq) - cfqq->last_request_pos;
> >> @@ -2966,7 +2968,10 @@ cfq_update_io_seektime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> >>       }
> >>
> >>       cfqq->seek_history <<= 1;
> >> -     cfqq->seek_history |= (sdist > CFQQ_SEEK_THR);
> >> +     if (blk_queue_nonrot(cfqd->queue))
> >> +             cfqq->seek_history |= (n_sec < CFQQ_SECT_THR_NONROT);
> >> +     else
> >> +             cfqq->seek_history |= (sdist > CFQQ_SEEK_THR);
> >>  }
> >>
> >>  /*
> >> --
> >> 1.6.4.4
> >


