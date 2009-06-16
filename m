Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbZFPOiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbZFPOiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 10:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbZFPOig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 10:38:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43591 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbZFPOif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 10:38:35 -0400
Date: Tue, 16 Jun 2009 17:38:16 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based
	notifier interface
Message-ID: <20090616143816.GA18196@redhat.com>
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37A7FC.4090403@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A37A7FC.4090403@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 10:11:08AM -0400, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
> > On Mon, Jun 15, 2009 at 10:29:56PM -0400, Gregory Haskins wrote:
> >   
> >> irqfd and its underlying implementation, eventfd, currently utilize
> >> the embedded wait-queue in eventfd for signal notification.  The nice thing
> >> about this design decision is that it re-uses the existing
> >> eventfd/wait-queue code and it generally works well....with several
> >> limitations.
> >>
> >> One of the limitations is that notification callbacks are always called
> >> inside a spin_lock_irqsave critical section.  Another limitation is
> >> that it is very difficult to build a system that can recieve release
> >> notification without being racy.
> >>
> >> Therefore, we introduce a new registration interface that is SRCU based
> >> instead of wait-queue based, and implement the internal wait-queue
> >> infrastructure in terms of this new interface.  We then convert irqfd
> >> to use this new interface instead of the existing wait-queue code.
> >>
> >> The end result is that we now have the opportunity to run the interrupt
> >> injection code serially to the callback (when the signal is raised from
> >> process-context, at least) instead of always deferring the injection to a
> >> work-queue.
> >>
> >> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> >> CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >> CC: Davide Libenzi <davidel@xmailserver.org>
> >> ---
> >>
> >>  fs/eventfd.c            |  115 +++++++++++++++++++++++++++++++++++++++++++----
> >>  include/linux/eventfd.h |   30 ++++++++++++
> >>  virt/kvm/eventfd.c      |  114 +++++++++++++++++++++--------------------------
> >>  3 files changed, 188 insertions(+), 71 deletions(-)
> >>
> >> diff --git a/fs/eventfd.c b/fs/eventfd.c
> >> index 72f5f8d..505d5de 100644
> >> --- a/fs/eventfd.c
> >> +++ b/fs/eventfd.c
> >> @@ -30,8 +30,47 @@ struct eventfd_ctx {
> >>  	 */
> >>  	__u64 count;
> >>  	unsigned int flags;
> >> +	struct srcu_struct srcu;
> >> +	struct list_head nh;
> >> +	struct eventfd_notifier notifier;
> >>  };
> >>  
> >> +static void _eventfd_wqh_notify(struct eventfd_notifier *en)
> >> +{
> >> +	struct eventfd_ctx *ctx = container_of(en,
> >> +					       struct eventfd_ctx,
> >> +					       notifier);
> >> +
> >> +	if (waitqueue_active(&ctx->wqh))
> >> +		wake_up_poll(&ctx->wqh, POLLIN);
> >> +}
> >> +
> >> +static void _eventfd_notify(struct eventfd_ctx *ctx)
> >> +{
> >> +	struct eventfd_notifier *en;
> >> +	int idx;
> >> +
> >> +	idx = srcu_read_lock(&ctx->srcu);
> >> +
> >> +	/*
> >> +	 * The goal here is to allow the notification to be preemptible
> >> +	 * as often as possible.  We cannot achieve this with the basic
> >> +	 * wqh mechanism because it requires the wqh->lock.  Therefore
> >> +	 * we have an internal srcu list mechanism of which the wqh is
> >> +	 * a client.
> >> +	 *
> >> +	 * Not all paths will invoke this function in process context.
> >> +	 * Callers should check for suitable state before assuming they
> >> +	 * can sleep (such as with preemptible()).  Paul McKenney assures
> >> +	 * me that srcu_read_lock is compatible with in-atomic, as long as
> >> +	 * the code within the critical section is also compatible.
> >> +	 */
> >> +	list_for_each_entry_rcu(en, &ctx->nh, list)
> >> +		en->ops->signal(en);
> >> +
> >> +	srcu_read_unlock(&ctx->srcu, idx);
> >> +}
> >> +
> >>  /*
> >>   * Adds "n" to the eventfd counter "count". Returns "n" in case of
> >>   * success, or a value lower then "n" in case of coutner overflow.
> >>     
> >
> > This is ugly, isn't it? With CONFIG_PREEMPT=no preemptible() is always false.
> >
> > Further, to do useful things it might not be enough that you can sleep:
> > with iofd you also want to access current task with e.g. copy from user.
> >
> > Here's an idea: let's pass a flag to ->signal, along the lines of
> > signal_is_task, that tells us that it is safe to use current, and add
> > eventfd_signal_task() which is the same as eventfd_signal but lets everyone
> > know that it's safe to both sleep and use current->mm.
> >
> > Makes sense?
> >   
> 
> It does make sense, yes.  What I am not clear on is how would eventfd
> detect this state such as to populate such flags, and why cant the
> ->signal() CB do the same?
> 
> Thanks Michael,
> -Greg
> 

eventfd can't detect this state. But the callers know in what context they are.
So the *caller* of eventfd_signal_task makes sure of this: if you are in a task,
you can call eventfd_signal_task() if not, you must call eventfd_signal.


-- 
MST
