Return-Path: <linux-kernel-owner+w=401wt.eu-S1750967AbZLOFEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750967AbZLOFEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 00:04:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750819AbZLOFE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 00:04:29 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:42665 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbZLOFE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 00:04:28 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: uclinux-dev@uclinux.org
Subject: Re: [uClinux-dev] [PATCH 5/7] NOMMU: Avoiding duplicate icache flushes of shared maps
Date: Mon, 14 Dec 2009 23:52:48 -0500
User-Agent: KMail/1.12.4 (Linux/2.6.31.4; KDE/4.3.4; x86_64; ; )
Cc: Jamie Lokier <jamie@shareable.org>, stefani@seibold.net,
       linux-kernel@vger.kernel.org, jie.zhang@analog.com
References: <20091210135755.6325.78149.stgit@warthog.procyon.org.uk> <20091210135816.6325.37536.stgit@warthog.procyon.org.uk> <20091215004143.GA15785@shareable.org>
In-Reply-To: <20091215004143.GA15785@shareable.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6865042.250As3gu3d";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200912142352.50331.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6865042.250As3gu3d
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Monday 14 December 2009 19:41:43 Jamie Lokier wrote:
> David Howells wrote:
> > From: Mike Frysinger <vapier.adi@gmail.com>
> >
> > When working with FDPIC, there are many shared mappings of read-only co=
de
> > regions between applications (the C library, applet packages like
> > busybox, etc.), but the current do_mmap_pgoff() function will issue an
> > icache flush whenever a VMA is added to an MM instead of only doing it
> > when the map is initially created.
> >
> > @@ -1354,10 +1355,14 @@ unsigned long do_mmap_pgoff(struct file *file,
> >  share:
> >  	add_vma_to_mm(current->mm, vma);
> >
> > -	up_write(&nommu_region_sem);
> > +	/* we flush the region from the icache only when the first executable
> > +	 * mapping of it is made  */
> > +	if (vma->vm_flags & VM_EXEC && !region->vm_icache_flushed) {
> > +		flush_icache_range(region->vm_start, region->vm_end);
> > +		region->vm_icache_flushed =3D true;
> > +	}
> >
> > -	if (prot & PROT_EXEC)
> > -		flush_icache_range(result, result + len);
> > +	up_write(&nommu_region_sem);
> >
> >  	kleave(" =3D %lx", result);
> >  	return result;
>=20
> This looks like it won't work in the following sequence:
>=20
>     process A maps MAP_SHARED, PROT_READ|PROT_EXEC (flushes icache)
>     process B maps MAP_SHARED, PROT_READ|PROT_WRITE
>         and proceeds to modify the data
>     process C maps MAP_SHARED, PROT_READ|PROT_EXEC (no icache flush)
>=20
> On a possibly related note:
>=20
> What about icache flushes in these cases:

David will have to respond here, but a test on my side shows that a mmap()=
=20
request on an existing r-xs mapping does not grant write access.  you get b=
ack=20
a r-xs mapping.

> When using mprotect() PROT_READ|PROT_WRITE -> PROT_READ|PROT_EXEC,
> e.g. as an FDPIC implementation may do when updating PLT entries.

when would that happen ?  PLT entries arent updated inline in the .text=20
section (if they were, you'd have TEXTRELs and the .text wouldnt be shared)=
=2E =20
by definition, the function descriptor is stored in the GOT and that is wha=
t=20
gets updated by the resolver during lazy relocation.

> And when calling msync(), like this:
>=20
>     process A maps MAP_SHARED, PROT_READ|PROT_EXEC (flushes icache)
>     process B maps MAP_SHARED, PROT_READ|PROT_WRITE
>         and proceeds to modify the data
>     process A calls msync()
>         and proceeds to execute the modified contents
>=20
> Do you think the mprotect() and msync() calls should flush icache in
> those cases?

from what i can tell, sys_mprotect() and sys_msync() do not currently exist=
 in=20
the nommu kernel port, and no one has complained so far ;).

uClibc has simply stubbed out these functions into inlines that always retu=
rn=20
success.  msync() is defined as pushing changes written to a file-backed=20
mapping back to disk, and i dont think this gets used under nommu.

> If seen arguments for it, and arguments that the executing process can
> be expected to explicitly flush icache itself in those cases because
> it knows what it is doing.  (Personally I lean towards the kernel
> should be doing it.  IRIX interestingly offers both alternatives, with
> a PROT_EXEC_NOFLUSH).
>=20
> But in the first example above, I don't see how process C could be
> expected to know it must flush icache, and process B could just be an
> "optimised with writable mmap" file copy, so it shouldn't have
> responsibility for icache either.

isnt this what the MS_INVALIDATE flag to msync() is for ?

> Or is icache fully flushed on every context switch on all nommu
> architectures anyway, and defined to do so?

ugh, no, this def does not occur, nor should it.  the overhead here would b=
e=20
crazy.  on a normal FDPIC boot, the only icache flush called are the initia=
l=20
creation of the shared .text maps in the C library and the applications.  a=
nd=20
with a large busybox, you rarely see another one since the .text is shared.
=2Dmike

--nextPart6865042.250As3gu3d
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iQIcBAABAgAGBQJLJxYiAAoJEEFjO5/oN/WBVnsP/3PzA82OHLUgqvQziM4TsTOe
pXybukS0H/127y8GMFJZ7xhlISZ2g0wBExJa4gt3ophR7kizLiK3ey6bGdF5njdB
acrs9GFUhOlnysuyQuEQB1dmLi9EnFgrC59VgNG7uwwJ/2kJ//JUQknaR+7fhaXZ
GtB64/r82YpTgvknUBRwkX5RvurD+p9kK4IGuVFwpH8AorOgqZ00U+XqllB/eFbt
Zx8dC0gpKWNjMfDawlBqrwQbU24FNzlz5JOXlDwXVO6mvrAPQsJ6VybmksSp/lK1
3QlgAaaVRC0ICqPWGs/Z526hy7mAKVX2LcCEJb5oe98YuijLqy98Dp1+PaqLnHKB
DqK+kYBjurmIZb5sfZPXwtgT6vZz6iP08iY+4N14Pu/tfiMMUHVwPCvFvnL7PLgM
M1ldVrxkfqN9wnDAMrPQzMHzORSMB46uUY7/mCwwgkH6llNU/EbSf/cjwjKcAbf1
AvvGgfjJR9yKRcxpGe8+MNBiyELBrnsuotlWQ6cl9V5vLq0f6d+cT3vm2cNcPsR3
EfPTjxAM8CFRf7ImDxHjx7kM6KzfEKmryW2xlsqFX7boI8s6HOUZVB35iSe4Ke7d
9I6M48qXz1SuCivQxcPC350za9ROckXbJsviXo1TkwfSqCKMddoUVhKM1n2r40fn
BZf+conqm9hJYm+mm/Jg
=DZEl
-----END PGP SIGNATURE-----

--nextPart6865042.250As3gu3d--
