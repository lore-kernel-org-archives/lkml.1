Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbZD2LV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbZD2LV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbZD2LVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:21:14 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:56128 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZD2LVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:21:13 -0400
Subject: Re: [PATCH] [RFC] EEE PC hangs when booting off battery
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: John Linville <linville@tuxdriver.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <49F83699.3000307@tuffmail.co.uk> (sfid-20090429_131440_091368_7AEAE289)
References: <49E065CF.6040408@tuffmail.co.uk>
	 <200904140859.02188.bjorn.helgaas@hp.com>
	 <20090414081728.10de978a@infradead.org>
	 <200904140948.37633.bjorn.helgaas@hp.com> <49E5F01B.2060201@tuffmail.co.uk>
		 <49EF0ABD.2080801@tuffmail.co.uk> <49F446AE.6070607@tuffmail.co.uk>
		 <49F6CA0E.5040101@tuffmail.co.uk>
	 (sfid-20090428_111942_198975_13CDA6F5) <1240912688.28835.10.camel@johannes.local>
	 <49F6DA14.7030608@tuffmail.co.uk>  <49F83699.3000307@tuffmail.co.uk>
	 (sfid-20090429_131440_091368_7AEAE289)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Mk4g2MVEm2fjMXdzbIOQ"
Date: Wed, 29 Apr 2009 13:20:35 +0200
Message-Id: <1241004035.593.59.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Mk4g2MVEm2fjMXdzbIOQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-04-29 at 12:14 +0100, Alan Jenkins wrote:

> From c5e9dc036247e70956d1a28e8850c3810385dda0 Mon Sep 17 00:00:00 2001
> From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Date: Wed, 29 Apr 2009 11:41:24 +0100
> Subject: [PATCH] mac80211: fix modprobe deadlock by not calling wep_init =
under rtnl_lock
>=20
>  - ieee80211_wep_init(), which is called with rtnl_lock held, blocks in
>    request_module() [waiting for modprobe to load a crypto module].
>=20
>  - modprobe blocks in a call to flush_workqueue(), when it closes a TTY
>    [presumably when it exits].
>=20
>  - The workqueue item linkwatch_event() blocks on rtnl_lock.
>=20
> There's no reason for wep_init() to be called with rtnl_lock held, so
> just move it outside the critical section.

Looks correct to me.

> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/main.c |   19 +++++++++----------
>  1 files changed, 9 insertions(+), 10 deletions(-)
>=20
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index fbcbed6..00968c2 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -909,6 +909,13 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  	if (result < 0)
>  		goto fail_sta_info;
> =20
> +	result =3D ieee80211_wep_init(local);
> +	if (result < 0) {
> +		printk(KERN_DEBUG "%s: Failed to initialize wep: %d\n",
> +		       wiphy_name(local->hw.wiphy), result);
> +		goto fail_wep;
> +	}
> +
>  	rtnl_lock();
>  	result =3D dev_alloc_name(local->mdev, local->mdev->name);
>  	if (result < 0)
> @@ -930,14 +937,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  		goto fail_rate;
>  	}
> =20
> -	result =3D ieee80211_wep_init(local);
> -
> -	if (result < 0) {
> -		printk(KERN_DEBUG "%s: Failed to initialize wep: %d\n",
> -		       wiphy_name(local->hw.wiphy), result);
> -		goto fail_wep;
> -	}
> -
>  	/* add one default STA interface if supported */
>  	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION)) {
>  		result =3D ieee80211_if_add(local, "wlan%d", NULL,
> @@ -967,13 +966,13 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
> =20
>  	return 0;
> =20
> -fail_wep:
> -	rate_control_deinitialize(local);
>  fail_rate:
>  	unregister_netdevice(local->mdev);
>  	local->mdev =3D NULL;
>  fail_dev:
>  	rtnl_unlock();
> +	ieee80211_wep_free(local);
> +fail_wep:
>  	sta_info_stop(local);
>  fail_sta_info:
>  	debugfs_hw_del(local);

--=-Mk4g2MVEm2fjMXdzbIOQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ+DgAAAoJEKVg1VMiehFY2jEP/i8N6nb5Yf36NBmlzfDCLoM0
lFnjwskD7vxYp9B6SECEqHQMN+0Obx0ed29OLQzhePjBdgpkjVgoMfr9RfEHQ0OP
rFYPdnJ0xzi7lytoX69iI1hcA9jynbAml48nLmbR2VGPtxq/1L3Pj93gz+02Xjxv
7dfcu/yWUZQyIxUwuMGD8kHk7SR7gSv3ep8VuOmYWJWsD3a419D9PRnnlfmByzM2
725irprTaSnYfWiqbek5EqIG5xYDVdWJFhtpAyq6+k6B1T2JJEnX/AlCZeab59Da
g2WcGvbTbgvE4/u7AHOaoj7GJIlATSz8mdYKn6PqsM+yDrPREVC+lKF0M2Lar4Rq
WYKEcIhEOErsomHleWBzl7vJfbBerijMSEnVzmNPpSDKThcZqzZcropwMRKKr5Me
hOjw9sWo5WtTRIXP3zBBjiEPDHsIYc8gOIi29LQUod/o7SG5jGRpENTPgK4OmIlX
Lj05oBgVOEBiWFcCMKhsA6SuzI8A5T+68waHpKu63RE7k1tpWCppeVAZz//MKjjp
qSEmp62pPjfwYvdE5yQgzpZ74JEfCf6V6jjWV15F7IipHA1JwQKMx9TWGDBS99qf
YhruFQ6cxN/rPRYT5KPLsGZWcF2ninHGNVK9wEMJz5PIxysuwnlrvwc1A3bR5QvT
8UgMsQrnVKO9+Hp+iXKE
=zl/S
-----END PGP SIGNATURE-----

--=-Mk4g2MVEm2fjMXdzbIOQ--

