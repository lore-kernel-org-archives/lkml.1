Return-Path: <linux-kernel-owner+w=401wt.eu-S1752956AbZG2HTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbZG2HTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 03:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbZG2HTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 03:19:55 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:37217 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZG2HTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 03:19:54 -0400
Subject: Re: 31-rc3-mmotm0716 - wonky wireless statistics..
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1248831078.3747.1117.camel@debian>
References: <5934.1248814870@turing-police.cc.vt.edu>
	 <1248831078.3747.1117.camel@debian>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-f4FY58J+oUxAJBL7zAfQ"
Date: Wed, 29 Jul 2009 09:19:12 +0200
Message-Id: <1248851953.13742.12.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-f4FY58J+oUxAJBL7zAfQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-29 at 09:31 +0800, Zhu Yi wrote:

> > # cat /proc/net/wireless
> > Inter-| sta-|   Quality        |   Discarded packets               | Mi=
ssed | WE
> >  face | tus | link level noise |  nwid  crypt   frag  retry   misc | be=
acon | 22
> >  wlan0: 0000   63.  -47.  -256        0      0      0      0      0    =
    0
> >  wlan1: 0000    0     0     0        0      0      0      0      0     =
   0
> >  wlan2: 0000    0     0     0        0      0      0      0      0     =
   0
> >=20
> > Where did that -256 for "noise" come from?  It ends up confusing the
> > gkrellm-wifi plugin, it reports a S/N of 219dB ;)
>=20
> This should be related to http://git.kernel.org/?p=3Dlinux/kernel/git/lin=
ville/wireless-testing.git;a=3Dcommit;h=3Dfdb897ea5c77836f890033d563336ab0c=
94c9222
>=20
> But I don't think this is an ABI broken. User space should parse the
> trailing '.' to see if a field is updated or not because there are cards
> not capable to report hardware noise level anyway. Johannes?

So I had to look at the code to figure out wtf is going on.

Then the value shown is calculated as:
	((__s32) stats->qual.noise) - ((stats->qual.updated & IW_QUAL_DBM) ? 0x100=
 : 0)

and since we have dBm for the signal strength (and dBm is "all or
nothing") you get -256 since we don't fill noise right now.

However, it goes on like this:
	stats->qual.updated & IW_QUAL_NOISE_UPDATED ? '.' : ' '

so you're right -- the tool shouldn't be using the value unless followed
by a dot (".").

Thus, your analysis is correct as far as I can tell -- it's a userspace
bug and your userspace just happened to work correctly with this card,
but would have been broken with almost all other wireless cards.

johannes

--=-f4FY58J+oUxAJBL7zAfQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKb/ftAAoJEODzc/N7+QmaXHEQAKCZi1mLwi6gkqCj+OqCw6dX
jdYNfDRDi3+GSoSmjZgfg1/P/EC/XtsDj+F5ijLjHfj4uk8OqJqlteWfllbcfH9X
TGjEGZizUlsQPXuFHLHa0MIWNvakzweGfiST5CxdOFSbiaPxQ1xWwsi8ky6QFNoI
n1iNdF4ZJK6f2nQU0jv9jHeTdZPL5y1RcxXf7YaWoFw6lzMP1ke8FXIlr6c9BEMK
aaM+OSzpTo+Lm2+k+PB8Ey2KOxrakcBcPtvqWQGP+PnOxNVs71ra2kScjFQCkdqY
e3ZidN21rNg5G3tP/iCPSma4reRLwPFhXA95cFdfllBUFdnIdvzqopuGo5aBct8O
b0ooe8Lwg8fghKGxq13FF33cDAsBLXsbes/t9zTZDh7r40U8OlfvoSSmPfZJ/qEP
E6zdTiAgpCBL/nfjHvCZA/LPgqqT3MeGDCv095SdHwtGamt/jKqyPJWMRpU34mzb
ESgd641IH9qd4sSBtzFi1AmuJzoHFzBzCCHUDQwEKwYArUTrUU368mpYlYRqpbHa
IvBFofAeOxfNRfRkUy9YB/JczOeE3cx8PrCH+iHSLh8XGm5AmxI2pDHwqivrJh3z
E2Wqmv76AP6TThJ8RJTi1/rGoIjHrkVqNerr+IISDXzqXhOFcWJCLGprZl0EIfwW
w7R8A5fJkFEt/8IhRcY3
=DD4g
-----END PGP SIGNATURE-----

--=-f4FY58J+oUxAJBL7zAfQ--

