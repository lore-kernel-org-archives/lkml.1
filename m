Return-Path: <linux-kernel-owner+w=401wt.eu-S1751378AbZL1Df5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbZL1Df5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 22:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbZL1Df4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 22:35:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:14148 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbZL1Df4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 22:35:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,461,1257148800"; 
   d="scan'208";a="479522574"
Date: Mon, 28 Dec 2009 11:35:54 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
Subject: Re: [RFC]cfq-iosched: quantum check tweak
Message-ID: <20091228033554.GB15242@sli10-desk.sh.intel.com>
References: <20091225091030.GA28365@sli10-desk.sh.intel.com>
 <4e5e476b0912250144l96c4d34v300910216e5c7a08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0912250144l96c4d34v300910216e5c7a08@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 25, 2009 at 05:44:40PM +0800, Corrado Zoccolo wrote:
> On Fri, Dec 25, 2009 at 10:10 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> > Currently a queue can only dispatch up to 4 requests if there are other queues.
> > This isn't optimal, device can handle more requests, for example, AHCI can
> > handle 31 requests. I can understand the limit is for fairness, but we could
> > do some tweaks:
> > 1. if the queue still has a lot of slice left, sounds we could ignore the limit
> ok. You can even scale the limit proportionally to the remaining slice
> (see below).
I can't understand the meaning of below scale. cfq_slice_used_soon() means
dispatched requests can finish before slice is used, so other queues will not be
impacted. I thought/hope a cfq_slice_idle time is enough to finish the
dispatched requests.
 
> > 2. we could keep the check only when cfq_latency is on. For uses who don't care
> > about latency should be happy to have device fully piped on.
> I wouldn't overload low_latency with this meaning. You can obtain the
> same by setting the quantum to 32.
As this impact fairness, so natually thought we could use low_latency. I'll remove
the check in next post.

> > I have a test of random direct io of two threads, each has 32 requests one time
> > without patch: 78m/s
> > with tweak 1: 138m/s
> > with two tweaks and disable latency: 156m/s
> 
> Please, test also with competing seq/random(depth1)/async workloads,
> and measure also introduced latencies.
depth1 should be ok, as if device can only send one request, it should not require
more requests from ioscheduler.
I'll do more checks. The time is hard to choose (I choose cfq_slice-idle here) to
balance thoughput and latency. Do we have creteria to measure this? See the patch
passes some tests, so it's ok for latency.

Thanks,
Shaohua
