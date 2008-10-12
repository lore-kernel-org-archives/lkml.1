Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbYJLMTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbYJLMTI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 08:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYJLMS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 08:18:56 -0400
Received: from pusher.mail.ru ([194.67.23.231]:16608 "EHLO mx48.mail.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbYJLMSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 08:18:55 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org
Subject: [PATCH RFC] provide information whether requested firmware is bult-in
Date: Sun, 12 Oct 2008 16:18:46 +0400
User-Agent: KMail/1.9.10
Cc: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3385729.I7qfuf3LGH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810121618.48830.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3385729.I7qfuf3LGH
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

As indicated by several threads on lkml, currently the only safe way
to reload external firmware in resume method is to cache it in memory.
In this case if firmware was already built in, we just create useless
copy. The patch suggests framework which can be used to return information
whether firmware was loaded dynamically or already available in memory.
Requestor can check it to decide whether local copy is required.

Alternative would be request_cached_firwmare() function to manage
cache in one place. =20

Comments? Is there any other reliable way to ensure firmware can be
loaded on resume?

=2Dandrey

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index c9c92b0..525561a 100644
=2D-- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -415,6 +415,7 @@ _request_firmware(const struct firmware **firmware_p, c=
onst char *name,
 		       name);
 		firmware->size =3D builtin->size;
 		firmware->data =3D builtin->data;
+		firmware->flags |=3D FW_FL_BUILTIN;
 		return 0;
 	}
=20
@@ -491,13 +492,8 @@ release_firmware(const struct firmware *fw)
 	struct builtin_fw *builtin;
=20
 	if (fw) {
=2D		for (builtin =3D __start_builtin_fw; builtin !=3D __end_builtin_fw;
=2D		     builtin++) {
=2D			if (fw->data =3D=3D builtin->data)
=2D				goto free_fw;
=2D		}
=2D		vfree(fw->data);
=2D	free_fw:
+		if (!(fw->flags&FW_FL_BUILTIN))
+			vfree(fw->data);
 		kfree(fw);
 	}
 }
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index c8ecf5b..0c6c232 100644
=2D-- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -9,9 +9,12 @@
 #define FW_ACTION_NOHOTPLUG 0
 #define FW_ACTION_HOTPLUG 1
=20
+#define FW_FL_BUILTIN	(1<<0) /* Firmware image is built in kernel */
+
 struct firmware {
 	size_t size;
 	const u8 *data;
+	unsigned short flags;
 };
=20
 struct device;

--nextPart3385729.I7qfuf3LGH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjx6ygACgkQR6LMutpd94wemgCfe9IcMaCznQfr8Y6jwf0bNVtz
lbIAn3xqJdFGMtcwyczRRDbDZeRVb/ns
=NO+J
-----END PGP SIGNATURE-----

--nextPart3385729.I7qfuf3LGH--
