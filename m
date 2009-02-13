Return-Path: <linux-kernel-owner+w=401wt.eu-S1759135AbZBMQ7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135AbZBMQ7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 11:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbZBMQ7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 11:59:30 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:49048 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750850AbZBMQ73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 11:59:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah0FAGo1lUnCTsYx/2dsb2JhbACBbtEShBgG
From: Laurent Pinchart <laurentp@cse-semaphore.com>
Organization: CSE Semaphore
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 11/13] sdhci: Add quirk for controllers that need IRQ re-init after reset
Date: Fri, 13 Feb 2009 16:47:13 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27-11-generic; KDE/4.1.3; i686; ; )
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Pierre Ossman <drzeus-sdhci@drzeus.cx>, Ben Dooks <ben-linux@fluff.org>,
       Arnd Bergmann <arnd@arndb.de>, Liu Dave <DaveLiu@freescale.com>,
       linux-kernel@vger.kernel.org, sdhci-devel@list.drzeus.cx
References: <20090213144630.GA13436@oksana.dev.rtsoft.ru> <20090213144738.GK23889@oksana.dev.rtsoft.ru>
In-Reply-To: <20090213144738.GK23889@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3658195.japQ0uH52i";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200902131647.17728.laurentp@cse-semaphore.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3658195.japQ0uH52i
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Anton,

On Friday 13 February 2009 15:47:38 Anton Vorontsov wrote:
> FSL eSDHC controllers losing signal/interrupt enable states after
> reset, so we should re-enable them.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
>  drivers/mmc/host/sdhci.c |    7 +++++++
>  drivers/mmc/host/sdhci.h |    2 ++
>  2 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index eff615d..b308dbf 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -189,6 +189,7 @@ static void sdhci_disable_card_detection(struct
> sdhci_host *host) static void sdhci_reset(struct sdhci_host *host, u8 mas=
k)
>  {
>  	unsigned long timeout;
> +	u32 ier =3D 0; /* shut up gcc */

You should use

	u32 uninitialized_var(ier);

instead to avoid generating extra code.

>
>  	if (host->quirks & SDHCI_QUIRK_NO_CARD_NO_RESET) {
>  		if (!(sdhci_readl(host, SDHCI_PRESENT_STATE) &
> @@ -196,6 +197,9 @@ static void sdhci_reset(struct sdhci_host *host, u8
> mask) return;
>  	}
>
> +	if (host->quirks & SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET)
> +		ier =3D sdhci_readl(host, SDHCI_INT_ENABLE);
> +
>  	sdhci_writeb(host, mask, SDHCI_SOFTWARE_RESET);
>
>  	if (mask & SDHCI_RESET_ALL)
> @@ -215,6 +219,9 @@ static void sdhci_reset(struct sdhci_host *host, u8
> mask) timeout--;
>  		mdelay(1);
>  	}
> +
> +	if (host->quirks & SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET)
> +		sdhci_clear_set_irqs(host, SDHCI_INT_ALL_MASK, ier);
>  }
>
>  static void sdhci_init(struct sdhci_host *host)
> diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
> index 44c820a..5c5a950 100644
> --- a/drivers/mmc/host/sdhci.h
> +++ b/drivers/mmc/host/sdhci.h
> @@ -229,6 +229,8 @@ struct sdhci_host {
>  #define SDHCI_QUIRK_NONSTANDARD_CLOCK			(1<<19)
>  /* Controller does not like fast PIO transfers */
>  #define SDHCI_QUIRK_PIO_NEEDS_DELAY			(1<<20)
> +/* Controller losing signal/interrupt enable states after reset */
> +#define SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET		(1<<21)
>
>  	int			irq;		/* Device IRQ */
>  	void __iomem *		ioaddr;		/* Mapped address */

=2D-=20
Laurent Pinchart
CSE Semaphore Belgium

Chaussee de Bruxelles, 732A
B-1410 Waterloo
Belgium

T +32 (2) 387 42 59
=46 +32 (2) 387 42 75

--nextPart3658195.japQ0uH52i
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmVlgEACgkQlyYWY4YEWhVGLgCfe6wTJschboY9UrkTDOErAxEV
/zQAni13XLvaxbeg6/2uA9IRXK3UKJ/1
=LI2n
-----END PGP SIGNATURE-----

--nextPart3658195.japQ0uH52i--
