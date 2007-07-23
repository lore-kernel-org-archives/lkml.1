Return-Path: <linux-kernel-owner+w=401wt.eu-S1762230AbXGWNcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762230AbXGWNcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbXGWNcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:32:09 -0400
Received: from aug.linbit.com ([212.69.162.22]:39477 "EHLO mail.linbit.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755451AbXGWNcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:32:07 -0400
Date: Mon, 23 Jul 2007 15:32:02 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Kyle Moffett <mrlinuxman@mac.com>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@osdl.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Message-ID: <20070723133202.GB23495@mail.linbit.com>
Mail-Followup-To: Lars Ellenberg <lars.ellenberg@linbit.com>,
	Kyle Moffett <mrlinuxman@mac.com>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
References: <20070721203819.GA10706@mail.linbit.com> <20070722213202.1f5d1cab.mrlinuxman@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070722213202.1f5d1cab.mrlinuxman@mac.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 09:32:02PM -0400, Kyle Moffett wrote:
> Ok, I didn't have a chance to get through anywhere near all of it, but
> here's my comments so far.  I didn't really go through things in any
> particular order but most of these comments are about your drbd_int.h
> header file.  Hopefully a lot of the comments will be useful to fix
> similar/identical problems in your C files.

Thank you for your time.

I want to give some lame excuses, still:

> +#undef DEVICE_NAME
> +#define DEVICE_NAME "drbd"

a left-over.
first prototypes of drbd have been around in linux 2.0 time...
"in the old days", as a block device, you had to define this,
and then include some header after that.
will clean that up.

> +/* I don't remember why XCPU ...
> + * This is used to wake the asender,
> + * and to interrupt sending the sending task
> + * on disconnect.
> + */
> +#define DRBD_SIG SIGXCPU

> Don't use signals between kernel threads, use proper primitives like
> notifiers and waitqueues, which means you should also probably switch away
> from kernel_thread() to the kthread_*() APIs.  Also you should fix this
> FIXME or remove it if it no longer applies:-D.

right.
but how to I tell a network thread in tcp_recvmsg to stop early,
without using signals?

> +/* see kernel/printk.c:printk_ratelimit
> + * macro, so it is easy do have independend rate limits at different locations
> + * "initializer element not constant ..." with kernel 2.4 :(
> + * so I initialize toks to something large
> + */
> +#define DRBD_ratelimit(ratelimit_jiffies, ratelimit_burst)     \
> 
> Any particular reason you can't just use printk_ratelimit for this?

I want to be able to do a rate-limit per specific message/code fragment,
without affecting other messages or execution paths.

> +/*
> + * Compatibility Section
> + *************************/
> +
> +#define LOCK_SIGMASK(task, flags)   spin_lock_irqsave(&task->sighand->siglock, flags)
> +#define UNLOCK_SIGMASK(task, flags) spin_unlock_irqrestore(&task->sighand->siglock, flags)
> +#define RECALC_SIGPENDING()        recalc_sigpending();
> 
> These aren't used anywhere,

I just recently cleaned up the use of them.
when the first drbd prototypes have been developed
it was linux 2.0 times...
along the way many things have changed in incompatible ways,
so we had to abstract it in macros.

> remove please?

yes.

> +/* THINK maybe we actually want to use the default "event/%s" worker threads
> + * or similar in linux 2.6, which uses per cpu data and threads.
> + *
> + * To be general, this might need a spin_lock member.
> + * For now, please use the mdev->req_lock to protect list_head,
> + * see drbd_queue_work below.
> + */
> +struct drbd_work_queue {
> +       struct list_head q;
> +       struct semaphore s; /* producers up it, worker down()s it */
> +       spinlock_t q_lock;  /* to protect the list. */
> +};
> 
> Umm, how about fixing this to actually use proper workqueues or something
> instead of this open-coded mess?

unlikely to happen "right now".
but it is on our todo list...

> +/* I want the packet to fit within one page
> + * THINK maybe use a special bitmap header,
> + * including offset and compression scheme and whatnot
> + * Do not use PAGE_SIZE here! Use a architecture agnostic constant!
> + */
> +#define BM_PACKET_WORDS ((4096-sizeof(struct Drbd_Header))/sizeof(long))
> 
> Yuck.  Definitely use PAGE_SIZE here, so at least if it's broken on an arch
> with multiple page sizes, somebody can grep for PAGE_SIZE to fix it.  It also
> means that on archs/configs with 8k or 64k pages you won't waste a bunch of
> memory.

No. This is not to allocate anything, but defines the chunk size with
which we transmit the bitmap, when we have to.
We need to be able to talk from one arch
(say i586) to some other (say s390, or sparc, or whatever).
The receiving side has a one-page buffer, from which it may or may not
to endian-conversion.
The hardcoded 4096 is the minimal common denominator here.

> +/* Dynamic tracing framework */
guess we have to explain first what this is for.
it probably is not exactly what you think it is...
but maybe I am just too ignorant about what you suggest here.

we'll have to defer discussion about this for when I'm done
doing the trivial fix-ups, and provided an overall design overview.

> +static inline void drbd_tcp_cork(struct socket *sock)
...
> On the other hand, none of the currently in-tree network block devices or
> network filesystems seem to feel the need to try to TCP_CORK their output, 
> why does drbd?

it had performance improvements somewhen.  I doubt it has still.
maybe we just remove this.

> +#define peer_mask role_mask
> +#define pdsk_mask disk_mask
> +#define susp_mask 1
> +#define user_isp_mask 1
> +#define aftr_isp_mask 1
> +#define NS(T, S) \
> +#define NS2(T1, S1, T2, S2) \
> +#define NS3(T1, S1, T2, S2, T3, S3) \
> +#define _NS(D, T, S) \
> +#define _NS2(D, T1, S1, T2, S2) \
> +#define _NS3(D, T1, S1, T2, S2, T3, S3) \
> 
> Grumble.  When I earlier said I thought I was in macro hell, well, I was
> wrong.  *THIS* is macro hell.  What the fsck is that supposed to do?  And it
> doesn't even include a *SINGLE* comment!!!

uhm. basically you are right.
Phil will take over to explain why it is done that way...


> +       int mxb = 1000000; /* arbitrary limit on open requests */
> 
> Arbitrary limits are usually bad.  Derive it from system properties, make it
> user-configurable, etc.

it is user configurable.
it is just the upper cap on user configurability.

most other points I just snipped off of this mail
will be handled as you suggested asap.

	Lars
