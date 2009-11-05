Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbZKEI1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbZKEI1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 03:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbZKEI1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 03:27:30 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:58433 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbZKEI13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 03:27:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=v59UXOzM87cibp2VVt0ADdoqYXl0P+q8oVGarmEY1gCIgf+zlMKzWlOXFGUjW+Z3tc
         xIdrij/kKp745phNqyyZPtvm44AaKRWEMZN94Jst9cOsGTgxltA11p5AWhfBWZtolRvp
         oto6Imy0995FoaIeEb1FEZ4v7vxAHQuGJC+9k=
MIME-Version: 1.0
In-Reply-To: <20091104232216.GP2870@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
	 <1257291837-6246-3-git-send-email-vgoyal@redhat.com>
	 <4e5e476b0911041318w68bd774qf110d1abd7f946e4@mail.gmail.com>
	 <20091104232216.GP2870@redhat.com>
Date: Thu, 5 Nov 2009 09:27:34 +0100
Message-ID: <4e5e476b0911050027w97cb8b4xd1d148d80de39e3@mail.gmail.com>
Subject: Re: [PATCH 02/20] blkio: Change CFQ to use CFS like queue time stamps
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
let me answer all your questions in a single mail.

On Thu, Nov 5, 2009 at 12:22 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi Corrado,
>
> Had one more question. Now with dynamic slice length (reduce slice length
> to meet target latency), don't wee see reduced throughput on rotational
> media with sequential workload?
>
Yes. This is the main reason for disabling dynamic slice length when
low_latency is not set. In this way, on servers where low latency is
not a must (but still desirable), this feature can be disabled, while
the others, that have positive impact on throughput, will not be
disabled.

> I saw some you posted numbers for SSD. Do you have some numbers for
> rotational media also?
Yes. I posted it in the first RFC for this patch, outside the series:
http://lkml.org/lkml/2009/9/3/87

The other patches in the series do not affect sequential bandwidth,
but can improve random read BW in case of NCQ hardware, regardless of
it being rotational, SSD, or SAN.

> I am looking at your patchset and trying to understand how have you
> ensured fairness for different priority level queues.
>
> Following seems to be the key piece of code which determines the slice
> length of the queue dynamically.
>
>
> static inline void
> cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> { [snipped code] }
>
> A question.
>
> - expect_latency seems to be being calculated based on based slice lenth
>  for sync queues (100ms). This will give right number only if all the
>  queues in the system were of prio 4. What if there are 3 prio 0 queues.
>  They will/should get 180ms slice each resulting in max latency of 540 ms
>  but we will be calculating expect_latency to = 100 * 3 =300 ms which is
>  less than cfq_target_latency and we will not adjust slice length?
>
Yes. Those are soft latencies, so we don't *guarantee* 300ms. On an
average system, where the average slice length is 100ms, we will go
pretty close (but since CFQ doesn't count the first seek in the time
slice, we can still be some tenths of ms off), but if you have a
different distribution of priorities, then this will not be
guaranteed.

> - With "no-idle" group, who benefits? As I said, all these optimizations
>  seems to be for low latency. In that case user will set "low_latency"
>  tunable in CFQ. If that's the case, then we will anyway enable idling
>  random seeky processes having think time less than 8ms. So they get
>  their fair share.
My patch changes the meaning for low_latency. As we discussed some
months ago, I always thought that the solution of idling for seeky
processes was sub-optimal. With the new code, regardless of
low_latency settings, we won't idle between 'no-idle' queues. We will
idle only at the end of the no-idle tree, if we still have not reached
workload_expires. This provides fairness between 'no-idle' and normal
sync queues.
>
>  I guess this will provide benefit if user has not set "low_latency" and
>  in that case we will not enable idle on random seeky readers and we will
>  gain in terms of throughput on NCQ hardware because we dispatch from
>  other no-idle queues and then idle on the no-idle group.
It will improve both latency and bandwidth, and as I said, it is now
not limited to just low_latency not set. After my patch series,
low_latency will control just 2 things:
* the dynamic timeslice adaption
* the dynamic threshold for number of writes dispatched

Thanks
Corrado
