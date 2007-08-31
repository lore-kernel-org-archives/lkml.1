Return-Path: <linux-kernel-owner+w=401wt.eu-S965454AbXHaQSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965454AbXHaQSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 12:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932687AbXHaQSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 12:18:16 -0400
Received: from orca.ele.uri.edu ([131.128.51.63]:43676 "EHLO orca.ele.uri.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932715AbXHaQSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 12:18:14 -0400
Date: Fri, 31 Aug 2007 12:18:57 -0400
From: Will Simoneau <simoneau@ele.uri.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] save registers around VESA BIOS calls
Message-ID: <20070831161746.GA5459@ele.uri.edu>
References: <20070831015620.GA6259@ele.uri.edu> <46D7AAF7.1030105@zytor.com> <46D7B817.3060304@zytor.com> <20070831150326.GA6003@ele.uri.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZmUaFz6apKcXQszQ"
Content-Disposition: inline
In-Reply-To: <20070831150326.GA6003@ele.uri.edu>
User-Agent: Mutt/1.5.16 [Linux 2.6.23-rc4-hrt1-b0rg-ga9a820df-dirty i686]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ZmUaFz6apKcXQszQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11:05 Fri 31 Aug     , Will Simoneau wrote:
> On 23:41 Thu 30 Aug     , H. Peter Anvin wrote:
> > H. Peter Anvin wrote:
> >> Will Simoneau wrote:
> >>> While trying to put together a new kernel for my laptop (Dell I5150, =
as
> >>> in subject) I found that recent kernels just don't boot. Right after
> >>> grub loads the kernel, before the "Uncompressing Linux" message is
> >>> shown, it hangs. The BIOS appears to still be alive (ctrl-alt-del wor=
ks,
> >>> keyboard lock LEDs respond). It seems to be caused by the new x86 set=
up
> >>> code.
> >>>
> >>> My kernel is Linus' git as of a1c582d0720f2eff61043e90711767decf37b91=
7.
> >>> I bisected and confirmed that 4fd06960f120e02e9abc802a09f9511c400042a5
> >>> triggers a non-functioning boot.
> >>>
> >>> This system has Dell BIOS rev A38 and a P4 3.2 w/HT.
> >>>
> >>> What should I do next to debug this problem?
> >> Can you put in some printf's in the code and see how far it gets?
> >
> > Specifically, the places to add printf's are to main() in main.c and=20
> > go_to_protected_mode() in pm.c.
> >
> > 	-hpa
>=20
> It dies in vesa_probe() right after calling int10 with ax=3D4f01 and
> checking the return status, which was 0x004f (success). This happens on
> the third iteration of the loop; the first two modes it finds are
> framebuffer modes. This would be just after line 72 in video-vesa.c .
>=20
> I have CONFIG_VIDEO_VESA=3Dy and CONFIG_FB=3Dy, but am not passing the
> kernel options that would use vesafb as the console.

Apparently some VESA BIOS implementations clobber our registers when called.
Tell gcc about it.

This makes my Dell Inspiron 5150 boot correctly instead of hanging.

Signed-off-by: Will Simoneau <simoneau@ele.uri.edu>

---

--- linux-2.6/arch/i386/boot/video-vesa.c.old	2007-08-31 11:51:40.478575122=
 -0400
+++ linux-2.6/arch/i386/boot/video-vesa.c	2007-08-31 11:51:10.980602450 -04=
00
@@ -39,9 +39,11 @@
=20
 	vginfo.signature =3D VBE2_MAGIC;
=20
-	/* Optimistically assume a VESA BIOS is register-clean... */
 	ax =3D 0x4f00;
-	asm("int $0x10" : "+a" (ax), "=3Dm" (vginfo) : "D" (&vginfo));
+	asm("int $0x10"
+	    : "+a" (ax), "=3Dm" (vginfo)
+	    : "D" (&vginfo)
+	    : "ebx", "ecx", "edx", "esi");
=20
 	if (ax !=3D 0x004f ||
 	    vginfo.signature !=3D VESA_MAGIC ||
@@ -66,7 +68,8 @@
 		ax =3D 0x4f01;
 		asm("int $0x10"
 		    : "+a" (ax), "=3Dm" (vminfo)
-		    : "c" (mode), "D" (&vminfo));
+		    : "c" (mode), "D" (&vminfo)
+		    : "ebx", "edx", "esi");
=20
 		if (ax !=3D 0x004f)
 			continue;

--ZmUaFz6apKcXQszQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.6 (GNU/Linux)

iD8DBQFG2D9xLYBaX8VDLLURAsgXAKCQwdisCb1hdmfKdm75Ax4r7XBGWwCfbVBu
7HMiNOVnhm1w2F2pPsK92u0=
=cYTZ
-----END PGP SIGNATURE-----

--ZmUaFz6apKcXQszQ--
