Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbYJCRJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbYJCRJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 13:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYJCRJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 13:09:39 -0400
Received: from flock1.newmail.ru ([82.204.219.207]:36995 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752602AbYJCRJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 13:09:39 -0400
From: Andrey Borzenkov <arvidjaar@newmail.ru>
To: akpm@linux-foundation.org
Subject: Re: + x86-fix-ghost-entries-under-sys-firmware-edd.patch added to -mm tree
Date: Fri, 3 Oct 2008 21:08:49 +0400
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt_Domsch@dell.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de
References: <200810030634.m936YVDC014640@imap1.linux-foundation.org>
In-Reply-To: <200810030634.m936YVDC014640@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2308472.UXNQSWZiLo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810032108.51047.arvidjaar@newmail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2308472.UXNQSWZiLo
Content-Type: multipart/mixed;
  boundary="Boundary-01=_iGl5IgP1EV7Cc4d"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_iGl5IgP1EV7Cc4d
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 03 October 2008, akpm@linux-foundation.org wrote:
> hpa:
>=20
>    Right, I think that's a much better patch.
>=20
>    The really Right Thing[TM] to do is probably to pre-clear the buffer
>    and then look for the 0xaa55 signature at offset 510; it is required
>    for sector 0 to be a valid MBR-format partition table and hence for the
>    MBR *signature* to be valid.
>=20
>    I'll write that up tomorrow (I'm travelling today), or you can send
>    me a patch.
>=20
> akpm:
>=20
>    A patch in hand is worth...

I am really sorry; I botched this initially and then was distracted by other
things. The patch attached.

--Boundary-01=_iGl5IgP1EV7Cc4d
Content-Type: text/x-diff;
  charset="utf-8";
  name="fix-edd-detection-v2"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="fix-edd-detection-v2"

Subject: [PATCH] Fix ghost entries under /sys/firmware/edd take 3
=46rom: Andrey Borzenkov < arvidjaar@mail.ru>

Some BIOSes do not indicate error when trying to read from non-
existing device. Zero buffer before reading and check that we
possibly have valid MBR by looking for MBR magic.

This was fixed in different way for edd.S in
http://marc.info/?l=3Dlinux-kernel&m=3D114087765422490&w=3D2, but lost
again when edd.S was rewritten in C.

Signed-off-by: Andrey Borzenkov < arvidjaar@mail.ru>

=2D--

 arch/x86/boot/edd.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)


diff --git a/arch/x86/boot/edd.c b/arch/x86/boot/edd.c
index d93cbc6..1aae8f3 100644
=2D-- a/arch/x86/boot/edd.c
+++ b/arch/x86/boot/edd.c
@@ -41,6 +41,7 @@ static u32 read_mbr_sig(u8 devno, struct edd_info *ei, u3=
2 *mbrsig)
 	char *mbrbuf_ptr, *mbrbuf_end;
 	u32 buf_base, mbr_base;
 	extern char _end[];
+	u16 mbr_magic;
=20
 	sector_size =3D ei->params.bytes_per_sector;
 	if (!sector_size)
@@ -58,11 +59,15 @@ static u32 read_mbr_sig(u8 devno, struct edd_info *ei, =
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
+	mbr_magic =3D *(u16 *)&mbrbuf_ptr[510];
+
+	/* check for valid MBR magic */
+	return mbr_magic =3D=3D 0xAA55 ? 0 : -1;
 }
=20
 static int get_edd_info(u8 devno, struct edd_info *ei)

--Boundary-01=_iGl5IgP1EV7Cc4d--

--nextPart2308472.UXNQSWZiLo
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjmUaIACgkQR6LMutpd94xQHQCfZMCTbYaXcI79c/6wvo+EomRc
a8sAoJgjOZkVpfkHiYIetGNXkHm5l61S
=wBhJ
-----END PGP SIGNATURE-----

--nextPart2308472.UXNQSWZiLo--
