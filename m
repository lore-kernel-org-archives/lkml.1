Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbXENWeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbXENWeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbXENWeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:34:16 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35619 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754775AbXENWeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:34:15 -0400
X-Sasl-enc: LaJ6teOk+enXfGU49q1ai4uGPLCddkEio5ZQs7+ZSaUU 1179182055
Message-ID: <4648E4A4.60309@imap.cc>
Date: Tue, 15 May 2007 00:37:24 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: "Lars K.W. Gohlke" <lkwg82@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
References: <46485D84.1010902@gmx.de>
In-Reply-To: <46485D84.1010902@gmx.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig97950D41FD2E1DC1B2B5D8DF"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig97950D41FD2E1DC1B2B5D8DF
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 14.05.2007 15:00 schrieb Lars K.W. Gohlke:
> after searching the mailing list and searching the web, I still don't
> know how to access correctly the serial port (in user space known as
> /dev/ttyS01)

I can only tell you how I did it in the special case of the
ser_gigaset driver which drives an ISDN device attached to
a serial port: I implemented it as a line discipline which
is associated to the appropriate serial port by a userspace
daemon.

Reading material:

Documentation/tty.txt
	documentation on the line discipline interface
include/linux/tty.h
include/linux/tty_ldisc.h
	definitions for same
drivers/isdn/gigaset/ser-gigaset.c
	my code - a simple example of abusing the line
	discipline interface for your own ends :-)

> would somebody be so kind to give me an example:

I hope the following will help you some. If not, feel free to
ask again.

> with this behaviour:
>=20
> 1. read from port

That's not how things work in the kernel. There is no system
call for reading some data that has arrived on that port or
blocking if there is none, like a userspace program would do.
Instead, when you register your line discipline you provide
a callback function (receive_buf) for the serial driver to
call when data has been received. That function can be called
at any time and has to deal with the data as it gets it.

> 2. output via printk()

You can of course put a printk() in your receive_buf function.
But ultimately you'll want to do more than that with the data,
I'm sure.

> 3. write to port

That's easy. :-) No, it isn't. The serial driver *does*
provide a function (aptly called "write") for sending data
to the serial port, but you can't just call it any time you
like. You have to synchronize with the driver by waiting for
it to call your "write_wakeup" callback before you can call
its write function again.

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig97950D41FD2E1DC1B2B5D8DF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGSOSlMdB4Whm86/kRAjkNAJ4njMaWzazw1qk1xk4I8NdGw1BK0wCfcOWJ
OtI/5CCNq+jnzNTKr4qm4wU=
=nJ8j
-----END PGP SIGNATURE-----

--------------enig97950D41FD2E1DC1B2B5D8DF--
