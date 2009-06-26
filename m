Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZFZW10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZFZW10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 18:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZFZW1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 18:27:12 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:17485 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707AbZFZW1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 18:27:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=Ph3LmyD5APTFx5E1L3fVnvu9zL19I1P9yAQA0MyYr2tolTzhx6fiMfPF7+yiB2HFHo
         YkSUj9tW6Nd2W54xvYOyLJea8oqxP3fCZBKu+hyA369hLDguFlHV4DI/L5GY6Pik0Xew
         57GHQ9JbGxAuYD18Lk4uUQKhp2cZgClz6MgFk=
Subject: Re: [PATCH] PCAP regulator driver (for 2.6.32).
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Pierre Ossman <pierre@ossman.eu>
In-Reply-To: <20090626150849.GA5504@sirena.org.uk>
References: <1245961793.10360.26.camel@brutus>
	 <20090625233723.GA13150@sirena.org.uk> <1245996263.10360.122.camel@brutus>
	 <20090626105550.GE5415@sirena.org.uk> <1246019192.10360.202.camel@brutus>
	 <20090626150849.GA5504@sirena.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-bbZDxfxw2UtDH4thRGW8"
Date: Fri, 26 Jun 2009 19:26:55 -0300
Message-Id: <1246055215.10360.273.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bbZDxfxw2UtDH4thRGW8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Em Sex, 2009-06-26 =C3=A0s 16:08 +0100, Mark Brown escreveu:
> > If the above is not possible, then regulator_is_enabled() doesn't match
> > regulator_enable()/regulator_disable() pair. Maybe the API should make
> > this clear?
>=20
> Frankly I'm not sure how much any documentation is going to help here.
> There's already a note about the fact that the regulator might've been
> enabled elsewhere, it could be strengthened a bit but it still relies on
> people reading it.

I wasn't talking about documentation.

> Fundamentally, if your consumer is trying to explicitly force the
> regulator off then it's not able to cope with the regulator being
> shared.  I suspect that if someone does add a non-shared API then the
> problem will go away, half the problem is with consumers thinking they
> have exclusive use of the regulator.

The consumer (pxamci.c with the logic implemented on mmc/core.c) is not
trying to explicitly force the regulator off. It is trying to know if
itself has previously enabled the regulator.

The problem is that regulator_is_enabled returns the regulator
_hardware_ state, and regulator_enable/regulator_disable are used to
update the use_count. This is an API inconsistency as the consumer
should keep an internal use_count and _not_ rely on
regulator_is_enabled.

I see no point in exporting regulator_is_enabled() as it is now. There
is no use in a consumer driver to know if the regulator _hardware_ is
enabled (as it may be shared).

So, if the regulator framework has no bugs regarding regulators left on
by the bootloader, then maybe the buggy code is mmc/core.c?

int mmc_regulator_set_ocr(struct regulator *supply, unsigned short vdd_bit)
{
	...
	int enabled;

	enabled =3D regulator_is_enabled(supply);
	...
	if (vdd_bit) {
		...
		if (result =3D=3D 0 && !enabled)
			result =3D regulator_enable(supply);
	} else if (enabled) {
		result =3D regulator_disable(supply);
	}
	return result;
}

Anyway, I don't have more time to spend on this issue, so i will just do
as you request, remove the workaround from pcap_regulator.c and put it
on pxamci.c, even if I think that this is the ugliest solution so far.

--=20
Daniel Ribeiro

--=-bbZDxfxw2UtDH4thRGW8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpFSy8ACgkQw3OYl0G0liT67ACfe7tIBz+hPmX7TE+sGVB45f13
zfkAnRitDhh7X/hVeE5v1HBwsXytZUtJ
=t0GG
-----END PGP SIGNATURE-----

--=-bbZDxfxw2UtDH4thRGW8--

