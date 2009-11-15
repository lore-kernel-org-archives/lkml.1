Return-Path: <linux-kernel-owner+w=401wt.eu-S1752328AbZKOIsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbZKOIsh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 03:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbZKOIsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 03:48:37 -0500
Received: from mx33.mail.ru ([94.100.176.47]:59588 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbZKOIsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 03:48:36 -0500
X-Greylist: delayed 71837 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Nov 2009 03:48:36 EST
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: Three buttons reported on two-button touchpad
Date: Sun, 15 Nov 2009 11:48:29 +0300
User-Agent: KMail/1.12.90 (Linux/2.6.31.6-desktop-0.rc1.1mnb; KDE/4.3.73; x86_64; ; )
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200911141551.14263.arvidjaar@mail.ru> <20091115062036.GA9844@core.coreip.homeip.net>
In-Reply-To: <20091115062036.GA9844@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1611703.nX0DO3Yev7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200911151148.32631.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1611703.nX0DO3Yev7
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Sunday 15 of November 2009 09:20:36 Dmitry Torokhov wrote:
> Hi Andrey,
>=20
> On Sat, Nov 14, 2009 at 03:51:10PM +0300, Andrey Borzenkov wrote:
> > Kernel 2.6.31.x
> >
> > dmesg:
> > Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1c0b1, caps:
> > 0xa04751/0x0
> >
> > but /proc/bus/input/devices:
> >
> > I: Bus=3D0011 Vendor=3D0002 Product=3D0007 Version=3D01b1
> > N: Name=3D"SynPS/2 Synaptics TouchPad"
> > P: Phys=3Disa0060/serio1/input0
> > S: Sysfs=3D/devices/platform/i8042/serio1/input/input15
> > U: Uniq=3D
> > H: Handlers=3Dmouse1 event2
> > B: EV=3Db
> > B: KEY=3D420 70000 0 0 0 0
> > B: ABS=3D11000003
> >
> > So even when capabilities clear say only 2 buttons, driver claims
> > there are 3 of them.
> >
> > The reason most likely is initialization sequence.
> > psmouse_switch_protocol() unconditionally sets supported buttons:
> >
> >         input_dev->evbit[0] =3D BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
> >         input_dev->keybit[BIT_WORD(BTN_MOUSE)] =3D BIT_MASK(BTN_LEFT)
> > | BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT); input_dev->relbit[0]
> > =3D BIT_MASK(REL_X) | BIT_MASK(REL_Y);
> >
> > before even starting hardware detection and knowing real
> > capabilities. Detection for specific hardware won't change it
> > (possibly only extend).
>=20
> Some of them do.
>=20
> > Is it OK to move button bits setting into ps2bare_detect()? This
> > seems to agree with comments in psmouse_extensions() as well:
> >
> > /*
> >  * Okay, all failed, we have a standard mouse here. The number of
> > the buttons
> >  * is still a question, though. We assume 3.
> >  */
> >
> > All other detection routines seem to be setting those bits already.
>=20
> Not all of them but yes, I think we should to this. DOes th patch
>  below work for you?
>=20

Yes (I can test only Synaptics case).

Tested-by: Andrey Borzenkov <arvidjaar@mail.ru>

> +       input_dev->keybit[BIT_WORD(BTN_MOUSE)] =3D
> +                               BIT_MASK(BTN_LEFT) |=20
BIT_MASK(BTN_RIGHT);

Just curious - is Apple touchpad (as found on MacBook) handled by=20
different driver? Because it has just single button.

--nextPart1611703.nX0DO3Yev7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkr/wF0ACgkQR6LMutpd94w3WgCfTqNsKsWG2iPXU4qeWl7hkyHz
+y4An2Ec7O0HDu3dcb7nniXqnMH9TqDt
=U7Nb
-----END PGP SIGNATURE-----

--nextPart1611703.nX0DO3Yev7--
