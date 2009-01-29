Return-Path: <linux-kernel-owner+w=401wt.eu-S1758321AbZA2AnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321AbZA2AnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:43:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757865AbZA2Am0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 19:42:26 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:36325 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757784AbZA2AmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 19:42:24 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Subject: Re: [PATCH RFC] sh: maple: Add support for SEGA Dreamcast VMU and clean up maple bus driver (1/3)
Date: Wed, 28 Jan 2009 19:42:20 -0500
User-Agent: KMail/1.10.4 (Linux/2.6.28; KDE/4.1.4; x86_64; ; )
Cc: Paul Mundt <lethal@linux-sh.org>, Greg KH <greg@kroah.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       dwmw2 <dwmw2@infradead.org>, "linux-sh" <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-input" <linux-input@vger.kernel.org>,
       "linux-mtd" <linux-mtd@vger.kernel.org>
References: <1233186456.6734.16.camel@localhost.localdomain> <1233187069.6734.21.camel@localhost.localdomain>
In-Reply-To: <1233187069.6734.21.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2726339.YXAjsRp0nJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901281942.22332.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2726339.YXAjsRp0nJ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 28 January 2009 18:57:49 Adrian McMenamin wrote:
> --- a/drivers/sh/maple/maple.c
> +++ b/drivers/sh/maple/maple.c
> -int maple_add_packet_sleeps(struct maple_device *mdev, u32 function,
> -	u32 command, size_t length, void *data)
> -{
> -	int locking, ret =3D 0;
> -	void *sendbuf =3D NULL;
> -
> -	locking =3D mutex_lock_interruptible(&mdev->mq->mutex);
> -	if (locking) {
> -		ret =3D -EIO;
> -		goto out;
> -	}
> +	int ret =3D 0;
> +	void *sendbuf;
>
> +	sendbuf =3D kzalloc(length * 4, GFP_KERNEL);
>  	if (length) {
> -		sendbuf =3D kmalloc(length * 4, GFP_KERNEL);

that looks wonky ... you do the alloc first and then check the len ?

>  failed_nomem:
> +	printk(KERN_INFO "maple: could not allocate memory\n");

should be a KERN_NOTICE or worse ... KERN_INFO doesnt seem appropriate

> +	if (device_register(&mdev->dev)) {
>  		printk(KERN_INFO
> -		"Maple bus: Attempt to register device"
> -		" (%x, %x) failed.\n",
> +			"Maple bus: Attempt to register device"
> +			" (%x, %x) failed.\n",

same here ... KERN_INFO shouldnt be used in error handlers

> +static void maple_response_fileerr(struct maple_device *mdev, void
> *recvbuf) +{
> +	if (mdev->fileerrhandler) {
> +		mdev->fileerrhandler(mdev, recvbuf);
> +		return;
> +	} else
> +		printk(KERN_INFO "maple: device (%d, %d) reports file error %d\n",
> +			mdev->port, mdev->unit, ((int *)recvbuf)[1]);
> +}

and here ...

>  			case MAPLE_RESPONSE_AGAIN:
>  			case MAPLE_RESPONSE_BADCMD:
>  			case MAPLE_RESPONSE_BADFUNC:
> -				printk(KERN_DEBUG
> +				printk(KERN_INFO
>  				       "Maple non-fatal error 0x%X\n",
>  				       code);

and here ...

>  /* Maple Bus command and response codes */
>  enum maple_code {
> +	MAPLE_RESPONSE_FILEERR =3D	-5,
> +	MAPLE_RESPONSE_AGAIN =3D		-4,	/* retransmit */

do you really need to set every value ?  i would only bother when there's a=
=20
discontinuity ...
=2Dmike

--nextPart2726339.YXAjsRp0nJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJgPtuAAoJEEFjO5/oN/WBo+AP/RKYSUZ4zV97VJJSkcFM97ji
n0U10cpoUIPIdwSCSfn+FM/rXigfP6jSiSVGbhXwirLQr5+pZenGqlguAiqW6HCz
pqJzJiH/3zX8fWLckOE/wmKTg6WQpseAsWpBVny/fjzNZh+h0xh21qlAiVjzmFpJ
U9/OV8Dn+bcwhcwaQjLUm12Aox3ZGrWuYw1M076gQwRcaf4Rd/iNSnCeSKbxxr/W
PY4NOCWZrgn6mve5wNMBIXAcg6NVVuqa7mskn6uvuoQ9McKAchVwKX7vWN2KRE6l
zUPfbSbyB5RF+q8ZxQ2v5LGIftNOVUWrTRFYlFcC77pjt50rh0I2vhXfoiIrTMzy
DEnjLHJrs3xu8FS6ihwKFlv8tb9OBQnuePHsvV6Tguge3Cn1HNJ4Bz5AeieVOqLp
+t08+YxUwz3zzyoikkRRAkjK/7BanAdU0brZetyd0n//ALPn3OhhbnadlVnNESGN
APE1m634LKykwE6dKwXOPobYK5NTP5wwHMIbkgZi021T4PrYHtyBK9tNLIjshvNU
e0FFLjvO85Jdk4p0T2YPjVnKDHsgtgwFWTfmarrafkVhtMqWuP0kntDFBM4t93el
/xtg14S9OOl+4B9/dxmdHJBHIjHZRMiEPUBxMKmr9C2HZ9hRgB36uEm1Q6D40LFj
IEbetuEbrB5U+dt2hDYt
=4fnH
-----END PGP SIGNATURE-----

--nextPart2726339.YXAjsRp0nJ--
