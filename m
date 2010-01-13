Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852Ab0AMIJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab0AMIJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 03:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559Ab0AMIJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 03:09:30 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:58575 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab0AMIJ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 03:09:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uYDz7MeDgtNPZn1c9RycJKbol1O4vnvI5dHepE67Z2UaE647pVnlG1x4Ydu5zSYAeH
         NCExE4XQTSxqPx/3u+ZE5+YCx2R+7nntDk0GhNy9AI5LD1vW2wiH0d+KgLV+ucOyAdQt
         nIr15mrHk2wFO1pCNFT6rHMjSxMAofGU4allU=
MIME-Version: 1.0
In-Reply-To: <20100113080045.GC10492@sli10-desk.sh.intel.com>
References: <1263052757-23436-1-git-send-email-czoccolo@gmail.com>
	 <20100111014730.GA22362@sli10-desk.sh.intel.com>
	 <4e5e476b1001110646i20c2bcf4n51380853820c29d8@mail.gmail.com>
	 <20100112014953.GA22606@sli10-desk.sh.intel.com>
	 <4e5e476b1001120052k7bb7396bsfc3eddf6ce28e6a5@mail.gmail.com>
	 <20100113034557.GA26135@sli10-desk.sh.intel.com>
	 <4e5e476b1001122309k66e5dd74h4dfdaadf15c3cfad@mail.gmail.com>
	 <20100113080045.GC10492@sli10-desk.sh.intel.com>
Date: Wed, 13 Jan 2010 09:09:26 +0100
Message-ID: <4e5e476b1001130009w1f3fd8aq609eab0cd3c790ab@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: rework seeky detection
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 9:00 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> On Wed, Jan 13, 2010 at 03:09:31PM +0800, Corrado Zoccolo wrote:
>> On Wed, Jan 13, 2010 at 4:45 AM, Shaohua Li <shaohua.li@intel.com> wrote:
>> > On Tue, Jan 12, 2010 at 04:52:59PM +0800, Corrado Zoccolo wrote:
>> >> Hi
>> >> On Tue, Jan 12, 2010 at 2:49 AM, Shaohua Li <shaohua.li@intel.com> wrote:
>> >> > On Mon, Jan 11, 2010 at 10:46:23PM +0800, Corrado Zoccolo wrote:
>> >> >> Hi,
>> >> >> On Mon, Jan 11, 2010 at 2:47 AM, Shaohua Li <shaohua.li@intel.com> wrote:
>> >> >> > On Sat, Jan 09, 2010 at 11:59:17PM +0800, Corrado Zoccolo wrote:
>> >> >> >> Current seeky detection is based on average seek lenght.
>> >> >> >> This is suboptimal, since the average will not distinguish between:
>> >> >> >> * a process doing medium sized seeks
>> >> >> >> * a process doing some sequential requests interleaved with larger seeks
>> >> >> >> and even a medium seek can take lot of time, if the requested sector
>> >> >> >> happens to be behind the disk head in the rotation (50% probability).
>> >> >> >>
>> >> >> >> Therefore, we change the seeky queue detection to work as follows:
>> >> >> >> * each request can be classified as sequential if it is very close to
>> >> >> >>   the current head position, i.e. it is likely in the disk cache (disks
>> >> >> >>   usually read more data than requested, and put it in cache for
>> >> >> >>   subsequent reads). Otherwise, the request is classified as seeky.
>> >> >> >> * an history window of the last 32 requests is kept, storing the
>> >> >> >>   classification result.
>> >> >> >> * A queue is marked as seeky if more than 1/8 of the last 32 requests
>> >> >> >>   were seeky.
>> >> >> >>
>> >> >> >> This patch fixes a regression reported by Yanmin, on mmap 64k random
>> >> >> >> reads.
>> >> >> > Can we not count a big request (say the request data is >= 32k) as seeky
>> >> >> > regardless the seek distance? In this way we can also make a 64k random sync
>> >> >> > read not as seeky.
>> >> >> I think I understand what you are proposing, but I don't think request
>> >> >> size should
>> >> >> matter at all for rotational disk.
>> >> > randread a 32k bs  definitely has better throughput than a 4k bs. So the request
>> >> > size does matter. From iops point of view, 64k and 4k might not have difference
>> >> > in device, but from performance point of view, they have big difference.
>> >> Assume we have two queues, one with 64k requests, and an other with 4k requests,
>> >> and that our ideal disk will service them with the same IOPS 'v'.
>> >> Then, servicing for 100ms the first, and then for 100ms the second, we
>> >> will have, averaging on the
>> >> 200ms period of the schedule:
>> >> first queue IOPS = v * 100/200 = v/2
>> >> second queue IOPS = v * 100/200 = v/2
>> >> Now the bandwidth will be simply IOPS * request size.
>> >> If instead, you service one request from one queue, and one from the
>> >> other (and keep switching for 200ms),
>> >> with v IOPS, each queue will obtain again v/2 IOPS, i.e. exactly the
>> >> same numbers.
>> >>
>> >> But, instead, if we have a 2-disk RAID 0, with stripe >= 64k, and the
>> >> 64k accesses are aligned (do not cross the stripe), we will have 50%
>> >> probability that the requests from the 2 queues are serviced in
>> >> parallel, thus increasing the total IOPS and bandwidth. This cannot
>> >> happen if you service for 100ms a single depth-1 seeky queue.
>> >>
>> >> >
>> >> >> Usually, the disk firmware will load a big chunk of data in its cache even when
>> >> >> requested to read a single sector, and will provide following ones
>> >> >> from the cache
>> >> >> if you read them sequentially.
>> >> >>
>> >> >> Now, in CFQ, what we really mean by saying that a queue is seeky is that
>> >> >> waiting a bit in order to serve an other request from this queue doesn't
>> >> >> give any benefit w.r.t. switching to an other queue.
>> >> > If no idle, we might switch to a random 4k access or any kind of queues. Compared
>> >> > to continue big request access and switch to other queue with small block, no switching
>> >> > does give benefit.
>> >> CFQ in 2.6.33 works differently than it worked before.
>> >> Now, seeky queues have an aggregate time slice, and within this time
>> >> slice, you will switch
>> >> between seeky queues fairly. So it cannot happen that a seeky queue
>> >> loses its time slice.
>> > Sorry for my ignorance here, from the code, I know we have a forced slice for a domain and
>> > service tree, but for a queue, it appears we haven't an aggregate time slice.
>> By aggregate time slice for seeky queues, I mean the time slice
>> assigned to the sync-noidle service tree.
>>
>> > From my understanding,
>> > we don't add a queue's remaining slice to its next run, and queue might not even init its slice if
>> > it's non-timedout preempted before it finishes its first request, which is normal for a seeky
>> > queue with a ncq device.
>>
>> Exactly for this reason, a seeky queue has no private time slice (it
>> is meaningless, since we want multiple seeky queues working in
>> parallel), but it participates fairly to the service tree's slice. The
>> service tree's slice is computed proportionally to the number of seeky
>> queues w.r.t. all queues in the domain, so you also have that seeky
>> queues are serviced fairly w.r.t. other queues as well.
> Ok, I got your point. An off topic issue:
> For a queue with iodepth 1 and a queue with iodepth 32, looks this mechanism can't
> guanantee fairness. the queue with big iodepth can submit more requests
> in every switch.

Yes. In fact, a queue that reaches large I/O depths will be marked as
SYNC_IDLE, and have its dedicated time slice. Your testcase about
cfq_quantum falls in this category.

>
> Thanks,
> Shaohua
>

Thanks,
Corrado
