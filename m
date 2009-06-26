Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbZFZGEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbZFZGEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 02:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbZFZGEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 02:04:32 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:9368 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbZFZGEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 02:04:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=pUydVdq8lXotZ66kpgT5QtQC3boB/TUB8TZpIVcO3QWpLgsp8gOBkd/xnnSSG8WuD0
         JVCFp9/Gm4ebcpjMMzVcpPDYLje/W0g4XOGPtunKOJYq5LGwUtK504YPFP+NpxONAzxn
         z9oCzIIMYnAPv/zqDlP1sWTxqpwTVOpdRDj5E=
Subject: Re: [PATCH] PCAP regulator driver (for 2.6.32).
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       David Brownell <dbrownell@users.sourceforge.net>
In-Reply-To: <20090625233723.GA13150@sirena.org.uk>
References: <1245961793.10360.26.camel@brutus>
	 <20090625233723.GA13150@sirena.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8X2+TfUwdBmkyhh7TOM4"
Date: Fri, 26 Jun 2009 03:04:23 -0300
Message-Id: <1245996263.10360.122.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8X2+TfUwdBmkyhh7TOM4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Em Sex, 2009-06-26 =C3=A0s 00:37 +0100, Mark Brown escreveu:
> On Thu, Jun 25, 2009 at 05:29:53PM -0300, Daniel Ribeiro wrote:
> > +	/*
> > +	 * The regulator framework doesn't like regulators which default
> > +	 * to ON at boot time, so we just disable it here (when it is safe).
> > +	 */
> > +	if (pdev->id =3D=3D VAUX2 || pdev->id =3D=3D VAUX3)
> > +		pcap_regulator_disable(rdev);
>=20
> No need to do this - the regulator framework is perfectly happy with
> regulators that are enabled at boot time and turning regulators that are
> actively being used off is likely to cause issues.  Regulator drivers
> should just leave everything as they find it and leave it up to the core
> and machine drivers to make any changes.

Humm, I still see:

        if (WARN(rdev->use_count <=3D 0,
                        "unbalanced disables for %s\n",
                        rdev->desc->name))
                return -EIO;

So, the regulator is enabled at boot, but it can't be disabled because
use_count is 0. This is the same issue as twl4030-mmc, but instead of a
enable/disable pair on pxamci.c i opted to disable it at pcap's
regulator probe(). VAUX2 and VAUX3 are only used for MMC on all the
hardware that I know of, so it is safe.

Also, on regulator_init_complete() the regulator core disables all
regulators which have a use_count =3D=3D 0. So, its kind of funny that if I
don't disable the regulator at boot(so mmc_core does enable() it), the
timing causes regulator_init_complete() to auto-disable the regulator
right when pxamci.c is probing the card.

I can move this hack to pxamci.c if you want me to (as David did for
twl4030), but this issue really should be fixed on regulator/core.c:

With the current code if you use a regulator which can be disabled as
the supplier for the CPU core, then the regulator framework will power
off the CPU at boot.

Maybe you should simply allow disable() if use_count is 0, and not
auto-disable() on regulator_init_complete() ?

--=20
Daniel Ribeiro

--=-8X2+TfUwdBmkyhh7TOM4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpEZOcACgkQw3OYl0G0liTqXgCcDfn++5U4WkUbA0DM2P5Rlr4s
Q7EAoIHWn2t+dHIUpVK/Ewe/wFi4trQI
=7Qxx
-----END PGP SIGNATURE-----

--=-8X2+TfUwdBmkyhh7TOM4--

