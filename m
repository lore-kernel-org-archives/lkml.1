Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYHQQT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYHQQT7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 12:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbYHQQTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 12:19:52 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:10460 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423AbYHQQTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 12:19:51 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Hugh Dickins <hugh@veritas.com>
Cc: Johannes Weiner <hannes@saeurebad.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Kel Modderman <kel@otaku42.de>, Markus Armbruster <armbru@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0808150049110.17216@blonde.site>
References: <1218697362.26014.9.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0808141347480.11013@blonde.site> <48A48879.2000309@goop.org>
	 <Pine.LNX.4.64.0808142104080.29719@blonde.site> <48A4AC01.7040402@goop.org>
	 <871w0r5gw8.fsf@skyscraper.fehenstaub.lan>
	 <Pine.LNX.4.64.0808150049110.17216@blonde.site>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4S8Fg6GeLTdJmQpG4OcC"
Date: Sun, 17 Aug 2008 17:19:32 +0100
Message-Id: <1218989974.3996.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: kernel BUG at lib/radix-tree.c:473!
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4S8Fg6GeLTdJmQpG4OcC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-08-15 at 01:00 +0100, Hugh Dickins wrote:
> On Fri, 15 Aug 2008, Johannes Weiner wrote:
> > Jeremy Fitzhardinge <jeremy@goop.org> writes:
> > > Hugh Dickins wrote:
> > >
> > >> An additional useful input would be: what happens if you replace
> > >> that /dev/fb0 by a symlink /dev/fb0 pointing to an fb0 device node i=
n
> > >> one of your disk filesystems?  I rather expect that to cause the sam=
e
> > >> trouble, which would argue that the driver is wrong and shmem right.
> > >
> > > I don't follow. Do you mean make /dev/fb0 a plain file on a
> > > filesystem?  Or make it a disk device node?  Something else?
> >=20
> > Creating a device node on a different filesystem to see if the driver
> > only worked with the safe shmem set_page_dirty and now breaks due to
> > exposure to the generic version.  Or if the driver works with the
> > generic version through other mappings and the shmem code screws it up
> > somewhere else.
>=20
> Yes, that's it.  I think it was ext2 I referred to, when I worried
> about this when making the change to tmpfs; and my reading of it
> was that ext2 left a device node's a_ops unset, as I was changing
> tmpfs to do.  (Looking at it again, ext2 doesn't even specify its
> .set_page_dirty, so even if it had assigned an a_ops, it wouldn't
> have avoided the default behaviour.)  But I'd like to hear what
> actually happens in practice, rather than relying on my reading.

Creating /tmp/fb0 on an ext3 filesystem gives the same behaviour.

FWIW the patch below apparently makes it work for me, but I'm not going
to pretend I follow what's going on, why or what else it breaks ;-)

Ian.

diff --git a/drivers/video/fb_defio.c b/drivers/video/fb_defio.c
index 59df132..8414646 100644
--- a/drivers/video/fb_defio.c
+++ b/drivers/video/fb_defio.c
@@ -24,6 +24,10 @@
 #include <linux/rmap.h>
 #include <linux/pagemap.h>
=20
+static const struct address_space_operations fb_defio_aops =3D {
+        .set_page_dirty =3D __set_page_dirty_no_writeback,
+};
+
 /* this is to find and return the vmalloc-ed fb pages */
 static int fb_deferred_io_fault(struct vm_area_struct *vma,
 				struct vm_fault *vmf)
@@ -119,6 +123,7 @@ static int fb_deferred_io_mmap(struct fb_info *info, st=
ruct vm_area_struct *vma)
 	vma->vm_ops =3D &fb_deferred_io_vm_ops;
 	vma->vm_flags |=3D ( VM_IO | VM_RESERVED | VM_DONTEXPAND );
 	vma->vm_private_data =3D info;
+	vma->vm_file->f_mapping->a_ops =3D &fb_defio_aops;
 	return 0;
 }
=20

--=20
Ian Campbell

Wharbat darbid yarbou sarbay?

--=-4S8Fg6GeLTdJmQpG4OcC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkioT40ACgkQM0+0qS9rzVkrVwCgzSzBVZ/FQL8XCPchAY37egl5
0KgAn2Y3DPAj/1bHt2wHqethYTtP42Jr
=z8yL
-----END PGP SIGNATURE-----

--=-4S8Fg6GeLTdJmQpG4OcC--

