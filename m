Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbYJ1TmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbYJ1TmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 15:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbYJ1Tlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 15:41:53 -0400
Received: from mail43.e.nsc.no ([193.213.115.43]:46765 "EHLO mail43.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332AbYJ1Tlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:41:51 -0400
From: Henrik Austad <henrik@austad.us>
Reply-To: henrik@austad.us
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Rearranging layout of code in the scheduler
Date: Tue, 28 Oct 2008 20:41:34 +0100
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, "linux-kernel" <linux-kernel@vger.kernel.org>,
       Dario <faggioli@gandalf.sssup.it>
References: <200810281634.11285.henrik@austad.us> <1225212627.15763.16.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1225212627.15763.16.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart23120474.YU7p0O8LAx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810282041.34706.henrik@austad.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart23120474.YU7p0O8LAx
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 28 October 2008 17:50:27 Peter Zijlstra wrote:
> On Tue, 2008-10-28 at 16:34 +0100, Henrik Austad wrote:
> > Hello,
> >
> > Before I dive in, I should probably justify my motivations for writing
> > this email. I'm working away on implementing an EDF scheduler for real
> > time tasks in the kernel. This again leads to hacking at the existing
> > source as I'm not about to toss out the entire scheduler - just replace
> > (by some Kconfig switch) the RR/FIFO classes. As to why I'm looking at
> > EDF, I think the answer to that is a bit too long (and not appropriate
> > for this email anyway) so I'll leave that part out.
>
> You and a few other folks. The most interesting part of EDF is not the
> actual scheduler itself (although there are fun issues with that as
> well), but extending the Priority Inheritance framework to deal with all
> the fun cases that come with EDF.

well, yes, you trade in priority inversion with deadline inversion. Probabl=
y a=20
few other exotic issues as well :-)

> > However, what I do mean to discuss is the current state of the scheduler
> > code. Working through the code, I must say I'm really impressed. The
> > code is clean, it is well thought out and the new approach with
> > sched_class and sched_entity makes it very modular. However, digging
> > deeper, I find myself turning more and more desperate, looking over my
> > shoulder for a way out.
> >
> > Now, I'm in no doubt that the code *is* modular, that it *is* clean and
> > tidy, but coming from outside, it is not that easy to grasp it all. And,
> > it is not just the sheer size and complexity of the scheduler itself,
> > but also a lot with how the code is arranged.
> >
> > For instance, functions like free_fair_sched_group,
> > alloc_fair_sched_group etc - does IMHO belong in sched_fair.c and not in
> > sched.c. The same goes for several rt-functions and structs.
> >
> > So, if one drew up a list over all events that would cause functions in
> > sched.c to be called, this could be used to make a minimized 'interface'
> > and then let the scheduler call the appropriate function for the given
> > class in the same fashion sched_tick is used today.
>
> I'd start out small by moving the functions to the right file. After
> that you could look at providing methods in the sched_class.

Yes, I was thinking something along those lines, slowly moving things out. =
I=20
just wanted to clear the air before I got started in case someone had some=
=20
real issues with this approach. After all, if it's never going to get merge=
d,=20
there's no point doing it.

> > What I would like, is to rip out all the *actual* scheduling logic and
> > put this in sched_[fair|rt].c and let sched be purely event-driven
> > (which would be a nice design goal in itself). This would also lead to
> > sched_[fair|rt].h, where the structs, macros, defines etc can be
> > defined. Today these are defined in just about everywhere, making the
> > code unnecessary complicated (I'm not going to say messy since I'm not
> > *that* senior to kernel coding :-))
>
> You might need to be careful there, or introduce sched_(fair|rt).h for
> those.

This is a final goal, the light in the end of the tunnel if you like.

> > Why not use the sched_class for all that it's worth - make the different
> > classes implement a set of functions and let sched.c be oblivious to
> > what's going on other than turning the machinery around?
>
> Sounds good, its been on the agenda for a while, but nobody ever got
> around to it.
>
> Other cleanups that can be done are:
>  - get rid of all the load balance iterator stuff and move
>    that all into sched_fair

Ah, yes. I can give that a go

>  - extract the common sched_entity members and create:
>
>    struct {
> 	struct sched_entity_common common;
> 	union {
> 		struct sched_entity fair;
> 		struct sched_rt_entity rt;
> 	}
>    }
>
> > Is this something worth pursuing? I mean, the scheduler *does* work, and
> > if it ain't broken, don't fix it. However, I have a strong feeling that
> > this can be done a lot cleaner, not to mention, changing from one type
> > of scheduler to another will be much easier. :-)
>
> Well, adding a sched_class, no need to replace anything besides that.

I wasn't really aiming at replacing anything (besides the rt-stuff, but as=
=20
said earlier, that's not the issuen ow). I just want to move things to make=
=20
it a bit clearer.=20

=2D-=20
med Vennlig Hilsen - Yours Sincerely
Henrik Austad

--nextPart23120474.YU7p0O8LAx
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBJB2ru/8Nu36TQ45ERAhYSAJ0QZ5VGiWEpdYg9Py7kXNZp5OMm5ACfQEwu
1798x+HqgChj59mkZZy2mQE=
=KzFT
-----END PGP SIGNATURE-----

--nextPart23120474.YU7p0O8LAx--
