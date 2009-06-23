Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbZFWPp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbZFWPp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbZFWPpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:45:15 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:51841 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759056AbZFWPpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:45:14 -0400
Message-ID: <4A40F879.3040408@novell.com>
Date: Tue, 23 Jun 2009 11:44:57 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH] kvm: remove in_range from kvm_io_device
References: <20090623150008.GA21059@redhat.com> <4A40F311.80105@novell.com> <20090623153144.GA21423@redhat.com>
In-Reply-To: <20090623153144.GA21423@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig46215A287F9E7DDFCF51422F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig46215A287F9E7DDFCF51422F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Jun 23, 2009 at 11:21:53AM -0400, Gregory Haskins wrote:
>  =20
>> Michael S. Tsirkin wrote:
>>    =20
>>> Remove in_range from kvm_io_device and ask read/write callbacks, if
>>> supplied, to perform range checks internally. This allows aliasing
>>> (mostly for in-kernel virtio), as well as better error handling by
>>> making it possible to pass errors up to userspace. And it's enough to=

>>> look at the diffstat to see that it's a better API anyway.
>>>
>>> While we are at it, document locking rules for kvm_io_device.
>>>  =20
>>>      =20
>> Sorry, not trying to be a PITA, but I liked your last suggestion bette=
r.  :(
>>
>> I am thinking forward to when we want to use something smarter than a
>> linear search (like rbtree/radix) for scaling the number of "devices"
>> (really, virtio-rings) that we support.
>>    =20
>
> in_range is broken for this anyway: you need more than a boolean
> predicate to implement rbtree/radix
>  =20

Yes, understood..in_range() needs to be (pardon the pun) "addressed"
;).  But getting rid of in_range() and moving the match logic into the
read()/write() verbs is potentially a step in the wrong direction if we
ever wanted to go that route.  And I'm pretty sure we do.

>  =20
>> The current device-count
>> target is 512, which we will begin to rapidly consume as the in-kernel=

>> virtio work progresses.
>>    =20
>
> That's a large number. I had in mind more like 4 virtio devices, for
> starters: 1 for each virtqueue in net and block.
>  =20

Thats way to low.  For instance, I'll be wanting to do things like
802.1p which would be 16 virtio-rings per device (8 prio levels tx, 8
levels rx).  And thats just for one device.  I think Avi came up with an
estimate of supporting 20 devices @ 16 queues =3D 320, so we rounded it t=
o
512.
>  =20
>>  This proposed approach forces us into a
>> potential O(256) algorithm in the hotpath (all MMIO/PIO exits will hit=

>> this, not just in-kernel users).  How would you address this?
>>    =20
>
> Two ideas that come to mind:
> - add addr/len fields to devices, use these to speed up lookup
>  =20

Yep, thats what I was thinking as well.  We can have the top-level
(group) be an rbtree on addr/len, and then walk the list of items at
that address linearly using your read/write() approach.


> - add a small cache that can be scanned first
>  =20

Yep, I think we may want to do this anyway independent of the search alg.=


> In both cases, you first do a fast lookup, ask the device whether
> it wants the transaction, then resort to linear scan if not
>  =20

-Greg




--------------enig46215A287F9E7DDFCF51422F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpA+HkACgkQlOSOBdgZUxnlugCfV/85Jx0MFGzDM6Zmbu0L6rtz
sgAAn2DIqUQBqnvJhml3lamWiwRQV6O0
=dNVL
-----END PGP SIGNATURE-----

--------------enig46215A287F9E7DDFCF51422F--
