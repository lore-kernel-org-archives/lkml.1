Return-Path: <linux-kernel-owner+w=401wt.eu-S1759512AbZEFP3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512AbZEFP3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbZEFP3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:29:30 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:42952 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbZEFP33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:29:29 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 6 May 2009 08:24:53 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: viro@ZenIV.linux.org.uk, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com
Subject: Re: [KVM PATCH v4 2/2] kvm: add support for irqfd via eventfd-notification
 interface
In-Reply-To: <4A0175F0.1090705@novell.com>
Message-ID: <alpine.DEB.1.10.0905060818000.32007@makko.or.mcafeemobile.com>
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <20090504175750.26758.7023.stgit@dev.haskins.net> <4A0175F0.1090705@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009, Gregory Haskins wrote:

> Al, Davide,
> 
> Gregory Haskins wrote:
> > +
> > +int
> > +kvm_irqfd(struct kvm *kvm, int gsi, int flags)
> > +{
> > +	struct _irqfd *irqfd;
> > +	struct file *file = NULL;
> > +	int fd = -1;
> > +	int ret;
> > +
> > +	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
> > +	if (!irqfd)
> > +		return -ENOMEM;
> > +
> > +	irqfd->kvm = kvm;
> > +	irqfd->gsi = gsi;
> > +	INIT_LIST_HEAD(&irqfd->list);
> > +	INIT_WORK(&irqfd->work, irqfd_inject);
> > +
> > +	/*
> > +	 * We re-use eventfd for irqfd, and therefore will embed the eventfd
> > +	 * lifetime in the irqfd.
> > +	 */
> > +	file = eventfd_file_create(0, 0);
> > +	if (IS_ERR(file)) {
> > +		ret = PTR_ERR(file);
> > +		goto fail;
> > +	}
> > +
> > +	irqfd->file = file;
> > +
> > +	/*
> > +	 * Install our own custom wake-up handling so we are notified via
> > +	 * a callback whenever someone signals the underlying eventfd
> > +	 */
> > +	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
> > +	init_poll_funcptr(&irqfd->pt, irqfd_ptable_queue_proc);
> > +
> > +	ret = file->f_op->poll(file, &irqfd->pt);
> > +	if (ret < 0)
> > +		goto fail;
> > +
> > +	mutex_lock(&kvm->lock);
> > +	list_add_tail(&irqfd->list, &kvm->irqfds);
> > +	mutex_unlock(&kvm->lock);
> > +
> > +	ret = get_unused_fd();
> > +	if (ret < 0)
> > +		goto fail;
> > +
> > +	fd = ret;
> > +
> > +	fd_install(fd, file);
> >   
> 
> Can you comment on whether this function needs to take an additional
> reference on file here?  (one for the one held by userspace/fd, and the
> other for irqfd->file)  My instinct is telling me this may be currently
> broken, but I am not sure.

I don't know exactly how it is used, but looks broken. If the fd is 
returned to userspace, and userspace closes the fd, you will leak the 
irqfd*. If you do an extra fget(), you will never know if the userspace 
closed the last-1 instance of the eventfd file*.
What is likely needed, is add a callback to eventfd_file_create(), so that 
the eventfd can call your callback on ->release, and give you a chance to 
perform proper cleanup of the irqfd*.



- Davide


