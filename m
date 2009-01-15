Return-Path: <linux-kernel-owner+w=401wt.eu-S932587AbZAOVw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587AbZAOVw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbZAOVvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 16:51:50 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:35637 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311AbZAOVvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 16:51:48 -0500
Message-ID: <496FAFE2.8020102@linux.vnet.ibm.com>
Date: Thu, 15 Jan 2009 15:51:30 -0600
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: hooanon05@yahoo.co.jp
CC: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net
Subject: Re: [Ecryptfs-devel] [PATCH] ecryptfs: some inode attrs, and a question
References: <7471.1231827621@jrobl> <1231852628.6954.4.camel@norville.austin.ibm.com>
In-Reply-To: <1231852628.6954.4.camel@norville.austin.ibm.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=5D35E502
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8CF21C253D448EE655EA8E07"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8CF21C253D448EE655EA8E07
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Dave Kleikamp wrote:
> cc'ing ecryptfs-devel.  mhalcrow has moved on to the dark side^W^W^W
> another company.
>=20
> Shaggy
>=20
> On Tue, 2009-01-13 at 15:20 +0900, hooanon05@yahoo.co.jp wrote:
>> Here are several fixes for linux-2.6.27/fs/ecryptfs.
>>
>> - The ecryptfs inode holds a reference to the lower inode, but doesn't=

>>   increment the reference counter. When a user sets inotify to the
>>   ecryptfs inode, it may live without the corresponding dentry. In thi=
s
>>   case the referecen to the lower inode may be broken.
>>   This patch maintains the reference of the lower inode.

Is this a problem that you've experienced or something you found during
a code review?  How can it be reproduced?  We get a reference to the
lower inode with the igrab() in ecryptfs_interpose() and put it back in
ecryptfs_clear_inode().  This part of the patch seems to just increment
the ref counts again.

>>
>> - follow the VFS unlink sequence in ecryptfs_unlink() which is
>>   inrementing and decrementing the inode->i_count and the reference
>>   counter for the dentry.

I see that do_unlinkat does this, but since eCryptfs already holds these
references, I don't think that we need to do it here.

>>
>> - maintain the link count and ctime in ecryptfs_rmdir() because a user=

>>   may issue fstat(2) later.

This part of the patch is valid, nice catch!

>>
>> - remove the unnecessary d_drop()s in ecryptfs_link().

I tend to agree that they look unnecessary, but one of them was added
for cifs (see ae56fb16) and the other two seem to be intentional (see
45ec4aba) as well.  I'm working on adding support for networked
filesystems, I'll keep these d_drop()s in mind and see if we can drop
them. :)

>>
>> And I have experienced a strange behaviour. When ecryptfs gets -ENOSPC=

>> from the lower fs, it converts and returns EINVAL to the userspace. Is=

>> this an intended behaviour?

This is a bug.  Check out ecryptfs_write_lower(), we discard the return
value of vfs_write() and return -EINVAL.  I'm betting this is the
problem, I'll get a patch out for this.  Thanks for reporting it.

>>
>>
>> J. R. Okajima
>>
>> Index: linux-2.6.27/fs/ecryptfs/inode.c
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> retrieving revision 1.1
>> retrieving revision 1.2
>> diff -u -p -r1.1 -r1.2
>> --- linux-2.6.27/fs/ecryptfs/inode.c	19 Dec 2008 03:05:27 -0000	1.1
>> +++ linux-2.6.27/fs/ecryptfs/inode.c	19 Dec 2008 19:52:26 -0000	1.2
>> @@ -430,9 +430,6 @@ out_lock:
>>  	unlock_dir(lower_dir_dentry);
>>  	dput(lower_new_dentry);
>>  	dput(lower_old_dentry);
>> -	d_drop(lower_old_dentry);
>> -	d_drop(new_dentry);
>> -	d_drop(old_dentry);
>>  	return rc;
>>  }
>>
>> @@ -444,7 +441,10 @@ static int ecryptfs_unlink(struct inode=20
>>  	struct dentry *lower_dir_dentry;
>>
>>  	lower_dir_dentry =3D lock_parent(lower_dentry);
>> +	dget(lower_dentry);
>> +	atomic_inc_return(&lower_dentry->d_inode->i_count);

atomic_inc() should probably be used here

>>  	rc =3D vfs_unlink(lower_dir_inode, lower_dentry);
>> +	dput(lower_dentry);
>>  	if (rc) {
>>  		printk(KERN_ERR "Error in vfs_unlink; rc =3D [%d]\n", rc);
>>  		goto out_unlock;
>> @@ -455,6 +455,7 @@ static int ecryptfs_unlink(struct inode=20
>>  	dentry->d_inode->i_ctime =3D dir->i_ctime;
>>  	d_drop(dentry);
>>  out_unlock:
>> +	iput(lower_dentry->d_inode);
>>  	unlock_dir(lower_dir_dentry);
>>  	return rc;
>>  }
>> @@ -538,8 +539,12 @@ static int ecryptfs_rmdir(struct inode *
>>  	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
>>  	dir->i_nlink =3D lower_dir_dentry->d_inode->i_nlink;
>>  	unlock_dir(lower_dir_dentry);
>> -	if (!rc)
>> +	if (!rc) {
>> +		struct inode *inode =3D dentry->d_inode;
>> +		inode->i_nlink =3D ecryptfs_inode_to_lower(inode)->i_nlink;
>> +		inode->i_ctime =3D dir->i_ctime;
>>  		d_drop(dentry);
>> +	}
>>  	dput(dentry);
>>  	return rc;
>>  }
>> Index: linux-2.6.27/fs/ecryptfs/super.c
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> retrieving revision 1.1
>> retrieving revision 1.2
>> diff -u -p -r1.1 -r1.2
>> --- linux-2.6.27/fs/ecryptfs/super.c	19 Dec 2008 04:37:43 -0000	1.1
>> +++ linux-2.6.27/fs/ecryptfs/super.c	19 Dec 2008 19:52:26 -0000	1.2
>> @@ -89,6 +89,7 @@ static void ecryptfs_destroy_inode(struc
>>  		}
>>  	}
>>  	mutex_unlock(&inode_info->lower_file_mutex);
>> +	iput(inode_info->wii_inode);
>>  	ecryptfs_destroy_crypt_stat(&inode_info->crypt_stat);
>>  	kmem_cache_free(ecryptfs_inode_info_cache, inode_info);
>>  }
>> @@ -101,6 +102,7 @@ static void ecryptfs_destroy_inode(struc
>>   */
>>  void ecryptfs_init_inode(struct inode *inode, struct inode *lower_ino=
de)
>>  {
>> +	atomic_inc_return(&lower_inode->i_count);
>>  	ecryptfs_set_inode_lower(inode, lower_inode);
>>  	inode->i_ino =3D lower_inode->i_ino;
>>  	inode->i_version++;



--------------enig8CF21C253D448EE655EA8E07
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAklvr+cACgkQqDCb9l015QJ9FQCfQwDq24nxpERaNWpx3oAVuP2U
NQEAn379D53sR4Q8r9RF9B3tsr4qX4Rg
=0T3e
-----END PGP SIGNATURE-----

--------------enig8CF21C253D448EE655EA8E07--
