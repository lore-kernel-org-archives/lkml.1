Return-Path: <linux-kernel-owner+w=401wt.eu-S1754457AbYIWRyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbYIWRyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 13:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbYIWRxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 13:53:52 -0400
Received: from server.drzeus.cx ([85.8.24.28]:58884 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752605AbYIWRxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 13:53:51 -0400
Date: Tue, 23 Sep 2008 19:53:42 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH 3/4] atmel-mci: support multiple mmc slots
Message-ID: <20080923195342.52b1164d@mjolnir.drzeus.cx>
In-Reply-To: <1222101497-21183-4-git-send-email-haavard.skinnemoen@atmel.com>
References: <1222101497-21183-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-3-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-4-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: Claws Mail 3.5.0cvs92 (GTK+ 2.14.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-22714-1222192430-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-22714-1222192430-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Sep 2008 18:38:16 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> The Atmel MCI controller can drive multiple cards through separate sets
> of pins, but only one at a time. This patch adds support for
> multiplexing access to the controller so that multiple card slots can be
> used as if they were hooked up to separate mmc controllers.
>=20

This multiplexing shenanigans seems to be all the rage these days...

> =20
>  static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>  {
> -	struct atmel_mci	*host =3D mmc_priv(mmc);
> +	struct atmel_mci_slot	*slot =3D mmc_priv(mmc);
> +	struct atmel_mci	*host =3D slot->host;
> =20
>  	if (ios->clock) {
>  		u32 clkdiv;

You forgot the most important part; how to handle the clock given two
different requests.

(This will also get a bit more painful when/if the core starts
disabling the clock when a card is idle)

> +
> +	if (gpio_is_valid(slot->detect_pin)) {
> +		int ret;
> +
> +		setup_timer(&slot->detect_timer, atmci_detect_change,
> +				(unsigned long)slot);
> +
> +		ret =3D request_irq(gpio_to_irq(slot->detect_pin),
> +				atmci_detect_interrupt,
> +				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
> +				"mmc-detect", slot);
> +		if (ret) {
> +			dev_dbg(&mmc->class_dev,
> +				"could not request IRQ %d for detect pin\n",
> +				gpio_to_irq(slot->detect_pin));
> +			gpio_free(slot->detect_pin);
> +			slot->detect_pin =3D -EBUSY;
> +		}
> +	}

Fall back to polling?

> +	/* We need at least one slot to succeed */
> +	ret =3D -1;
> +	if (pdata->slot[0].bus_width)
> +		ret &=3D atmci_init_slot(host, &pdata->slot[0],
> +				MCI_SDCSEL_SLOT_A);
> +	if (pdata->slot[1].bus_width)
> +		ret &=3D atmci_init_slot(host, &pdata->slot[1],
> +				MCI_SDCSEL_SLOT_B);
> +	if (ret) {
> +		ret =3D -ENODEV;
> +		goto err_init_slot;
>  	}

Memory/resource leak.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-22714-1222192430-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkjZLSsACgkQ7b8eESbyJLjGFACfceaFAt5MZ91MSDWbSBy70R5c
avsAmwUsqYFGW3UKWT9RJlbYGOfhqO+g
=kJki
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-22714-1222192430-0001-2--
