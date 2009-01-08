Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbZAHDYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbZAHDYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 22:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbZAHDYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 22:24:23 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:42178 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbZAHDYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 22:24:22 -0500
Message-ID: <49657297.9000708@novell.com>
Date: Wed, 07 Jan 2009 22:27:19 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       Ingo Molnar <mingo@elte.hu>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
References: <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain> <1231281801.11687.125.camel@twins> <1231283778.11687.136.camel@twins> <1231329783.11687.287.camel@twins> <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain> <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain> <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <20090107210923.GV2002@parisc-linux.org> <20090107213924.GP496@one.firstfloor.org> <49652C7C.3000909@novell.com> <alpine.LFD.2.00.0901071510390.3057@localhost.localdomain> <alpine.LFD.2.00.0901071516280.3057@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901071516280.3057@localhost.localdomain>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA6E298A189E1D7FE75596CE2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA6E298A189E1D7FE75596CE2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

[resend: i fat fingered the reply-to-all for a few messages]

>>> Linus Torvalds <torvalds@linux-foundation.org> 01/07/09 6:20 PM >>>


>On Wed, 7 Jan 2009, Linus Torvalds wrote:
>> >
>> > "Is get_task_struct() really that bad?"
>>
>> Yes. It's an atomic access (two, in fact, since you need to release it=

>> too), which is a huge deal if we're talking about a timing-critical
>> section of code.
>
>There's another issue: you also need to lock the thing that gives you th=
e
>task pointer in the first place. So it's not sufficient to do
>get_task_struct(), you also need to do it within a context where you kno=
w
>that the pointer is not going away _while_ you do it.

In my defense, the -rt versions of the patches guarantee this is ok
based on a little hack:

"if the owner holds the mutex, and you old the wait-lock, you guarantee
owner cannot exit". Therefore get_task_struct is guaranteed not to race
if you take it while holding wait-lock. (This is, in fact, why the
original design had a loop within a loop...the inner loop would break
when it wanted the outer-loop to reacquire wait-lock for things such as
re-acquiring owner/get-task

This is in part enforced by the fact that in -rt, pending pending
waiters force the mutex-release to hit the slow path (and therefore
require that the wait-lock be reacquired by the releaser). I am under
the impression (because I havent had a chance to really review the new
patches yet) that this is not necessarily the case here for the mainline
patch, since the owner field is not managed atomically IIUC

Again, not advocating get/put task per se. Just wanted to point out that
I didnt flub this up on the original -rt design ;)

-Greg



--------------enigA6E298A189E1D7FE75596CE2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkllcpcACgkQlOSOBdgZUxmHDgCeMAv3mbNtvYAMfY1dX6fycf8z
HikAn0RUGDwsaKZgRANnvoqD/VRIdGe4
=i0z6
-----END PGP SIGNATURE-----

--------------enigA6E298A189E1D7FE75596CE2--
