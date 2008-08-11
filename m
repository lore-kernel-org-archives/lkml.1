Return-Path: <linux-kernel-owner+w=401wt.eu-S1752305AbYHKJ3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbYHKJ3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 05:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbYHKJ3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 05:29:31 -0400
Received: from il.qumranet.com ([212.179.150.194]:12818 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbYHKJ3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 05:29:30 -0400
Message-ID: <48A00678.20804@qumranet.com>
Date: Mon, 11 Aug 2008 12:29:28 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: kvm-devel <kvm@vger.kernel.org>, Anthony Liguori <aliguori@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] reduce kvm stack usage in kvm_arch_vm_ioctl()
References: <1217874693-28398-1-git-send-email-dave@linux.vnet.ibm.com>
In-Reply-To: <1217874693-28398-1-git-send-email-dave@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please use avi@qumranet.com, not avi@argo.co.il)

Dave Hansen wrote:
> On my machine with gcc 3.4, kvm uses ~2k of stack in a few
> select functions.  This is mostly because gcc fails to
> notice that the different case: statements could have their
> stack usage combined.  It overflows very nicely if interrupts
> happen during one of these large uses.
>
> This patch uses two methods for reducing stack usage.
> 1. dynamically allocate large objects instead of putting
>    on the stack.
> 2. Use a union{} member for all of the case variables. This
>    tricks gcc into combining them all into a single stack
>    allocation.
>   

Missing signoff.

> ---
>  arch/x86/kvm/x86.c |  116 ++++++++++++++++++++++++++++++++--------------------
>  1 files changed, 72 insertions(+), 44 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0d682fc..9d77da1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1624,12 +1624,73 @@ out:
>  	return r;
>  }
>  
> +static inline int kvm_arch_vm_irqchip_ioctl(struct kvm *kvm, void *argp,
> +					    unsigned int ioctl)
> +{
> +	int ret = 0;
> +	struct kvm_irqchip *chip = kmalloc(sizeof(struct kvm_irqchip), GFP_KERNEL);
> +
> +	if (!chip)
> +		return -ENOMEM;
> +
> +	/* cheaper than the copy, so do this first */
> +	if (!irqchip_in_kernel(kvm)) {
> +		ret = -ENXIO;
> +		goto out;
> +	}
> +	if (copy_from_user(chip, argp, sizeof(struct kvm_irqchip))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +	switch (ioctl) {
> +	case KVM_GET_IRQCHIP:
> +		ret = kvm_vm_ioctl_get_irqchip(kvm, chip);
> +		if (ret)
> +			goto out;
> +		ret = copy_to_user(argp, chip, sizeof(struct kvm_irqchip));
> +		if (ret) {
> +			ret = -EFAULT;
> +			goto out;
> +		}
> +		break;
> +	case KVM_SET_IRQCHIP:
> +		ret = kvm_vm_ioctl_set_irqchip(kvm, chip);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +out:
> +	kfree(chip);
> +	return ret;
> +}
> +
> +
>   

Please fold this back into the parent function.  It will cause a bit of 
code duplication, but I'd like to keep the patch small and obvious since 
it needs to be backported.  Later patches can refactor the code to 
reduce the duplication (these won't be backported obviously).

> +static inline int x86_kvm_vm_ioctl_set_memory_region(struct kvm *kvm, void *argp)
> +{
> +	struct kvm_memory_region kvm_mem;
> +	struct kvm_userspace_memory_region kvm_userspace_mem;
> +
> +	if (copy_from_user(&kvm_mem, argp, sizeof(struct kvm_memory_region)))
> +		return -EFAULT;
> +	kvm_userspace_mem.slot = kvm_mem.slot;
> +	kvm_userspace_mem.flags = kvm_mem.flags;
> +	kvm_userspace_mem.guest_phys_addr = kvm_mem.guest_phys_addr;
> +	kvm_userspace_mem.memory_size = kvm_mem.memory_size;
> +	return kvm_vm_ioctl_set_memory_region(kvm, &kvm_userspace_mem, 0);
> +}
>   

Ditto.




-- 
error compiling committee.c: too many arguments to function

