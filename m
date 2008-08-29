Return-Path: <linux-kernel-owner+w=401wt.eu-S1758101AbYH2RCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbYH2RCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 13:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYH2RC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 13:02:26 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:44641 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbYH2RCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 13:02:25 -0400
Message-ID: <48B82B12.2020008@novell.com>
Date: Fri, 29 Aug 2008 13:00:02 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Gregory Haskins <gregory.haskins@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] seqlock: serialize against writers
References: <20080829154237.1196.66825.stgit@dev.haskins.net> <87abevpzv7.fsf@basil.nowhere.org> <48B81F60.3080409@gmail.com> <20080829162216.GW26610@one.firstfloor.org> <48B82349.1020109@gmail.com> <alpine.DEB.1.10.0808291233280.17917@gandalf.stny.rr.com> <48B8254D.1010206@gmail.com> <20080829164551.GY26610@one.firstfloor.org>
In-Reply-To: <20080829164551.GY26610@one.firstfloor.org>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA08706DB703BE03F33E4D362"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA08706DB703BE03F33E4D362
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Andi Kleen wrote:
>> I could just force all of the seqbegins to hit the slowpath by hacking=

>> the code and see what happens (aside from slowing down, of course ;)
>>    =20
>
> Only if you don't believe it will really crash? I think it's pretty
> clear even without trying it.
>  =20

Well, I guess it was just to prove to myself that I broke something
because I dont understand how the vsyscall interface works.  But given
your expertise here, I have no problem with just taking your word for it.=



>  =20
>> Question: Which seqlock_t does userspace use?  I assume it uses
>> seqlock_t and not raw_seqlock_t.=20
>>    =20
>
>  =20
>> But the only reason that I ask is that
>> I converted raw_seqlock_t to use the new style as well to be consisten=
t,
>>    =20
>
> There's no raw_seqlock_t anywhere in mainline?
>  =20
Yeah, understood.  There is both in -rt and I was just saying that we
technically only need the seqlock_t fix in -rt.  So if raw_seqlock_t
could be left pristine and solve this problem, that is an acceptable
compromise to me.


> Anyways the variable is declared (in mainline) in asm-x86/vgtod.h=20
>
>  =20
>> even though it is not strictly necessary for the same reasons.  So if
>> perchance userspace uses the raw variant, I could solve this issue by
>> only re-working the seqlock_t variant.  Kind of a long shot, but figur=
ed
>> I would mention it :)
>>    =20
>
> I guess you could define a new seqlock_t which is explicitely user spac=
e
> safe. That might avoid such issues in the future. But then
> that would likely require some code duplication and be ugly.
>
> On the other hand whatever problem you fixing in the kernel
> (to be honest it's still unclear to me what the problem is)
> needs to be likely fixed for the userland lock too.
>  =20

Yeah, it would possibly be a problem in both cases.

The problem I am addressing only exists in -rt since it has seqlock_t
and raw_seqlock_t (with the former using preemptible spinlock_t's).=20
Since the underlying seqlock_t->spinlock_t is preemptible, you can see
that one thread that does:

{
    write_seqlock();
    /* asl */
    write_sequnlock();
}

while other high-prio threads do

do { read_seqbegin(); /* asl */; } while (read_seqretry());

The readers could preempt the writer mid critical section and enter a
live-locked loop.

raw_seqlock_t (which is equivalent to a mainline seqlock_t) do not have
this problem because the spinlock acquisition inside the write_seqlock
disables preemption.

HTH

-Greg



--------------enigA08706DB703BE03F33E4D362
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAki4KxIACgkQlOSOBdgZUxk6aQCfZamECdF8u17y696ZGAvfNRuu
izsAn2qalLj0ctTk3FqKk02v6ny0wKaP
=Gzxt
-----END PGP SIGNATURE-----

--------------enigA08706DB703BE03F33E4D362--
