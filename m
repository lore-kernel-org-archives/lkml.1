Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbZBHTpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbZBHTpS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 14:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZBHTpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 14:45:05 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:48028 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbZBHTpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 14:45:03 -0500
Date: Sun, 8 Feb 2009 20:44:52 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH] Fixes and enhancements for the MMC SPI driver - revised
Message-ID: <20090208204452.0ecdb18e@mjolnir.drzeus.cx>
In-Reply-To: <200901261418.19681.wolfgang.mues@auerswald.de>
References: <20090113015904.606e3548.akpm@linux-foundation.org>
	<200901261418.19681.wolfgang.mues@auerswald.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-2964-1234122299-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-2964-1234122299-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 26 Jan 2009 14:18:19 +0100
Wolfgang M=C3=BCes <wolfgang.mues@auerswald.de> wrote:

> Hi,
>=20
> thanks to all contributors who have reviewed my patch, especial to=20
> Andrew Morton for pointing out some problems.
>=20
> Here is a revised patch incl. changelog. I have though about putting
> some warnings in the message log with printk, Pierre. But this is low-lev=
el
> stuff and will likely flood the logfile.
>=20

There are some helpers to avoid flooding dmesg, but its a wish a not a
requirement so don't sweat it.

> changelog:

Please split these things up into one patch for each item. It keeps the
logs sensible and makes bisecting work better in case of problems.

> @@ -609,6 +616,18 @@ mmc_spi_writeblock(struct mmc_spi_host *
>  	struct spi_device	*spi =3D host->spi;
>  	int			status, i;
>  	struct scratch		*scratch =3D host->data;
> +	u32			pattern;
> +	struct timeval 		tv;
> +
> +	/*
> +	 * The MMC framework does a good job of computing timeouts
> +	 * according to the mmc/sd standard. However, we found that in
> +	 * SPI mode, there are many cards which need a longer timeout
> +	 * of 1s after receiving a long stream of write data.
> +	 */
> +	tv =3D ktime_to_timeval(timeout);
> +	if (tv.tv_sec =3D=3D 0)
> +		timeout =3D ktime_set(1, 0);
> =20
>  	if (host->mmc->use_spi_crc)
>  		scratch->crc_val =3D cpu_to_be16(

This might as well be handled when we compute the timeout in the core.
Having things spread out is just confusing.

> @@ -743,7 +777,12 @@ mmc_spi_readblock(struct mmc_spi_host *h
>  		return -EIO;
>  	}
> =20
> -	if (host->mmc->use_spi_crc) {
> +	/*
> +	 * Omit the CRC check for CID and CSD reads. There are some SDHC
> +	 * cards which don't supply a valid CRC after CID reads.
> +	 * Note that the CID has it's own CRC7 value inside the data block.
> +	 */
> +	if (host->mmc->use_spi_crc && (t->len =3D=3D MMC_SPI_BLOCKSIZE)) {
>  		u16 crc =3D crc_itu_t(0, t->rx_buf, t->len);
> =20
>  		be16_to_cpus(&scratch->crc_val);

Hmmm... I think this also better handled in the core. Reorder things in
the init to not turn CRC checks on until after those registers have
been read.

Other than that, the changes look fine. So split them up and I can
queue them up for the next merge window.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-2964-1234122299-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkmPNjkACgkQ7b8eESbyJLhOYACbBzDzoEGHbrYYk5JjQvvEmTMt
Gs0AnivwtpiDA9H6el3bmV3DBTdNKgVj
=W7qr
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-2964-1234122299-0001-2--
