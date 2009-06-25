Return-Path: <linux-kernel-owner+w=401wt.eu-S1754973AbZFYOWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbZFYOWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZFYOWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:22:34 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36957 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbZFYOWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:22:33 -0400
Message-ID: <4A438825.5000606@novell.com>
Date: Thu, 25 Jun 2009 10:22:29 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: avi@redhat.com
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com,
       "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [KVM PATCH v8 1/3] KVM: make io_bus interface more robust
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003035.15859.33528.stgit@dev.haskins.net>
In-Reply-To: <20090619003035.15859.33528.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9FB8B942C8DCC9322915D42B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9FB8B942C8DCC9322915D42B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Today kvm_io_bus_regsiter_dev() returns void and will internally BUG_ON=
 if it
> fails.  We want to create dynamic MMIO/PIO entries driven from userspac=
e later
> in the series, so we need to enhance the code to be more robust with th=
e
> following changes:
>
>    1) Add a return value to the registration function
>    2) Fix up all the callsites to check the return code, handle any
>       failures, and percolate the error up to the caller.
>    3) Add an unregister function that collapses holes in the array
>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>  =20

Hi Avi,
  While the disposition on the iosignalfd patch w.r.t. current proposals
by Michael is up in the air, this patch has not had and comments in a
while.  Please at least consider this one for merging ASAP so we can
base some of the other io_bus cleanups on it.

Thanks,
-Greg

> ---
>
>  arch/x86/kvm/i8254.c      |   22 ++++++++++++++++++++--
>  arch/x86/kvm/i8259.c      |    9 ++++++++-
>  include/linux/kvm_host.h  |    6 ++++--
>  virt/kvm/coalesced_mmio.c |    8 ++++++--
>  virt/kvm/ioapic.c         |    9 +++++++--
>  virt/kvm/kvm_main.c       |   23 +++++++++++++++++++++--
>  6 files changed, 66 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
> index 331705f..1c41715 100644
> --- a/arch/x86/kvm/i8254.c
> +++ b/arch/x86/kvm/i8254.c
> @@ -586,6 +586,7 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32=
 flags)
>  {
>  	struct kvm_pit *pit;
>  	struct kvm_kpit_state *pit_state;
> +	int ret;
> =20
>  	pit =3D kzalloc(sizeof(struct kvm_pit), GFP_KERNEL);
>  	if (!pit)
> @@ -620,14 +621,31 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u=
32 flags)
>  	kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
> =20
>  	kvm_iodevice_init(&pit->dev, &pit_dev_ops);
> -	kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
> +	ret =3D kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
> +	if (ret < 0)
> +		goto fail;
> =20
>  	if (flags & KVM_PIT_SPEAKER_DUMMY) {
>  		kvm_iodevice_init(&pit->speaker_dev, &speaker_dev_ops);
> -		kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
> +		ret =3D kvm_io_bus_register_dev(&kvm->pio_bus,
> +					      &pit->speaker_dev);
> +		if (ret < 0)
> +			goto fail;
>  	}
> =20
>  	return pit;
> +
> +fail:
> +	if (flags & KVM_PIT_SPEAKER_DUMMY)
> +		kvm_io_bus_unregister_dev(&kvm->pio_bus, &pit->speaker_dev);
> +
> +	kvm_io_bus_unregister_dev(&kvm->pio_bus, &pit->dev);
> +
> +	if (pit->irq_source_id >=3D 0)
> +		kvm_free_irq_source_id(kvm, pit->irq_source_id);
> +
> +	kfree(pit);
> +	return NULL;
>  }
> =20
>  void kvm_free_pit(struct kvm *kvm)
> diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
> index 148c52a..66e37c2 100644
> --- a/arch/x86/kvm/i8259.c
> +++ b/arch/x86/kvm/i8259.c
> @@ -532,6 +532,8 @@ static const struct kvm_io_device_ops picdev_ops =3D=
 {
>  struct kvm_pic *kvm_create_pic(struct kvm *kvm)
>  {
>  	struct kvm_pic *s;
> +	int ret;
> +
>  	s =3D kzalloc(sizeof(struct kvm_pic), GFP_KERNEL);
>  	if (!s)
>  		return NULL;
> @@ -548,6 +550,11 @@ struct kvm_pic *kvm_create_pic(struct kvm *kvm)
>  	 * Initialize PIO device
>  	 */
>  	kvm_iodevice_init(&s->dev, &picdev_ops);
> -	kvm_io_bus_register_dev(&kvm->pio_bus, &s->dev);
> +	ret =3D kvm_io_bus_register_dev(&kvm->pio_bus, &s->dev);
> +	if (ret < 0) {
> +		kfree(s);
> +		return NULL;
> +	}
> +
>  	return s;
>  }
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e4e78db..eafa2b3 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -61,8 +61,10 @@ void kvm_io_bus_init(struct kvm_io_bus *bus);
>  void kvm_io_bus_destroy(struct kvm_io_bus *bus);
>  struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
>  					  gpa_t addr, int len, int is_write);
> -void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
> -			     struct kvm_io_device *dev);
> +int kvm_io_bus_register_dev(struct kvm_io_bus *bus,
> +			    struct kvm_io_device *dev);
> +void kvm_io_bus_unregister_dev(struct kvm_io_bus *bus,
> +			    struct kvm_io_device *dev);
> =20
>  struct kvm_vcpu {
>  	struct kvm *kvm;
> diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
> index 397f419..3e89db8 100644
> --- a/virt/kvm/coalesced_mmio.c
> +++ b/virt/kvm/coalesced_mmio.c
> @@ -94,6 +94,7 @@ static const struct kvm_io_device_ops coalesced_mmio_=
ops =3D {
>  int kvm_coalesced_mmio_init(struct kvm *kvm)
>  {
>  	struct kvm_coalesced_mmio_dev *dev;
> +	int ret;
> =20
>  	dev =3D kzalloc(sizeof(struct kvm_coalesced_mmio_dev), GFP_KERNEL);
>  	if (!dev)
> @@ -102,9 +103,12 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
>  	kvm_iodevice_init(&dev->dev, &coalesced_mmio_ops);
>  	dev->kvm =3D kvm;
>  	kvm->coalesced_mmio_dev =3D dev;
> -	kvm_io_bus_register_dev(&kvm->mmio_bus, &dev->dev);
> =20
> -	return 0;
> +	ret =3D kvm_io_bus_register_dev(&kvm->mmio_bus, &dev->dev);
> +	if (ret < 0)
> +		kfree(dev);
> +
> +	return ret;
>  }
> =20
>  int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
> diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
> index d8b2eca..28adb05 100644
> --- a/virt/kvm/ioapic.c
> +++ b/virt/kvm/ioapic.c
> @@ -335,6 +335,7 @@ static const struct kvm_io_device_ops ioapic_mmio_o=
ps =3D {
>  int kvm_ioapic_init(struct kvm *kvm)
>  {
>  	struct kvm_ioapic *ioapic;
> +	int ret;
> =20
>  	ioapic =3D kzalloc(sizeof(struct kvm_ioapic), GFP_KERNEL);
>  	if (!ioapic)
> @@ -343,7 +344,11 @@ int kvm_ioapic_init(struct kvm *kvm)
>  	kvm_ioapic_reset(ioapic);
>  	kvm_iodevice_init(&ioapic->dev, &ioapic_mmio_ops);
>  	ioapic->kvm =3D kvm;
> -	kvm_io_bus_register_dev(&kvm->mmio_bus, &ioapic->dev);
> -	return 0;
> +
> +	ret =3D kvm_io_bus_register_dev(&kvm->mmio_bus, &ioapic->dev);
> +	if (ret < 0)
> +		kfree(ioapic);
> +
> +	return ret;
>  }
> =20
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9fab08e..6bd71f7 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2481,11 +2481,30 @@ struct kvm_io_device *kvm_io_bus_find_dev(struc=
t kvm_io_bus *bus,
>  	return NULL;
>  }
> =20
> -void kvm_io_bus_register_dev(struct kvm_io_bus *bus, struct kvm_io_dev=
ice *dev)
> +/* assumes kvm->lock held */
> +int kvm_io_bus_register_dev(struct kvm_io_bus *bus, struct kvm_io_devi=
ce *dev)
>  {
> -	BUG_ON(bus->dev_count > (NR_IOBUS_DEVS-1));
> +	if (bus->dev_count > (NR_IOBUS_DEVS-1))
> +		return -ENOSPC;
> =20
>  	bus->devs[bus->dev_count++] =3D dev;
> +
> +	return 0;
> +}
> +
> +/* assumes kvm->lock held */
> +void kvm_io_bus_unregister_dev(struct kvm_io_bus *bus,
> +			       struct kvm_io_device *dev)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < bus->dev_count; i++) {
> +
> +		if (bus->devs[i] =3D=3D dev) {
> +			bus->devs[i] =3D bus->devs[--bus->dev_count];
> +			return;
> +		}
> +	}
>  }
> =20
>  static struct notifier_block kvm_cpu_notifier =3D {
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  =20



--------------enig9FB8B942C8DCC9322915D42B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpDiCUACgkQlOSOBdgZUxn5TwCfVd2xKJraX6wgTnsAQQ3Y1qis
JKsAn19QytUOLS9xLD7uOxIkOnSyJ2r+
=c6PC
-----END PGP SIGNATURE-----

--------------enig9FB8B942C8DCC9322915D42B--
