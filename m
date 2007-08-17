Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbXHQHf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbXHQHf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 03:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbXHQHfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 03:35:19 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34097 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbXHQHfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 03:35:17 -0400
Message-ID: <46C54FB8.7050504@bull.net>
Date: Fri, 17 Aug 2007 09:35:20 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>, Ingo Molnar <mingo@elte.hu>,
       virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC 3/4]Introduce "account modifiers" mechanism
References: <46C4719A.2060308@bull.net> <46C4720F.7030304@bull.net>	 <46C4725A.4070607@bull.net>  <46C4740F.2050701@bull.net> <1187303955.6449.7.camel@localhost.localdomain>
In-Reply-To: <1187303955.6449.7.camel@localhost.localdomain>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 17/08/2007 09:40:26,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 17/08/2007 09:40:27,
	Serialize complete at 17/08/2007 09:40:27
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig68B7E5EE8B48CA38480FE25A"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig68B7E5EE8B48CA38480FE25A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Rusty Russell wrote:
> On Thu, 2007-08-16 at 17:58 +0200, Laurent Vivier wrote:
>> [PATCH 3/3] introduce "account modifiers" mechanism in the kernel allo=
wing a
>> module to modify the collected accounting for a given task. This imple=
mentation
>> is based on the "preempt_notifier". "account_system_time()" and
>> "account_user_time()" can call functions registered by a module to mod=
ify the
>> cputime value.
>>
>> Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
>=20
>=20
> Hi Laurent,

Hi Rusty,
how are your puppies ?
And thank you for your comment.

> 	This seems a little like overkill.  Why not just add an
> "account_guest_time" which subtracts the given amount of time from
> system time (if available) and adds it to guest time?  Then kvm (and
> lguest) should just need to call this at the right times.

We can. I did something like this before.
By doing like that, I think there is a major issue: system time can be
decreasing (as we substract a value from it), and thus we can have negati=
ve
value in a tool like top. It's why I play with the cputime to add to syst=
em time
and not directly with the system time.

BUT I'm very open, my only goal is be able to compute guest time, "how" i=
s not
very important...

what we can do:

- keep PATCHES 1 and 2, because we need to store guest time for cpu and t=
asks.
It is very generic.

- remove PATCH 3, and add in task_struct a "ktime vtime" where we accumul=
ate
guest time (by calling something like guest_enter() and guest_exit() from=
 the
virtualization engine), and when in account_system_time() we have cputime=
 >
vtime we substrate vtime from cputime and add vtime to user time and gues=
t time.
But doing like this we freeze in kernel/sched.c the link between system t=
ime,
user time and guest time (i.e. system time =3D system time - vtime, user =
time =3D
user time + vtime and guest time =3D guest time + vtime).

- modify PATCH 4 to use new PATCH 3.

Do you agree ? Anybody doesn't agree ?

Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth


--------------enig68B7E5EE8B48CA38480FE25A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFGxU+89Kffa9pFVzwRAh/bAKCa7ICgQDN6sPkpvUvtDHQaC3sXmQCglg5B
usAST6mne8Zo5tYtvkRGuvU=
=xswk
-----END PGP SIGNATURE-----

--------------enig68B7E5EE8B48CA38480FE25A--
