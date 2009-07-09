Return-Path: <linux-kernel-owner+w=401wt.eu-S1761496AbZGIPAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761496AbZGIPAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 11:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760756AbZGIPAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 11:00:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:63982 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760251AbZGIPAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 11:00:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=tA83MmQzwEQ3QGdZgp2Vl2iliv+kiUf9yuWz6zzZ6/3Wpsb3PsGN9zHkuN2oQDd40s
         8Fc6Pn1pSZsqJcgAWprb4QYCuUlhQxjYJw8ALuNCs1PIfttlKqgMkVc9zd7SKHfHPrsG
         k8vkjRPLgWjGcCnA/CVYA7ltedR9NwiyZLYEI=
Message-ID: <4A56060C.4090206@gmail.com>
Date: Thu, 09 Jul 2009 11:00:28 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
       avi@redhat.com
Subject: Re: [KVM PATCH v10 2/2] KVM: add ioeventfd support
References: <20090707210023.21953.22087.stgit@dev.haskins.net> <20090707210849.21953.93817.stgit@dev.haskins.net>
In-Reply-To: <20090707210849.21953.93817.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0D24D65A4163E61AEBDE4E2C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0D24D65A4163E61AEBDE4E2C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> ioeventfd is a mechanism to register PIO/MMIO regions to trigger an eve=
ntfd
> signal when written to by a guest.  Host userspace can register any
> arbitrary IO address with a corresponding eventfd and then pass the eve=
ntfd
> to a specific end-point of interest for handling.
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
> ioeventfd.
>
> You can download this test harness here:
>
> ftp://ftp.novell.com/dev/ghaskins/doorbell.tar.bz2
>
> The measured results are as follows:
>
> qemu-mmio:       110000 iops, 9.09us rtt
> ioeventfd-mmio: 200100 iops, 5.00us rtt
> ioeventfd-pio:  367300 iops, 2.72us rtt
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
> ioeventfd-hc: 412585 iops, 2.37us rtt
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
>  include/linux/kvm.h      |   24 ++++
>  include/linux/kvm_host.h |   10 +-
>  virt/kvm/eventfd.c       |  252 ++++++++++++++++++++++++++++++++++++++=
++++++++
>  virt/kvm/kvm_main.c      |   11 ++
>  5 files changed, 294 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 95fa45c..59c2d93 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1212,6 +1212,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_IRQ_INJECT_STATUS:
>  	case KVM_CAP_ASSIGN_DEV_IRQ:
>  	case KVM_CAP_IRQFD:
> +	case KVM_CAP_IOEVENTFD:
>  	case KVM_CAP_PIT2:
>  		r =3D 1;
>  		break;
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index 76c6408..22d0eb7 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -307,6 +307,28 @@ struct kvm_guest_debug {
>  	struct kvm_guest_debug_arch arch;
>  };
> =20
> +enum {
> +	kvm_ioeventfd_flag_nr_datamatch,
> +	kvm_ioeventfd_flag_nr_pio,
> +	kvm_ioeventfd_flag_nr_deassign,
> +	kvm_ioeventfd_flag_nr_max,
> +};
> +
> +#define KVM_IOEVENTFD_FLAG_DATAMATCH (1 << kvm_ioeventfd_flag_nr_datam=
atch)
> +#define KVM_IOEVENTFD_FLAG_PIO       (1 << kvm_ioeventfd_flag_nr_pio)
> +#define KVM_IOEVENTFD_FLAG_DEASSIGN  (1 << kvm_ioeventfd_flag_nr_deass=
ign)
> +
> +#define KVM_IOEVENTFD_VALID_FLAG_MASK  ((1 << kvm_ioeventfd_flag_nr_ma=
x) - 1)
> +
> +struct kvm_ioeventfd {
> +	__u64 datamatch;
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
> @@ -409,6 +431,7 @@ struct kvm_guest_debug {
>  #define KVM_CAP_PIT2 33
>  #endif
>  #define KVM_CAP_SET_BOOT_CPU_ID 34
> +#define KVM_CAP_IOEVENTFD 35
> =20
>  #ifdef KVM_CAP_IRQ_ROUTING
> =20
> @@ -517,6 +540,7 @@ struct kvm_irqfd {
>  #define KVM_IRQFD                  _IOW(KVMIO, 0x76, struct kvm_irqfd)=

>  #define KVM_CREATE_PIT2		   _IOW(KVMIO, 0x77, struct kvm_pit_config)
>  #define KVM_SET_BOOT_CPU_ID        _IO(KVMIO, 0x78)
> +#define KVM_IOEVENTFD             _IOW(KVMIO, 0x79, struct kvm_ioevent=
fd)
> =20
>  /*
>   * ioctls for vcpu fds
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 306bc67..0347d59 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -154,6 +154,7 @@ struct kvm {
>  		spinlock_t        lock;
>  		struct list_head  items;
>  	} irqfds;
> +	struct list_head ioeventfds;
>  #endif
>  	struct kvm_vm_stat stat;
>  	struct kvm_arch arch;
> @@ -532,19 +533,24 @@ static inline void kvm_free_irq_routing(struct kv=
m *kvm) {}
> =20
>  #ifdef CONFIG_HAVE_KVM_EVENTFD
> =20
> -void kvm_irqfd_init(struct kvm *kvm);
> +void kvm_eventfd_init(struct kvm *kvm);
>  int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags);
>  void kvm_irqfd_release(struct kvm *kvm);
> +int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args);
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
> +static inline int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd =
*args)
> +{
> +	return -ENOSYS;
> +}
> =20
>  #endif /* CONFIG_HAVE_KVM_EVENTFD */
> =20
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 4092b8d..eee8edb 100644
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
> @@ -28,6 +29,9 @@
>  #include <linux/file.h>
>  #include <linux/list.h>
>  #include <linux/eventfd.h>
> +#include <linux/kernel.h>
> +
> +#include "iodev.h"
> =20
>  /*
>   * -------------------------------------------------------------------=
-
> @@ -234,10 +238,11 @@ fail:
>  }
> =20
>  void
> -kvm_irqfd_init(struct kvm *kvm)
> +kvm_eventfd_init(struct kvm *kvm)
>  {
>  	spin_lock_init(&kvm->irqfds.lock);
>  	INIT_LIST_HEAD(&kvm->irqfds.items);
> +	INIT_LIST_HEAD(&kvm->ioeventfds);
>  }
> =20
>  /*
> @@ -327,3 +332,248 @@ static void __exit irqfd_module_exit(void)
> =20
>  module_init(irqfd_module_init);
>  module_exit(irqfd_module_exit);
> +
> +/*
> + * -------------------------------------------------------------------=
-
> + * ioeventfd: translate a PIO/MMIO memory write to an eventfd signal.
> + *
> + * userspace can register a PIO/MMIO address with an eventfd for recei=
ving
> + * notification when the memory has been touched.
> + * -------------------------------------------------------------------=
-
> + */
> +
> +struct _ioeventfd {
> +	struct list_head     list;
> +	u64                  addr;
> +	int                  length;
> +	struct eventfd_ctx  *eventfd;
> +	u64                  datamatch;
> +	struct kvm_io_device dev;
> +	bool                 wildcard;
> +};
> +
> +static inline struct _ioeventfd *
> +to_ioeventfd(struct kvm_io_device *dev)
> +{
> +	return container_of(dev, struct _ioeventfd, dev);
> +}
> +
> +static void
> +ioeventfd_release(struct _ioeventfd *p)
> +{
> +	eventfd_ctx_put(p->eventfd);
> +	list_del(&p->list);
> +	kfree(p);
> +}
> +
> +static bool
> +ioeventfd_in_range(struct _ioeventfd *p, gpa_t addr, int len, const vo=
id *val)
> +{
> +	u64 _val;
> +
> +	if (!(addr =3D=3D p->addr && len =3D=3D p->length))
> +		/* address-range must be precise for a hit */
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
> +		_val =3D *(u8 *)val;
> +		break;
> +	case 2:
> +		_val =3D *(u16 *)val;
> +		break;
> +	case 4:
> +		_val =3D *(u32 *)val;
> +		break;
> +	case 8:
> +		_val =3D *(u64 *)val;
> +		break;
> +	default:
> +		return false;
> +	}
> +
> +	return _val =3D=3D p->datamatch ? true : false;
> +}
> +
> +/* MMIO/PIO writes trigger an event if the addr/val match */
> +static int
> +ioeventfd_write(struct kvm_io_device *this, gpa_t addr, int len,
> +		const void *val)
> +{
> +	struct _ioeventfd *p =3D to_ioeventfd(this);
> +
> +	if (!ioeventfd_in_range(p, addr, len, val))
> +		return -EOPNOTSUPP;
> +
> +	eventfd_signal(p->eventfd, 1);
> +	return 0;
> +}
> +
> +/*
> + * This function is called as KVM is completely shutting down.  We do =
not
> + * need to worry about locking just nuke anything we have as quickly a=
s possible
> + */
> +static void
> +ioeventfd_destructor(struct kvm_io_device *this)
> +{
> +	struct _ioeventfd *p =3D to_ioeventfd(this);
> +
> +	ioeventfd_release(p);
> +}
> +
> +static const struct kvm_io_device_ops ioeventfd_ops =3D {
> +	.write      =3D ioeventfd_write,
> +	.destructor =3D ioeventfd_destructor,
> +};
> +
> +/* assumes kvm->slots_lock held */
> +static bool
> +ioeventfd_check_collision(struct kvm *kvm, struct _ioeventfd *p)
> +{
> +	struct _ioeventfd *_p;
> +
> +	list_for_each_entry(_p, &kvm->ioeventfds, list)
> +		if (_p->addr =3D=3D p->addr && _p->length =3D=3D p->length &&
> +		    (_p->wildcard || p->wildcard ||
> +		     _p->datamatch =3D=3D p->datamatch))
> +			return true;
> +
> +	return false;
> +}
> +
> +static int
> +kvm_assign_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
> +{
> +	int                       pio =3D args->flags & KVM_IOEVENTFD_FLAG_PI=
O;
> +	struct kvm_io_bus        *bus =3D pio ? &kvm->pio_bus : &kvm->mmio_bu=
s;
> +	struct _ioeventfd        *p;
> +	struct eventfd_ctx       *eventfd;
> +	int                       ret;
> +
> +	/* must be natural-word sized */
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
> +	/* check for range overflow */
> +	if (args->addr + args->len < args->addr)
> +		return -EINVAL;
> +
> +	/* check for extra flags that we don't understand */
> +	if (args->flags & ~KVM_IOEVENTFD_VALID_FLAG_MASK)
> +		return -EINVAL;
> +
> +	eventfd =3D eventfd_ctx_fdget(args->fd);
> +	if (IS_ERR(eventfd))
> +		return PTR_ERR(eventfd);
> +
> +	p =3D kzalloc(sizeof(*p), GFP_KERNEL);
> +	if (!p) {
> +		ret =3D -ENOMEM;
> +		goto fail;
> +	}
> +
> +	INIT_LIST_HEAD(&p->list);
> +	p->addr    =3D args->addr;
> +	p->length  =3D args->len;
> +	p->eventfd =3D eventfd;
> +
> +	/* The datamatch feature is optional, otherwise this is a wildcard */=

> +	if (args->flags & KVM_IOEVENTFD_FLAG_DATAMATCH)
> +		p->datamatch =3D args->datamatch;
> +	else
> +		p->wildcard =3D true;
> +
> +	down_write(&kvm->slots_lock);
> +
> +	/* Verify that there isnt a match already */
> +	if (ioeventfd_check_collision(kvm, p)) {
> +		ret =3D -EEXIST;
> +		goto unlock_fail;
> +	}
> +
> +	kvm_iodevice_init(&p->dev, &ioeventfd_ops);
> +
> +	ret =3D __kvm_io_bus_register_dev(bus, &p->dev);
> +	if (ret < 0)
> +		goto unlock_fail;
> +
> +	list_add_tail(&p->list, &kvm->ioeventfds);
> +
> +	up_write(&kvm->slots_lock);
> +
> +	return 0;
> +
> +unlock_fail:
> +	up_write(&kvm->slots_lock);
> +
> +fail:
> +	kfree(p);
> +	eventfd_ctx_put(eventfd);
> +
> +	return ret;
> +}
> +
> +static int
> +kvm_deassign_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
> +{
> +	int                       pio =3D args->flags & KVM_IOEVENTFD_FLAG_PI=
O;
> +	struct kvm_io_bus        *bus =3D pio ? &kvm->pio_bus : &kvm->mmio_bu=
s;
> +	struct _ioeventfd        *p, *tmp;
> +	struct eventfd_ctx       *eventfd;
> +	int                       ret =3D -ENOENT;
> +
> +	eventfd =3D eventfd_ctx_fdget(args->fd);
> +	if (IS_ERR(eventfd))
> +		return PTR_ERR(eventfd);
> +
> +	down_write(&kvm->slots_lock);
> +
> +	list_for_each_entry_safe(p, tmp, &kvm->ioeventfds, list) {
> +		bool wildcard =3D args->flags & KVM_IOEVENTFD_FLAG_DATAMATCH ?
> +			true : false;
>  =20
Doh!  Inverted logic.  "wildcard" should be "false" if DATAMATCH is
defined in the flags.

Avi, please reverse true/false here before accepting (assuming a v11
respin isn't needed).  Of course, if you would prefer me to just submit
a new patch, that is fine too.

-Greg

> +
> +		if (p->eventfd !=3D eventfd  ||
> +		    p->addr !=3D args->addr  ||
> +		    p->length !=3D args->len ||
> +		    p->wildcard !=3D wildcard)
> +			continue;
> +
> +		if (!p->wildcard && p->datamatch !=3D args->datamatch)
> +			continue;
> +
> +		__kvm_io_bus_unregister_dev(bus, &p->dev);
> +		ioeventfd_release(p);
> +		ret =3D 0;
> +		break;
> +	}
> +
> +	up_write(&kvm->slots_lock);
> +
> +	eventfd_ctx_put(eventfd);
> +
> +	return ret;
> +}
> +
> +int
> +kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
> +{
> +	if (args->flags & KVM_IOEVENTFD_FLAG_DEASSIGN)
> +		return kvm_deassign_ioeventfd(kvm, args);
> +
> +	return kvm_assign_ioeventfd(kvm, args);
> +}
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index dd92b44..14e1f32 100644
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
>  		r =3D kvm_irqfd(kvm, data.fd, data.gsi, data.flags);
>  		break;
>  	}
> +	case KVM_IOEVENTFD: {
> +		struct kvm_ioeventfd data;
> +
> +		r =3D -EFAULT;
> +		if (copy_from_user(&data, argp, sizeof data))
> +			goto out;
> +		r =3D kvm_ioeventfd(kvm, &data);
> +		break;
> +	}
>  #ifdef CONFIG_KVM_APIC_ARCHITECTURE
>  	case KVM_SET_BOOT_CPU_ID:
>  		r =3D 0;
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  =20



--------------enig0D24D65A4163E61AEBDE4E2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpWBhAACgkQP5K2CMvXmqFEZQCgg4GjuuoPcwgxV1QRTfq4nfPH
o1EAn3wIK5OVfyXje6apheqF7SOrXEQL
=7R8t
-----END PGP SIGNATURE-----

--------------enig0D24D65A4163E61AEBDE4E2C--
