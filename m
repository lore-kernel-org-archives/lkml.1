Return-Path: <linux-kernel-owner+w=401wt.eu-S1751169AbXAXLMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169AbXAXLMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 06:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbXAXLMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 06:12:20 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:33029 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbXAXLMS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 06:12:18 -0500
Date: Wed, 24 Jan 2007 12:11:30 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-aio <linux-aio@kvack.org>, Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [PATCH -mm 4/5][AIO] - AIO completion signal notification
Message-ID: <20070124121130.0dfc8573@frecb000686>
In-Reply-To: <20070123213513.2454b24d.akpm@osdl.org>
References: <20070117104601.36b2ab18@frecb000686>
	<20070117105018.7213ed7c@frecb000686>
	<20070123213513.2454b24d.akpm@osdl.org>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 24/01/2007 12:13:05,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 24/01/2007 12:13:07,
	Serialize complete at 24/01/2007 12:13:07
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007 21:35:13 -0800 Andrew Morton <akpm@osdl.org> wrote:

> On Wed, 17 Jan 2007 10:50:18 +0100
> Sébastien Dugué <sebastien.dugue@bull.net> wrote:
> 
> > +static long aio_setup_sigevent(struct aio_notify *notify,
> > +			       struct sigevent __user *user_event)
> > +{
> > +	sigevent_t event;
> > +	struct task_struct *target;
> > +
> > +	if (copy_from_user(&event, user_event, sizeof (event)))
> > +		return -EFAULT;
> > +
> > +	if (event.sigev_notify == SIGEV_NONE)
> > +		return 0;
> > +
> > +	notify->notify = event.sigev_notify;
> > +	notify->signo = event.sigev_signo;
> > +	notify->value = event.sigev_value;
> > +
> > +	read_lock(&tasklist_lock);
> > +	target = good_sigevent(&event);
> > +
> > +	if (unlikely(!target || (target->flags & PF_EXITING)))
> > +		goto out_unlock;
> > +
> > +	/*
> > +	 * At this point, we know that notify is either SIGEV_SIGNAL or
> > +	 * SIGEV_THREAD_ID and the target task is valid. So get a reference
> > +	 * on the task, it will be dropped in really_put_req() when
> > +	 * we're done with the request.
> > +	 */
> > +	get_task_struct(target);
> > +	notify->target = target;
> > +	read_unlock(&tasklist_lock);
> > +
> > +	/*
> > +	 * NOTE: we cannot free the sigqueue in the completion path as
> > +	 * the signal may not have been delivered to the target task.
> > +	 * Therefore it has to be freed in __sigqueue_free() when the
> > +	 * signal is collected if si_code is SI_ASYNCIO.
> > +	 */
> > +	notify->sigq = sigqueue_alloc();
> > +
> > +	if (unlikely(!notify->sigq))
> > +		return -EAGAIN;
> 
> Did this just leak a ref on the task_struct?
> 

  No, the ref is released in really_put_req() when we dispose of
the iocb.

  Thanks,

  Sébastien.
