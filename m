Return-Path: <linux-kernel-owner+w=401wt.eu-S1760977AbXGXXMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977AbXGXXMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 19:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbXGXXL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 19:11:58 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:46947 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbXGXXL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 19:11:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NW7PI6LZcgWtbW5YSqJYbITi3z+IoXbQm1+xdCAPhCYrmm6jwN35Is4at35RSuHwMOwzYVCa7mGMQceKlUOH+T1vIe3P4E9DAW2e5dhFfl1J7DOzA1o4nqMBYcwCI4b3nseABNmVskMz/LGeKifIRJkfnSLHVfgCpeMuAyl6Hag=
Message-ID: <a781481a0707241611v3c35f6bdsb7af97d382b9298f@mail.gmail.com>
Date: Wed, 25 Jul 2007 04:41:53 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Lars Ellenberg" <lars.ellenberg@linbit.com>
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Cc: "Kyle Moffett" <mrlinuxman@mac.com>, "Jens Axboe" <axboe@kernel.dk>,
       "Andrew Morton" <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070723211947.GD6477@mail.linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070721203819.GA10706@mail.linbit.com>
	 <20070722213202.1f5d1cab.mrlinuxman@mac.com>
	 <20070723133202.GB23495@mail.linbit.com>
	 <a781481a0707230640h17e6d83l5c2359e41f3ec7b7@mail.gmail.com>
	 <20070723211947.GD6477@mail.linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,


On 7/24/07, Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
> On Mon, Jul 23, 2007 at 07:10:58PM +0530, Satyam Sharma wrote:
> > On 7/23/07, Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
> > >On Sun, Jul 22, 2007 at 09:32:02PM -0400, Kyle Moffett wrote:
> > >[...]
> > >> Don't use signals between kernel threads, use proper primitives like
> > >> notifiers and waitqueues, which means you should also probably switch
> > >away
> > >> from kernel_thread() to the kthread_*() APIs.  Also you should fix this
> > >> FIXME or remove it if it no longer applies:-D.
> > >
> > >right.
> > >but how to I tell a network thread in tcp_recvmsg to stop early,
> > >without using signals?
> >
> > Yup, kthreads API cannot handle (properly stop) kernel threads that want
> > to sleep on possibly-blocking-forever-till-signalled-functions such as
> > tcp_recvmsg or skb_recv_datagram etc etc.
> >
> > There are two workarounds:
> > 1. Use sk_rcvtimeo and related while-continue logic
> > 2. force_sig(SIGKILL) to your kernel thread just before kthread_stop
> >   (note that you don't need to allow / write code to handle / etc signals
> >   in your kthread code -- force_sig will work automatically)
>
> this is not only at stop time.
> for example our "drbd_asender" thread
> does receive as well as send,

That's normal -- in fact it would've been surprising if your kthread only
did recvs but no sends!

But where does the "send" come into the picture over here -- a send
won't block forever, so I don't foresee any issues whatsoever w.r.t.
kthreads conversion for that. [ BTW I hope you're *not* using any
signals-based interface for your kernel thread _at all_. Kthreads
disallow (ignore) all signals by default, as they should, and you really
shouldn't need to write any logic to handle or do-certain-things-on-seeing
a signal in a well designed kernel thread. ]

> and the sending
> latency is crucial to performance, while the recv
> will not timeout for the next few seconds.

Again, I don't see what sending latency has to do with a kernel_thread
to kthread conversion. Or with signals, for that matter. Anyway, as
Kyle Moffett mentioned elsewhere, you could probably look at other
examples (say cifs_demultiplexer_thread() in fs/cifs/connect.c).

[ I didn't really want to give that example, because I get a nervous
breakdown when looking at that code myself, and would actively
like to save other fellow developers from a similar fate. To know
what I'm talking about, set your xterm to display 40 rows, and
then look at the line numbers 3139-3218 in that file, especially
3190-3212. Yes, what you see there is a map of Sulawesi [1]
subliminally hidden in Linux kernel code :-) ]

Anyway, cifs_demultiplexer_thread() is just your normal kthread that:

(1) Ignores all signals
(2) Calls perma-blocking-till-signalled functions such as tcp_recvmsg
    (via kernel_recvmsg)
(3) Calls send-to-socket kind of functions

Hence, it could get into trouble when the umount(2) code wants to stop
it with kthread_stop() and it happens to be blocked in tcp_recvmsg()
with noblock = 0 (hence sk_rcvtimeo == MAX_SCHEDULE_TIMEOUT), thus
would handle the wake_up_process() internally, and not break out, hence
not check kthread_should_stop() which it should -- all this ensuring that
the kthread never gets killed, kthread_stop() hangs, and the umount(2)
from userspace never returns ...

But they've solved it as follows (as I suggested earlier):

(1) First, set sock->sk_rcvtimeo to some "magical value" in your code
    that sets up the socket params after socket->proto_ops->connect().
    See ipv4_connect(), f.e. in CIFS they've set it up to 7 seconds. But
    that's arbitrarily chosen -- this'll ensure your tcp_recvmsg() isn't
    perma-blocking in the first place, but will unblock/return every 7 secs,
    and thus get a chance to check kthread_should_stop().

(2) From the code that wants to kill/stop the kthread (module exit, or
    umount(2) most probably), just ensure you make a call to force_sig()
    before kthread_stop() on that kthread -- see cifs_umount() in the
    same file. This'll ensure that even if the kthread is currently sleeping
    in tcp_recvmsg(), it'll be signalled to break out from there, and thus
    check kthread_should_stop().

(3) Note that not a single line of code needs to be written extra in the
    kthread itself for this to work -- nothing to allow / handle signals ...

Just this, should be enough for a smooth conversion to kthreads, IMHO.


> > >> +/* THINK maybe we actually want to use the default "event/%s" worker
> > >threads
> > >> + * or similar in linux 2.6, which uses per cpu data and threads.
> > >> + *
> > >> + * To be general, this might need a spin_lock member.
> > >> + * For now, please use the mdev->req_lock to protect list_head,
> > >> + * see drbd_queue_work below.
> > >> + */
> > >> +struct drbd_work_queue {
> > >> +       struct list_head q;
> > >> +       struct semaphore s; /* producers up it, worker down()s it */
> > >> +       spinlock_t q_lock;  /* to protect the list. */
> > >> +};
> > >>
> > >> Umm, how about fixing this to actually use proper workqueues or something
> > >> instead of this open-coded mess?
> > >
> > >unlikely to happen "right now".
> > >but it is on our todo list...
> >
> > It should be easier to do it now (if you defer it for later, the code will
> > only grow more and more complex). Also, removing this gunk from
> > your driver will clearly make it smaller, and easier for us to review :-)
>
> and will poison the generic work queues

You could create your own workqueue as Jens Axboe suggested.

> with stuff that might block
> somewhere deep in the tcp stack. and where we are not able to cancel it.
> not exactly desirable, either.
> but maybe I am missing something?

What would that workqueue be for, in the first place? Are we talking of
the same (which is presently the) kernel_thread() here? Sorry, but I'm
only looking at the struct / snippet above, and reading words like
"worker" / "producer" and although you're calling that struct a
drbd_work_queue, it isn't quite obvious to me you're actually /using/
it as one.

Frankly, a high-level design document is a must, here (with lower
level implementation details in the individual changelogs of the
patches you finally post to this list). Working that out from 17 kloc
would otherwise be too difficult for any reviewer.

Thanks,
Satyam

[1] Sulawesi is the oddly-shaped island in the Indonesian archipelago:
http://upload.wikimedia.org/wikipedia/commons/1/16/Sulawesi_map.PNG
