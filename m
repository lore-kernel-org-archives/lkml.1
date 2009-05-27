Return-Path: <linux-kernel-owner+w=401wt.eu-S1760411AbZE0Iyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760411AbZE0Iyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 04:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbZE0Iyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 04:54:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48997 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbZE0Iyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 04:54:31 -0400
Message-ID: <4A1CFFC5.9070100@redhat.com>
Date: Wed, 27 May 2009 11:54:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davide@xmailserver.org,
       mtosatti@redhat.com
Subject: Re: [KVM PATCH v4 2/3] kvm: make io_bus interface more robust
References: <20090526191010.20860.75372.stgit@dev.haskins.net> <20090526191534.20860.38511.stgit@dev.haskins.net>
In-Reply-To: <20090526191534.20860.38511.stgit@dev.haskins.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Today kvm_io_bus_regsiter_dev() returns void and will internally BUG_ON if it
> fails.  We want to create dynamic MMIO/PIO entries driven from userspace later
> in the series, so we need to enhance the code to be more robust with the
> following changes:
>
>    1) Add a return value to the registration function
>    2) Fix up all the callsites to check the return code, handle any
>       failures, and percolate the error up to the caller.
>    3) Refactor io_bus to allow "holes" in the array so device hotplug
>       can add/remove devices arbitrarily.
>    4) Add an unregister function
>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
>
>  arch/x86/kvm/i8254.c      |   34 ++++++++++++++++++++++---------
>  arch/x86/kvm/i8259.c      |    9 +++++++-
>  include/linux/kvm_host.h  |    8 +++++--
>  virt/kvm/coalesced_mmio.c |    8 ++++++-
>  virt/kvm/ioapic.c         |    9 ++++++--
>  virt/kvm/kvm_main.c       |   49 +++++++++++++++++++++++++++++++++++++++------
>  6 files changed, 92 insertions(+), 25 deletions(-)
>
> diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
> index 584e3d3..6cf84d4 100644
> --- a/arch/x86/kvm/i8254.c
> +++ b/arch/x86/kvm/i8254.c
> @@ -564,36 +564,40 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
>  {
>  	struct kvm_pit *pit;
>  	struct kvm_kpit_state *pit_state;
> +	int ret;
>  
>  	pit = kzalloc(sizeof(struct kvm_pit), GFP_KERNEL);
>  	if (!pit)
>  		return NULL;
>  
>  	pit->irq_source_id = kvm_request_irq_source_id(kvm);
> -	if (pit->irq_source_id < 0) {
> -		kfree(pit);
> -		return NULL;
> -	}
> -
> -	mutex_init(&pit->pit_state.lock);
> -	mutex_lock(&pit->pit_state.lock);
> -	spin_lock_init(&pit->pit_state.inject_lock);
> +	if (pit->irq_source_id < 0)
> +		goto fail;
>  
>  	/* Initialize PIO device */
>  	pit->dev.read = pit_ioport_read;
>  	pit->dev.write = pit_ioport_write;
>  	pit->dev.in_range = pit_in_range;
>  	pit->dev.private = pit;
> -	kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
> +	ret = kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
> +	if (ret < 0)
> +		goto fail;
>  
>  	if (flags & KVM_PIT_SPEAKER_DUMMY) {
>  		pit->speaker_dev.read = speaker_ioport_read;
>  		pit->speaker_dev.write = speaker_ioport_write;
>  		pit->speaker_dev.in_range = speaker_in_range;
>  		pit->speaker_dev.private = pit;
> -		kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
> +		ret = kvm_io_bus_register_dev(&kvm->pio_bus,
> +					      &pit->speaker_dev);
> +		if (ret < 0)
> +			goto fail;
>  	}
>  
> +	mutex_init(&pit->pit_state.lock);
> +	mutex_lock(&pit->pit_state.lock);
> +	spin_lock_init(&pit->pit_state.inject_lock);
> +
>   

You are registering the PIT before it is initialized.  That exposes a 
race.  The original code also did that, but at least the pit lock was 
held while this was done.

>  	kvm->arch.vpit = pit;
>  	pit->kvm = kvm;
>  
> @@ -613,6 +617,16 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
>  	kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
>  
>  	return pit;
> +
> +fail:
> +	kvm_io_bus_unregister_dev(&kvm->pio_bus, &pit->speaker_dev);
>   

There's an option now to avoid speaker_dev, so this needs to be conditional.

> +	kvm_io_bus_unregister_dev(&kvm->pio_bus, &pit->dev);
> +
> +	if (pit->irq_source_id >= 0)
> +		kvm_free_irq_source_id(kvm, pit->irq_source_id);
> +
> +	kfree(pit);
> +	return NULL;
>  }
>  
> @@ -52,7 +52,7 @@ extern struct kmem_cache *kvm_vcpu_cache;
>   * in one place.
>   */
>  struct kvm_io_bus {
> -	int                   dev_count;
> +	spinlock_t lock;
>  #define NR_IOBUS_DEVS 6
>  	struct kvm_io_device *devs[NR_IOBUS_DEVS];
>  };
> @@ -61,8 +61,10 @@ void kvm_io_bus_init(struct kvm_io_bus *bus);
>  void kvm_io_bus_destroy(struct kvm_io_bus *bus);
>  struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
>  					  gpa_t addr, int len, int is_write);
> -void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
> -			     struct kvm_io_device *dev);
> +int kvm_io_bus_register_dev(struct kvm_io_bus *bus,
> +			    struct kvm_io_device *dev);
> +int kvm_io_bus_unregister_dev(struct kvm_io_bus *bus,
> +			    struct kvm_io_device *dev);
>  
>   

unregister() should return void.  There's really nothing you can do to 
recover from a failure.

>  
> @@ -2453,21 +2455,54 @@ struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
>  {
>  	int i;
>  
> -	for (i = 0; i < bus->dev_count; i++) {
> +	for (i = 0; i < NR_IOBUS_DEVS; i++) {
>  		struct kvm_io_device *pos = bus->devs[i];
>  
> -		if (pos->in_range(pos, addr, len, is_write))
> +		if (pos && pos->in_range(pos, addr, len, is_write))
>  			return pos;
>  	}
>   

Let's keep dev_count, and just move things around on unregister.

 


-- 
error compiling committee.c: too many arguments to function

