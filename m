Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbZFNHAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbZFNHAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 03:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZFNHAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 03:00:15 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:60718 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbZFNHAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 03:00:13 -0400
Date: Sun, 14 Jun 2009 14:52:56 +0800
From: Harald Welte <HaraldWelte@viatech.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       JosephChan@via.com.tw, Bruce Chang <BruceChang@via.com.tw>
Subject: Re: [PATCH] mmc: Add new via-sdmmc host controller driver
Message-ID: <20090614065256.GJ2854@prithivi.gnumonks.org>
References: <20090612075930.GB30843@prithivi.gnumonks.org> <20090613134328.0c168205@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <20090613134328.0c168205@mjolnir.ossman.eu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pierre,

as usual, thanks for your review+comments.

On Sat, Jun 13, 2009 at 01:43:28PM +0200, Pierre Ossman wrote:
> On Fri, 12 Jun 2009 15:59:30 +0800
> Harald Welte <HaraldWelte@viatech.com> wrote:
>=20
> > +
> > +#define MMC_STOP_TRANSMISSION	12
>=20
> This define is no longer used.

thanks, removed.

> > +	/* It seems that our DMA can not work normally with 375kHz clock */
> > +	/* FIXME: don't brute-force 8MHz but use PIO at 375kHz !! */
> > +	addrbase =3D host->pcictrl_mmiobase;
> > +	if (readb(addrbase + VIA_CRDR_PCISDCCLK) =3D=3D PCI_CLK_375K) {
> > +		dev_info(host->mmc->parent, "forcing card speed to 8MHz\n");
> > +		writeb(PCI_CLK_8M, addrbase + VIA_CRDR_PCISDCCLK);
> > +	}
>=20
> This is pretty nasty. Please see if you can provide a workaround some
> time soon.

yes, I'm looking into this, definitely.  Will need some
experimentation/testing, but I'll submit an incremental fix ASAP.

> > +	if (ios->power_mode !=3D MMC_POWER_OFF)
> > +		via_sdc_set_power(host, ios->vdd);
>=20
> What if we actually do need to power off?

I see. Good spot.  It seems like we actually leave the power on,
and instread only switch the clock off:

>        if (ios->power_mode =3D=3D MMC_POWER_OFF)
>                org_data &=3D ~VIA_CRDR_SDMODE_POWER;
>        else
>                org_data |=3D VIA_CRDR_SDMODE_POWER;

according to the (public) docs, this bit is not about power but about
clock gating.  I have renamed it to SDMODE_CLK_ON to make it more clear.

> > +static void __devexit via_sd_remove(struct pci_dev *pcidev)
> > +{
> > +	struct via_crdr_mmc_host *sdhost;
> > +	u8 gatt;
> > +
> > +	pr_info(DRV_NAME
> > +		": VIA SDMMC controller at %s [%04x:%04x] has been removed\n",
> > +		pci_name(pcidev), (int)pcidev->vendor, (int)pcidev->device);
> > +
> > +	sdhost =3D pci_get_drvdata(pcidev);
> > +
> > +	tasklet_kill(&sdhost->finish_tasklet);
> > +
> > +	if (&sdhost->timer)
> > +		del_timer_sync(&sdhost->timer);
> > +
> > +	mmc_remove_host(sdhost->mmc);
> > +
>=20
> You need to do the removal as the first step=20

Thanks, I've fixed this in my tree.=20

Looking at other drivers, imxmmc seems to get this wrong, too.

> and you might need to explicitly kill any ongoing requests.

you mean something like the snippet in sdhci.c:
=3D=3D=3D=3D=3D=3D
       if (dead) {
                spin_lock_irqsave(&host->lock, flags);

                host->flags |=3D SDHCI_DEVICE_DEAD;

                if (host->mrq) {
                        printk(KERN_ERR "%s: Controller removed during "
                                " transfer!\n", mmc_hostname(host->mmc));

                        host->mrq->cmd->error =3D -ENOMEDIUM;
                        tasklet_schedule(&host->finish_tasklet);
                }

                spin_unlock_irqrestore(&host->lock, flags);
        }
=3D=3D=3D=3D=3D=3D

Why is sdhci about the only driver that does it?  What decides if we need
to kill ongoing requests or not?

Also, you stated that mmc_remove_host needs to be the first step.  However,
sdhci first kills the ongoing rquest (if "dead"), and then removes the host.

--=20
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
VIA Free and Open Source Software Liaison

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFKNJ5IXaXGVTD0i/8RAt6OAJ9n96OVwUCplkbKTamOvgIdZIW4lwCePLIQ
FMAr8a514n09/6CxPh8rO4k=
=RI1W
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
