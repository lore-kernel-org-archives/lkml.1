Return-Path: <linux-kernel-owner+w=401wt.eu-S1752427AbXBELKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbXBELKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 06:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbXBELKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 06:10:44 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46510 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbXBELKo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 06:10:44 -0500
Date: Mon, 5 Feb 2007 12:09:28 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       linux-aio <linux-aio@kvack.org>, Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Benjamin LaHaise <bcrl@linux.intel.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>
Subject: Re: [PATCH -mm 4/7][AIO] - Make good_sigevent() non-static
Message-ID: <20070205120928.51dbc6a2@frecb000686>
In-Reply-To: <20070202180039.GA658@tv-sign.ru>
References: <20070201102252.240130c6@frecb000686>
	<20070201103053.64489048@frecb000686>
	<20070202180039.GA658@tv-sign.ru>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 05/02/2007 12:11:46,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 05/02/2007 12:11:47,
	Serialize complete at 05/02/2007 12:11:47
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Oleg,

  thanks for your comments.

On Fri, 2 Feb 2007 21:00:39 +0300 Oleg Nesterov <oleg@tv-sign.ru> wrote:

> On 02/01, S?bastien Dugu? wrote:
> > 
> > +struct task_struct * sigevent_find_task(sigevent_t * event)
> > +{
> > +	struct task_struct *task = NULL;
> > +
> > +	if (event->sigev_signo <= 0 || event->sigev_signo > SIGRTMAX)
> > +		return NULL;
> > +
> > +	if ((event->sigev_notify & SIGEV_THREAD_ID ) == SIGEV_THREAD_ID) {
> > +		task = find_task_by_pid(event->sigev_notify_thread_id);
> > +
> > +		if (!task || task->tgid != current->tgid)
> > +			task = NULL;
> > +	} else if (event->sigev_notify == SIGEV_SIGNAL)
> > +		task = current->group_leader;
> > +
> > +	return task;
> > +}
> 
> I am afraid this is still not right. Consider
> 
> 	->sigev_notify == SIGEV_THREAD_ID | RANDOM_BIT
> 
> Now, the second "if (SIGEV_THREAD_ID)" returns a valid task. However,
> 
> 	really_put_req:
> 
> 		if (notify == SIGEV_THREAD_ID || notify == SIGEV_SIGNAL)
> 			put_task_struct();
> 
> doesn't work, so we have task_struct leak.

  Right, I'll revert back to the old code with cleanups.

> 
> Worse, this breaks posix-timers. Note that posix-timers allow SIGEV_NONE,
> the timer is not queued in that case, we shouldn't do ->sigev_signo check.
> This means that aio should check SIGEV_NONE itself.
> 
> Also, it is critical for posix-timers that SIGEV_THREAD_ID doesn't come
> with another bit (like in the example below), note the code like
> 
> 	if (sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
> 		...
> 
> IOW: good_sigevent() in its current form is very cryptic, and it _really_
> needs a cleanup, but we should not change its behaviour.

  Yep. I must admit that I didn't pay enough attention to this 10-liner,
but in the end it rightfully backfired on me.

> 
> Apart from this, I don't see other problems in the signal related code in
> this series.
> 
> Oleg.
> 

  Thanks again for your review.

  Sébastien.
