Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbZENJsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbZENJsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 05:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZENJr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 05:47:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48900 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064AbZENJr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 05:47:56 -0400
Message-ID: <4A0BE8CA.7080801@redhat.com>
Date: Thu, 14 May 2009 12:47:54 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v7 2/3] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090512181134.26131.10023.stgit@dev.haskins.net> <20090512182655.26131.53824.stgit@dev.haskins.net>
In-Reply-To: <20090512182655.26131.53824.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

>  		r = 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index 3db5d8d..dfc4bcc 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -415,6 +415,7 @@ struct kvm_trace_rec {
>  #define KVM_CAP_ASSIGN_DEV_IRQ 29
>  /* Another bug in KVM_SET_USER_MEMORY_REGION fixed: */
>  #define KVM_CAP_JOIN_MEMORY_REGIONS_WORKS 30
> +#define KVM_CAP_EVENTFD 31
>   

Let's keep a fine granularity and call it IRQFD.

> +
> +int
> +kvm_deassign_irqfd(struct kvm *kvm, int fd)
> +{
> +	struct _irqfd *irqfd, *tmp;
> +
> +	mutex_lock(&kvm->lock);
> +
> +	/*
> +	 * linear search isn't brilliant, but this should be a infrequent
> +	 * operation and the list should not grow very large
> +	 */
> +	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list) {
> +		if (irqfd->fd != fd)
> +			continue;
>   

Please fget() the new fd and compare the filps; fds aren't meaningful in 
the kernel.  You can also drop _irqfd::fd.

It may also be useful to compare the gsi, this allows a 
"make-before-break" switchover:

- guest reroutes irq to a different gsi
- associate irqfd with new gsi
- disassociate irqfd from old gsi

> +
> +		irqfd_release(irqfd);
> +		mutex_unlock(&kvm->lock);
> +		return 0;
>   

Don't return, userspace may have multiple associations?


-- 
error compiling committee.c: too many arguments to function

