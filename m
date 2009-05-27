Return-Path: <linux-kernel-owner+w=401wt.eu-S1760411AbZE0N4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760411AbZE0N4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 09:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbZE0N4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 09:56:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43778 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297AbZE0N4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 09:56:05 -0400
Date: Wed, 27 May 2009 16:55:59 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, mtosatti@redhat.com
Subject: Re: [KVM PATCH v10] kvm: add support for irqfd
Message-ID: <20090527130447.GA11643@redhat.com>
References: <20090520142234.22285.72274.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090520142234.22285.72274.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 10:30:49AM -0400, Gregory Haskins wrote:
> +static int
> +kvm_assign_irqfd(struct kvm *kvm, int fd, int gsi)
> +{
> +	struct _irqfd *irqfd;
> +	struct file *file = NULL;
> +	int ret;
> +
> +	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
> +	if (!irqfd)
> +		return -ENOMEM;
> +
> +	irqfd->kvm = kvm;
> +	irqfd->gsi = gsi;
> +	INIT_LIST_HEAD(&irqfd->list);
> +	INIT_WORK(&irqfd->work, irqfd_inject);
> +
> +	/*
> +	 * Embed the file* lifetime in the irqfd.
> +	 */
> +	file = fget(fd);
> +	if (IS_ERR(file)) {
> +		ret = PTR_ERR(file);
> +		goto fail;
> +	}

So we get a reference to a file, and unless the user is nice to us, it
will only be dropped when kvm char device file is closed?
I think this will deadlock if the fd in question is the open kvm char device.


-- 
MST
