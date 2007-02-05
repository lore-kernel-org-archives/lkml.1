Return-Path: <linux-kernel-owner+w=401wt.eu-S932478AbXBENlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbXBENlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 08:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932417AbXBENlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 08:41:24 -0500
Received: from mail.screens.ru ([213.234.233.54]:53477 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932478AbXBENlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 08:41:24 -0500
Date: Mon, 5 Feb 2007 16:43:14 +0300
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
Subject: Re: [PATCH -mm 4/7][AIO] Resend - Make good_sigevent() non-static
Message-ID: <20070205134314.GA283@tv-sign.ru>
References: <20070201102252.240130c6@frecb000686> <20070201103053.64489048@frecb000686> <20070202180039.GA658@tv-sign.ru> <20070205131839.6f601c3e@frecb000686>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205131839.6f601c3e@frecb000686>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05, S?bastien Dugu? wrote:
> 
> +struct task_struct * sigevent_find_task(sigevent_t * event)
> +{
> +	struct task_struct *task = current->group_leader;
> +
> +	if ((event->sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_NONE) {
> +		if (event->sigev_signo <= 0 || event->sigev_signo > SIGRTMAX)
> +			return NULL;
> +	}
> +
> +	if (event->sigev_notify & SIGEV_THREAD_ID) {
> +		if ((event->sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_SIGNAL)
> +			return NULL;
> +
> +		task = find_task_by_pid(event->sigev_notify_thread_id);
> +
> +		if (!task || task->tgid != current->tgid)
> +			task = NULL;
> +	}
> +
> +	return task;
> +}

I think this patch is correct, and the code is much more readable than
the old good_sigevet().

But please don't forget that PATCH 6/7 still needs a small fixup, we can
leak a task_struct in really_put_req()

		if (notify == SIGEV_THREAD_ID || notify == SIGEV_SIGNAL)
			put_task_struct(req->ki_notify.target);

because without SIGEV_THREAD_ID ->sigev_notify can have any bit/bits set,
even SIGEV_NONE (along with some other bit, aio_setup_sigevent checks for
== SIGEV_NONE).

Oleg.

