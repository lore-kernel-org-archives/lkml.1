Return-Path: <linux-kernel-owner+w=401wt.eu-S1750973AbZFWEEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750973AbZFWEEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 00:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZFWEES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 00:04:18 -0400
Received: from mail-qy0-f171.google.com ([209.85.221.171]:34846 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbZFWEEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 00:04:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=GRLPDL5V81CJiKOhjpUQ1Or7UK7iCnmlAT4ldoCnZvQj3UvGf/6JqXdt4/a5AxyHtK
         pC9qVLm0Fa9lPlvymQJF/HUWJqZis9s52U++50ALiACSwwtNGFEo7/c/ZmUNghSFMxr8
         t9fXGiHgRPxwny4HbLbOZq7mPja9HO6/xwst8=
Message-ID: <4A405436.1080100@gmail.com>
Date: Tue, 23 Jun 2009 00:04:06 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH RFC] pass write value to in_range pointers
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622151631.GA14780@redhat.com> <4A3FA6FC.9030301@novell.com> <20090622160833.GA15228@redhat.com> <4A3FB156.3030301@novell.com> <20090622172720.GC15228@redhat.com>
In-Reply-To: <20090622172720.GC15228@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7994C608DA10D13B18D9ABBD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7994C608DA10D13B18D9ABBD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Mon, Jun 22, 2009 at 12:29:10PM -0400, Gregory Haskins wrote:
>  =20
>> Michael S. Tsirkin wrote:
>>    =20
>>> On Mon, Jun 22, 2009 at 11:45:00AM -0400, Gregory Haskins wrote:
>>>  =20
>>>      =20
>>>> Michael S. Tsirkin wrote:
>>>>    =20
>>>>        =20
>>>>> It seems that a lot of complexity and trickiness with iosignalfd is=

>>>>> handling the group/item relationship, which comes about because kvm=
 does
>>>>> not currently let a device on the bus claim a write transaction bas=
ed on the
>>>>> value written.  This could be greatly simplified if the value writt=
en
>>>>> was passed to the in_range check for write operation.  We could the=
n
>>>>> simply make each kvm_iosignalfd a device on the bus.
>>>>>
>>>>> What does everyone think of the following lightly tested patch?
>>>>>  =20
>>>>>      =20
>>>>>          =20
>>>> Hi Michael,
>>>>   Its interesting, but I am not convinced its necessary.  We created=
 the
>>>> group/item layout because iosignalfds are unique in that they are
>>>> probably the only IO device that wants to do some kind of address
>>>> aliasing.
>>>>    =20
>>>>        =20
>>> We actually already have aliasing: is_write flag is used for this
>>> purpose.
>>>      =20
>> Yes, but read/write address aliasing is not the same thing is
>> multi-match data aliasing.
>>    =20
>
> What's the big difference?
>  =20

Well, for one its not very clear what the benefit of the read/write
aliasing even is. ;)  Apparently coalesced_mmio uses it, but even so I
doubt that is for the purposes of having one device do reads while
another does writes.  I could be wrong, though.
>  =20
>> Besides, your proposal also breaks
>>    =20
>
> s/break/removes limitation/ :)
>
>  =20
>> some of
>> the natural relationship models
>> (e.g. all the aliased iosignal_items
>> always belong to the same underlying device.  io_bus entries have an
>> arbitrary topology).
>>    =20
>
> iosignal_item is an artifact, they are not seen by user -
> they are just a work around an API limitation.
>  =20

Well, not really.  The "limitation" is a natural attribute of real
hardware too.  I don't know of a whole bunch of real hardware that
aliases multiple address decoders to the same value, do you?  How would
you handle reads?

The way I think of these items are not as unique devices in the io_bus
sense.  We have one address decoder (the group) listening on the bus to
a unique address.  That group provides a data-decoding service, where
you can program what event gets triggered for which value (or wildcard =3D=

all values).

It is unnatural to turn it around and say that the io_bus now scans
exhaustively on the address/data tuple, and we support aliasing such
that multiple decoders may coexist.  There isn't any other device
(hardware or software) that will actually do this aside from iosignalfd,
to my knowledge.  So why distort the entire io_bus subsystem's
addressing scheme to match?  I don't get the motivation, as it appears
to me to be already handled ideally as it is.

Perhaps I am contributing to this confusion with my decision to make the
group creation implicit with the first item creation.  Would you feel
better about this if we made the distinction with group and item more
explicit? (E.g. IOSIGNALFD_GROUP_ASSIGN and IOSIGNALFD_ITEM_ASSIGN
verbs).  I am fine with that change, I suppose.


> And they are only grouped if the same PIO offset is used for all access=
es.
> Why is not always the case. If a device uses several PIO offsets
> (as virtio does), you create separate devices for a single guest device=
 too.
>  =20

Thats ok.  As I stated above, I view this as a data-match service
against a single address decoder, not as multiple decoders aliased to
the same address/data pair.  Its perfectly fine for a logical device to
employ multiple decoders, but its unnatural for there to be multiple
decoders to the same address.  Its also unnatural to use the data as
part of the decode criteria for a general IO cycle.

>  =20
>>>  Actually, it's possible to remove is_write by passing
>>> a null pointer in write_val for reads. I like this a bit less as
>>> the code generated is less compact ... Avi, what do you think?
>>>
>>>  =20
>>>      =20
>>>>  With what you are proposing here, you are adding aliasing
>>>> support to the general infrastructure which I am not (yet) convinced=
 is
>>>> necessary.
>>>>    =20
>>>>        =20
>>> Infrastructure is a big name for something that adds a total of 10 li=
nes to kvm.
>>> And it should at least halve the size of your 450-line patch.
>>>  =20
>>>      =20
>> Your patch isn't complete until some critical missing features are add=
ed
>> to io_bus, though, so its not really just 10 lines.
>>  For one, it will
>> need to support much more than 6 devices.
>>    =20
>
> Isn't this like a #define change? With the item patch we are still
> limited in the number of groups we can create.
>  =20

Well, no because we want to support ~512 of these things, so the array
is not going to scale.  Right now iosignalfd is implemented as a
tree+list, which is a little better for scalability but even that needs
to change soon.  We probably ultimately want to do either a rbtree or
radixtree for all of these things.  But that is an optimization patch
for a later day ;)

> What we gain is a simple array/list instead of a tree of
> linked lists that makes cheshire cheese out of CPU data cache.
>
>  =20

Yeah, that is a down side, I admit.  But the current io_bus array will
probably not scale going forward either so it needs to be addressed on
that side as well.  We can always implement a SW cache, if need be, to
account for this.

>>  It will also need to support
>> multiple matches.
>>    =20
>
> What, signal many fds on the same address/value pair?
> I see this as a bug. Why is this a good thing to support?
> Just increases the chance of leaking this fd.
>  =20

I believe Avi asked for this feature specifically, so I will defer to him=
=2E


>  =20
>> Also you are proposing an general interface change
>> that doesn't make sense to all but one device type.  So now every
>> io-device developer that comes along will scratch their head at what t=
o
>> do with that field.
>>    =20
>
> What do they do with is_write now? Ignore it. It's used in a whole
> of 1 place.
>
>  =20
>> None of these are insurmountable hurdles, but my point is that today t=
he
>> complexity is encapsulated in the proper place IMO.
>>    =20
>
> It's better to get rid of complexity than encapsulate it.
>  =20

All you are doing is moving the complexity to a place where I don't see
it serving a benefit to any code other than the one you just took it
away from.  Like it or not, io_bus will have to address scale and
data-matching to do what you want.  And the address/data match doesn't
make sense to anyone else afaict.  In addition, data-matching at that
level is even harder because we can make little simplifications with the
way we do things now (like enforce that all add/lens conform to the
group addr/len).  If you go to a general address/data tuple decoder, you
will presumably need to have a much more flexible decoder design
(overlapping regions, etc).

Again, not insurmountable...but I am not seeing the advantage to make
this change worthwhile either.


>  =20
>>  E.g. The one and
>> only device that cares to do this "weird" thing handles it behind an
>> interface that makes sense to all parties involved.
>>    =20
>>>  =20
>>>      =20
>>>> If there isn't a use case for other devices to have
>>>> aliasing, I would think the logic is best contained in iosignalfd.  =
Do
>>>> you have something in mind?
>>>>    =20
>>>>        =20
>>> One is enough :)
>>>  =20
>>>      =20
>> I am not convinced yet. ;)  It appears to me that we are leaking
>> iosignalfd-isms into the general code.  If there is another device tha=
t
>> wants to do something similar, ok.  But I can't think of any.
>>    =20
>
> You never know. is_write was used by a whole of 1 user: coalesced_mmio,=

> then your patch comes along ...
>  =20

Can it wait until that happens, then?  :)  I'm already at v8 and a v9 is
brewing.  It's not like we can't change later if something better comes
along.

>
>  =20
>>> Seriously, do you see that this saves you all of RCU, linked lists an=
d
>>> counters?
>>>      =20
>> Well, also keep in mind we will probably be converting io_bus to RCU
>> very soon, so we are going the opposite direction ;)
>>
>> Kind Regards,
>> -Greg
>>
>>    =20
>
> Same direction. Let's put RCU in iobus, we don't need another one on
> top of it. That's encapsulating complexity.
>  =20

Is this really all that complicated?  The iosignalfd code is fairly
trivial even with the group/item nesting IMO.  I also think it makes
sense to live where it is.

Thanks Michael,
-Greg



--------------enig7994C608DA10D13B18D9ABBD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpAVDYACgkQP5K2CMvXmqGLUQCdEr9ojt7kshJm3ju3NJEwqMcj
47QAn2GzAw45gu+zJrtmSjci1qz2nVMM
=ykok
-----END PGP SIGNATURE-----

--------------enig7994C608DA10D13B18D9ABBD--
