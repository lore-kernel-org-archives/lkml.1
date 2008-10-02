Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbYJBI0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbYJBI0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYJBI0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:26:46 -0400
Received: from server.drzeus.cx ([85.8.24.28]:50896 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752294AbYJBI0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:26:46 -0400
Date: Thu, 2 Oct 2008 10:26:43 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Matt Fleming" <mattjfleming@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] MMC: Use write timeout value as read from CSR
Message-ID: <20081002102643.1d980a1f@mjolnir.drzeus.cx>
In-Reply-To: <5ff4a1e50809240416p3c51587fs320bc9ebff7733c7@mail.gmail.com>
References: <5ff4a1e50809010812i32168136qea538ba177b81446@mail.gmail.com>
	<5ff4a1e50809090059i2bcdb7ber8cae07128eea5a77@mail.gmail.com>
	<20080909105513.5b8ceaaf@mjolnir.drzeus.cx>
	<5ff4a1e50809090207o5846f5udf709eeda81653eb@mail.gmail.com>
	<5ff4a1e50809090242ha576dcdmf82d1e9ec2204178@mail.gmail.com>
	<20080914154817.3d618e67@mjolnir.drzeus.cx>
	<5ff4a1e50809150103v1e250e0x4192e2fe901750a6@mail.gmail.com>
	<20080915103821.2b618bba@mjolnir.drzeus.cx>
	<5ff4a1e50809150224o600fd9fhb29e986bdb618464@mail.gmail.com>
	<20080920130652.05f3da6d@mjolnir.drzeus.cx>
	<5ff4a1e50809240416p3c51587fs320bc9ebff7733c7@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0cvs92 (GTK+ 2.14.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008 12:16:02 +0100
"Matt Fleming" <mattjfleming@googlemail.com> wrote:

> 2008/9/20 Pierre Ossman <drzeus-mmc@drzeus.cx>:
> >
> > It shouldn't take that long to write the more proper solution, so get
> > to it and it should be possible to get in even for .27.
> >
> 
> OK, attached is the latest attempt at this patch. Because a lot of
> host drivers manipulate timeout_ns and timeout_clks I decided not
> touch them at all. So, I created a new member of the mmc_data struct
> that has the timeout value as a ktime_t.

Hmm... What do you mean manipulate? They all just read it, so I don't
see a need for a new member.

> I'm still unsure of how
> exactly to tackle the mmc_send_cid and mmc_send_csd() cases, the
> timeout value used in the spec is Ncr, where can I find this value?

Right, they left that out of the simplified spec. Sneaky bastards. It's
defined as 64 clock cycles.

> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 044d84e..b5c6f5f 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -249,8 +249,10 @@ void mmc_set_data_timeout(struct mmc_data *data,
> const struct mmc_card *card)
>          * SDIO cards only define an upper 1 s limit on access.
>          */
>         if (mmc_card_sdio(card)) {
> -               data->timeout_ns = 1000000000;
> -               data->timeout_clks = 0;
> +               if (data->timeout_ns > 1000000000) {
> +                       data->timeout_ns = 1000000000;
> +                       data->timeout_clks = 0;
> +               }
>                 return;
>         }
> 

data->timeout_* is undefined when this function is invoked, so this
code is wrong. It is also unnecessary, so just leave it out.

> @@ -269,6 +271,11 @@ void mmc_set_data_timeout(struct mmc_data *data,
> const struct mmc_card *card)
>         data->timeout_ns = card->csd.tacc_ns * mult;
>         data->timeout_clks = card->csd.tacc_clks * mult;
> 
> +       data->ktimeout = ktime_set(0, 0);
> +       data->ktimeout = ktime_add_ns(data->ktimeout, data->timeout_ns);
> +       data->ktimeout = ktime_add_ns(data->ktimeout,
> +               data->timeout_clks * 1000000 / card->host->ios.clock);
> +
>         /*
>          * SD cards also have an upper limit on the timeout.
>          */

card->host->ios.clock is just the upper bound on the clock, it might be
running slower. This is why the host driver needs to calculate it (well
that, and the fact that different controllers treat timeouts in
different ways so it's not one-size-fits-all).

> @@ -832,9 +832,11 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct
> mmc_command *cmd,
>                                 t->len);
> 
>                         if (direction == DMA_TO_DEVICE)
> -                               status = mmc_spi_writeblock(host, t);
> +                               status = mmc_spi_writeblock(host, t,
> +                                               data->ktimeout);
>                         else
> -                               status = mmc_spi_readblock(host, t);
> +                               status = mmc_spi_readblock(host, t,
> +                                               data->ktimeout);
>                         if (status < 0)
>                                 break;
> 

If you put the calculation somewhere before this chunk instead,
everything should be peachy.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
