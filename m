Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbZGGMPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbZGGMPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 08:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725AbZGGMPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 08:15:23 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:43660 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298AbZGGMPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 08:15:18 -0400
Message-ID: <4A533C4C.7020202@novell.com>
Date: Tue, 07 Jul 2009 08:15:08 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [KVM PATCH v9 2/2] KVM: add iosignalfd support
References: <20090706202742.14222.65548.stgit@dev.haskins.net> <20090706203321.14222.67866.stgit@dev.haskins.net> <20090707112024.GA3647@redhat.com>
In-Reply-To: <20090707112024.GA3647@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCE4CD36B7B75844F2FE2F7C4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCE4CD36B7B75844F2FE2F7C4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> Some comments below. Sorry, I know it's late in the series, but
> previously I've been too confused with complicated locking to notice
> anything else :(.
>
> On Mon, Jul 06, 2009 at 04:33:21PM -0400, Gregory Haskins wrote:
>  =20
>
>> +#define KVM_IOSIGNALFD_FLAG_PIO       (1 << 1) /* is a pio (otherwise=
 mmio) */
>> +#define KVM_IOSIGNALFD_FLAG_DEASSIGN  (1 << 2)
>> +
>> +struct kvm_iosignalfd {
>> +	__u64 trigger;
>>    =20
>
> for length <8, it's the 8*len least significant bits that are used, rig=
ht?
> That's a bit ugly ... Maybe just put an 8 byte array here instead, then=

> the first len bytes are valid.
>  =20

The original series uses an array that I kmalloc'ed to size, or left it
NULL for a wildcard.  Avi didn't like this and requested a u64 for all
values.  I don't care either way, but since you two are asking for
conflicting designs, I will let you debate.

>  =20
>> =20
>>  void
>> -kvm_irqfd_init(struct kvm *kvm)
>> +kvm_eventfd_init(struct kvm *kvm)
>>  {
>>  	spin_lock_init(&kvm->irqfds.lock);
>>  	INIT_LIST_HEAD(&kvm->irqfds.items);
>> +
>>    =20
>
> don't need this empty line
>  =20

Ack
>  =20
>> +	INIT_LIST_HEAD(&kvm->iosignalfds);
>>  }
>> =20
>>  /*
>> @@ -327,3 +333,275 @@ static void __exit irqfd_module_exit(void)
>> =20
>>  module_init(irqfd_module_init);
>>  module_exit(irqfd_module_exit);
>> +
>> +/*
>> + * ------------------------------------------------------------------=
--
>> + * iosignalfd: translate a PIO/MMIO memory write to an eventfd signal=
=2E
>> + *
>> + * userspace can register a PIO/MMIO address with an eventfd for reci=
eving
>>    =20
>
> recieving -> receiving
>
>  =20
Ack

/me is embarrassed

>> + * notification when the memory has been touched.
>> + * ------------------------------------------------------------------=
--
>> + */
>> +
>> +struct _iosignalfd {
>> +	struct list_head     list;
>> +	u64                  addr;
>> +	size_t               length;
>>    =20
>
> "int length" should be enough: the value is 1, 2, 4 or 8.
> and put wildcard near it if you want to save some space
>
>  =20
Ok

>> +	struct eventfd_ctx  *eventfd;
>> +	u64                  match;
>>    =20
>
> match -> value
>
>  =20
Ok

>> +	struct kvm_io_device dev;
>> +	int                  wildcard:1;
>>    =20
>
> don't use bitfields
>  =20

bool?
>  =20
>> +};
>> +
>> +static inline struct _iosignalfd *
>> +to_iosignalfd(struct kvm_io_device *dev)
>> +{
>> +	return container_of(dev, struct _iosignalfd, dev);
>> +}
>> +
>> +static void
>> +iosignalfd_release(struct _iosignalfd *p)
>> +{
>> +	eventfd_ctx_put(p->eventfd);
>> +	list_del(&p->list);
>> +	kfree(p);
>> +}
>> +
>> +static bool
>> +iosignalfd_in_range(struct _iosignalfd *p, gpa_t addr, int len, const=
 void *val)
>> +{
>> +	u64 _val;
>> +
>> +	if (!(addr =3D=3D p->addr && len =3D=3D p->length))
>>    =20
>
> de-morgan's laws can help simplify this
>
>  =20
>> +		/* address-range must be precise for a hit */
>>    =20
>
> So there's apparently no way to specify that
> you want 1,2, or 4 byte writes at address X?
>  =20

No, they can be any legal size (1, 2, 4, or 8).  The only limitation is
that any overlap of two or more registrations have to be uniform in
addr/len.
>  =20
>> +		return false;
>> +
>> +	if (p->wildcard)
>> +		/* all else equal, wildcard is always a hit */
>> +		return true;
>> +
>> +	/* otherwise, we have to actually compare the data */
>> +
>> +	BUG_ON(!IS_ALIGNED((unsigned long)val, len));
>> +
>> +	switch (len) {
>> +	case 1:
>> +		_val =3D *(u8 *)val;
>> +		break;
>> +	case 2:
>> +		_val =3D *(u16 *)val;
>> +		break;
>> +	case 4:
>> +		_val =3D *(u32 *)val;
>> +		break;
>> +	case 8:
>> +		_val =3D *(u64 *)val;
>> +		break;
>> +	default:
>> +		return false;
>> +	}
>> +
>> +	return _val =3D=3D p->match ? true : false;
>>    =20
>
> Life be simpler if we use an 8 byte array for match
> and just do memcmp here.
>
>  =20
You would need to use an n-byte array, technically (to avoid endian
issues).  As mentioned earlier, I already did it that way in earlier
versions but Avi wanted to see it this current (u64 based) way.

>> +}
>> +
>> +/*
>> + * MMIO/PIO writes trigger an event if the addr/val match
>> + */
>>    =20
>
> single line comment can look like this:
> /* MMIO/PIO writes trigger an event if the addr/val match */
>
>  =20
Ack

>> +static int
>> +iosignalfd_write(struct kvm_io_device *this, gpa_t addr, int len,
>> +		 const void *val)
>> +{
>> +	struct _iosignalfd *p =3D to_iosignalfd(this);
>> +
>> +	if (!iosignalfd_in_range(p, addr, len, val))
>> +		return -EOPNOTSUPP;
>> +
>> +	eventfd_signal(p->eventfd, 1);
>> +	return 0;
>> +}
>> +
>> +/*
>> + * This function is called as KVM is completely shutting down.  We do=
 not
>> + * need to worry about locking just nuke anything we have as quickly =
as possible
>> + */
>> +static void
>> +iosignalfd_destructor(struct kvm_io_device *this)
>> +{
>> +	struct _iosignalfd *p =3D to_iosignalfd(this);
>> +
>> +	iosignalfd_release(p);
>> +}
>> +
>> +static const struct kvm_io_device_ops iosignalfd_ops =3D {
>> +	.write      =3D iosignalfd_write,
>> +	.destructor =3D iosignalfd_destructor,
>> +};
>> +
>> +static bool
>> +iosignalfd_overlap(struct _iosignalfd *lhs, struct _iosignalfd *rhs)
>>    =20
>
> this checks both region overlap and data collision.
> better split into two helpers?
>
>  =20
Why?

>> +{
>> +	/*
>> +	 * Check for completely non-overlapping regions.  We can simply
>> +	 * return "false" for non-overlapping regions and be done with
>> +	 * it.
>> +	 */
>>    =20
>
> done with it -> ignore the value
>
>  =20
I think that is a valid expression (at least here in the states), but
ok.  Note that "false" means we are accepting the request, not ignoring
any value.  I will construct a better comment either way.

>> +	if ((rhs->addr + rhs->length) <=3D lhs->addr)
>> +		return false;
>>    =20
>
> rhs->addr + rhs->length <=3D lhs->addr
> is not less clear, as precedence for simple math
> follows the familiar rules from school.
>
>  =20

Yes, but the "eye compiler" isn't as efficient as a machine driven tool.
;)  The annotation is for the readers benefit (or at least me), not
technical/mathematical correctness.

But whatever, I'll take it out.

>> +
>> +	if ((lhs->addr + lhs->length) <=3D rhs->addr)
>>    =20
>
> this math can overflow.
>
>  =20
Well, we should probably have vetted that during assign since
addr+length that overflows is not a valid region.  I will put a check in
for that.

>> +		return false;
>>    =20
>
> or shorter:
>  	if (rhs->addr + rhs->length <=3D lhs->addr ||
>  	    lhs->addr + lhs->length <=3D rhs->addr)
>            return true;
>
>  =20
Ok

>> +
>> +	/*
>> +	 * If we get here, we know there is *some* overlap, but we don't
>> +	 * yet know how much.
>>    =20
>
> how much?
>  =20
Well, as stated we don't know yet.

>  =20
>>  Make sure its a "precise" overlap, or
>>    =20
>
> precise overlap -> address/len pairs match
>
>  =20

Precisely.

>> +	 * its rejected as incompatible
>> +	 */
>>    =20
>
> "rejected" does not seem to make sense in the context of a boolean
> function
>
>  =20

Why?  true =3D rejected, false =3D accepted.  Seems boolean to me.  Whats=

wrong with that?

>> +	if (lhs->addr !=3D rhs->addr)
>> +		return true;
>> +
>> +	if (lhs->length !=3D rhs->length)
>> +		return true;
>> +
>>    =20
>
> or shorter:
> 	if (lhs->addr !=3D rhs->addr || lhs->length !=3D rhs->length)
>            return true;
>  =20

Ok

>
>  =20
>> +	/*
>> +	 * If we get here, the request should be a precise overlap
>> +	 * between rhs+lhs.  The only thing left to check is for
>> +	 * data-match overlap.  If the data match is distinctly different
>> +	 * we can allow the two to co-exist.  Any kind of wild-card
>> +	 * consitutes an incompatible range, so reject any wild-cards,
>> +	 * or if the match token is identical.
>> +	 */
>> +	if (lhs->wildcard || rhs->wildcard || lhs->match =3D=3D rhs->match)
>> +		return true;
>> +
>> +	return false;
>> +}
>>    =20
>
>
>  =20
>> +
>> +/* assumes kvm->slots_lock write-lock held */
>>    =20
>
> it seems you only need read lock?
>
>  =20

The caller needs write-lock, so we just inherit that state.  I can
update the comment though (I just ran a find/replace on "kvm->lock held"
while updating to your new interface, thus the vague comment)

>> +static bool
>> +iosignalfd_check_collision(struct kvm *kvm, struct _iosignalfd *p)
>> +{
>> +	struct _iosignalfd *_p;
>> +
>> +	list_for_each_entry(_p, &kvm->iosignalfds, list)
>> +		if (iosignalfd_overlap(_p, p))
>>    =20
>
> This looks wrong: let's assume I want one signal with length 1 and one
> with length 2 at address 0. They never trigger together, so it should
> be ok to have 2 such devices.
>  =20

We have previously decided to not support mis-matched overlaps.  It's
more complicated to handle, and there isn't a compelling use-case for it
that I am aware of.

>  =20
>> +			return true;
>> +
>> +	return false;
>> +}
>> +
>> +static int
>> +kvm_assign_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
>> +{
>> +	int                       pio =3D args->flags & KVM_IOSIGNALFD_FLAG_=
PIO;
>> +	struct kvm_io_bus        *bus =3D pio ? &kvm->pio_bus : &kvm->mmio_b=
us;
>> +	struct _iosignalfd       *p;
>> +	struct eventfd_ctx       *eventfd;
>> +	int                       ret;
>> +
>> +	switch (args->len) {
>> +	case 1:
>> +	case 2:
>> +	case 4:
>> +	case 8:
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	eventfd =3D eventfd_ctx_fdget(args->fd);
>> +	if (IS_ERR(eventfd))
>> +		return PTR_ERR(eventfd);
>>    =20
>
> since this eventfd is kept around indefinitely, we should keep the
> file * around as well, so that this eventfd is accounted for
> properly with # of open files limit set by the admin.
>  =20

I agree.  The fact that I am missing that is a side-effect to the recent
change in eventfd-upstream.  If I acquire both a file* and ctx* and hold
them, it should work around the issue, but perhaps we should let the
eventfd interface handle this.

>  =20
>> +
>> +	p =3D kzalloc(sizeof(*p), GFP_KERNEL);
>> +	if (!p) {
>> +		ret =3D -ENOMEM;
>> +		goto fail;
>> +	}
>> +
>> +	INIT_LIST_HEAD(&p->list);
>> +	p->addr    =3D args->addr;
>> +	p->length  =3D args->len;
>> +	p->eventfd =3D eventfd;
>> +
>> +	/*
>> +	 * A trigger address is optional, otherwise this is a wildcard
>> +	 */
>>    =20
>
> A single line comment can look like this:
> 	/* A trigger address is optional, otherwise this is a wildcard */
>
>  =20
>> +	if (args->flags & KVM_IOSIGNALFD_FLAG_TRIGGER)
>> +		p->match =3D args->trigger;
>>    =20
>
> For len < 8, high bits in trigger are ignored.
> it's better to check that they are 0, less confusing
> if the user e.g. gets the endian-ness wrong.
>
>  =20
>> +	else
>> +		p->wildcard =3D true;
>> +
>>    =20
>
>  =20
>> +	down_write(&kvm->slots_lock);
>> +
>> +	/* Verify that there isnt a match already */
>>    =20
>
> Better to put documentation to where function is declared,
> not where it is used.
>
>  =20
>> +	if (iosignalfd_check_collision(kvm, p)) {
>> +		ret =3D -EEXIST;
>> +		goto unlock_fail;
>> +	}
>> +
>> +	kvm_iodevice_init(&p->dev, &iosignalfd_ops);
>> +
>> +	ret =3D __kvm_io_bus_register_dev(bus, &p->dev);
>> +	if (ret < 0)
>> +		goto unlock_fail;
>> +
>> +	list_add_tail(&p->list, &kvm->iosignalfds);
>> +
>> +	up_write(&kvm->slots_lock);
>> +
>> +	return 0;
>> +
>>    =20
>
> we probably do not need an empty line after each line of code here
>
>  =20
>> +unlock_fail:
>> +	up_write(&kvm->slots_lock);
>> +fail:
>> +	/*
>> +	 * it would have never made it to the list in the failure path, so
>> +	 * we dont need to worry about removing it
>> +	 */
>>    =20
>
> of course: you goto fail before list_add
> can just kill this comment
>
>  =20
>> +	kfree(p);
>> +
>> +	eventfd_ctx_put(eventfd);
>> +
>> +	return ret;
>>    =20
>
> we probably do not need an empty line after each line of code here
>
>
>  =20
>> +}
>> +
>> +
>>    =20
>
> two empty lines
>  =20

Ack
>  =20
>> +static int
>> +kvm_deassign_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)=

>> +{
>> +	int                       pio =3D args->flags & KVM_IOSIGNALFD_FLAG_=
PIO;
>> +	struct kvm_io_bus        *bus =3D pio ? &kvm->pio_bus : &kvm->mmio_b=
us;
>> +	struct _iosignalfd       *p, *tmp;
>> +	struct eventfd_ctx       *eventfd;
>> +	int                       ret =3D 0;
>> +
>> +	eventfd =3D eventfd_ctx_fdget(args->fd);
>> +	if (IS_ERR(eventfd))
>> +		return PTR_ERR(eventfd);
>> +
>> +	down_write(&kvm->slots_lock);
>> +
>> +	list_for_each_entry_safe(p, tmp, &kvm->iosignalfds, list) {
>> +
>>    =20
>
> kill empty line
>
>  =20
>> +		if (p->eventfd !=3D eventfd)
>> +			continue;
>>    =20
>
> So for deassign, you ignore all arguments besides fd?  Is this
> intentional? Looks strange - think of multiple addresses triggering a
> single eventfd. But if so, it's better to have a different ioctl with
> just the fields we need.
>  =20

Hmm... I suspect the check for a range-match got lost along the way.  I
agree we should probably qualify this with more than just the eventfd.

>  =20
>> +
>> +		__kvm_io_bus_unregister_dev(bus, &p->dev);
>> +		iosignalfd_release(p);
>>    =20
>
> a single deassign removed multiple irqfds? Looks ugly.
>  =20

Avi requested this general concept.

>  =20
>> +	}
>> +
>>    =20
>
> kill empty line
>
>  =20
>> +	up_write(&kvm->slots_lock);
>> +
>> +	eventfd_ctx_put(eventfd);
>> +
>> +	return ret;
>> +}
>>    =20
>
> return error status if no device was found?
>  =20

Ack
>  =20
>> +
>> +int
>> +kvm_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
>> +{
>> +	if (args->flags & KVM_IOSIGNALFD_FLAG_DEASSIGN)
>> +		return kvm_deassign_iosignalfd(kvm, args);
>>    =20
>
> Better check that only known flag values are present.
> Otherwise when you add more flags things just break
> silently.
>  =20

Ok
>  =20
>> +
>> +	return kvm_assign_iosignalfd(kvm, args);
>> +}
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 11595c7..5ac381b 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -979,7 +979,7 @@ static struct kvm *kvm_create_vm(void)
>>  	spin_lock_init(&kvm->mmu_lock);
>>  	spin_lock_init(&kvm->requests_lock);
>>  	kvm_io_bus_init(&kvm->pio_bus);
>> -	kvm_irqfd_init(kvm);
>> +	kvm_eventfd_init(kvm);
>>  	mutex_init(&kvm->lock);
>>  	mutex_init(&kvm->irq_lock);
>>  	kvm_io_bus_init(&kvm->mmio_bus);
>> @@ -2271,6 +2271,15 @@ static long kvm_vm_ioctl(struct file *filp,
>>  		r =3D kvm_irqfd(kvm, data.fd, data.gsi, data.flags);
>>  		break;
>>  	}
>> +	case KVM_IOSIGNALFD: {
>> +		struct kvm_iosignalfd data;
>> +
>> +		r =3D -EFAULT;
>>    =20
>
> this trick is nice, it saves a line of code for the closing brace
> but why waste it on an empty line above then?
>
>  =20
>> +		if (copy_from_user(&data, argp, sizeof data))
>> +			goto out;
>> +		r =3D kvm_iosignalfd(kvm, &data);
>> +		break;
>> +	}
>>  #ifdef CONFIG_KVM_APIC_ARCHITECTURE
>>  	case KVM_SET_BOOT_CPU_ID:
>>  		r =3D 0;
>>    =20



--------------enigCE4CD36B7B75844F2FE2F7C4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpTPE8ACgkQlOSOBdgZUxmbrgCdHJEw67d4l2yeDG8mOO0U/6Gp
B64An2fIeN2i7llylRag6AJ9TLmFKQQM
=fGlC
-----END PGP SIGNATURE-----

--------------enigCE4CD36B7B75844F2FE2F7C4--
