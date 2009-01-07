Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbZAGPks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbZAGPks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbZAGPki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:40:38 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:56259 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbZAGPkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:40:36 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19mvyZ5hftGaLset35nzU1L
Date: Wed, 7 Jan 2009 17:40:14 +0200
From: Tony Lindgren <tony@atomide.com>
To: Jean Pihet <jpihet@mvista.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Madhusudhan Chikkature <madhu.cr@ti.com>,
       David Brownell <david-b@pacbell.net>,
       "Jarkko Lavinen (NMP/Helsinki)" <jarkko.lavinen@nokia.com>
Subject: Re: [PATCH] OMAP: MMC: recover from transfer failures (was: Re:
	[PATCH 5/5] omap mmc: Add new omap hsmmc controller for 2430 and
	34xx)
Message-ID: <20090107154013.GR27566@atomide.com>
References: <20081207213617.10456.43951.stgit@localhost> <20081231185928.2ba325e6@mjolnir.drzeus.cx> <20090107101812.GD27566@atomide.com> <200901071128.43937.jpihet@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901071128.43937.jpihet@mvista.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Jean Pihet <jpihet@mvista.com> [090107 12:28]:
> Tony, Pierre,
> 
> Here is a patch that fixes a MMC host controller deadlock. The problem happens 
> when removing the MMC/SD device when a transfer is on-going.
> 
> It has been tested on OMAP3430 but this fix should apply to OMAP2 chips as 
> well, as seen from the TRMs.
> 
> What do you think?

Looks OK to me, adding Jarkko to Cc.

Tony

> Regards,
> Jean.
> 
>     OMAP: MMC: recover from transfer failures
> 
>     Timeouts during a command that has a data phase can result in the
>     next command issued after the command that failed not being processed,
>     i.e. no interrupt ever occurs to indicate the command has completed.
>     This failure can result in a deadlock.
> 
>     The indication that the mmc host controller is in this error state is
>     that the DATI bit is set in the PSTATE register.  This patch checks
>     to see if the DATI bit is set before starting a new command, and if it
>     is set it resets the data state machine to clear the error.
> 
>     Tested on OMAP3430 chip and intensive MMC/SD device removal while
>     transferring data.
> 
> Regards,
> Jean
> 
> 
> From 48a40925a4d57f6e7e45809a4b5c09b20f9314d7 Mon Sep 17 00:00:00 2001
> From: Jean Pihet <jpihet@mvista.com>
> Date: Tue, 16 Dec 2008 19:44:12 +0100
> Subject: [PATCH] OMAP: MMC: recover from transfer failures
> 
> Timeouts during a command that has a data phase can result in the
> next command issued after the command that failed not being processed,
> i.e. no interrupt ever occurs to indicate the command has completed.
> This failure can result in a deadlock.
> 
> The indication that the mmc host controller is in this error state is
> that the DATI bit is set in the PSTATE register.  This patch checks
> to see if the DATI bit is set before starting a new command, and if it
> is set it resets the data state machine to clear the error.
> 
> Tested on OMAP3430 chip and intensive MMC/SD device removal while
> transferring data.
> 
> Signed-off-by: Andy Lowe <alowe@mvista.com>
> Signed-off-by: Jean Pihet <jpihet@mvista.com>
> ---
>  drivers/mmc/host/omap_hsmmc.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 1fcc544..b7d111e 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -44,6 +44,7 @@
>  #define OMAP_HSMMC_RSP54       0x0118
>  #define OMAP_HSMMC_RSP76       0x011C
>  #define OMAP_HSMMC_DATA                0x0120
> +#define OMAP_HSMMC_PSTATE      0x0124
>  #define OMAP_HSMMC_HCTL                0x0128
>  #define OMAP_HSMMC_SYSCTL      0x012C
>  #define OMAP_HSMMC_STAT                0x0130
> @@ -89,6 +90,7 @@
>  #define DUAL_VOLT_OCR_BIT      7
>  #define SRC                    (1 << 25)
>  #define SRD                    (1 << 26)
> +#define DATI                   (1 << 1)
>  
>  /*
>   * FIXME: Most likely all the data using these _DEVID defines should come
> @@ -273,6 +275,15 @@ mmc_omap_start_command(struct mmc_omap_host *host, struct 
> mmc_command *cmd,
>                 mmc_hostname(host->mmc), cmd->opcode, cmd->arg);
>         host->cmd = cmd;
>  
> +       if (OMAP_HSMMC_READ(host->base, PSTATE) & DATI) {
> +               dev_dbg(mmc_dev(host->mmc), "mmc_omap_start_command: "
> +                       " resetting data state machine\n");
> +               OMAP_HSMMC_WRITE(host->base, SYSCTL,
> +                       OMAP_HSMMC_READ(host->base, SYSCTL) | SRD);
> +               while (OMAP_HSMMC_READ(host->base, SYSCTL) & SRD)
> +                       ;
> +       }
> +
>         /*
>          * Clear status bits and enable interrupts
>          */
> -- 
> 1.5.4.4.21.gc4a6c
> 
> 
> On Wednesday 07 January 2009 11:18:13 Tony Lindgren wrote:
> > * Pierre Ossman <drzeus-mmc@drzeus.cx> [081231 19:59]:
> > > On Tue, 30 Dec 2008 10:36:26 +0200
> > >
> > > Tony Lindgren <tony@atomide.com> wrote:
> > > > Here's one more version that leaves out the unnecessary TWL4030
> > > > dependency in the Kconfig as pointed out by David Brownell.
> > >
> > > Looks ok.
> > >
> > > Acked-by: Pierre Ossman <drzeus@drzeus.cx>
> >
> > Thanks, I'll queue it up with Russell with one change
> > to include <mach/dma.h> instead of <asm/dma.h>.
> >
> > All further patches to this driver will come to you via
> > LKML.
> >
> > Regards,
> >
> > Tony
> >
> > > --
> > >      -- Pierre Ossman
> > >
> > >   Linux kernel, MMC maintainer        http://www.kernel.org
> > >   rdesktop, core developer          http://www.rdesktop.org
> > >
> > >   WARNING: This correspondence is being monitored by the
> > >   Swedish government. Make sure your server uses encryption
> > >   for SMTP traffic and consider using PGP for end-to-end
> > >   encryption.
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> > > in the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> >
> > -------------------------------------------------------------------
> > List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> > FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> > Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
> 
> 

> From 48a40925a4d57f6e7e45809a4b5c09b20f9314d7 Mon Sep 17 00:00:00 2001
> From: Jean Pihet <jpihet@mvista.com>
> Date: Tue, 16 Dec 2008 19:44:12 +0100
> Subject: [PATCH] OMAP: MMC: recover from transfer failures
> 
> Timeouts during a command that has a data phase can result in the
> next command issued after the command that failed not being processed,
> i.e. no interrupt ever occurs to indicate the command has completed.
> This failure can result in a deadlock.
> 
> The indication that the mmc host controller is in this error state is
> that the DATI bit is set in the PSTATE register.  This patch checks
> to see if the DATI bit is set before starting a new command, and if it
> is set it resets the data state machine to clear the error.
> 
> Tested on OMAP3430 chip and intensive MMC/SD device removal while
> transferring data.
> 
> Signed-off-by: Andy Lowe <alowe@mvista.com>
> Signed-off-by: Jean Pihet <jpihet@mvista.com>
> ---
>  drivers/mmc/host/omap_hsmmc.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 1fcc544..b7d111e 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -44,6 +44,7 @@
>  #define OMAP_HSMMC_RSP54	0x0118
>  #define OMAP_HSMMC_RSP76	0x011C
>  #define OMAP_HSMMC_DATA		0x0120
> +#define OMAP_HSMMC_PSTATE	0x0124
>  #define OMAP_HSMMC_HCTL		0x0128
>  #define OMAP_HSMMC_SYSCTL	0x012C
>  #define OMAP_HSMMC_STAT		0x0130
> @@ -89,6 +90,7 @@
>  #define DUAL_VOLT_OCR_BIT	7
>  #define SRC			(1 << 25)
>  #define SRD			(1 << 26)
> +#define DATI			(1 << 1)
>  
>  /*
>   * FIXME: Most likely all the data using these _DEVID defines should come
> @@ -273,6 +275,15 @@ mmc_omap_start_command(struct mmc_omap_host *host, struct mmc_command *cmd,
>  		mmc_hostname(host->mmc), cmd->opcode, cmd->arg);
>  	host->cmd = cmd;
>  
> +	if (OMAP_HSMMC_READ(host->base, PSTATE) & DATI) {
> +		dev_dbg(mmc_dev(host->mmc), "mmc_omap_start_command: "
> +			" resetting data state machine\n");
> +		OMAP_HSMMC_WRITE(host->base, SYSCTL,
> +			OMAP_HSMMC_READ(host->base, SYSCTL) | SRD);
> +		while (OMAP_HSMMC_READ(host->base, SYSCTL) & SRD)
> +			;
> +	}
> +
>  	/*
>  	 * Clear status bits and enable interrupts
>  	 */
> -- 
> 1.5.4.4.21.gc4a6c
> 

