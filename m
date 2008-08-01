Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbYHASSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbYHASSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757970AbYHASSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:18:01 -0400
Received: from home.keithp.com ([63.227.221.253]:3494 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757937AbYHASSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:18:00 -0400
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
From: Keith Packard <keithp@keithp.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: keithp@keithp.com, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0808011134360.13604@blonde.site>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <1217573919-7496-2-git-send-email-eric@anholt.net>
	 <Pine.LNX.4.64.0808011134360.13604@blonde.site>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-X81Hn1xUK7hCQy9r22hD"
Date: Fri, 01 Aug 2008 11:06:38 -0700
Message-Id: <1217613998.23437.246.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-X81Hn1xUK7hCQy9r22hD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-08-01 at 11:57 +0100, Hugh Dickins wrote:

> It's fine to be getting the GEM end working using this easiest way,
> and I don't think we'll have a problem with EXPORT_SYMBOL_GPL() on
> shmem_file_setup() or something very like it - it just happens that
> its current callers are not in loadable modules.

Cool. Using shmem saved a huge amount of code in DRM and allows the GEM
objects to be paged to disk if necessary. We haven't added the shrinker
API calls to finish this work, but that shouldn't take much additional
code.

> But shmem_getpage() is very much an internal helper function for
> mm/shmem.c, and I'm pretty sure we should keep it and its sgp_types
> that way: I'll take a look at how you're using it later on, and see
> what makes sense to offer instead.

We use it to get a struct page within a shmem object; we don't need the
sgp types exposed as we only ever use SGP_DIRTY. We could use a narrower
interface like:

int shmem_file_page(struct file *file, int idx, struct page **page)
{
        struct inode *inode =3D file->f_path.dentry->d_inode;

        return shmem_getpage(inode, idx, page, SGP_DIRTY, NULL);
}
EXPORT_SYMBOL(shmem_file_page);


> And I don't think you should assume that all GEM users must have
> CONFIG_SHMEM=3Dy: we should aim for an interface that mm/tiny_shmem.c
> (redirecting to ramfs) can also support.

Seems like the simpler interface should be supportable from ramfs:

int shmem_file_page(struct file *file, int idx, struct page **page)
{
        struct inode *inode =3D file->f_path.dentry->d_inode;
        struct address_space *mapping =3D inode->i_mapping;
        struct page *filepage;
       =20
        filepage =3D find_lock_page(mapping, idx);
        if (!filepage)
                return -ENOSPC;
        *page =3D filepage;
        return 0;
}

(no, I didn't try this)

>   I can believe that GEM and
> TINY won't have much intersection, but let's not force that by using
> shmem_getpage().

I don't know; I'm running without swap on several netbooks these days,
and I can easily believe that TINY would be a reasonable option there.
Thanks for the suggestions.

--=20
keith.packard@intel.com

--=-X81Hn1xUK7hCQy9r22hD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIk1CuQp8BWwlsTdMRAkDXAJ9MxKvO5c8WVAWLL4mmanw0+8m0QACffrtk
wAzZFaxTYekwk1MyAMCg4ZY=
=bD+2
-----END PGP SIGNATURE-----

--=-X81Hn1xUK7hCQy9r22hD--

