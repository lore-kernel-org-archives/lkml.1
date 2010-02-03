Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab0BCTr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:47:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932671Ab0BCTrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:47:24 -0500
Date: Wed, 3 Feb 2010 20:43:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, rusty@rustcorp.com.au,
       tj@kernel.org, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] core: workqueue: BUG_ON on workqueue recursion
Message-ID: <20100203194350.GA13824@redhat.com>
References: <20100203122755.0fd4fb7e@marrow.netinsight.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100203122755.0fd4fb7e@marrow.netinsight.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03, Simon Kagstrom wrote:
>
> When the workqueue is flushed from workqueue context (recursively), the
> system enters a strange state where things at random (dependent on the
> global workqueue) start misbehaving. For example, for us the console and
> logins locks up while the web server continues running.
>
> Since the system becomes unstable, change this to a BUG_ON instead.

I agree with this patch. We are going to deadlock anyway, if the
condition is true the caller is cwq->current_work, this means
flush_cpu_workqueue() will insert the barrier and hang.

However,

> @@ -482,7 +482,7 @@ static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
>  	int active = 0;
>  	struct wq_barrier barr;
>
> -	WARN_ON(cwq->thread == current);
> +	BUG_ON(cwq->thread == current);

Another option is change the code to do

	if (WARN_ON(cwq->thread == current))
		return;

This gives the kernel chance to survive after the warning.

What do you think?

Oleg.

