Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbXFGHLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbXFGHLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 03:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbXFGHLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 03:11:01 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4374 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbXFGHLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 03:11:00 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 7 Jun 2007 00:10:58 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/8] fdmap v2 - fdmap core
In-Reply-To: <4667AB97.8090603@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0706070004470.4875@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169031.1>
 <4667AB97.8090603@cosmosbay.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1795850513-1590864617-1181200258=:4875"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1795850513-1590864617-1181200258=:4875
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 7 Jun 2007, Eric Dumazet wrote:

> Davide Libenzi a =E9crit :
> > Core code for the fdmap implementation. Random allocation, exact alloca=
tion,
> > de-allocation and lookup are all O(1) operations. It also support the
> "legacy"
> > sequential (compact) file descriptor allocation, that is O(N) like the =
old
> > fdtable implementation.
> > Like the old "struct fdtable", fdmap is RCU friendly too.
> >
>=20
> Hi Davide
>=20
> I just took a 10 minutes look before running away this morning, I'll try =
to
> test this to get performance numbers in about 12 hours.

Ok, thx!


> > +int fdmap_newfd_seq(struct fd_map *fmap, unsigned int start,
> > +=09=09    unsigned int limit, unsigned long flags)
> > +{
> > +=09int fd;
> > +
> > +=09if (unlikely(start))
> > +=09=09start =3D start - fmap->base;
> > +=09if (likely(start < fmap->fdnext))
> > +=09=09start =3D fmap->fdnext;
> > +=09fd =3D find_next_zero_bit(fmap->map, fmap->size, start);
> > +=09if (unlikely(fd >=3D limit))
> > +=09=09return -EMFILE;
> > +=09if (unlikely(fd >=3D fmap->size))
> > +=09=09return -ENOSPC;
>=20
> > +=09fmap->fdnext =3D fd + 1;
>=20
> Here you broke POSIX I'm afraid.
>=20
> You might need some test like
>=20
>     if (start <=3D fmap->fdnext)
>         fmap->fdnext =3D fd + 1;

Whoops :) It's running everything fine on my machine, so I think not many=
=20
sw uses F_DUPFD ;) Will fix tomorrow.
I also have other changes to do, a couple performance related. I also=20
forgot the --diffstat option for quilt refresh, that'd show the diffstat=20
inside the patch.



> Also I'm not sure the first unlikely() and likely() are worth it.
>=20
> They probably match the user code you wrote yourself :)

95% or more of the code, uses get_unused_fd(), that calls with start =3D=3D=
 0.
So the likely/unlikely are appropriate.



- Davide


--1795850513-1590864617-1181200258=:4875--
