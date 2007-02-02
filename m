Return-Path: <linux-kernel-owner+w=401wt.eu-S1946007AbXBBSAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946007AbXBBSAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 13:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946010AbXBBSAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 13:00:54 -0500
Received: from mail.screens.ru ([213.234.233.54]:35203 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946009AbXBBSAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 13:00:53 -0500
Date: Fri, 2 Feb 2007 21:00:39 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: S?bastien Dugu? <sebastien.dugue@bull.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       linux-aio <linux-aio@kvack.org>, Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Benjamin LaHaise <bcrl@linux.intel.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>
Subject: Re: [PATCH -mm 4/7][AIO] - Make good_sigevent() non-static
Message-ID: <20070202180039.GA658@tv-sign.ru>
References: <20070201102252.240130c6@frecb000686> <20070201103053.64489048@frecb000686>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070201103053.64489048@frecb000686>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01, S?bastien Dugu? wrote:
> 
> +struct task_struct * sigevent_find_task(sigevent_t * event)
> +{
> +	struct task_struct *task = NULL;
> +
> +	if (event->sigev_signo <= 0 || event->sigev_signo > SIGRTMAX)
> +		return NULL;
> +
> +	if ((event->sigev_notify & SIGEV_THREAD_ID ) == SIGEV_THREAD_ID) {
> +		task = find_task_by_pid(event->sigev_notify_thread_id);
> +
> +		if (!task || task->tgid != current->tgid)
> +			task = NULL;
> +	} else if (event->sigev_notify == SIGEV_SIGNAL)
> +		task = current->group_leader;
> +
> +	return task;
> +}

I am afraid this is still not right. Consider

	->sigev_notify == SIGEV_THREAD_ID | RANDOM_BIT

Now, the second "if (SIGEV_THREAD_ID)" returns a valid task. However,

	really_put_req:

		if (notify == SIGEV_THREAD_ID || notify == SIGEV_SIGNAL)
			put_task_struct();

doesn't work, so we have task_struct leak.

Worse, this breaks posix-timers. Note that posix-timers allow SIGEV_NONE,
the timer is not queued in that case, we shouldn't do ->sigev_signo check.
This means that aio should check SIGEV_NONE itself.

Also, it is critical for posix-timers that SIGEV_THREAD_ID doesn't come
with another bit (like in the example below), note the code like

	if (sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
		...

IOW: good_sigevent() in its current form is very cryptic, and it _really_
needs a cleanup, but we should not change its behaviour.

Apart from this, I don't see other problems in the signal related code in
this series.

Oleg.

