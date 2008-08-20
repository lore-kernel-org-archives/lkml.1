Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbYHTINx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbYHTINx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 04:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYHTINh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 04:13:37 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:39225 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752898AbYHTINe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 04:13:34 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@vger.kernel.org, Jaya Kumar <jayakumar.lkml@gmail.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh@veritas.com>, Johannes Weiner <hannes@saeurebad.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Kel Modderman <kel@otaku42.de>,
       Markus Armbruster <armbru@redhat.com>
In-Reply-To: <20080818233824.5d219105.akpm@linux-foundation.org>
References: <1219125765-31833-1-git-send-email-ijc@hellion.org.uk>
	 <20080818233824.5d219105.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4nMPuaMLDOGOGHFms84P"
Date: Wed, 20 Aug 2008 09:13:23 +0100
Message-Id: <1219220003.3996.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] fbdefio: add set_page_dirty handler to deferred IO FB
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4nMPuaMLDOGOGHFms84P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-18 at 23:38 -0700, Andrew Morton wrote:
> On Tue, 19 Aug 2008 07:02:45 +0100 Ian Campbell <ijc@hellion.org.uk> wrot=
e:
>=20
> > Fixes kernel BUG at lib/radix-tree.c:473.
> >=20
> > Previously the handler was incidentally provided by tmpfs but this was
> > removed with:
> >=20
> >   commit 14fcc23fdc78e9d32372553ccf21758a9bd56fa1
> >   Author: Hugh Dickins <hugh@veritas.com>
> >   Date:   Mon Jul 28 15:46:19 2008 -0700
> >=20
> >     tmpfs: fix kernel BUG in shmem_delete_inode
> >=20
> > relying on this behaviour was incorrect in any case and the BUG
> > also appeared when the device node was on an ext3 filesystem.
> >=20
> > Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
> > Acked-by: Jaya Kumar <jayakumar.lkml@gmail.com>
> > Acked-by: Nick Piggin <npiggin@suse.de>
> > Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
> > Cc: Nick Piggin <npiggin@suse.de>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Hugh Dickins <hugh@veritas.com>
> > Cc: Johannes Weiner <hannes@saeurebad.de>
> > Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> > Cc: Kel Modderman <kel@otaku42.de>
> > Cc: Markus Armbruster <armbru@redhat.com>
> > Cc: stable@vger.kernel.org [14fcc23fd is in 2.6.25.14 and 2.6.26.1]
> > ---
> >  drivers/video/fb_defio.c |   12 ++++++++++++
> >  1 files changed, 12 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/drivers/video/fb_defio.c b/drivers/video/fb_defio.c
> > index 59df132..214bb7c 100644
> > --- a/drivers/video/fb_defio.c
> > +++ b/drivers/video/fb_defio.c
> > @@ -114,11 +114,23 @@ static struct vm_operations_struct fb_deferred_io=
_vm_ops =3D {
> >  	.page_mkwrite	=3D fb_deferred_io_mkwrite,
> >  };
> > =20
> > +static int fb_deferred_io_set_page_dirty(struct page *page)
> > +{
> > +	if (!PageDirty(page))
> > +		SetPageDirty(page);
> > +	return 0;
> > +}
>=20
> <searches, finds the thread.  "kernel BUG at lib/radix-tree.c:473!">

Sorry, I had an unsent reply to self pointing to
http://marc.info/?l=3Dlinux-kernel&m=3D121869811531858

> Is there actually any benefit in setting these pages dirty?  Or should
> this be an empty function?  I see claims in the above thread that this
> driver uses PG_dirty for optimising writeback but I can't immediately
> locate any code which actually does that.

I'm not really that familiar with this driver, but me neither. It seems
to actually use a list constructed at fault time (in io_mkwrite).

> > +static const struct address_space_operations fb_deferred_io_aops =3D {
> > +	.set_page_dirty =3D fb_deferred_io_set_page_dirty,
> > +};
> > +
> >  static int fb_deferred_io_mmap(struct fb_info *info, struct vm_area_st=
ruct *vma)
> >  {
> >  	vma->vm_ops =3D &fb_deferred_io_vm_ops;
> >  	vma->vm_flags |=3D ( VM_IO | VM_RESERVED | VM_DONTEXPAND );
> >  	vma->vm_private_data =3D info;
> > +	vma->vm_file->f_mapping->a_ops =3D &fb_deferred_io_aops;
> >  	return 0;
> >  }
>=20
> Seems a bit odd to rewrite the address_space_operations at mmap()-time.
> A filesystem will usually do this on the inode when it is first being
> set up, when no other thread of control can be looking at it.
>=20
> 	grep 'if .*[-]>a_ops' */*.c
>=20
> and you'll see that lots of code assumes that a_ops doesn't get
> swizzled around (to contain a bunch of NULL pointers!) under its feet.=20
> Maybe none of those code paths are applicable to the /dev/fb0 inode,
> but it would be painful to work out which paths _are_ applicable and to
> verify that they're all safe wrt a_ops getting whisked away.
>=20
> Rewriting page->mapping within the vm_operations_struct.fault handler
> seems a bit suspect for similar reasons.
>=20
> I suspect that we just shouldn't be pretending that this is a regular
> anon/pagecache page to this extent.

Quite possibly, as I say I'm not really familiar with this code, I just
want my framebuffer to work again ;-)

Perhaps applying the band-aid at open time instead would be preferred?
Reworking the guts of this thing doesn't sound like the best option in
an rc4 timeframe and reverting 14fcc23fdc doesn't seem wise either.

FWIW the 2.6.25/2.6.26 stable branches also have 14fcc23fdc in them now
too.

>   Maybe a suitable fix would be to
> teach fb_deferred_io_fault() to instantiate the pte itself
> (vm_insert_page()) and then return VM_FAULT_NOPAGE?

I had a stab at it but naively translating your paragraph into code
didn't work (no change in symptoms), which is hardly surprising since I
haven't had a chance to really examine what's (supposed to be) going
on...

Ian.

> I assume there's a reason why we aren't VM_IO/VM_RESERVED/PG_reserved in
> here.
>=20
>=20
--=20
Ian Campbell

Who made the world I cannot tell;
'Tis made, and here am I in hell.
My hand, though now my knuckles bleed,
I never soiled with such a deed.
		-- A. E. Housman

--=-4nMPuaMLDOGOGHFms84P
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkir0iMACgkQM0+0qS9rzVkgnACg0zygBPLKFtoMOlKcTR0L/vHV
Jw4An2jDxbsCXAgwk1YM8DrRo9s3nDuY
=GfcL
-----END PGP SIGNATURE-----

--=-4nMPuaMLDOGOGHFms84P--

