Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbZGGNRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbZGGNRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 09:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085AbZGGNQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 09:16:51 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36656 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbZGGNQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 09:16:48 -0400
Message-ID: <4A534AAC.6010804@novell.com>
Date: Tue, 07 Jul 2009 09:16:28 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [KVM PATCH v9 2/2] KVM: add iosignalfd support
References: <20090706202742.14222.65548.stgit@dev.haskins.net> <20090706203321.14222.67866.stgit@dev.haskins.net> <20090707112024.GA3647@redhat.com> <4A533C4C.7020202@novell.com> <20090707124810.GD3647@redhat.com>
In-Reply-To: <20090707124810.GD3647@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF89E3691C58D061AE2F6A660"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF89E3691C58D061AE2F6A660
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Jul 07, 2009 at 08:15:08AM -0400, Gregory Haskins wrote:
>  =20
>> Michael S. Tsirkin wrote:
>>    =20
>>> Some comments below. Sorry, I know it's late in the series, but
>>> previously I've been too confused with complicated locking to notice
>>> anything else :(.
>>>
>>> On Mon, Jul 06, 2009 at 04:33:21PM -0400, Gregory Haskins wrote:
>>>  =20
>>>
>>>      =20
>>>> +#define KVM_IOSIGNALFD_FLAG_PIO       (1 << 1) /* is a pio (otherwi=
se mmio) */
>>>> +#define KVM_IOSIGNALFD_FLAG_DEASSIGN  (1 << 2)
>>>> +
>>>> +struct kvm_iosignalfd {
>>>> +	__u64 trigger;
>>>>    =20
>>>>        =20
>>> for length <8, it's the 8*len least significant bits that are used, r=
ight?
>>> That's a bit ugly ... Maybe just put an 8 byte array here instead, th=
en
>>> the first len bytes are valid.
>>>  =20
>>>      =20
>> The original series uses an array that I kmalloc'ed to size, or left i=
t
>> NULL for a wildcard.  Avi didn't like this and requested a u64 for all=

>> values.  I don't care either way, but since you two are asking for
>> conflicting designs, I will let you debate.
>>    =20
>
> It turns out the io bus will be changed in the future.
> Let's just document the usage, and check that unused bits
> are zeroed.
>
>  =20
>>>> +	struct kvm_io_device dev;
>>>> +	int                  wildcard:1;
>>>>    =20
>>>>        =20
>>> don't use bitfields
>>>  =20
>>>      =20
>> bool?
>>    =20
>
> sure
>
>  =20
>>>> +}
>>>> +
>>>> +/*
>>>> + * MMIO/PIO writes trigger an event if the addr/val match
>>>> + */
>>>>    =20
>>>>        =20
>>> single line comment can look like this:
>>> /* MMIO/PIO writes trigger an event if the addr/val match */
>>>
>>>  =20
>>>      =20
>> Ack
>>
>>    =20
>>>> +static int
>>>> +iosignalfd_write(struct kvm_io_device *this, gpa_t addr, int len,
>>>> +		 const void *val)
>>>> +{
>>>> +	struct _iosignalfd *p =3D to_iosignalfd(this);
>>>> +
>>>> +	if (!iosignalfd_in_range(p, addr, len, val))
>>>> +		return -EOPNOTSUPP;
>>>> +
>>>> +	eventfd_signal(p->eventfd, 1);
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +/*
>>>> + * This function is called as KVM is completely shutting down.  We =
do not
>>>> + * need to worry about locking just nuke anything we have as quickl=
y as possible
>>>> + */
>>>> +static void
>>>> +iosignalfd_destructor(struct kvm_io_device *this)
>>>> +{
>>>> +	struct _iosignalfd *p =3D to_iosignalfd(this);
>>>> +
>>>> +	iosignalfd_release(p);
>>>> +}
>>>> +
>>>> +static const struct kvm_io_device_ops iosignalfd_ops =3D {
>>>> +	.write      =3D iosignalfd_write,
>>>> +	.destructor =3D iosignalfd_destructor,
>>>> +};
>>>> +
>>>> +static bool
>>>> +iosignalfd_overlap(struct _iosignalfd *lhs, struct _iosignalfd *rhs=
)
>>>>    =20
>>>>        =20
>>> this checks both region overlap and data collision.
>>> better split into two helpers?
>>>
>>>  =20
>>>      =20
>> Why?
>>    =20
>
> Because it says iosignalfd_overlap but that's not what it does?
>  =20

It would seem to me that that is exactly what it does.  Given that I
wrote it, I'm sure my perspective is skewed, so let me turn it around on
you.  Why do you think "overlap" is inaccurate?
>  =20
>>>> +{
>>>> +	/*
>>>> +	 * Check for completely non-overlapping regions.  We can simply
>>>> +	 * return "false" for non-overlapping regions and be done with
>>>> +	 * it.
>>>> +	 */
>>>>    =20
>>>>        =20
>>> done with it -> ignore the value
>>>
>>>  =20
>>>      =20
>> I think that is a valid expression (at least here in the states),
>>    =20
>
> I'm always interested in improving my english :)

I'm sure its slang and not proper english, so don't take it too seriously=
 ;)

>  here's what I thought:
>
> "done with it" says we skip the rest of the function. "ignore the value=
"
> says skip the value check. So I was trying to say let's be more
> specific.
>
> Isn't that what it means?
>  =20

Yes, you are right.  I thought you were saying the comment was somehow
wrong.  But I see now you are just clarifying it.
>  =20
>> but
>> ok.  Note that "false" means we are accepting the request, not ignorin=
g
>> any value.  I will construct a better comment either way.
>>    =20
>
> Maybe name a function in a way that makes this explicit?
>
>  =20
Sure

>>>> +
>>>> +	if ((lhs->addr + lhs->length) <=3D rhs->addr)
>>>>    =20
>>>>        =20
>>> this math can overflow.
>>>
>>>  =20
>>>      =20
>> Well, we should probably have vetted that during assign since
>> addr+length that overflows is not a valid region.  I will put a check =
in
>> for that.
>>    =20
>
> add =3D ~0x0ULL, len =3D 1 should be valid.
> You'll have to make the math not overflow.
>
>  =20
Yes, understood.
>>>> +
>>>> +	/*
>>>> +	 * If we get here, we know there is *some* overlap, but we don't
>>>> +	 * yet know how much.
>>>>    =20
>>>>        =20
>>> how much?
>>>  =20
>>>      =20
>> Well, as stated we don't know yet.
>>    =20
>
> So why tell me :)?
> What I mean is this statement (especially the the part of the statement=

> after the comma) does not add useful information.
>  =20

What I was trying to convey is that the next section of code tries to
narrow the amount of overlap down further.  If it bothers you, I will
just remove the comment.

>  =20
>>>  =20
>>>      =20
>>>>  Make sure its a "precise" overlap, or
>>>>    =20
>>>>        =20
>>> precise overlap -> address/len pairs match
>>>
>>>  =20
>>>      =20
>> Precisely.
>>    =20
>
> so say so :)
>  =20

Ok
>  =20
>>>> +	 * its rejected as incompatible
>>>> +	 */
>>>>    =20
>>>>        =20
>>> "rejected" does not seem to make sense in the context of a boolean
>>> function
>>>
>>>  =20
>>>      =20
>> Why?  true =3D rejected, false =3D accepted.  Seems boolean to me.
>>    =20
>
> How should I know that? Rename it to iosignalfd_rejected?
>  =20

Dunno..  Seems clear to me already:  collision =3D true if overlap =3D
true.  collision =3D reject the request to create a new object on grounds=

that we already have one in that spot.  I don't really care what we call
it, but I don't currently see a superior way to describe what I am doing
that isn't just a synonym.
>  =20
>>  Whats
>> wrong with that?
>>    =20
>
> If you want to return 0 on success, !=3D 0 on failure,
> make the function int.
>
>  =20
I don't want that.  I want to know true or false on whether we have a
collision.  A collision is defined by whether there is overlap with any
existing object.

>>>> +
>>>> +/* assumes kvm->slots_lock write-lock held */
>>>>    =20
>>>>        =20
>>> it seems you only need read lock?
>>>
>>>  =20
>>>      =20
>> The caller needs write-lock, so we just inherit that state.  I can
>> update the comment though (I just ran a find/replace on "kvm->lock hel=
d"
>> while updating to your new interface, thus the vague comment)
>>    =20
>
> I guess so.
>
>  =20
>>>> +static bool
>>>> +iosignalfd_check_collision(struct kvm *kvm, struct _iosignalfd *p)
>>>> +{
>>>> +	struct _iosignalfd *_p;
>>>> +
>>>> +	list_for_each_entry(_p, &kvm->iosignalfds, list)
>>>> +		if (iosignalfd_overlap(_p, p))
>>>>    =20
>>>>        =20
>>> This looks wrong: let's assume I want one signal with length 1 and on=
e
>>> with length 2 at address 0. They never trigger together, so it should=

>>> be ok to have 2 such devices.
>>>  =20
>>>      =20
>> We have previously decided to not support mis-matched overlaps.  It's
>> more complicated to handle, and there isn't a compelling use-case for =
it
>> that I am aware of.
>>    =20
>
> That's not what I propose. By all means len =3D X should only catch
> len =3D X and not len =3D X - 1.
>
> However, I think it makes sense to
> allow both len =3D 2 and len =3D 1 at the same address even though
> they seem to overlap. And all you really need to do is simplify
> the code: replace the tricky overlap logic with simple
>
> if (rhs->addr =3D=3D lhs->addr && rhs->len =3D=3D lhs->len)
> 	reject
> else
> 	accept
>
> (+add wildcard thing)
>  =20

Hmm..ok.  I can't imagine anyone using that, but it seems simple enough
to implement.
>  =20
>>>> +		if (p->eventfd !=3D eventfd)
>>>> +			continue;
>>>>    =20
>>>>        =20
>>> So for deassign, you ignore all arguments besides fd?  Is this
>>> intentional? Looks strange - think of multiple addresses triggering a=

>>> single eventfd. But if so, it's better to have a different ioctl with=

>>> just the fields we need.
>>>  =20
>>>      =20
>> Hmm... I suspect the check for a range-match got lost along the way.  =
I
>> agree we should probably qualify this with more than just the eventfd.=

>>
>>    =20
>>>  =20
>>>      =20
>>>> +
>>>> +		__kvm_io_bus_unregister_dev(bus, &p->dev);
>>>> +		iosignalfd_release(p);
>>>>    =20
>>>>        =20
>>> a single deassign removed multiple irqfds? Looks ugly.
>>>  =20
>>>      =20
>> Avi requested this general concept.
>>    =20
>
> Really? Avi, could you explain? I would think each
> assign needs to be matched with 1 deassign. No?
>
>  =20



--------------enigF89E3691C58D061AE2F6A660
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpTSrAACgkQlOSOBdgZUxn2RQCfb8DIUDGgBxtsljo0NeBeamlN
onQAn0uKaAvyF+jc/1yIikV+Ont+3Y5w
=d0Rj
-----END PGP SIGNATURE-----

--------------enigF89E3691C58D061AE2F6A660--
