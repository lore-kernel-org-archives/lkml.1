Return-Path: <linux-kernel-owner+w=401wt.eu-S1760014AbZE0JEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014AbZE0JEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 05:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZE0JDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 05:03:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40895 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbZE0JDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 05:03:53 -0400
Message-ID: <4A1D01F8.8080508@redhat.com>
Date: Wed, 27 May 2009 12:03:52 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davide@xmailserver.org,
       mtosatti@redhat.com
Subject: Re: [KVM PATCH v4 3/3] kvm: add iosignalfd support
References: <20090526191010.20860.75372.stgit@dev.haskins.net> <20090526191539.20860.1385.stgit@dev.haskins.net>
In-Reply-To: <20090526191539.20860.1385.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> iosignalfd is a mechanism to register PIO/MMIO regions to trigger an eventfd
> signal when written to by a guest.  Host userspace can register any arbitrary
> IO address with a corresponding eventfd and then pass the eventfd to a
> specific end-point of interest for handling.
>
> Normal IO requires a blocking round-trip since the operation may cause
> side-effects in the emulated model or may return data to the caller.
> Therefore, an IO in KVM traps from the guest to the host, causes a VMX/SVM
> "heavy-weight" exit back to userspace, and is ultimately serviced by qemu's
> device model synchronously before returning control back to the vcpu.
>
> However, there is a subclass of IO which acts purely as a trigger for
> other IO (such as to kick off an out-of-band DMA request, etc).  For these
> patterns, the synchronous call is particularly expensive since we really
> only want to simply get our notification transmitted asychronously and
> return as quickly as possible.  All the sychronous infrastructure to ensure
> proper data-dependencies are met in the normal IO case are just unecessary
> overhead for signalling.  This adds additional computational load on the
> system, as well as latency to the signalling path.
>
> Therefore, we provide a mechanism for registration of an in-kernel trigger
> point that allows the VCPU to only require a very brief, lightweight
> exit just long enough to signal an eventfd.  This also means that any
> clients compatible with the eventfd interface (which includes userspace
> and kernelspace equally well) can now register to be notified. The end
> result should be a more flexible and higher performance notification API
> for the backend KVM hypervisor and perhipheral components.
>
> To test this theory, we built a test-harness called "doorbell".  This
> module has a function called "doorbell_ring()" which simply increments a
> counter for each time the doorbell is signaled.  It supports signalling
> from either an eventfd, or an ioctl().
>
> We then wired up two paths to the doorbell: One via QEMU via a registered
> io region and through the doorbell ioctl().  The other is direct via
> iosignalfd.
>
> You can download this test harness here:
>
> ftp://ftp.novell.com/dev/ghaskins/doorbell.tar.bz2
>
> The measured results are as follows:
>
> qemu-mmio:       110000 iops, 9.09us rtt
> iosignalfd-mmio: 200100 iops, 5.00us rtt
> iosignalfd-pio:  367300 iops, 2.72us rtt
>
> I didn't measure qemu-pio, because I have to figure out how to register a
> PIO region with qemu's device model, and I got lazy.  However, for now we
> can extrapolate based on the data from the NULLIO runs of +2.56us for MMIO,
> and -350ns for HC, we get:
>
> qemu-pio:      153139 iops, 6.53us rtt
> iosignalfd-hc: 412585 iops, 2.37us rtt
>
> these are just for fun, for now, until I can gather more data.
>
> Here is a graph for your convenience:
>
> http://developer.novell.com/wiki/images/7/76/Iofd-chart.png
>
> The conclusion to draw is that we save about 4us by skipping the userspace
> hop.
>
> +/* writes trigger an event */
> +static void
> +iosignalfd_write(struct kvm_io_device *this, gpa_t addr, int len,
> +		 const void *val)
> +{
> +	struct _iosignalfd *iosignalfd = (struct _iosignalfd *)this->private;
> +
> +	eventfd_signal(iosignalfd->file, 1);
> +}
>   

I much prefer including kvm_io_device inside _iosignalfd and using 
container_of() instead of ->private.  But that is of course unrelated to 
this patch and is not a requirement.

> +
> +static int
> +kvm_assign_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
> +{
> +	int                 pio = args->flags & KVM_IOSIGNALFD_FLAG_PIO;
> +	struct kvm_io_bus  *bus = pio ? &kvm->pio_bus : &kvm->mmio_bus;
> +	struct _iosignalfd *iosignalfd;
> +	struct file        *file;
> +	int                 ret;
> +
> +	file = eventfd_fget(args->fd);
> +	if (IS_ERR(file)) {
> +		ret = PTR_ERR(file);
> +		printk(KERN_ERR "iosignalfd: failed to get %d eventfd: %d\n",
> +		       args->fd, ret);
>   

drop the printk, we don't want to let users spam dmesg.

> +		return ret;
> +	}
> +
> +	iosignalfd = kzalloc(sizeof(*iosignalfd), GFP_KERNEL);
> +	if (!iosignalfd) {
> +		printk(KERN_ERR "iosignalfd: memory pressure\n");
>   

here too.

> +	ret = kvm_io_bus_register_dev(bus, &iosignalfd->dev);
> +	if (ret < 0) {
> +		printk(KERN_ERR "iosignalfd: failed to register IODEV: %d\n",
> +		       ret);
>   

and here etc.

What happens if you register to iosignalfds for the same address but 
with different cookies (a very practical scenario)?

-- 
error compiling committee.c: too many arguments to function

