Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbYLIO0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbYLIO0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbYLIORY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:17:24 -0500
Received: from gv-out-0910.google.com ([216.239.58.189]:35169 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbYLIOQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=YTvu/jjbcpIr7sMhaXcrSYLPcAxl/fm0KT4/3uMcQoozY265TxNxZC13EikkrhzNKm
         pjShuTNu/BH7L6u0nOn07OavZ+6XMOGTY3k6ILSkrUxJ+1270rKFcYlno4IlfHYQSErj
         t/SPfNX0F2k8IEKFiPcGY1GNBFKrD2vvgMGdY=
Subject: Re: [PATCH] Add basic export support to HFS+.
From: "Diego E. 'Flameeyes'" =?ISO-8859-1?Q?Petten=F2?= 
	<flameeyes@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081209100619.GA18141@infradead.org>
References: <20081204174706.10397.94789.stgit@localhost>
	 <20081209100619.GA18141@infradead.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-suLzGrBLBOsiUw79e1oH"
Date: Tue, 09 Dec 2008 15:16:37 +0100
Message-Id: <1228832197.19631.76.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-suLzGrBLBOsiUw79e1oH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-09 at 05:06 -0500, Christoph Hellwig wrote:
> > +static struct inode *hfsplus_export_get_inode(struct super_block *sb,
> > +					      u64 ino, u32 generation)
> > +{
> > +	struct inode *inode;
> > +
> > +	if (ino < HFSPLUS_FIRSTUSER_CNID && ino !=3D HFSPLUS_ROOT_CNID)
> > +		return ERR_PTR(-ESTALE);
> > +
> > +	/* iget isn't really right if the inode is currently unallocated!!
> > +	 */
>=20
> I don't understand this comment.  This interface is only used when
> getting the FH for an already allocated inode.  hfsplus_iget is what
> all other operations use in hfsplus, so it seems fine.  hfs experts
> might chime in that something else might be needed due to the strange
> ways links work in hfs, but from the VFS POW it seems fine.

Sincerely, this is just blatantly copied over from the equivalent ext2
function.

>=20
> > +	inode =3D hfsplus_iget(sb, ino);
> > +	if (IS_ERR(inode))
> > +		return ERR_CAST(inode);
> > +	if (generation && inode->i_generation !=3D generation) {
> > +		/* we didn't find the right inode.. */
> > +		iput(inode);
> > +		return ERR_PTR(-ESTALE);
> > +	}
>=20
> hfsplus never updates i_generation, so this check is superflous.  Brad,
> Roman: is there something that can help to guard against inode number
> reuse on HFS/HFSplus?

As above, just copied over, I tried to keep the code as similar as
possible so to make it clear that it's a copy-paste.

>=20
>=20
> > +/* Yes, most of these are left as NULL!!
> > + * A NULL value implies the default, which (hopefully) works with
> > + * hfs+-like file systems, but can be improved upon.
> > + * Currently only fh_to_dentry is required.
> > + */
>=20
> You _do_ need a get_parent, otherwise access will magically fail once
> any directory inode in a path is out of the cache.  This can be
> trivially reproduced by unexporting and unmounting a filesystem while
> a client has a cwd deep inside the exported filesystem.

Okay, I think I was able to reproduce this both in "production" (as in,
making use of this in my real system) and on my testing virtual machine.
I'll get it fixed.

> And otherwise I don't think this comment is helpful in the code,
> fh_to_parent / fh_To_dentry and get_parent is what most simpler
> filesystems have.

Yes I noticed, my reason to change the comment was that the code
actually only tests fh_to_dentry (while the comment on ext2 structure
says that get_parent is the only needed one).

--=20
Diego "Flameeyes" Petten=C3=B2
http://blog.flameeyes.eu/


--=-suLzGrBLBOsiUw79e1oH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkk+fcUACgkQe2h1+2mHVWPWeACgzITbkuz3r9vu8qrHdKSUmlZa
V5gAoJsW5d3pYVaWO+3/s5D6nGHPIcPV
=irae
-----END PGP SIGNATURE-----

--=-suLzGrBLBOsiUw79e1oH--

