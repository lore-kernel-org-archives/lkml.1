Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbZF1NTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbZF1NTm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 09:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZF1NTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 09:19:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53668 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbZF1NTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 09:19:32 -0400
Date: Sun, 28 Jun 2009 16:18:59 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       paulmck@linux.vnet.ibm.com, davidel@xmailserver.org,
       rusty@rustcorp.com.au
Subject: Re: [KVM PATCH v5 3/4] KVM: Fix races in irqfd using new
	eventfd_kref_get interface
Message-ID: <20090628131859.GC11866@redhat.com>
References: <20090625132441.26748.641.stgit@dev.haskins.net> <20090625132826.26748.15607.stgit@dev.haskins.net> <20090628110650.GA8061@redhat.com> <4A476714.2000602@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A476714.2000602@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 08:50:28AM -0400, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
> > On Thu, Jun 25, 2009 at 09:28:27AM -0400, Gregory Haskins wrote:
> >   
> >> @@ -65,25 +134,39 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
> >>  	unsigned long flags = (unsigned long)key;
> >>  
> >>  	/*
> >> -	 * Assume we will be called with interrupts disabled
> >> +	 * Called with interrupts disabled
> >>  	 */
> >>  	if (flags & POLLIN)
> >> -		/*
> >> -		 * Defer the IRQ injection until later since we need to
> >> -		 * acquire the kvm->lock to do so.
> >> -		 */
> >> +		/* An event has been signaled, inject an interrupt */
> >>  		schedule_work(&irqfd->inject);
> >>  
> >>  	if (flags & POLLHUP) {
> >> -		/*
> >> -		 * for now, just remove ourselves from the list and let
> >> -		 * the rest dangle.  We will fix this up later once
> >> -		 * the races in eventfd are fixed
> >> -		 */
> >> +		/* The eventfd is closing, detach from KVM */
> >> +		struct kvm *kvm = irqfd->kvm;
> >> +		unsigned long flags;
> >> +
> >>  		__remove_wait_queue(irqfd->wqh, &irqfd->wait);
> >> -		irqfd->wqh = NULL;
> >> +
> >> +		spin_lock_irqsave(&kvm->irqfds.lock, flags);
> >> +
> >> +		if (irqfd->active) {
> >> +			/*
> >> +			 * If the item is still active we can be sure that
> >> +			 * no-one else is trying to shutdown this object at
> >> +			 * the same time.
> >> +			 *
> >> +			 * Defer the shutdown to a thread so we can flush
> >> +			 * all remaining inject jobs.  We use a slow-work
> >> +			 * item to prevent a deadlock against the work-queue
> >> +			 */
> >> +			irqfd_deactivate(irqfd);
> >> +			slow_work_enqueue(&irqfd->shutdown);
> >>     
> >
> > Greg, in your patch for slow-work module removal, you write:
> >   "Callers must ensure that their module has at least
> >   one reference held while the work is enqueued."
> >   Where does this guarantee come from, in this case?
> >   
> The general guarantee comes from the fact that modules naturally have to
> have a reference to be able to call the enqueue function to begin with,
> or the calling function was already racy.  In this particular case, we
> can guarantee that the kvm vm fd is held while our slow-work is active,
> and all slow work is flushed before it is released.  (I guess I am
> assuming that VFS takes a module reference when an fd is opened, but I
> have not verified that it actually does.  If it doesn't, I suppose KVM
> is already racy w.r.t. unloading, independent of my patches)
> 
> -Greg
> 

that could be the case, as we have, for example:

static struct file_operations kvm_vm_fops = {
        .release        = kvm_vm_release,
        .unlocked_ioctl = kvm_vm_ioctl,
        .compat_ioctl   = kvm_vm_ioctl,
        .mmap           = kvm_vm_mmap,
};

with no owner field.

Avi, shouldn't we initialize the owner field to prevent
kvm module from going away while files are open?

-- 
MST
