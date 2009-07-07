Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbZGGLVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbZGGLVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 07:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbZGGLVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 07:21:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50833 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086AbZGGLVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 07:21:12 -0400
Date: Tue, 7 Jul 2009 14:20:35 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [KVM PATCH v9 1/2] KVM: make io_bus interface more robust
Message-ID: <20090707112035.GB3647@redhat.com>
References: <20090706202742.14222.65548.stgit@dev.haskins.net> <20090706203315.14222.25490.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090706203315.14222.25490.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me. One thing that's kind of ugly is the cleanup in i8254,
see below. And a couple of other style comments.

On Mon, Jul 06, 2009 at 04:33:15PM -0400, Gregory Haskins wrote:
> Today kvm_io_bus_regsiter_dev() returns void and will internally BUG_ON
> if it fails.  We want to create dynamic MMIO/PIO entries driven from
> userspace later in the series, so we need to enhance the code to be more
> robust with the following changes:
> 
>    1) Add a return value to the registration function
>    2) Fix up all the callsites to check the return code, handle any
>       failures, and percolate the error up to the caller.
>    3) Add an unregister function that collapses holes in the array
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
> 
>  arch/x86/kvm/i8254.c      |   22 ++++++++++++++++++++--
>  arch/x86/kvm/i8259.c      |    9 ++++++++-
>  include/linux/kvm_host.h  |   10 +++++++---
>  virt/kvm/coalesced_mmio.c |    8 ++++++--
>  virt/kvm/ioapic.c         |    8 ++++++--
>  virt/kvm/kvm_main.c       |   41 ++++++++++++++++++++++++++++++++++++-----
>  6 files changed, 83 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
> index 8c3ac30..298312d 100644
> --- a/arch/x86/kvm/i8254.c
> +++ b/arch/x86/kvm/i8254.c
> @@ -591,6 +591,7 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
>  {
>  	struct kvm_pit *pit;
>  	struct kvm_kpit_state *pit_state;
> +	int ret;
>  
>  	pit = kzalloc(sizeof(struct kvm_pit), GFP_KERNEL);
>  	if (!pit)
> @@ -625,14 +626,31 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
>  	kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
>  
>  	kvm_iodevice_init(&pit->dev, &pit_dev_ops);
> -	__kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
> +	ret = __kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
> +	if (ret < 0)
> +		goto fail;
>  
>  	if (flags & KVM_PIT_SPEAKER_DUMMY) {
>  		kvm_iodevice_init(&pit->speaker_dev, &speaker_dev_ops);
> -		__kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
> +		ret = __kvm_io_bus_register_dev(&kvm->pio_bus,
> +						&pit->speaker_dev);
> +		if (ret < 0)
> +			goto fail;
>  	}
>  
>  	return pit;
> +
> +fail:
> +	if (flags & KVM_PIT_SPEAKER_DUMMY)
> +		__kvm_io_bus_unregister_dev(&kvm->pio_bus, &pit->speaker_dev);
> +
> +	__kvm_io_bus_unregister_dev(&kvm->pio_bus, &pit->dev);

The above works because we scan the whole array; so it's safe to call
unregister on a device that we didn't register, and even on a device we
didn't init. But IMO it's cleaner not to assume this and do
cleanup properly. No?

> +
> +	if (pit->irq_source_id >= 0)
> +		kvm_free_irq_source_id(kvm, pit->irq_source_id);
> +
> +	kfree(pit);
> +	return NULL;
>  }
>  
>  void kvm_free_pit(struct kvm *kvm)
> diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
> index 1d1bb75..670e426 100644
> --- a/arch/x86/kvm/i8259.c
> +++ b/arch/x86/kvm/i8259.c
> @@ -536,6 +536,8 @@ static const struct kvm_io_device_ops picdev_ops = {
>  struct kvm_pic *kvm_create_pic(struct kvm *kvm)
>  {
>  	struct kvm_pic *s;
> +	int ret;
> +
>  	s = kzalloc(sizeof(struct kvm_pic), GFP_KERNEL);
>  	if (!s)
>  		return NULL;
> @@ -552,6 +554,11 @@ struct kvm_pic *kvm_create_pic(struct kvm *kvm)
>  	 * Initialize PIO device
>  	 */
>  	kvm_iodevice_init(&s->dev, &picdev_ops);
> -	kvm_io_bus_register_dev(kvm, &kvm->pio_bus, &s->dev);
> +	ret = kvm_io_bus_register_dev(kvm, &kvm->pio_bus, &s->dev);
> +	if (ret < 0) {

I thought the function returns 0 on success?
If so can we just if (ret) all over?

> +		kfree(s);
> +		return NULL;
> +	}
> +

kill empty line

>  	return s;
>  }
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 8e04a34..306bc67 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -64,10 +64,14 @@ int kvm_io_bus_write(struct kvm_io_bus *bus, gpa_t addr, int len,
>  		     const void *val);
>  int kvm_io_bus_read(struct kvm_io_bus *bus, gpa_t addr, int len,
>  		    void *val);
> -void __kvm_io_bus_register_dev(struct kvm_io_bus *bus,
> +int __kvm_io_bus_register_dev(struct kvm_io_bus *bus,
> +			       struct kvm_io_device *dev);
> +int kvm_io_bus_register_dev(struct kvm *kvm, struct kvm_io_bus *bus,
> +			    struct kvm_io_device *dev);
> +void __kvm_io_bus_unregister_dev(struct kvm_io_bus *bus,
> +				 struct kvm_io_device *dev);
> +void kvm_io_bus_unregister_dev(struct kvm *kvm, struct kvm_io_bus *bus,
>  			       struct kvm_io_device *dev);
> -void kvm_io_bus_register_dev(struct kvm *kvm, struct kvm_io_bus *bus,
> -			     struct kvm_io_device *dev);
>  
>  struct kvm_vcpu {
>  	struct kvm *kvm;
> diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
> index 0352f81..04d69cd 100644
> --- a/virt/kvm/coalesced_mmio.c
> +++ b/virt/kvm/coalesced_mmio.c
> @@ -92,6 +92,7 @@ static const struct kvm_io_device_ops coalesced_mmio_ops = {
>  int kvm_coalesced_mmio_init(struct kvm *kvm)
>  {
>  	struct kvm_coalesced_mmio_dev *dev;
> +	int ret;
>  
>  	dev = kzalloc(sizeof(struct kvm_coalesced_mmio_dev), GFP_KERNEL);
>  	if (!dev)
> @@ -100,9 +101,12 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
>  	kvm_iodevice_init(&dev->dev, &coalesced_mmio_ops);
>  	dev->kvm = kvm;
>  	kvm->coalesced_mmio_dev = dev;
> -	kvm_io_bus_register_dev(kvm, &kvm->mmio_bus, &dev->dev);
>  
> -	return 0;
> +	ret = kvm_io_bus_register_dev(kvm, &kvm->mmio_bus, &dev->dev);
> +	if (ret < 0)
> +		kfree(dev);
> +

kill empty line

> +	return ret;
>  }
>  
>  int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
> diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
> index 92496ff..048836d 100644
> --- a/virt/kvm/ioapic.c
> +++ b/virt/kvm/ioapic.c
> @@ -340,6 +340,7 @@ static const struct kvm_io_device_ops ioapic_mmio_ops = {
>  int kvm_ioapic_init(struct kvm *kvm)
>  {
>  	struct kvm_ioapic *ioapic;
> +	int ret;
>  
>  	ioapic = kzalloc(sizeof(struct kvm_ioapic), GFP_KERNEL);
>  	if (!ioapic)
> @@ -348,7 +349,10 @@ int kvm_ioapic_init(struct kvm *kvm)
>  	kvm_ioapic_reset(ioapic);
>  	kvm_iodevice_init(&ioapic->dev, &ioapic_mmio_ops);
>  	ioapic->kvm = kvm;
> -	kvm_io_bus_register_dev(kvm, &kvm->mmio_bus, &ioapic->dev);
> -	return 0;
> +	ret = kvm_io_bus_register_dev(kvm, &kvm->mmio_bus, &ioapic->dev);
> +	if (ret < 0)
> +		kfree(ioapic);

kill empty line

> +
> +	return ret;
>  }
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 05b6bc7..11595c7 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2533,21 +2533,52 @@ int kvm_io_bus_read(struct kvm_io_bus *bus, gpa_t addr, int len, void *val)
>  	return -EOPNOTSUPP;
>  }
>  
> -void kvm_io_bus_register_dev(struct kvm *kvm, struct kvm_io_bus *bus,
> +int kvm_io_bus_register_dev(struct kvm *kvm, struct kvm_io_bus *bus,
>  			     struct kvm_io_device *dev)

Let's document return value?

>  {
> +	int ret;
> +
>  	down_write(&kvm->slots_lock);
> -	__kvm_io_bus_register_dev(bus, dev);
> +	ret = __kvm_io_bus_register_dev(bus, dev);
>  	up_write(&kvm->slots_lock);

kill empty line? this one is kind of iffy

> +
> +	return ret;
>  }
>  
>  /* An unlocked version. Caller must have write lock on slots_lock. */
> -void __kvm_io_bus_register_dev(struct kvm_io_bus *bus,
> -			     struct kvm_io_device *dev)
> +int __kvm_io_bus_register_dev(struct kvm_io_bus *bus,
> +			      struct kvm_io_device *dev)
>  {
> -	BUG_ON(bus->dev_count > (NR_IOBUS_DEVS-1));
> +	if (bus->dev_count > (NR_IOBUS_DEVS-1))

as long as we are touching this: (NR_IOBUS_DEVS-1) -> NR_IOBUS_DEVS - 1?

> +		return -ENOSPC;
>  
>  	bus->devs[bus->dev_count++] = dev;

kill empty line

> +
> +	return 0;
> +}
> +
> +void kvm_io_bus_unregister_dev(struct kvm *kvm,
> +			       struct kvm_io_bus *bus,
> +			       struct kvm_io_device *dev)
> +{
> +	down_write(&kvm->slots_lock);
> +	__kvm_io_bus_unregister_dev(bus, dev);
> +	up_write(&kvm->slots_lock);
> +}
> +
> +/* An unlocked version. Caller must have write lock on slots_lock. */
> +void __kvm_io_bus_unregister_dev(struct kvm_io_bus *bus,
> +				 struct kvm_io_device *dev)
> +{
> +	int i;
> +
> +	for (i = 0; i < bus->dev_count; i++) {
> +

kill empty line

> +		if (bus->devs[i] == dev) {
> +			bus->devs[i] = bus->devs[--bus->dev_count];
> +			break;
> +		}
> +	}

no {} around single statement


>  }
>  
>  static struct notifier_block kvm_cpu_notifier = {
