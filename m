Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbZD1IrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbZD1IrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbZD1IpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:45:03 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:37135 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbZD1Io7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:44:59 -0400
Subject: Re: [PATCH] appletouch: fix DMA to/from stack buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090428015844.GA16190@hash.localnet>
References: <20090428015844.GA16190@hash.localnet>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-aClLdoYWDh0LEjgoPiLM"
Date: Tue, 28 Apr 2009 10:44:54 +0200
Message-Id: <1240908294.19534.2.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-aClLdoYWDh0LEjgoPiLM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-04-27 at 21:58 -0400, Bob Copeland wrote:
> CONFIG_DMA_API_DEBUG spotted an instance of appletouch using
> an array on the stack as a DMA buffer for certain hardware.
> Change it to use a kmalloc()ed buffer instead.
>=20
> This fixes the following error:

> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Interestingly, I first thought the GFP_KERNEL is wrong due to
atp_reinit, but the GFP_ATOMIC in that is wrong instead :)

> ---
>  drivers/input/mouse/appletouch.c |   24 ++++++++++++++++++------
>  1 files changed, 18 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/input/mouse/appletouch.c b/drivers/input/mouse/apple=
touch.c
> index 454b961..e0140fd 100644
> --- a/drivers/input/mouse/appletouch.c
> +++ b/drivers/input/mouse/appletouch.c
> @@ -255,15 +255,22 @@ MODULE_PARM_DESC(debug, "Activate debugging output"=
);
>   */
>  static int atp_geyser_init(struct usb_device *udev)
>  {
> -	char data[8];
> +	char *data;
>  	int size;
>  	int i;
> +	int ret;
> +
> +	data =3D kmalloc(8, GFP_KERNEL);
> +	if (!data) {
> +		err("Out of memory");
> +		return -ENOMEM;
> +	}
> =20
>  	size =3D usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>  			ATP_GEYSER_MODE_READ_REQUEST_ID,
>  			USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
>  			ATP_GEYSER_MODE_REQUEST_VALUE,
> -			ATP_GEYSER_MODE_REQUEST_INDEX, &data, 8, 5000);
> +			ATP_GEYSER_MODE_REQUEST_INDEX, data, 8, 5000);
> =20
>  	if (size !=3D 8) {
>  		dprintk("atp_geyser_init: read error\n");
> @@ -271,7 +278,8 @@ static int atp_geyser_init(struct usb_device *udev)
>  			dprintk("appletouch[%d]: %d\n", i, data[i]);
> =20
>  		err("Failed to read mode from device.");
> -		return -EIO;
> +		ret =3D -EIO;
> +		goto out_free;
>  	}
> =20
>  	/* Apply the mode switch */
> @@ -281,7 +289,7 @@ static int atp_geyser_init(struct usb_device *udev)
>  			ATP_GEYSER_MODE_WRITE_REQUEST_ID,
>  			USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
>  			ATP_GEYSER_MODE_REQUEST_VALUE,
> -			ATP_GEYSER_MODE_REQUEST_INDEX, &data, 8, 5000);
> +			ATP_GEYSER_MODE_REQUEST_INDEX, data, 8, 5000);
> =20
>  	if (size !=3D 8) {
>  		dprintk("atp_geyser_init: write error\n");
> @@ -289,9 +297,13 @@ static int atp_geyser_init(struct usb_device *udev)
>  			dprintk("appletouch[%d]: %d\n", i, data[i]);
> =20
>  		err("Failed to request geyser raw mode");
> -		return -EIO;
> +		ret =3D -EIO;
> +		goto out_free;
>  	}
> -	return 0;
> +	ret =3D 0;
> +out_free:
> +	kfree(data);
> +	return ret;
>  }
> =20
>  /*
> --=20
> 1.6.0.6
>=20

--=-aClLdoYWDh0LEjgoPiLM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ9sIEAAoJEKVg1VMiehFYkjoP/2YsxPTHDu0VBopQJHJvn9X5
8s+Wwec7vAOKCy+NN4sTBNgzbsZB2IjdTNVPnSf4GN9iBqvN4+tqw79jIpNLy/od
nhS68Pw3EP3LtHZh8uWde9t0uevCgDuvx6beWjrYZQWfzvsUHMCKdVvB10VcO3U9
7pPT/AncHrNMogk0ARoRxKWyXkzNTYsUX9YCcf4euSkXFE1hNaIgcb56fqISKKDM
jywAZiZzz4G6qfPCmqaZv8JN4bExrrKZ2P1F+choj5UFnBKc2zMrUhWdaCtOkS4p
lqvIx353w9cyU4oMooT3P6Wgnz+LMtvVUgzyDXj6Tf1zv2raEWZHIAPJvqz29NfY
JdhRII2jtBf0z7+ebHU1bejEFIMA6Etcygsp+7ZY4EFjIpBpHAQaT4XMpoXhCM/D
iNPbid6lZXntXw9K/U6J5iI4ZKDQ5/kwyGg0ayeQfWyGfbk4/xove2OAou++3nQQ
OjFD7Dv5u702CuEFfRwuvBrF9BduvO3AB86sgousu7bNTSFtpKGCh9RT5P3I/uH4
Dy4Nqg7OBiTz6OVBPsI8L3jikQqNBcAl5DA1hpx3TRJGSWzuQBdQ/7/ODUQ4kSuf
9VPwrjiBhTYq8crOYH8P5otHWAiepBV0BQ02pCecbGeoZPOX5oFrn70/FX+yZk5z
eF5hzKlmnbPrsuUtn0WT
=apZP
-----END PGP SIGNATURE-----

--=-aClLdoYWDh0LEjgoPiLM--

