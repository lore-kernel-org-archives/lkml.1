Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbYEWRzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbYEWRzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbYEWRzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:55:09 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:36652 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbYEWRzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:55:06 -0400
Message-ID: <483704F3.1030803@web.de>
Date: Fri, 23 May 2008 19:54:59 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemcheck: SMP support
References: <20080523141759.GA1833@damson.getinternet.no>	 <4836E55C.5000304@goop.org>	 <19f34abd0805230851w59a5972dk593900cf3ea8c14a@mail.gmail.com>	 <4836FB0B.9020906@web.de> <19f34abd0805231032h2055c092h6423638cb69ca5c9@mail.gmail.com>
In-Reply-To: <19f34abd0805231032h2055c092h6423638cb69ca5c9@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9EA85102A5E7E0132BADD2CF"
X-Provags-ID: V01U2FsdGVkX1+emM6sei+cAiw9kltZdIhVgbboFfsch5STeqwq
	PPTZE0biYSuWLc+cBsXmdJOIpkJMtOWVLFWZr9EdbHVAhGQX5h
	qu5nWPc6k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9EA85102A5E7E0132BADD2CF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Vegard Nossum wrote:
> On Fri, May 23, 2008 at 7:12 PM, Jan Kiszka <jan.kiszka@web.de> wrote:
>> Vegard Nossum wrote:
>>> On Fri, May 23, 2008 at 5:40 PM, Jeremy Fitzhardinge <jeremy@goop.org=
> wrote:
>>>> Vegard Nossum wrote:
>>>>> This works on real hw, but not on qemu. It seems to get stuck waiti=
ng for
>>>>> one
>>>>> of the atomic values to change. Don't know why yet, it might just b=
e yet
>>>>> another bug in qemu... (we've hit at least two of them so far. And =
they
>>>>> were
>>>>> real bugs too.)
>>>>>
>>>> I've noticed that qemu mis-reports the eip of cmpxchg if it faults (=
it
>>>> reports the eip of the start of the basic block, I think).  Does tha=
t match
>>>> what you're seeing?
>>> You mean the EIP that gets pushed on the stack for the page fault?
>>> (That would be bad news for kmemcheck. I suppose the rest of the
>>> kernel never page faults on cmpxchg addresses?)
>>>
>>> Or do you mean the EIP that shows up in gdb?
>>>
>>> But no, it seems to be unrelated. What I hit so far were (in 0.9.0):
>>>
>>> 1. qemu doesn't set the single-stepping flag of DR6 on single-step
>>> debug exceptions.
>>> 2. qemu triggers int 0 (divide error) instead of int 2 on NMI IPIs.
>>>
>>> But both of these were fixed in the latest 0.9.1.
>> I guess you mean trunk - NMI IPIs didn't came with "old" 0.9.1.
>=20
> Are you sure? It does in fact deliver the NMI IPI as far as I can see
> and I am running from a qemu-0.9.1.tar.gz... E.g. for "-smp 3" on this
> 0.9.1 qemu:
>=20
> (first number is smp_processor_id())
>=20
> [0 pause all] <-- in page fault handler
> [1 paused] <-- in nmi handler
> [2 paused]
> [0 resume all] <-- in debug exception handler
> [2 resuming, paused =3D 1] <-- still in nmi handler, now exiting
> [1 resuming, paused =3D 0]

Revision 4205 (2008-04-13) introduced the NMI abstraction to QEMU, 4206
added NMI IPIs - while 0.9.1 was released in January. Find /me confused
about what triggers the handler.

>=20
> But maybe I should try the trunk and see if that fixes the problem I wa=
s seeing!

And even if that hangs, either the internal gdbstub or an external gdb
(on the qemu process) may reveal where things got stuck. Keep in mind
that QEMU is fairly good in widening tiny race windows ;). But if it's
too obscure, just report to qemu-devel.

>=20
>>> I don't yet know if what I'm hitting now is really an error with qemu=
=2E
>>> But I usually trust the real hardware more :-)
>> Try KVM as well. It is, of course, must faster than QEMU, and it comes=

>> with true SMP (given you have a SMP host). With in-kernel irqchip
>> (that's default), KVM now also supports NMI IPIs. And debug registers
>> should be fine with my latest patch.
>>
>> I'm currently trying to get debug support straight for upstream KVM an=
d,
>> where also required, QEMU. SMP debugging is a common issue, but alread=
y
>> usable with KVM. So testers are welcome, an overview on required patch=
es
>> can be provided.
>>
>=20
> Hm. Doesn't KVM require special hardware? I have just a cheap laptop
> (Pentium Dual-Core) and I doubt I will be able to run it... :-(

Yeah, forgot to mention that "minor" precondition...

Jan


--------------enig9EA85102A5E7E0132BADD2CF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFINwT3niDOoMHTA+kRAlsHAJ9zO2ZxBx8n7gE5igK3vxlJXt312gCeJNj4
RmJ+yRqvcM7KppSmHzVKDsc=
=DPRa
-----END PGP SIGNATURE-----

--------------enig9EA85102A5E7E0132BADD2CF--
