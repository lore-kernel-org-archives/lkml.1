Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab0BTBCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 20:02:17 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46514 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756582Ab0BTBCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 20:02:14 -0500
Date: Sat, 20 Feb 2010 12:02:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: import of usb series failed
Message-Id: <20100220120207.1d765147.sfr@canb.auug.org.au>
In-Reply-To: <20100219155343.GA3946@kroah.com>
References: <20100218105500.898ece5e.sfr@canb.auug.org.au>
	<20100218002144.GA17850@kroah.com>
	<20100218132221.b15d151f.sfr@canb.auug.org.au>
	<20100219175218.10025a7a.sfr@canb.auug.org.au>
	<20100219155343.GA3946@kroah.com>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__20_Feb_2010_12_02_07_+1100_nnFAd2gL_0Blf2Bl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__20_Feb_2010_12_02_07_+1100_nnFAd2gL_0Blf2Bl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

[This is a bit long - I wrote it while I was investigating.  Skip to the
end for the possible resolution.]

On Fri, 19 Feb 2010 07:53:43 -0800 Greg KH <greg@kroah.com> wrote:
>
> Very wierd.  I just ran 'git quiltimport' on my whole tree onto Linus's
> latest git tree and it worked just fine.
>=20
> What is the command you are using here to do this?  Perhaps there is
> some other tree modifying this file causing a problem?
>=20
> odd,

Yes, indeed.

Here is an excerpt from the quilt import log for yesterday:

-------------------------------------------------------------------------
Importing driver-core.current based on 2.6.33-rc8
Unchanged quilt series driver-core.current
Importing tty.current based on quilt/driver-core.current
Unchanged quilt series tty.current
Importing usb.current based on quilt/tty.current
Unchanged quilt series usb.current
Importing staging.current based on quilt/usb.current
Unchanged quilt series staging.current
Importing driver-core based on quilt/staging.current
$ git clone -s -l -n -q . ../quilt-tmp
$ cd ../quilt-tmp
$ git reset --hard 724e6d3fe8003c3f60bf404bf22e4e331327c596
HEAD is now at 724e6d3 Linux 2.6.33-rc8
$ git quiltimport --author Greg KH <greg@kroah.com> --patches ../quilt/driv=
er-core
kobject-example-spelling-fixes.patch
	.
	.
	.
msi-laptop-depends-on-rfkill.patch
$ cd ../next
$ git fetch -f ../quilt-tmp master:quilt/driver-core
=46rom ../quilt-tmp
 + 3d6a19d...ce9ae3d master     -> quilt/driver-core  (forced update)
Importing tty based on quilt/driver-core
$ cd ../quilt-tmp
$ git reset --hard ce9ae3d4576783400109975a5a25f4bd9202cf7c
HEAD is now at ce9ae3d msi-laptop: depends on RFKILL
$ git quiltimport --author Greg KH <greg@kroah.com> --patches ../quilt/tty
serial-fit-blackfin-uart-over-sport-driver-into-common-uart-infrastructure.=
patch
	.
	.
	.
tty-fix-the-ldisc-hangup-race.patch
$ cd ../next
$ git fetch -f ../quilt-tmp master:quilt/tty
=46rom ../quilt-tmp
 + d99adec...e686c28 master     -> quilt/tty  (forced update)
Importing usb based on quilt/tty
$ cd ../quilt-tmp
$ git reset --hard e686c28435a750e78ac3eb44ea8295c5a3ce3461
HEAD is now at e686c28 tty: Fix the ldisc hangup race
$ git quiltimport --author Greg KH <greg@kroah.com> --patches ../quilt/usb
usb-mxc-add-i.mx21-specific-usb-host-controller-driver.patch
	.
	.
	.
usb-gadget-add-devtype-support-for-ethernet-functions.patch
usb-serial-eliminate-useless-code.patch
usb-ftdi_sio-correct-spelling-in-header-files.patch
error: patch failed: drivers/usb/serial/ftdi_sio_ids.h:185
error: drivers/usb/serial/ftdi_sio_ids.h: patch does not apply
-------------------------------------------------------------------------

So, since the ".current" series are all empty, I am importing the
driver-core, tty and then usb series on top of v2.6.33-rc8.  I have just
done this again manually and the failure still happens (I have not
refetched your quilt series since yesterday.

At this point, the file drivers/usb/serial/ftdi_sio_ids.h from line 185
looks like this:

#define FTDI_ELV_PCD200_PID	0xF06C	/* PC-Datenlogger (PCD 200) */
#define FTDI_ELV_ULA200_PID	0xF06D	/* USB-LCD-Ansteuerung (ULA 200) */
#define FTDI_ELV_ALC8500_PID	0xF06E	/* ALC 8500 Expert */
#define FTDI_ELV_FHZ1000PC_PID	0xF06F	/* FHZ 1000 PC */
#define FTDI_ELV_UR100_PID	0xFB58	/* USB-RS232-Umsetzer (UR 100) */
#define FTDI_ELV_UM100_PID	0xFB5A	/* USB-Modul UM 100 */

The patch hunk looks like this:

@@ -185,7 +185,7 @@
 #define FTDI_ELV_TFD128_PID	0xE0EC	/* ELV Temperatur-Feuchte-Datenlogger T=
FD 128 */
 #define FTDI_ELV_FM3RX_PID	0xE0ED	/* ELV Messwertuebertragung FM3 RX */
 #define FTDI_ELV_WS777_PID	0xE0EE	/* Conrad WS 777 */
-#define FTDI_ELV_EM1010PC_PID	0xE0EF	/* Engery monitor EM 1010 PC */
+#define FTDI_ELV_EM1010PC_PID	0xE0EF	/* Energy monitor EM 1010 PC */
 #define FTDI_ELV_CSI8_PID	0xE0F0	/* Computer-Schalt-Interface (CSI 8) */
 #define FTDI_ELV_EM1000DL_PID	0xE0F1	/* PC-Datenlogger fuer Energiemonitor=
 (EM 1000 DL) */
 #define FTDI_ELV_PCK100_PID	0xE0F2	/* PC-Kabeltester (PCK 100) */

Between v2.6.33-rc8 and the head if Linus' tree thee are two patches that
change this file.  So I guess the BASE in the driver-core.current series
files needs updating.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__20_Feb_2010_12_02_07_+1100_nnFAd2gL_0Blf2Bl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkt/NI8ACgkQjjKRsyhoI8yMhwCgs+bLyrbELLYcWxMfxTt+gu5i
yIUAoI2mNI3YoDF28tcX3pUyyZegqKQv
=Hrk/
-----END PGP SIGNATURE-----

--Signature=_Sat__20_Feb_2010_12_02_07_+1100_nnFAd2gL_0Blf2Bl--
