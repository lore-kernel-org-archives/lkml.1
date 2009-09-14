Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178AbZINGYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbZINGYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 02:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbZINGY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 02:24:28 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:56325 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbZINGY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 02:24:28 -0400
Message-ID: <4AADE19D.7030808@web.de>
Date: Mon, 14 Sep 2009 08:24:29 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 3/5] hw-breakpoints: Rewrite the hw-breakpoints layer
 on top of perf counters
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com> <1252571367-25876-4-git-send-email-fweisbec@gmail.com> <4AAACAA4.2030707@web.de> <20090914034131.GF14306@nowhere>
In-Reply-To: <20090914034131.GF14306@nowhere>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE9F90D6E3DD5BA6A43D60444"
X-Provags-ID: V01U2FsdGVkX18IukYDqas8wGf9bbKIiHh6ln3piXe3y2tVgTF/
	Hbaed+DEJsxdfuBbqtzWQLcuzOylnQpsbphOof30YFn0+7Igvo
	VEP1nSK/M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE9F90D6E3DD5BA6A43D60444
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Frederic Weisbecker wrote:
> On Sat, Sep 12, 2009 at 12:09:40AM +0200, Jan Kiszka wrote:
>> Frederic Weisbecker wrote:
>>> This patch rebase the implementation of the breakpoints API on top of=

>>> perf counters instances.
>>>
>>> The core breakpoint API has changed a bit:
>>>
>>> - register_kernel_hw_breakpoint() now takes a cpu as a parameter. For=

>>>   now it doesn't support all cpu wide breakpoints but this may be
>>>   implemented soon.
>>>
>>> - unregister_kernel_hw_breakpoint() and unregister_user_hw_breakpoint=
()
>>>   have been unified in a single unregister_hw_breakpoint()
>>>
>>> Each breakpoints now match a perf counter which now handles the
>>> register scheduling, thread/cpu attachment, etc..
>>>
>>> The new layering is now made as follows:
>>>
>>>        ptrace       kgdb      ftrace   perf syscall
>>>           \          |          /         /
>>>            \         |         /         /
>> kgdb doesn't fit here as it requires nmi-safe services.
>>
>> I don't think you want to make the whole stack nmi-safe but rather
>> provide a separate interface that allows kgdb to announce to the kerne=
l
>> when it uses some slot. Those slots should simply be excluded from
>> hardware updates. That's roughly the logic we use in KVM for guest
>> debugging: when the host starts to use debug registers for that purpos=
e,
>> the guest's setting will not effect the real hardware anymore.
>=20
>=20
>=20
> I don't quite understand what must be NMI-safe here. Is it when
> we request a breakpoint or when we hit one?
>=20

Both. With kgdb, the kernel may be interrupted (almost) everywhere, and
then the operator may decide to add/remove hardware breakpoints during
this interruption.

>=20
> =20
>> Still on my wishlist for KVM is a cheap & easy way to obtain the curre=
nt
>> register content or to refresh it in hardware. It's not yet clear to m=
e
>> where to hook this in the given design. It looks like this information=

>> can be scattered over the current thread and some perf counters.
>=20
>=20
> With this design approach, the debug registers are not anymore stored
> in the thread structure. They are not stored anymore actually.
>=20
> Especially because the breakpoint are not anymore assigned to a
> specific address register. This one is decided when the counter
> is enabled. And the counter is often toggled on/off, depending
> if we start/end profiling the desired context. It can be a single task,=

> in which case the counter is enabled while the task is sched in, and
> disabled when it is sched out.
> And between two sched atoms, the register used for a breakpoint
> can be different.
>=20
> The arch informations about the breakpoints (len/type/addr) are stored
> in the counter structure, and the address/control registers contents
> are now dynamically computed.
>=20
> For your needs, basically the control must be done from perfcounters.
> When you switch from host to guest, the counter must be sched out.
> And in the reverse direction, it must be sched in.
> Then perf will take care of that by itself.

Actually, we wanted to avoid sched-out activity, and so far this is
possible. But if both steps are cheap enough, specifically if the
sched-out does _not_ touch the hardware and is very cheap if no
breakpoints are set, KVM will likely be a happy user.

Does that API already exist or what additional work is required?

Jan


--------------enigE9F90D6E3DD5BA6A43D60444
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkqt4Z0ACgkQniDOoMHTA+kyvQCdFSZ58U8f9kDqdSX3upBOxKWr
Z7IAn2gZKNHp68U5r5/9AIxyJugMSXIH
=toV0
-----END PGP SIGNATURE-----

--------------enigE9F90D6E3DD5BA6A43D60444--
