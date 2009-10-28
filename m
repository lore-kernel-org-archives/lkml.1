Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbZJ1Hi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbZJ1Hi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 03:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756914AbZJ1Hi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 03:38:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756849AbZJ1Hi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 03:38:26 -0400
Date: Wed, 28 Oct 2009 09:35:50 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v3 3/3] KVM: Directly inject interrupts if they
	support lockless operation
Message-ID: <20091028073550.GA22784@redhat.com>
References: <20091026162148.23704.47286.stgit@dev.haskins.net> <20091026162208.23704.19953.stgit@dev.haskins.net> <20091027174515.GA14421@redhat.com> <4AE741F0.1030509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE741F0.1030509@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 02:54:40PM -0400, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
> > On Mon, Oct 26, 2009 at 12:22:08PM -0400, Gregory Haskins wrote:
> >> IRQFD currently uses a deferred workqueue item to execute the injection
> >> operation.  It was originally designed this way because kvm_set_irq()
> >> required the caller to hold the irq_lock mutex, and the eventfd callback
> >> is invoked from within a non-preemptible critical section.
> >>
> >> With the advent of lockless injection support for certain GSIs, the
> >> deferment mechanism is no longer technically needed in all cases.
> >> Since context switching to the workqueue is a source of interrupt
> >> latency, lets switch to a direct method whenever possible.  Fortunately
> >> for us, the most common use of irqfd (MSI-based GSIs) readily support
> >> lockless injection.
> >>
> >> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> > 
> > This is a useful optimization I think.
> > Some comments below.
> > 
> >> ---
> >>
> >>  virt/kvm/eventfd.c |   31 +++++++++++++++++++++++++++----
> >>  1 files changed, 27 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> >> index 30f70fd..e6cc958 100644
> >> --- a/virt/kvm/eventfd.c
> >> +++ b/virt/kvm/eventfd.c
> >> @@ -51,20 +51,34 @@ struct _irqfd {
> >>  	wait_queue_t              wait;
> >>  	struct work_struct        inject;
> >>  	struct work_struct        shutdown;
> >> +	void (*execute)(struct _irqfd *);
> >>  };
> >>  
> >>  static struct workqueue_struct *irqfd_cleanup_wq;
> >>  
> >>  static void
> >> -irqfd_inject(struct work_struct *work)
> >> +irqfd_inject(struct _irqfd *irqfd)
> >>  {
> >> -	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
> >>  	struct kvm *kvm = irqfd->kvm;
> >>  
> >>  	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
> >>  	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
> >>  }
> >>  
> >> +static void
> >> +irqfd_deferred_inject(struct work_struct *work)
> >> +{
> >> +	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
> >> +
> >> +	irqfd_inject(irqfd);
> >> +}
> >> +
> >> +static void
> >> +irqfd_schedule(struct _irqfd *irqfd)
> >> +{
> >> +	schedule_work(&irqfd->inject);
> >> +}
> >> +
> >>  /*
> >>   * Race-free decouple logic (ordering is critical)
> >>   */
> >> @@ -126,7 +140,7 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
> >>  
> >>  	if (flags & POLLIN)
> >>  		/* An event has been signaled, inject an interrupt */
> >> -		schedule_work(&irqfd->inject);
> >> +		irqfd->execute(irqfd);
> >>  
> >>  	if (flags & POLLHUP) {
> >>  		/* The eventfd is closing, detach from KVM */
> >> @@ -179,7 +193,7 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
> >>  	irqfd->kvm = kvm;
> >>  	irqfd->gsi = gsi;
> >>  	INIT_LIST_HEAD(&irqfd->list);
> >> -	INIT_WORK(&irqfd->inject, irqfd_inject);
> >> +	INIT_WORK(&irqfd->inject, irqfd_deferred_inject);
> >>  	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
> >>  
> >>  	file = eventfd_fget(fd);
> >> @@ -209,6 +223,15 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
> >>  	list_add_tail(&irqfd->list, &kvm->irqfds.items);
> >>  	spin_unlock_irq(&kvm->irqfds.lock);
> >>  
> >> +	ret = kvm_irq_check_lockless(kvm, gsi);
> >> +	if (ret < 0)
> >> +		goto fail;
> >> +
> >> +	if (ret)
> >> +		irqfd->execute = &irqfd_inject;
> >> +	else
> >> +		irqfd->execute = &irqfd_schedule;
> >> +
> > 
> > Can't gsi get converted from lockless to non-lockless
> > after it's checked (by the routing ioctl)?
> 
> I think I protect against this in patch 2/3 by ensuring that any vectors
> that are added have to conform to the same locking rules.  The code
> doesn't support deleting routes, so we really only need to make sure
> that new routes do not change.

What I refer to, is when userspace calls KVM_SET_GSI_ROUTING.
I don't see how your patch helps here: can't a GSI formerly
used for MSI become unused, and then reused for non-MSI?
If not, it's a problem I think, because I think userspace currently does this
sometimes.

> > Kernel will crash then.
> > 
> > How about, each time we get event from eventfd, we implement
> > kvm_irqfd_toggle_lockless, which does a single scan, and returns
> > true/false status (and I really mean toggle, let's not do set 1 / set 0
> > as well) telling us whether interrupts could be delivered in a lockless
> > manner?
> 
> I am not sure I like this idea in general given that I believe I already
> handle the error case you are concerned with.
> 
> However, the concept of providing a "toggle" option so we can avoid
> scanning the list twice is a good one.  That can be done as a new patch
> series, but it would be a nice addition.
> 
> Thanks Michael,
> -Greg
> 


