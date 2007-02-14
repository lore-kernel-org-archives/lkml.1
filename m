Return-Path: <linux-kernel-owner+w=401wt.eu-S932508AbXBNTsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508AbXBNTsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 14:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932509AbXBNTsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 14:48:40 -0500
Received: from mail.screens.ru ([213.234.233.54]:52461 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932508AbXBNTsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 14:48:39 -0500
Date: Wed, 14 Feb 2007 22:47:42 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 1/4] freezer-cpu-hotplug core
Message-ID: <20070214194742.GA301@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214144229.GA19789@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gautham, I'll try to apply this patch and read the code on Sunday, right
now a couple of comments about workqueue.c changes.

On 02/14, Gautham R Shenoy wrote:
>
> --- hotplug.orig/kernel/workqueue.c
> +++ hotplug/kernel/workqueue.c
> @@ -368,6 +368,7 @@ static int worker_thread(void *__cwq)
>  	DEFINE_WAIT(wait);
>  	struct k_sigaction sa;
>  	sigset_t blocked;
> +	int bind_cpu = smp_processor_id();
>  
>  	if (!cwq->wq->freezeable)
>  		current->flags |= PF_NOFREEZE;
> @@ -392,8 +393,11 @@ static int worker_thread(void *__cwq)
>  	do_sigaction(SIGCHLD, &sa, (struct k_sigaction *)0);
>  
>  	for (;;) {
> -		if (cwq->wq->freezeable)
> +		if (cwq->wq->freezeable) {

Else? This is wrong. The change like this should start from making all
cwq->threads freezeable, otherwise it just doesn't work.

>  			try_to_freeze();
> +			if (cpu_is_offline(bind_cpu))
> +				goto wait_to_die;
> +		}
>
> ...
>
> +
> +wait_to_die:
> +	/* Wait for kthread_stop */
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	while (!kthread_should_stop()) {
> +		schedule();
> +		set_current_state(TASK_INTERRUPTIBLE);
> +	}
> +	__set_current_state(TASK_RUNNING);
> +	return 0;
>  }

I believe this is not needed, see the comments for the next patch.

Oleg.

