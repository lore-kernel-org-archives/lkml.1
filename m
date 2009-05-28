Return-Path: <linux-kernel-owner+w=401wt.eu-S1762311AbZE1Ftb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762311AbZE1Ftb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 01:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757904AbZE1FtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 01:49:20 -0400
Received: from sous-sol.org ([216.99.217.87]:40562 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757878AbZE1FtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 01:49:19 -0400
Date: Wed, 27 May 2009 22:49:04 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: avi@redhat.com, chrisw@sous-sol.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v2 2/3] kvm: cleanup io_device code
Message-ID: <20090528054904.GK20823@sequoia.sous-sol.org>
References: <20090527213535.24324.62362.stgit@dev.haskins.net> <20090527213744.24324.82745.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527213744.24324.82745.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gregory Haskins (ghaskins@novell.com) wrote:
> We modernize the io_device code so that we use container_of() instead of
> dev->private, and move the vtable to a separate ops structure
> (theoretically allows better caching for multiple instances of the same
> ops structure)

Looks like a nice cleanup.  Couple minor nits.

> +static struct kvm_io_device_ops pit_dev_ops = {
> +	.read     = pit_ioport_read,
> +	.write    = pit_ioport_write,
> +	.in_range = pit_in_range,
> +};
> +
> +static struct kvm_io_device_ops speaker_dev_ops = {
> +	.read     = speaker_ioport_read,
> +	.write    = speaker_ioport_write,
> +	.in_range = speaker_in_range,
> +};

kvm_io_device_ops instances could be made const.

> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2227,7 +2227,7 @@ static struct kvm_io_device *vcpu_find_pervcpu_dev(struct kvm_vcpu *vcpu,
>  
>  	if (vcpu->arch.apic) {
>  		dev = &vcpu->arch.apic->dev;
> -		if (dev->in_range(dev, addr, len, is_write))
> +		if (dev->ops->in_range(dev, addr, len, is_write))
>  			return dev;

> --- a/virt/kvm/iodev.h
> +++ b/virt/kvm/iodev.h
> @@ -18,7 +18,9 @@
>  
>  #include <linux/kvm_types.h>
>  
> -struct kvm_io_device {
> +struct kvm_io_device;
> +
> +struct kvm_io_device_ops {
>  	void (*read)(struct kvm_io_device *this,
>  		     gpa_t addr,
>  		     int len,
> @@ -30,16 +32,25 @@ struct kvm_io_device {
>  	int (*in_range)(struct kvm_io_device *this, gpa_t addr, int len,
>  			int is_write);
>  	void (*destructor)(struct kvm_io_device *this);
> +};
> +
>  
> -	void             *private;
> +struct kvm_io_device {
> +	struct kvm_io_device_ops *ops;
>  };

Did you plan to extend kvm_io_device struct?

> +static inline void kvm_iodevice_init(struct kvm_io_device *dev,
> +				     struct kvm_io_device_ops *ops)
> +{
> +	dev->ops = ops;
> +}

And similarly, did you have a plan to do more with kvm_iodevice_init()?
Otherwise looking a bit like overkill to me.

> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2456,7 +2456,7 @@ struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
>  	for (i = 0; i < bus->dev_count; i++) {
>  		struct kvm_io_device *pos = bus->devs[i];
>  
> -		if (pos->in_range(pos, addr, len, is_write))
> +		if (kvm_iodevice_inrange(pos, addr, len, is_write))
>  			return pos;
>  	}

You converted this to the helper but not vcpu_find_pervcpu_dev() (not
convinced it actually helps readability, but consistency is good).  BTW,
while there, s/kvm_iodevice_inrange/kvm_iodevice_in_range/ would be nice.

thanks,
-chris
