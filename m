Return-Path: <linux-kernel-owner+w=401wt.eu-S1761414AbXHQJQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761414AbXHQJQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 05:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758203AbXHQJQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 05:16:39 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:38862 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580AbXHQJQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 05:16:37 -0400
Message-ID: <46C56774.2030009@bull.net>
Date: Fri, 17 Aug 2007 11:16:36 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>, Ingo Molnar <mingo@elte.hu>,
       virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC 3/4]Introduce "account modifiers" mechanism
References: <46C4719A.2060308@bull.net> <46C4720F.7030304@bull.net>	 <46C4725A.4070607@bull.net>  <46C4740F.2050701@bull.net>	 <1187303955.6449.7.camel@localhost.localdomain> <46C54FB8.7050504@bull.net> <1187339450.6449.115.camel@localhost.localdomain>
In-Reply-To: <1187339450.6449.115.camel@localhost.localdomain>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 17/08/2007 11:21:45,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 17/08/2007 11:21:47,
	Serialize complete at 17/08/2007 11:21:47
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0381E23CC19789AE44F721AC"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0381E23CC19789AE44F721AC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Rusty Russell wrote:
> On Fri, 2007-08-17 at 09:35 +0200, Laurent Vivier wrote:
>> Rusty Russell wrote:
>>> Hi Laurent,
>> Hi Rusty,
>> how are your puppies ?
>=20
> They're getting a little fat, actually.  Too many features ...
>=20
>> - remove PATCH 3, and add in task_struct a "ktime vtime" where we accu=
mulate
>> guest time (by calling something like guest_enter() and guest_exit() f=
rom the
>> virtualization engine), and when in account_system_time() we have cput=
ime >
>> vtime we substrate vtime from cputime and add vtime to user time and g=
uest time.
>> But doing like this we freeze in kernel/sched.c the link between syste=
m time,
>> user time and guest time (i.e. system time =3D system time - vtime, us=
er time =3D
>> user time + vtime and guest time =3D guest time + vtime).
>=20
> Actually, I think we can set a per-cpu "in_guest" flag for the schedule=
r
> code, which then knows to add the tick to the guest time.  That seems
> the simplest possible solution.
>=20
> lguest or kvm would set the flag before running the guest (which is don=
e
> with preempt disabled or using preemption hooks), and reset it
> afterwards.
>=20
> Thoughts?

It was my first attempt (except I didn't have a per-cpu flag, but a per-t=
ask
flag), it's not visible but I love simplicity... ;-)

A KVM VCPU is stopped by preemption, so when we enter in scheduler we hav=
e
exited from VCPU and thus this flags is off (so we account 0 to the guest=
). What
I did then is "set the flag on when we enter in the VCPU, and
"account_system_time()" sets the flag off when it adds this timeslice to =
cpustat
(and compute correctly guest, user, system time). But I didn't like this =
idea
because all code executed after we entered in the VCPU is accounted to th=
e guest
until we have an account_system_time() and I suppose we can have real sys=
tem
time in this part. And I guess a VCPU can be less than 1 ms (unit of cput=
ime) in
a timeslice.

So ? What's best ?
Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth


--------------enig0381E23CC19789AE44F721AC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFGxWd79Kffa9pFVzwRAq3jAKCZGGebPJKSVM7gZ0Jcw8IaFjFKXACfVo+P
t0lvQShts8SUsT/ECx4EVUk=
=BOzN
-----END PGP SIGNATURE-----

--------------enig0381E23CC19789AE44F721AC--
