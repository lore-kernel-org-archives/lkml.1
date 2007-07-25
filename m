Return-Path: <linux-kernel-owner+w=401wt.eu-S1762035AbXGYJqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762035AbXGYJqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 05:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757719AbXGYJqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 05:46:43 -0400
Received: from aug.linbit.com ([212.69.162.22]:53193 "EHLO mail.linbit.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755609AbXGYJqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 05:46:42 -0400
Date: Wed, 25 Jul 2007 11:46:39 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Kyle Moffett <mrlinuxman@mac.com>, Jens Axboe <axboe@kernel.dk>,
       Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Message-ID: <20070725094638.GA2444@mail.linbit.com>
Mail-Followup-To: Lars Ellenberg <lars.ellenberg@linbit.com>,
	Satyam Sharma <satyam.sharma@gmail.com>,
	Kyle Moffett <mrlinuxman@mac.com>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
References: <20070721203819.GA10706@mail.linbit.com> <20070722213202.1f5d1cab.mrlinuxman@mac.com> <20070723133202.GB23495@mail.linbit.com> <a781481a0707230640h17e6d83l5c2359e41f3ec7b7@mail.gmail.com> <20070723211947.GD6477@mail.linbit.com> <a781481a0707241611v3c35f6bdsb7af97d382b9298f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0707241611v3c35f6bdsb7af97d382b9298f@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 04:41:53AM +0530, Satyam Sharma wrote:
> Hi Lars,
> 
> 
> On 7/24/07, Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
> >On Mon, Jul 23, 2007 at 07:10:58PM +0530, Satyam Sharma wrote:
> >> On 7/23/07, Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
> >> >On Sun, Jul 22, 2007 at 09:32:02PM -0400, Kyle Moffett wrote:
> >> >[...]
> >> >> Don't use signals between kernel threads, use proper primitives like
> >> >> notifiers and waitqueues, which means you should also probably switch
> >> >away
> >> >> from kernel_thread() to the kthread_*() APIs.  Also you should fix 
> >this
> >> >> FIXME or remove it if it no longer applies:-D.
> >> >
> >> >right.
> >> >but how to I tell a network thread in tcp_recvmsg to stop early,
> >> >without using signals?
> >>
> >> Yup, kthreads API cannot handle (properly stop) kernel threads that want
> >> to sleep on possibly-blocking-forever-till-signalled-functions such as
> >> tcp_recvmsg or skb_recv_datagram etc etc.
> >>
> >> There are two workarounds:
> >> 1. Use sk_rcvtimeo and related while-continue logic
> >> 2. force_sig(SIGKILL) to your kernel thread just before kthread_stop
> >>   (note that you don't need to allow / write code to handle / etc signals
> >>   in your kthread code -- force_sig will work automatically)
> >
> >this is not only at stop time.
> >for example our "drbd_asender" thread
> >does receive as well as send,
> 
> That's normal -- in fact it would've been surprising if your kthread only
> did recvs but no sends!
> 
> But where does the "send" come into the picture over here -- a send
> won't block forever, so I don't foresee any issues whatsoever w.r.t.
> kthreads conversion for that. [ BTW I hope you're *not* using any
> signals-based interface for your kernel thread _at all_. Kthreads
> disallow (ignore) all signals by default, as they should, and you really
> shouldn't need to write any logic to handle or do-certain-things-on-seeing
> a signal in a well designed kernel thread. ]
> 
> >and the sending
> >latency is crucial to performance, while the recv
> >will not timeout for the next few seconds.
> 
> Again, I don't see what sending latency has to do with a kernel_thread
> to kthread conversion. Or with signals, for that matter. Anyway, as
> Kyle Moffett mentioned elsewhere, you could probably look at other
> examples (say cifs_demultiplexer_thread() in fs/cifs/connect.c).

the basic problem, and what we use signals for, is:

it is waiting in recv, waiting for the peer to say something.
but I want it to stop recv, and go send something "right now".
I don't want to have two threads for that.

yes we have timeo in place, anyways: we need to detect a failed peer
node in time. we even aim for "sub-second failover" sometimes (which is
not exactly feasible; but failover times of 15 seconds and less are
requirement for useable HA-iSCSI deployments).
but that does not cut it, timeo is seconds.
you don't want seconds latency for IO operations.

so I signal it, it breaks out of recv, then sends, and goes back to recv.

in-kernel epoll would probably solve this.
I don't know how to do that properly, though.

> >> only grow more and more complex). Also, removing this gunk from
> >> your driver will clearly make it smaller, and easier for us to review :-)
> >
> >and will poison the generic work queues
> 
> You could create your own workqueue as Jens Axboe suggested.

will do.
I was not aware of the "create_singlethread_workqueue",
it does fit our useage good enough.

> Frankly, a high-level design document is a must, here (with lower
> level implementation details in the individual changelogs of the
> patches you finally post to this list). Working that out from 17 kloc
> would otherwise be too difficult for any reviewer.

sure. will be available soon.
this was just a "bust in and see what lkml does about it",
I don't expect to be merged within days :)
I think it is realistic to be merged this year, though...
[as chrismas present, maybe :-)]

-- 
: Lars Ellenberg                            Tel +43-1-8178292-0  :
: LINBIT Information Technologies GmbH      Fax +43-1-8178292-82 :
: Vivenotgasse 48, A-1120 Vienna/Europe    http://www.linbit.com :
