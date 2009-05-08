Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbZEHMoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbZEHMoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 08:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbZEHMns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 08:43:48 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:60841 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbZEHMns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 08:43:48 -0400
Message-ID: <4A0428FC.8080304@novell.com>
Date: Fri, 08 May 2009 08:43:40 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>, paulmck@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <20090507233503.GA9103@amt.cnet> <4A03E644.5000103@redhat.com> <20090508104228.GD3011@amt.cnet>
In-Reply-To: <20090508104228.GD3011@amt.cnet>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3082A6FB543864F4DE1EA887"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3082A6FB543864F4DE1EA887
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Marcelo Tosatti wrote:
> On Fri, May 08, 2009 at 10:59:00AM +0300, Avi Kivity wrote:
>  =20
>> Marcelo Tosatti wrote:
>>    =20
>>> I think comparison is not entirely fair. You're using
>>> KVM_HC_VAPIC_POLL_IRQ ("null" hypercall) and the compiler optimizes t=
hat
>>> (on Intel) to only one register read:
>>>
>>>         nr =3D kvm_register_read(vcpu, VCPU_REGS_RAX);
>>>
>>> Whereas in a real hypercall for (say) PIO you would need the address,=

>>> size, direction and data.
>>>  =20
>>>      =20
>> Well, that's probably one of the reasons pio is slower, as the cpu has=
 =20
>> to set these up, and the kernel has to read them.
>>
>>    =20
>>> Also for PIO/MMIO you're adding this unoptimized lookup to the =20
>>> measurement:
>>>
>>>         pio_dev =3D vcpu_find_pio_dev(vcpu, port, size, !in);
>>>         if (pio_dev) {
>>>                 kernel_pio(pio_dev, vcpu, vcpu->arch.pio_data);
>>>                 complete_pio(vcpu);                 return 1;
>>>         }
>>>  =20
>>>      =20
>> Since there are only one or two elements in the list, I don't see how =
it =20
>> could be optimized.
>>    =20
>
> speaker_ioport, pit_ioport, pic_ioport and plus nulldev ioport. nulldev=
=20
> is probably the last in the io_bus list.
>
> Not sure if this one matters very much. Point is you should measure the=

> exit time only, not the pio path vs hypercall path in kvm.=20
>  =20

The problem is the exit time in of itself isnt all that interesting to
me.  What I am interested in measuring is how long it takes KVM to
process the request and realize that I want to execute function "X".=20
Ultimately that is what matters in terms of execution latency and is
thus the more interesting data.  I think the exit time is possibly an
interesting 5th data point, but its more of a side-bar IMO.   In any
case, I suspect that both exits will be approximately the same at the
VT/SVM level.

OTOH: If there is a patch out there to improve KVMs code (say
specifically the PIO handling logic), that is fair-game here and we
should benchmark it.  For instance, if you have ideas on ways to improve
the find_pio_dev performance, etc....   One item may be to replace the
kvm->lock on the bus scan with an RCU or something.... (though PIOs are
very frequent and the constant re-entry to an an RCU read-side CS may
effectively cause a perpetual grace-period and may be too prohibitive).=20
CC'ing pmck.

FWIW: the PIOoHCs were about 140ns slower than pure HC, so some of that
140 can possibly be recouped.  I currently suspect the lock acquisition
in the iobus-scan is the bulk of that time, but that is admittedly a
guess.  The remaining 200-250ns is elsewhere in the PIO decode.

-Greg





--------------enig3082A6FB543864F4DE1EA887
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoEKPwACgkQlOSOBdgZUxn4YgCeIEMrf+a3qhCsnmEIwwSKayZl
yVgAn0/xjiAwW2W2xy6BhGjGhoPXfa4S
=7pkT
-----END PGP SIGNATURE-----

--------------enig3082A6FB543864F4DE1EA887--
