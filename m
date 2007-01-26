Return-Path: <linux-kernel-owner+w=401wt.eu-S933177AbXAZLPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177AbXAZLPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 06:15:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933178AbXAZLPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 06:15:12 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37836 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933177AbXAZLPJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 06:15:09 -0500
Date: Fri, 26 Jan 2007 12:14:07 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Laurent Vivier <laurent.vivier@bull.net>,
       Zach Brown <zach.brown@oracle.com>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ulrich Drepper <drepper@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: + aio-completion-signal-notification.patch added to -mm tree
Message-ID: <20070126121407.1437928a@frecb000686>
In-Reply-To: <20070125162141.GA226@tv-sign.ru>
References: <20070125162141.GA226@tv-sign.ru>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 26/01/2007 12:15:59,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 26/01/2007 12:16:00,
	Serialize complete at 26/01/2007 12:16:00
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007 19:21:41 +0300 Oleg Nesterov <oleg@tv-sign.ru> wrote:

> Sebastien Dugue wrote:
> >
> > +static long aio_setup_sigevent(struct aio_notify *notify,
> > +			       struct sigevent __user *user_event)
> > +{
> > +	sigevent_t event;
> > +	struct task_struct *target;
> > +
> > +	if (copy_from_user(&event, user_event, sizeof(event)))
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
> 
> We don't need tasklist_lock, we can use rcu_read_lock() instead.

  Right that will be beneficial, will change.

> 
> > +	target = good_sigevent(&event);
> > +
> > +	if (unlikely(!target || (target->flags & PF_EXITING)))
> > +		goto out_unlock;
> 
> PF_EXITING check is racy and unneded. In fact, it is wrong. If the main
> thread is already died, we can only use SIGEV_THREAD_ID signals, because
> otherwise good_sigevent() returns ->group_leader.

  Care to explain here please, I'm not following you.

> 
> > @@ -994,6 +1077,15 @@ int fastcall aio_complete(struct kiocb *
> >  	kunmap_atomic(ring, KM_IRQ1);
> >
> >  	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
> > +
> > +	if (iocb->ki_notify.notify != SIGEV_NONE) {
> > +		ret = aio_send_signal(&iocb->ki_notify);
> > +
> > +		/* If signal generation failed, release the sigqueue */
> > +		if (ret)
> > +			sigqueue_free(iocb->ki_notify.sigq);
> 
> We should not use sigqueue_free() here. It takes current->sighand->siglock
> to remove sigqueue from "struct sigpending". But current is just a "random"
> process here.
> 
> Yes, if I understand this patch correctly, it is not possible that this
> sigqueue is pending, but still this is bad imho.

 Yes, in fact the sigqueue is used for a single signal delivery and then
free. In fact I could have used directly __sigqueue_free() instead here
except for the fact that it's private to signal.c and I'm reluctant
to export it to other subsystems.

> 
> >  static void __sigqueue_free(struct sigqueue *q)
> >  {
> > -	if (q->flags & SIGQUEUE_PREALLOC)
> > +	if (q->flags & SIGQUEUE_PREALLOC && q->info.si_code != SI_ASYNCIO)
> >  		return;
> 
> Oh, this is not nice. Could we change send_sigqueue/send_group_sigqueue
> instead ?

  Yep, that's the other solution.

> 
> -	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
> +	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC) && q->info.si_code != SI_ASYNCIO);
> 
> This way aio can use __sigqueue_alloc/__sigqueue_free directly and forget
> about SIGQUEUE_PREALLOC.

  Well, I don't think it's cleaner. The aio error path calls sigqueue_free()
directly whereas in case of success sigqueue_free() is called from the signal
delivery path.

> 
> On the other hand, imho this patch takes a wrong direction.
> 
> The purpose of SIGQUEUE_PREALLOC + send_sigqueue() is to re-use the same
> sigqueue while sending a stream of signals. But in aio case we allocate
> sigqueue to send only 1 signal, then it freed after the delivery like
> the regular sigqueue. So what is the point?
> 
> I'd suggest to not use this interface. Just use group_send_sig_info() or
> specific_send_sig_info(). Yes, this way we will do GFP_ATOMIC allocation
> of sigqueue in interrupt context, but is this so bad in this case?

  Well, the thihere is that in the past we used group_send_sig_info()
and specific_send_sig_info() for notification but Zach Brown raised
the question about reliable signal delivery. IOW an aio submission
should not succeed if signal delivery is going to fail. Hence the
use of the preallocated sigqueue.

  Thanks,

  Sébastien.





