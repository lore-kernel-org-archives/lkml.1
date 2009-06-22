Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbZFVQ3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbZFVQ3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZFVQ3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:29:24 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:50917 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbZFVQ3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:29:24 -0400
Message-ID: <4A3FB156.3030301@novell.com>
Date: Mon, 22 Jun 2009 12:29:10 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH RFC] pass write value to in_range pointers
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622151631.GA14780@redhat.com> <4A3FA6FC.9030301@novell.com> <20090622160833.GA15228@redhat.com>
In-Reply-To: <20090622160833.GA15228@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1F3C89A1936FD557AD942DC5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1F3C89A1936FD557AD942DC5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Mon, Jun 22, 2009 at 11:45:00AM -0400, Gregory Haskins wrote:
>  =20
>> Michael S. Tsirkin wrote:
>>    =20
>>> It seems that a lot of complexity and trickiness with iosignalfd is
>>> handling the group/item relationship, which comes about because kvm d=
oes
>>> not currently let a device on the bus claim a write transaction based=
 on the
>>> value written.  This could be greatly simplified if the value written=

>>> was passed to the in_range check for write operation.  We could then
>>> simply make each kvm_iosignalfd a device on the bus.
>>>
>>> What does everyone think of the following lightly tested patch?
>>>  =20
>>>      =20
>> Hi Michael,
>>   Its interesting, but I am not convinced its necessary.  We created t=
he
>> group/item layout because iosignalfds are unique in that they are
>> probably the only IO device that wants to do some kind of address
>> aliasing.
>>    =20
>
> We actually already have aliasing: is_write flag is used for this
> purpose.

Yes, but read/write address aliasing is not the same thing is
multi-match data aliasing.  Besides, your proposal also breaks some of
the natural relationship models (e.g. all the aliased iosignal_items
always belong to the same underlying device.  io_bus entries have an
arbitrary topology).


>  Actually, it's possible to remove is_write by passing
> a null pointer in write_val for reads. I like this a bit less as
> the code generated is less compact ... Avi, what do you think?
>
>  =20
>>  With what you are proposing here, you are adding aliasing
>> support to the general infrastructure which I am not (yet) convinced i=
s
>> necessary.
>>    =20
>
> Infrastructure is a big name for something that adds a total of 10 line=
s to kvm.
> And it should at least halve the size of your 450-line patch.
>  =20

Your patch isn't complete until some critical missing features are added
to io_bus, though, so its not really just 10 lines.  For one, it will
need to support much more than 6 devices.  It will also need to support
multiple matches.  Also you are proposing an general interface change
that doesn't make sense to all but one device type.  So now every
io-device developer that comes along will scratch their head at what to
do with that field.

None of these are insurmountable hurdles, but my point is that today the
complexity is encapsulated in the proper place IMO.  E.g. The one and
only device that cares to do this "weird" thing handles it behind an
interface that makes sense to all parties involved.
>  =20
>> If there isn't a use case for other devices to have
>> aliasing, I would think the logic is best contained in iosignalfd.  Do=

>> you have something in mind?
>>    =20
>
> One is enough :)
>  =20

I am not convinced yet. ;)  It appears to me that we are leaking
iosignalfd-isms into the general code.  If there is another device that
wants to do something similar, ok.  But I can't think of any.

> Seriously, do you see that this saves you all of RCU, linked lists and
> counters?

Well, also keep in mind we will probably be converting io_bus to RCU
very soon, so we are going the opposite direction ;)

Kind Regards,
-Greg


--------------enig1F3C89A1936FD557AD942DC5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko/sVYACgkQlOSOBdgZUxlpnACeMboL4+mzKh/2UKwcIx3FqTjF
WEQAn2ePSVbfoMm7NCh5JwoZgbWcJazw
=7TUe
-----END PGP SIGNATURE-----

--------------enig1F3C89A1936FD557AD942DC5--
