Return-Path: <linux-kernel-owner+w=401wt.eu-S932490AbZAGWcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbZAGWcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762657AbZAGWZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:25:13 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:55890 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762183AbZAGWZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:25:08 -0500
Message-ID: <49652C7C.3000909@novell.com>
Date: Wed, 07 Jan 2009 17:28:12 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
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
References: <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain> <1231281801.11687.125.camel@twins> <1231283778.11687.136.camel@twins> <1231329783.11687.287.camel@twins> <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain> <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain> <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <20090107210923.GV2002@parisc-linux.org> <20090107213924.GP496@one.firstfloor.org>
In-Reply-To: <20090107213924.GP496@one.firstfloor.org>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBDE06008AA53C040729B7369"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBDE06008AA53C040729B7369
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Andi Kleen wrote:
>> I appreciate this is sample code, but using __get_user() on
>> non-userspace pointers messes up architectures which have separate
>> user/kernel spaces (eg the old 4G/4G split for x86-32).  Do we have an=

>> appropriate function for kernel space pointers?=20
>>    =20
>
> probe_kernel_address().
>
> But it's slow.
>
> -Andi
>
>  =20

Can I ask a simple question in light of all this discussion?=20

"Is get_task_struct() really that bad?"

I have to admit you guys have somewhat lost me on some of the more
recent discussion, so its probably just a case of being naive on my
part...but this whole thing seems to have become way more complex than
it needs to be.  Lets boil this down to the core requirements:  We need
to know if the owner task is still running somewhere in the system as a
predicate to whether we should sleep or spin, period.  Now the question
is how to do that.

The get/put task is the obvious answer to me (as an aside, we looked at
task->oncpu rather than the rq->curr stuff which I believe was better),
and I am inclined to think that is perfectly reasonable way to do this:=20
After all, even if acquiring a reference is somewhat expensive (which I
don't really think it is on a modern processor), we are already in the
slowpath as it is and would sleep otherwise.

Steve proposed a really cool trick with RCU since we know that the task
cannot release while holding the lock, and the pointer cannot go away
without waiting for a grace period.  It turned out to introduce latency
side-effects so it  ultimately couldn't be used (and this was in no way
a knock against RCU or you, Paul..just wasn't the right tool for the job
it turned out).

Ok, so onto other ideas.  What if we simply look at something like a
scheduling sequence id.  If we know (within the wait-lock) that task X
is the owner and its on CPU A, then we can simply monitor if A context
switches.  Having something like rq[A]->seq++ every time we schedule()
would suffice and you wouldnt need to hold a task reference...just note
A=3DX->cpu from inside the wait-lock.  I guess the downside there is
putting that extra increment in the schedule() hotpath even if no-one
cares, but I would surmise that should be reasonably cheap when no-one
is pulling the cacheline around other than A (i.e. no observers).

But anyway, my impression from observing the direction this discussion
has taken is that it is being way way over optimized before we even know
if a) the adaptive stuff helps, and b) the get/put-ref hurts.  Food for
thought.

-Greg




--------------enigBDE06008AA53C040729B7369
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkllLHwACgkQlOSOBdgZUxltbQCgiMIUD97U8uHIuXhe7oTSm32j
vQAAnAxsiPilJMPng5/vL+8OfAYNJFbB
=5QzP
-----END PGP SIGNATURE-----

--------------enigBDE06008AA53C040729B7369--
