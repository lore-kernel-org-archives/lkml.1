Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950Ab0AMSm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab0AMSm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 13:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238Ab0AMSm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 13:42:59 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:46729 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab0AMSm6 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ghaskins@novell.com:3:2>);
	Wed, 13 Jan 2010 13:42:58 -0500
X-Greylist: delayed 1203 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jan 2010 13:42:58 EST
Message-Id: <4B4DC92A0200005A0005D0C4@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 13 Jan 2010 11:22:50 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Julia Lawall" <julia@diku.dk>, "Avi Kivity" <avi@redhat.com>,
       "Gleb Natapov" <gleb@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
       "Marcelo Tosatti" <mtosatti@redhat.com>, <kvm@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm: only allow one gsi per fd
References: <20100113165809.GA13334@redhat.com>
In-Reply-To: <20100113165809.GA13334@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 1/13/2010 at 11:58 AM, in message <20100113165809.GA13334@redhat.com>,
"Michael S. Tsirkin" <mst@redhat.com> wrote: 
> Looks like repeatedly binding same fd to multiple gsi's with irqfd can
> use up a ton of kernel memory for irqfd structures.
> 
> A simple fix is to allow each fd to only trigger one gsi: triggering a
> srorm of interrupts in guest is likely useless anyway, and we can do it
> by binding a single gsi to many interrupts if we really want to.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Seems reasonable to me.

Acked-by: Gregory Haskins <ghaskins@novell.com>

> ---
> 
> This patch is IMO a good candidate for 2.6.33 and 2.6.32.x.
> 
>  virt/kvm/eventfd.c |   15 +++++++++++++--
>  1 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 30f70fd..62e4cd9 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -166,7 +166,7 @@ irqfd_ptable_queue_proc(struct file *file, 
> wait_queue_head_t *wqh,
>  static int
>  kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
>  {
> -	struct _irqfd *irqfd;
> +	struct _irqfd *irqfd, *tmp;
>  	struct file *file = NULL;
>  	struct eventfd_ctx *eventfd = NULL;
>  	int ret;
> @@ -203,9 +203,20 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
>  	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
>  	init_poll_funcptr(&irqfd->pt, irqfd_ptable_queue_proc);
>  
> +	spin_lock_irq(&kvm->irqfds.lock);
> +
> +	ret = 0;
> +	list_for_each_entry(tmp, &kvm->irqfds.items, list) {
> +		if (irqfd->eventfd != tmp->eventfd)
> +			continue;
> +		/* This fd is used for another irq already. */
> +		ret = -EBUSY;
> +		spin_unlock_irq(&kvm->irqfds.lock);
> +		goto fail;
> +	}
> +
>  	events = file->f_op->poll(file, &irqfd->pt);
>  
> -	spin_lock_irq(&kvm->irqfds.lock);
>  	list_add_tail(&irqfd->list, &kvm->irqfds.items);
>  	spin_unlock_irq(&kvm->irqfds.lock);
>  




