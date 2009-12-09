Return-Path: <linux-kernel-owner+w=401wt.eu-S1757521AbZLITyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbZLITyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757435AbZLITyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:54:35 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35231 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757425AbZLITyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:54:35 -0500
Date: Wed, 9 Dec 2009 20:54:41 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] cfq-iosched: reduce write depth only if sync was
	delayed
Message-ID: <20091209195441.GZ8742@kernel.dk>
References: <4b1ffe39.0f1abc0a.19c7.05d2@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b1ffe39.0f1abc0a.19c7.05d2@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09 2009, Corrado Zoccolo wrote:
> On Wed, Dec 9, 2009 at 8:05 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Wed, Dec 09 2009, Jeff Moyer wrote:
> >> OK.  Can we put a comment in there and change the initialization to
> >> cfq_slice_sync * 10?
> >
> > Agree, that would be MUCH easier to understand.
> >
> Sure, we can put a comment there, but I don't like hardcoding a constant that depends on how the formula is computed (what if the formula is changed, 
> and it doesn't depend on cfq_slice_sync any more, or if cfq_slice_sync changes dynamically?).
> When I wrote it, what I really meant was exactly what you read in the C code (assume the last delayed sync happened 1 second ago). Then, the effect 
> would be to start with a queue depth of 10 with the current formula, but even if we change the formula, 1 second is still meaningful (while 10 
> *cfq_slice_sync, that has the same value, becomes misleading). So my proposed fix is just:
> 
> From f06cd83b45b3a7ee13ae7322197b610085dc70dd Mon Sep 17 00:00:00 2001
> From: Corrado Zoccolo <corrado@localhost.(none)>
> Date: Wed, 9 Dec 2009 20:40:16 +0100
> Subject: [PATCH] cfq-iosched: commenting non-obvious initialization
> 
> Added a comment to explain the initialization of last_delayed_sync.
> 
> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
> ---
>  block/cfq-iosched.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 98b15b9..69ecee7 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -3759,6 +3759,10 @@ static void *cfq_init_queue(struct request_queue *q)
>  	cfqd->cfq_latency = 1;
>  	cfqd->cfq_group_isolation = 0;
>  	cfqd->hw_tag = -1;
> +	/*
> +	 * we optimistically start assuming sync ops weren't delayed in last
> +	 * second, in order to have larger depth for async operations.
> +	 */
>  	cfqd->last_delayed_sync = jiffies - HZ;

Thanks, that explains the HZ nicely. Applied.

-- 
Jens Axboe

