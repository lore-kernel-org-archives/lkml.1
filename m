Return-Path: <linux-kernel-owner+w=401wt.eu-S1756493AbZBJUym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbZBJUym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbZBJUyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:54:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754729AbZBJUyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:54:32 -0500
Date: Tue, 10 Feb 2009 12:53:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: peterz@infradead.org, mingo@elte.hu, fweisbec@gmail.com, oleg@tv-sign.ru,
       dada1@cosmosbay.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] workqueue: not allow recursion run_workqueue
Message-Id: <20090210125344.6fc244a3.akpm@linux-foundation.org>
In-Reply-To: <498B9675.3000202@cn.fujitsu.com>
References: <497838F0.7020408@cn.fujitsu.com>
	<20090122093046.GC5891@nowhere>
	<20090122093649.GD24758@elte.hu>
	<c62985530901220306p78ea541cs28912a844297b304@mail.gmail.com>
	<1232622615.4890.114.camel@laptop>
	<498AA0F1.2030003@cn.fujitsu.com>
	<498B9675.3000202@cn.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Feb 2009 09:46:29 +0800
Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> Hi, Ingo
> 
> This is new changelog, I didn't change the patch,
> except use WARN_ON instead BUG_ON.
> 
> Thanks, Lai
> 
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> 1) lockdep will complain when recursion run_workqueue()
> 2) The recursive implement of run_workqueue() makes flush_workqueue()
>    and it's doc are inconsistent. It may hide deadlock and other bugs.
> 3) recursion run_workqueue() will poison cwq->current_work,
>    but flush_work() and __cancel_work_timer() ...etc. need
>    reliable cwq->current_work.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 2f44583..1129cde 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -48,8 +48,6 @@ struct cpu_workqueue_struct {
>  
>  	struct workqueue_struct *wq;
>  	struct task_struct *thread;
> -
> -	int run_depth;		/* Detect run_workqueue() recursion depth */
>  } ____cacheline_aligned;
>  
>  /*
> @@ -262,13 +260,6 @@ EXPORT_SYMBOL_GPL(queue_delayed_work_on);
>  static void run_workqueue(struct cpu_workqueue_struct *cwq)
>  {
>  	spin_lock_irq(&cwq->lock);
> -	cwq->run_depth++;
> -	if (cwq->run_depth > 3) {
> -		/* morton gets to eat his hat */
> -		printk("%s: recursion depth exceeded: %d\n",
> -			__func__, cwq->run_depth);
> -		dump_stack();
> -	}

I never did get to eat my hat.


Do we know of any cases where there was ever any recursion here?  Even
single-level recursion?

