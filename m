Return-Path: <linux-kernel-owner+w=401wt.eu-S1759703AbZFZQ0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703AbZFZQ0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 12:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757155AbZFZQ0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 12:26:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34669 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbZFZQ0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 12:26:24 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] cfq-iosched: get rid of the need for __GFP_FAIL in cfq_find_alloc_queue()
References: <1246007120-24034-1-git-send-email-jens.axboe@oracle.com>
	<1246007120-24034-3-git-send-email-jens.axboe@oracle.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 26 Jun 2009 12:25:59 -0400
In-Reply-To: <1246007120-24034-3-git-send-email-jens.axboe@oracle.com> (Jens
	Axboe's message of "Fri, 26 Jun 2009 11:05:20 +0200")
Message-ID: <x497hyz9d2g.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> Setup an emergency fallback cfqq that we allocate at IO scheduler init
> time. If the slab allocation fails in cfq_find_alloc_queue(), we'll just
> punt IO to that cfqq instead. This ensures that cfq_find_alloc_queue()
> never fails without having to ensure free memory.
>
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  block/cfq-iosched.c |  124 +++++++++++++++++++++++++++-----------------------
>  1 files changed, 67 insertions(+), 57 deletions(-)
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index c760ae7..91e7e0b 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> +	/*
> +	 * Fallback dummy cfqq for extreme OOM conditions
> +	 */
> +	struct cfq_queue oom_cfqq;

OK, so you're embedding a cfqq into the cfqd.  That's 136 bytes, so I
guess that's not too bad.

> +	/*
> +	 * Our fallback cfqq if cfq_find_alloc_queue() runs into OOM issues.
> +	 * Grab a permanent reference to it, so that the normal code flow
> +	 * will not attempt to free it.
> +	 */
> +	cfq_init_cfqq(cfqd, &cfqd->oom_cfqq, 1, 0);
> +	atomic_inc(&cfqd->oom_cfqq.ref);
> +

I guess this is so we never try to free it, good.  ;)

One issue I have with this patch is that, if a task happens to run into
this condition, there is no way out.  It will always have the oom_cfqq
as it's cfqq.  Can't we fix that if we recover from the OOM condition?

Cheers,
Jeff
