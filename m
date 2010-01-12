Return-Path: <linux-kernel-owner+w=401wt.eu-S1753588Ab0ALIxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab0ALIxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 03:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138Ab0ALIxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 03:53:06 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:63703 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab0ALIxE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 03:53:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S6/NomZngxKRrVHSQ42qWISOlkhyP8CF+U1ywILy25HvzvEMcwy+4YG/Ghd9SbOtut
         C3DcqHqhK4a/KR3KNcEStJpcTxTGskfLvvsxyyoN8XI33c7oPJb4dz1BbJ6cJHfduPSQ
         pOdyHUvcMzwJrbnaFwnyh8CdSbTNYJFTCivZU=
MIME-Version: 1.0
In-Reply-To: <20100112014953.GA22606@sli10-desk.sh.intel.com>
References: <1263052757-23436-1-git-send-email-czoccolo@gmail.com>
	 <20100111014730.GA22362@sli10-desk.sh.intel.com>
	 <4e5e476b1001110646i20c2bcf4n51380853820c29d8@mail.gmail.com>
	 <20100112014953.GA22606@sli10-desk.sh.intel.com>
Date: Tue, 12 Jan 2010 09:52:59 +0100
Message-ID: <4e5e476b1001120052k7bb7396bsfc3eddf6ce28e6a5@mail.gmail.com>
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

Hi
On Tue, Jan 12, 2010 at 2:49 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> On Mon, Jan 11, 2010 at 10:46:23PM +0800, Corrado Zoccolo wrote:
>> Hi,
>> On Mon, Jan 11, 2010 at 2:47 AM, Shaohua Li <shaohua.li@intel.com> wrote:
>> > On Sat, Jan 09, 2010 at 11:59:17PM +0800, Corrado Zoccolo wrote:
>> >> Current seeky detection is based on average seek lenght.
>> >> This is suboptimal, since the average will not distinguish between:
>> >> * a process doing medium sized seeks
>> >> * a process doing some sequential requests interleaved with larger seeks
>> >> and even a medium seek can take lot of time, if the requested sector
>> >> happens to be behind the disk head in the rotation (50% probability).
>> >>
>> >> Therefore, we change the seeky queue detection to work as follows:
>> >> * each request can be classified as sequential if it is very close to
>> >>   the current head position, i.e. it is likely in the disk cache (disks
>> >>   usually read more data than requested, and put it in cache for
>> >>   subsequent reads). Otherwise, the request is classified as seeky.
>> >> * an history window of the last 32 requests is kept, storing the
>> >>   classification result.
>> >> * A queue is marked as seeky if more than 1/8 of the last 32 requests
>> >>   were seeky.
>> >>
>> >> This patch fixes a regression reported by Yanmin, on mmap 64k random
>> >> reads.
>> > Can we not count a big request (say the request data is >= 32k) as seeky
>> > regardless the seek distance? In this way we can also make a 64k random sync
>> > read not as seeky.
>> I think I understand what you are proposing, but I don't think request
>> size should
>> matter at all for rotational disk.
> randread a 32k bs  definitely has better throughput than a 4k bs. So the request
> size does matter. From iops point of view, 64k and 4k might not have difference
> in device, but from performance point of view, they have big difference.
Assume we have two queues, one with 64k requests, and an other with 4k requests,
and that our ideal disk will service them with the same IOPS 'v'.
Then, servicing for 100ms the first, and then for 100ms the second, we
will have, averaging on the
200ms period of the schedule:
first queue IOPS = v * 100/200 = v/2
second queue IOPS = v * 100/200 = v/2
Now the bandwidth will be simply IOPS * request size.
If instead, you service one request from one queue, and one from the
other (and keep switching for 200ms),
with v IOPS, each queue will obtain again v/2 IOPS, i.e. exactly the
same numbers.

But, instead, if we have a 2-disk RAID 0, with stripe >= 64k, and the
64k accesses are aligned (do not cross the stripe), we will have 50%
probability that the requests from the 2 queues are serviced in
parallel, thus increasing the total IOPS and bandwidth. This cannot
happen if you service for 100ms a single depth-1 seeky queue.

>
>> Usually, the disk firmware will load a big chunk of data in its cache even when
>> requested to read a single sector, and will provide following ones
>> from the cache
>> if you read them sequentially.
>>
>> Now, in CFQ, what we really mean by saying that a queue is seeky is that
>> waiting a bit in order to serve an other request from this queue doesn't
>> give any benefit w.r.t. switching to an other queue.
> If no idle, we might switch to a random 4k access or any kind of queues. Compared
> to continue big request access and switch to other queue with small block, no switching
> does give benefit.
CFQ in 2.6.33 works differently than it worked before.
Now, seeky queues have an aggregate time slice, and within this time
slice, you will switch
between seeky queues fairly. So it cannot happen that a seeky queue
loses its time slice.

>
>> So, if you read a single 64k block from disk and then seek, then you can service
>> any other request without losing bandwidth.
> But the 64k bs queue loses its slice, which might means device serves more 4k access.
> As a result, reduce bandwidth.
If both queues are backlogged and at the same priority, they will be
serviced fairly.
If one queue has large think time (or lower priority), the other will
be serviced more often.
>
>> Instead, if you are reading 4k, then the next ones (and so on up to 64k, as it
>> happens with mmap when you fault in a single page at a time), then it
>> is convenient
>> to wait for the next request, since it has 3/4 of changes to be
>> sequential, so be
>> serviced by cache.
>>
>> I'm currently testing a patch to consider request size in SSDs, instead.
>> In SSDs, the location of the request doesn't mean anything, but the
>> size is meaningful.
>> Therefore, submitting together many small requests from different
>> queues can improve
>> the overall performance.
> Agree.
>
> Thanks,
> Shaohua
>


Thanks,
Corrado
