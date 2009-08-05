Return-Path: <linux-kernel-owner+w=401wt.eu-S933456AbZHEFDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456AbZHEFDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 01:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933237AbZHEFD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 01:03:27 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:35448 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbZHEFD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 01:03:26 -0400
Subject: Re: regression IWl3945 - doesn't work with recent 2.6.30-rcX
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1249422260.30019.4553.camel@rc-desk>
References: <c4e36d110904220333u37304c79k6ab528f92b5f3718@mail.gmail.com>
	 <20090422140107.GD3288@tuxdriver.com>
	 <c4e36d110904241218x209a4b76kf271f7288f1a33da@mail.gmail.com>
	 <c4e36d110904270059m3e43d6ccl18cc2ec6954e5649@mail.gmail.com>
	 <1240959723.1207.104.camel@rc-desk>
	 <c4e36d110908040807s1778f392o941748fd2c373d4a@mail.gmail.com>
	 <1249422260.30019.4553.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-h3Kmlm/dTKtO+YYyFiwl"
Date: Wed, 05 Aug 2009 07:03:19 +0200
Message-Id: <1249448599.4168.6.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.4 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-h3Kmlm/dTKtO+YYyFiwl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Reinette,

> I think I can see how this could happen. From what I can tell there is
> no checking if a scan is in progress when userspace triggers a new scan.

There isn't anywhere in mac80211, but all scans are now triggered by
cfg80211, which does the checking.

> ieee80211_scan -> ieee80211_request_scan -> __ieee80211_start_scan
> without local->hw_scanning or local->sw_scanning being checked.
>=20
> Considering this the above warning could happen in the following
> scenario:
> * userspace triggers scan, this sets local->hw_scanning and goes off
> scanning
> * userspace triggers another scan, even though local->hw_scanning is set
> it continues anyway and calls the drivers scanning function, this
> function returns error (which will cause ieee80211_scan_completed to be
> called) or calls ieee80211_scan_completed immediately because it is
> still busy with previous scan
> * now original scan completes and it tries to call
> ieee80211_scan_completed, but this triggers the warning because previous
> call of ieee80211_scan_completed cleared local->hw_scanning

Due to the check in cfg80211, I don't see how this could possibly
happen. But there are IWL_DEBUG_MAC80211 calls, so it should be easy to
figure it out if reproducible.

Zdenek, are you taking the interface down at the same time maybe? I
could see a race condition here where mac80211 assumes the scan must
have finished when the interface goes down, and maybe iwlwifi does that
too or something. Haven't looked at the code right now.

johannes

--=-h3Kmlm/dTKtO+YYyFiwl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKeRKTAAoJEODzc/N7+QmaUHwP/RKQDUWvmJXyoY5ic1b67VOL
/zpMPcd36c7PuO00cucafobFtMkysfhIHorfgBSaC7ku58GtTWSHURcpf+vjhffJ
VUcPmF28eoBBgxfRfYWmgFMywk5jguL6RIpA6MpyGZ0ighgtqvpZywjpahD6GAln
x3sitX6swoFSaAH1byknlpZPDns7HfaC7Va5cX6Ti5kpl5klbUfSYTtP1lzm4fj6
vLZX+Mhlk3g+BbcvPIeXwD6M1zgtlizylBIGNoc1BqAfyKHGY3GhuPNZCsGTrKxG
YKHuRPAT7yZcaz5qCXOXC4uY85HAk9kxXYfcGUH5TtcY2Tw06SLT+wdJjv0MM/0N
3lBsNQ6JB5MCkNFmL9/KBArPaZ7xBwdS8oRp82BOyBPzpslX035+pTOdQyoODRH2
4z67DnWHb/VsEultZfVSxitCjYFOhnUV5SaExb6SzSjwKUOURyUz8F4ME60365uR
DqTca+rrvAfwpE60OKnccinB6QeUqOEAkNPXwn4NHfRW/S3v8AG8V4BvYSEF+9Es
Nlwi/RXRr/ZW4P1jc8Ey3jbkBQ9YKXI5rkKcA6vZov8365gL5u6Rrsxo7/uym3bL
gBCv1gjirI1TrjH0Mhoq731pN0b6ghRFG05sju6asp7aX9qu2NwYs3iRFdH+XaVl
I1c0EgM9Q6Gyk63pN88a
=kYaw
-----END PGP SIGNATURE-----

--=-h3Kmlm/dTKtO+YYyFiwl--

