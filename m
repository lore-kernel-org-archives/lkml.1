Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbZEZPaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbZEZPaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 11:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbZEZPaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 11:30:12 -0400
Received: from mail-qy0-f190.google.com ([209.85.221.190]:34578 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbZEZPaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 11:30:10 -0400
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 May 2009 11:30:10 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=YCkC0AMc4Y0AAuaTR8fv3QyJ/+E+fWBFl0Uo6bU0DWIcdnQIKE9h2g9OM7GGhFpORU
         WjLWeLhMnuRr9GdzVIyDRr0H/r1JAgxnpTsKAFa5uURAp8VWZncCUTukZ8nGA2Vetk/G
         QlYn6Qix1ilvCg+p1zKXWz0QsfvQT7I3o9zFI=
Message-ID: <4A1C095C.5010904@gmail.com>
Date: Tue, 26 May 2009 11:23:08 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mtosatti@redhat.com
Subject: Re: [KVM PATCH v3 2/4] kvm: add return value to kvm_io_bus_register_dev
References: <20090521165059.14851.83681.stgit@dev.haskins.net> <20090521165118.14851.66865.stgit@dev.haskins.net>
In-Reply-To: <20090521165118.14851.66865.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFEA4B038B7DC7C6E7D869947"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFEA4B038B7DC7C6E7D869947
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Today this function returns void and will internally BUG_ON if it fails=
=2E
> We want to create dynamic MMIO/PIO entries driven from userspace later =
in
> the series, so enhance this API to return an error code on failure.
>
> We also fix up all the callsites to check the return code, handle any
> failures, and percolate the error up to the caller.
>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
>
>  arch/x86/kvm/i8254.c      |   27 +++++++++++++++++----------
>  arch/x86/kvm/i8259.c      |    9 ++++++++-
>  include/linux/kvm_host.h  |    4 ++--
>  virt/kvm/coalesced_mmio.c |    8 ++++++--
>  virt/kvm/ioapic.c         |    9 +++++++--
>  virt/kvm/kvm_main.c       |    7 +++++--
>  6 files changed, 45 insertions(+), 19 deletions(-)
>
> diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
> index 4d6f0d2..3ef8b1b 100644
> --- a/arch/x86/kvm/i8254.c
> +++ b/arch/x86/kvm/i8254.c
> @@ -564,33 +564,36 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm)
>  {
>  	struct kvm_pit *pit;
>  	struct kvm_kpit_state *pit_state;
> +	int ret;
> =20
>  	pit =3D kzalloc(sizeof(struct kvm_pit), GFP_KERNEL);
>  	if (!pit)
>  		return NULL;
> =20
>  	pit->irq_source_id =3D kvm_request_irq_source_id(kvm);
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
> =20
>  	/* Initialize PIO device */
>  	pit->dev.read =3D pit_ioport_read;
>  	pit->dev.write =3D pit_ioport_write;
>  	pit->dev.in_range =3D pit_in_range;
>  	pit->dev.private =3D pit;
> -	kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
> +	ret =3D kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
> +	if (ret < 0)
> +		goto fail;
> =20
>  	pit->speaker_dev.read =3D speaker_ioport_read;
>  	pit->speaker_dev.write =3D speaker_ioport_write;
>  	pit->speaker_dev.in_range =3D speaker_in_range;
>  	pit->speaker_dev.private =3D pit;
> -	kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
> +	ret =3D kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
> +	if (ret < 0)
> +		goto fail;
> +
> +	mutex_init(&pit->pit_state.lock);
> +	mutex_lock(&pit->pit_state.lock);
> +	spin_lock_init(&pit->pit_state.inject_lock);
> =20
>  	kvm->arch.vpit =3D pit;
>  	pit->kvm =3D kvm;
> @@ -611,6 +614,10 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm)
>  	kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
> =20
>  	return pit;
> +
> +fail:
> +	kfree(pit);
>  =20

Hmm, this is broken.  I need to also potentially free any successfully
registered devices.  Looks like we need a v4 afterall.

> +	return NULL;
>  }
> =20
>  void kvm_free_pit(struct kvm *kvm)
> diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
> index 1ccb50c..0caf7d4 100644
> --- a/arch/x86/kvm/i8259.c
> +++ b/arch/x86/kvm/i8259.c
> @@ -519,6 +519,8 @@ static void pic_irq_request(void *opaque, int level=
)
>  struct kvm_pic *kvm_create_pic(struct kvm *kvm)
>  {
>  	struct kvm_pic *s;
> +	int ret;
> +
>  	s =3D kzalloc(sizeof(struct kvm_pic), GFP_KERNEL);
>  	if (!s)
>  		return NULL;
> @@ -538,6 +540,11 @@ struct kvm_pic *kvm_create_pic(struct kvm *kvm)
>  	s->dev.write =3D picdev_write;
>  	s->dev.in_range =3D picdev_in_range;
>  	s->dev.private =3D s;
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
> index 28bd112..5289552 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -61,8 +61,8 @@ void kvm_io_bus_init(struct kvm_io_bus *bus);
>  void kvm_io_bus_destroy(struct kvm_io_bus *bus);
>  struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
>  					  gpa_t addr, int len, int is_write);
> -void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
> -			     struct kvm_io_device *dev);
> +int kvm_io_bus_register_dev(struct kvm_io_bus *bus,
> +			    struct kvm_io_device *dev);
> =20
>  struct kvm_vcpu {
>  	struct kvm *kvm;
> diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
> index 5ae620d..ede9087 100644
> --- a/virt/kvm/coalesced_mmio.c
> +++ b/virt/kvm/coalesced_mmio.c
> @@ -86,6 +86,7 @@ static void coalesced_mmio_destructor(struct kvm_io_d=
evice *this)
>  int kvm_coalesced_mmio_init(struct kvm *kvm)
>  {
>  	struct kvm_coalesced_mmio_dev *dev;
> +	int ret;
> =20
>  	dev =3D kzalloc(sizeof(struct kvm_coalesced_mmio_dev), GFP_KERNEL);
>  	if (!dev)
> @@ -96,9 +97,12 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
>  	dev->dev.private  =3D dev;
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
> index 1eddae9..9be89f5 100644
> --- a/virt/kvm/ioapic.c
> +++ b/virt/kvm/ioapic.c
> @@ -317,6 +317,7 @@ void kvm_ioapic_reset(struct kvm_ioapic *ioapic)
>  int kvm_ioapic_init(struct kvm *kvm)
>  {
>  	struct kvm_ioapic *ioapic;
> +	int ret;
> =20
>  	ioapic =3D kzalloc(sizeof(struct kvm_ioapic), GFP_KERNEL);
>  	if (!ioapic)
> @@ -328,7 +329,11 @@ int kvm_ioapic_init(struct kvm *kvm)
>  	ioapic->dev.in_range =3D ioapic_in_range;
>  	ioapic->dev.private =3D ioapic;
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
> index de042cb..c71f276 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2463,11 +2463,14 @@ struct kvm_io_device *kvm_io_bus_find_dev(struc=
t kvm_io_bus *bus,
>  	return NULL;
>  }
> =20
> -void kvm_io_bus_register_dev(struct kvm_io_bus *bus, struct kvm_io_dev=
ice *dev)
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
>  }
> =20
>  static struct notifier_block kvm_cpu_notifier =3D {
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  =20



--------------enigFEA4B038B7DC7C6E7D869947
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkocCWAACgkQP5K2CMvXmqG8yQCfQwiadLVaqlTCGlE9nHCmgNYC
0WoAnjGtvhf3oXk+7LqiellhYaJNRqY6
=QMU1
-----END PGP SIGNATURE-----

--------------enigFEA4B038B7DC7C6E7D869947--
