Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab0CDW1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 17:27:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119Ab0CDW1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 17:27:35 -0500
Date: Thu, 4 Mar 2010 17:27:26 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] cfq-iosched: rethink seeky detection for SSDs
Message-ID: <20100304222726.GA3577@redhat.com>
References: <1267296340-3820-1-git-send-email-czoccolo@gmail.com> <1267296340-3820-2-git-send-email-czoccolo@gmail.com> <1267296340-3820-3-git-send-email-czoccolo@gmail.com> <20100301142553.GB8878@redhat.com> <4e5e476b1003031147n6a53b646k418483a93013d77c@mail.gmail.com> <20100303232832.GD5230@redhat.com> <4e5e476b1003041234t21ed2facxe4dbeccec79b2ba6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b1003041234t21ed2facxe4dbeccec79b2ba6@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 09:34:51PM +0100, Corrado Zoccolo wrote:
> Hi Vivek,
> On Thu, Mar 4, 2010 at 12:28 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, Mar 03, 2010 at 08:47:31PM +0100, Corrado Zoccolo wrote:
> >> Hi Vivek,
> >> On Mon, Mar 1, 2010 at 3:25 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > On Sat, Feb 27, 2010 at 07:45:40PM +0100, Corrado Zoccolo wrote:
> >> >> CFQ currently applies the same logic of detecting seeky queues and
> >> >> grouping them together for rotational disks as well as SSDs.
> >> >> For SSDs, the time to complete a request doesn't depend on the
> >> >> request location, but only on the size.
> >> >> This patch therefore changes the criterion to group queues by
> >> >> request size in case of SSDs, in order to achieve better fairness.
> >> >
> >> > Hi Corrado,
> >> >
> >> > Can you give some numbers regarding how are you measuring fairness and
> >> > how did you decide that we achieve better fairness?
> >> >
> >> Please, see the attached fio script. It benchmarks pairs of processes
> >> performing direct random I/O.
> >> One is always fixed at bs=4k , while I vary the other from 8K to 64K
> >> test00: (g=0): rw=randread, bs=8K-8K/8K-8K, ioengine=sync, iodepth=1
> >> test01: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
> >> test10: (g=1): rw=randread, bs=16K-16K/16K-16K, ioengine=sync, iodepth=1
> >> test11: (g=1): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
> >> test20: (g=2): rw=randread, bs=32K-32K/32K-32K, ioengine=sync, iodepth=1
> >> test21: (g=2): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
> >> test30: (g=3): rw=randread, bs=64K-64K/64K-64K, ioengine=sync, iodepth=1
> >> test31: (g=3): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
> >>
> >> With unpatched cfq (2.6.33), on a flash card (non-ncq), after running
> >> a fio script with high number of parallel readers to make sure ncq
> >> detection is stabilized, I get the following:
> >> Run status group 0 (all jobs):
> >>    READ: io=21528KiB, aggrb=4406KiB/s, minb=1485KiB/s, maxb=2922KiB/s,
> >> mint=5001msec, maxt=5003msec
> >>
> >> Run status group 1 (all jobs):
> >>    READ: io=31524KiB, aggrb=6452KiB/s, minb=1327KiB/s, maxb=5126KiB/s,
> >> mint=5002msec, maxt=5003msec
> >>
> >> Run status group 2 (all jobs):
> >>    READ: io=46544KiB, aggrb=9524KiB/s, minb=1031KiB/s, maxb=8493KiB/s,
> >> mint=5001msec, maxt=5004msec
> >>
> >> Run status group 3 (all jobs):
> >>    READ: io=64712KiB, aggrb=13242KiB/s, minb=761KiB/s,
> >> maxb=12486KiB/s, mint=5002msec, maxt=5004msec
> >>
> >> As you can see from minb, the process with smallest I/O size is
> >> penalized (the fact is that being both marked as noidle, they both end
> >> up in the noidle tree, where they are serviced round robin, so they
> >> get fairness in term of IOPS, but bandwidth varies a lot.
> >>
> >> With my patches in place, I get:
> >> Run status group 0 (all jobs):
> >>    READ: io=21544KiB, aggrb=4409KiB/s, minb=1511KiB/s, maxb=2898KiB/s,
> >> mint=5002msec, maxt=5003msec
> >>
> >> Run status group 1 (all jobs):
> >>    READ: io=32000KiB, aggrb=6549KiB/s, minb=1277KiB/s, maxb=5274KiB/s,
> >> mint=5001msec, maxt=5003msec
> >>
> >> Run status group 2 (all jobs):
> >>    READ: io=39444KiB, aggrb=8073KiB/s, minb=1576KiB/s, maxb=6498KiB/s,
> >> mint=5002msec, maxt=5003msec
> >>
> >> Run status group 3 (all jobs):
> >>    READ: io=49180KiB, aggrb=10059KiB/s, minb=1512KiB/s,
> >> maxb=8548KiB/s, mint=5001msec, maxt=5006msec
> >>
> >> The process doing smaller requests is now not penalized by the fact
> >> that it is run concurrently with the other one, and the other still
> >> benefits from larger requests because it uses better its time slice.
> >>
> >
> > Hi Corrado,
> >
> > I ran your fio script on my SSD which supports NCQ. In my case both the
> > processes lose.
> >
> > Vanilla kernel (2.6.33)
> > =======================
> > Run status group 0 (all jobs):
> >   READ: io=258MB, aggrb=52,903KB/s, minb=18,058KB/s, maxb=36,114KB/s,
> > mint=5001msec, maxt=5001msec
> >
> > Run status group 1 (all jobs):
> >   READ: io=382MB, aggrb=78,301KB/s, minb=16,037KB/s, maxb=64,143KB/s,
> > mint=5001msec, maxt=5001msec
> >
> > Run status group 2 (all jobs):
> >   READ: io=560MB, aggrb=112MB/s, minb=13,052KB/s, maxb=102MB/s,
> > mint=5001msec, maxt=5001msec
> >
> > Run status group 3 (all jobs):
> >   READ: io=774MB, aggrb=155MB/s, minb=9,595KB/s, maxb=149MB/s,
> > mint=5001msec, maxt=5001msec
> >
> > With two seek patches applied
> > =============================
> > Run status group 0 (all jobs):
> >   READ: io=260MB, aggrb=53,148KB/s, minb=18,140KB/s, maxb=36,283KB/s,
> > mint=5001msec, maxt=5001msec
> >
> > Run status group 1 (all jobs):
> >   READ: io=383MB, aggrb=78,484KB/s, minb=16,073KB/s, maxb=64,294KB/s,
> > mint=5001msec, maxt=5001msec
> >
> > Run status group 2 (all jobs):
> >   READ: io=359MB, aggrb=73,534KB/s, minb=8,367KB/s, maxb=66,931KB/s,
> > mint=5001msec, maxt=5001msec
> >
> > Run status group 3 (all jobs):
> >   READ: io=556MB, aggrb=111MB/s, minb=6,852KB/s, maxb=107MB/s,
> > mint=5001msec, maxt=5001msec
> >
> > Note, how overall BW suffers for group 2 and group 3. This needs some
> > debugging why it is happening. I guess we are idling on sync-noidle
> > tree and not idling on sync-idle tree, probably that's why bigger request
> > size process can't get enough IO pushed. But then smaller request size
> > process should have got more IO done but that also does not seem to
> > be happening.
> 
> I think this is a preexisting bug. You can probably trigger it in
> vanilla 2.6.33 by having one process doing random and an other doing
> sequential reads.
> I think the issue is:
> * cfq_should_idle returns true for the last queue on a tree, even for NCQ SSDs:

you are right. The way cfq_should_idle() is written, it will return true
for bothe sync-idle and sync-noidle trees. With your patch two random
readers go onto different service trees and now we start driving queue
depth 1 because of follwing.

        if (timer_pending(&cfqd->idle_slice_timer) ||
            (cfqq->dispatched && cfq_should_idle(cfqd, cfqq))) {
                cfqq = NULL;
                goto keep_queue;
        }


I tested following patch and now throughput is almost back at the same levels
as wihtout your patch.

---
 block/cfq-iosched.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 40840da..296aa23 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1788,9 +1788,12 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	if (prio == IDLE_WORKLOAD)
 		return false;
 
+	/* Don't idle on NCQ SSDs */
+	if (blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag)
+		return false;
+
 	/* We do for queues that were marked with idle window flag. */
-	if (cfq_cfqq_idle_window(cfqq) &&
-	   !(blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag))
+	if (cfq_cfqq_idle_window(cfqq))
 		return true;
 
 	/*
-- 
1.6.2.5


Now I am wondering what are the side affects of above change.

One advantage of idling on service tree even on NCQ SSD is that READS get
more protection from WRITES. Especially if there are SSDs which implement
NCQ but really suck at WRITE speed or don't implement parallel IO
channels.

I see cfq_should_idle() being used at four places.

- cfq_select_queue()
                if (cfqq->cfqg->nr_cfqq == 1 && RB_EMPTY_ROOT(&cfqq->sort_list)
                    && cfqq->dispatched && cfq_should_idle(cfqd, cfqq)) {
                        cfqq = NULL;
                        goto keep_queue;
		}

This is for fairness in group scheduling. I think that impact here should
not be much because this condition is primarily hit on media where we idle
on the queue.

On NCQ SSD, I don't think we get fairness in group scheduling much until
and unless a group is generating enough traffic to keep the request queue
full.

- cfq_select_queue()
            (cfqq->dispatched && cfq_should_idle(cfqd, cfqq))) {
                cfqq = NULL;

Should we really wait for a dispatched request to complete on NCQ SSD?
On SSD with parallel channel, I think this will reduce throughput?

- cfq_may_dispatch()

        /*
         * Drain async requests before we start sync IO
         */
        if (cfq_should_idle(cfqd, cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])
                return false;

If NCQ SSD is implementing parallel IO channels, probably there is no need
to clear out WRITES before we start sync IO?

- cfq_arm_slice_timer()

	       if (!cfqd->cfq_slice_idle || !cfq_should_idle(cfqd, cfqq))
                return;

cfq_arm_slice_timer()  already check for NCQ SSD and does not arm timer
so this function should remain unaffected with this change.

So the question is, should we wait on service tree on an NCQ SSD or not?

Secondly, your patch of determining cfqq seeky nature based on request
size on SSD, helps only on non NCQ SSD.

Thanks
Vivek
