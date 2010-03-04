Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab0CDUez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 15:34:55 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:55448 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009Ab0CDUex convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 15:34:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RqMivdexWAqA4M2uvQGqtSYB2oAb1Yd4925O8HolzbSwPtFoVS0Xaxoc4bWUfZjk82
         sOq2FtuNAdUXGrKX9f9dGGcsEA1KHAzHAfNOvc0MjU+h87qVe7qrriHV18pJNV7UW7f7
         vD/SUIwtFZMN6JXCUhQpsrcf41A6P5HO5ejm4=
MIME-Version: 1.0
In-Reply-To: <20100303232832.GD5230@redhat.com>
References: <1267296340-3820-1-git-send-email-czoccolo@gmail.com>
	 <1267296340-3820-2-git-send-email-czoccolo@gmail.com>
	 <1267296340-3820-3-git-send-email-czoccolo@gmail.com>
	 <20100301142553.GB8878@redhat.com>
	 <4e5e476b1003031147n6a53b646k418483a93013d77c@mail.gmail.com>
	 <20100303232832.GD5230@redhat.com>
Date: Thu, 4 Mar 2010 21:34:51 +0100
Message-ID: <4e5e476b1003041234t21ed2facxe4dbeccec79b2ba6@mail.gmail.com>
Subject: Re: [PATCH 2/2] cfq-iosched: rethink seeky detection for SSDs
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
On Thu, Mar 4, 2010 at 12:28 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Mar 03, 2010 at 08:47:31PM +0100, Corrado Zoccolo wrote:
>> Hi Vivek,
>> On Mon, Mar 1, 2010 at 3:25 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Sat, Feb 27, 2010 at 07:45:40PM +0100, Corrado Zoccolo wrote:
>> >> CFQ currently applies the same logic of detecting seeky queues and
>> >> grouping them together for rotational disks as well as SSDs.
>> >> For SSDs, the time to complete a request doesn't depend on the
>> >> request location, but only on the size.
>> >> This patch therefore changes the criterion to group queues by
>> >> request size in case of SSDs, in order to achieve better fairness.
>> >
>> > Hi Corrado,
>> >
>> > Can you give some numbers regarding how are you measuring fairness and
>> > how did you decide that we achieve better fairness?
>> >
>> Please, see the attached fio script. It benchmarks pairs of processes
>> performing direct random I/O.
>> One is always fixed at bs=4k , while I vary the other from 8K to 64K
>> test00: (g=0): rw=randread, bs=8K-8K/8K-8K, ioengine=sync, iodepth=1
>> test01: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
>> test10: (g=1): rw=randread, bs=16K-16K/16K-16K, ioengine=sync, iodepth=1
>> test11: (g=1): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
>> test20: (g=2): rw=randread, bs=32K-32K/32K-32K, ioengine=sync, iodepth=1
>> test21: (g=2): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
>> test30: (g=3): rw=randread, bs=64K-64K/64K-64K, ioengine=sync, iodepth=1
>> test31: (g=3): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
>>
>> With unpatched cfq (2.6.33), on a flash card (non-ncq), after running
>> a fio script with high number of parallel readers to make sure ncq
>> detection is stabilized, I get the following:
>> Run status group 0 (all jobs):
>>    READ: io=21528KiB, aggrb=4406KiB/s, minb=1485KiB/s, maxb=2922KiB/s,
>> mint=5001msec, maxt=5003msec
>>
>> Run status group 1 (all jobs):
>>    READ: io=31524KiB, aggrb=6452KiB/s, minb=1327KiB/s, maxb=5126KiB/s,
>> mint=5002msec, maxt=5003msec
>>
>> Run status group 2 (all jobs):
>>    READ: io=46544KiB, aggrb=9524KiB/s, minb=1031KiB/s, maxb=8493KiB/s,
>> mint=5001msec, maxt=5004msec
>>
>> Run status group 3 (all jobs):
>>    READ: io=64712KiB, aggrb=13242KiB/s, minb=761KiB/s,
>> maxb=12486KiB/s, mint=5002msec, maxt=5004msec
>>
>> As you can see from minb, the process with smallest I/O size is
>> penalized (the fact is that being both marked as noidle, they both end
>> up in the noidle tree, where they are serviced round robin, so they
>> get fairness in term of IOPS, but bandwidth varies a lot.
>>
>> With my patches in place, I get:
>> Run status group 0 (all jobs):
>>    READ: io=21544KiB, aggrb=4409KiB/s, minb=1511KiB/s, maxb=2898KiB/s,
>> mint=5002msec, maxt=5003msec
>>
>> Run status group 1 (all jobs):
>>    READ: io=32000KiB, aggrb=6549KiB/s, minb=1277KiB/s, maxb=5274KiB/s,
>> mint=5001msec, maxt=5003msec
>>
>> Run status group 2 (all jobs):
>>    READ: io=39444KiB, aggrb=8073KiB/s, minb=1576KiB/s, maxb=6498KiB/s,
>> mint=5002msec, maxt=5003msec
>>
>> Run status group 3 (all jobs):
>>    READ: io=49180KiB, aggrb=10059KiB/s, minb=1512KiB/s,
>> maxb=8548KiB/s, mint=5001msec, maxt=5006msec
>>
>> The process doing smaller requests is now not penalized by the fact
>> that it is run concurrently with the other one, and the other still
>> benefits from larger requests because it uses better its time slice.
>>
>
> Hi Corrado,
>
> I ran your fio script on my SSD which supports NCQ. In my case both the
> processes lose.
>
> Vanilla kernel (2.6.33)
> =======================
> Run status group 0 (all jobs):
>   READ: io=258MB, aggrb=52,903KB/s, minb=18,058KB/s, maxb=36,114KB/s,
> mint=5001msec, maxt=5001msec
>
> Run status group 1 (all jobs):
>   READ: io=382MB, aggrb=78,301KB/s, minb=16,037KB/s, maxb=64,143KB/s,
> mint=5001msec, maxt=5001msec
>
> Run status group 2 (all jobs):
>   READ: io=560MB, aggrb=112MB/s, minb=13,052KB/s, maxb=102MB/s,
> mint=5001msec, maxt=5001msec
>
> Run status group 3 (all jobs):
>   READ: io=774MB, aggrb=155MB/s, minb=9,595KB/s, maxb=149MB/s,
> mint=5001msec, maxt=5001msec
>
> With two seek patches applied
> =============================
> Run status group 0 (all jobs):
>   READ: io=260MB, aggrb=53,148KB/s, minb=18,140KB/s, maxb=36,283KB/s,
> mint=5001msec, maxt=5001msec
>
> Run status group 1 (all jobs):
>   READ: io=383MB, aggrb=78,484KB/s, minb=16,073KB/s, maxb=64,294KB/s,
> mint=5001msec, maxt=5001msec
>
> Run status group 2 (all jobs):
>   READ: io=359MB, aggrb=73,534KB/s, minb=8,367KB/s, maxb=66,931KB/s,
> mint=5001msec, maxt=5001msec
>
> Run status group 3 (all jobs):
>   READ: io=556MB, aggrb=111MB/s, minb=6,852KB/s, maxb=107MB/s,
> mint=5001msec, maxt=5001msec
>
> Note, how overall BW suffers for group 2 and group 3. This needs some
> debugging why it is happening. I guess we are idling on sync-noidle
> tree and not idling on sync-idle tree, probably that's why bigger request
> size process can't get enough IO pushed. But then smaller request size
> process should have got more IO done but that also does not seem to
> be happening.

I think this is a preexisting bug. You can probably trigger it in
vanilla 2.6.33 by having one process doing random and an other doing
sequential reads.
I think the issue is:
* cfq_should_idle returns true for the last queue on a tree, even for NCQ SSDs:

static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
{
 	enum wl_prio_t prio = cfqq_prio(cfqq);
        struct cfq_rb_root *service_tree = cfqq->service_tree;

        BUG_ON(!service_tree);
	BUG_ON(!service_tree->count);

	/* We never do for idle class queues. */
        if (prio == IDLE_WORKLOAD)
                return false;

	/* We do for queues that were marked with idle window flag. */
	if (cfq_cfqq_idle_window(cfqq) &&
           !(blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag))
		return true;

        /*
         * Otherwise, we do only if they are the last ones
         * in their service tree.
         */
        return service_tree->count == 1 && cfq_cfqq_sync(cfqq);
}

* Even if we never activate a timer, we wait for request completion by
keeping a queue that has requests in flight, when cfq_should_idle
returns true (in two places):
        /*
         * The active queue has run out of time, expire it and select
new.
         */
        if (cfq_slice_used(cfqq) && !cfq_cfqq_must_dispatch(cfqq)) {
                /*
                 * If slice had not expired at the completion of last
request
                 * we might not have turned on wait_busy flag. Don't
expire
                 * the queue yet. Allow the group to get backlogged.
                 *
                 * The very fact that we have used the slice, that
means we
                 * have been idling all along on this queue and it
should be
                 * ok to wait for this request to complete.
                 */
                if (cfqq->cfqg->nr_cfqq == 1 && RB_EMPTY_ROOT(&cfqq->sort_list)
                    && cfqq->dispatched && cfq_should_idle(cfqd, cfqq)) {
			cfqq = NULL;
                        goto keep_queue;
                } else
 	                goto expire;
        }

        /*
         * No requests pending. If the active queue still has requests
in
         * flight or is idling for a new request, allow either of
these
         * conditions to happen (or time out) before selecting a new
queue.
         */
        if (timer_pending(&cfqd->idle_slice_timer) ||
            (cfqq->dispatched && cfq_should_idle(cfqd, cfqq))) {
                cfqq = NULL;
                goto keep_queue;
        }

Can you change cfq_should_idle to always return false for NCQ SSDs and retest?

Thanks
Corrado

>
> Both small request size and big request size processes are losing.
>
> Thanks
> Vivek
>
>> > In case of SSDs with NCQ, we will not idle on any of the queues (either
>> > sync or sync-noidle (seeky queues)). So w.r.t code, what behavior changes
>> > if we mark a queue as seeky/non-seeky on SSD?
>> >
>>
>> I've not tested on NCQ SSD, but I think at worst it will not harm, and
>> at best, it will provide similar fairness improvements when the queue
>> of processes submitting requests grows above the available NCQ slots.
>>
>> > IOW, looking at this patch, now any queue doing IO in smaller chunks than
>> > 32K on SSD will be marked as seeky. How does that change the behavior in
>> > terms of fairness for the queue?
>> >
>> Basically, we will have IOPS based fairness for small requests, and
>> time based fairness for larger requests.
>>
>> Thanks,
>> Corrado
>>
>> > Thanks
>> > Vivek
>> >
>> >>
>> >> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
>> >> ---
>> >>  block/cfq-iosched.c |    7 ++++++-
>> >>  1 files changed, 6 insertions(+), 1 deletions(-)
>> >>
>> >> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> >> index 806d30b..f27e535 100644
>> >> --- a/block/cfq-iosched.c
>> >> +++ b/block/cfq-iosched.c
>> >> @@ -47,6 +47,7 @@ static const int cfq_hist_divisor = 4;
>> >>  #define CFQ_SERVICE_SHIFT       12
>> >>
>> >>  #define CFQQ_SEEK_THR                (sector_t)(8 * 100)
>> >> +#define CFQQ_SECT_THR_NONROT (sector_t)(2 * 32)
>> >>  #define CFQQ_SEEKY(cfqq)     (hweight32(cfqq->seek_history) > 32/8)
>> >>
>> >>  #define RQ_CIC(rq)           \
>> >> @@ -2958,6 +2959,7 @@ cfq_update_io_seektime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>> >>                      struct request *rq)
>> >>  {
>> >>       sector_t sdist = 0;
>> >> +     sector_t n_sec = blk_rq_sectors(rq);
>> >>       if (cfqq->last_request_pos) {
>> >>               if (cfqq->last_request_pos < blk_rq_pos(rq))
>> >>                       sdist = blk_rq_pos(rq) - cfqq->last_request_pos;
>> >> @@ -2966,7 +2968,10 @@ cfq_update_io_seektime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>> >>       }
>> >>
>> >>       cfqq->seek_history <<= 1;
>> >> -     cfqq->seek_history |= (sdist > CFQQ_SEEK_THR);
>> >> +     if (blk_queue_nonrot(cfqd->queue))
>> >> +             cfqq->seek_history |= (n_sec < CFQQ_SECT_THR_NONROT);
>> >> +     else
>> >> +             cfqq->seek_history |= (sdist > CFQQ_SEEK_THR);
>> >>  }
>> >>
>> >>  /*
>> >> --
>> >> 1.6.4.4
>> >
>
>
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
