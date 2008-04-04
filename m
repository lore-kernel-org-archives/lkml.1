Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbYDDPlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbYDDPlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 11:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756959AbYDDPlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 11:41:32 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:53712 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895AbYDDPlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 11:41:31 -0400
Subject: Re: debugfs_remove() vs. anything that is dynamic
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20080404153402.GB16923@kroah.com>
References: <1207266986.19189.14.camel@johannes.berg>
	 <20080404153402.GB16923@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jk9x+LuOgBkzW8aOUWPP"
Date: Fri, 04 Apr 2008 17:41:24 +0200
Message-Id: <1207323684.19189.54.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jk9x+LuOgBkzW8aOUWPP
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> If you worry about this type of interaction, use debugfs_create_file,
> which takes a fileops, and set your module owner in there so that the
> reference count will not allow your module from being removed.
>
> Also remember, you have to be root to unload modules, so if you are
> doing that, and you have debugfs files open, you should know better :)

That really was just an example, we have per-wireless-device debugfs
code users can easily trigger a debugfs_remove() by unplugging a usb
netdevice for example. Also, that means that anything that is dynamic
would have the lifetime rules imposed by debugfs which is rather
awkward.

The current code for simple_attr_open copies the in i_private pointer:

attr->data =3D inode->i_private;

if, instead, it would keep a reference to that, like

attr->dataptr =3D &=EF=BB=BFinode->i_private;

we could NULL out that pointer on debugfs_remove() and have
simple_attr_read() just return -ENOENT.


However, if nobody else is concerned about this, I'll just remove all
the wireless debugfs code instead, I just don't want to allow crashing
it that way.

johannes

--=-jk9x+LuOgBkzW8aOUWPP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/ZMI6Vg1VMiehFYAQLlpBAAhUXSUeRHR1ZHw3eYMLxZ4cl6D6YO1pat
9XVJkEVI+xz63w375IN4p3jG4UZxl7KHwBUgiFCXxQ0zzYyuPHEHUBV3okoUaxuX
9JkFd9AMvqaMgSTP6mjSGApLhjty9wlDdf0rC3so6p0SfmHwMxIXHjy05t4aBw9W
UWBGn/NrAuDGOLJG2MJxlkTQSyVd3hWkxDKAeI44MVhTgGtQndTOeO1e14XfYZbx
6Xh8t3f71y10pI0V+zFzS5ffoPO37QHGAcvyJ+AaFRqQMogQvDfSvE1HD1w+pqZR
Ydo0SJ8oLZyL4ibjKJ1yBZsJVAyAqEcBbgj2GQ4J0TPO7arQda42MudyaPUSQXWc
HAtu+WV9J1Ut3SFDg4DjxtmcmftuS3K/ZLwh/uR6F6fCmH0fOhb8dwH4kJ4bHBlR
+M0jaYbGXnbBpRZLk4U/1e7F3mYgn8bksXBcXyKGGeAcOiXKaZlTLwvkYS3w4PaS
oInGxgOnxYCirwaqVwZCQTBIqm/PgZm8dQ53qSNntuJRoXyfwzhL9bO/xzz/iUnP
hIh7qHbzxxVD79dmRibcJbU4sBj7FvElROjPWhDAOVplhDzaneaZd7uEc1Y3odgz
9gkVgpDUwP5dDkImurWnF1UbvEUuN4meMCuv4ZbQnv599FdAspKZAdleZZMdCOWE
R/lspyXbBKE=
=Y/NJ
-----END PGP SIGNATURE-----

--=-jk9x+LuOgBkzW8aOUWPP--

