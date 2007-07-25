Return-Path: <linux-kernel-owner+w=401wt.eu-S1765277AbXGYMMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765277AbXGYMMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761846AbXGYMMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:12:22 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:64860 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761750AbXGYMMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:12:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HiTZfPg7/51tj28NxskyVJyHQEPS8YpE0ggJQazUKamLJimFWEv/HH6k2q9UeG5rZ/ep+A7OFH+a2kLerrcXv2MOENSk8L6dpyfhQvuSGVr7TKNVlfEBzxSezFg2CCPtcqZVx+VDsCdnp4qf9zYBZuBaJMeKzf7Ve6hNwnjGYSk=
Message-ID: <a781481a0707250512v29d41b1bh25bcd358e7381d38@mail.gmail.com>
Date: Wed, 25 Jul 2007 17:42:15 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Lars Ellenberg" <lars.ellenberg@linbit.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Kyle Moffett" <mrlinuxman@mac.com>, "Jens Axboe" <axboe@kernel.dk>,
       "Andrew Morton" <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
In-Reply-To: <20070725094638.GA2444@mail.linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070721203819.GA10706@mail.linbit.com>
	 <20070722213202.1f5d1cab.mrlinuxman@mac.com>
	 <20070723133202.GB23495@mail.linbit.com>
	 <a781481a0707230640h17e6d83l5c2359e41f3ec7b7@mail.gmail.com>
	 <20070723211947.GD6477@mail.linbit.com>
	 <a781481a0707241611v3c35f6bdsb7af97d382b9298f@mail.gmail.com>
	 <20070725094638.GA2444@mail.linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/07, Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
> On Wed, Jul 25, 2007 at 04:41:53AM +0530, Satyam Sharma wrote:
> > [...]
> >
> > But where does the "send" come into the picture over here -- a send
> > won't block forever, so I don't foresee any issues whatsoever w.r.t.
> > kthreads conversion for that. [ BTW I hope you're *not* using any
> > signals-based interface for your kernel thread _at all_. Kthreads
> > disallow (ignore) all signals by default, as they should, and you really
> > shouldn't need to write any logic to handle or do-certain-things-on-seeing
> > a signal in a well designed kernel thread. ]
> >
> > >and the sending
> > >latency is crucial to performance, while the recv
> > >will not timeout for the next few seconds.
> >
> > Again, I don't see what sending latency has to do with a kernel_thread
> > to kthread conversion. Or with signals, for that matter. Anyway, as
> > Kyle Moffett mentioned elsewhere, you could probably look at other
> > examples (say cifs_demultiplexer_thread() in fs/cifs/connect.c).
>
> the basic problem, and what we use signals for, is:
>
> it is waiting in recv, waiting for the peer to say something.
> but I want it to stop recv, and go send something "right now".

That's ... weird. Most (all?) communication between any two parties
would follow a protocol where someone recv's stuff, does something
with it, and sends it back ... what would you send "right now" if you
didn't receive anything?

> I don't want to have two threads for that.

I really think you should -- you clearly should. From the above, it does
appear that you're mixing in multiple kinds of stuff into a single thread,
and thus mucking up the entire design (and implementation).

> yes we have timeo in place, anyways: we need to detect a failed peer
> node in time. we even aim for "sub-second failover" sometimes (which is
> not exactly feasible; but failover times of 15 seconds and less are
> requirement for useable HA-iSCSI deployments).
> but that does not cut it, timeo is seconds.
> you don't want seconds latency for IO operations.

Ok, that's a reasonable goal.

> so I signal it, it breaks out of recv, then sends, and goes back to recv.
>
> in-kernel epoll would probably solve this.
> I don't know how to do that properly, though.

Hmm, probably I don't understand what you're doing, how you're doing etc.
Will wait for the design & implementation docs.

Thanks,
Satyam
