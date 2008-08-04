Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbYHDV6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbYHDV6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbYHDV6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:58:42 -0400
Received: from home.keithp.com ([63.227.221.253]:3729 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbYHDV6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:58:41 -0400
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
From: Keith Packard <keithp@keithp.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: keithp@keithp.com, Christoph Hellwig <hch@infradead.org>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
In-Reply-To: <200808041902.23970.nickpiggin@yahoo.com.au>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <20080801205052.GA28747@infradead.org>
	 <1217814896.23437.420.camel@koto.keithp.com>
	 <200808041902.23970.nickpiggin@yahoo.com.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9i85DXy/H63TCyipn3v2"
Date: Mon, 04 Aug 2008 14:58:36 -0700
Message-Id: <1217887116.24714.118.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9i85DXy/H63TCyipn3v2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-04 at 19:02 +1000, Nick Piggin wrote:

> > I suppose we could have user space allocate the shmem file (either via
> > tmpfs or sysv ipc). tmpfs suffers from the maxfd issue, while sysv ipc
> > runs up against the SHMMAX value.
>=20
> This is how I'd suggested it work as well. I think a little bit
> more effort should be spent looking at making this work.

Well, I've spent a day thinking about using existing user-space APIs to
get at shmem files. While it's nice that we've discovered a
filesystem-independent mechanism to pin file pages, we haven't found
anything similar for creating the files. In particular, what I want is:

 1) Anonymous files backed by swap
 2) Freed when the last process using them exits
 3) That never appear in the file system
 4) Do not consume a low FD (yeah, I know, rewrite the desktop)

So, what I could do is

	char	template[] =3D "/dev/shm/drm-XXXXXX";
	int	fd;
	fd =3D mkstemp (template);
	unlink (template);
	ftruncate (fd, size)
	object =3D drm_create_an_object_for_a_file (fd);
	close (fd);

While I haven't written any code yet, this should work and will even be
compatible with my current user-space API. I have to create a DRM object
for the file in any case, and so I don't need to hold onto the fd.
Releasing the fd also eliminates any ulimit issues.=20

The drm_create_an_object_for_a_file call could return another fd. But,
note that the original shmem fd has no real value to the application in
this case.

I can imagine other cases where mapping non-shmem files would make sense
though, in particular it's fairly easy to envision mapping an image file
to the GTT and having the graphics process decode and display it without
any additional copies. I think this demonstrates the potential utility
of the general file mapping operation.

But, I'd like to have you reconsider whether it makes sense for user
space to go through the above dance to create anonymous shared objects
when the kernel already supports precisely the desired semantics and
even exposes them to the ipc/shm implementation.

We'd offer two paths in DRM -- one that used an existing file and
created an object using that as backing store, and a second one that
created anonymous objects using shmem as backing store. Transient data
would use anonymous objects while applications could directly map
arbitrary file contents as well.

--=20
keith.packard@intel.com

--=-9i85DXy/H63TCyipn3v2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIl3uMQp8BWwlsTdMRArAaAKCEX1qof1cI+0ghNBbBvruPRungYgCfe5f8
U0zL7WKtYrhMD4zth1hdZO8=
=khO5
-----END PGP SIGNATURE-----

--=-9i85DXy/H63TCyipn3v2--

