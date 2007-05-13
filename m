Return-Path: <linux-kernel-owner+w=401wt.eu-S934094AbXEMNgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934094AbXEMNgA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 09:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759846AbXEMNfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 09:35:45 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:39565 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758763AbXEMNfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 09:35:42 -0400
Message-ID: <464713FB.2060801@drzeus.cx>
Date: Sun, 13 May 2007 15:34:51 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_hera.drzeus.cx-951-1179063331-0001-2"
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Flush mmc workqueue late in the boot sequence
References: <117879333788-git-send-email-hskinnemoen@atmel.com>	<46430A49.9090803@drzeus.cx>	<20070510143737.54969394@dhcp-252-105.norway.atmel.com>	<46432212.9070008@drzeus.cx>	<20070510163348.0a117d92@dhcp-252-105.norway.atmel.com>	<46434123.8040801@drzeus.cx>	<20070510182749.219351cb@dhcp-252-105.norway.atmel.com>	<46437562.9050501@drzeus.cx> <20070511103905.08530507@dhcp-252-105.norway.atmel.com>
In-Reply-To: <20070511103905.08530507@dhcp-252-105.norway.atmel.com>
X-Enigmail-Version: 0.95.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-951-1179063331-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Haavard Skinnemoen wrote:
>=20
> You're right about my assumptions. Are there any existing drivers that
> break them? Are there even any usb-based controllers around? I though
> most usb-mmc controllers used the USB Mass Storage class and thus
> don't use the mmc subsystem at all.
>=20

Yes, but they might show up in the future. My point was that we know of
scenarios that will break this, so it won't be a universal solution (even=
 though
it might work right now).

>=20
> I see. The flush_workqueue approach might end up waiting for other
> things than just scanning, is that the problem? Would it be better to
> add a per-host "inital scan complete" completion that we could wait on
> instead?
>=20

That would be a cleaner solution yes. That way we don't exploit any curre=
nt
behaviour that might change in the future.

>=20
> I'm not sure how many embedded people actually know how to build an
> initrd for a custom board.
>=20

All the ones I have on my desk right now use initrd. ;)

>=20
> But if you don't want this issue fixed (i.e. you don't think of it as
> an issue) I guess I have to either start working on yet another initrd
> setup or just apply the patch to our vendor kernel and be done with it.=

> The latter certainly is the most tempting, but I suppose the former is
> more like how things are supposed to be done in the future.
>=20

Of course I see it as an issue. My concern is if we gain more than we los=
e.

I had a chat with David Woodhouse and Segher Boessenkool and I think we h=
ave
another approach. Basically, we move the waiting which would normally go =
into
the initrd and move it into the kernel. So you get something like:

"Waiting for root device /dev/mmcblk0p1..."

The only problem here is if the device never shows up, but if that was th=
e case
you would previously get a panic, so it should not be any worse.

Does that sound like something that would work for you? From my point of =
view
it's a much cleaner solution that has the benefit of not being tied into =
a
certain subsystem (i.e. this would "fix" usb aswell).

Rgds
Pierre


--=_hera.drzeus.cx-951-1179063331-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGRxP+7b8eESbyJLgRAjJLAJ44uFbI+woJ3I33mClA5WwounybnwCfbvc3
bA3nT99q5zJTd0B6iEyE5WI=
=nD3a
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-951-1179063331-0001-2--
