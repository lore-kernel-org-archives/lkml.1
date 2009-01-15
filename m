Return-Path: <linux-kernel-owner+w=401wt.eu-S935431AbZAOXjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935431AbZAOXjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934254AbZAOXjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:39:22 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:46691 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933914AbZAOXjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:39:20 -0500
Message-ID: <496FC91C.10806@linux.vnet.ibm.com>
Date: Thu, 15 Jan 2009 17:39:08 -0600
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: hooanon05@yahoo.co.jp, linux-fsdevel@vger.kernel.org,
       ecryptfs-devel@lists.launchpad.net, linux-kernel@vger.kernel.org,
       mhalcrow@us.ibm.com
Subject: Re: [Ecryptfs-devel] [PATCH] ecryptfs: some inode attrs, and a question
References: <7471.1231827621@jrobl> <20090115150332.f72ad0f8.akpm@linux-foundation.org>
In-Reply-To: <20090115150332.f72ad0f8.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
OpenPGP: id=5D35E502
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig667C64A7FCAC845DBCD1AA8D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig667C64A7FCAC845DBCD1AA8D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Andrew Morton wrote:
> On Tue, 13 Jan 2009 15:20:21 +0900
> hooanon05@yahoo.co.jp wrote:
>=20
>> Here are several fixes for linux-2.6.27/fs/ecryptfs.
>>
>> - The ecryptfs inode holds a reference to the lower inode, but doesn't=

>>   increment the reference counter. When a user sets inotify to the
>>   ecryptfs inode, it may live without the corresponding dentry. In thi=
s
>>   case the referecen to the lower inode may be broken.
>>   This patch maintains the reference of the lower inode.
>>
>> - follow the VFS unlink sequence in ecryptfs_unlink() which is
>>   inrementing and decrementing the inode->i_count and the reference
>>   counter for the dentry.
>>
>> - maintain the link count and ctime in ecryptfs_rmdir() because a user=

>>   may issue fstat(2) later.
>>
>> - remove the unnecessary d_drop()s in ecryptfs_link().
>>
>> And I have experienced a strange behaviour. When ecryptfs gets -ENOSPC=

>> from the lower fs, it converts and returns EINVAL to the userspace. Is=

>> this an intended behaviour?
>>
>=20
> I am puzzled by the current ecryptfs maintenance situation.
>=20

http://article.gmane.org/gmane.linux.kernel/768122

The torch has been passed to me.  :)

> I queued this for 2.6.30.  It could be bumped up for 2.6.29 (and even
> backported to 2.6.28 and earlier) with suitable acks from the
> maintainer(?)
>=20

The changes to ecryptfs_rmdir() are valid, but not the rest of the patch.=


>> ...
>>
>> +	atomic_inc_return(&lower_dentry->d_inode->i_count);
>> +	atomic_inc_return(&lower_inode->i_count);
>=20
> atomic_inc() would suffice here, yes?
>=20
> From: Andrew Morton <akpm@linux-foundation.org>
>=20
> s/atomic_inc_return/atomic_inc/
>=20
> Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> Cc: J. R. Okajima <hooanon05@yahoo.co.jp>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  fs/ecryptfs/inode.c |    2 +-
>  fs/ecryptfs/super.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff -puN fs/ecryptfs/inode.c~ecryptfs-some-inode-attr-fixes-fix fs/ecr=
yptfs/inode.c
> --- a/fs/ecryptfs/inode.c~ecryptfs-some-inode-attr-fixes-fix
> +++ a/fs/ecryptfs/inode.c
> @@ -479,7 +479,7 @@ static int ecryptfs_unlink(struct inode=20
>=20
>  	lower_dir_dentry =3D lock_parent(lower_dentry);
>  	dget(lower_dentry);
> -	atomic_inc_return(&lower_dentry->d_inode->i_count);
> +	atomic_inc(&lower_dentry->d_inode->i_count);
>  	rc =3D vfs_unlink(lower_dir_inode, lower_dentry);
>  	dput(lower_dentry);
>  	if (rc) {
> diff -puN fs/ecryptfs/super.c~ecryptfs-some-inode-attr-fixes-fix fs/ecr=
yptfs/super.c
> --- a/fs/ecryptfs/super.c~ecryptfs-some-inode-attr-fixes-fix
> +++ a/fs/ecryptfs/super.c
> @@ -102,7 +102,7 @@ static void ecryptfs_destroy_inode(struc
>   */
>  void ecryptfs_init_inode(struct inode *inode, struct inode *lower_inod=
e)
>  {
> -	atomic_inc_return(&lower_inode->i_count);
> +	atomic_inc(&lower_inode->i_count);
>  	ecryptfs_set_inode_lower(inode, lower_inode);
>  	inode->i_ino =3D lower_inode->i_ino;
>  	inode->i_version++;
> _
>=20
>=20
> _______________________________________________
> Mailing list: https://launchpad.net/~ecryptfs-devel
> Post to     : ecryptfs-devel@lists.launchpad.net
> Unsubscribe : https://launchpad.net/~ecryptfs-devel
> More help   : https://help.launchpad.net/ListHelp



--------------enig667C64A7FCAC845DBCD1AA8D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAklvyR8ACgkQqDCb9l015QL+dQCaA0lPf3c1UNYzs7JulqzaEwPZ
0bsAnipoxOBKPAH59fv7hpvqLOJQE8XD
=T6Df
-----END PGP SIGNATURE-----

--------------enig667C64A7FCAC845DBCD1AA8D--
