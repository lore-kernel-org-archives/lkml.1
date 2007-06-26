Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbXFZArA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbXFZArA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 20:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbXFZAqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 20:46:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbXFZAqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 20:46:51 -0400
Date: Mon, 25 Jun 2007 20:46:41 -0400
From: Jeff Layton <jlayton@redhat.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH] RFC: have tcp_recvmsg() check kthread_should_stop() and
 treat it as if it were signalled
Message-Id: <20070625204641.3a328bc4.jlayton@redhat.com>
In-Reply-To: <a781481a0706251509w24c63e5ar65021b612f8a928f@mail.gmail.com>
References: <20070608123527.9b4cdafe.jlayton@redhat.com>
	<E1HwpmG-0008LW-00@gondolin.me.apana.org.au>
	<20070609070826.7bd3480c.jlayton@redhat.com>
	<a781481a0706251241n36126456x7f4b445a86d1a68f@mail.gmail.com>
	<20070625155213.665e5215.jlayton@redhat.com>
	<a781481a0706251509w24c63e5ar65021b612f8a928f@mail.gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 03:39:23 +0530
"Satyam Sharma" <satyam.sharma@gmail.com> wrote:

> Hi Jeff,
> 
> [ Trimmed netdev from Cc: list, added Christoph. ]
> 
> On 6/26/07, Jeff Layton <jlayton@redhat.com> wrote:
> > On Tue, 26 Jun 2007 01:11:20 +0530
> > "Satyam Sharma" <satyam.sharma@gmail.com> wrote:
> > > [...]
> > > Yes, why not embed a send_sig(SIGKILL) just before the wake_up_process()
> > > in kthread_stop() itself?
> > >
> > > Looking at some happily out-of-date comments in the kthread code, I can
> > > guess that at some point of time (perhaps very early drafts) Rusty actually
> > > *did* implement the whole kthread_stop() functionality using signals, but
> > > I suspect it might've been discarded and the kthread_stop_info approach
> > > used instead to protect from spurious signals from userspace. (?)
> > >
> > > So could we have signals in _addition_ to kthread_stop_info and change
> > > kthread_should_stop() to check for both:
> > >
> > > kthread_stop_info.k == current && signal_pending(current)
> > >
> > > If !kthread_should_stop() && signal_pending(current) => spurious signal,
> > > so just flush and discard (in the kthread).
> > > [...]
> > > Why is it wrong for kthreads to let signals through? We can ignore out
> > > all signals we're not interested in, and flush the spurious ones ...
> > > otherwise there really isn't much those kthreads can do that get blocked
> > > in such functions, is there?
> >
> > Yes, after I wrote that I began to question that assumption too. I was
> > pretty much going on a statement by Christoph Hellwig on an earlier
> > patch that I did:
> 
> Ok, I found both the threads / patches you referred to ...
> 
> > -----[snip]------
> > The right way to fix this is to stop sending signals at all and have
> > a kernel-internal way to get out of kernel_recvmsg.  Uses of signals by
> > kernel thread generally are bugs.
> > -----[snip]------
> >
> > Though this makes no sense to me. I don't see any reason why kthreads
> > can't use signals, and hacking support for breaking out of sleeping
> > functions seems redundant.
> 
> Right, signals _are_ the "signalling" mechanism all through kernel code
> already, anything else would clearly be redundant.
> 
> But I've listened / participated in other discussions about kthreads and
> signals and the general feeling is that (somebody correct me if I'm wrong)
> kernel threads are a kernel _implementation detail_ after all, and good
> design must ensure that userspace be unaware of even their existence.
> And I agree with that, but the real ugly uses of signals by kernel threads
> are those cases where we want to export a full signals-based interface to
> our kthread to userspace (such cases do exist in mainline, I think).
> But that's clearly not the case with the usage here.
> 
> > My latest patch for cifsd has it block all signals from userspace
> > and uses force_sig() instead of send_sig() when trying to stop the
> > thread. This seems to work pretty well and  still insulates the thread
> > from userspace signals.
> 
> Thanks, I find this solution much cleaner too, so now we avoid any
> sort of spuriousness getting in from userspace (and pretty much takes
> care of all the checking-if-spurious-and-flushing business I referred to
> earlier).
> 
> But how about making this part of kthreads proper? Functions such as
> skb_recv_datagram etc are pretty standard (and others such would also
> exist or get added in due time) and it is not exactly intuitive for a developer
> to add a force_sig(SIGKILL) before the kthread_stop() to ensure that the
> kthread using such functions does exit properly. [ I can foresee cases in
> the future when such functions are added to kthreads that did not have
> them previously, and suddenly someone reports a regression that the
> kthread stops exiting cleanly. ]
> 
> Satyam

I have no issue with it. I just didn't feel confident enough  to know
whether that might have harmful side effects.  Right offhand I don't
see why adding a force_sig() to kthread_stop() would be an issue. It
seems like if you're wanting to stop the thread anyway then a signal
probably wouldn't hurt anything.

-- 
Jeff Layton <jlayton@redhat.com>
