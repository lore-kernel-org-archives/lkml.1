Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbZFNNT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbZFNNT4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 09:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756150AbZFNNTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 09:19:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46062 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280AbZFNNTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 09:19:47 -0400
Date: Sun, 14 Jun 2009 16:19:37 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, mtosatti@redhat.com
Subject: Re: [KVM PATCH v10] kvm: add support for irqfd
Message-ID: <20090614131937.GA10646@redhat.com>
References: <20090520142234.22285.72274.stgit@dev.haskins.net> <20090614092542.GA4833@redhat.com> <4A34EFD9.7010303@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A34EFD9.7010303@novell.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 08:40:57AM -0400, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
> > On Wed, May 20, 2009 at 10:30:49AM -0400, Gregory Haskins wrote:
> >
> > ...
> >
> >   
> >> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> >> +static int
> >> +kvm_assign_irqfd(struct kvm *kvm, int fd, int gsi)
> >> +{
> >> +	struct _irqfd *irqfd;
> >> +	struct file *file = NULL;
> >> +	int ret;
> >> +
> >> +	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
> >> +	if (!irqfd)
> >> +		return -ENOMEM;
> >> +
> >> +	irqfd->kvm = kvm;
> >> +	irqfd->gsi = gsi;
> >> +	INIT_LIST_HEAD(&irqfd->list);
> >> +	INIT_WORK(&irqfd->work, irqfd_inject);
> >> +
> >> +	/*
> >> +	 * Embed the file* lifetime in the irqfd.
> >> +	 */
> >> +	file = fget(fd);
> >> +	if (IS_ERR(file)) {
> >> +		ret = PTR_ERR(file);
> >> +		goto fail;
> >> +	}
> >> +
> >> +	/*
> >> +	 * Install our own custom wake-up handling so we are notified via
> >> +	 * a callback whenever someone signals the underlying eventfd
> >> +	 */
> >> +	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
> >> +	init_poll_funcptr(&irqfd->pt, irqfd_ptable_queue_proc);
> >> +
> >> +	ret = file->f_op->poll(file, &irqfd->pt);
> >> +	if (ret < 0)
> >> +		goto fail;
> >> +
> >> +	irqfd->file = file;
> >> +
> >> +	mutex_lock(&kvm->lock);
> >> +	list_add_tail(&irqfd->list, &kvm->irqfds);
> >> +	mutex_unlock(&kvm->lock);
> >> +
> >> +	return 0;
> >> +
> >> +fail:
> >> +	if (irqfd->wqh)
> >> +		remove_wait_queue(irqfd->wqh, &irqfd->wait);
> >> +
> >> +	if (file && !IS_ERR(file))
> >> +		fput(file);
> >> +
> >> +	kfree(irqfd);
> >> +	return ret;
> >> +}
> >>     
> >
> > It seems that this lets the guest assign an unlimited number of fds
> > to the same gsi, potentially using up all of kernel memory.
> >
> > Since we don't need multiple fds assigned to the same gsi (instead,
> > multiple processes can write to the same eventfd to trigger an
> > interrupt) let's simply check that no fd is yet assigned to this gsi.
> >   
> 
> I think Avi asked for this specific feature during review which is the
> reason why its there today.  However, I agree that it would probably be
> a good idea to put an upper limit on the number of supported aliases
> that can be registered.  Will fix.
> 
> Thanks Michael,
> 
> -Greg
> 
> 


Avi, can you elaborate on why do we want to map multiple fds
to the same gsi? I think it's better to allow a 1:1 mapping
only: if many processes want to trigger interrupts they can
all write to the same fd.

-- 
MST
