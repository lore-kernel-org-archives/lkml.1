Return-Path: <linux-kernel-owner+w=401wt.eu-S1760449AbZFWPWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760449AbZFWPWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbZFWPWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:22:00 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:38975 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760167AbZFWPV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:21:58 -0400
Message-ID: <4A40F311.80105@novell.com>
Date: Tue, 23 Jun 2009 11:21:53 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH] kvm: remove in_range from kvm_io_device
References: <20090623150008.GA21059@redhat.com>
In-Reply-To: <20090623150008.GA21059@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8EC5800C03221941FFE2B91E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8EC5800C03221941FFE2B91E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> Remove in_range from kvm_io_device and ask read/write callbacks, if
> supplied, to perform range checks internally. This allows aliasing
> (mostly for in-kernel virtio), as well as better error handling by
> making it possible to pass errors up to userspace. And it's enough to
> look at the diffstat to see that it's a better API anyway.
>
> While we are at it, document locking rules for kvm_io_device.
>  =20

Sorry, not trying to be a PITA, but I liked your last suggestion better. =
 :(

I am thinking forward to when we want to use something smarter than a
linear search (like rbtree/radix) for scaling the number of "devices"
(really, virtio-rings) that we support.   The current device-count
target is 512, which we will begin to rapidly consume as the in-kernel
virtio work progresses.  This proposed approach forces us into a
potential O(256) algorithm in the hotpath (all MMIO/PIO exits will hit
this, not just in-kernel users).  How would you address this?

Regards,
-Greg

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> This is a replacement for my patch extending in_range.
> This works for me, but please review carefully.
>
>  arch/ia64/kvm/kvm-ia64.c  |   28 ++++---------
>  arch/x86/kvm/i8254.c      |   49 ++++++++++++----------
>  arch/x86/kvm/i8259.c      |   22 ++++++----
>  arch/x86/kvm/lapic.c      |   48 ++++++++++------------
>  arch/x86/kvm/x86.c        |  100 +++++++++++++++----------------------=
--------
>  include/linux/kvm_host.h  |    6 ++-
>  virt/kvm/coalesced_mmio.c |   26 +++++-------
>  virt/kvm/ioapic.c         |   24 ++++++-----
>  virt/kvm/iodev.h          |   34 ++++++---------
>  virt/kvm/kvm_main.c       |   25 +++++++-----
>  10 files changed, 158 insertions(+), 204 deletions(-)
>
> diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
> index d20a5db..647ff91 100644
> --- a/arch/ia64/kvm/kvm-ia64.c
> +++ b/arch/ia64/kvm/kvm-ia64.c
> @@ -198,16 +198,6 @@ int kvm_dev_ioctl_check_extension(long ext)
> =20
>  }
> =20
> -static struct kvm_io_device *vcpu_find_mmio_dev(struct kvm_vcpu *vcpu,=

> -					gpa_t addr, int len, int is_write)
> -{
> -	struct kvm_io_device *dev;
> -
> -	dev =3D kvm_io_bus_find_dev(&vcpu->kvm->mmio_bus, addr, len, is_write=
);
> -
> -	return dev;
> -}
> -
>  static int handle_vm_error(struct kvm_vcpu *vcpu, struct kvm_run *kvm_=
run)
>  {
>  	kvm_run->exit_reason =3D KVM_EXIT_UNKNOWN;
> @@ -219,6 +209,7 @@ static int handle_mmio(struct kvm_vcpu *vcpu, struc=
t kvm_run *kvm_run)
>  {
>  	struct kvm_mmio_req *p;
>  	struct kvm_io_device *mmio_dev;
> +	int r;
> =20
>  	p =3D kvm_get_vcpu_ioreq(vcpu);
> =20
> @@ -235,16 +226,13 @@ static int handle_mmio(struct kvm_vcpu *vcpu, str=
uct kvm_run *kvm_run)
>  	kvm_run->exit_reason =3D KVM_EXIT_MMIO;
>  	return 0;
>  mmio:
> -	mmio_dev =3D vcpu_find_mmio_dev(vcpu, p->addr, p->size, !p->dir);
> -	if (mmio_dev) {
> -		if (!p->dir)
> -			kvm_iodevice_write(mmio_dev, p->addr, p->size,
> -						&p->data);
> -		else
> -			kvm_iodevice_read(mmio_dev, p->addr, p->size,
> -						&p->data);
> -
> -	} else
> +	if (p->dir)
> +		r =3D kvm_io_bus_read(&vcpu->kvm->mmio_bus, p->addr, p->size,
> +				    &p->data);
> +	else
> +		r =3D kvm_io_bus_write(&vcpu->kvm->mmio_bus, p->addr, p->size,
> +				     &p->data);
> +	if (r)
>  		printk(KERN_ERR"kvm: No iodevice found! addr:%lx\n", p->addr);
>  	p->state =3D STATE_IORESP_READY;
> =20
> diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
> index c13bb92..d5881a4 100644
> --- a/arch/x86/kvm/i8254.c
> +++ b/arch/x86/kvm/i8254.c
> @@ -336,8 +336,14 @@ void kvm_pit_load_count(struct kvm *kvm, int chann=
el, u32 val)
>  	mutex_unlock(&kvm->arch.vpit->pit_state.lock);
>  }
> =20
> -static void pit_ioport_write(struct kvm_io_device *this,
> -			     gpa_t addr, int len, const void *data)
> +static inline int pit_in_range(gpa_t addr)
> +{
> +	return ((addr >=3D KVM_PIT_BASE_ADDRESS) &&
> +		(addr < KVM_PIT_BASE_ADDRESS + KVM_PIT_MEM_LENGTH));
> +}
> +
> +static int pit_ioport_write(struct kvm_io_device *this,
> +			    gpa_t addr, int len, const void *data)
>  {
>  	struct kvm_pit *pit =3D (struct kvm_pit *)this->private;
>  	struct kvm_kpit_state *pit_state =3D &pit->pit_state;
> @@ -345,6 +351,8 @@ static void pit_ioport_write(struct kvm_io_device *=
this,
>  	int channel, access;
>  	struct kvm_kpit_channel_state *s;
>  	u32 val =3D *(u32 *) data;
> +	if (!pit_in_range(addr))
> +		return -EOPNOTSUPP;
> =20
>  	val  &=3D 0xff;
>  	addr &=3D KVM_PIT_CHANNEL_MASK;
> @@ -407,16 +415,19 @@ static void pit_ioport_write(struct kvm_io_device=
 *this,
>  	}
> =20
>  	mutex_unlock(&pit_state->lock);
> +	return 0;
>  }
> =20
> -static void pit_ioport_read(struct kvm_io_device *this,
> -			    gpa_t addr, int len, void *data)
> +static int pit_ioport_read(struct kvm_io_device *this,
> +			   gpa_t addr, int len, void *data)
>  {
>  	struct kvm_pit *pit =3D (struct kvm_pit *)this->private;
>  	struct kvm_kpit_state *pit_state =3D &pit->pit_state;
>  	struct kvm *kvm =3D pit->kvm;
>  	int ret, count;
>  	struct kvm_kpit_channel_state *s;
> +	if (!pit_in_range(addr))
> +		return -EOPNOTSUPP;
> =20
>  	addr &=3D KVM_PIT_CHANNEL_MASK;
>  	s =3D &pit_state->channels[addr];
> @@ -471,37 +482,36 @@ static void pit_ioport_read(struct kvm_io_device =
*this,
>  	memcpy(data, (char *)&ret, len);
> =20
>  	mutex_unlock(&pit_state->lock);
> +	return 0;
>  }
> =20
> -static int pit_in_range(struct kvm_io_device *this, gpa_t addr,
> -			int len, int is_write)
> -{
> -	return ((addr >=3D KVM_PIT_BASE_ADDRESS) &&
> -		(addr < KVM_PIT_BASE_ADDRESS + KVM_PIT_MEM_LENGTH));
> -}
> -
> -static void speaker_ioport_write(struct kvm_io_device *this,
> -				 gpa_t addr, int len, const void *data)
> +static int speaker_ioport_write(struct kvm_io_device *this,
> +				gpa_t addr, int len, const void *data)
>  {
>  	struct kvm_pit *pit =3D (struct kvm_pit *)this->private;
>  	struct kvm_kpit_state *pit_state =3D &pit->pit_state;
>  	struct kvm *kvm =3D pit->kvm;
>  	u32 val =3D *(u32 *) data;
> +	if (addr !=3D KVM_SPEAKER_BASE_ADDRESS)
> +		return -EOPNOTSUPP;
> =20
>  	mutex_lock(&pit_state->lock);
>  	pit_state->speaker_data_on =3D (val >> 1) & 1;
>  	pit_set_gate(kvm, 2, val & 1);
>  	mutex_unlock(&pit_state->lock);
> +	return 0;
>  }
> =20
> -static void speaker_ioport_read(struct kvm_io_device *this,
> -				gpa_t addr, int len, void *data)
> +static int speaker_ioport_read(struct kvm_io_device *this,
> +			       gpa_t addr, int len, void *data)
>  {
>  	struct kvm_pit *pit =3D (struct kvm_pit *)this->private;
>  	struct kvm_kpit_state *pit_state =3D &pit->pit_state;
>  	struct kvm *kvm =3D pit->kvm;
>  	unsigned int refresh_clock;
>  	int ret;
> +	if (addr !=3D KVM_SPEAKER_BASE_ADDRESS)
> +		return -EOPNOTSUPP;
> =20
>  	/* Refresh clock toggles at about 15us. We approximate as 2^14ns. */
>  	refresh_clock =3D ((unsigned int)ktime_to_ns(ktime_get()) >> 14) & 1;=

> @@ -513,12 +523,7 @@ static void speaker_ioport_read(struct kvm_io_devi=
ce *this,
>  		len =3D sizeof(ret);
>  	memcpy(data, (char *)&ret, len);
>  	mutex_unlock(&pit_state->lock);
> -}
> -
> -static int speaker_in_range(struct kvm_io_device *this, gpa_t addr,
> -			    int len, int is_write)
> -{
> -	return (addr =3D=3D KVM_SPEAKER_BASE_ADDRESS);
> +	return 0;
>  }
> =20
>  void kvm_pit_reset(struct kvm_pit *pit)
> @@ -571,13 +576,11 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm)
>  	/* Initialize PIO device */
>  	pit->dev.read =3D pit_ioport_read;
>  	pit->dev.write =3D pit_ioport_write;
> -	pit->dev.in_range =3D pit_in_range;
>  	pit->dev.private =3D pit;
>  	kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
> =20
>  	pit->speaker_dev.read =3D speaker_ioport_read;
>  	pit->speaker_dev.write =3D speaker_ioport_write;
> -	pit->speaker_dev.in_range =3D speaker_in_range;
>  	pit->speaker_dev.private =3D pit;
>  	kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
> =20
> diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
> index 1ccb50c..dc2d3a3 100644
> --- a/arch/x86/kvm/i8259.c
> +++ b/arch/x86/kvm/i8259.c
> @@ -428,8 +428,7 @@ static u32 elcr_ioport_read(void *opaque, u32 addr1=
)
>  	return s->elcr;
>  }
> =20
> -static int picdev_in_range(struct kvm_io_device *this, gpa_t addr,
> -			   int len, int is_write)
> +static int picdev_in_range(gpa_t addr)
>  {
>  	switch (addr) {
>  	case 0x20:
> @@ -444,16 +443,18 @@ static int picdev_in_range(struct kvm_io_device *=
this, gpa_t addr,
>  	}
>  }
> =20
> -static void picdev_write(struct kvm_io_device *this,
> -			 gpa_t addr, int len, const void *val)
> +static int picdev_write(struct kvm_io_device *this,
> +			gpa_t addr, int len, const void *val)
>  {
>  	struct kvm_pic *s =3D this->private;
>  	unsigned char data =3D *(unsigned char *)val;
> +	if (!picdev_in_range(addr))
> +		return -EOPNOTSUPP;
> =20
>  	if (len !=3D 1) {
>  		if (printk_ratelimit())
>  			printk(KERN_ERR "PIC: non byte write\n");
> -		return;
> +		return 0;
>  	}
>  	pic_lock(s);
>  	switch (addr) {
> @@ -469,18 +470,21 @@ static void picdev_write(struct kvm_io_device *th=
is,
>  		break;
>  	}
>  	pic_unlock(s);
> +	return 0;
>  }
> =20
> -static void picdev_read(struct kvm_io_device *this,
> -			gpa_t addr, int len, void *val)
> +static int picdev_read(struct kvm_io_device *this,
> +		       gpa_t addr, int len, void *val)
>  {
>  	struct kvm_pic *s =3D this->private;
>  	unsigned char data =3D 0;
> +	if (!picdev_in_range(addr))
> +		return -EOPNOTSUPP;
> =20
>  	if (len !=3D 1) {
>  		if (printk_ratelimit())
>  			printk(KERN_ERR "PIC: non byte read\n");
> -		return;
> +		return 0;
>  	}
>  	pic_lock(s);
>  	switch (addr) {
> @@ -497,6 +501,7 @@ static void picdev_read(struct kvm_io_device *this,=

>  	}
>  	*(unsigned char *)val =3D data;
>  	pic_unlock(s);
> +	return 0;
>  }
> =20
>  /*
> @@ -536,7 +541,6 @@ struct kvm_pic *kvm_create_pic(struct kvm *kvm)
>  	 */
>  	s->dev.read =3D picdev_read;
>  	s->dev.write =3D picdev_write;
> -	s->dev.in_range =3D picdev_in_range;
>  	s->dev.private =3D s;
>  	kvm_io_bus_register_dev(&kvm->pio_bus, &s->dev);
>  	return s;
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index f0b67f2..62e7e05 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -584,18 +584,27 @@ static u32 __apic_read(struct kvm_lapic *apic, un=
signed int offset)
>  	return val;
>  }
> =20
> -static void apic_mmio_read(struct kvm_io_device *this,
> -			   gpa_t address, int len, void *data)
> +static int apic_mmio_in_range(struct kvm_lapic *apic, gpa_t addr)
>  {
> -	struct kvm_lapic *apic =3D (struct kvm_lapic *)this->private;
> +	return apic_hw_enabled(apic) &&
> +	    addr >=3D apic->base_address &&
> +	    addr < apic->base_address + LAPIC_MMIO_LENGTH;
> +}
> +
> +static int apic_mmio_read(struct kvm_io_device *this,
> +			  gpa_t address, int len, void *data)
> +{
> +	struct kvm_lapic *apic =3D this->private;
>  	unsigned int offset =3D address - apic->base_address;
>  	unsigned char alignment =3D offset & 0xf;
>  	u32 result;
> +	if (!apic_mmio_in_range(apic, address))
> +		return -EOPNOTSUPP;
> =20
>  	if ((alignment + len) > 4) {
>  		printk(KERN_ERR "KVM_APIC_READ: alignment error %lx %d",
>  		       (unsigned long)address, len);
> -		return;
> +		return 0;
>  	}
>  	result =3D __apic_read(apic, offset & ~0xf);
> =20
> @@ -610,6 +619,7 @@ static void apic_mmio_read(struct kvm_io_device *th=
is,
>  		       "should be 1,2, or 4 instead\n", len);
>  		break;
>  	}
> +	return 0;
>  }
> =20
>  static void update_divide_count(struct kvm_lapic *apic)
> @@ -665,13 +675,15 @@ static void apic_manage_nmi_watchdog(struct kvm_l=
apic *apic, u32 lvt0_val)
>  		apic->vcpu->kvm->arch.vapics_in_nmi_mode--;
>  }
> =20
> -static void apic_mmio_write(struct kvm_io_device *this,
> -			    gpa_t address, int len, const void *data)
> +static int apic_mmio_write(struct kvm_io_device *this,
> +			   gpa_t address, int len, const void *data)
>  {
> -	struct kvm_lapic *apic =3D (struct kvm_lapic *)this->private;
> +	struct kvm_lapic *apic =3D this->private;
>  	unsigned int offset =3D address - apic->base_address;
>  	unsigned char alignment =3D offset & 0xf;
>  	u32 val;
> +	if (!apic_mmio_in_range(apic, address))
> +		return -EOPNOTSUPP;
> =20
>  	/*
>  	 * APIC register must be aligned on 128-bits boundary.
> @@ -682,7 +694,7 @@ static void apic_mmio_write(struct kvm_io_device *t=
his,
>  		/* Don't shout loud, $infamous_os would cause only noise. */
>  		apic_debug("apic write: bad size=3D%d %lx\n",
>  			   len, (long)address);
> -		return;
> +		return 0;
>  	}
> =20
>  	val =3D *(u32 *) data;
> @@ -765,7 +777,7 @@ static void apic_mmio_write(struct kvm_io_device *t=
his,
>  		hrtimer_cancel(&apic->timer.dev);
>  		apic_set_reg(apic, APIC_TMICT, val);
>  		start_apic_timer(apic);
> -		return;
> +		return 0;
> =20
>  	case APIC_TDCR:
>  		if (val & 4)
> @@ -779,22 +791,7 @@ static void apic_mmio_write(struct kvm_io_device *=
this,
>  			   offset);
>  		break;
>  	}
> -
> -}
> -
> -static int apic_mmio_range(struct kvm_io_device *this, gpa_t addr,
> -			   int len, int size)
> -{
> -	struct kvm_lapic *apic =3D (struct kvm_lapic *)this->private;
> -	int ret =3D 0;
> -
> -
> -	if (apic_hw_enabled(apic) &&
> -	    (addr >=3D apic->base_address) &&
> -	    (addr < (apic->base_address + LAPIC_MMIO_LENGTH)))
> -		ret =3D 1;
> -
> -	return ret;
> +	return 0;
>  }
> =20
>  void kvm_free_lapic(struct kvm_vcpu *vcpu)
> @@ -1032,7 +1029,6 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu)
>  	kvm_lapic_reset(vcpu);
>  	apic->dev.read =3D apic_mmio_read;
>  	apic->dev.write =3D apic_mmio_write;
> -	apic->dev.in_range =3D apic_mmio_range;
>  	apic->dev.private =3D apic;
> =20
>  	return 0;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3944e91..b6465c4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2016,35 +2016,23 @@ static void kvm_init_msr_list(void)
>  	num_msrs_to_save =3D j;
>  }
> =20
> -/*
> - * Only apic need an MMIO device hook, so shortcut now..
> - */
> -static struct kvm_io_device *vcpu_find_pervcpu_dev(struct kvm_vcpu *vc=
pu,
> -						gpa_t addr, int len,
> -						int is_write)
> +static int vcpu_mmio_write(struct kvm_vcpu *vcpu, gpa_t addr, int len,=

> +			   const void *val)
>  {
> -	struct kvm_io_device *dev;
> +	if (vcpu->arch.apic &&
> +	    !kvm_iodevice_write(&vcpu->arch.apic->dev, addr, len, val))
> +		return 0;
> =20
> -	if (vcpu->arch.apic) {
> -		dev =3D &vcpu->arch.apic->dev;
> -		if (dev->in_range(dev, addr, len, is_write))
> -			return dev;
> -	}
> -	return NULL;
> +	return kvm_io_bus_write(&vcpu->kvm->mmio_bus, addr, len, val);
>  }
> =20
> -
> -static struct kvm_io_device *vcpu_find_mmio_dev(struct kvm_vcpu *vcpu,=

> -						gpa_t addr, int len,
> -						int is_write)
> +static int vcpu_mmio_read(struct kvm_vcpu *vcpu, gpa_t addr, int len, =
void *val)
>  {
> -	struct kvm_io_device *dev;
> +	if (vcpu->arch.apic &&
> +	    !kvm_iodevice_read(&vcpu->arch.apic->dev, addr, len, val))
> +		return 0;
> =20
> -	dev =3D vcpu_find_pervcpu_dev(vcpu, addr, len, is_write);
> -	if (dev =3D=3D NULL)
> -		dev =3D kvm_io_bus_find_dev(&vcpu->kvm->mmio_bus, addr, len,
> -					  is_write);
> -	return dev;
> +	return kvm_io_bus_read(&vcpu->kvm->mmio_bus, addr, len, val);
>  }
> =20
>  static int kvm_read_guest_virt(gva_t addr, void *val, unsigned int byt=
es,
> @@ -2113,7 +2101,6 @@ static int emulator_read_emulated(unsigned long a=
ddr,
>  				  unsigned int bytes,
>  				  struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_io_device *mmio_dev;
>  	gpa_t                 gpa;
> =20
>  	if (vcpu->mmio_read_completed) {
> @@ -2139,9 +2126,7 @@ mmio:
>  	 * Is this MMIO handled locally?
>  	 */
>  	mutex_lock(&vcpu->kvm->lock);
> -	mmio_dev =3D vcpu_find_mmio_dev(vcpu, gpa, bytes, 0);
> -	if (mmio_dev) {
> -		kvm_iodevice_read(mmio_dev, gpa, bytes, val);
> +	if (!vcpu_mmio_read(vcpu, gpa, bytes, val)) {
>  		mutex_unlock(&vcpu->kvm->lock);
>  		return X86EMUL_CONTINUE;
>  	}
> @@ -2172,7 +2157,6 @@ static int emulator_write_emulated_onepage(unsign=
ed long addr,
>  					   unsigned int bytes,
>  					   struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_io_device *mmio_dev;
>  	gpa_t                 gpa;
> =20
>  	gpa =3D vcpu->arch.mmu.gva_to_gpa(vcpu, addr);
> @@ -2194,9 +2178,7 @@ mmio:
>  	 * Is this MMIO handled locally?
>  	 */
>  	mutex_lock(&vcpu->kvm->lock);
> -	mmio_dev =3D vcpu_find_mmio_dev(vcpu, gpa, bytes, 1);
> -	if (mmio_dev) {
> -		kvm_iodevice_write(mmio_dev, gpa, bytes, val);
> +	if (!vcpu_mmio_write(vcpu, gpa, bytes, val)) {
>  		mutex_unlock(&vcpu->kvm->lock);
>  		return X86EMUL_CONTINUE;
>  	}
> @@ -2508,52 +2490,45 @@ int complete_pio(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
> =20
> -static void kernel_pio(struct kvm_io_device *pio_dev,
> -		       struct kvm_vcpu *vcpu,
> -		       void *pd)
> +static int kernel_pio(struct kvm_vcpu *vcpu, void *pd)
>  {
>  	/* TODO: String I/O for in kernel device */
> +	int r;
> =20
>  	mutex_lock(&vcpu->kvm->lock);
>  	if (vcpu->arch.pio.in)
> -		kvm_iodevice_read(pio_dev, vcpu->arch.pio.port,
> -				  vcpu->arch.pio.size,
> -				  pd);
> +		r =3D kvm_io_bus_read(&vcpu->kvm->pio_bus, vcpu->arch.pio.port,
> +				    vcpu->arch.pio.size, pd);
>  	else
> -		kvm_iodevice_write(pio_dev, vcpu->arch.pio.port,
> -				   vcpu->arch.pio.size,
> -				   pd);
> +		r =3D kvm_io_bus_write(&vcpu->kvm->pio_bus, vcpu->arch.pio.port,
> +				       vcpu->arch.pio.size, pd);
>  	mutex_unlock(&vcpu->kvm->lock);
> +	return r;
>  }
> =20
> -static void pio_string_write(struct kvm_io_device *pio_dev,
> -			     struct kvm_vcpu *vcpu)
> +static int pio_string_write(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_pio_request *io =3D &vcpu->arch.pio;
>  	void *pd =3D vcpu->arch.pio_data;
> -	int i;
> +	int i, r =3D 0;
> =20
>  	mutex_lock(&vcpu->kvm->lock);
>  	for (i =3D 0; i < io->cur_count; i++) {
> -		kvm_iodevice_write(pio_dev, io->port,
> -				   io->size,
> -				   pd);
> +		if (kvm_io_bus_write(&vcpu->kvm->pio_bus, io->port,
> +				     io->size,
> +				     pd)) {
> +			r =3D -EOPNOTSUPP;
> +			break;
> +		}
>  		pd +=3D io->size;
>  	}
>  	mutex_unlock(&vcpu->kvm->lock);
> -}
> -
> -static struct kvm_io_device *vcpu_find_pio_dev(struct kvm_vcpu *vcpu,
> -					       gpa_t addr, int len,
> -					       int is_write)
> -{
> -	return kvm_io_bus_find_dev(&vcpu->kvm->pio_bus, addr, len, is_write);=

> +	return r;
>  }
> =20
>  int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in=
,
>  		  int size, unsigned port)
>  {
> -	struct kvm_io_device *pio_dev;
>  	unsigned long val;
> =20
>  	vcpu->run->exit_reason =3D KVM_EXIT_IO;
> @@ -2577,9 +2552,7 @@ int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct=
 kvm_run *run, int in,
>  	val =3D kvm_register_read(vcpu, VCPU_REGS_RAX);
>  	memcpy(vcpu->arch.pio_data, &val, 4);
> =20
> -	pio_dev =3D vcpu_find_pio_dev(vcpu, port, size, !in);
> -	if (pio_dev) {
> -		kernel_pio(pio_dev, vcpu, vcpu->arch.pio_data);
> +	if (!kernel_pio(vcpu, vcpu->arch.pio_data)) {
>  		complete_pio(vcpu);
>  		return 1;
>  	}
> @@ -2593,7 +2566,6 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu,=
 struct kvm_run *run, int in,
>  {
>  	unsigned now, in_page;
>  	int ret =3D 0;
> -	struct kvm_io_device *pio_dev;
> =20
>  	vcpu->run->exit_reason =3D KVM_EXIT_IO;
>  	vcpu->run->io.direction =3D in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
> @@ -2641,9 +2613,6 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu,=
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
> @@ -2651,16 +2620,13 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcp=
u, struct kvm_run *run, int in,
>  			kvm_inject_gp(vcpu, 0);
>  			return 1;
>  		}
> -		if (ret =3D=3D 0 && pio_dev) {
> -			pio_string_write(pio_dev, vcpu);
> +		if (ret =3D=3D 0 && !pio_string_write(vcpu)) {
>  			complete_pio(vcpu);
>  			if (vcpu->arch.pio.count =3D=3D 0)
>  				ret =3D 1;
>  		}
> -	} else if (pio_dev)
> -		pr_unimpl(vcpu, "no string pio read support yet, "
> -		       "port %x size %d count %ld\n",
> -			port, size, count);
> +	}
> +	/* no string PIO read support yet */
> =20
>  	return ret;
>  }
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 894a56e..2b9069f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -58,8 +58,10 @@ struct kvm_io_bus {
> =20
>  void kvm_io_bus_init(struct kvm_io_bus *bus);
>  void kvm_io_bus_destroy(struct kvm_io_bus *bus);
> -struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
> -					  gpa_t addr, int len, int is_write);
> +int kvm_io_bus_write(struct kvm_io_bus *bus, gpa_t addr, int len,
> +		     const void *val);
> +int kvm_io_bus_read(struct kvm_io_bus *bus, gpa_t addr, int len,
> +		    void *val);
>  void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
>  			     struct kvm_io_device *dev);
> =20
> diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
> index 5ae620d..d57b5ad 100644
> --- a/virt/kvm/coalesced_mmio.c
> +++ b/virt/kvm/coalesced_mmio.c
> @@ -14,21 +14,14 @@
> =20
>  #include "coalesced_mmio.h"
> =20
> -static int coalesced_mmio_in_range(struct kvm_io_device *this,
> -				   gpa_t addr, int len, int is_write)
> +static int coalesced_mmio_in_range(struct kvm_coalesced_mmio_dev *dev,=

> +				   gpa_t addr, int len)
>  {
> -	struct kvm_coalesced_mmio_dev *dev =3D
> -				(struct kvm_coalesced_mmio_dev*)this->private;
>  	struct kvm_coalesced_mmio_zone *zone;
>  	int next;
>  	int i;
> =20
> -	if (!is_write)
> -		return 0;
> -
> -	/* kvm->lock is taken by the caller and must be not released before
> -         * dev.read/write
> -         */
> +	/* kvm->lock is taken by the caller */
> =20
>  	/* Are we able to batch it ? */
> =20
> @@ -60,14 +53,15 @@ static int coalesced_mmio_in_range(struct kvm_io_de=
vice *this,
>  	return 0;
>  }
> =20
> -static void coalesced_mmio_write(struct kvm_io_device *this,
> -				 gpa_t addr, int len, const void *val)
> +static int coalesced_mmio_write(struct kvm_io_device *this,
> +				gpa_t addr, int len, const void *val)
>  {
> -	struct kvm_coalesced_mmio_dev *dev =3D
> -				(struct kvm_coalesced_mmio_dev*)this->private;
> +	struct kvm_coalesced_mmio_dev *dev =3D this->private;
>  	struct kvm_coalesced_mmio_ring *ring =3D dev->kvm->coalesced_mmio_rin=
g;
> +	if (!coalesced_mmio_in_range(dev, addr, len))
> +		return -EOPNOTSUPP;
> =20
> -	/* kvm->lock must be taken by caller before call to in_range()*/
> +	/* kvm->lock must be taken by caller */
> =20
>  	/* copy data in first free entry of the ring */
> =20
> @@ -76,6 +70,7 @@ static void coalesced_mmio_write(struct kvm_io_device=
 *this,
>  	memcpy(ring->coalesced_mmio[ring->last].data, val, len);
>  	smp_wmb();
>  	ring->last =3D (ring->last + 1) % KVM_COALESCED_MMIO_MAX;
> +	return 0;
>  }
> =20
>  static void coalesced_mmio_destructor(struct kvm_io_device *this)
> @@ -91,7 +86,6 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
>  	if (!dev)
>  		return -ENOMEM;
>  	dev->dev.write  =3D coalesced_mmio_write;
> -	dev->dev.in_range  =3D coalesced_mmio_in_range;
>  	dev->dev.destructor  =3D coalesced_mmio_destructor;
>  	dev->dev.private  =3D dev;
>  	dev->kvm =3D kvm;
> diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
> index c3b99de..172e044 100644
> --- a/virt/kvm/ioapic.c
> +++ b/virt/kvm/ioapic.c
> @@ -329,20 +329,19 @@ void kvm_ioapic_update_eoi(struct kvm *kvm, int v=
ector, int trigger_mode)
>  			__kvm_ioapic_update_eoi(ioapic, i, trigger_mode);
>  }
> =20
> -static int ioapic_in_range(struct kvm_io_device *this, gpa_t addr,
> -			   int len, int is_write)
> +static inline int ioapic_in_range(struct kvm_ioapic *ioapic, gpa_t add=
r)
>  {
> -	struct kvm_ioapic *ioapic =3D (struct kvm_ioapic *)this->private;
> -
>  	return ((addr >=3D ioapic->base_address &&
>  		 (addr < ioapic->base_address + IOAPIC_MEM_LENGTH)));
>  }
> =20
> -static void ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, i=
nt len,
> -			     void *val)
> +static int ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, in=
t len,
> +			    void *val)
>  {
> -	struct kvm_ioapic *ioapic =3D (struct kvm_ioapic *)this->private;
> +	struct kvm_ioapic *ioapic =3D this->private;
>  	u32 result;
> +	if (!ioapic_in_range(ioapic, addr))
> +		return -ENOTSUPP;
> =20
>  	ioapic_debug("addr %lx\n", (unsigned long)addr);
>  	ASSERT(!(addr & 0xf));	/* check alignment */
> @@ -373,13 +372,16 @@ static void ioapic_mmio_read(struct kvm_io_device=
 *this, gpa_t addr, int len,
>  	default:
>  		printk(KERN_WARNING "ioapic: wrong length %d\n", len);
>  	}
> +	return 0;
>  }
> =20
> -static void ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, =
int len,
> -			      const void *val)
> +static int ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, i=
nt len,
> +			     const void *val)
>  {
>  	struct kvm_ioapic *ioapic =3D (struct kvm_ioapic *)this->private;
>  	u32 data;
> +	if (!ioapic_in_range(ioapic, addr))
> +		return -ENOTSUPP;
> =20
>  	ioapic_debug("ioapic_mmio_write addr=3D%p len=3D%d val=3D%p\n",
>  		     (void*)addr, len, val);
> @@ -388,7 +390,7 @@ static void ioapic_mmio_write(struct kvm_io_device =
*this, gpa_t addr, int len,
>  		data =3D *(u32 *) val;
>  	else {
>  		printk(KERN_WARNING "ioapic: Unsupported size %d\n", len);
> -		return;
> +		return 0;
>  	}
> =20
>  	addr &=3D 0xff;
> @@ -409,6 +411,7 @@ static void ioapic_mmio_write(struct kvm_io_device =
*this, gpa_t addr, int len,
>  	default:
>  		break;
>  	}
> +	return 0;
>  }
> =20
>  void kvm_ioapic_reset(struct kvm_ioapic *ioapic)
> @@ -434,7 +437,6 @@ int kvm_ioapic_init(struct kvm *kvm)
>  	kvm_ioapic_reset(ioapic);
>  	ioapic->dev.read =3D ioapic_mmio_read;
>  	ioapic->dev.write =3D ioapic_mmio_write;
> -	ioapic->dev.in_range =3D ioapic_in_range;
>  	ioapic->dev.private =3D ioapic;
>  	ioapic->kvm =3D kvm;
>  	kvm_io_bus_register_dev(&kvm->mmio_bus, &ioapic->dev);
> diff --git a/virt/kvm/iodev.h b/virt/kvm/iodev.h
> index 55e8846..f891501 100644
> --- a/virt/kvm/iodev.h
> +++ b/virt/kvm/iodev.h
> @@ -17,43 +17,37 @@
>  #define __KVM_IODEV_H__
> =20
>  #include <linux/kvm_types.h>
> +#include <asm/errno.h>
> =20
> +/**
> + * read and write handlers are called under kvm_lock.
> + * They return 0 if the transaction has been handled,
> + * or non-zero to have it passed to the next device.
> + **/
>  struct kvm_io_device {
> -	void (*read)(struct kvm_io_device *this,
> +	int (*read)(struct kvm_io_device *this,
>  		     gpa_t addr,
>  		     int len,
>  		     void *val);
> -	void (*write)(struct kvm_io_device *this,
> +	int (*write)(struct kvm_io_device *this,
>  		      gpa_t addr,
>  		      int len,
>  		      const void *val);
> -	int (*in_range)(struct kvm_io_device *this, gpa_t addr, int len,
> -			int is_write);
>  	void (*destructor)(struct kvm_io_device *this);
> =20
>  	void             *private;
>  };
> =20
> -static inline void kvm_iodevice_read(struct kvm_io_device *dev,
> -				     gpa_t addr,
> -				     int len,
> -				     void *val)
> +static inline int kvm_iodevice_read(struct kvm_io_device *dev,
> +				    gpa_t addr, int len, void *val)
>  {
> -	dev->read(dev, addr, len, val);
> +	return dev->read ? dev->read(dev, addr, len, val) : -EOPNOTSUPP;
>  }
> =20
> -static inline void kvm_iodevice_write(struct kvm_io_device *dev,
> -				      gpa_t addr,
> -				      int len,
> -				      const void *val)
> +static inline int kvm_iodevice_write(struct kvm_io_device *dev,
> +				     gpa_t addr, int len, const void *val)
>  {
> -	dev->write(dev, addr, len, val);
> -}
> -
> -static inline int kvm_iodevice_inrange(struct kvm_io_device *dev,
> -				       gpa_t addr, int len, int is_write)
> -{
> -	return dev->in_range(dev, addr, len, is_write);
> +	return dev->write ? dev->write(dev, addr, len, val) : -EOPNOTSUPP;
>  }
> =20
>  static inline void kvm_iodevice_destructor(struct kvm_io_device *dev)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4d0dd39..ed9e420 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2145,19 +2145,24 @@ void kvm_io_bus_destroy(struct kvm_io_bus *bus)=

>  	}
>  }
> =20
> -struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
> -					  gpa_t addr, int len, int is_write)
> +int kvm_io_bus_write(struct kvm_io_bus *bus, gpa_t addr, int len,
> +		     const void *val)
>  {
>  	int i;
> +	for (i =3D 0; i < bus->dev_count; i++)
> +		if (!kvm_iodevice_write(bus->devs[i], addr, len, val))
> +			return 0;
> +	return -ENOTSUPP;
> +}
> =20
> -	for (i =3D 0; i < bus->dev_count; i++) {
> -		struct kvm_io_device *pos =3D bus->devs[i];
> -
> -		if (pos->in_range(pos, addr, len, is_write))
> -			return pos;
> -	}
> -
> -	return NULL;
> +int kvm_io_bus_read(struct kvm_io_bus *bus, gpa_t addr, int len,
> +		    void *val)
> +{
> +	int i;
> +	for (i =3D 0; i < bus->dev_count; i++)
> +		if (!kvm_iodevice_read(bus->devs[i], addr, len, val))
> +			return 0;
> +	return -ENOTSUPP;
>  }
> =20
>  void kvm_io_bus_register_dev(struct kvm_io_bus *bus, struct kvm_io_dev=
ice *dev)
>  =20



--------------enig8EC5800C03221941FFE2B91E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpA8xEACgkQlOSOBdgZUxlnIgCfY9Ynz3rYdwCFWJ7r5LeyYq0t
M1kAn3N7MoyD5pWLCiwppB5qeISMx2os
=6N3P
-----END PGP SIGNATURE-----

--------------enig8EC5800C03221941FFE2B91E--
