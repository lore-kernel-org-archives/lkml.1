Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbZD0Iza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbZD0Iza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 04:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbZD0IzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 04:55:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35601 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbZD0IzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 04:55:14 -0400
Message-ID: <49F572EF.4010909@redhat.com>
Date: Mon, 27 Apr 2009 11:55:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v2 2/2] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090424042142.1796.60756.stgit@dev.haskins.net> <20090424042518.1796.65593.stgit@dev.haskins.net>
In-Reply-To: <20090424042518.1796.65593.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> This allows an eventfd to be registered as an irq source with a guest.  Any
> signaling operation on the eventfd (via userspace or kernel) will inject
> the registered GSI at the next available window.
>
>  
> +struct kvm_irqfd {
> +	__u32 fd;
> +	__u32 gsi;
> +};
> +
>   

I think it's better to have ioctl create and return the fd.  This way we 
aren't tied to eventfd (though it makes a lot of sense to use it).

Also, please add a flags field and some padding so we can extend it later.

> +
> +#include <linux/kvm_host.h>
> +#include <linux/eventfd.h>
> +#include <linux/workqueue.h>
> +#include <linux/wait.h>
> +#include <linux/poll.h>
> +#include <linux/file.h>
> +#include <linux/list.h>
> +
> +struct _irqfd {
> +	struct kvm               *kvm;
> +	int                       gsi;
> +	struct file              *file;
> +	struct list_head          list;
> +	poll_table                pt;
> +	wait_queue_head_t        *wqh;
> +	wait_queue_t              wait;
> +	struct work_struct        work;
> +};
> +
> +static void
> +irqfd_inject(struct work_struct *work)
> +{
> +	struct _irqfd *irqfd = container_of(work, struct _irqfd, work);
> +	struct kvm *kvm = irqfd->kvm;
> +
> +	mutex_lock(&kvm->lock);
> +	kvm_set_irq(kvm, kvm->irqfd.src, irqfd->gsi, 1);
>   

Need to lower the irq too (though irqfd only supports edge triggered 
interrupts).

> +	mutex_unlock(&kvm->lock);
> +}
> +
> +static int
> +irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
> +{
> +	struct _irqfd *irqfd = container_of(wait, struct _irqfd, wait);
> +
> +	/*
> +	 * The eventfd calls its wake_up with interrupts disabled,
> +	 * so we need to defer the IRQ injection until later since we need
> +	 * to acquire the kvm->lock to do so.
> +	 */
> +	schedule_work(&irqfd->work);
> +
> +	return 0;
> +}
>   

One day we'll have lockless injection and we'll want to drop this.  I 
guess if we create the fd ourselves we can make it work, but I don't see 
how we can do this with eventfd.

> +int
> +kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
> +{
> +	struct _irqfd *irqfd;
> +	struct file *file;
> +	int ret;
> +
> +	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
> +	if (!irqfd)
> +		return -ENOMEM;
> +
> +	irqfd->kvm = kvm;
> +	irqfd->gsi = gsi;
> +	INIT_LIST_HEAD(&irqfd->list);
> +	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
> +	init_poll_funcptr(&irqfd->pt, irqfd_ptable_queue_proc);
> +	INIT_WORK(&irqfd->work, irqfd_inject);
> +
> +	file = eventfd_fget(fd);
> +	if (IS_ERR(file)) {
> +		ret = PTR_ERR(file);
> +		goto fail;
> +	}
> +
> +	ret = file->f_op->poll(file, &irqfd->pt);
> +	/* do we need to look for errors in ret? */
>   

Do we?

> +
> +	irqfd->file = file;
> +
> +	mutex_lock(&kvm->lock);
> +	if (kvm->irqfd.src == -1) {
> +		ret = kvm_request_irq_source_id(kvm);
> +		BUG_ON(ret < 0);
>   

I think you can reuse the userspace irq source (since it's just another 
way for userspace to inject an interrupt).  It isn't really needed since 
the irq source stuff is only needed to support level triggered interrupts.

-- 
error compiling committee.c: too many arguments to function

