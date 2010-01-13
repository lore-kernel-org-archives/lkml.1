Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864Ab0AMUTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab0AMUTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 15:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269Ab0AMUTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 15:19:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab0AMUTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 15:19:33 -0500
Date: Wed, 13 Jan 2010 15:19:13 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] cfq-iosched: rework seeky detection
Message-ID: <20100113201913.GE6123@redhat.com>
References: <1263052757-23436-1-git-send-email-czoccolo@gmail.com> <20100112191257.GE3065@redhat.com> <4e5e476b1001121205u4fd487b7o2ee6dd42c8740955@mail.gmail.com> <20100112223638.GH3065@redhat.com> <4e5e476b1001121517y5ebdd6ebt7ade0b4ac068655b@mail.gmail.com> <4e5e476b1001130005p4acfdd55na387f925ad6078f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b1001130005p4acfdd55na387f925ad6078f3@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 09:05:21AM +0100, Corrado Zoccolo wrote:
> On Wed, Jan 13, 2010 at 12:17 AM, Corrado Zoccolo <czoccolo@gmail.com> wrote:
> > On Tue, Jan 12, 2010 at 11:36 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >>> The fact is, can we reliably determine which of those two setups we
> >>> have from cfq?
> >>
> >> I have no idea at this point of time but it looks like determining this
> >> will help.
> >>
> >> May be something like keep a track of number of processes on "sync-noidle"
> >> tree and average read times when sync-noidle tree is being served. Over a
> >> period of time we need to monitor what's the number of processes
> >> (threshold), after which average read time goes up. For sync-noidle we can
> >> then drive "queue_depth=nr_thrshold" and once queue depth reaches that,
> >> then idle on the process. So for single spindle, I guess tipping point
> >> will be 2 processes and we can idle on sync-noidle process. For more
> >> spindles, tipping point will be higher.
> >>
> >> These are just some random thoughts.
> > It seems reasonable.
> I think, though, that the implementation will be complex.
> We should limit this to request sizes that are <= stripe size (larger
> requests will hit more disks, and have a much lower optimal queue
> depth), so we need to add a new service_tree (they will become:
> SYNC_IDLE_LARGE, SYNC_IDLE_SMALL, SYNC_NOIDLE, ASYNC), and the
> optimization will apply only to the SYNC_IDLE_SMALL tree.
> Moreover, we can't just dispatch K queues and then idle on the last
> one. We need to have a set of K active queues, and wait on any of
> them. This makes this optimization very complex, and I think for
> little gain. In fact, usually we don't have sequential streams of
> small requests, unless we misuse mmap or direct I/O.

I guess one little simpler thing could be to determine whether underlying
media is single disk/spindle or not. So if optimal queue depth is more
than 1, there are most likely more than one spindle and we can drive
deeper queue depths and not idle on mmap process. If optimal queue depth
is 1, then there is single disk/spindle, and we can mark mmap process as
sync-idle. Not need of extra service tree.

But I do agree, that even determining optimal queue depth might turn out
to be complex. But in the long run it might be a useful information to
detct/know whether we are operating on single disk or an array of disks. I
will play around a bit with it if time permits.

> BTW, the mmap problem could be easily fixed adding madvise(WILL_NEED)
> to the userspace program, when dealing with data.
> I think we only have to worry about binaries, here.
> 
> > Something similar to what we do to reduce depth for async writes.
> > Can you see if you get similar BW improvements also for parallel
> > sequential direct I/Os with block size < stripe size?
> 
> Thanks,
> Corrado
