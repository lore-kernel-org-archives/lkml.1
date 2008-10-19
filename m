Return-Path: <linux-kernel-owner+w=401wt.eu-S1751501AbYJSM26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbYJSM26 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 08:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbYJSM2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 08:28:50 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:55635 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751219AbYJSM2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 08:28:49 -0400
X-Sasl-enc: m5tGO2qsfCKvZiro/seRf/TKfTpo8sxufyVgFiGkoSN1 1224419327
Message-ID: <48FB27F1.9010007@imap.cc>
Date: Sun, 19 Oct 2008 14:28:33 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Hansjoerg Lipp <hjlipp@web.de>
Subject: Re: [PATCH 72/80] tty: fix up gigaset a bit
References: <20081013092758.21645.2359.stgit@localhost.localdomain>	<20081013094438.21645.30934.stgit@localhost.localdomain>	<48F762CA.4080608@imap.cc> <20081017124004.64d3f2cf@lxorguk.ukuu.org.uk>
In-Reply-To: <20081017124004.64d3f2cf@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig61329DC5304200D04BCBEE89"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig61329DC5304200D04BCBEE89
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Scripsit Alan Cox die 17.10.2008 13:40:
>>>  	/* prevent other callers from entering ldisc methods */
>>> +	/* FIXME: should use the tty state flags */
>>>  	tty->disc_data =3D NULL;
>>> =20
>>>  	if (!cs->hw.ser)
>>=20
>> Do you know of an example line discipline that has got this right?
>> My model for this code was drivers/net/ppp_async.c but now it seems
>> that this was not as exemplary as I had hoped.
>=20
> If you want to know if the tty has been closed for further I/O then you=

> can use test_bit(TTY_IO_ERROR, &tty->flags). This gets set at the right=

> points on close/hangup/etc.

Ok, but where do you see a need for such a test? AFAICS I have covered
all the eventualities without resorting to an explicit tty->flags test,
and looking around among my LD brethren it looks like they came to the
same conclusion. (Not that I'd want to pull the "a million flies can't
be wrong" card. ;-) Can you point me to a place or situation where an
additional test_bit(TTY_IO_ERROR, &tty->flags) would catch a case that
would otherwise be handled incorrectly?

>> Looking around, I see that many LDs don't even provide a poll method.
>> So I'm thinking of just dropping this one. Would that be ok?
>=20
> PPP doesn't route characters via the tty interface while you seem to do=

> so for the AT emulation so you do need it.

Actually I don't. The AT command interface is accessed through a
separate tty interface created by the main module of the Gigaset driver
in drivers/isdn/gigaset/interface.c.

(The reason for that is that ser_gigaset is just one of three hardware
backends for accessing Gigaset devices, and the only one with an
existing tty device. I have to create my own AT command interface
device for the other two, anyway. Specialcasing ser_gigaset in order to
route that back to the tty device of the serial port would just
complicate things needlessly.)

So I think removing the poll method is the right thing to do. If you
have no objections, I'll submit a patch doing just that. (Hoping to
still make it for the .28 merge window.)

Thanks,
Tilman


--------------enig61329DC5304200D04BCBEE89
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFI+yf8Q3+did9BuFsRAuVGAJ9sRNSxr+IMCH9/d644MkpE7jcW5ACgm0zf
/wLANUAzwjSVMtO31xu77LY=
=20rt
-----END PGP SIGNATURE-----

--------------enig61329DC5304200D04BCBEE89--
