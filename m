Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbYJ1QNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbYJ1QNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYJ1QNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:13:45 -0400
Received: from mail45.e.nsc.no ([193.213.115.45]:63722 "EHLO mail45.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321AbYJ1QNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:13:44 -0400
X-Greylist: delayed 2344 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2008 12:13:40 EDT
From: Henrik Austad <henrik@austad.us>
Reply-To: henrik@austad.us
To: Ingo Molnar <mingo@elte.hu>
Subject: Rearranging layout of code in the scheduler
Date: Tue, 28 Oct 2008 16:34:11 +0100
User-Agent: KMail/1.9.10
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1791685.J4d34tD93S";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810281634.11285.henrik@austad.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1791685.J4d34tD93S
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,=20

Before I dive in, I should probably justify my motivations for writing
this email. I'm working away on implementing an EDF scheduler for real
time tasks in the kernel. This again leads to hacking at the existing
source as I'm not about to toss out the entire scheduler - just replace
(by some Kconfig switch) the RR/FIFO classes. As to why I'm looking at
EDF, I think the answer to that is a bit too long (and not appropriate
for this email anyway) so I'll leave that part out.

However, what I do mean to discuss is the current state of the scheduler
code. Working through the code, I must say I'm really impressed. The
code is clean, it is well thought out and the new approach with
sched_class and sched_entity makes it very modular. However, digging
deeper, I find myself turning more and more desperate, looking over my
shoulder for a way out.

Now, I'm in no doubt that the code *is* modular, that it *is* clean and
tidy, but coming from outside, it is not that easy to grasp it all. And,
it is not just the sheer size and complexity of the scheduler itself,
but also a lot with how the code is arranged.

=46or instance, functions like free_fair_sched_group,
alloc_fair_sched_group etc - does IMHO belong in sched_fair.c and not in
sched.c. The same goes for several rt-functions and structs.

So, if one drew up a list over all events that would cause functions in
sched.c to be called, this could be used to make a minimized 'interface'
and then let the scheduler call the appropriate function for the given
class in the same fashion sched_tick is used today.=20

What I would like, is to rip out all the *actual* scheduling logic and
put this in sched_[fair|rt].c and let sched be purely event-driven
(which would be a nice design goal in itself). This would also lead to
sched_[fair|rt].h, where the structs, macros, defines etc can be
defined. Today these are defined in just about everywhere, making the
code unnecessary complicated (I'm not going to say messy since I'm not
*that* senior to kernel coding :-))

Why not use the sched_class for all that it's worth - make the different
classes implement a set of functions and let sched.c be oblivious to
what's going on other than turning the machinery around?

Is this something worth pursuing? I mean, the scheduler *does* work, and
if it ain't broken, don't fix it. However, I have a strong feeling that
this can be done a lot cleaner, not to mention, changing from one type
of scheduler to another will be much easier. :-)

=2D-=20
med Vennlig Hilsen - Yours Sincerely
Henrik Austad

--nextPart1791685.J4d34tD93S
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBJBzDz/8Nu36TQ45ERAnp9AJ99jyqNIIGeBp/8JX8Z+w7KX3q6aACglSj1
OwbpcRNsf2TYBl6gFnYjUbk=
=grto
-----END PGP SIGNATURE-----

--nextPart1791685.J4d34tD93S--
