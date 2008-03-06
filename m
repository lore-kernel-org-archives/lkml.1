Return-Path: <linux-kernel-owner+w=401wt.eu-S1755031AbYCFMC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbYCFMC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbYCFMCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:02:47 -0500
Received: from mail2.iitk.ac.in ([203.197.196.2]:38075 "EHLO mail2.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbYCFMCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:02:46 -0500
X-Greylist: delayed 1381 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2008 07:02:45 EST
Message-ID: <47CFD7F8.9010903@cse.iitk.ac.in>
Date: Thu, 06 Mar 2008 17:09:36 +0530
From: Arun Raghavan <arunsr@cse.iitk.ac.in>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Allow clients to set key perms in key_create_or_update()
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA2A8E7198457995C9DC58848"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA2A8E7198457995C9DC58848
Content-Type: multipart/mixed;
 boundary="------------020305010009010109070602"

This is a multi-part message in MIME format.
--------------020305010009010109070602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hello,
The key_create_or_update() function provided by the keyring code has a=20
default set of permissions that are always applied to the key when=20
created. This might not be desirable to all clients.

Here's a patch that adds a "perm" parameter to the function to address=20
this, which can be set to KEY_PERM_UNDEF to revert to the current behavio=
ur.

Cheers,
Arun

[please CC me on replies -- I'm not on the LKML)

--------------020305010009010109070602
Content-Type: text/plain;
 name="key_create_or_update-with-perms.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="key_create_or_update-with-perms.diff"

diff --git a/include/linux/key.h b/include/linux/key.h
index a70b8a8..5b09ad6 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -67,6 +67,8 @@ struct key;
 #define KEY_OTH_SETATTR	0x00000020
 #define KEY_OTH_ALL	0x0000003f
=20
+#define KEY_PERM_UNDEF	0xffffffff
+
 struct seq_file;
 struct user_struct;
 struct signal_struct;
@@ -229,6 +231,7 @@ extern key_ref_t key_create_or_update(key_ref_t keyri=
ng,
 				      const char *description,
 				      const void *payload,
 				      size_t plen,
+				      key_perm_t perm,
 				      unsigned long flags);
=20
 extern int key_update(key_ref_t key,
diff --git a/security/keys/key.c b/security/keys/key.c
index fdd5ca6..ca1d921 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -757,11 +757,11 @@ key_ref_t key_create_or_update(key_ref_t keyring_re=
f,
 			       const char *description,
 			       const void *payload,
 			       size_t plen,
+			       key_perm_t perm,
 			       unsigned long flags)
 {
 	struct key_type *ktype;
 	struct key *keyring, *key =3D NULL;
-	key_perm_t perm;
 	key_ref_t key_ref;
 	int ret;
=20
@@ -806,15 +806,17 @@ key_ref_t key_create_or_update(key_ref_t keyring_re=
f,
 			goto found_matching_key;
 	}
=20
-	/* decide on the permissions we want */
-	perm =3D KEY_POS_VIEW | KEY_POS_SEARCH | KEY_POS_LINK | KEY_POS_SETATTR=
;
-	perm |=3D KEY_USR_VIEW | KEY_USR_SEARCH | KEY_USR_LINK | KEY_USR_SETATT=
R;
+	/* if the client doesn't provide, decide on the permissions we want */
+	if (perm =3D=3D KEY_PERM_UNDEF) {
+		perm =3D KEY_POS_VIEW | KEY_POS_SEARCH | KEY_POS_LINK | KEY_POS_SETATT=
R;
+		perm |=3D KEY_USR_VIEW | KEY_USR_SEARCH | KEY_USR_LINK | KEY_USR_SETAT=
TR;
=20
-	if (ktype->read)
-		perm |=3D KEY_POS_READ | KEY_USR_READ;
+		if (ktype->read)
+			perm |=3D KEY_POS_READ | KEY_USR_READ;
=20
-	if (ktype =3D=3D &key_type_keyring || ktype->update)
-		perm |=3D KEY_USR_WRITE;
+		if (ktype =3D=3D &key_type_keyring || ktype->update)
+			perm |=3D KEY_USR_WRITE;
+	}
=20
 	/* allocate a new key */
 	key =3D key_alloc(ktype, description, current->fsuid, current->fsgid,
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index d9ca15c..90ba663 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -102,7 +102,8 @@ asmlinkage long sys_add_key(const char __user *_type,=

 	/* create or update the requested key and add it to the target
 	 * keyring */
 	key_ref =3D key_create_or_update(keyring_ref, type, description,
-				       payload, plen, KEY_ALLOC_IN_QUOTA);
+				       payload, plen, KEY_PERM_UNDEF,
+				       KEY_ALLOC_IN_QUOTA);
 	if (!IS_ERR(key_ref)) {
 		ret =3D key_ref_to_ptr(key_ref)->serial;
 		key_ref_put(key_ref);

--------------020305010009010109070602--

--------------enigA2A8E7198457995C9DC58848
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHz9f7nt3q2cgh8Z4RAso5AJ43MsrklBN6fIsaX540fdSObH0UCQCdGhkz
NqaQQaHCn1FaohOsbpR2n0M=
=0pfG
-----END PGP SIGNATURE-----

--------------enigA2A8E7198457995C9DC58848--
