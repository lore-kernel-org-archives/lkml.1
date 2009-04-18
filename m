Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbZDRQzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbZDRQzK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 12:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbZDRQy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 12:54:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40978 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538AbZDRQy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 12:54:56 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Darren Salt <linux@youmustbejoking.demon.co.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <505368DED8%linux@youmustbejoking.demon.co.uk>
References: <1239590029.18110.122.camel@deadeye.i.decadent.org.uk>
	 <505368DED8%linux@youmustbejoking.demon.co.uk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IHgZvkk0b/yCCW73pf+x"
Date: Sat, 18 Apr 2009 17:54:48 +0100
Message-Id: <1240073688.3384.4.camel@deadeye.i.decadent.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.4.182
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 4/3] rt2860sta: call release_firmware on module exit,
	else resume is broken
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IHgZvkk0b/yCCW73pf+x
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-04-18 at 16:15 +0100, Darren Salt wrote:
> Resume breakage is as follows: it takes somewhat longer (firmware request
> timeout), as a result of which the firmware isn't reloaded; and any
> subsequent attempt to trying to bring down the interface results in a pan=
ic &
> lockup (SysRq failure on my 901).
>=20
> Consequently, it's better to request the firmware once and hang onto it u=
ntil
> the module is unloaded.

Greg hasn't accepted the previous patch, so there's not much point
submitting patches on top of it yet.  I suggest you post a combined
patch once David has done a release of linux-firmware including
rt2860.bin.

> Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>
>=20
> diff -pur a/drivers/staging/rt2860/2860_main_dev.c b/drivers/staging/rt28=
60/2860_main_dev.c
> --- a/drivers/staging/rt2860/2860_main_dev.c
> +++ b/drivers/staging/rt2860/2860_main_dev.c
> @@ -289,6 +289,7 @@ static INT __init rt2860_init_module(VOI
>  static VOID __exit rt2860_cleanup_module(VOID)
>  {
>      pci_unregister_driver(&rt2860_driver);
> +    NICForgetFirmware();
>  }
> =20
>  module_init(rt2860_init_module);
> diff -pur a/drivers/staging/rt2860/common/rtmp_init.c b/drivers/staging/r=
t2860/common/rtmp_init.c
> --- a/drivers/staging/rt2860/common/rtmp_init.c
> +++ b/drivers/staging/rt2860/common/rtmp_init.c
> @@ -144,6 +144,8 @@ RTMP_REG_PAIR	STAMACRegTable[] =3D	{
>  #define FW_FILENAME "rt2860.bin"
>  MODULE_FIRMWARE(FW_FILENAME);
> =20
> +const struct firmware *fw =3D NULL;
> +

Must be static.

>  #define FIRMWAREIMAGE_MAX_LENGTH	0x2000
>  #define FIRMWARE_MAJOR_VERSION	0
>  #define FIRMWARE_MINOR_VERSION	2
> @@ -2583,6 +2585,12 @@ VOID NICEraseFirmware(
> =20
>  }/* End of NICEraseFirmware */
> =20
> +VOID NICForgetFirmware(void)
> +{
> +	release_firmware(fw);
> +	fw =3D NULL;
> +}
> +
>  /*
>  	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
> @@ -2603,11 +2611,11 @@ VOID NICEraseFirmware(
>  NDIS_STATUS NICLoadFirmware(
>  	IN PRTMP_ADAPTER pAd)
>  {
> -	const struct firmware *fw;
>  	int ret, i;
>  	NDIS_STATUS Status =3D NDIS_STATUS_SUCCESS;
> =20
> -	ret =3D request_firmware(&fw, FW_FILENAME,
> +	ret =3D fw ? 0 :
> +	      request_firmware(&fw, FW_FILENAME,
>  			       &((POS_COOKIE)pAd->OS_Cookie)->pci_dev->dev);

This is not thread-safe unless NICLoadFirmware is guarded by a global
lock.  Is it always called under RTNL?  If so, we can add ASSERT_RTNL()
to ensure that this doesn't change.

>  	if (ret) {
>  		printk(KERN_ERR "rt2860sta: firmware file %s request failed (%d)\n",
> @@ -2659,7 +2667,7 @@ NDIS_STATUS NICLoadFirmware(
>  	RTMP_IO_WRITE32(pAd, H2M_BBP_AGENT, 0);
>  	RTMP_IO_WRITE32(pAd, H2M_MAILBOX_CSR, 0);
> =20
> -	release_firmware(fw);
> +	/*release_firmware(fw);*/
[...]

Just remove it.
=20
Ben.


--=-IHgZvkk0b/yCCW73pf+x
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJ6gXR79ZNCRIGYgcRApDbAKDXMVTEKa5KB+An+N4E73K15L/sSwCgzCRG
bcsZ7PRTFByThjJHGc4AbaA=
=vM6o
-----END PGP SIGNATURE-----

--=-IHgZvkk0b/yCCW73pf+x--
