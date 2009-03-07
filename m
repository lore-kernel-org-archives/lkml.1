Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbZCGBiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbZCGBiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 20:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbZCGBiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 20:38:00 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:35579 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbZCGBh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 20:37:59 -0500
Subject: Re: Problems with AGPGART/drm and X11 2D-acceleration
From: Eric Anholt <eric@anholt.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       David Airlie <airlied@linux.ie>
In-Reply-To: <Pine.LNX.4.44L0.0903061522001.2715-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0903061522001.2715-100000@iolanthe.rowland.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Xti/nhw2qdSdffA1deKx"
Date: Fri, 06 Mar 2009 17:37:56 -0800
Message-Id: <1236389876.30263.16.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Xti/nhw2qdSdffA1deKx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-06 at 15:33 -0500, Alan Stern wrote:
> I've been experiencing problems running X with recent kernels. =20
> Without 2D-acceleration everything seems to work okay, but scrolling is
> uncomfortably slow.  With acceleration enabled...
>=20
> Under 2.6.27.19, X runs okay.  But the dmesg log gets these error
> messages when X start:
>=20
> [   54.375769] [drm] Initialized drm 1.1.0 20060810
> [   54.441049] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ =
16
> [   54.441521] pci 0000:00:02.0: setting latency timer to 64
> [   54.442380] [drm] Initialized i915 1.6.0 20060119 on minor 0
> [   54.543516] [drm:i915_getparam] *ERROR* Unknown parameter 5
> [   55.292058] [drm:i915_getparam] *ERROR* Unknown parameter 5

This says userland is asking about things (GEM) that the kernel doesn't
know about.

> Under 2.6.28.7, X fails during startup and exits with an error message. =20
> Dmesg says:
>=20
> [   63.129319] [drm] Initialized drm 1.1.0 20060810
> [   63.196690] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ =
16
> [   63.196704] pci 0000:00:02.0: setting latency timer to 64
> [   63.197679] [drm] Initialized i915 1.6.0 20080730 on minor 0
> [   63.457664] [drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LR=
U list empty
> [   63.457673] [drm:i915_gem_object_pin] *ERROR* Failure to bind: -12

Your xorg log probably says that you ran out of aperture space while
trying to initialize the server.  This message says "I ran out of
aperture space".

If userland's defaults (as long as you don't have any options in
xorg.conf) fail, then they need to be fixed.

> Under 2.6.29-rc6, X hangs during startup.  I have to reboot the machine
> to recover.  Dmesg says only:
>=20
> [   57.001997] [drm] Initialized drm 1.1.0 20060810
> [   57.121966] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ =
16
> [   57.121980] pci 0000:00:02.0: setting latency timer to 64
> [   57.127739] [drm] Initialized i915 1.6.0 20080730 on minor 0

Can't really say anything here without Xorg.0.log.  Maybe a backtrace of
the server, too?

> Relevant device info:
>=20
> # lspci -v -s 0:2.0
> 00:02.0 VGA compatible controller: Intel Corporation 82845G/GL[Brookdale-=
G]/GE Chipset Integrated Graphics Device (rev 03) (prog-if 00 [VGA controll=
er])
>         Subsystem: Intel Corporation Device 5247
>         Flags: bus master, fast devsel, latency 0, IRQ 16
>         Memory at f0000000 (32-bit, prefetchable) [size=3D128M]
>         Memory at ffa80000 (32-bit, non-prefetchable) [size=3D512K]
>         Capabilities: [d0] Power Management version 1
>         Kernel modules: intelfb

intelfb could interact badly with the DRM, I'd recommend removing it.

> From /etc/X11/xorg.conf:
>=20
> Section "Device"
>         Identifier  "Card0"
>         Driver      "intel"
>         VendorName  "Intel Corporation"
>         BoardName   "82845G/GL[Brookdale-G]/GE Chipset Integrated Graphic=
s Device"
>         BusID       "PCI:0:2:0"
>         Option      "AccelMethod"       "XAA"
> #       Option      "NoAccel" "yes"
>         Option      "BackingStore"      "on"
> EndSection
>=20
> I use XAA because the default EXA method causes X to hang during=20
> startup even under 2.6.27.
>=20
> Any advice or suggestions for things to try?

Userland needs to get fixed so that the defaults work for pre-9xx.  But
we don't support XAA.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-Xti/nhw2qdSdffA1deKx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmxz/QACgkQHUdvYGzw6vfJBgCfYH2eeaelFWcUPPC+W/ifWLYS
1hwAnjH9uVasKMq6Ns8ql6J+fjIO9yud
=JW9i
-----END PGP SIGNATURE-----

--=-Xti/nhw2qdSdffA1deKx--

