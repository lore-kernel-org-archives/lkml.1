Return-Path: <linux-kernel-owner+w=401wt.eu-S1758414AbYH2QoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414AbYH2QoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYH2QoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:44:01 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:47248 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbYH2QoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:44:00 -0400
Message-ID: <48B826BD.9000308@novell.com>
Date: Fri, 29 Aug 2008 12:41:33 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Gregory Haskins <gregory.haskins@gmail.com>, mingo@elte.hu,
       rostedt@goodmis.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] seqlock: serialize against writers
References: <20080829154237.1196.66825.stgit@dev.haskins.net> <87abevpzv7.fsf@basil.nowhere.org> <48B81F60.3080409@gmail.com> <20080829162216.GW26610@one.firstfloor.org> <48B823F6.1010509@novell.com> <20080829163749.GX26610@one.firstfloor.org>
In-Reply-To: <20080829163749.GX26610@one.firstfloor.org>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1C42A7E83BE93405CFF80494"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1C42A7E83BE93405CFF80494
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Andi Kleen wrote:
> On Fri, Aug 29, 2008 at 12:29:42PM -0400, Gregory Haskins wrote:
>  =20
>> Andi Kleen wrote:
>>    =20
>>>> Im running it on a x86_64 box as we speak.  How can I tell if there =
is a
>>>> certain mode that is permitting this?
>>>>    =20
>>>>        =20
>>> If the boot up says you're running with PMtimer then it uses the fall=
back
>>> (usually happens on pre Fam10h AMD boxes). A typical Intel box
>>> would use the faster ring 3 only TSC path and then explode with your
>>> change I bet.=20
>>>  =20
>>>      =20
>> Thinking about this some more, perhaps the issue is I am not hitting t=
he
>> contended path in vsyscall?
>>    =20
>
> Yes it will be only contended when gettimeofday() races with the timer =

> interrupt.  You could try to run gettimeofday() in a loop and see how
> long it holds up.
>
> But anyways from the theory you should crash when it happens.=20
> Writes to kernel data are not allowed in vsyscalls and your read_lock c=
learly=20
> does a write.
>  =20

Oh I don't deny that it does.  The compiler neatly reminded me that it
could no longer be "const".  I just was ignorant of the userspace
requirement ;)

But we *do* have a serious problem here.  A non-preemptible seqlock_t
will do bad things if it preempts the writer, so we need some kind of
solution here, one way or the other.  So suggestions welcome :)  I
realize this is only an issue currently in PREEMPT_RT so perhaps most
will not care... but I do need to solve this at least for this branch.

I currently do not see a way to solve this problem that doesn't involve
some heavier involvement in the read path (read: const seqlock_t need
not apply).  Given that, we either need to address the const requirement
for userspace, alter userspace's usage, or find another way to address
the deadlock.  Any ideas?

-Greg



--------------enig1C42A7E83BE93405CFF80494
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAki4Jr0ACgkQlOSOBdgZUxnocgCfVzLmgdUV5LPI95T8qs+Gmtid
kUIAn2fhrLscugbNjKNUbP1JDZYFK1VA
=JMDu
-----END PGP SIGNATURE-----

--------------enig1C42A7E83BE93405CFF80494--
