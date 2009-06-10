Return-Path: <linux-kernel-owner+w=401wt.eu-S1760665AbZFJR7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665AbZFJR7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 13:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756535AbZFJR7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 13:59:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43188 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674AbZFJR7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 13:59:35 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Shan Wei <shanwei@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CFQ:optimize the cfq_should_preempt()
References: <4A2E4088.1010403@cn.fujitsu.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 10 Jun 2009 13:59:30 -0400
In-Reply-To: <4A2E4088.1010403@cn.fujitsu.com> (Shan Wei's message of "Tue, 09
	Jun 2009 18:59:20 +0800")
Message-ID: <x49iqj4q8al.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shan Wei <shanwei@cn.fujitsu.com> writes:

> The patch don't fix bug, just optimizes the cfq_should_preempt()
> to preempt higher priority queue.
>
> Additionally, the comment above cfq_preempt_queue() is outdated.
>
>
> Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
> ---
>  block/cfq-iosched.c |   17 +++++------------
>  1 files changed, 5 insertions(+), 12 deletions(-)
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index a55a9bd..427f522 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1993,10 +1993,10 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
>  	if (cfq_slice_used(cfqq))
>  		return 1;
>  
> -	if (cfq_class_idle(new_cfqq))
> -		return 0;
> -
> -	if (cfq_class_idle(cfqq))
> +	/*
> +	 * if new_cfqq is of higher priority, preempting the active queue.
> +	 */
> +	if (new_cfqq->ioprio_class < cfqq->ioprio_class)
>  		return 1;

Prior to this patch, if both queues were idle, the first if statement
would evaluate to true and we would return 0.  With your patch, we fall
through to the rest of the logic in the function.  In such a case, I
don't think this is an optimiation.  I can't say how likely this is to
happen, though.

What other justfication do you have for this change?  Were you able to
measure a performance difference?

Cheers,
Jeff
