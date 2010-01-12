Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340Ab0ALBuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab0ALBuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 20:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946Ab0ALBuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 20:50:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:29385 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab0ALBt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 20:49:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,259,1262592000"; 
   d="scan'208";a="483209113"
Date: Tue, 12 Jan 2010 09:49:53 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] cfq-iosched: rework seeky detection
Message-ID: <20100112014953.GA22606@sli10-desk.sh.intel.com>
References: <1263052757-23436-1-git-send-email-czoccolo@gmail.com>
 <20100111014730.GA22362@sli10-desk.sh.intel.com>
 <4e5e476b1001110646i20c2bcf4n51380853820c29d8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b1001110646i20c2bcf4n51380853820c29d8@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 10:46:23PM +0800, Corrado Zoccolo wrote:
> Hi,
> On Mon, Jan 11, 2010 at 2:47 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> > On Sat, Jan 09, 2010 at 11:59:17PM +0800, Corrado Zoccolo wrote:
> >> Current seeky detection is based on average seek lenght.
> >> This is suboptimal, since the average will not distinguish between:
> >> * a process doing medium sized seeks
> >> * a process doing some sequential requests interleaved with larger seeks
> >> and even a medium seek can take lot of time, if the requested sector
> >> happens to be behind the disk head in the rotation (50% probability).
> >>
> >> Therefore, we change the seeky queue detection to work as follows:
> >> * each request can be classified as sequential if it is very close to
> >>   the current head position, i.e. it is likely in the disk cache (disks
> >>   usually read more data than requested, and put it in cache for
> >>   subsequent reads). Otherwise, the request is classified as seeky.
> >> * an history window of the last 32 requests is kept, storing the
> >>   classification result.
> >> * A queue is marked as seeky if more than 1/8 of the last 32 requests
> >>   were seeky.
> >>
> >> This patch fixes a regression reported by Yanmin, on mmap 64k random
> >> reads.
> > Can we not count a big request (say the request data is >= 32k) as seeky
> > regardless the seek distance? In this way we can also make a 64k random sync
> > read not as seeky.
> I think I understand what you are proposing, but I don't think request
> size should
> matter at all for rotational disk.
randread a 32k bs  definitely has better throughput than a 4k bs. So the request
size does matter. From iops point of view, 64k and 4k might not have difference
in device, but from performance point of view, they have big difference.

> Usually, the disk firmware will load a big chunk of data in its cache even when
> requested to read a single sector, and will provide following ones
> from the cache
> if you read them sequentially.
> 
> Now, in CFQ, what we really mean by saying that a queue is seeky is that
> waiting a bit in order to serve an other request from this queue doesn't
> give any benefit w.r.t. switching to an other queue.
If no idle, we might switch to a random 4k access or any kind of queues. Compared
to continue big request access and switch to other queue with small block, no switching
does give benefit.

> So, if you read a single 64k block from disk and then seek, then you can service
> any other request without losing bandwidth.
But the 64k bs queue loses its slice, which might means device serves more 4k access.
As a result, reduce bandwidth.

> Instead, if you are reading 4k, then the next ones (and so on up to 64k, as it
> happens with mmap when you fault in a single page at a time), then it
> is convenient
> to wait for the next request, since it has 3/4 of changes to be
> sequential, so be
> serviced by cache.
> 
> I'm currently testing a patch to consider request size in SSDs, instead.
> In SSDs, the location of the request doesn't mean anything, but the
> size is meaningful.
> Therefore, submitting together many small requests from different
> queues can improve
> the overall performance.
Agree.

Thanks,
Shaohua
