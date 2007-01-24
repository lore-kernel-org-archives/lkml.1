Return-Path: <linux-kernel-owner+w=401wt.eu-S1030210AbXAXFz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030210AbXAXFz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 00:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030223AbXAXFz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 00:55:27 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53221 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030210AbXAXFz0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 00:55:26 -0500
Date: Tue, 23 Jan 2007 21:35:13 -0800
From: Andrew Morton <akpm@osdl.org>
To: =?ISO-8859-1?B?U+liYXN0aWVuIER1Z3Xp?= <sebastien.dugue@bull.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-aio <linux-aio@kvack.org>, Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [PATCH -mm 4/5][AIO] - AIO completion signal notification
Message-Id: <20070123213513.2454b24d.akpm@osdl.org>
In-Reply-To: <20070117105018.7213ed7c@frecb000686>
References: <20070117104601.36b2ab18@frecb000686>
	<20070117105018.7213ed7c@frecb000686>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jan 2007 10:50:18 +0100
Sébastien Dugué <sebastien.dugue@bull.net> wrote:

> +static long aio_setup_sigevent(struct aio_notify *notify,
> +			       struct sigevent __user *user_event)
> +{
> +	sigevent_t event;
> +	struct task_struct *target;
> +
> +	if (copy_from_user(&event, user_event, sizeof (event)))
> +		return -EFAULT;
> +
> +	if (event.sigev_notify == SIGEV_NONE)
> +		return 0;
> +
> +	notify->notify = event.sigev_notify;
> +	notify->signo = event.sigev_signo;
> +	notify->value = event.sigev_value;
> +
> +	read_lock(&tasklist_lock);
> +	target = good_sigevent(&event);
> +
> +	if (unlikely(!target || (target->flags & PF_EXITING)))
> +		goto out_unlock;
> +
> +	/*
> +	 * At this point, we know that notify is either SIGEV_SIGNAL or
> +	 * SIGEV_THREAD_ID and the target task is valid. So get a reference
> +	 * on the task, it will be dropped in really_put_req() when
> +	 * we're done with the request.
> +	 */
> +	get_task_struct(target);
> +	notify->target = target;
> +	read_unlock(&tasklist_lock);
> +
> +	/*
> +	 * NOTE: we cannot free the sigqueue in the completion path as
> +	 * the signal may not have been delivered to the target task.
> +	 * Therefore it has to be freed in __sigqueue_free() when the
> +	 * signal is collected if si_code is SI_ASYNCIO.
> +	 */
> +	notify->sigq = sigqueue_alloc();
> +
> +	if (unlikely(!notify->sigq))
> +		return -EAGAIN;

Did this just leak a ref on the task_struct?

> +
> +	return 0;
> +
> +out_unlock:
> +	read_unlock(&tasklist_lock);
> +	return -EINVAL;
> +}
