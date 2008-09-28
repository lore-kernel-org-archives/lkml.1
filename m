Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbYI1Gfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbYI1Gfz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 02:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbYI1Gfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 02:35:47 -0400
Received: from flock1.newmail.ru ([82.204.219.207]:50873 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751125AbYI1Gfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 02:35:46 -0400
From: Andrey Borzenkov <arvidjaar@newmail.ru>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Ghost EDD devices in /sys again
Date: Sun, 28 Sep 2008 10:34:58 +0400
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
References: <200809062208.m86M8hJM016685@terminus.zytor.com>
In-Reply-To: <200809062208.m86M8hJM016685@terminus.zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1276939.FzfHb1WbHJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809281035.06547.arvidjaar@newmail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1276939.FzfHb1WbHJ
Content-Type: multipart/mixed;
  boundary="Boundary-01=_UWy3IhuNYHpFHUe"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_UWy3IhuNYHpFHUe
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 07 September 2008, H. Peter Anvin wrote:
>=20
> I think this is closer to what we really want; after all, memory being wr=
itten is the "first principles" test that applies here.
>=20

OK I have been using this for some time. I do not actually insist on
returning "failure" for zero signature; my main concern was duplicated
signature resulted from not clearing read buffer. Still I assume that
zero signature is the same as no signature; i.e. even if disk is physically
present but zeroed out there is no point in presenting mbr_signature in
sysfs either.

--Boundary-01=_UWy3IhuNYHpFHUe
Content-Type: text/x-diff;
  charset="utf-8";
  name="fix-edd-detection-v2"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="fix-edd-detection-v2"

Subject: [PATCH] Fix ghost entries under /sys/firmware/edd take 2
=46rom: Andrey Borzenkov < arvidjaar@mail.ru>

Some BIOSes do not indicate error when trying to read from non-
existing device. Zero buffer before reading and check that we
actually got some data.

This was fixed in different way for edd.S in
http://marc.info/?l=3Dlinux-kernel&m=3D114087765422490&w=3D2, but lost
again when edd.S was rewritten in C.

Signed-off-by: Andrey Borzenkov < arvidjaar@mail.ru>

=2D--

 arch/x86/boot/edd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/arch/x86/boot/edd.c b/arch/x86/boot/edd.c
index d93cbc6..0388234 100644
=2D-- a/arch/x86/boot/edd.c
+++ b/arch/x86/boot/edd.c
@@ -58,11 +58,12 @@ static u32 read_mbr_sig(u8 devno, struct edd_info *ei, =
u32 *mbrsig)
 	if (mbrbuf_end > (char *)(size_t)boot_params.hdr.heap_end_ptr)
 		return -1;
=20
+	memset(mbrbuf_ptr, 0, sector_size);
 	if (read_mbr(devno, mbrbuf_ptr))
 		return -1;
=20
 	*mbrsig =3D *(u32 *)&mbrbuf_ptr[EDD_MBR_SIG_OFFSET];
=2D	return 0;
+	return -!*mbrsig;	/* treat zero signature as no sig */
 }
=20
 static int get_edd_info(u8 devno, struct edd_info *ei)

--Boundary-01=_UWy3IhuNYHpFHUe--

--nextPart1276939.FzfHb1WbHJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjfJZQACgkQR6LMutpd94zxBQCfdYZoKz66iplURmkEZzOBOgak
K/AAnAhht6c99KkrSoiegPazUt6cdcN1
=Gp8v
-----END PGP SIGNATURE-----

--nextPart1276939.FzfHb1WbHJ--
