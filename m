Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbXGWVT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbXGWVT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbXGWVTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:19:50 -0400
Received: from aug.linbit.com ([212.69.162.22]:50439 "EHLO mail.linbit.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752007AbXGWVTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:19:49 -0400
Date: Mon, 23 Jul 2007 23:19:47 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Kyle Moffett <mrlinuxman@mac.com>, Jens Axboe <axboe@kernel.dk>,
       Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Message-ID: <20070723211947.GD6477@mail.linbit.com>
References: <20070721203819.GA10706@mail.linbit.com> <20070722213202.1f5d1cab.mrlinuxman@mac.com> <20070723133202.GB23495@mail.linbit.com> <a781481a0707230640h17e6d83l5c2359e41f3ec7b7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0707230640h17e6d83l5c2359e41f3ec7b7@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 07:10:58PM +0530, Satyam Sharma wrote:
> On 7/23/07, Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
> >On Sun, Jul 22, 2007 at 09:32:02PM -0400, Kyle Moffett wrote:
> >[...]
> >> Don't use signals between kernel threads, use proper primitives like
> >> notifiers and waitqueues, which means you should also probably switch 
> >away
> >> from kernel_thread() to the kthread_*() APIs.  Also you should fix this
> >> FIXME or remove it if it no longer applies:-D.
> >
> >right.
> >but how to I tell a network thread in tcp_recvmsg to stop early,
> >without using signals?
> 
> 
> Yup, kthreads API cannot handle (properly stop) kernel threads that want
> to sleep on possibly-blocking-forever-till-signalled-functions such as
> tcp_recvmsg or skb_recv_datagram etc etc.
> 
> There are two workarounds:
> 1. Use sk_rcvtimeo and related while-continue logic
> 2. force_sig(SIGKILL) to your kernel thread just before kthread_stop
>   (note that you don't need to allow / write code to handle / etc signals
>   in your kthread code -- force_sig will work automatically)

this is not only at stop time.
for example our "drbd_asender" thread
does receive as well as send, and the sending
latency is crucial to performance, while the recv
will not timeout for the next few seconds.

> >> +/* THINK maybe we actually want to use the default "event/%s" worker 
> >threads
> >> + * or similar in linux 2.6, which uses per cpu data and threads.
> >> + *
> >> + * To be general, this might need a spin_lock member.
> >> + * For now, please use the mdev->req_lock to protect list_head,
> >> + * see drbd_queue_work below.
> >> + */
> >> +struct drbd_work_queue {
> >> +       struct list_head q;
> >> +       struct semaphore s; /* producers up it, worker down()s it */
> >> +       spinlock_t q_lock;  /* to protect the list. */
> >> +};
> >>
> >> Umm, how about fixing this to actually use proper workqueues or something
> >> instead of this open-coded mess?
> >
> >unlikely to happen "right now".
> >but it is on our todo list...
> 
> It should be easier to do it now (if you defer it for later, the code will
> only grow more and more complex). Also, removing this gunk from
> your driver will clearly make it smaller, and easier for us to review :-)

and will poison the generic work queues with stuff that might block
somewhere deep in the tcp stack. and where we are not able to cancel it.
not exactly desirable, either.
but maybe I am missing something?

	Lars
