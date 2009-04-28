Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbZD1SSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbZD1SSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 14:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbZD1SSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 14:18:36 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:41175 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbZD1SSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 14:18:36 -0400
Subject: Re: [.30-rc2 regression] garbled screen on video
From: Eric Anholt <eric@anholt.net>
To: Justin Madru <jdm64@gawab.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <49F10D49.5010604@gawab.com>
References: <49F10D49.5010604@gawab.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Lq7ZKq6aEOLxCx+J0mkl"
Date: Tue, 28 Apr 2009 11:18:34 -0700
Message-Id: <1240942714.13997.71.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Lq7ZKq6aEOLxCx+J0mkl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-23 at 17:52 -0700, Justin Madru wrote:
> Hi everyone,
>=20
> Summary:
> After playing a video for a little bit, the screen gets garbled. The=20
> only way to fix it is to
> switch to a virtual console and then back. The screen is fixed but=20
> unfortunately only for
> less than a few minuets and the screen gets corrupted again.
>=20
> Effected Version: 2.6.30-rc2+
> Picture showing a corrupt screen:=20
> http://ecs.fullerton.edu/~cs351a15/badscreen.jpg
>=20
> My System:
> Ubuntu 9.4 with 943/940GML Express Integrated Graphics Controller=20
> [8086:27a2]
> UXA/GEM/DRI2 enable. Full info at=20
> http://jdserver.homelinux.org/bugreports/004/
>=20
> Syslog Messages:
> None, but switching virtual consoles gives
> [drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for=20
> disabled pipe 0
> But I think that is another bug introduced with .30-rc1.

Interesting.  Could you open a bug at bugs.freedesktop.org against xorg,
driver/intel, to be sure this doesn't get lost?

However, I suspect that the commit in question isn't causing your issue,
but is just when tiling got reenabled on your platform so you got to see
other (likely userland) bugs.  To test, you could revert the patch you
bisected to and just apply one of the hunks with a little tweak:

diff --git a/drivers/gpu/drm/i915/i915_gem_tiling.c b/drivers/gpu/drm/i915/=
i915_gem_tiling.c
index 6be3f92..f27e523 100644
--- a/drivers/gpu/drm/i915/i915_gem_tiling.c
+++ b/drivers/gpu/drm/i915/i915_gem_tiling.c
@@ -127,8 +129,8 @@ i915_gem_detect_bit_6_swizzle(struct drm_device *dev)
 				swizzle_y =3D I915_BIT_6_SWIZZLE_9_11;
 			} else {
 				/* Bit 17 swizzling by the CPU in addition. */
-				swizzle_x =3D I915_BIT_6_SWIZZLE_UNKNOWN;
-				swizzle_y =3D I915_BIT_6_SWIZZLE_UNKNOWN;
+				swizzle_x =3D I915_BIT_6_SWIZZLE_9_10;
+				swizzle_y =3D I915_BIT_6_SWIZZLE_9;
 			}
 			break;
 		}

You'll get typical swizzling corruption if any tiled buffers get swapped
out, but that shouldn't happen because Ubuntu 9.04 is stuck with DRI1 so
all tiled buffers are pinned.  Note that DRI1 with compiz has many
graphical corruption and stability issues that are fixed with DRI2, but
I'm not sure that what you're seeing is one of those.

If that patch doesn't make things work, then to fix a giant pile of
userland bugs that might account for it, update to the 2.7.0 2D driver
and enable UXA, which will get you DRI2.

If the revert + small diff fixes things, I'm interested in seeing the
output of either reg_dumper from a compile of the 2D driver or a printk
of dcc in that function, combined with a screenshot of mesa's readpix
demo, on master (no reverts or anything).

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-Lq7ZKq6aEOLxCx+J0mkl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkn3SHoACgkQHUdvYGzw6vdSBgCePRVEqsA3v4t/ViyRXtieuI+t
s7YAnRtKs6yOV30mk1+VA/fJ/1XOubER
=GK5c
-----END PGP SIGNATURE-----

--=-Lq7ZKq6aEOLxCx+J0mkl--
