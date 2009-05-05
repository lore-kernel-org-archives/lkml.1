Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbZEEPpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbZEEPpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 11:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZEEPpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 11:45:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45716 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbZEEPpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 11:45:13 -0400
Message-ID: <4A005F05.30409@redhat.com>
Date: Tue, 05 May 2009 18:45:09 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v4 2/2] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <20090504175750.26758.7023.stgit@dev.haskins.net>
In-Reply-To: <20090504175750.26758.7023.stgit@dev.haskins.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> KVM provides a complete virtual system environment for guests, including
> support for injecting interrupts modeled after the real exception/interrupt
> facilities present on the native platform (such as the IDT on x86).
> Virtual interrupts can come from a variety of sources (emulated devices,
> pass-through devices, etc) but all must be injected to the guest via
> the KVM infrastructure.  This patch adds a new mechanism to inject a specific
> interrupt to a guest using a decoupled eventfd mechnanism:  Any legal signal
> on the irqfd (using eventfd semantics from either userspace or kernel) will
> translate into an injected interrupt in the guest at the next available
> interrupt window.
>
>  
> +struct kvm_irqfd {
> +	__u32 gsi;
> +	__u32 flags;
> +};
> +
>   

Please add some reserved space here.

> +int
> +kvm_irqfd(struct kvm *kvm, int gsi, int flags)
> +{
> +	struct _irqfd *irqfd;
> +	struct file *file = NULL;
> +	int fd = -1;
> +	int ret;
> +
> +	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
> +	if (!irqfd)
> +		return -ENOMEM;
> +
> +	irqfd->kvm = kvm;
>   

You need to increase the refcount on struct kvm here.  Otherwise evil 
userspace will create an irqfd, close the vm and vcpu fds, and inject an 
interrupt.

Otherwise, looks good.

-- 
error compiling committee.c: too many arguments to function

