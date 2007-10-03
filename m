Return-Path: <linux-kernel-owner+w=401wt.eu-S1752659AbXJCEJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbXJCEJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 00:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbXJCEJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 00:09:49 -0400
Received: from ozlabs.org ([203.10.76.45]:60507 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbXJCEJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 00:09:48 -0400
Subject: Re: 2.6.23-rc7-mm1 -- powerpc rtas panic
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: Linas Vepstas <linas@austin.ibm.com>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20071003011909.GG9814@bakeyournoodle.com>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
	 <20070924123531.GC30855@shadowen.org>
	 <20071002232819.GN4338@austin.ibm.com>
	 <20071003002646.GD9814@bakeyournoodle.com>
	 <1191371416.8073.1.camel@concordia>
	 <20071003011909.GG9814@bakeyournoodle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IE+h7C1I63k+QydlU76X"
Date: Wed, 03 Oct 2007 14:09:46 +1000
Message-Id: <1191384586.8073.6.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IE+h7C1I63k+QydlU76X
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-03 at 11:19 +1000, Tony Breeds wrote:
> On Wed, Oct 03, 2007 at 10:30:16AM +1000, Michael Ellerman wrote:
> =20
> > I realise it'll make the patch bigger, but this doesn't seem like a
> > particularly good name for the variable anymore.
>=20
> Sure, what about?

Better .. but  ..   :D

> diff --git a/arch/powerpc/platforms/pseries/rtasd.c b/arch/powerpc/platfo=
rms/pseries/rtasd.c
> index 30925d2..73401c8 100644
> --- a/arch/powerpc/platforms/pseries/rtasd.c
> +++ b/arch/powerpc/platforms/pseries/rtasd.c
> @@ -54,8 +54,9 @@ static unsigned int rtas_event_scan_rate;
>  static int full_rtas_msgs =3D 0;
> =20
>  /* Stop logging to nvram after first fatal error */
> -static int no_more_logging;
> -
> +static int logging_enabled; /* Until we initialize everything,
> +                             * make sure we don't try logging
> +                             * anything */

Until we initialise what exactly?

>  static int error_log_cnt;
> =20
>  /*
> @@ -217,7 +218,7 @@ void pSeries_log_error(char *buf, unsigned int err_ty=
pe, int fatal)
>  	}
> =20
>  	/* Write error to NVRAM */
> -	if (!no_more_logging && !(err_type & ERR_FLAG_BOOT))
> +	if (logging_enabled && !(err_type & ERR_FLAG_BOOT))
>  		nvram_write_error_log(buf, len, err_type, error_log_cnt);
> =20
>  	/*
> @@ -229,8 +230,8 @@ void pSeries_log_error(char *buf, unsigned int err_ty=
pe, int fatal)
>  		printk_log_rtas(buf, len);
> =20
>  	/* Check to see if we need to or have stopped logging */
> -	if (fatal || no_more_logging) {
> -		no_more_logging =3D 1;
> +	if (fatal || !logging_enabled) {
> +		logging_enabled =3D 0;
>  		spin_unlock_irqrestore(&rtasd_log_lock, s);
>  		return;
>  	}

Hmmm, this routine has 4 separate lock-dropping exit paths ..

> @@ -302,7 +303,7 @@ static ssize_t rtas_log_read(struct file * file, char=
 __user * buf,
> =20
>  	spin_lock_irqsave(&rtasd_log_lock, s);
>  	/* if it's 0, then we know we got the last one (the one in NVRAM) */
> -	if (rtas_log_size =3D=3D 0 && !no_more_logging)
> +	if (rtas_log_size =3D=3D 0 && logging_enabled)
>  		nvram_clear_error_log();
>  	spin_unlock_irqrestore(&rtasd_log_lock, s);
> =20
> @@ -414,6 +415,8 @@ static int rtasd(void *unused)
>  	memset(logdata, 0, rtas_error_log_max);
>  	rc =3D nvram_read_error_log(logdata, rtas_error_log_max,
>  	                          &err_type, &error_log_cnt);
> +	/* We can use rtas_log_buf now */
> +	logging_enabled =3D 1;
> =20
>  	if (!rc) {
>  		if (err_type !=3D ERR_FLAG_ALREADY_LOGGED) {

What exactly happens that allows us to do logging? I don't see any
ordering between anything else and the setting of the flag, and AFAICT
we're not inside a spinlock or anything here.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-IE+h7C1I63k+QydlU76X
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHAxYKdSjSd0sB4dIRAqkaAJ0cNctprskMb5oWy/KmBIofza+zYQCePtvw
mNDfo7zbAHKRe9d4cDiPCM8=
=FpEp
-----END PGP SIGNATURE-----

--=-IE+h7C1I63k+QydlU76X--

