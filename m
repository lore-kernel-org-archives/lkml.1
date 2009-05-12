Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbZELTFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbZELTFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 15:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbZELTFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 15:05:15 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:57996 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZELTFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 15:05:13 -0400
Message-ID: <4A09C866.1080309@novell.com>
Date: Tue, 12 May 2009 15:05:10 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
CC: kvm@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       avi@redhat.com, davidel@xmailserver.org
Subject: Re: [KVM PATCH v7 3/3] kvm: add iofd support
References: <20090512181134.26131.10023.stgit@dev.haskins.net> <20090512182701.26131.66801.stgit@dev.haskins.net>
In-Reply-To: <20090512182701.26131.66801.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig043DD2E2AC5D2F7F9749759F"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig043DD2E2AC5D2F7F9749759F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> iofd is a mechanism to register PIO/MMIO regions to trigger an eventfd
> signal when written to.  Userspace can register any arbitrary address
> with a corresponding eventfd.
>  =20

Ugg..this patch header sucks, especially given all the talk around how
we need to do them better lately :)

I will add this text as well for future versions:

--------------

Traditional MMIO/PIO exit paths are expensive because they are done
within the same context as the VCPU thread and therefore cause a VMX/SVM
"heavy-weight" exit, a transition back to userspace, and overhead with
the qemu processing of the operation.  An eventfd mechanism, on the
other hand, allows the VCPU to take a very brief lightweight exit only
long enough to trigger the eventfd_signal.  This means that clients of
the eventfd (supporting both userspace or kernel end-points) can
potentially get notified much more efficiently than if we were to
register through the traditional mechanism via qemu MMIO/PIO notification=
=2E

-----------
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
>
>  include/linux/kvm.h      |   12 +++++
>  include/linux/kvm_host.h |    2 +
>  virt/kvm/eventfd.c       |  107 ++++++++++++++++++++++++++++++++++++++=
++++++++
>  virt/kvm/kvm_main.c      |   13 ++++++
>  4 files changed, 134 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index dfc4bcc..99b6e45 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -292,6 +292,17 @@ struct kvm_guest_debug {
>  	struct kvm_guest_debug_arch arch;
>  };
> =20
> +#define KVM_IOFD_FLAG_DEASSIGN  (1 << 0)
> +#define KVM_IOFD_FLAG_PIO       (1 << 1)
> +
> +struct kvm_iofd {
> +	__u64 addr;
> +	__u32 len;
> +	__u32 fd;
> +	__u32 flags;
> +	__u8  pad[12];
> +};
> +
>  #define KVM_TRC_SHIFT           16
>  /*
>   * kvm trace categories
> @@ -508,6 +519,7 @@ struct kvm_irqfd {
>  #define KVM_DEASSIGN_DEV_IRQ       _IOW(KVMIO, 0x75, struct kvm_assign=
ed_irq)
>  #define KVM_ASSIGN_IRQFD           _IOW(KVMIO, 0x76, struct kvm_irqfd)=

>  #define KVM_DEASSIGN_IRQFD         _IOW(KVMIO, 0x77, __u32)
> +#define KVM_IOFD                   _IOW(KVMIO, 0x78, struct kvm_iofd)
> =20
>  /*
>   * ioctls for vcpu fds
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 1acc528..d53cb70 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -529,5 +529,7 @@ static inline void kvm_free_irq_routing(struct kvm =
*kvm) {}
>  int kvm_assign_irqfd(struct kvm *kvm, int fd, int gsi, int flags);
>  int kvm_deassign_irqfd(struct kvm *kvm, int fd);
>  void kvm_irqfd_release(struct kvm *kvm);
> +int kvm_iofd(struct kvm *kvm, unsigned long addr, size_t len,
> +	     int fd, int flags);
> =20
>  #endif
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 71afd62..8b23317 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -21,12 +21,16 @@
>   */
> =20
>  #include <linux/kvm_host.h>
> +#include <linux/kvm.h>
>  #include <linux/workqueue.h>
>  #include <linux/syscalls.h>
>  #include <linux/wait.h>
>  #include <linux/poll.h>
>  #include <linux/file.h>
>  #include <linux/list.h>
> +#include <linux/eventfd.h>
> +
> +#include "iodev.h"
> =20
>  /*
>   * -------------------------------------------------------------------=
-
> @@ -185,3 +189,106 @@ kvm_irqfd_release(struct kvm *kvm)
>  	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list)
>  		irqfd_release(irqfd);
>  }
> +
> +/*
> + * -------------------------------------------------------------------=
-
> + * iofd: translate a PIO/MMIO memory write to an eventfd signal.
> + *
> + * userspace can register a PIO/MMIO address with an eventfd for recie=
ving
> + * notification when the memory has been touched.
> + * -------------------------------------------------------------------=
-
> + */
> +
> +struct _iofd {
> +	u64                  addr;
> +	size_t               length;
> +	struct file         *file;
> +	struct kvm_io_device dev;
> +};
> +
> +static int
> +iofd_in_range(struct kvm_io_device *this, gpa_t addr, int len, int is_=
write)
> +{
> +	struct _iofd *iofd =3D (struct _iofd *)this->private;
> +
> +	return ((addr >=3D iofd->addr && (addr < iofd->addr + iofd->length)))=
;
> +}
> +
> +/* writes trigger an event */
> +static void
> +iofd_write(struct kvm_io_device *this, gpa_t addr, int len, const void=
 *val)
> +{
> +	struct _iofd *iofd =3D (struct _iofd *)this->private;
> +
> +	eventfd_signal(iofd->file, 1);
> +}
> +
> +/* reads return all zeros */
> +static void
> +iofd_read(struct kvm_io_device *this, gpa_t addr, int len, void *val)
> +{
> +	memset(val, 0, len);
> +}
> +
> +static void
> +iofd_destructor(struct kvm_io_device *this)
> +{
> +	struct _iofd *iofd =3D (struct _iofd *)this->private;
> +
> +	fput(iofd->file);
> +	kfree(iofd);
> +}
> +
> +static int
> +kvm_assign_iofd(struct kvm *kvm, unsigned long addr, size_t len,
> +		int fd, int flags)
> +{
> +	int                pio =3D flags & KVM_IOFD_FLAG_PIO;
> +	struct kvm_io_bus *bus =3D pio ? &kvm->pio_bus : &kvm->mmio_bus;
> +	struct _iofd      *iofd;
> +	struct file       *file;
> +
> +	file =3D eventfd_fget(fd);
> +	if (IS_ERR(file))
> +		return PTR_ERR(file);
> +
> +	iofd =3D kzalloc(sizeof(*iofd), GFP_KERNEL);
> +	if (!iofd) {
> +		fput(file);
> +		return -ENOMEM;
> +	}
> +
> +	iofd->dev.read       =3D iofd_read;
> +	iofd->dev.write      =3D iofd_write;
> +	iofd->dev.in_range   =3D iofd_in_range;
> +	iofd->dev.destructor =3D iofd_destructor;
> +	iofd->dev.private    =3D iofd;
> +
> +	iofd->addr           =3D addr;
> +	iofd->length         =3D len;
> +	iofd->file           =3D file;
> +
> +	kvm_io_bus_register_dev(bus, &iofd->dev);
> +
> +	printk(KERN_DEBUG "registering %s iofd at %lx of size %d\n",
> +	       pio  ? "PIO" : "MMIO", addr, (int)len);
> +
> +	return 0;
> +}
> +
> +static int
> +kvm_deassign_iofd(struct kvm *kvm, unsigned long addr, size_t len,
> +		  int fd, int flags)
> +{
> +	/* FIXME: We need an io_bus_unregister() function */
> +	return -EINVAL;
> +}
> +
> +int
> +kvm_iofd(struct kvm *kvm, unsigned long addr, size_t len, int fd, int =
flags)
> +{
> +	if (flags & KVM_IOFD_FLAG_DEASSIGN)
> +		return kvm_deassign_iofd(kvm, addr, len, fd, flags);
> +
> +	return kvm_assign_iofd(kvm, addr, len, fd, flags);
> +}
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7aa9f0a..a443974 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2228,6 +2228,19 @@ static long kvm_vm_ioctl(struct file *filp,
>  		r =3D kvm_deassign_irqfd(kvm, data);
>  		break;
>  	}
> +	case KVM_IOFD: {
> +		struct kvm_iofd entry;
> +
> +		r =3D -EFAULT;
> +		if (copy_from_user(&entry, argp, sizeof entry))
> +			goto out;
> +
> +		r =3D kvm_iofd(kvm, entry.addr, entry.len, entry.fd,
> +			     entry.flags);
> +		if (r)
> +			goto out;
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



--------------enig043DD2E2AC5D2F7F9749759F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoJyGYACgkQlOSOBdgZUxmOdwCeOieHWQ5pm5PRcwZLWwfTUqB4
dM8AnjPhrJfvGmBbonxHH/gmx5rozO7E
=e6Ou
-----END PGP SIGNATURE-----

--------------enig043DD2E2AC5D2F7F9749759F--
