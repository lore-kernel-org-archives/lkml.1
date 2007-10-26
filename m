Return-Path: <linux-kernel-owner+w=401wt.eu-S1762205AbXJZP3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762205AbXJZP3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbXJZP3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:29:08 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:60462 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753642AbXJZP3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:29:07 -0400
Subject: Re: 2.6.24-rc1: First impressions
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Martin Knoblauch <spamtrap@knobisoft.de>, linux-kernel@vger.kernel.org,
       Fengguang Wu <wfg@mail.ustc.edu.cn>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20071026152221.GA26619@elte.hu>
References: <796505.25770.qm@web32612.mail.mud.yahoo.com>
	 <20071026152221.GA26619@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/vWf6AeNYTRiaP7OgmsZ"
Date: Fri, 26 Oct 2007 17:29:00 +0200
Message-Id: <1193412540.27652.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/vWf6AeNYTRiaP7OgmsZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-26 at 17:22 +0200, Ingo Molnar wrote:
> * Martin Knoblauch <spamtrap@knobisoft.de> wrote:
>=20
> > Hi ,
> >=20
> >  just to give some feedback on 2.6.24-rc1. For some time I am tracking=20
> >  IO/writeback problems that hurt system responsiveness big-time. I=20
> >  tested Peters stuff together with Fenguangs additions and it looked=20
> >  promising. Therefore I was very happy to see Peters stuff going into=20
> >  2.6.24 and waited eagerly for rc1. In short, I am impressed. This=20
> >  really looks good. IO throughput is great and I could not reproduce=20
> >  the responsiveness problems so far.
> >=20
> >  Below are a some numbers of my brute-force I/O tests that I can use=20
> >  to bring responsiveness down. My platform is a HP/DL380g4, dual CPUs,=20
> >  HT-enabled, 8 GB Memory, SmartaArray6i controller with 4x72GB SCSI=20
> >  disks as RAID5 (battery protected writeback cahe enabled) and gigabit=20
> >  networking (tg3). User space is 64-bit RHEL4.3
> >=20
> >  I am basically doing copies using "dd" with 1MB blocksize. Local=20
> >  Filesystem ist ext2 (noatime). IO-Scheduler is dealine, as it tends=20
> >  to give best results. NFS3 Server is a Sun/T2000/Solaris10. The tests=20
> >  are:
> >=20
> > dd1 - copy 16 GB from /dev/zero to local FS
> > dd1-dir - same, but using O_DIRECT for output
> > dd2/dd2-dir - copy 2x7.6 GB in parallel from /dev/zero to local FS
> > dd3/dd3-dir - copy 3x5.2 GB in parallel from /dev/zero lo local FS
> > net1 - copy 5.2 GB from NFS3 share to local FS
> > mix3 - copy 3x5.2 GB from /dev/zero to local disk and two NFS3 shares
> >=20
> >  I did the numbers for 2.6.19.2, 2.6.22.6 and 2.6.24-rc1. All units=20
> >  are MB/sec.
> >=20
> > test           2.6.19.2     2.6.22.6    2.6.24.-rc1
> > ----------------------------------------------------------------
> > dd1                  28           50             96
> > dd1-dir              88           88             86
> > dd2              2x16.5         2x11         2x44.5
> > dd2-dir            2x44         2x44           2x43
> > dd3               3x9.8        3x8.7           3x30
> > dd3-dir          3x29.5       3x29.5         3x28.5
> > net1              30-33        50-55          37-52
> > mix3              17/32        25/50          96/35 (disk/combined-netw=
ork)
>=20
> wow, really nice results! Peter does know how to make stuff fast :) Now=20
> lets pick up some of Peter's other, previously discarded patches as well
> :-)
>=20
> Such as the rewritten reclaim (clockpro) patches:
>=20
>   http://programming.kicks-ass.net/kernel-patches/page-replace/

I think riel is taking over that stuff with his split vm and policies
per type.

> The improve-swap-performance (swap-token) patches:
>=20
>   http://programming.kicks-ass.net/kernel-patches/swap_token/

Ashwin's version did get upstreamed.

> His enable-swap-over-NFS [and other complex IO transports] patches:
>=20
>   http://programming.kicks-ass.net/kernel-patches/vm_deadlock/

Will post that one again, soonish.... Esp. after Linus professed liking
to have swap over NFS.

I've been working on improving the changelogs and comments in that code.

latest code (somewhat raw, as rushed by ingo posting this) in:
http://programming.kicks-ass.net/kernel-patches/vm_deadlock/v2.6.23-mm1/

> And the concurrent pagecache patches:
>=20
>   http://programming.kicks-ass.net/kernel-patches/concurrent-pagecache/
>=20
> as a starter :-) I think the MM should get out of deep-feature-freeze=20
> mode - there's tons of room to improve :-/

Yeah, that one would be cool, but it depends on Nick getting his
lockless pagecache upstream. For those who don't know, both are in -rt
(and have been for some time) so it's not unproven code.

--=-/vWf6AeNYTRiaP7OgmsZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHIge8XA2jU0ANEf4RAuWIAJ4nL4LoddUCKTX6aAnsRmobeZ/u4QCeL6pr
m1ABetZ6z9OwrJGO7fMOi4o=
=gigc
-----END PGP SIGNATURE-----

--=-/vWf6AeNYTRiaP7OgmsZ--

