Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab0BDKyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 05:54:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab0BDKyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 05:54:04 -0500
Date: Thu, 4 Feb 2010 11:52:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, rusty@rustcorp.com.au, akpm@linux-foundation.org,
       mingo@elte.hu
Subject: Re: [PATCH v2] core: workqueue: return on workqueue recursion
Message-ID: <20100204105213.GB21188@redhat.com>
References: <20100203122755.0fd4fb7e@marrow.netinsight.se> <20100203194350.GA13824@redhat.com> <4B6A2D29.3010804@kernel.org> <20100204090216.131fc73f@marrow.netinsight.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204090216.131fc73f@marrow.netinsight.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Simon Kagstrom wrote:
>
> When the workqueue is flushed from workqueue context (recursively), the
> system enters a strange state where things at random (dependent on the
> global workqueue) start misbehaving. For example, for us the console and
> logins locks up while the web server continues running.
>
> The system becomes unstable since the workqueue barrier locks the
> workqueue. This patch instead returns if the workqueue is flushed
> recursively, which keeps the workqueue alive but warns.
>
> Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>

Acked-by: Oleg Nesterov <oleg@redhat.com>

> ---
> ChangeLog:
> 	* Instead of BUG_ON, warn and return on recursive calls as suggested
> 	  by Oleg Nesterov and Tejun Hao
>
>  kernel/workqueue.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index dee4865..49f8fa7 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -482,7 +482,8 @@ static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
>  	int active = 0;
>  	struct wq_barrier barr;
>
> -	WARN_ON(cwq->thread == current);
> +	if (WARN_ON(cwq->thread == current))
> +		return 1;
>
>  	spin_lock_irq(&cwq->lock);
>  	if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
> --
> 1.6.0.4
>

