Return-Path: <linux-kernel-owner+w=401wt.eu-S1765089AbZDAALj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765089AbZDAALj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761169AbZDAAKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:10:51 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:46968 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764445AbZDAAKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:10:50 -0400
Subject: PAGE_CACHE_WC strikes again
From: Eric Anholt <eric@anholt.net>
To: lkml <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NyDJnIK42oTxt+V5+B/9"
Date: Tue, 31 Mar 2009 17:10:47 -0700
Message-Id: <1238544647.8369.682.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NyDJnIK42oTxt+V5+B/9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I just tracked down what was cutting performance 10x on one of my
systems on a microbenchmark I'd just written:

--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -540,7 +540,7 @@ int drm_gem_mmap(struct file *filp, struct
vm_area_struct *vma)
 	/* FIXME: use pgprot_writecombine when available */
 	prot =3D pgprot_val(vma->vm_page_prot);
 #ifdef CONFIG_X86
-	prot |=3D _PAGE_CACHE_WC;
+	/*prot |=3D _PAGE_CACHE_WC;*/
 #endif
 	vma->vm_page_prot =3D __pgprot(prot);
=20
Turns out that setting PAGE_CACHE_WC disables the WC effect of the MTRR
on my non-PAT (disabled due to CPU errata) 945GM system, and this
workaround took GTT-mapped writes from 120MB/s to 1180MB/s.

What's the right way to be setting our PTEs?  This is similar to the
workaround in ef5fa0ab24b87646c7bc98645acbb4b51fc2acd4, but to do it in
the driver as well means exporting pat_enabled, and it really seems like
PAT presence shouldn't be something the driver has to worry about --
I've got a WC MTRR and I'm asking for a WC mapping and I'm getting
uncached.  If I failed to init the MTRR, the state of the aperture I'm
mapping would be uncached.

Test code is at
git://anongit.freedesktop.org/git/xorg/app/intel-gpu-tools
under benchmarks/intel_upload_blit_large_gtt but requires libdrm master
until we get a release out in the next week or so.  Also includes a few
standalone regression tests, which may be useful for people making
changes that may affect i915.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-NyDJnIK42oTxt+V5+B/9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEABECAAYFAknSsQcACgkQHUdvYGzw6vdkPwCfdUnebvNPu6/SHnuL/NTSI2gR
ts0AljZig+gREW3l7mIFyAYYjEzuFQg=
=PXf0
-----END PGP SIGNATURE-----

--=-NyDJnIK42oTxt+V5+B/9--

