Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab0CEKCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 05:02:42 -0500
Received: from mail.SerNet.de ([193.175.80.2]:46384 "EHLO mail.SerNet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab0CEKCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 05:02:39 -0500
X-Greylist: delayed 898 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Mar 2010 05:02:38 EST
Date: Fri, 5 Mar 2010 10:47:37 +0100
From: Michael Adam <obnox@samba.org>
To: Jeff Layton <jlayton@samba.org>
Cc: Jon Severinsson <jon@severinsson.net>, linux-cifs-client@lists.samba.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       obnox@samba.org
Subject: Re: [linux-cifs-client] [RFC PATCH] CIFS posix acl permission checking
References: <201003041150.08341.jon@severinsson.net> <20100304111812.6af53003@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vJwpkiw3F9XLBeML"
Content-Disposition: inline
In-Reply-To: <20100304111812.6af53003@barsoom.rdu.redhat.com>
User-Agent: Mutt/1.5.9i
Message-Id: <E1NnU8A-00HEea-5z@intern.SerNet.DE>
Organization: SerNet GmbH, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vJwpkiw3F9XLBeML
Content-Type: multipart/mixed; boundary="eSuk7cb4xGx9LvKi"
Content-Disposition: inline


--eSuk7cb4xGx9LvKi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

yes, the coincidence is really funny!

I have been working on a similar patch, which I attach just for
reference. It is just in a proof-of-concept stage with some
printk calls for my personal debugging, and the code is not yet
conditional.

The main difference is that I used the CIFSSMBGetPosixACL call
instead of handcrafting the reading of the xtended attribute.

I have been chatting extensively chatting with Jeff about the
implementation of multi session/user mounts, which is definitely
the way to go but much more coding work.

I also noticed the problem of file ownership, which should
in principle be solvabel by useing the "setuids" mount option,
but this seemd to have no effect in my test setup with uml
linux running from a 2.6.32 git checkout.

Cheers - Michael

Jeff Layton wrote:
> On Thu, 4 Mar 2010 11:50:04 +0100
> Jon Severinsson <jon@severinsson.net> wrote:
>=20
> > Hello
> >=20
> > Early this weak I sent a patch implementing posix acl permission checki=
ng in=20
> > the linux cifs filesystem module. Unfortunately I only sent it to linux=
-fsdev=20
> > as I was unaware of the linux-cifs-client list. I later tried to submit=
 it to=20
> > linux-cifs-client as well, but my message seems to have been lost in th=
e=20
> > moderation queue, so I subscribed and am trying again.
> >=20
> > I don't believe my patch is perfect, but I think it's a good start, and=
 would=20
> > like some comments from more experienced cifs developers to be able to =
get it=20
> > into shape for inclusion in the kernel.=20
> >=20
> > I did get some comments from Matthew Wilcox at linux-fsdev, but unfortu=
nately=20
> > he never followed up on my response, so I'm including some unresolved=
=20
> > questions I still have, as well as attaching the patch for further comm=
ents.
> >=20
> > Best Regards
> > Jon Severinsson
> >
>=20
> (cc'ing Michael Adam since he's been working on a similar patch)
>=20
> I've looked over the patch and it's pretty good for a first attempt.
> There are a few minor problems with it, but it's a reasonable first
> pass.
>=20
> The issues I have are with the approach -- you've stepped into a bit of
> a minefield with regards to CIFS' design. The issues that Simo brings up
> however are quite valid. Let me just state outright that permission
> checking on the client is a completely bogus concept. There are a
> couple of problems with this approach:
>=20
> 1) Someone could change the permissions on the server between the time
> you check them and when you do your operation. Yes, I know that CIFS
> already does this for permission bits, but that's dumb too.
>=20
> 2) Ownership matters. This patch will have no effect on how files get
> created. They still get created with the owner set to the user who's
> credentials were used, and you can't change them afterward (since users
> can't "chown" files to other users). Now, it is possible to mount a
> samba server with root's credentials. Then you can use the "setuids"
> mount option to make chown's work and you *might* get files created the
> way you intend. I really, really do not recommend this though -- it's a
> bad idea to allow any user to share root's server credentials.
>=20
> I'm convinced, after working on it for more than 3 years that the *only*
> proper fix for the nightmare that is CIFS permissions is to make CIFS
> use proper credentials in the first place. CIFS is currently completely
> broken in this regard -- it's designed such that all accesses to the
> mount use the same set of credentials, and that's just plain wrong.
>=20
> Fixing this entails establishing new SMB sessions on the fly whenever a
> user wants to do an on the wire operation. Obviously, we can't prompt
> for passwords for this, so we need to limit this to krb5 creds or come
> up with a way for people to stash credentials for the kernel to use for
> this purpose. I'm about 1/3 of the way into a first draft of a patchset
> to do this, but it won't be fixed anytime soon and may not be suitable
> for CIFS with SMB2 getting development focus now.
>=20
> Now, all of that said...I don't have a specific issue with adding a
> patch to do this. I think this approach is completely ass-backwards and
> broken, but we do already attempt to enforce permission bits on the
> client currently. Adding checks for POSIX acl's don't make this (much)
> worse.
>=20
> The one thing I don't think we want though is to turn this on by
> default since it means an extra round trip to the server every time
> you want to check permissions. This needs to be "switchable" somehow --
> possibly via mount option (maybe -o checkposixacls or something?)
>=20
> > commit fa0b9415cda17b31966542101bc4ceb0c97c87cb
> > Author: Jon Severinsson <jon@severinsson.net>
> > Date:   Mon Mar 1 19:24:30 2010 +0100
> >=20
> >     [CIFS] Adds support for permision checking vs. posix acl.
> >    =20
> >     CIFS already supports getting and setting acls through getfacl and =
setfacl, but
> >     prior to this patch, any acls was ignored when doing permission che=
cking.
> >=20
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index 29f1da7..0605e11 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -284,7 +284,7 @@ static int cifs_permission(struct inode *inode, int=
 mask)
> >  		on the client (above and beyond ACL on servers) for
> >  		servers which do not support setting and viewing mode bits,
> >  		so allowing client to check permissions is useful */
> > -		return generic_permission(inode, mask, NULL);
> > +		return generic_permission(inode, mask, inode->i_op->check_acl);
> >  }
> > =20
> >  static struct kmem_cache *cifs_inode_cachep;
> > @@ -702,6 +702,9 @@ const struct inode_operations cifs_dir_inode_ops =
=3D {
> >  	.getxattr =3D cifs_getxattr,
> >  	.listxattr =3D cifs_listxattr,
> >  	.removexattr =3D cifs_removexattr,
> > +#ifdef CONFIG_CIFS_POSIX
> > +	.check_acl =3D cifs_check_acl,
> > +#endif
> >  #endif
> >  };
> > =20
> > @@ -716,6 +719,9 @@ const struct inode_operations cifs_file_inode_ops =
=3D {
> >  	.getxattr =3D cifs_getxattr,
> >  	.listxattr =3D cifs_listxattr,
> >  	.removexattr =3D cifs_removexattr,
> > +#ifdef CONFIG_CIFS_POSIX
> > +	.check_acl =3D cifs_check_acl,
> > +#endif
> >  #endif
> >  };
> > =20
> > @@ -732,6 +738,9 @@ const struct inode_operations cifs_symlink_inode_op=
s =3D {
> >  	.getxattr =3D cifs_getxattr,
> >  	.listxattr =3D cifs_listxattr,
> >  	.removexattr =3D cifs_removexattr,
> > +#ifdef CONFIG_CIFS_POSIX
> > +	.check_acl =3D cifs_check_acl,
> > +#endif
> >  #endif
> >  };
> > =20
> > diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> > index ac2b24c..6409a83 100644
> > --- a/fs/cifs/cifsfs.h
> > +++ b/fs/cifs/cifsfs.h
> > @@ -102,11 +102,15 @@ extern int cifs_readlink(struct dentry *direntry,=
 char __user *buffer,
> >  			 int buflen);
> >  extern int cifs_symlink(struct inode *inode, struct dentry *direntry,
> >  			const char *symname);
> > +
> > +/* Functions related to extended attributes */
> >  extern int	cifs_removexattr(struct dentry *, const char *);
> >  extern int 	cifs_setxattr(struct dentry *, const char *, const void *,
> >  			size_t, int);
> >  extern ssize_t	cifs_getxattr(struct dentry *, const char *, void *, si=
ze_t);
> >  extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t);
> > +extern int cifs_check_acl(struct inode *inode, int mask);
> > +
> >  extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned =
long arg);
> > =20
> >  #ifdef CONFIG_CIFS_EXPERIMENTAL
> > diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
> > index a75afa3..a07633b 100644
> > --- a/fs/cifs/xattr.c
> > +++ b/fs/cifs/xattr.c
> > @@ -374,3 +374,71 @@ ssize_t cifs_listxattr(struct dentry *direntry, ch=
ar *data, size_t buf_size)
> >  #endif
> >  	return rc;
> >  }
> > +
> > +int cifs_check_acl(struct inode *inode, int mask)
> > +{
> > +	int rc =3D -EOPNOTSUPP;
> > +#ifdef CONFIG_CIFS_XATTR
> > +#ifdef CONFIG_CIFS_POSIX
> > +	struct dentry *dentry;
> > +	size_t buf_size;
> > +	void *ea_value =3D NULL;
> > +	ssize_t ea_size;
> > +	struct posix_acl *acl =3D NULL;
> > +
> > +	/* CIFS gets acl from server by path, and thus needs a dentry rather =
than
> > +	   an inode. Note that the path of each dentry will point to the same=
 inode
> > +	   on the backing fs at the server, so their acls will be the same, a=
nd it
> > +	   doesn't matter which one we pick, so just pick the fist. */
>=20
> ^^^ comments should follow kernel coding styles. Be sure to run your
> patch through scripts/checkpatch.pl too.
>=20
> > +	if (!list_empty(&inode->i_dentry))
> > +		dentry =3D list_first_entry(&inode->i_dentry, struct dentry, d_alias=
);
>=20
> 		^^^^ you should probably dget this dentry to take a
> 		reference to it and then put it when you're finished
> 		with it. It could vanish out of the cache before you
> 		have a chance to use it otherwise.
>=20
> > +	else
> > +		return -EINVAL;
> > +
> > +	/* Try to fit the extended attribute corresponding to the posix acl i=
n 4k
> > +	   memory. 4k was chosen because it always fits in a single page, and=
 is
> > +	   the maximum on a default ext2/3/4 backing fs. */
> > +	buf_size =3D 4096;
> > +	ea_value =3D kmalloc(buf_size, GFP_KERNEL);
> > +	if (!ea_value) {
> > +		rc =3D -EAGAIN;
> > +		goto check_acl_exit;
> > +	}
> > +	ea_size =3D cifs_getxattr(dentry, POSIX_ACL_XATTR_ACCESS, ea_value, b=
uf_size);
> > +
> > +	/* If 4k wasn't enough, try 64k, the maximum on any current backing f=
s. */
> > +	if (ea_size =3D=3D -ERANGE) {
> > +		kfree(ea_value);
> > +		buf_size =3D 65536;
> > +		ea_value =3D kmalloc(buf_size, GFP_KERNEL);
> > +		if (!ea_value) {
> > +			rc =3D -EAGAIN;
> > +			goto check_acl_exit;
> > +		}
> > +		ea_size =3D cifs_getxattr(dentry, POSIX_ACL_XATTR_ACCESS, ea_value, =
buf_size);
> > +	}
> > +
> > +	/* If we didn't get any extended attribute, set the error code and ex=
it */
> > +	if (ea_size <=3D 0) {
> > +		rc =3D -EAGAIN;
> > +		if (ea_size =3D=3D -EOPNOTSUPP || ea_size =3D=3D -EIO || ea_size =3D=
=3D -ENOTDIR || ea_size =3D=3D -ENOENT || ea_size =3D=3D -EFAULT || ea_size=
 =3D=3D -EACCES)
> > +			rc =3D ea_size;
> > +		goto check_acl_exit;
> > +	}
> > +
> > +	/* Set the appropriate return value. Adapted from ext4. */
> > +	acl =3D posix_acl_from_xattr(ea_value, ea_size);
> > +	if (IS_ERR(acl))
> > +		rc =3D PTR_ERR(acl);
> > +	else if (acl)
> > +		rc =3D posix_acl_permission(inode, acl, mask);
> > +	else
> > +		rc =3D -EAGAIN;
> > +
> > +check_acl_exit:
> > +	posix_acl_release(acl);
> > +	kfree(ea_value);
> > +#endif /* CONFIG_CIFS_POSIX */
> > +#endif /* CONFIG_CIFS_XATTR */
> > +	return rc;
> > +}
>=20
> The rest of the patch looks reasonable but I agree with Simo that all
> of our time would be better spent working to make CIFS use proper
> credentials on the wire.
>=20
> --=20
> Jeff Layton <jlayton@samba.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--eSuk7cb4xGx9LvKi
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-cifs-prototype-implementation-of-client-side-posix-a.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 159de5f89c010dd2fe082d8b8109e5e3c8633462 Mon Sep 17 00:00:00 2001
=46rom: Michael Adam <obnox@samba.org>
Date: Thu, 25 Feb 2010 17:06:03 +0100
Subject: [PATCH] cifs: prototype implementation of client-side posix acl ch=
ecks.

---
 fs/cifs/cifsfs.c |  114 ++++++++++++++++++++++++++++++++++++++++++++++++++=
+++-
 1 files changed, 113 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 29f1da7..cb31ecd 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -47,6 +47,8 @@
 #include <linux/key-type.h>
 #include "dns_resolve.h"
 #include "cifs_spnego.h"
+#include <linux/posix_acl.h>
+#include <linux/posix_acl_xattr.h>
 #define CIFS_MAGIC_NUMBER 0xFF534D42	/* the first four bytes of SMB PDUs */
=20
 #ifdef CONFIG_CIFS_QUOTA
@@ -269,6 +271,116 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *bu=
f)
 	return 0;
 }
=20
+static int cifs_check_acl(struct inode *inode, int mask)
+{
+	ssize_t rc =3D -EOPNOTSUPP;
+	struct cifs_sb_info *cifs_sb;
+	struct super_block *sb;
+	struct cifsTconInfo *pTcon;
+	int xid;
+	char *full_path;
+	void *ea_value =3D NULL;
+	size_t buf_size =3D 0;
+	struct dentry *dentry;
+	struct posix_acl *acl;
+
+printk(KERN_NOTICE "cifs_check_acl: entering\n");
+
+	sb =3D inode->i_sb;
+	if (sb =3D=3D NULL) {
+		return -EIO;
+	}
+
+	cifs_sb =3D CIFS_SB(sb);
+	pTcon =3D cifs_sb->tcon;
+
+	xid =3D GetXid();
+
+	if (inode->i_dentry.next =3D=3D NULL) {
+		/* no dentry found - deny access */
+		FreeXid(xid);
+		return -EACCES;
+	}
+
+	dentry =3D list_first_entry(&(inode->i_dentry), struct dentry, d_alias);
+	if (dentry =3D=3D NULL) {
+		FreeXid(xid);
+		return -EACCES;
+	}
+
+printk(KERN_NOTICE "cifs_check_acl: got first dentry\n");
+
+	full_path =3D build_path_from_dentry(dentry);
+	if (full_path =3D=3D NULL) {
+		rc =3D -ENOMEM;
+		FreeXid(xid);
+		return rc;
+	}
+
+printk(KERN_NOTICE "cifs_check_acl: got path '%s'\n", full_path);
+
+	if (!(sb->s_flags & MS_POSIXACL)) {
+		rc =3D -EOPNOTSUPP;
+		goto out;
+	}
+
+	ea_value =3D kmalloc(4096, GFP_KERNEL);
+	if (ea_value =3D=3D NULL) {
+		rc =3D -ENOMEM;
+		goto out;
+	}
+	buf_size =3D (size_t)4096;
+
+printk(KERN_NOTICE "cifs_check_acl: allocated ea buffer (4096)\n");
+
+	rc =3D CIFSSMBGetPosixACL(xid, pTcon, full_path, ea_value,
+			buf_size, ACL_TYPE_ACCESS,
+			cifs_sb->local_nls,
+			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+	if (rc =3D=3D -1) {
+printk(KERN_NOTICE "cifs_check_acl: error calling CIFSSMBGetPosixACL\n");
+		goto out;
+	}
+
+printk(KERN_NOTICE "cifs_check_ack: CIFSSMBGetPosixACL returned %d\n", rc);
+
+	acl =3D posix_acl_from_xattr(ea_value, rc);
+
+	if (acl =3D=3D NULL) {
+printk(KERN_NOTICE "cifs_check_acl: error converting acl from ea buffer: N=
ULL ACL\n");
+		rc =3D -EAGAIN;
+		goto out;
+	}
+
+	if (IS_ERR(acl)) {
+printk(KERN_NOTICE "cifs_check_acl: error converting acl from ea buffer: I=
S_ERR(acl): %d\n", -PTR_ERR(acl));
+		rc =3D PTR_ERR(acl);
+		goto out;
+	}
+
+	rc =3D posix_acl_valid(acl);
+	if (rc !=3D 0) {
+printk(KERN_NOTICE "cifs_check_acl: acl is invalid\n");
+		goto out;
+	}
+
+	rc =3D posix_acl_permission(inode, acl, mask);
+	posix_acl_release(acl);
+
+printk(KERN_NOTICE "cifs_check_acl: posix_acl_permission check gave: %d\n"=
, rc);
+
+out:
+	kfree(full_path);
+	FreeXid(xid);
+	if (ea_value !=3D NULL) {
+		kfree(ea_value);
+	}
+
+printk(KERN_NOTICE "cifs_check_acl: done, returning %d\n", rc);
+
+	return rc;
+}
+
 static int cifs_permission(struct inode *inode, int mask)
 {
 	struct cifs_sb_info *cifs_sb;
@@ -284,7 +396,7 @@ static int cifs_permission(struct inode *inode, int mas=
k)
 		on the client (above and beyond ACL on servers) for
 		servers which do not support setting and viewing mode bits,
 		so allowing client to check permissions is useful */
-		return generic_permission(inode, mask, NULL);
+		return generic_permission(inode, mask, cifs_check_acl);
 }
=20
 static struct kmem_cache *cifs_inode_cachep;
--=20
1.6.3.3


--eSuk7cb4xGx9LvKi--

--vJwpkiw3F9XLBeML
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: comment

iD8DBQFLkNM5yU9JOBhPkDQRAuKaAJ4nRewPgcsFCtU8pSoWq04QhvPFJgCgnGmm
szdSEaWzrBG6i2jX9WIeKf4=
=Nn0o
-----END PGP SIGNATURE-----

--vJwpkiw3F9XLBeML--
