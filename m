Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab0CKIeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 03:34:12 -0500
Received: from mga06.intel.com ([134.134.136.21]:28084 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753724Ab0CKIeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 03:34:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,619,1262592000"; 
   d="asc'?scan'208";a="499747672"
Date: Thu, 11 Mar 2010 16:34:04 +0800
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: linux-kernel@vger.kernel.org, David.Woodhouse@intel.com,
       dwmw2@infradead.org, eric@anholt.net, ben@decadent.org.uk,
       gregkh@suse.de
Subject: Re: [PATCH] intel-agp.c: Fix crash when accessing nonexistent GTT
 entries in i915
Message-ID: <20100311083404.GG6896@zhen-devel.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
Mail-Followup-To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	linux-kernel@vger.kernel.org, David.Woodhouse@intel.com,
	dwmw2@infradead.org, eric@anholt.net, ben@decadent.org.uk,
	gregkh@suse.de
References: <1268258994.2183.14.camel@carter>
 <ca2dc2821003102331x3d1a7a0fgadb63612e49f77db@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqCDj3hiknadvR6t"
Content-Disposition: inline
In-Reply-To: <ca2dc2821003102331x3d1a7a0fgadb63612e49f77db@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqCDj3hiknadvR6t
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2010.03.11 08:31:57 +0100, Miguel Ojeda wrote:
> On Wed, Mar 10, 2010 at 11:09 PM, Miguel Ojeda
> <miguel.ojeda.sandonis@gmail.com> wrote:
> > Hi,
> >
> > The commit 5877960869333e42ebeb733e8d9d5630ff96d350 (included since 2.6=
=2E32.4) crashes (locks up) the 82915G/GV/910GL Controller when intel-agp.c=
 tries to access nonexistent GTT entries at:
> >
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D intel_private.gtt_entries; i <=
 current_size->num_entries; i++) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D intel_private.gtt_entries; i <=
 intel_private.gtt_total_size; i++) {
> >
> > Rationale: I915 (gma900) has 128 MB of video memory (maximum), as per i=
ntel.com ( http://www.intel.com/support/graphics/intel915g/sb/CS-012579.htm=
 ) and lscpi:

I think that page is wrong, and http://www.intel.com/design/chipsets/datash=
ts/301467.htm
has info that 256K is for GTT bar, so max video memory size is 256M. On my =
915G
board, I can choose 128M/256M in BIOS setup.

> >
> > 00:02.0 VGA compatible controller: Intel Corporation 82915G/GV/910GL In=
tegrated Graphics Controller (rev 04) (prog-if 00 [VGA controller])
> > =A0 =A0 =A0 =A0Subsystem: Intel Corporation Device 4147
> > =A0 =A0 =A0 =A0Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASno=
op- ParErr- Stepping- SERR- FastB2B- DisINTx-
> > =A0 =A0 =A0 =A0Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast =
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> > =A0 =A0 =A0 =A0Latency: 0
> > =A0 =A0 =A0 =A0Interrupt: pin A routed to IRQ 11
> > =A0 =A0 =A0 =A0Region 0: Memory at ff480000 (32-bit, non-prefetchable) =
[size=3D512K]
> > =A0 =A0 =A0 =A0Region 1: I/O ports at ec00 [size=3D8]
> > =A0 =A0 =A0 =A0Region 2: Memory at d8000000 (32-bit, prefetchable) [siz=
e=3D128M]
> > =A0 =A0 =A0 =A0Region 3: Memory at ff440000 (32-bit, non-prefetchable) =
[size=3D256K]

This also tells bar 3 for GTT has 256K.

> > =A0 =A0 =A0 =A0Capabilities: <access denied>
> >
> >
> > AFAIK, that implies that its gtt_total_size (in pages) should be 32K (a=
s num_entries showed before the commit) instead of 64K.
> >
> > Note: The IS_I915 macro includes 945; however, only GMA900 (I915) had 1=
28 MB as the maximum AFAIK. Therefore, I divided the IS_I915 macro. I do no=
t know about the "E7221" (please check).
> >
> > How to reproduce: Access kernel.org in iceweasel (Debian Lenny) and the=
 X server will crash. Sometimes, the kernel freezes.
> >

I can't produce this on my 915G board with 128M or 256M memory config. Coul=
d you
paste dmesg in your failure or just hang?

> > Please review. The fix should be applied to stable series, as well as 2=
=2E6.33 and 2.6.34-rc1.
> >
> > Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> > ---
> > --- linux-2.6.32.stable/drivers/char/agp/intel-agp.c.old =A0 =A0 =A0 =
=A02010-03-10 15:32:36.000000000 +0100
> > +++ linux-2.6.32.stable/drivers/char/agp/intel-agp.c =A0 =A02010-03-10 =
22:38:23.000000000 +0100
> > @@ -65,11 +65,11 @@
> > =A0#define PCI_DEVICE_ID_INTEL_IGDNG_MC2_HB =A0 =A00x006a
> > =A0#define PCI_DEVICE_ID_INTEL_IGDNG_M_IG =A0 =A0 0x0046
> >
> > -/* cover 915 and 945 variants */
> > =A0#define IS_I915 (agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_=
E7221_HB || \
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 agp_bridge->dev->device =3D=3D PCI_DEVI=
CE_ID_INTEL_82915G_HB || \
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0agp_bridge->dev->device =3D=3D PCI_DEV=
ICE_ID_INTEL_82915GM_HB || \
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0agp_bridge->dev->device =3D=3D PCI_DEV=
ICE_ID_INTEL_82945G_HB || \
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0agp_bridge->dev->device =3D=3D PCI_DEV=
ICE_ID_INTEL_82915GM_HB)
> > +
> > +#define IS_I945 (agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_82=
945G_HB || \
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 agp_bridge->dev->device =3D=3D PCI_DEVI=
CE_ID_INTEL_82945GM_HB || \
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 agp_bridge->dev->device =3D=3D PCI_DEVI=
CE_ID_INTEL_82945GME_HB)
> >
> > @@ -724,14 +724,14 @@ static void intel_i830_init_gtt_entries(
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case I915_GMCH_GMS_STOLEN_48M:
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Check it's really I91=
5G */
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_I915 || IS_I965 ||=
 IS_G33 || IS_G4X)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_I915 || IS_I945 ||=
 IS_I965 || IS_G33 || IS_G4X)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0gtt_entr=
ies =3D MB(48) - KB(size);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0gtt_entr=
ies =3D 0;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case I915_GMCH_GMS_STOLEN_64M:
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Check it's really I91=
5G */
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_I915 || IS_I965 ||=
 IS_G33 || IS_G4X)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_I915 || IS_I945 ||=
 IS_I965 || IS_G33 || IS_G4X)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0gtt_entr=
ies =3D MB(64) - KB(size);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0gtt_entr=
ies =3D 0;
> > @@ -1305,6 +1305,8 @@ static int intel_i915_create_gatt_table(
> >
> > =A0 =A0 =A0 =A0if (IS_G33)
> > =A0 =A0 =A0 =A0 =A0 =A0gtt_map_size =3D 1024 * 1024; /* 1M on G33 */
> > + =A0 =A0 =A0 else if (IS_I915)
> > + =A0 =A0 =A0 =A0 =A0 gtt_map_size =3D 128 * 1024; /* 128K on I915 */
> > =A0 =A0 =A0 =A0intel_private.gtt =3D ioremap(temp2, gtt_map_size);
> > =A0 =A0 =A0 =A0if (!intel_private.gtt)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
> >
> >
> >
>=20
> Cc'ing the original committers.

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--AqCDj3hiknadvR6t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuYqvwACgkQsQQaM014GCfp8QCeKq/pp/1CLnb6wIwyDrcHtlp4
N2MAn1MLVKNuISjYYcGs1gc/18ABQhZu
=1GTP
-----END PGP SIGNATURE-----

--AqCDj3hiknadvR6t--
