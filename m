Return-Path: <linux-kernel-owner+w=401wt.eu-S1760597AbXEJTmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760597AbXEJTmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909AbXEJTmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:42:12 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:42545 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179AbXEJTmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:42:12 -0400
Message-ID: <46437562.9050501@drzeus.cx>
Date: Thu, 10 May 2007 21:41:22 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_hera.drzeus.cx-5794-1178826130-0001-2"
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Flush mmc workqueue late in the boot sequence
References: <117879333788-git-send-email-hskinnemoen@atmel.com>	<46430A49.9090803@drzeus.cx>	<20070510143737.54969394@dhcp-252-105.norway.atmel.com>	<46432212.9070008@drzeus.cx>	<20070510163348.0a117d92@dhcp-252-105.norway.atmel.com>	<46434123.8040801@drzeus.cx> <20070510182749.219351cb@dhcp-252-105.norway.atmel.com>
In-Reply-To: <20070510182749.219351cb@dhcp-252-105.norway.atmel.com>
X-Enigmail-Version: 0.95.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-5794-1178826130-0001-2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Haavard Skinnemoen wrote:
> On Thu, 10 May 2007 17:58:27 +0200
> Pierre Ossman <drzeus@drzeus.cx> wrote:
>=20
> Is there any way this can happen? Host controller drivers register
> themselves from module_init(), their probe() function gets called,
> which calls mmc_add_host(), which schedules the initial scan. If
> multiple host controllers are present, they will all schedule their
> scans before all module_init()s have been called. Am I missing
> something?
>=20

You're assuming two things:

1. The bus the host controller reside on is synchronous both in adding de=
vices
and drivers. This is true for most buses, but not all. As we can see, the=
 MMC
bus is an example of one that isn't.

2. The bus the host controller reside on is scanned before any sync funct=
ion we add.

The second probably isn't much of a stretch, but the first is more likely=
 to
break. E.g. an usb based controller would not satisfy 1 as usb is scanned=

asynchronously. Platform devices are case by case (e.g. some device might=
 be
delayed since it needs time to power up).

>> Indeed. But it is not by design that they are scheduled before late_in=
itcall().
>> Also, flushing the workqueue is also not a by-design way of completing=
 a scan,
>> it just happens to be that way right now.
>=20
> So how is it supposed to work "by design"?
>=20

It isn't. The MMC bus is a pesky bugger in that it is slow and involves a=
 lot of
sleeping and asynchronous callbacks. As such, synchronisation needs to be=
 very
explicit using for example completions.

>>> And I never realized that using a block device as a parameter to the
>>> root=3D parameter could possibly be "unofficial" functionality...?
>> Then you've learned something new. ;)
>=20
> Guess so. It seems like the prepare_namespace stuff is getting less
> useful every day.
>=20

Probably. But I'd like to hope we're gaining more than we lose. There are=
 some
horror stories from the scsi camp where synchronous scanning means it tak=
es an
hour to boot a machine.

>> Only some devices work that way (generally only those with "simple" in=
terfaces).
>> And most things are these days behind more advanced buses, more akin t=
o a network.
>=20
> It's funny that NFS root does not have these kinds of problems then...
>=20

I'm not familiar with that code, but I would guess it has a whole bunch o=
f
prerequisite conditions. And the nfs root installations I've seen all use=

initrd, so I would assume there are some restrictions to letting the kern=
el
handle it.

>> Generally, not waiting for a lot of hardware is a good thing as it spe=
eds up
>> boot times. In my mind, the proper way is having a script in an initrd=
 that
>> waits for just the parts of the hardware that this particular system n=
eeds.
>> Everything else can be brought up in the background.
>=20
> Yeah, but I suspect most users will rather have a system that actually
> boots than a system that would have booted very quickly if it had boote=
d
> at all.
>=20

I think most people can live with having an initrd, so I wouldn't paint q=
uite
such a bleak picture.

> Btw, how can I wait for the scanning to complete from early userspace?
>=20

Monitor /proc/partitions or /sys until the device you need for rootfs sho=
ws up.


The big problem from my point of view is that I do not want to start prom=
ising
people a feature we might not be able to support in the future, and perha=
ps not
even now with some hardware.

Is there some reason you cannot use an initrd or is it just the inconveni=
ence?


Rgds
Pierre


--=_hera.drzeus.cx-5794-1178826130-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGQ3Vl7b8eESbyJLgRAt1uAKDSmnL0QHTM9fvEq7tziXC6e269FgCggGZr
baQLap1PvAMz5v3jkPg4EWI=
=DeJi
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-5794-1178826130-0001-2--
