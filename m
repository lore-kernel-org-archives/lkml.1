Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbZGGLVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbZGGLVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 07:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbZGGLVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 07:21:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50827 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509AbZGGLVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 07:21:02 -0400
Date: Tue, 7 Jul 2009 14:20:25 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [KVM PATCH v9 2/2] KVM: add iosignalfd support
Message-ID: <20090707112024.GA3647@redhat.com>
References: <20090706202742.14222.65548.stgit@dev.haskins.net> <20090706203321.14222.67866.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090706203321.14222.67866.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some comments below. Sorry, I know it's late in the series, but
previously I've been too confused with complicated locking to notice
anything else :(.

On Mon, Jul 06, 2009 at 04:33:21PM -0400, Gregory Haskins wrote:
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
> --------------------
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
> 
>  arch/x86/kvm/x86.c       |    1 
>  include/linux/kvm.h      |   15 ++
>  include/linux/kvm_host.h |   10 +-
>  virt/kvm/eventfd.c       |  280 ++++++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c      |   11 ++
>  5 files changed, 313 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0e74d98..6e4b2f5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1204,6 +1204,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_IRQ_INJECT_STATUS:
>  	case KVM_CAP_ASSIGN_DEV_IRQ:
>  	case KVM_CAP_IRQFD:
> +	case KVM_CAP_IOSIGNALFD:
>  	case KVM_CAP_PIT2:
>  		r = 1;
>  		break;
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index 76c6408..236f12d 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -307,6 +307,19 @@ struct kvm_guest_debug {
>  	struct kvm_guest_debug_arch arch;
>  };
>  
> +#define KVM_IOSIGNALFD_FLAG_TRIGGER   (1 << 0) /* trigger is valid */

can we rename trigger -> value?

> +#define KVM_IOSIGNALFD_FLAG_PIO       (1 << 1) /* is a pio (otherwise mmio) */
> +#define KVM_IOSIGNALFD_FLAG_DEASSIGN  (1 << 2)
> +
> +struct kvm_iosignalfd {
> +	__u64 trigger;

for length <8, it's the 8*len least significant bits that are used, right?
That's a bit ugly ... Maybe just put an 8 byte array here instead, then
the first len bytes are valid.

> +	__u64 addr;        /* legal pio/mmio address */
> +	__u32 len;         /* 1, 2, 4, or 8 bytes    */
> +	__s32 fd;
> +	__u32 flags;
> +	__u8  pad[36];
> +};
> +
>  #define KVM_TRC_SHIFT           16
>  /*
>   * kvm trace categories
> @@ -409,6 +422,7 @@ struct kvm_guest_debug {
>  #define KVM_CAP_PIT2 33
>  #endif
>  #define KVM_CAP_SET_BOOT_CPU_ID 34
> +#define KVM_CAP_IOSIGNALFD 35
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> @@ -517,6 +531,7 @@ struct kvm_irqfd {
>  #define KVM_IRQFD                  _IOW(KVMIO, 0x76, struct kvm_irqfd)
>  #define KVM_CREATE_PIT2		   _IOW(KVMIO, 0x77, struct kvm_pit_config)
>  #define KVM_SET_BOOT_CPU_ID        _IO(KVMIO, 0x78)
> +#define KVM_IOSIGNALFD             _IOW(KVMIO, 0x79, struct kvm_iosignalfd)
>  
>  /*
>   * ioctls for vcpu fds
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 306bc67..5099416 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -154,6 +154,7 @@ struct kvm {
>  		spinlock_t        lock;
>  		struct list_head  items;
>  	} irqfds;
> +	struct list_head iosignalfds;
>  #endif
>  	struct kvm_vm_stat stat;
>  	struct kvm_arch arch;
> @@ -532,19 +533,24 @@ static inline void kvm_free_irq_routing(struct kvm *kvm) {}
>  
>  #ifdef CONFIG_HAVE_KVM_EVENTFD
>  
> -void kvm_irqfd_init(struct kvm *kvm);
> +void kvm_eventfd_init(struct kvm *kvm);
>  int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags);
>  void kvm_irqfd_release(struct kvm *kvm);
> +int kvm_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args);
>  
>  #else
>  
> -static inline void kvm_irqfd_init(struct kvm *kvm) {}
> +static inline void kvm_eventfd_init(struct kvm *kvm) {}
>  static inline int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
>  {
>  	return -EINVAL;
>  }
>  
>  static inline void kvm_irqfd_release(struct kvm *kvm) {}
> +static inline int kvm_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
> +{
> +	return -ENOSYS;
> +}
>  
>  #endif /* CONFIG_HAVE_KVM_EVENTFD */
>  
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 4092b8d..c03b619 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -21,6 +21,7 @@
>   */
>  
>  #include <linux/kvm_host.h>
> +#include <linux/kvm.h>
>  #include <linux/workqueue.h>
>  #include <linux/syscalls.h>
>  #include <linux/wait.h>
> @@ -28,6 +29,9 @@
>  #include <linux/file.h>
>  #include <linux/list.h>
>  #include <linux/eventfd.h>
> +#include <linux/kernel.h>
> +
> +#include "iodev.h"
>  
>  /*
>   * --------------------------------------------------------------------
> @@ -234,10 +238,12 @@ fail:
>  }
>  
>  void
> -kvm_irqfd_init(struct kvm *kvm)
> +kvm_eventfd_init(struct kvm *kvm)
>  {
>  	spin_lock_init(&kvm->irqfds.lock);
>  	INIT_LIST_HEAD(&kvm->irqfds.items);
> +

don't need this empty line

> +	INIT_LIST_HEAD(&kvm->iosignalfds);
>  }
>  
>  /*
> @@ -327,3 +333,275 @@ static void __exit irqfd_module_exit(void)
>  
>  module_init(irqfd_module_init);
>  module_exit(irqfd_module_exit);
> +
> +/*
> + * --------------------------------------------------------------------
> + * iosignalfd: translate a PIO/MMIO memory write to an eventfd signal.
> + *
> + * userspace can register a PIO/MMIO address with an eventfd for recieving

recieving -> receiving

> + * notification when the memory has been touched.
> + * --------------------------------------------------------------------
> + */
> +
> +struct _iosignalfd {
> +	struct list_head     list;
> +	u64                  addr;
> +	size_t               length;

"int length" should be enough: the value is 1, 2, 4 or 8.
and put wildcard near it if you want to save some space

> +	struct eventfd_ctx  *eventfd;
> +	u64                  match;

match -> value

> +	struct kvm_io_device dev;
> +	int                  wildcard:1;

don't use bitfields

> +};
> +
> +static inline struct _iosignalfd *
> +to_iosignalfd(struct kvm_io_device *dev)
> +{
> +	return container_of(dev, struct _iosignalfd, dev);
> +}
> +
> +static void
> +iosignalfd_release(struct _iosignalfd *p)
> +{
> +	eventfd_ctx_put(p->eventfd);
> +	list_del(&p->list);
> +	kfree(p);
> +}
> +
> +static bool
> +iosignalfd_in_range(struct _iosignalfd *p, gpa_t addr, int len, const void *val)
> +{
> +	u64 _val;
> +
> +	if (!(addr == p->addr && len == p->length))

de-morgan's laws can help simplify this

> +		/* address-range must be precise for a hit */

So there's apparently no way to specify that
you want 1,2, or 4 byte writes at address X?

> +		return false;
> +
> +	if (p->wildcard)
> +		/* all else equal, wildcard is always a hit */
> +		return true;
> +
> +	/* otherwise, we have to actually compare the data */
> +
> +	BUG_ON(!IS_ALIGNED((unsigned long)val, len));
> +
> +	switch (len) {
> +	case 1:
> +		_val = *(u8 *)val;
> +		break;
> +	case 2:
> +		_val = *(u16 *)val;
> +		break;
> +	case 4:
> +		_val = *(u32 *)val;
> +		break;
> +	case 8:
> +		_val = *(u64 *)val;
> +		break;
> +	default:
> +		return false;
> +	}
> +
> +	return _val == p->match ? true : false;

Life be simpler if we use an 8 byte array for match
and just do memcmp here.

> +}
> +
> +/*
> + * MMIO/PIO writes trigger an event if the addr/val match
> + */

single line comment can look like this:
/* MMIO/PIO writes trigger an event if the addr/val match */

> +static int
> +iosignalfd_write(struct kvm_io_device *this, gpa_t addr, int len,
> +		 const void *val)
> +{
> +	struct _iosignalfd *p = to_iosignalfd(this);
> +
> +	if (!iosignalfd_in_range(p, addr, len, val))
> +		return -EOPNOTSUPP;
> +
> +	eventfd_signal(p->eventfd, 1);
> +	return 0;
> +}
> +
> +/*
> + * This function is called as KVM is completely shutting down.  We do not
> + * need to worry about locking just nuke anything we have as quickly as possible
> + */
> +static void
> +iosignalfd_destructor(struct kvm_io_device *this)
> +{
> +	struct _iosignalfd *p = to_iosignalfd(this);
> +
> +	iosignalfd_release(p);
> +}
> +
> +static const struct kvm_io_device_ops iosignalfd_ops = {
> +	.write      = iosignalfd_write,
> +	.destructor = iosignalfd_destructor,
> +};
> +
> +static bool
> +iosignalfd_overlap(struct _iosignalfd *lhs, struct _iosignalfd *rhs)

this checks both region overlap and data collision.
better split into two helpers?

> +{
> +	/*
> +	 * Check for completely non-overlapping regions.  We can simply
> +	 * return "false" for non-overlapping regions and be done with
> +	 * it.
> +	 */

done with it -> ignore the value

> +	if ((rhs->addr + rhs->length) <= lhs->addr)
> +		return false;

rhs->addr + rhs->length <= lhs->addr
is not less clear, as precedence for simple math
follows the familiar rules from school.

> +
> +	if ((lhs->addr + lhs->length) <= rhs->addr)

this math can overflow.

> +		return false;

or shorter:
 	if (rhs->addr + rhs->length <= lhs->addr ||
 	    lhs->addr + lhs->length <= rhs->addr)
           return true;

> +
> +	/*
> +	 * If we get here, we know there is *some* overlap, but we don't
> +	 * yet know how much.

how much?

>  Make sure its a "precise" overlap, or

precise overlap -> address/len pairs match

> +	 * its rejected as incompatible
> +	 */

"rejected" does not seem to make sense in the context of a boolean
function

> +	if (lhs->addr != rhs->addr)
> +		return true;
> +
> +	if (lhs->length != rhs->length)
> +		return true;
> +

or shorter:
	if (lhs->addr != rhs->addr || lhs->length != rhs->length)
           return true;


> +	/*
> +	 * If we get here, the request should be a precise overlap
> +	 * between rhs+lhs.  The only thing left to check is for
> +	 * data-match overlap.  If the data match is distinctly different
> +	 * we can allow the two to co-exist.  Any kind of wild-card
> +	 * consitutes an incompatible range, so reject any wild-cards,
> +	 * or if the match token is identical.
> +	 */
> +	if (lhs->wildcard || rhs->wildcard || lhs->match == rhs->match)
> +		return true;
> +
> +	return false;
> +}


> +
> +/* assumes kvm->slots_lock write-lock held */

it seems you only need read lock?

> +static bool
> +iosignalfd_check_collision(struct kvm *kvm, struct _iosignalfd *p)
> +{
> +	struct _iosignalfd *_p;
> +
> +	list_for_each_entry(_p, &kvm->iosignalfds, list)
> +		if (iosignalfd_overlap(_p, p))

This looks wrong: let's assume I want one signal with length 1 and one
with length 2 at address 0. They never trigger together, so it should
be ok to have 2 such devices.

> +			return true;
> +
> +	return false;
> +}
> +
> +static int
> +kvm_assign_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
> +{
> +	int                       pio = args->flags & KVM_IOSIGNALFD_FLAG_PIO;
> +	struct kvm_io_bus        *bus = pio ? &kvm->pio_bus : &kvm->mmio_bus;
> +	struct _iosignalfd       *p;
> +	struct eventfd_ctx       *eventfd;
> +	int                       ret;
> +
> +	switch (args->len) {
> +	case 1:
> +	case 2:
> +	case 4:
> +	case 8:
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	eventfd = eventfd_ctx_fdget(args->fd);
> +	if (IS_ERR(eventfd))
> +		return PTR_ERR(eventfd);

since this eventfd is kept around indefinitely, we should keep the
file * around as well, so that this eventfd is accounted for
properly with # of open files limit set by the admin.

> +
> +	p = kzalloc(sizeof(*p), GFP_KERNEL);
> +	if (!p) {
> +		ret = -ENOMEM;
> +		goto fail;
> +	}
> +
> +	INIT_LIST_HEAD(&p->list);
> +	p->addr    = args->addr;
> +	p->length  = args->len;
> +	p->eventfd = eventfd;
> +
> +	/*
> +	 * A trigger address is optional, otherwise this is a wildcard
> +	 */

A single line comment can look like this:
	/* A trigger address is optional, otherwise this is a wildcard */

> +	if (args->flags & KVM_IOSIGNALFD_FLAG_TRIGGER)
> +		p->match = args->trigger;

For len < 8, high bits in trigger are ignored.
it's better to check that they are 0, less confusing
if the user e.g. gets the endian-ness wrong.

> +	else
> +		p->wildcard = true;
> +

> +	down_write(&kvm->slots_lock);
> +
> +	/* Verify that there isnt a match already */

Better to put documentation to where function is declared,
not where it is used.

> +	if (iosignalfd_check_collision(kvm, p)) {
> +		ret = -EEXIST;
> +		goto unlock_fail;
> +	}
> +
> +	kvm_iodevice_init(&p->dev, &iosignalfd_ops);
> +
> +	ret = __kvm_io_bus_register_dev(bus, &p->dev);
> +	if (ret < 0)
> +		goto unlock_fail;
> +
> +	list_add_tail(&p->list, &kvm->iosignalfds);
> +
> +	up_write(&kvm->slots_lock);
> +
> +	return 0;
> +

we probably do not need an empty line after each line of code here

> +unlock_fail:
> +	up_write(&kvm->slots_lock);
> +fail:
> +	/*
> +	 * it would have never made it to the list in the failure path, so
> +	 * we dont need to worry about removing it
> +	 */

of course: you goto fail before list_add
can just kill this comment

> +	kfree(p);
> +
> +	eventfd_ctx_put(eventfd);
> +
> +	return ret;

we probably do not need an empty line after each line of code here


> +}
> +
> +

two empty lines

> +static int
> +kvm_deassign_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
> +{
> +	int                       pio = args->flags & KVM_IOSIGNALFD_FLAG_PIO;
> +	struct kvm_io_bus        *bus = pio ? &kvm->pio_bus : &kvm->mmio_bus;
> +	struct _iosignalfd       *p, *tmp;
> +	struct eventfd_ctx       *eventfd;
> +	int                       ret = 0;
> +
> +	eventfd = eventfd_ctx_fdget(args->fd);
> +	if (IS_ERR(eventfd))
> +		return PTR_ERR(eventfd);
> +
> +	down_write(&kvm->slots_lock);
> +
> +	list_for_each_entry_safe(p, tmp, &kvm->iosignalfds, list) {
> +

kill empty line

> +		if (p->eventfd != eventfd)
> +			continue;

So for deassign, you ignore all arguments besides fd?  Is this
intentional? Looks strange - think of multiple addresses triggering a
single eventfd. But if so, it's better to have a different ioctl with
just the fields we need.

> +
> +		__kvm_io_bus_unregister_dev(bus, &p->dev);
> +		iosignalfd_release(p);

a single deassign removed multiple irqfds? Looks ugly.

> +	}
> +

kill empty line

> +	up_write(&kvm->slots_lock);
> +
> +	eventfd_ctx_put(eventfd);
> +
> +	return ret;
> +}

return error status if no device was found?

> +
> +int
> +kvm_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
> +{
> +	if (args->flags & KVM_IOSIGNALFD_FLAG_DEASSIGN)
> +		return kvm_deassign_iosignalfd(kvm, args);

Better check that only known flag values are present.
Otherwise when you add more flags things just break
silently.

> +
> +	return kvm_assign_iosignalfd(kvm, args);
> +}
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 11595c7..5ac381b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -979,7 +979,7 @@ static struct kvm *kvm_create_vm(void)
>  	spin_lock_init(&kvm->mmu_lock);
>  	spin_lock_init(&kvm->requests_lock);
>  	kvm_io_bus_init(&kvm->pio_bus);
> -	kvm_irqfd_init(kvm);
> +	kvm_eventfd_init(kvm);
>  	mutex_init(&kvm->lock);
>  	mutex_init(&kvm->irq_lock);
>  	kvm_io_bus_init(&kvm->mmio_bus);
> @@ -2271,6 +2271,15 @@ static long kvm_vm_ioctl(struct file *filp,
>  		r = kvm_irqfd(kvm, data.fd, data.gsi, data.flags);
>  		break;
>  	}
> +	case KVM_IOSIGNALFD: {
> +		struct kvm_iosignalfd data;
> +
> +		r = -EFAULT;

this trick is nice, it saves a line of code for the closing brace
but why waste it on an empty line above then?

> +		if (copy_from_user(&data, argp, sizeof data))
> +			goto out;
> +		r = kvm_iosignalfd(kvm, &data);
> +		break;
> +	}
>  #ifdef CONFIG_KVM_APIC_ARCHITECTURE
>  	case KVM_SET_BOOT_CPU_ID:
>  		r = 0;
