Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab0CIVAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 16:00:01 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:42800 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069Ab0CIU75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 15:59:57 -0500
Date: Tue, 9 Mar 2010 17:59:48 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Kacur <jkacur@gmail.com>
Subject: Re: [PATCH 2/3] input: use input_mutex instead of BKL when opening
 input device
Message-ID: <20100309205947.GB1498@holoscopio.com>
References: <1268162386-2745-1-git-send-email-cascardo@holoscopio.com>
 <1268162386-2745-2-git-send-email-cascardo@holoscopio.com>
 <201003092112.14071.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TakKZr9L6Hm6aLOc"
Content-Disposition: inline
In-Reply-To: <201003092112.14071.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 09, 2010 at 09:12:13PM +0100, Arnd Bergmann wrote:
> On Tuesday 09 March 2010, Thadeu Lima de Souza Cascardo wrote:
> >  MODULE_AUTHOR("Vojtech Pavlik <vojtech@suse.cz>");
> > @@ -1881,7 +1880,7 @@ static int input_open_file(struct inode *inode, s=
truct file *file)
> >         const struct file_operations *old_fops, *new_fops =3D NULL;
> >         int err;
> > =20
> > -       lock_kernel();
> > +       mutex_lock(&input_mutex);
> >         /* No load-on-demand here? */
> >         handler =3D input_table[iminor(inode) >> 5];
> >         if (!handler || !(new_fops =3D fops_get(handler->fops))) {
> > @@ -1909,7 +1908,7 @@ static int input_open_file(struct inode *inode, s=
truct file *file)
> >         }
> >         fops_put(old_fops);
> >  out:
> > -       unlock_kernel();
> > +       mutex_unlock(&input_mutex);
> >         return err;
> >  }
> > =20
> > --=20
>=20
> Well, actually please have a look at
> http://git.kernel.org/?p=3Dlinux/kernel/git/arnd/playground.git;a=3Dcommi=
tdiff;h=3Dc06fd0234357618a5741ce958d58901ae4cb7ac1
>=20
> * use mutex_lock_interruptible() where possible
> * you probably don't want to hold input_mutex when calling into the lower
>   device's open function
>=20
> 	Arnd

Yeah. I was just looking at your appointed branch. And I've noticed your
change was better.

I was willing to let the open call go unprotected. But ended up checking
that the three callees were fine (they do not call any of the other
functions that take the mutex).

Since the fops_put/fops_get do protect that section from the handler
removal and I can't think of any other race right now, I think your
version is really better.

Acked-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Regards,
Cascardo.

--TakKZr9L6Hm6aLOc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuWtsMACgkQyTpryRcqtS0XjgCghF1eduvktyWryrkoEFY03k5p
sKIAn1obCxXzHZWQQ1cItZ158aEuXdXS
=HQGd
-----END PGP SIGNATURE-----

--TakKZr9L6Hm6aLOc--
