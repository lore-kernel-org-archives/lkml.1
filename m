Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbYBQSto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbYBQSto (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 13:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYBQStf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 13:49:35 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:41427 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247AbYBQSte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 13:49:34 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Jody Belka <lists-lkml@pimb.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
In-Reply-To: <20080215202336.GE26034@mail.oracle.com>
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org>
	 <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org>
	 <20080215202336.GE26034@mail.oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vOzYejRCEP/gXY6hP+I4"
Date: Sun, 17 Feb 2008 18:49:21 +0000
Message-Id: <1203274161.27987.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: 2.6.25-rc1 xen pvops regression
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=qcrRp5rlbqkS0d6TfuPTVw==:17 a=CHsNB40CsFkegmRE1e0A:9 a=kGwKrqIQ92h_EhrUQl4A:7 a=IkqdYhytcJH6Xz-X3aHZaxPQl9EA:4 a=WuK_CZDBSqoA:10 a=Mk1hGskNj2f678dB3p8A:9 a=HJx8NVoFwEaVn_xXAS6zt9IDn80A:4 a=rPt6xJ-oxjAA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vOzYejRCEP/gXY6hP+I4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2008-02-15 at 12:23 -0800, Joel Becker wrote:
> On Thu, Feb 14, 2008 at 06:50:52PM +1100, Jeremy Fitzhardinge wrote:
> >> 	I'm seeing the same problem, with no messages at all from xen
> >> other than "domain crashed, restart disabled" in xend.log.  I got a
> >> different commit in my bisect, 0947b2f31ca1ea1211d3cde2dbd8fcec579ef39=
5
> >> (i386 boot: replace boot_io    remap with enhanced bt_ioremap - enhanc=
e
> >> bt_ioremap).  I started from yesterday's
> >> 96b5a46e2a72dc1829370c87053e0cd558d58bc0 (WMI: initialize
> >> wmi_blocks.list even if ACPI is disabled) and a known good
> >> 9b73e76f3cf63379dcf45fcd4f112f5812418d0a (Merge
> >> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6).
> >
> > Is the domain ending up in the crashed state?  Do you get a register =20
> > dump with xm dmesg?  That would be very useful in determining what went=
 =20
> > wrong.  You may need to compile Xen with debug=3Dy in Config.mk.
>=20
> 	I didn't know xm dmesg existed :-)  Regarding debug=3Dy, I'm using
> a prepackaged dom0 set.  Here's what I find in xm dmesg:
>=20
> Joel
>=20
> (XEN) mm.c:1825:d109 Bad type (saw 0000000028000001 !=3D exp 00000000e000=
0000) for mfn 3a2f0f (pfn f0)
> (XEN) mm.c:649:d109 Error getting mfn 3a2f0f (pfn f0) from L1 entry 00000=
003a2f0f063 for dom109
> (XEN) mm.c:1825:d109 Bad type (saw 0000000028000001 !=3D exp 00000000e000=
0000) for mfn 3a2f0f (pfn f0)
> (XEN) mm.c:649:d109 Error getting mfn 3a2f0f (pfn f0) from L1 entry 00000=
003a2f0f063 for dom109
> (XEN) mm.c:3331:d109 ptwr_emulate: could not get_page_from_l1e()

I've been seeing similar attempts to map 0xf0 but so far I was the only
one (although that made no sense to me). Does the patch below help at
all? The problem seems to be that the kernel is trying to map pages at
0xf0000 but these are not reserved in the guest E820 map so they could
contain a page table page etc.

A useful tip for getting a backtrace out of a crashed Xen guest is to
set "on_crash=3Dpreserve" in your domain config. Then once the crash has
happened you can use "/usr/lib/xen/bin/xenctx -s System.map <domid>"
where System.map is the guest kernel System.map.

Ian.

---=20

x86/xen: Do not scan for DMI unless the DMI region is reserved by e820.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 9008ed5..79525f5 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -7,6 +7,7 @@
 #include <linux/bootmem.h>
 #include <linux/slab.h>
 #include <asm/dmi.h>
+#include <asm/e820.h>
=20
 static char dmi_empty_string[] =3D "        ";
=20
@@ -336,6 +337,10 @@ void __init dmi_scan_machine(void)
 		}
 	}
 	else {
+
+		if (!e820_all_mapped(0xF0000, 0xF0000+0x10000, E820_RESERVED))
+			goto out;
+
 		/*
 		 * no iounmap() for that ioremap(); it would be a no-op, but
 		 * it's so early in setup that sucker gets confused into doing

--=20
Ian Campbell

The profession of book writing makes horse racing seem like a solid,
stable business.
		-- John Steinbeck
	[Horse racing *is* a stable business ...]

--=-vOzYejRCEP/gXY6hP+I4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHuIGxM0+0qS9rzVkRAkFPAJ9qN8ARBGYN8IDTWKxyTYUMzV6xcQCfaZGI
+jyZrki0IBmxQ9yyIulh1tw=
=Wnnz
-----END PGP SIGNATURE-----

--=-vOzYejRCEP/gXY6hP+I4--

