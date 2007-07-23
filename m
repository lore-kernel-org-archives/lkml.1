Return-Path: <linux-kernel-owner+w=401wt.eu-S1762803AbXGWNlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762803AbXGWNlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbXGWNlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:41:00 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:54075 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbXGWNk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:40:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m73nSFHG6Z1FVvhzPNMwITNv4cgwH+3QJsJmghINvvtJXzM0/hKVKD7vIn2yHpRnJPDuYNOaaiU8U7X+ec6HDWcXZOqeZEWYNtLy/rqzRnVJ1vZ9PBvkxaRD3g0peJqdRuEgwrV7Mz8Pxx7oIUIoquoRhKsc/H1Y6kqdWTpsH1I=
Message-ID: <a781481a0707230640h17e6d83l5c2359e41f3ec7b7@mail.gmail.com>
Date: Mon, 23 Jul 2007 19:10:58 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Lars Ellenberg" <lars.ellenberg@linbit.com>,
       "Kyle Moffett" <mrlinuxman@mac.com>, "Jens Axboe" <axboe@kernel.dk>,
       "Andrew Morton" <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
In-Reply-To: <20070723133202.GB23495@mail.linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070721203819.GA10706@mail.linbit.com>
	 <20070722213202.1f5d1cab.mrlinuxman@mac.com>
	 <20070723133202.GB23495@mail.linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/23/07, Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
> On Sun, Jul 22, 2007 at 09:32:02PM -0400, Kyle Moffett wrote:
> [...]
> > Don't use signals between kernel threads, use proper primitives like
> > notifiers and waitqueues, which means you should also probably switch away
> > from kernel_thread() to the kthread_*() APIs.  Also you should fix this
> > FIXME or remove it if it no longer applies:-D.
>
> right.
> but how to I tell a network thread in tcp_recvmsg to stop early,
> without using signals?


Yup, kthreads API cannot handle (properly stop) kernel threads that want
to sleep on possibly-blocking-forever-till-signalled-functions such as
tcp_recvmsg or skb_recv_datagram etc etc.

There are two workarounds:
1. Use sk_rcvtimeo and related while-continue logic
2. force_sig(SIGKILL) to your kernel thread just before kthread_stop
   (note that you don't need to allow / write code to handle / etc signals
   in your kthread code -- force_sig will work automatically)

> > +/* THINK maybe we actually want to use the default "event/%s" worker threads
> > + * or similar in linux 2.6, which uses per cpu data and threads.
> > + *
> > + * To be general, this might need a spin_lock member.
> > + * For now, please use the mdev->req_lock to protect list_head,
> > + * see drbd_queue_work below.
> > + */
> > +struct drbd_work_queue {
> > +       struct list_head q;
> > +       struct semaphore s; /* producers up it, worker down()s it */
> > +       spinlock_t q_lock;  /* to protect the list. */
> > +};
> >
> > Umm, how about fixing this to actually use proper workqueues or something
> > instead of this open-coded mess?
>
> unlikely to happen "right now".
> but it is on our todo list...


It should be easier to do it now (if you defer it for later, the code will
only grow more and more complex). Also, removing this gunk from
your driver will clearly make it smaller, and easier for us to review :-)

> > +#define peer_mask role_mask
> > +#define pdsk_mask disk_mask
> > +#define susp_mask 1
> > +#define user_isp_mask 1
> > +#define aftr_isp_mask 1
> > +#define NS(T, S) \
> > +#define NS2(T1, S1, T2, S2) \
> > +#define NS3(T1, S1, T2, S2, T3, S3) \
> > +#define _NS(D, T, S) \
> > +#define _NS2(D, T1, S1, T2, S2) \
> > +#define _NS3(D, T1, S1, T2, S2, T3, S3) \
> >
> > Grumble.  When I earlier said I thought I was in macro hell, well, I was
> > wrong.  *THIS* is macro hell.  What the fsck is that supposed to do?  And it
> > doesn't even include a *SINGLE* comment!!!
>
> uhm. basically you are right.
> Phil will take over to explain why it is done that way...


The simplistic problems I initially thought your driver suffered from turned
out to be not so true, actually -- like Kyle mentioned, your driver is in
proper macro hell. Please get rid of as many as possible, and replace
with functions, as applicable.


Satyam
