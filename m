Return-Path: <linux-kernel-owner+w=401wt.eu-S1760943AbZDXRIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943AbZDXRIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 13:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932210AbZDXRH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 13:07:56 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:43855 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206AbZDXRHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 13:07:54 -0400
Message-ID: <49F1F1DD.7090101@novell.com>
Date: Fri, 24 Apr 2009 13:07:41 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: davidel@xmailserver.org
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [KVM PATCH v2 2/2] kvm: add support for irqfd via eventfd-notification
 interface
References: <20090424042142.1796.60756.stgit@dev.haskins.net> <20090424042518.1796.65593.stgit@dev.haskins.net>
In-Reply-To: <20090424042518.1796.65593.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7AB9E3EB9D3248BD0C3B043E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7AB9E3EB9D3248BD0C3B043E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi David,
   See inline for an answer to your last question:

Gregory Haskins wrote:
> This allows an eventfd to be registered as an irq source with a guest. =
 Any
> signaling operation on the eventfd (via userspace or kernel) will injec=
t
> the registered GSI at the next available window.
>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
>
>  arch/x86/kvm/Makefile    |    2 -
>  arch/x86/kvm/x86.c       |    1=20
>  include/linux/kvm.h      |    7 ++
>  include/linux/kvm_host.h |    7 ++
>  virt/kvm/irqfd.c         |  146 ++++++++++++++++++++++++++++++++++++++=
++++++++
>  virt/kvm/kvm_main.c      |   12 ++++
>  6 files changed, 174 insertions(+), 1 deletions(-)
>  create mode 100644 virt/kvm/irqfd.c
>
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index b43c4ef..d5fff51 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -3,7 +3,7 @@
>  #
> =20
>  common-objs =3D $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o \
> -                coalesced_mmio.o irq_comm.o)
> +                coalesced_mmio.o irq_comm.o irqfd.o)
>  ifeq ($(CONFIG_KVM_TRACE),y)
>  common-objs +=3D $(addprefix ../../../virt/kvm/, kvm_trace.o)
>  endif
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8cb8542..88c45e6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1027,6 +1027,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_REINJECT_CONTROL:
>  	case KVM_CAP_IRQ_INJECT_STATUS:
>  	case KVM_CAP_ASSIGN_DEV_IRQ:
> +	case KVM_CAP_IRQFD:
>  		r =3D 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index 3db5d8d..2404775 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -415,6 +415,7 @@ struct kvm_trace_rec {
>  #define KVM_CAP_ASSIGN_DEV_IRQ 29
>  /* Another bug in KVM_SET_USER_MEMORY_REGION fixed: */
>  #define KVM_CAP_JOIN_MEMORY_REGIONS_WORKS 30
> +#define KVM_CAP_IRQFD 31
> =20
>  #ifdef KVM_CAP_IRQ_ROUTING
> =20
> @@ -454,6 +455,11 @@ struct kvm_irq_routing {
> =20
>  #endif
> =20
> +struct kvm_irqfd {
> +	__u32 fd;
> +	__u32 gsi;
> +};
> +
>  /*
>   * ioctls for VM fds
>   */
> @@ -498,6 +504,7 @@ struct kvm_irq_routing {
>  #define KVM_ASSIGN_SET_MSIX_ENTRY \
>  			_IOW(KVMIO, 0x74, struct kvm_assigned_msix_entry)
>  #define KVM_DEASSIGN_DEV_IRQ       _IOW(KVMIO, 0x75, struct kvm_assign=
ed_irq)
> +#define KVM_ASSIGN_IRQFD          _IOW(KVMIO, 0x76, struct kvm_irqfd)
> =20
>  /*
>   * ioctls for vcpu fds
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 095ebb6..57f8dfe 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -134,6 +134,10 @@ struct kvm {
>  	struct list_head vm_list;
>  	struct kvm_io_bus mmio_bus;
>  	struct kvm_io_bus pio_bus;
> +	struct {
> +		struct list_head items;
> +		int              src;
> +	} irqfd;
>  	struct kvm_vm_stat stat;
>  	struct kvm_arch arch;
>  	atomic_t users_count;
> @@ -524,4 +528,7 @@ static inline void kvm_free_irq_routing(struct kvm =
*kvm) {}
> =20
>  #endif
> =20
> +int kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi);
> +void kvm_irqfd_release(struct kvm *kvm);
> +
>  #endif
> diff --git a/virt/kvm/irqfd.c b/virt/kvm/irqfd.c
> new file mode 100644
> index 0000000..d2e0915
> --- /dev/null
> +++ b/virt/kvm/irqfd.c
> @@ -0,0 +1,146 @@
> +/*
> + * irqfd: Allows an eventfd to be used to inject an interrupt to the g=
uest
> + *
> + * Credit goes to Avi Kivity for the original idea.
> + *
> + * Copyright 2009 Novell.  All Rights Reserved.
> + *
> + * Author:
> + *	Gregory Haskins <ghaskins@novell.com>
> + *
> + * This file is free software; you can redistribute it and/or modify
> + * it under the terms of version 2 of the GNU General Public License
> + * as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software Foundat=
ion,
> + * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
> + */
> +
> +#include <linux/kvm_host.h>
> +#include <linux/eventfd.h>
> +#include <linux/workqueue.h>
> +#include <linux/wait.h>
> +#include <linux/poll.h>
> +#include <linux/file.h>
> +#include <linux/list.h>
> +
> +struct _irqfd {
> +	struct kvm               *kvm;
> +	int                       gsi;
> +	struct file              *file;
> +	struct list_head          list;
> +	poll_table                pt;
> +	wait_queue_head_t        *wqh;
> +	wait_queue_t              wait;
> +	struct work_struct        work;
> +};
> +
> +static void
> +irqfd_inject(struct work_struct *work)
> +{
> +	struct _irqfd *irqfd =3D container_of(work, struct _irqfd, work);
> +	struct kvm *kvm =3D irqfd->kvm;
> +
> +	mutex_lock(&kvm->lock);
> +	kvm_set_irq(kvm, kvm->irqfd.src, irqfd->gsi, 1);
> +	mutex_unlock(&kvm->lock);
> +}
> +
> +static int
> +irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
> +{
> +	struct _irqfd *irqfd =3D container_of(wait, struct _irqfd, wait);
> +
> +	/*
> +	 * The eventfd calls its wake_up with interrupts disabled,
> +	 * so we need to defer the IRQ injection until later since we need
> +	 * to acquire the kvm->lock to do so.
> +	 */
> +	schedule_work(&irqfd->work);
> +
> +	return 0;
> +}
> +
> +static void
> +irqfd_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh,
> +			poll_table *pt)
> +{
> +	struct _irqfd *irqfd =3D container_of(pt, struct _irqfd, pt);
> +
> +	irqfd->wqh =3D wqh;
> +	add_wait_queue(wqh, &irqfd->wait);
> +}
> +
> +int
> +kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
> +{
> +	struct _irqfd *irqfd;
> +	struct file *file;
> +	int ret;
> +
> +	irqfd =3D kzalloc(sizeof(*irqfd), GFP_KERNEL);
> +	if (!irqfd)
> +		return -ENOMEM;
> +
> +	irqfd->kvm =3D kvm;
> +	irqfd->gsi =3D gsi;
> +	INIT_LIST_HEAD(&irqfd->list);
> +	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
> +	init_poll_funcptr(&irqfd->pt, irqfd_ptable_queue_proc);
> +	INIT_WORK(&irqfd->work, irqfd_inject);
> +
> +	file =3D eventfd_fget(fd);
>  =20

I grab the fget() reference here, and I hold it until after I have
already called remove_wait_queue()...

> +	if (IS_ERR(file)) {
> +		ret =3D PTR_ERR(file);
> +		goto fail;
> +	}
> +
> +	ret =3D file->f_op->poll(file, &irqfd->pt);
> +	/* do we need to look for errors in ret? */
> +
> +	irqfd->file =3D file;
> +
> +	mutex_lock(&kvm->lock);
> +	if (kvm->irqfd.src =3D=3D -1) {
> +		ret =3D kvm_request_irq_source_id(kvm);
> +		BUG_ON(ret < 0);
> +
> +		kvm->irqfd.src =3D ret;
> +	}
> +
> +	list_add_tail(&irqfd->list, &kvm->irqfd.items);
> +
> +	mutex_unlock(&kvm->lock);
> +
> +	return 0;
> +
> +fail:
> +	kfree(irqfd);
> +	return ret;
> +}
> +
> +void
> +kvm_irqfd_release(struct kvm *kvm)
> +{
> +	struct _irqfd *irqfd, *tmp;
> +
> +	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfd.items, list) {
> +		remove_wait_queue(irqfd->wqh, &irqfd->wait);
> +
> +		flush_work(&irqfd->work);
> +		fput(irqfd->file);
>  =20

=2E.. here.

Please let me know if you see any holes in that approach.

-Greg


> +
> +		list_del(&irqfd->list);
> +		kfree(irqfd);
> +	}
> +
> +	if (kvm->irqfd.src !=3D -1)
> +		kvm_free_irq_source_id(kvm, kvm->irqfd.src);
> +
> +}
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3265566..c822d79 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -972,6 +972,8 @@ static struct kvm *kvm_create_vm(void)
>  	atomic_inc(&kvm->mm->mm_count);
>  	spin_lock_init(&kvm->mmu_lock);
>  	kvm_io_bus_init(&kvm->pio_bus);
> +	INIT_LIST_HEAD(&kvm->irqfd.items);
> +	kvm->irqfd.src =3D -1;
>  	mutex_init(&kvm->lock);
>  	kvm_io_bus_init(&kvm->mmio_bus);
>  	init_rwsem(&kvm->slots_lock);
> @@ -1023,6 +1025,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
>  	spin_lock(&kvm_lock);
>  	list_del(&kvm->vm_list);
>  	spin_unlock(&kvm_lock);
> +	kvm_irqfd_release(kvm);
>  	kvm_free_irq_routing(kvm);
>  	kvm_io_bus_destroy(&kvm->pio_bus);
>  	kvm_io_bus_destroy(&kvm->mmio_bus);
> @@ -2197,6 +2200,15 @@ static long kvm_vm_ioctl(struct file *filp,
>  	}
>  #endif
>  #endif /* KVM_CAP_IRQ_ROUTING */
> +	case KVM_ASSIGN_IRQFD: {
> +		struct kvm_irqfd data;
> +
> +		r =3D -EFAULT;
> +		if (copy_from_user(&data, argp, sizeof data))
> +			goto out;
> +		r =3D kvm_irqfd_assign(kvm, data.fd, data.gsi);
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



--------------enig7AB9E3EB9D3248BD0C3B043E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknx8d0ACgkQlOSOBdgZUxn99gCdHIAAvaEmlYZDFb3ZbizrKKgT
accAoIz7+PXE4TlF/ZL+EKf/I1VjWYWn
=h3Ra
-----END PGP SIGNATURE-----

--------------enig7AB9E3EB9D3248BD0C3B043E--
