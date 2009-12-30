Return-Path: <linux-kernel-owner+w=401wt.eu-S1753782AbZL3VQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbZL3VQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 16:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbZL3VQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 16:16:46 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35699 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbZL3VQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 16:16:45 -0500
Date: Wed, 30 Dec 2009 22:16:43 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] cfq-iosched: replace sync_flight by
	rq_in_driver[BLK_RW_SYNC]
Message-ID: <20091230211643.GO4489@kernel.dk>
References: <1262185738-11942-1-git-send-email-czoccolo@gmail.com> <20091230184748.GF4489@kernel.dk> <4e5e476b0912301250x4a0de523v8c1d0a03720c8fa8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0912301250x4a0de523v8c1d0a03720c8fa8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30 2009, Corrado Zoccolo wrote:
> On Wed, Dec 30, 2009 at 7:47 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Wed, Dec 30 2009, Corrado Zoccolo wrote:
> >> According to my intuition (and brief testing), sync_flight is always
> >> equal to rq_in_driver[BLK_RW_SYNC] at the point of usage, so it can
> >> be removed and replaced by the other.
> >
> > They are not fully identical. ->sync_flight is incremented on insertion
> > on the dispatch list, ->rq_in_driver not until the request is activated
> > (eg the driver has retrieved it and wants to dispatch to the hardware).
> Usually (only exceptions are forced dispatch, or when a conflict in the
> rb tree is found), a request is activated as soon as cfq returns from
> cfq_dispatch_requests.

Yes, but then it may be deactivated immediately for requeue.

> > They will usually be identical, but that may not be true for requeues
> > for instance.
> 
> For our purpose, it is sufficient that in cfq_may_dispatch, they are either
> both 0 or both non-0.
> Since we have sync_flight >= rq_in_driver[1], the only question is:
> can the number of requests in the driver drop to 0 with requests still
> in flight?

It's mostly a theoretical issue, but yes it could happen. I'm assuming
you mean ->rq_in_driver[1] == 0 while ->sync_flight != 0. But then we
are into the area of some starvation problem, in hardware or in the
kernel. So it's not likely, but still.

> I'm asking because to drain async requests, we are using the rq_in_driver
> counter instead. Maybe they need the same treatment.

In theory, yes the same applies there. Normal operations would not have
that distinction between activated and on dispatch list.

-- 
Jens Axboe

