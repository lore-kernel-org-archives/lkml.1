Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbYJLIkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbYJLIkZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 04:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbYJLIkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 04:40:12 -0400
Received: from server.drzeus.cx ([85.8.24.28]:58914 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751335AbYJLIkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 04:40:10 -0400
Date: Sun, 12 Oct 2008 10:39:58 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH v2 4/7] atmel-mci: support multiple mmc slots
Message-ID: <20081012103958.7905356b@mjolnir.drzeus.cx>
In-Reply-To: <1223223690-2637-5-git-send-email-haavard.skinnemoen@atmel.com>
References: <1223223690-2637-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1223223690-2637-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1223223690-2637-3-git-send-email-haavard.skinnemoen@atmel.com>
	<1223223690-2637-4-git-send-email-haavard.skinnemoen@atmel.com>
	<1223223690-2637-5-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-11758-1223800808-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-11758-1223800808-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun,  5 Oct 2008 18:21:27 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> =20
>  	if (ios->clock) {
> +		unsigned int clock_min =3D ~0U;
>  		u32 clkdiv;
> =20
> -		if (!host->mode_reg)
> +		spin_lock_bh(&host->lock);
> +		if (!host->mode_reg) {
>  			clk_enable(host->mck);
> +			mci_writel(host, CR, MCI_CR_SWRST);
> +			mci_writel(host, CR, MCI_CR_MCIEN);
> +		}
> =20
> -		/* Set clock rate */
> -		clkdiv =3D DIV_ROUND_UP(host->bus_hz, 2 * ios->clock) - 1;
> +		/*
> +		 * Use mirror of ios->clock to prevent race with mmc
> +		 * core ios update when finding the minimum.
> +		 */
> +		slot->clock =3D ios->clock;
> +		for (i =3D 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
> +			if (host->slot[i] && host->slot[i]->clock
> +					&& host->slot[i]->clock < clock_min)
> +				clock_min =3D host->slot[i]->clock;
> +		}
> +

Hmm... This does not cover the power up case. You can only ignore the
other slot's clock setting if it is unpowered.

> +		/* Calculate clock divider */
> +		clkdiv =3D DIV_ROUND_UP(host->bus_hz, 2 * clock_min) - 1;
>  		if (clkdiv > 255) {
>  			dev_warn(&mmc->class_dev,
>  				"clock %u too slow; using %lu\n",
> -				ios->clock, host->bus_hz / (2 * 256));
> +				clock_min, host->bus_hz / (2 * 256));
>  			clkdiv =3D 255;
>  		}
> =20

Has this ever happened, or is it just a bit defensive? :)

(not that there is something wrong with that)

>  	default:
>  		/*
>  		 * TODO: None of the currently available AVR32-based
>  		 * boards allow MMC power to be turned off. Implement
>  		 * power control when this can be tested properly.
> +		 *
> +		 * We also need to hook this into the clock management
> +		 * somehow so that newly inserted cards aren't
> +		 * subjected to a fast clock before we have a chance
> +		 * to figure out what the maximum rate is. Currently,
> +		 * there's no way to avoid this, and there never will
> +		 * be for boards that don't support power control.
>  		 */
>  		break;
>  	}

Hmm again... As you've pointed out, this could be a problem. The card
should survive getting jittery power during the insertion, but I
wouldn't chance having the clock running at that point (which will
happen if the other slot is populated).

I don't see a decent way of solving this, so I guess we'll have to
stick our heads in the sand for now...

(did I mention that I think this slot multiplexing thing is a bad idea?)

> @@ -922,9 +1191,11 @@ static void atmci_write_data_pio(struct atmel_mci *=
host)
>  			mci_writel(host, IDR, (MCI_NOTBUSY | MCI_TXRDY
>  						| ATMCI_DATA_ERROR_FLAGS));
>  			host->data_status =3D status;
> +			data->bytes_xfered +=3D nbytes;
> +			smp_wmb();
>  			atmci_set_pending(host, EVENT_DATA_ERROR);
>  			tasklet_schedule(&host->tasklet);
> -			break;
> +			return;
>  		}
>  	} while (status & MCI_TXRDY);
> =20
> @@ -937,29 +1208,26 @@ done:
>  	mci_writel(host, IDR, MCI_TXRDY);
>  	mci_writel(host, IER, MCI_NOTBUSY);
>  	data->bytes_xfered +=3D nbytes;
> +	smp_wmb();
>  	atmci_set_pending(host, EVENT_XFER_COMPLETE);
>  }
> =20

I'm not sure I commented on this during the last run, but bytes_xfered
should only be updated upon confirmation from the card, not as it goes
out over the bus (there might be CRC error for instance).

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-11758-1223800808-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkjxt+UACgkQ7b8eESbyJLgjPACglCA0s5agUixivh7Ylmm808nK
f3oAn3FTxDZI3Io2L/SKJuCbKQbnu4cP
=/Jyr
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-11758-1223800808-0001-2--
