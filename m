Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbYLBXbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbYLBXbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 18:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbYLBXbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 18:31:04 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51596 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbYLBXbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 18:31:02 -0500
Date: Wed, 3 Dec 2008 10:30:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nicolas Palix <npalix@diku.dk>
Cc: Jean Delvare <khali@linux-fr.org>, Paul Mackerras <paulus@samba.org>,
       Stelian Pop <stelian@popies.net>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH linux-next] hwmon/ams: Add missing of_node_put in
 ams-core.c
Message-Id: <20081203103051.f2f59c9f.sfr@canb.auug.org.au>
In-Reply-To: <200812021448.13543.npalix@diku.dk>
References: <200812021448.13543.npalix@diku.dk>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Dec_2008_10_30_51_+1100_R8tHdBYwG48n87cF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Dec_2008_10_30_51_+1100_R8tHdBYwG48n87cF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 2 Dec 2008 14:48:13 +0100 Nicolas Palix <npalix@diku.dk> wrote:
>
> of_node_put is needed before discarding a value received from
> of_find_node_by_name, eg in error handling code or when the device
> node is no longer used.
>=20
> Signed-off-by: Nicolas Palix <npalix@diku.dk>
> Signed-off-by: Julia Lawall <julia@diku.dk>
> ---
>  drivers/hwmon/ams/ams-core.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/hwmon/ams/ams-core.c b/drivers/hwmon/ams/ams-core.c
> index 6c9ace1..e612af9 100644
> --- a/drivers/hwmon/ams/ams-core.c
> +++ b/drivers/hwmon/ams/ams-core.c
> @@ -202,6 +202,7 @@ int __init ams_init(void)
>  	if (np && of_device_is_compatible(np, "AAPL,accelerometer_1"))
>  		/* Found I2C motion sensor */
>  		return ams_i2c_init(np);
> +	of_node_put(np);

This is wrong because if CONFIG_SENSORS_AMS_PMU is set, np is used again
below.

>  #endif
> =20
>  #ifdef CONFIG_SENSORS_AMS_PMU
> @@ -209,6 +210,7 @@ int __init ams_init(void)
>  	if (np && of_device_is_compatible(np, "sms"))
>  		/* Found PMU motion sensor */
>  		return ams_pmu_init(np);
> +	of_node_put(np);
>  #endif
>  	return -ENODEV;
>  }

Also, I don't like this code since each of ams_i2c_init and ams_pmu_init
keep a reference to np, so they should be doing an of_node_get(np) and
this code above should be unconditionally doing an of_node_put(np).  This
is not your problem, though.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__3_Dec_2008_10_30_51_+1100_R8tHdBYwG48n87cF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk1xSsACgkQjjKRsyhoI8xg4QCgidp8doUQip5FfPunS8ODBknh
oY8An3ABeSbIFNkSTaXR2WTCFToOYqu6
=Hbe4
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Dec_2008_10_30_51_+1100_R8tHdBYwG48n87cF--
