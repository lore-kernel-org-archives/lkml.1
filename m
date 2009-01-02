Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbZABLWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbZABLWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 06:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbZABLWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 06:22:03 -0500
Received: from server.drzeus.cx ([85.8.24.28]:48704 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755803AbZABLWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 06:22:00 -0500
Date: Fri, 2 Jan 2009 12:21:48 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Andreas Mohr <andi@lisas.de>
Cc: Sriram V <vshrirama@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Power Management with rootfs on SDMMC.
Message-ID: <20090102122148.175cff4a@mjolnir.drzeus.cx>
In-Reply-To: <20090102102152.GA26603@rhlx01.hs-esslingen.de>
References: <8bf247760901012235v20bb448ch5c34fb2791ea83ca@mail.gmail.com>
	<20090102102152.GA26603@rhlx01.hs-esslingen.de>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-635-1230895318-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-635-1230895318-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 2 Jan 2009 11:21:52 +0100
Andreas Mohr <andi@lisas.de> wrote:

>=20
> There have been long threads on mobile phone and netbook related forums a=
bout issues
> with seemingly "any slightly advanced use whatsoever" of partitions on SD=
 cards.
>=20

As you may notice, you only get egg on your face when you suspend, so
it's really just the single problem. Granted, it's still a big one.

> IMHO in this strongly increasingly netbook- and mobile phone-enabled worl=
d it's
> a bloody shame that:
> - we have a hanging suspend/resume on an SD rootfs (often the only way of
>   achieving serious Linux use on a mobile phone!)

I take it this is without CONFIG_MMC_UNSAFE_RESUME.

The fundamental problem is that we have no way of detecting if a card
was removed during suspend, meaning we cannot guarantee that we'll
return the hardware to the upper layers in the same state it was
before the suspend.

There are two improvements that can be made here:

- Don't power down the card during suspend. This eats more power and
  might not be supported on all systems, but it allows us to detect any
  removal. This has been on my todo list for ages, but I haven't found
  any time to implement it (or even test if I have any systems that
  might support it).

- Have upper layers handle removal detection. E.g. in the common case
  of rootfs, the filesystem driver verifies that the storage is in the
  same state when it resumes as it was when it suspended. This requires
  a lot of work though as AFAIK there is no suspend functionality in
  either the block layer or the VFS.

> - we lose partition mounts due to full device re-probing instead of re-us=
ing the
>   same minor device ID after resume

This is a block layer issue, and I don't know if it's fixable.

Basically the problem is that someone is keeping the resources
associated with the pre-suspend block device pinned in memory. When the
post-suspend block device is created, it cannot reuse the device IDs
since they are still in use.

> - installing a swap partition on an SD card and then resuming can easily
>   go as far as __even completely corrupting__ the entire SD card partitio=
ning
>   plus first partition (corrupts first 1kB of the card: both table and pa=
rtition)
>   People then immediately resort to a non-helpful "Don't Do This, Ever" r=
eply
>   (using swap partition on SD and suspend, see http://dev.laptop.org/tick=
et/6532#comment:10),

Hmm... I was under the impression that they got this fixed nice and
proper. Perhaps comment 34 should be sent to lkml and/or added to the
kernel bugzilla.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-635-1230895318-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkld+NMACgkQ7b8eESbyJLhdNACfW74t9TgKyp+ah5wTKKo7bh+G
e2QAn1gMjMhXcRMY7LnOtIEvqwS1lYts
=iiAp
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-635-1230895318-0001-2--
