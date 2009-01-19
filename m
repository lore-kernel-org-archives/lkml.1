Return-Path: <linux-kernel-owner+w=401wt.eu-S1759339AbZASVXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339AbZASVXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 16:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbZASVXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 16:23:03 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:60299 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbZASVXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 16:23:01 -0500
Date: Mon, 19 Jan 2009 16:23:29 -0500
From: Jody McIntyre <scjody@sun.com>
Subject: Re: 2.6.29-rc1: BUG: unable to handle kernel paging request at
	000077fed87bb6bf
In-reply-to: <20090114215120.b0ad7c4b.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-id: <20090119212329.GS28831@clouds>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <20090113214743.GE28831@clouds>
 <20090114215120.b0ad7c4b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 09:51:20PM -0800, Andrew Morton wrote:
> It needs to be bisected :(
> 
> At a guess I'd say that some piece of code somewhere did
> schedule_delayed_work(work) and then scribbled on *work before the
> timer got to run.  It could be anywhere at all in your kernel.

I tried your patch on Friday and couldn't find the bug with it.  I was
going to try more debugging today but happily, a commit made over the
weekend has fixed the issue.

Thanks,
Jody

> Thomas's debugobjects code could perhaps be used to find the culprit,
> but alas the workqueue code hasn't been taught to use that framework.
> 
> We could do something like this:
> 
> --- a/kernel/workqueue.c~a
> +++ a/kernel/workqueue.c
> @@ -196,9 +196,14 @@ EXPORT_SYMBOL_GPL(queue_work_on);
>  
>  static void delayed_work_timer_fn(unsigned long __data)
>  {
> -	struct delayed_work *dwork = (struct delayed_work *)__data;
> -	struct cpu_workqueue_struct *cwq = get_wq_data(&dwork->work);
> -	struct workqueue_struct *wq = cwq->wq;
> +	struct delayed_work *dwork;
> +	struct cpu_workqueue_struct *cwq;
> +	struct workqueue_struct *wq;
> +
> +	dwork = (struct delayed_work *)__data;
> +	printk("delayed_work_timer_fn: handling %p\n", dwork);
> +	cwq = get_wq_data(&dwork->work);
> +	wq = cwq->wq;
>  
>  	__queue_work(wq_per_cpu(wq, smp_processor_id()), &dwork->work);
>  }
> @@ -214,6 +219,8 @@ static void delayed_work_timer_fn(unsign
>  int queue_delayed_work(struct workqueue_struct *wq,
>  			struct delayed_work *dwork, unsigned long delay)
>  {
> +	printk("queue_delayed_work: queueing %p\n", dwork);
> +	dump_stack();
>  	if (delay == 0)
>  		return queue_work(wq, &dwork->work);
>  
> _
> 
> It will print an object address and a call trace in
> queue_delayed_work() and will print an object address in
> delayed_work_timer_fn().
> 
> Hopefully when it oopses you'll see the bad object address which was
> obtained by delayed_work_timer_fn().  Then, you can go back through the
> trace and determine which callsite passed that object address to
> queue_delayed_work().  Then we will have our culprit.
> 
> It'll possibly generate a lot of output, so logged netconsole might be
> needed.
> 
