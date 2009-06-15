Return-Path: <linux-kernel-owner+w=401wt.eu-S1757895AbZFOJrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbZFOJrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbZFOJr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:47:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49150 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbZFOJr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:47:27 -0400
Date: Mon, 15 Jun 2009 12:46:50 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org
Subject: Re: [KVM PATCH v2 2/2] kvm: use POLLHUP to close an irqfd instead
	of an explicit ioctl
Message-ID: <20090615094650.GA4949@redhat.com>
References: <20090604124047.10544.38861.stgit@dev.haskins.net> <20090604124812.10544.5811.stgit@dev.haskins.net> <20090614114854.GA10269@redhat.com> <4A34F2B7.1030606@novell.com> <20090614132843.GC10646@redhat.com> <4A35C269.7050209@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A35C269.7050209@novell.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 11:39:21PM -0400, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
> > On Sun, Jun 14, 2009 at 08:53:11AM -0400, Gregory Haskins wrote:
> >   
> >> Michael S. Tsirkin wrote:
> >>     
> >>> On Thu, Jun 04, 2009 at 08:48:12AM -0400, Gregory Haskins wrote:
> >>>   
> >>>       
> >>>> +static void
> >>>> +irqfd_disconnect(struct _irqfd *irqfd)
> >>>> +{
> >>>> +	struct kvm *kvm;
> >>>> +
> >>>> +	mutex_lock(&irqfd->lock);
> >>>> +
> >>>> +	kvm = rcu_dereference(irqfd->kvm);
> >>>> +	rcu_assign_pointer(irqfd->kvm, NULL);
> >>>> +
> >>>> +	mutex_unlock(&irqfd->lock);
> >>>> +
> >>>> +	if (!kvm)
> >>>> +		return;
> >>>>  
> >>>>  	mutex_lock(&kvm->lock);
> >>>> -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
> >>>> -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
> >>>> +	list_del(&irqfd->list);
> >>>>  	mutex_unlock(&kvm->lock);
> >>>> +
> >>>> +	/*
> >>>> +	 * It is important to not drop the kvm reference until the next grace
> >>>> +	 * period because there might be lockless references in flight up
> >>>> +	 * until then
> >>>> +	 */
> >>>> +	synchronize_srcu(&irqfd->srcu);
> >>>> +	kvm_put_kvm(kvm);
> >>>>  }
> >>>>     
> >>>>         
> >>> So irqfd object will persist after kvm goes away, until eventfd is closed?
> >>>   
> >>>       
> >> Yep, by design.  It becomes part of the eventfd and is thus associated
> >> with its lifetime.  Consider it as if we made our own anon-fd
> >> implementation for irqfd and the lifetime looks similar.  The difference
> >> is that we are reusing eventfd and its interface semantics.
> >>     
> >>>   
> >>>       
> >>>>  
> >>>>  static int
> >>>>  irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
> >>>>  {
> >>>>  	struct _irqfd *irqfd = container_of(wait, struct _irqfd, wait);
> >>>> +	unsigned long flags = (unsigned long)key;
> >>>>  
> >>>> -	/*
> >>>> -	 * The wake_up is called with interrupts disabled.  Therefore we need
> >>>> -	 * to defer the IRQ injection until later since we need to acquire the
> >>>> -	 * kvm->lock to do so.
> >>>> -	 */
> >>>> -	schedule_work(&irqfd->work);
> >>>> +	if (flags & POLLIN)
> >>>> +		/*
> >>>> +		 * The POLLIN wake_up is called with interrupts disabled.
> >>>> +		 * Therefore we need to defer the IRQ injection until later
> >>>> +		 * since we need to acquire the kvm->lock to do so.
> >>>> +		 */
> >>>> +		schedule_work(&irqfd->inject);
> >>>> +
> >>>> +	if (flags & POLLHUP) {
> >>>> +		/*
> >>>> +		 * The POLLHUP is called unlocked, so it theoretically should
> >>>> +		 * be safe to remove ourselves from the wqh using the locked
> >>>> +		 * variant of remove_wait_queue()
> >>>> +		 */
> >>>> +		remove_wait_queue(irqfd->wqh, &irqfd->wait);
> >>>> +		flush_work(&irqfd->inject);
> >>>> +		irqfd_disconnect(irqfd);
> >>>> +
> >>>> +		cleanup_srcu_struct(&irqfd->srcu);
> >>>> +		kfree(irqfd);
> >>>> +	}
> >>>>  
> >>>>  	return 0;
> >>>>  }
> >>>>     
> >>>>         
> >>> And it is removed by this function when eventfd is closed.
> >>> But what prevents the kvm module from going away, meanwhile?
> >>>   
> >>>       
> >> Well, we hold a reference to struct kvm until we call
> >> irqfd_disconnect().  If kvm closes first, we disconnect and disassociate
> >> all references to kvm leaving irqfd->kvm = NULL.  Likewise, if irqfd
> >> closes first, we disassociate with kvm with the above quoted logic.  In
> >> either case, we are holding a kvm reference up until that "disconnect"
> >> point.  Therefore kvm should not be able to disappear before that
> >> disconnect, and after that point we do not care.
> >>     
> >
> > Yes, we do care.
> >
> > Here's the scenario in more detail:
> >
> > - kvm is closed
> > - irq disconnect is called
> > - kvm is put
> > - kvm module is removed: all irqs are disconnected
> > - eventfd closes and triggers callback into removed kvm module
> > - crash
> >   
> 
> [ lightbulb turns on]
> 
> Ah, now I see the point you were making.  I thought you were talking
> about the .text in kvm_set_irq() (which would be protected by my
> kvm_get_kvm() reference afaict).  But you are actually talking about the
> irqfd .text itself.  Indeed, you are correct that is this currently a
> race.  Good catch!
> 
> >   
> >> If that is not sufficient to prevent kvm.ko from going away in the
> >> middle, then IMO kvm_get_kvm() has a bug, not irqfd. ;) However, I
> >> believe everything is actually ok here.
> >>
> >> -Greg
> >>
> >>     
> >
> >
> > BTW, why can't we remove irqfds in kvm_release?
> >   
> 
> Well, this would be ideal but we run into that bi-directional reference
> thing that we talked about earlier and we both agree is non-trivial to
> solve.  Solving this locking problem would incidentally also pave the
> way for restoring the DEASSIGN feature, so patches welcome!

So far the only workable approach that I see is reverting the POLLHUP
patch. I agree it looks pretty, but DEASSIGN and closing the races is
more important IMO. And locking will definitely become much simpler.

> In the meantime, I think we can close the hole you found with the
> following patch (build-tested only):
> 
> commit f3a8dccc9e815599438e9feb0ea53e8eb10ad2b3
> Author: Gregory Haskins <ghaskins@novell.com>
> Date:   Sun Jun 14 23:37:49 2009 -0400
> 
>     KVM: make irqfd take kvm.ko module reference
>    
>     Michael Tsirkin pointed out that we currently have a race between someone
>     holding an irqfd reference and an rmmod against kvm.ko.  This patch closes
>     that hole by making sure that irqfd holds a kvm.ko reference for its lifetime.
>    
>     Found-by: Michael S. Tsirkin <mst@redhat.com>
>     Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> 
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 2c8028c..67e4eca 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -29,6 +29,7 @@
>  #include <linux/list.h>
>  #include <linux/eventfd.h>
>  #include <linux/srcu.h>
> +#include <linux/module.h>
>  
>  /*
>   * --------------------------------------------------------------------
> @@ -123,6 +124,7 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int
> sync, void
>  *key)
>  
>                 cleanup_srcu_struct(&irqfd->srcu);
>                 kfree(irqfd);
> +               module_put(THIS_MODULE);
>         }
>  
>         return 0;

module_put(THIS_MODULE) is always a bug unless you know that someone has
a reference to the current module: the module could go away between this
call and returning from function.

> @@ -176,6 +178,7 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
>         if (ret < 0)
>                 goto fail;
>  
> +       __module_get(THIS_MODULE);
>         kvm_get_kvm(kvm);
>  
>         mutex_lock(&kvm->lock);
> 
> 
> 


