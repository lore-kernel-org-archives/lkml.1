Return-Path: <linux-kernel-owner+w=401wt.eu-S1946330AbXBQADk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946330AbXBQADk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 19:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946333AbXBQADk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 19:03:40 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:40007 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946330AbXBQADj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 19:03:39 -0500
X-Sasl-enc: n3JW30b0ttPf933DCBTxl2W6AINOsG1VJhgKJLY5caBr 1171670636
Message-ID: <45D64691.8070901@imap.cc>
Date: Sat, 17 Feb 2007 01:04:33 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Hansjoerg Lipp <hjlipp@web.de>, gigaset307x-common@lists.sourceforge.net,
       kkeil@suse.de, kai.germaschewski@gmx.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
Subject: Kbuild problem (was: [2.6 patch] drivers/isdn/gigaset/: build asyncdata.o
 into the gigaset module)
References: <20070215215638.GI13958@stusta.de> <45D4F80F.8040200@imap.cc> <20070216083339.GK13958@stusta.de>
In-Reply-To: <20070216083339.GK13958@stusta.de>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig44077C0FF51720E85C4C85E9"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig44077C0FF51720E85C4C85E9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 16.02.2007 09:33 schrieb Adrian Bunk:
>>> ...
>>>   LD      drivers/isdn/gigaset/built-in.o
>>> drivers/isdn/gigaset/ser_gigaset.o: In function `gigaset_m10x_send_sk=
b':
>>> (.text+0xe50): multiple definition of `gigaset_m10x_send_skb'
>>> drivers/isdn/gigaset/usb_gigaset.o:(.text+0x0): first defined here
>>> drivers/isdn/gigaset/ser_gigaset.o: In function `gigaset_m10x_input':=

>>> (.text+0x1121): multiple definition of `gigaset_m10x_input'
>>> drivers/isdn/gigaset/usb_gigaset.o:(.text+0x2d1): first defined here
>>> make[4]: *** [drivers/isdn/gigaset/built-in.o] Error 1

> CONFIG_ISDN_DRV_GIGASET=3Dy
> CONFIG_GIGASET_BASE=3Dy
> CONFIG_GIGASET_M105=3Dy
> CONFIG_GIGASET_M101=3Dy

Ah, thanks, I can see what's happening now. When both the M101 and M105
drivers are built into the kernel, asyncdata.o gets linked in twice, via

	usb_gigaset-y :=3D usb-gigaset.o asyncdata.o
	obj-$(CONFIG_GIGASET_M105) +=3D usb_gigaset.o gigaset.o

and

	ser_gigaset-y :=3D ser-gigaset.o asyncdata.o
	obj-$(CONFIG_GIGASET_M101) +=3D ser_gigaset.o gigaset.o

The assertion in Documentation/kbuild/makefiles.txt:

        The order of files in $(obj-y) is significant.  Duplicates in
        the lists are allowed: the first instance will be linked into
        built-in.o and succeeding instances will be ignored.

doesn't work out in this case because asyncdata.o isn't added directly
to $(obj-y), but as part of usb_gigaset.o and ser_gigaset.o.

I'm not quite happy with your solution, though. I'd prefer a
Makefile which builds modular usb_gigaset.ko and/or ser_gigaset.ko
like the present one (including asyncdata.o), but when linking
usb-gigaset.o and ser-gigaset.o into the kernel includes asyncdata.o
only once. Trouble is, I don't know how to express that in Kbuild.

Any ideas?

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig44077C0FF51720E85C4C85E9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF1kaaMdB4Whm86/kRAqS9AJ9UfpK/PgPyWEygO6cuR7I3nDkmlQCfdEK6
JMdNRA/DcxR7YXDRwEH7p1g=
=SkQk
-----END PGP SIGNATURE-----

--------------enig44077C0FF51720E85C4C85E9--
