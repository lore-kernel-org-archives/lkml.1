Return-Path: <linux-kernel-owner+w=401wt.eu-S1757731AbYFPSJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731AbYFPSJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 14:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbYFPSJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 14:09:14 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:48400 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbYFPSJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 14:09:13 -0400
Date: Mon, 16 Jun 2008 20:09:11 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [PATCH][BUGFIX] configfs: Fix symlink() to a removing item
Message-ID: <20080616180911.GV30804@localhost>
Reply-To: Louis.Rilling@kerlabs.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-18240-1213639663-0001-2"
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-18240-1213639663-0001-2
Content-Type: multipart/mixed; boundary="ahZICQ7iXVM/oLYH"
Content-Disposition: inline


--ahZICQ7iXVM/oLYH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi, the following patch fixes the symlink bug I mentioned a few days ago.
Thanks for your comments.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--ahZICQ7iXVM/oLYH
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="configfs-do-not-symlink-to-removing-item.patch"
Content-Transfer-Encoding: quoted-printable

configfs: Fix symlink() to a removing item

[Applies on top of rename() vs rmdir() deadlock fix patchset]

The rule for configfs symlinks is that symlinks always point to valid
config_items, and prevent the target from being removed. However,
configfs_symlink() only checks that it can grab a reference on the target i=
tem,
without ensuring that it remains alive until the symlink is correctly attac=
hed.

This patch makes configfs_symlink() fail whenever the target is being remov=
ed,
using the CONFIGFS_USET_DROPPING flag set by configfs_detach_prep() and
protected by configfs_dirent_lock.

This patch introduces a similar (weird?) behavior as with mkdir failures ma=
king
rmdir fail: if symlink() races with rmdir() of the parent directory (or its
youngest user-created ancestor if parent is a default group) or rmdir() of =
the
target directory, and then fails in configfs_create(), this can make the ra=
cing
rmdir() fail despite the concerned directory having no user-created entry (=
resp.
no symlink pointing to it or one of its default groups) in the end.
If this behavior is found unacceptable, I'll submit a fix in the same spiri=
t as
the racing mkdir() fix.

Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
---
 fs/configfs/dir.c     |   14 +++++++-------
 fs/configfs/symlink.c |    6 ++++++
 2 files changed, 13 insertions(+), 7 deletions(-)

Index: b/fs/configfs/dir.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/fs/configfs/dir.c	2008-06-16 19:35:57.000000000 +0200
+++ b/fs/configfs/dir.c	2008-06-16 19:38:47.000000000 +0200
@@ -370,6 +370,9 @@ static int configfs_detach_prep(struct d
 	struct configfs_dirent *sd;
 	int ret;
=20
+	/* Mark that we're trying to drop the group */
+	parent_sd->s_type |=3D CONFIGFS_USET_DROPPING;
+
 	ret =3D -EBUSY;
 	if (!list_empty(&parent_sd->s_links))
 		goto out;
@@ -385,8 +388,6 @@ static int configfs_detach_prep(struct d
 					*wait_mutex =3D &sd->s_dentry->d_inode->i_mutex;
 				return -EAGAIN;
 			}
-			/* Mark that we're trying to drop the group */
-			sd->s_type |=3D CONFIGFS_USET_DROPPING;
=20
 			/*
 			 * Yup, recursive.  If there's a problem, blame
@@ -414,12 +415,11 @@ static void configfs_detach_rollback(str
 	struct configfs_dirent *parent_sd =3D dentry->d_fsdata;
 	struct configfs_dirent *sd;
=20
-	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
-		if (sd->s_type & CONFIGFS_USET_DEFAULT) {
+	parent_sd->s_type &=3D ~CONFIGFS_USET_DROPPING;
+
+	list_for_each_entry(sd, &parent_sd->s_children, s_sibling)
+		if (sd->s_type & CONFIGFS_USET_DEFAULT)
 			configfs_detach_rollback(sd->s_dentry);
-			sd->s_type &=3D ~CONFIGFS_USET_DROPPING;
-		}
-	}
 }
=20
 static void detach_attrs(struct config_item * item)
Index: b/fs/configfs/symlink.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/fs/configfs/symlink.c	2008-06-16 19:43:34.000000000 +0200
+++ b/fs/configfs/symlink.c	2008-06-16 19:47:06.000000000 +0200
@@ -78,6 +78,12 @@ static int create_link(struct config_ite
 	if (sl) {
 		sl->sl_target =3D config_item_get(item);
 		spin_lock(&configfs_dirent_lock);
+		if (target_sd->s_type & CONFIGFS_USET_DROPPING) {
+			spin_unlock(&configfs_dirent_lock);
+			config_item_put(item);
+			kfree(sl);
+			return -EPERM;
+		}
 		list_add(&sl->sl_list, &target_sd->s_links);
 		spin_unlock(&configfs_dirent_lock);
 		ret =3D configfs_create_link(sl, parent_item->ci_dentry,

--ahZICQ7iXVM/oLYH--

--=_bohort-18240-1213639663-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIVqxHVKcRuvQ9Q1QRAjyOAKC0K/MGj+eIlcDQZzv8ioqBgS1AngCgpIdv
VCWfItbBJrqyAufhCogqLxc=
=zlxj
-----END PGP SIGNATURE-----

--=_bohort-18240-1213639663-0001-2--
