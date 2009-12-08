Return-Path: <linux-kernel-owner+w=401wt.eu-S965703AbZLHRwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965703AbZLHRwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 12:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965694AbZLHRwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 12:52:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965083AbZLHRwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 12:52:50 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] cfq-iosched: Wait for next request if we are about to expire the queue
References: <20091208150412.GC28615@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 08 Dec 2009 12:52:48 -0500
In-Reply-To: <20091208150412.GC28615@redhat.com> (Vivek Goyal's message of
	"Tue, 8 Dec 2009 10:04:12 -0500")
Message-ID: <x49zl5tfj4f.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> If there is a sequential reader running in a group, we wait for next request
> to come in that group after slice expiry and once new request is in, we expire
> the queue. Otherwise we delete the group from service tree and group looses
> its fair share.
>
> So far I was marking a queue as wait_busy if it had consumed its slice and
> it was last queue in the group. But this condition did not cover following
> two cases.
>
> - If think time of process is more than slice left, we will not arm the timer
>   and queue will be expired. 
>
> - If we hit the boundary condition where slice has not expired after request
>   completion but almost immediately after (4-5 ns), select_queue() hits and
>   by that time slice has expired because jiffies has incremented by one.
>
> Gui was hitting the boundary condition and not getting fairness numbers
> proportional to weight.
>
> This patch puts the checks for above two conditions and improves the fairness
> numbers for sequential workload on rotational media.
>
> Reported-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Acked-by: Gui Jianfeng <guijiafneng@cn.fujitsu.com>
> ---
>  block/cfq-iosched.c |   30 ++++++++++++++++++++++++++----
>  1 file changed, 26 insertions(+), 4 deletions(-)
>
> Index: linux1/block/cfq-iosched.c
> ===================================================================
> --- linux1.orig/block/cfq-iosched.c	2009-12-07 14:40:03.000000000 -0500
> +++ linux1/block/cfq-iosched.c	2009-12-07 14:40:04.000000000 -0500
> @@ -3251,6 +3251,29 @@ static void cfq_update_hw_tag(struct cfq
>  		cfqd->hw_tag = 0;
>  }
>  
> +static inline bool
> +cfq_should_wait_busy(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> +{
> +	struct cfq_io_context *cic = cfqd->active_cic;
> +
> +	/* If there are other queues in the group, don't wait */
> +	if (cfqq->cfqg->nr_cfqq > 1)
> +		return false;
> +
> +	if (cfq_slice_used(cfqq))
> +		return true;
> +
> +	if (cfqq->slice_end - jiffies == 1)
> +		return true;

This really looks like a hack.  At the very least, it requires a big
comment above it explaining why it's there.  Would it be possible to
detect such a condition in select_queue and handle it there?

Cheers,
Jeff
