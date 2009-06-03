Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbZFCVpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbZFCVpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 17:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbZFCVpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 17:45:30 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:41556 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbZFCVp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 17:45:28 -0400
Message-ID: <4A26EEEF.6040007@novell.com>
Date: Wed, 03 Jun 2009 17:45:19 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org, avi@redhat.com, davidel@xmailserver.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v5 2/2] kvm: add iosignalfd support
References: <20090603200835.8206.8039.stgit@dev.haskins.net> <20090603201748.8206.96424.stgit@dev.haskins.net>
In-Reply-To: <20090603201748.8206.96424.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig173905EFB13413175408DBC4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig173905EFB13413175408DBC4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> iosignalfd is a mechanism to register PIO/MMIO regions to trigger an ev=
entfd
> signal when written to by a guest.  Host userspace can register any arb=
itrary
> IO address with a corresponding eventfd and then pass the eventfd to a
> specific end-point of interest for handling.
>
> Normal IO requires a blocking round-trip since the operation may cause
> side-effects in the emulated model or may return data to the caller.
> Therefore, an IO in KVM traps from the guest to the host, causes a VMX/=
SVM
> "heavy-weight" exit back to userspace, and is ultimately serviced by qe=
mu's
> device model synchronously before returning control back to the vcpu.
>
> However, there is a subclass of IO which acts purely as a trigger for
> other IO (such as to kick off an out-of-band DMA request, etc).  For th=
ese
> patterns, the synchronous call is particularly expensive since we reall=
y
> only want to simply get our notification transmitted asychronously and
> return as quickly as possible.  All the sychronous infrastructure to en=
sure
> proper data-dependencies are met in the normal IO case are just unecess=
ary
> overhead for signalling.  This adds additional computational load on th=
e
> system, as well as latency to the signalling path.
>
> Therefore, we provide a mechanism for registration of an in-kernel trig=
ger
> point that allows the VCPU to only require a very brief, lightweight
> exit just long enough to signal an eventfd.  This also means that any
> clients compatible with the eventfd interface (which includes userspace=

> and kernelspace equally well) can now register to be notified. The end
> result should be a more flexible and higher performance notification AP=
I
> for the backend KVM hypervisor and perhipheral components.
>
> To test this theory, we built a test-harness called "doorbell".  This
> module has a function called "doorbell_ring()" which simply increments =
a
> counter for each time the doorbell is signaled.  It supports signalling=

> from either an eventfd, or an ioctl().
>
> We then wired up two paths to the doorbell: One via QEMU via a register=
ed
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
> I didn't measure qemu-pio, because I have to figure out how to register=
 a
> PIO region with qemu's device model, and I got lazy.  However, for now =
we
> can extrapolate based on the data from the NULLIO runs of +2.56us for M=
MIO,
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
> The conclusion to draw is that we save about 4us by skipping the usersp=
ace
> hop.
>
> --------------------
>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
>
>  arch/x86/kvm/x86.c       |    1=20
>  include/linux/kvm.h      |   15 ++
>  include/linux/kvm_host.h |   10 +
>  virt/kvm/eventfd.c       |  356 ++++++++++++++++++++++++++++++++++++++=
++++++++
>  virt/kvm/kvm_main.c      |   11 +
>  5 files changed, 389 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c1ed485..c96c0e3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1097,6 +1097,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_IRQ_INJECT_STATUS:
>  	case KVM_CAP_ASSIGN_DEV_IRQ:
>  	case KVM_CAP_IRQFD:
> +	case KVM_CAP_IOSIGNALFD:
>  	case KVM_CAP_PIT2:
>  		r =3D 1;
>  		break;
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index 632a856..53b720d 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -300,6 +300,19 @@ struct kvm_guest_debug {
>  	struct kvm_guest_debug_arch arch;
>  };
> =20
> +#define KVM_IOSIGNALFD_FLAG_TRIGGER   (1 << 0)
> +#define KVM_IOSIGNALFD_FLAG_PIO       (1 << 1)
> +#define KVM_IOSIGNALFD_FLAG_DEASSIGN  (1 << 2)
> +
> +struct kvm_iosignalfd {
> +	__u64 trigger;
> +	__u64 addr;
> +	__u32 len;
> +	__u32 fd;
> +	__u32 flags;
> +	__u8  pad[36];
> +};
> +
>  #define KVM_TRC_SHIFT           16
>  /*
>   * kvm trace categories
> @@ -430,6 +443,7 @@ struct kvm_trace_rec {
>  #ifdef __KVM_HAVE_PIT
>  #define KVM_CAP_PIT2 33
>  #endif
> +#define KVM_CAP_IOSIGNALFD 34
> =20
>  #ifdef KVM_CAP_IRQ_ROUTING
> =20
> @@ -537,6 +551,7 @@ struct kvm_irqfd {
>  #define KVM_DEASSIGN_DEV_IRQ       _IOW(KVMIO, 0x75, struct kvm_assign=
ed_irq)
>  #define KVM_IRQFD                  _IOW(KVMIO, 0x76, struct kvm_irqfd)=

>  #define KVM_CREATE_PIT2		   _IOW(KVMIO, 0x77, struct kvm_pit_config)
> +#define KVM_IOSIGNALFD             _IOW(KVMIO, 0x78, struct kvm_iosign=
alfd)
> =20
>  /*
>   * ioctls for vcpu fds
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 216fe07..b705960 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -138,6 +138,7 @@ struct kvm {
>  	struct kvm_io_bus pio_bus;
>  #ifdef CONFIG_HAVE_KVM_EVENTFD
>  	struct list_head irqfds;
> +	struct list_head iosignalfds;
>  #endif
>  	struct kvm_vm_stat stat;
>  	struct kvm_arch arch;
> @@ -533,19 +534,24 @@ static inline void kvm_free_irq_routing(struct kv=
m *kvm) {}
> =20
>  #ifdef CONFIG_HAVE_KVM_EVENTFD
> =20
> -void kvm_irqfd_init(struct kvm *kvm);
> +void kvm_eventfd_init(struct kvm *kvm);
>  int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags);
>  void kvm_irqfd_release(struct kvm *kvm);
> +int kvm_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args);
> =20
>  #else
> =20
> -static inline void kvm_irqfd_init(struct kvm *kvm) {}
> +static inline void kvm_eventfd_init(struct kvm *kvm) {}
>  static inline int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flag=
s)
>  {
>  	return -EINVAL;
>  }
> =20
>  static inline void kvm_irqfd_release(struct kvm *kvm) {}
> +static inline int kvm_iosignalfd(struct kvm *kvm, struct kvm_iosignalf=
d *args)
> +{
> +	return -EINVAL;
> +}
> =20
>  #endif /* CONFIG_HAVE_KVM_EVENTFD */
> =20
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index f3f2ea1..77befb3 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -21,6 +21,7 @@
>   */
> =20
>  #include <linux/kvm_host.h>
> +#include <linux/kvm.h>
>  #include <linux/workqueue.h>
>  #include <linux/syscalls.h>
>  #include <linux/wait.h>
> @@ -29,6 +30,8 @@
>  #include <linux/list.h>
>  #include <linux/eventfd.h>
> =20
> +#include "iodev.h"
> +
>  /*
>   * -------------------------------------------------------------------=
-
>   * irqfd: Allows an fd to be used to inject an interrupt to the guest
> @@ -208,9 +211,10 @@ kvm_deassign_irqfd(struct kvm *kvm, int fd, int gs=
i)
>  }
> =20
>  void
> -kvm_irqfd_init(struct kvm *kvm)
> +kvm_eventfd_init(struct kvm *kvm)
>  {
>  	INIT_LIST_HEAD(&kvm->irqfds);
> +	INIT_LIST_HEAD(&kvm->iosignalfds);
>  }
> =20
>  int
> @@ -233,3 +237,353 @@ kvm_irqfd_release(struct kvm *kvm)
>  		irqfd_release(irqfd);
>  	}
>  }
> +
> +/*
> + * -------------------------------------------------------------------=
-
> + * iosignalfd: translate a PIO/MMIO memory write to an eventfd signal.=

> + *
> + * userspace can register a PIO/MMIO address with an eventfd for recie=
ving
> + * notification when the memory has been touched.
> + * -------------------------------------------------------------------=
-
> + */
> +
> +/*
> + * Design note: We create one PIO/MMIO device (iosignalfd_group) which=

> + * aggregates  one or more iosignalfd_items.  Each item points to exac=
tly one
> + * eventfd, and can be registered to trigger on any write to the group=

> + * (wildcard), or to a write of a specific value.  If more than one it=
em is to
> + * be supported, the addr/len ranges must all be identical in the grou=
p.  If a
> + * trigger value is to be supported on a particular item, the group ra=
nge must
> + * be exactly the width of the trigger.
> + */
> +
> +struct _iosignalfd_item {
> +	struct list_head     list;
> +	struct file         *file;
> +	unsigned char       *match;
> +	struct rcu_head      rcu;
> +};
> +
> +struct _iosignalfd_group {
> +	struct list_head     list;
> +	u64                  addr;
> +	size_t               length;
> +	struct list_head     items;
> +	struct kvm_io_device dev;
> +};
> +
> +static inline struct _iosignalfd_group *to_group(struct kvm_io_device =
*dev)
> +{
> +	return container_of(dev, struct _iosignalfd_group, dev);
> +}
> +
> +static inline struct _iosignalfd_item *to_item(struct rcu_head *rhp)
> +{
> +	return container_of(rhp, struct _iosignalfd_item, rcu);
> +}
> +
> +static int
> +iosignalfd_group_in_range(struct kvm_io_device *this, gpa_t addr, int =
len,
> +			  int is_write)
> +{
> +	struct _iosignalfd_group *p =3D to_group(this);
> +
> +	return ((addr >=3D p->addr && (addr < p->addr + p->length)));
> +}
> +
> +static int
> +iosignalfd_is_match(struct _iosignalfd_group *group,
> +		    struct _iosignalfd_item *item,
> +		    const void *val,
> +		    int len)
> +{
> +	if (!item->match)
> +		/* wildcard is a hit */
> +		return true;
> +
> +	if (len !=3D group->length)
> +		/* mis-matched length is a miss */
> +		return false;
> +
> +	/* otherwise, we have to actually compare the data */
> +	return !memcmp(item->match, val, len) ? true : false;
> +}
> +
> +/*
> + * MMIO/PIO writes trigger an event (if the data matches).
> + *
> + * This is invoked by the io_bus subsystem in response to an address m=
atch
> + * against the group.  We must then walk the list of individual items =
to check
> + * for a match and, if applicable, to send the appropriate signal. If =
the item
> + * in question does not have a "match" pointer, it is considered a wil=
dcard
> + * and will always generate a signal.  There can be an arbitrary numbe=
r
> + * of distinct matches or wildcards per group.
> + */
> +static void
> +iosignalfd_group_write(struct kvm_io_device *this, gpa_t addr, int len=
,
> +		       const void *val)
> +{
> +	struct _iosignalfd_group *group =3D to_group(this);
> +	struct _iosignalfd_item *item;
> +
> +	/* FIXME: We should probably use SRCU */
> +	rcu_read_lock();
> +
> +	list_for_each_entry_rcu(item, &group->items, list) {
> +		if (iosignalfd_is_match(group, item, val, len))
> +			eventfd_signal(item->file, 1);
> +	}
> +
> +	rcu_read_unlock();
> +}
> +
> +/*
> + * MMIO/PIO reads against the group indiscriminately return all zeros
> + */
> +static void
> +iosignalfd_group_read(struct kvm_io_device *this, gpa_t addr, int len,=

> +		      void *val)
> +{
> +	memset(val, 0, len);
> +}
> +
> +static void
> +_iosignalfd_group_destructor(struct _iosignalfd_group *group)
> +{
> +	list_del(&group->list);
> +	kfree(group);
> +}
> +
> +static void
> +iosignalfd_group_destructor(struct kvm_io_device *this)
> +{
> +	struct _iosignalfd_group *group =3D to_group(this);
> +
> +	_iosignalfd_group_destructor(group);
> +}
> +
> +/* assumes kvm->lock held */
> +static struct _iosignalfd_group *
> +iosignalfd_group_find(struct kvm *kvm, u64 addr)
> +{
> +	struct _iosignalfd_group *group;
> +
> +	list_for_each_entry(group, &kvm->iosignalfds, list) {
> +		if (group->addr =3D=3D addr)
> +			return group;
> +	}
> +
> +	return NULL;
> +}
> +
> +static const struct kvm_io_device_ops iosignalfd_ops =3D {
> +	.read       =3D iosignalfd_group_read,
> +	.write      =3D iosignalfd_group_write,
> +	.in_range   =3D iosignalfd_group_in_range,
> +	.destructor =3D iosignalfd_group_destructor,
> +};
> +
> +/*
> + * Atomically find an existing group, or create a new one if it doesn'=
t already
> + * exist.
> + *
> + * assumes kvm->lock is held
> + */
> +static struct _iosignalfd_group *
> +iosignalfd_group_get(struct kvm *kvm, struct kvm_io_bus *bus,
> +		      u64 addr, size_t len)
> +{
> +	struct _iosignalfd_group *group;
> +
> +	group =3D iosignalfd_group_find(kvm, addr);
> +	if (!group) {
> +		int ret;
> +
> +		group =3D kzalloc(sizeof(*group), GFP_KERNEL);
> +		if (!group)
> +			return ERR_PTR(-ENOMEM);
> +
> +		INIT_LIST_HEAD(&group->list);
> +		INIT_LIST_HEAD(&group->items);
> +		group->addr   =3D addr;
> +		group->length =3D len;
> +		kvm_iodevice_init(&group->dev, &iosignalfd_ops);
> +
> +		ret =3D kvm_io_bus_register_dev(bus, &group->dev);
> +		if (ret < 0) {
> +			kfree(group);
> +			return ERR_PTR(ret);
> +		}
> +
> +		list_add_tail(&group->list, &kvm->iosignalfds);
> +
> +	} else if (group->length !=3D len)
> +		/*
> +		 * Existing groups must have the same addr/len tuple or we
> +		 * reject the request
> +		 */
> +		return ERR_PTR(-EINVAL);
> +
> +	return group;
> +}
> +
> +static int
> +kvm_assign_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
> +{
> +	int                       pio =3D args->flags & KVM_IOSIGNALFD_FLAG_P=
IO;
> +	struct kvm_io_bus        *bus =3D pio ? &kvm->pio_bus : &kvm->mmio_bu=
s;
> +	struct _iosignalfd_group *group =3D NULL;
> +	struct _iosignalfd_item  *item =3D NULL;
> +	struct file              *file;
> +	int                       ret;
> +
> +	file =3D eventfd_fget(args->fd);
> +	if (IS_ERR(file)) {
> +		ret =3D PTR_ERR(file);
> +		return ret;
> +	}
> +
> +	item =3D kzalloc(sizeof(*item), GFP_KERNEL);
> +	if (!item) {
> +		ret =3D -ENOMEM;
> +		goto fail;
> +	}
> +
> +	INIT_LIST_HEAD(&item->list);
> +	item->file =3D file;
> +
> +	/*
> +	 * Registering a "trigger" address is optional.  If this flag
> +	 * is not specified, we leave the item->match pointer NULL, which
> +	 * indicates a wildcard
> +	 */
> +	if (args->flags & KVM_IOSIGNALFD_FLAG_TRIGGER) {
> +		if (args->len > sizeof(u64)) {
> +			ret =3D -EINVAL;
> +			goto fail;
> +		}
> +
> +		item->match =3D kzalloc(args->len, GFP_KERNEL);
> +		if (!item->match) {
> +			ret =3D -ENOMEM;
> +			goto fail;
> +		}
> +
> +		if (copy_from_user(item->match,
> +				   (void *)args->trigger,
> +				   args->len)) {
> +			ret =3D -EFAULT;
> +			goto fail;
> +		}
> +	}
> +
> +	mutex_lock(&kvm->lock);
> +
> +	group =3D iosignalfd_group_get(kvm, bus, args->addr, args->len);
> +	if (IS_ERR(group)) {
> +		ret =3D PTR_ERR(group);
> +		mutex_unlock(&kvm->lock);
> +		goto fail;
> +	}
> +
> +	/*
> +	 * Note: We are committed to succeed at this point since we have
> +	 * (potentially) published a new group-device.  Any failure handling
> +	 * added in the future after this point will need to be handled
> +	 * carefully.
> +	 */
> +
> +	list_add_tail_rcu(&item->list, &group->items);
> +
> +	mutex_unlock(&kvm->lock);
> +
> +	return 0;
> +
> +fail:
> +	if (item) {
> +		/*
> +		 * it would have never made it to the group->items list
> +		 * in the failure path, so we dont need to worry about removing
> +		 * it
> +		 */
> +		kfree(item->match);
> +		kfree(item);
> +	}
> +
> +	if (file)
> +		fput(file);
> +
> +	return ret;
> +}
> +
> +static void
> +iosignalfd_item_free(struct rcu_head *rhp)
> +{
> +	struct _iosignalfd_item *item =3D to_item(rhp);
> +
> +	fput(item->file);
> +	kfree(item->match);
> +	kfree(item);
> +}
> +
> +static int
> +kvm_deassign_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
> +{
> +	int                       pio =3D args->flags & KVM_IOSIGNALFD_FLAG_P=
IO;
> +	struct kvm_io_bus        *bus =3D pio ? &kvm->pio_bus : &kvm->mmio_bu=
s;
> +	struct _iosignalfd_group *group;
> +	struct _iosignalfd_item  *item, *tmp;
> +	struct file              *file;
> +	int                       ret =3D 0;
> +
> +	mutex_lock(&kvm->lock);
> +
> +	group =3D iosignalfd_group_find(kvm, args->addr);
> +	if (!group) {
> +		ret =3D -EINVAL;
> +		goto out;
> +	}
> +
> +	file =3D eventfd_fget(args->fd);
> +	if (IS_ERR(file)) {
> +		ret =3D PTR_ERR(file);
> +		goto out;
> +	}
> +
> +	list_for_each_entry_safe(item, tmp, &group->items, list) {
> +		/*
> +		 * any items registered at this group-address with the matching
> +		 * eventfd will be removed
> +		 */
> +		if (item->file !=3D file)
> +			continue;
> +
> +		list_del_rcu(&item->list);
> +		call_rcu(&item->rcu, iosignalfd_item_free);
> +	}
> +
> +	if (list_empty(&group->items)) {
> +		/*
> +		 * We should unpublish our group device if we just removed
> +		 * the last of its contained items
> +		 */
> +		kvm_io_bus_unregister_dev(bus, &group->dev);
> +		_iosignalfd_group_destructor(group);
>  =20

This is the issue I mentioned in the last email (against 0/2).  I may
need to be concerned about racing to destroy the group before the next
grace period.

That aside, my whole use of RCU here is a bit dubious (at least in the
current code) since today all io_bus operations hold the kvm->lock while
they execute.  I think we would like to fix this in the future to be
more fine grained, so thinking in this direction is probably not a bad
idea.  However, I really shouldn't do it half-assed like I am right now
;)  I will fix this.

-Greg

> +	}
> +
> +	fput(file);
> +
> +out:
> +	mutex_unlock(&kvm->lock);
> +
> +	return ret;
> +}
> +
> +int
> +kvm_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
> +{
> +	if (args->flags & KVM_IOSIGNALFD_FLAG_DEASSIGN)
> +		return kvm_deassign_iosignalfd(kvm, args);
> +
> +	return kvm_assign_iosignalfd(kvm, args);
> +}
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 179c650..91d0fe2 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -977,7 +977,7 @@ static struct kvm *kvm_create_vm(void)
>  	atomic_inc(&kvm->mm->mm_count);
>  	spin_lock_init(&kvm->mmu_lock);
>  	kvm_io_bus_init(&kvm->pio_bus);
> -	kvm_irqfd_init(kvm);
> +	kvm_eventfd_init(kvm);
>  	mutex_init(&kvm->lock);
>  	kvm_io_bus_init(&kvm->mmio_bus);
>  	init_rwsem(&kvm->slots_lock);
> @@ -2215,6 +2215,15 @@ static long kvm_vm_ioctl(struct file *filp,
>  		r =3D kvm_irqfd(kvm, data.fd, data.gsi, data.flags);
>  		break;
>  	}
> +	case KVM_IOSIGNALFD: {
> +		struct kvm_iosignalfd entry;
> +
> +		r =3D -EFAULT;
> +		if (copy_from_user(&entry, argp, sizeof entry))
> +			goto out;
> +		r =3D kvm_iosignalfd(kvm, &entry);
> +		break;
> +	}
>  	default:
>  		r =3D kvm_arch_vm_ioctl(filp, ioctl, arg);
>  	}
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  =20



--------------enig173905EFB13413175408DBC4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkom7vQACgkQlOSOBdgZUxmkswCbBCD27sDKiMeOsVa/qtOJJm4W
FSQAn0zAIO1qdDoTFv/OANKd8XSnZy1K
=+7cM
-----END PGP SIGNATURE-----

--------------enig173905EFB13413175408DBC4--
