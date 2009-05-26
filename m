Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbZEZUGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbZEZUGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 16:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757011AbZEZUG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 16:06:29 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:59130 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686AbZEZUG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 16:06:28 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 26 May 2009 13:00:26 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, mtosatti@redhat.com
Subject: Re: [KVM PATCH v10] kvm: add support for irqfd
In-Reply-To: <20090526164201.GD9842@redhat.com>
Message-ID: <alpine.DEB.1.10.0905261257520.5884@makko.or.mcafeemobile.com>
References: <20090520142234.22285.72274.stgit@dev.haskins.net> <20090526164201.GD9842@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009, Michael S. Tsirkin wrote:

> On Wed, May 20, 2009 at 10:30:49AM -0400, Gregory Haskins wrote:
> > +static int
> > +irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
> > +{
> > +	struct _irqfd *irqfd = container_of(wait, struct _irqfd, wait);
> > +
> > +	/*
> > +	 * The wake_up is called with interrupts disabled.  Therefore we need
> > +	 * to defer the IRQ injection until later since we need to acquire the
> > +	 * kvm->lock to do so.
> > +	 */
> > +	schedule_work(&irqfd->work);
> > +
> > +	return 0;
> > +}
> 
> This schedule_work is there just to work around the spinlock
> in eventfd_signal, which we don't really need. Isn't this right?
> And this is on each interrupt. Seems like a pity.
> How about a flag in eventfd that would
> convert it from waking up someone to a plain function call?
> 
> Davide, could we add something like

I'm sorry, but it's not very pretty. Please find another way around.



> diff --git a/fs/eventfd.c b/fs/eventfd.c
> index 2a701d5..8bfa308 100644
> --- a/fs/eventfd.c
> +++ b/fs/eventfd.c
> @@ -29,6 +29,7 @@ struct eventfd_ctx {
>  	 */
>  	__u64 count;
>  	unsigned int flags;
> +	int nolock;
>  };
>  
>  /*
> @@ -46,6 +47,12 @@ int eventfd_signal(struct file *file, int n)
>  
>  	if (n < 0)
>  		return -EINVAL;
> +	if (ctx->nolock) {
> +               /* Whoever set nolock
> +                  better set wqh.func as well. */
> +		ctx->wqh.func(&ctx->wqh, 0, 0, NULL);
> +		return 0;
> +	}
>  	spin_lock_irqsave(&ctx->wqh.lock, flags);
>  	if (ULLONG_MAX - ctx->count < n)
>  		n = (int) (ULLONG_MAX - ctx->count);



- Davide


