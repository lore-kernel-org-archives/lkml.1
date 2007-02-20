Return-Path: <linux-kernel-owner+w=401wt.eu-S964878AbXBTN6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964878AbXBTN6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 08:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964883AbXBTN6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 08:58:19 -0500
Received: from posthamster.phnxsoft.com ([195.227.45.4]:3088 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964878AbXBTN6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 08:58:19 -0500
Message-ID: <45DAFE0B.1070305@imap.cc>
Date: Tue, 20 Feb 2007 14:56:27 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Kai Germaschewski <kai.germaschewski@unh.edu>,
       Hansjoerg Lipp <hjlipp@web.de>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
Subject: Re: Kbuild problem
References: <45D74B46.3090602@imap.cc> <Pine.LNX.4.44.0702180017170.1150-100000@localhost.localdomain> <20070218104028.GU13958@stusta.de>
In-Reply-To: <20070218104028.GU13958@stusta.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBBFDD3706E5F7D3DE1B996C0"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBBFDD3706E5F7D3DE1B996C0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Adrian Bunk schrieb:
> On Sun, Feb 18, 2007 at 12:22:10AM -0500, Kai Germaschewski wrote:
>> On Sat, 17 Feb 2007, Tilman Schmidt wrote:
>>=20
>> > asyncdata.o is only needed for M105 and M101, not for the base
>> > driver. How do I express in Kbuild that asyncdata.o is to be added
>> > to gigaset-y only if CONFIG_GIGASET_M105 and CONFIG_GIGASET_M101
>> > are not both 'n'?
>>=20
>> The way this is typically done is via Kconfig. Add a config option=20
>> ASYNCDATA (actually something more descriptive/specific would be bette=
r),=20
>> add a "select ASYNCDATA" to the config options for m101 and m105, and =
then=20
>> you can use CONFIG_ASYNCDATA to decide whether to add asyncdata.o in t=
he=20
>> Makefile.
>=20
> One disadvantage of this approach is that in a kernel with=20
> CONFIG_GIGASET_BASE=3Dy, you can't later compile and load the usb_gigas=
et=20
> or ser_gigaset modules without rebooting since they require a change to=
=20
> the kernel image.

You've got a point there. So linking asyncdata.o into the modules that
need it, as it is currently done, would perhaps be better after all?
The original problem (asyncdata.o linked in twice, causing duplicate
symbol definitions) could be fixed with this (admittedly somewhat
awkward) change to the Makefile (build tested):

--- linux-2.6.20-mm1-work/drivers/isdn/gigaset/Makefile 2007-02-20 13:39:=
44.000000000 +0100
+++ u/drivers/isdn/gigaset/Makefile     2007-02-20 13:38:58.000000000 +01=
00
@@ -1,7 +1,10 @@
 gigaset-y :=3D common.o interface.o proc.o ev-layer.o i4l.o
 usb_gigaset-y :=3D usb-gigaset.o asyncdata.o
 bas_gigaset-y :=3D bas-gigaset.o isocdata.o
-ser_gigaset-y :=3D ser-gigaset.o asyncdata.o
+ser_gigaset-y :=3D ser-gigaset.o
+ifneq ($(CONFIG_GIGASET_M101)$(CONFIG_GIGASET_M105),yy)
+ser_gigaset-y +=3D asyncdata.o
+endif

 obj-$(CONFIG_GIGASET_M105) +=3D usb_gigaset.o gigaset.o
 obj-$(CONFIG_GIGASET_BASE) +=3D bas_gigaset.o gigaset.o

The alternative would be to always link asyncdata.o into the gigaset
module whether it's needed or not. "size asyncdata.o" says:
   text    data     bss     dec     hex filename
   4200       0       0    4200    1068 asyncdata.o
which appears tolerable.

Opinions?

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigBBFDD3706E5F7D3DE1B996C0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF2v4LMdB4Whm86/kRAvNZAJoDwRaH51JxqooSgnCzHcX7/b52XwCfXdhG
kgo0+rVhBIwZmLkcwgta9+Y=
=bZxC
-----END PGP SIGNATURE-----

--------------enigBBFDD3706E5F7D3DE1B996C0--
