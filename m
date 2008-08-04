Return-Path: <linux-kernel-owner+w=401wt.eu-S1755126AbYHDLqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbYHDLqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 07:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbYHDLqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 07:46:07 -0400
Received: from home.keithp.com ([63.227.221.253]:1640 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbYHDLqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 07:46:06 -0400
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
From: Keith Packard <keithp@keithp.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: keithp@keithp.com, Christoph Hellwig <hch@infradead.org>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
In-Reply-To: <200808042043.46710.nickpiggin@yahoo.com.au>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <200808041902.23970.nickpiggin@yahoo.com.au>
	 <1217845590.24714.45.camel@koto.keithp.com>
	 <200808042043.46710.nickpiggin@yahoo.com.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uj+ENrIdGD9OOGx1oL2E"
Date: Mon, 04 Aug 2008 04:45:52 -0700
Message-Id: <1217850352.24714.66.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uj+ENrIdGD9OOGx1oL2E
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-04 at 20:43 +1000, Nick Piggin wrote:

> True. It would make it possible for the userspace program to pass in
> anonymous pages, but maybe not a big deal if you're using files and
> shmem based management.

We considered using anonymous pages, but as the user-mapping is not a
feature, it seemed like it wasn't the right model. Plus, many of these
objects need to be shared across multiple processes, so anonymous pages
would be a pain there.

> pagecache_write_begin/pagecache_write_end should be reasonable, but you
> have to be careful of the semantics of it. For example, you can't really
> read anything from the page inside the calls because the filesystem may
> not bring it up to date.

Ok, that's useful information which isn't clear from the docs.

> read_mapping_page might help there.

That does look a lot more like what I want, as it returns an unlocked
page. And, makes my code look cleaner to boot:

        inode =3D obj->filp->f_path.dentry->d_inode;
        mapping =3D inode->i_mapping;
        for (i =3D 0; i < page_count; i++) {
                page =3D read_mapping_page(mapping, i, NULL);
                if (IS_ERR(page)) {
                        ret =3D PTR_ERR(page);
                        DRM_ERROR("read_mapping_page failed: %d\n", ret);
                        i915_gem_object_free_page_list(obj);
                        return ret;
                }
                obj_priv->page_list[i] =3D page;
        }

Does this look like it conforms to the vfs api? It appears to work when
using shmem at least.

> Right, that's your specific implementation, but for some cases the
> memory management can map or be implemented using generic primitives.
> Using pagecache for your memory for example should work nicely. Making
> it shmem specific and using internal APIs seems like a negative step
> until you really have a good reason to.

Yup, I'm liking the general file mechanism, I used shmem only because
that seemed like the obvious file system you'd want underneath these
objects.

--=20
keith.packard@intel.com

--=-uj+ENrIdGD9OOGx1oL2E
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIluvwQp8BWwlsTdMRAipxAKCEs+7kV9ZcICB2XKYucecDxrh5kwCfdIti
1z9DRFha06EmpnbgqKbaFEQ=
=l2Vw
-----END PGP SIGNATURE-----

--=-uj+ENrIdGD9OOGx1oL2E--

