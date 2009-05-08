Return-Path: <linux-kernel-owner+w=401wt.eu-S1763649AbZEHTzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763649AbZEHTzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbZEHTzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:55:25 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:57088 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbZEHTzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:55:24 -0400
Message-ID: <4A048E1D.3060101@novell.com>
Date: Fri, 08 May 2009 15:55:09 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <20090507233503.GA9103@amt.cnet> <4A03E644.5000103@redhat.com> <20090508104228.GD3011@amt.cnet> <4A0428FC.8080304@novell.com> <20090508164845.GI6788@linux.vnet.ibm.com>
In-Reply-To: <20090508164845.GI6788@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig02F8DBD1ED49D777E9C49E25"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig02F8DBD1ED49D777E9C49E25
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Paul E. McKenney wrote:
> On Fri, May 08, 2009 at 08:43:40AM -0400, Gregory Haskins wrote:
>  =20
>> Marcelo Tosatti wrote:
>>    =20
>>> On Fri, May 08, 2009 at 10:59:00AM +0300, Avi Kivity wrote:
>>>  =20
>>>      =20
>>>> Marcelo Tosatti wrote:
>>>>    =20
>>>>        =20
>>>>> I think comparison is not entirely fair. You're using
>>>>> KVM_HC_VAPIC_POLL_IRQ ("null" hypercall) and the compiler optimizes=
 that
>>>>> (on Intel) to only one register read:
>>>>>
>>>>>         nr =3D kvm_register_read(vcpu, VCPU_REGS_RAX);
>>>>>
>>>>> Whereas in a real hypercall for (say) PIO you would need the addres=
s,
>>>>> size, direction and data.
>>>>>  =20
>>>>>      =20
>>>>>          =20
>>>> Well, that's probably one of the reasons pio is slower, as the cpu h=
as =20
>>>> to set these up, and the kernel has to read them.
>>>>
>>>>    =20
>>>>        =20
>>>>> Also for PIO/MMIO you're adding this unoptimized lookup to the =20
>>>>> measurement:
>>>>>
>>>>>         pio_dev =3D vcpu_find_pio_dev(vcpu, port, size, !in);
>>>>>         if (pio_dev) {
>>>>>                 kernel_pio(pio_dev, vcpu, vcpu->arch.pio_data);
>>>>>                 complete_pio(vcpu);                 return 1;
>>>>>         }
>>>>>  =20
>>>>>      =20
>>>>>          =20
>>>> Since there are only one or two elements in the list, I don't see ho=
w it =20
>>>> could be optimized.
>>>>    =20
>>>>        =20
>>> speaker_ioport, pit_ioport, pic_ioport and plus nulldev ioport. nulld=
ev=20
>>> is probably the last in the io_bus list.
>>>
>>> Not sure if this one matters very much. Point is you should measure t=
he
>>> exit time only, not the pio path vs hypercall path in kvm.=20
>>>  =20
>>>      =20
>> The problem is the exit time in of itself isnt all that interesting to=

>> me.  What I am interested in measuring is how long it takes KVM to
>> process the request and realize that I want to execute function "X".=20
>> Ultimately that is what matters in terms of execution latency and is
>> thus the more interesting data.  I think the exit time is possibly an
>> interesting 5th data point, but its more of a side-bar IMO.   In any
>> case, I suspect that both exits will be approximately the same at the
>> VT/SVM level.
>>
>> OTOH: If there is a patch out there to improve KVMs code (say
>> specifically the PIO handling logic), that is fair-game here and we
>> should benchmark it.  For instance, if you have ideas on ways to impro=
ve
>> the find_pio_dev performance, etc....   One item may be to replace the=

>> kvm->lock on the bus scan with an RCU or something.... (though PIOs ar=
e
>> very frequent and the constant re-entry to an an RCU read-side CS may
>> effectively cause a perpetual grace-period and may be too prohibitive)=
=2E=20
>> CC'ing pmck.
>>    =20
>
> Hello, Greg!
>
> Not a problem.  ;-)
>
> A grace period only needs to wait on RCU read-side critical sections th=
at
> started before the grace period started.  As soon as those pre-existing=

> RCU read-side critical get done, the grace period can end, regardless
> of how many RCU read-side critical sections might have started after
> the grace period started.
>
> If you find a situation where huge numbers of RCU read-side critical
> sections do indefinitely delay a grace period, then that is a bug in
> RCU that I need to fix.
>
> Of course, if you have a single RCU read-side critical section that
> runs for a very long time, that -will- delay a grace period.  As long
> as you don't do it too often, this is not a problem, though if running
> a single RCU read-side critical section for more than a few millisecond=
s
> is probably not a good thing.  Not as bad as holding a heavily contende=
d
> spinlock for a few milliseconds, but still not a good thing.
>  =20

Hey Paul,
  This makes sense, and it clears up a misconception I had about RCU.=20
So thanks for that.

Based on what Paul said, I think we can get some amount of gains in the
PIO and PIOoHC stats from converting to RCU.  I will do this next.

-Greg




--------------enig02F8DBD1ED49D777E9C49E25
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoEjh0ACgkQlOSOBdgZUxnAxwCdEvAztPO0UbyVkgp9rx/mnPYI
WIcAn2Ii+seW+FUf40IfaJo9oZqNjfi8
=nA67
-----END PGP SIGNATURE-----

--------------enig02F8DBD1ED49D777E9C49E25--
