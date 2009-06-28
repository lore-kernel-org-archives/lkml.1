Return-Path: <linux-kernel-owner+w=401wt.eu-S1752963AbZF1LHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbZF1LHe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 07:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbZF1LHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 07:07:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60248 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbZF1LHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 07:07:22 -0400
Date: Sun, 28 Jun 2009 14:06:50 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       paulmck@linux.vnet.ibm.com, davidel@xmailserver.org,
       rusty@rustcorp.com.au
Subject: Re: [KVM PATCH v5 3/4] KVM: Fix races in irqfd using new
	eventfd_kref_get interface
Message-ID: <20090628110650.GA8061@redhat.com>
References: <20090625132441.26748.641.stgit@dev.haskins.net> <20090625132826.26748.15607.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625132826.26748.15607.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 09:28:27AM -0400, Gregory Haskins wrote:
> @@ -65,25 +134,39 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
>  	unsigned long flags = (unsigned long)key;
>  
>  	/*
> -	 * Assume we will be called with interrupts disabled
> +	 * Called with interrupts disabled
>  	 */
>  	if (flags & POLLIN)
> -		/*
> -		 * Defer the IRQ injection until later since we need to
> -		 * acquire the kvm->lock to do so.
> -		 */
> +		/* An event has been signaled, inject an interrupt */
>  		schedule_work(&irqfd->inject);
>  
>  	if (flags & POLLHUP) {
> -		/*
> -		 * for now, just remove ourselves from the list and let
> -		 * the rest dangle.  We will fix this up later once
> -		 * the races in eventfd are fixed
> -		 */
> +		/* The eventfd is closing, detach from KVM */
> +		struct kvm *kvm = irqfd->kvm;
> +		unsigned long flags;
> +
>  		__remove_wait_queue(irqfd->wqh, &irqfd->wait);
> -		irqfd->wqh = NULL;
> +
> +		spin_lock_irqsave(&kvm->irqfds.lock, flags);
> +
> +		if (irqfd->active) {
> +			/*
> +			 * If the item is still active we can be sure that
> +			 * no-one else is trying to shutdown this object at
> +			 * the same time.
> +			 *
> +			 * Defer the shutdown to a thread so we can flush
> +			 * all remaining inject jobs.  We use a slow-work
> +			 * item to prevent a deadlock against the work-queue
> +			 */
> +			irqfd_deactivate(irqfd);
> +			slow_work_enqueue(&irqfd->shutdown);

Greg, in your patch for slow-work module removal, you write:
  "Callers must ensure that their module has at least
  one reference held while the work is enqueued."
  Where does this guarantee come from, in this case?

-- 
MST
