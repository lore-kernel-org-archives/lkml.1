Return-Path: <linux-kernel-owner+w=401wt.eu-S1758622AbZFVPpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622AbZFVPpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbZFVPpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:45:22 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:50543 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbZFVPpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:45:19 -0400
Message-ID: <4A3FA6FC.9030301@novell.com>
Date: Mon, 22 Jun 2009 11:45:00 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH RFC] pass write value to in_range pointers
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622151631.GA14780@redhat.com>
In-Reply-To: <20090622151631.GA14780@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6D705559027E7C0129F50DD9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6D705559027E7C0129F50DD9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> It seems that a lot of complexity and trickiness with iosignalfd is
> handling the group/item relationship, which comes about because kvm doe=
s
> not currently let a device on the bus claim a write transaction based o=
n the
> value written.  This could be greatly simplified if the value written
> was passed to the in_range check for write operation.  We could then
> simply make each kvm_iosignalfd a device on the bus.
>
> What does everyone think of the following lightly tested patch?
>  =20

Hi Michael,
  Its interesting, but I am not convinced its necessary.  We created the
group/item layout because iosignalfds are unique in that they are
probably the only IO device that wants to do some kind of address
aliasing.  With what you are proposing here, you are adding aliasing
support to the general infrastructure which I am not (yet) convinced is
necessary.  If there isn't a use case for other devices to have
aliasing, I would think the logic is best contained in iosignalfd.  Do
you have something in mind?

Kind Regards,
-Greg

> -->
>
> Subject: kvm: pass value to in_range callback
>
> For write transactions, pass the value written to in_range checks so
> that we can make each iosignalfd a separate device on kvm bus.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>
> ---
>
>
> diff --git a/virt/kvm/iodev.h b/virt/kvm/iodev.h
> index 55e8846..98a25af 100644
> --- a/virt/kvm/iodev.h
> +++ b/virt/kvm/iodev.h
> @@ -28,7 +28,7 @@ struct kvm_io_device {
>  		      int len,
>  		      const void *val);
>  	int (*in_range)(struct kvm_io_device *this, gpa_t addr, int len,
> -			int is_write);
> +			int is_write, void *write_val);
>  	void (*destructor)(struct kvm_io_device *this);
> =20
>  	void             *private;
> @@ -51,9 +51,10 @@ static inline void kvm_iodevice_write(struct kvm_io_=
device *dev,
>  }
> =20
>  static inline int kvm_iodevice_inrange(struct kvm_io_device *dev,
> -				       gpa_t addr, int len, int is_write)
> +				       gpa_t addr, int len, int is_write,
> +				       void *write_val)
>  {
> -	return dev->in_range(dev, addr, len, is_write);
> +	return dev->in_range(dev, addr, len, is_write, write_val);
>  }
> =20
>  static inline void kvm_iodevice_destructor(struct kvm_io_device *dev)
> diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
> index 80c57b0..8cfdf9d 100644
> --- a/arch/ia64/kvm/kvm-ia64.c
> +++ b/arch/ia64/kvm/kvm-ia64.c
> @@ -211,11 +211,13 @@ int kvm_dev_ioctl_check_extension(long ext)
>  }
> =20
>  static struct kvm_io_device *vcpu_find_mmio_dev(struct kvm_vcpu *vcpu,=

> -					gpa_t addr, int len, int is_write)
> +					gpa_t addr, int len, int is_write,
> +					void *write_val)
>  {
>  	struct kvm_io_device *dev;
> =20
> -	dev =3D kvm_io_bus_find_dev(&vcpu->kvm->mmio_bus, addr, len, is_write=
);
> +	dev =3D kvm_io_bus_find_dev(&vcpu->kvm->mmio_bus, addr, len, is_write=
,
> +	                          write_val);
> =20
>  	return dev;
>  }
> @@ -247,7 +247,8 @@ static int handle_mmio(struct kvm_vcpu *vcpu, struc=
t kvm_run *kvm_run)
>  	kvm_run->exit_reason =3D KVM_EXIT_MMIO;
>  	return 0;
>  mmio:
> -	mmio_dev =3D vcpu_find_mmio_dev(vcpu, p->addr, p->size, !p->dir);
> +	mmio_dev =3D vcpu_find_mmio_dev(vcpu, p->addr, p->size,
> +				      !p->dir, &p->data);
>  	if (mmio_dev) {
>  		if (!p->dir)
>  			kvm_iodevice_write(mmio_dev, p->addr, p->size,
> diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
> index 4d6f0d2..5ba21ff 100644
> --- a/arch/x86/kvm/i8254.c
> +++ b/arch/x86/kvm/i8254.c
> @@ -485,7 +485,7 @@ static void pit_ioport_read(struct kvm_io_device *t=
his,
>  }
> =20
>  static int pit_in_range(struct kvm_io_device *this, gpa_t addr,
> -			int len, int is_write)
> +			int len, int is_write, void *write_val)
>  {
>  	return ((addr >=3D KVM_PIT_BASE_ADDRESS) &&
>  		(addr < KVM_PIT_BASE_ADDRESS + KVM_PIT_MEM_LENGTH));
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index ae99d83..456fd53 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -721,7 +721,7 @@ static void apic_mmio_write(struct kvm_io_device *t=
his,
>  }
> =20
>  static int apic_mmio_range(struct kvm_io_device *this, gpa_t addr,
> -			   int len, int size)
> +			   int len, int is_write, void *write_val)
>  {
>  	struct kvm_lapic *apic =3D (struct kvm_lapic *)this->private;
>  	int ret =3D 0;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 249540f..9d29017 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2043,13 +2043,13 @@ static void kvm_init_msr_list(void)
>   */
>  static struct kvm_io_device *vcpu_find_pervcpu_dev(struct kvm_vcpu *vc=
pu,
>  						gpa_t addr, int len,
> -						int is_write)
> +						int is_write, void *write_val)
>  {
>  	struct kvm_io_device *dev;
> =20
>  	if (vcpu->arch.apic) {
>  		dev =3D &vcpu->arch.apic->dev;
> -		if (dev->in_range(dev, addr, len, is_write))
> +		if (dev->in_range(dev, addr, len, is_write, write_val))
>  			return dev;
>  	}
>  	return NULL;
> @@ -2058,14 +2058,14 @@ static struct kvm_io_device *vcpu_find_pervcpu_=
dev(struct kvm_vcpu *vcpu,
> =20
>  static struct kvm_io_device *vcpu_find_mmio_dev(struct kvm_vcpu *vcpu,=

>  						gpa_t addr, int len,
> -						int is_write)
> +						int is_write, void *write_val)
>  {
>  	struct kvm_io_device *dev;
> =20
> -	dev =3D vcpu_find_pervcpu_dev(vcpu, addr, len, is_write);
> +	dev =3D vcpu_find_pervcpu_dev(vcpu, addr, len, is_write, write_val);
>  	if (dev =3D=3D NULL)
>  		dev =3D kvm_io_bus_find_dev(&vcpu->kvm->mmio_bus, addr, len,
> -					  is_write);
> +					  is_write, write_val);
>  	return dev;
>  }
> =20
> @@ -2161,7 +2161,7 @@ mmio:
>  	 * Is this MMIO handled locally?
>  	 */
>  	mutex_lock(&vcpu->kvm->lock);
> -	mmio_dev =3D vcpu_find_mmio_dev(vcpu, gpa, bytes, 0);
> +	mmio_dev =3D vcpu_find_mmio_dev(vcpu, gpa, bytes, 0, NULL);
>  	if (mmio_dev) {
>  		kvm_iodevice_read(mmio_dev, gpa, bytes, val);
>  		mutex_unlock(&vcpu->kvm->lock);
> @@ -2216,7 +2216,7 @@ mmio:
>  	 * Is this MMIO handled locally?
>  	 */
>  	mutex_lock(&vcpu->kvm->lock);
> -	mmio_dev =3D vcpu_find_mmio_dev(vcpu, gpa, bytes, 1);
> +	mmio_dev =3D vcpu_find_mmio_dev(vcpu, gpa, bytes, 1, val);
>  	if (mmio_dev) {
>  		kvm_iodevice_write(mmio_dev, gpa, bytes, val);
>  		mutex_unlock(&vcpu->kvm->lock);
> @@ -2576,9 +2576,10 @@ static void pio_string_write(struct kvm_io_devic=
e *pio_dev,
> =20
>  static struct kvm_io_device *vcpu_find_pio_dev(struct kvm_vcpu *vcpu,
>  					       gpa_t addr, int len,
> -					       int is_write)
> +					       int is_write, void *write_val)
>  {
> -	return kvm_io_bus_find_dev(&vcpu->kvm->pio_bus, addr, len, is_write);=

> +	return kvm_io_bus_find_dev(&vcpu->kvm->pio_bus, addr, len, is_write,
> +	                           write_val);
>  }
> =20
>  int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in=
,
> @@ -2608,7 +2608,8 @@ int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct=
 kvm_run *run, int in,
>  	val =3D kvm_register_read(vcpu, VCPU_REGS_RAX);
>  	memcpy(vcpu->arch.pio_data, &val, 4);
> =20
> -	pio_dev =3D vcpu_find_pio_dev(vcpu, port, size, !in);
> +	pio_dev =3D vcpu_find_pio_dev(vcpu, port, size, !in,
> +				    vcpu->arch.pio_data);
>  	if (pio_dev) {
>  		kernel_pio(pio_dev, vcpu, vcpu->arch.pio_data);
>  		complete_pio(vcpu);
> @@ -2624,7 +2625,6 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu,=
 struct kvm_run *run, int in,
>  {
>  	unsigned now, in_page;
>  	int ret =3D 0;
> -	struct kvm_io_device *pio_dev;
> =20
>  	vcpu->run->exit_reason =3D KVM_EXIT_IO;
>  	vcpu->run->io.direction =3D in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
> @@ -2672,9 +2672,6 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu,=
 struct kvm_run *run, int in,
> =20
>  	vcpu->arch.pio.guest_gva =3D address;
> =20
> -	pio_dev =3D vcpu_find_pio_dev(vcpu, port,
> -				    vcpu->arch.pio.cur_count,
> -				    !vcpu->arch.pio.in);
>  	if (!vcpu->arch.pio.in) {
>  		/* string PIO write */
>  		ret =3D pio_copy_data(vcpu);
> @@ -2682,13 +2679,20 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcp=
u, struct kvm_run *run, int in,
>  			kvm_inject_gp(vcpu, 0);
>  			return 1;
>  		}
> -		if (ret =3D=3D 0 && pio_dev) {
> -			pio_string_write(pio_dev, vcpu);
> -			complete_pio(vcpu);
> -			if (vcpu->arch.pio.count =3D=3D 0)
> -				ret =3D 1;
> +		if (ret =3D=3D 0) {
> +			struct kvm_io_device *pio_dev;
> +			pio_dev =3D vcpu_find_pio_dev(vcpu, port,
> +						    vcpu->arch.pio.cur_count,
> +						    1, vcpu->arch.pio_data);
> +			if (pio_dev) {
> +				pio_string_write(pio_dev, vcpu);
> +				complete_pio(vcpu);
> +				if (vcpu->arch.pio.count =3D=3D 0)
> +					ret =3D 1;
> +			}
>  		}
> -	} else if (pio_dev)
> +	} else if (vcpu_find_pio_dev(vcpu, port, vcpu->arch.pio.cur_count, 0,=

> +				     NULL))
>  		pr_unimpl(vcpu, "no string pio read support yet, "
>  		       "port %x size %d count %ld\n",
>  			port, size, count);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index aacc544..0fb7938 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -60,7 +60,8 @@ struct kvm_io_bus {
>  void kvm_io_bus_init(struct kvm_io_bus *bus);
>  void kvm_io_bus_destroy(struct kvm_io_bus *bus);
>  struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
> -					  gpa_t addr, int len, int is_write);
> +					  gpa_t addr, int len, int is_write,
> +					  void *write_val);
>  void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
>  			     struct kvm_io_device *dev);
> =20
> diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
> index 5ae620d..3a1cbfd 100644
> --- a/virt/kvm/coalesced_mmio.c
> +++ b/virt/kvm/coalesced_mmio.c
> @@ -15,7 +15,8 @@
>  #include "coalesced_mmio.h"
> =20
>  static int coalesced_mmio_in_range(struct kvm_io_device *this,
> -				   gpa_t addr, int len, int is_write)
> +				   gpa_t addr, int len, int is_write,
> +				   void *write_val)
>  {
>  	struct kvm_coalesced_mmio_dev *dev =3D
>  				(struct kvm_coalesced_mmio_dev*)this->private;
> diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
> index 1eddae9..2adbb1b 100644
> --- a/virt/kvm/ioapic.c
> +++ b/virt/kvm/ioapic.c
> @@ -221,7 +221,8 @@ void kvm_ioapic_update_eoi(struct kvm *kvm, int vec=
tor, int trigger_mode)
>  }
> =20
>  static int ioapic_in_range(struct kvm_io_device *this, gpa_t addr,
> -			   int len, int is_write)
> +			   int len, int is_write,
> +			   void *write_val)
>  {
>  	struct kvm_ioapic *ioapic =3D (struct kvm_ioapic *)this->private;
> =20
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7645543..b97e390 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2445,14 +2445,15 @@ void kvm_io_bus_destroy(struct kvm_io_bus *bus)=

>  }
> =20
>  struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
> -					  gpa_t addr, int len, int is_write)
> +					  gpa_t addr, int len, int is_write,
> +					  void *write_val)
>  {
>  	int i;
> =20
>  	for (i =3D 0; i < bus->dev_count; i++) {
>  		struct kvm_io_device *pos =3D bus->devs[i];
> =20
> -		if (pos->in_range(pos, addr, len, is_write))
> +		if (pos->in_range(pos, addr, len, is_write, write_val))
>  			return pos;
>  	}
> =20
>  =20



--------------enig6D705559027E7C0129F50DD9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko/pvwACgkQlOSOBdgZUxkOgwCbBEqJIItCaywqJCwgQNafFrHx
MYMAn2TLefartpdVjH2VZPOgyWfPOkvT
=IF1E
-----END PGP SIGNATURE-----

--------------enig6D705559027E7C0129F50DD9--
