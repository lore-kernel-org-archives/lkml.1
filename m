Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab0CAQi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:38:27 -0500
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:42497 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab0CAQi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:38:26 -0500
X-SMTPAUTH-B2: 
X-SENDER-IP: 83.227.31.74
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ais6AKdmi0tT4x9KPGdsb2JhbACDBIRVkzUMAQEBATctqwyPPIQRagQ
X-IronPort-AV: E=Sophos;i="4.49,560,1262559600"; 
   d="asc'?scan'208";a="44127523"
From: Jon Severinsson <jon@severinsson.net>
To: linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH] CIFS posix acl permission checking
Date: Mon, 1 Mar 2010 16:15:10 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32-gentoo-r6; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
X-Length: 7585
Content-Type: multipart/signed;
  boundary="nextPart1622648.3oyFPvTCCd";
  protocol="application/pgp-signature";
  micalg=pgp-sha512
Content-Transfer-Encoding: 7bit
Message-Id: <201003011615.49121.jon@severinsson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1622648.3oyFPvTCCd
Content-Type: multipart/mixed;
  boundary="Boundary-01=_Co9iLvrI9pEFGRx"
Content-Transfer-Encoding: 7bit


--Boundary-01=_Co9iLvrI9pEFGRx
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello everyone

=46irstly, please note that I'm new to the kernel community, so if I'm doin=
g=20
something wrong, just please politely point it out to me and I'll try to fi=
x=20
it, or at the very least not do it again. Also please bear in mind that=20
English isn't my native language.

Anyway, I recently realised that while the CIFS file system driver in Linux=
=20
does supports posix acl retrieval and modification using the getfacl and=20
setfacl command line tools, it does not use acl for client side permission=
=20
checking. On the server side Samba does consult the acl, but that doesn't=20
really help when cifs.ko never even asks the server, due to the users only=
=20
source of permission being from an acl.

I'm attaching a first attempt at implementing it. I have tested it, but onl=
y on=20
a single setup, so I can give no guarantees to its portability. Also please=
=20
note that this is my first kernel patch, so if I'm doing something wrong, s=
uch=20
as not following some coding standard, please enlighten me and I'll gladly =
fix=20
it.

I only subscribed to the linux-fsdevel list, so please include it in any=20
response you might send.

Best Regards
Jon Severinsson

--Boundary-01=_Co9iLvrI9pEFGRx
Content-Type: text/x-patch;
  charset="UTF-8";
  name="cifs-acl-permission-check-v1.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="cifs-acl-permission-check-v1.patch"

commit fab1872fcbb8a5cdb85d7e7a88ecf0cad99d1c80
Author: Jon Severinsson <jon@severinsson.net>
Date:   Mon Mar 1 15:49:40 2010 +0100

    [CIFS] Adds support for permision checking vs. posix acl.
   =20
    CIFS already supports getting and setting acls through getfacl and setf=
acl, but
    prior to this patch, any acls was ignored when doing permission checkin=
g.

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 29f1da7..0605e11 100644
=2D-- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -284,7 +284,7 @@ static int cifs_permission(struct inode *inode, int mas=
k)
 		on the client (above and beyond ACL on servers) for
 		servers which do not support setting and viewing mode bits,
 		so allowing client to check permissions is useful */
=2D		return generic_permission(inode, mask, NULL);
+		return generic_permission(inode, mask, inode->i_op->check_acl);
 }
=20
 static struct kmem_cache *cifs_inode_cachep;
@@ -702,6 +702,9 @@ const struct inode_operations cifs_dir_inode_ops =3D {
 	.getxattr =3D cifs_getxattr,
 	.listxattr =3D cifs_listxattr,
 	.removexattr =3D cifs_removexattr,
+#ifdef CONFIG_CIFS_POSIX
+	.check_acl =3D cifs_check_acl,
+#endif
 #endif
 };
=20
@@ -716,6 +719,9 @@ const struct inode_operations cifs_file_inode_ops =3D {
 	.getxattr =3D cifs_getxattr,
 	.listxattr =3D cifs_listxattr,
 	.removexattr =3D cifs_removexattr,
+#ifdef CONFIG_CIFS_POSIX
+	.check_acl =3D cifs_check_acl,
+#endif
 #endif
 };
=20
@@ -732,6 +738,9 @@ const struct inode_operations cifs_symlink_inode_ops =
=3D {
 	.getxattr =3D cifs_getxattr,
 	.listxattr =3D cifs_listxattr,
 	.removexattr =3D cifs_removexattr,
+#ifdef CONFIG_CIFS_POSIX
+	.check_acl =3D cifs_check_acl,
+#endif
 #endif
 };
=20
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index ac2b24c..6409a83 100644
=2D-- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -102,11 +102,15 @@ extern int cifs_readlink(struct dentry *direntry, cha=
r __user *buffer,
 			 int buflen);
 extern int cifs_symlink(struct inode *inode, struct dentry *direntry,
 			const char *symname);
+
+/* Functions related to extended attributes */
 extern int	cifs_removexattr(struct dentry *, const char *);
 extern int 	cifs_setxattr(struct dentry *, const char *, const void *,
 			size_t, int);
 extern ssize_t	cifs_getxattr(struct dentry *, const char *, void *, size_t=
);
 extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t);
+extern int cifs_check_acl(struct inode *inode, int mask);
+
 extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long=
 arg);
=20
 #ifdef CONFIG_CIFS_EXPERIMENTAL
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index a75afa3..a851ba1 100644
=2D-- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -374,3 +374,74 @@ ssize_t cifs_listxattr(struct dentry *direntry, char *=
data, size_t buf_size)
 #endif
 	return rc;
 }
+
+int cifs_check_acl(struct inode *inode, int mask)
+{
+	int rc =3D -EOPNOTSUPP;
+#ifdef CONFIG_CIFS_XATTR
+#ifdef CONFIG_CIFS_POSIX
+	struct dentry *dentry =3D NULL;
+	size_t buf_size;
+	void *ea_value =3D NULL;
+	ssize_t ea_size;
+	struct posix_acl *acl =3D NULL;
+
+	/* CIFS gets acl from server by path, and thus needs a dentry rather than
+	   an inode. Note that the path of each dentry will point to the same ino=
de
+	   on the backing fs at the server, so their acls will be the same, and it
+	   doesn't matter which one we pick, so just pick the fist. */
+	if (list_empty(&inode->i_dentry))
+		dentry =3D list_first_entry(&inode->i_dentry, struct dentry, d_alias);
+
+	/* If we didn't get an dentry for the inode, something went terribly wron=
g.
+	   All we can do at this point is to return an error. */
+	if (!dentry || IS_ERR(dentry))=20
+		return PTR_ERR(dentry);
+
+	/* Try to fit the extended attribute corresponding to the posix acl in 4k
+	   memory. 4k was chosen because it always fits in a single page, and is
+	   the maximum on a default ext2/3/4 backing fs. */
+	buf_size =3D 4096;
+	ea_value =3D kmalloc(buf_size, GFP_KERNEL);
+	if (!ea_value) {
+		rc =3D -EAGAIN;
+		goto check_acl_exit;
+	}
+	ea_size =3D cifs_getxattr(dentry, POSIX_ACL_XATTR_ACCESS, ea_value, buf_s=
ize);
+
+	/* If 4k wasn't enough, try 64k, the maximum on any current backing fs. */
+	if (ea_size =3D=3D -ERANGE) {
+		kfree(ea_value);
+		buf_size =3D 65536;
+		ea_value =3D kmalloc(buf_size, GFP_KERNEL);
+		if (!ea_value) {
+			rc =3D -EAGAIN;
+			goto check_acl_exit;
+		}
+		ea_size =3D cifs_getxattr(dentry, POSIX_ACL_XATTR_ACCESS, ea_value, buf_=
size);
+	}
+
+	/* If we didn't get any extended attribute, set the error code and exit */
+	if (ea_size <=3D 0) {
+		rc =3D -EAGAIN;
+		if (ea_size =3D=3D -EOPNOTSUPP || ea_size =3D=3D -EIO || ea_size =3D=3D =
=2DENOTDIR || ea_size =3D=3D -ENOENT || ea_size =3D=3D -EFAULT || ea_size =
=3D=3D -EACCES)
+			rc =3D ea_size;
+		goto check_acl_exit;
+	}
+
+	/* Set the appropriate return value. Adapted from ext4. */
+	acl =3D posix_acl_from_xattr(ea_value, ea_size);
+	if (IS_ERR(acl))
+		rc =3D PTR_ERR(acl);
+	else if (acl)
+		rc =3D posix_acl_permission(inode, acl, mask);
+	else
+		rc =3D -EAGAIN;
+
+check_acl_exit:
+	posix_acl_release(acl);
+	kfree(ea_value);
+#endif /* CONFIG_CIFS_POSIX */
+#endif /* CONFIG_CIFS_XATTR */
+	return rc;
+}

--Boundary-01=_Co9iLvrI9pEFGRx--

--nextPart1622648.3oyFPvTCCd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iQIcBAABCgAGBQJLi9olAAoJEIxPDyvAFXjJ0N8P/jDg0+N/W+NJ5msbk10Su/Yk
mS634USbW6x08d1kMccz/suLQE8C41nrA7ds+oFsAma7m69syCkhnRP8Vid75aXd
2xnUD30sZuICUx95vIakTSCXB7ce98wff00CZTyiHNQ2q7jgZodOFFS/889sOpbe
F9LrJCXjy7yUoHZpTvhtgB+tGkr/9nAJvIIMJvc1cG750Oy54muLAuDZGizyuwM2
yUL4lxiYbtajpH2KduF3SFIn6pAlXSh1Ui/xCKTe2+mIYPKtgiLcA7KDadtk1y4B
gX3j8YSc92JYX/cl6jKV+wKkNxLh3FC+EdSj4mXvXq3Y1OWTAvOzFZZwMp+vZBHD
ykLJw9eL+l21rxq11a7WwQmdQbr35LwZc12U3cfmzeTvXABgNViiMwhxyI9Dm4kt
4AfF9JFsk7A4krmEZIxbkiXN0QZgB5h68Qv/sao+CYRzEM8YOHAsuHU+qkvqyaR+
8MURnMlEC91SAKHtm46KN+Z0Sq0b/Z44ClFPtafXoQYBvRUDNxj7VmQJQQmuNAHA
AODid4g7eVJ8pQ1v0j1djf6/6muzmrExyKxu0ACXpqLyqmGOgiOuRZx5ltLC6EGU
K1NaqPKuNAKyeAhoSD4YgYSFcprs1u9WflugovB1RnRhq2DrOWOla33hGxp4VRhK
/Qj3jZjSm8/0VpmBMeCk
=pOnd
-----END PGP SIGNATURE-----

--nextPart1622648.3oyFPvTCCd--
