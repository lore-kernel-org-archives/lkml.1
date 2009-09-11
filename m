Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbZIKQA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbZIKQA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 12:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZIKQAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 12:00:25 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:41651 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbZIKQAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 12:00:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=VDL+oiTG7tDpGGmRCdsOGKbeIfJj1Pv+AELZ5J1phdhLehPIXcF0/hU/u1MlniDJxl
         FX0VhVA2fElr0Ntb5fCqjp94mxXmcBrYr/TUH6PXFeMDYM5j4Ax37iUF52lwIlHATtVJ
         VdLcvka/+nSqRoXMGqVRKbvpPv9n3QfBcQcgY=
Message-ID: <4AAA7415.5080204@gmail.com>
Date: Fri, 11 Sep 2009 12:00:21 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
CC: "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       akpm@linux-foundation.org, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, s.hetze@linux-ag.com
Subject: Re: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
References: <cover.1251388414.git.mst@redhat.com> <20090827160750.GD23722@redhat.com> <20090903183945.GF28651@ovro.caltech.edu> <20090907101537.GH3031@redhat.com> <20090908172035.GB319@ovro.caltech.edu>
In-Reply-To: <20090908172035.GB319@ovro.caltech.edu>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig44D4489987F3DAB472725FC4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig44D4489987F3DAB472725FC4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ira W. Snyder wrote:
> On Mon, Sep 07, 2009 at 01:15:37PM +0300, Michael S. Tsirkin wrote:
>> On Thu, Sep 03, 2009 at 11:39:45AM -0700, Ira W. Snyder wrote:
>>> On Thu, Aug 27, 2009 at 07:07:50PM +0300, Michael S. Tsirkin wrote:
>>>> What it is: vhost net is a character device that can be used to redu=
ce
>>>> the number of system calls involved in virtio networking.
>>>> Existing virtio net code is used in the guest without modification.
>>>>
>>>> There's similarity with vringfd, with some differences and reduced s=
cope
>>>> - uses eventfd for signalling
>>>> - structures can be moved around in memory at any time (good for mig=
ration)
>>>> - support memory table and not just an offset (needed for kvm)
>>>>
>>>> common virtio related code has been put in a separate file vhost.c a=
nd
>>>> can be made into a separate module if/when more backends appear.  I =
used
>>>> Rusty's lguest.c as the source for developing this part : this suppl=
ied
>>>> me with witty comments I wouldn't be able to write myself.
>>>>
>>>> What it is not: vhost net is not a bus, and not a generic new system=

>>>> call. No assumptions are made on how guest performs hypercalls.
>>>> Userspace hypervisors are supported as well as kvm.
>>>>
>>>> How it works: Basically, we connect virtio frontend (configured by
>>>> userspace) to a backend. The backend could be a network device, or a=

>>>> tun-like device. In this version I only support raw socket as a back=
end,
>>>> which can be bound to e.g. SR IOV, or to macvlan device.  Backend is=

>>>> also configured by userspace, including vlan/mac etc.
>>>>
>>>> Status:
>>>> This works for me, and I haven't see any crashes.
>>>> I have done some light benchmarking (with v4), compared to userspace=
, I
>>>> see improved latency (as I save up to 4 system calls per packet) but=
 not
>>>> bandwidth/CPU (as TSO and interrupt mitigation are not supported).  =
For
>>>> ping benchmark (where there's no TSO) troughput is also improved.
>>>>
>>>> Features that I plan to look at in the future:
>>>> - tap support
>>>> - TSO
>>>> - interrupt mitigation
>>>> - zero copy
>>>>
>>> Hello Michael,
>>>
>>> I've started looking at vhost with the intention of using it over PCI=
 to
>>> connect physical machines together.
>>>
>>> The part that I am struggling with the most is figuring out which par=
ts
>>> of the rings are in the host's memory, and which parts are in the
>>> guest's memory.
>> All rings are in guest's memory, to match existing virtio code.
>=20
> Ok, this makes sense.
>=20
>> vhost
>> assumes that the memory space of the hypervisor userspace process cove=
rs
>> the whole of guest memory.
>=20
> Is this necessary? Why? The assumption seems very wrong when you're
> doing data transport between two physical systems via PCI.

FWIW: VBUS handles this situation via the "memctx" abstraction.  IOW,
the memory is not assumed to be a userspace address.  Rather, it is a
memctx-specific address, which can be userspace, or any other type
(including hardware, dma-engine, etc).  As long as the memctx knows how
to translate it, it will work.

Kind Regards,
-Greg


--------------enig44D4489987F3DAB472725FC4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqqdBYACgkQP5K2CMvXmqG10wCeMsWj8pZ67IwUC/p5CWgPbkcS
1E8An17le37yKs06FqAvx8ohzQF+yphQ
=VaYm
-----END PGP SIGNATURE-----

--------------enig44D4489987F3DAB472725FC4--
