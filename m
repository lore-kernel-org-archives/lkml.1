Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbZAHIvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbZAHIvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 03:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbZAHIvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 03:51:44 -0500
Received: from smtp.nokia.com ([192.100.122.230]:62818 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbZAHIvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 03:51:43 -0500
Message-ID: <4965C120.3010705@nokia.com>
Date: Thu, 08 Jan 2009 11:02:24 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Jean Pihet <jpihet@mvista.com>
CC: linux-arm-kernel@lists.arm.linux.org.uk, Tony Lindgren <tony@atomide.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Madhusudhan Chikkature <madhu.cr@ti.com>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] OMAP: MMC: recover from transfer failures
References: <20081207213617.10456.43951.stgit@localhost> <20081231185928.2ba325e6@mjolnir.drzeus.cx> <20090107101812.GD27566@atomide.com> <200901071128.43937.jpihet@mvista.com>
In-Reply-To: <200901071128.43937.jpihet@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jan 2009 08:50:32.0055 (UTC) FILETIME=[29EDA070:01C9716E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Pihet wrote:
> Tony, Pierre,
> 
> Here is a patch that fixes a MMC host controller deadlock. The problem happens 
> when removing the MMC/SD device when a transfer is on-going.
> 
> It has been tested on OMAP3430 but this fix should apply to OMAP2 chips as 
> well, as seen from the TRMs.
> 
> What do you think?
> 
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
> 

Why not do the reset in mmc_omap_irq() like the other resets?
e.g.

static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
{
	struct mmc_omap_host *host = dev_id;
	struct mmc_data *data;
	int end_cmd = 0, end_trans = 0, status;

	if (host->cmd == NULL && host->data == NULL) {
		OMAP_HSMMC_WRITE(host->base, STAT,
			OMAP_HSMMC_READ(host->base, STAT));
		return IRQ_HANDLED;
	}

	data = host->data;
	status = OMAP_HSMMC_READ(host->base, STAT);
	dev_dbg(mmc_dev(host->mmc), "IRQ Status is %x\n", status);

	if (status & ERR) {
#ifdef CONFIG_MMC_DEBUG
		mmc_omap_report_irq(host, status);
#endif
		if ((status & CMD_TIMEOUT) ||
			(status & CMD_CRC)) {
			if (host->cmd) {
				if (status & CMD_TIMEOUT) {
					OMAP_HSMMC_WRITE(host->base, SYSCTL,
						OMAP_HSMMC_READ(host->base,
								SYSCTL) | SRC);
					while (OMAP_HSMMC_READ(host->base,
							SYSCTL) & SRC)
						;

					host->cmd->error = -ETIMEDOUT;
				} else {
					host->cmd->error = -EILSEQ;
				}
				end_cmd = 1;
			}
-			if (host->data)
+			if (host->data) {
				mmc_dma_cleanup(host);
+				OMAP_HSMMC_WRITE(host->base, SYSCTL,
+					OMAP_HSMMC_READ(host->base,
+							SYSCTL) | SRD);
+				while (OMAP_HSMMC_READ(host->base,
+						SYSCTL) & SRD)
+					;
+			}
		}
		if ((status & DATA_TIMEOUT) ||
			(status & DATA_CRC)) {
			if (host->data) {
				if (status & DATA_TIMEOUT)
					mmc_dma_cleanup(host);
				else
					host->data->error = -EILSEQ;
				OMAP_HSMMC_WRITE(host->base, SYSCTL,
					OMAP_HSMMC_READ(host->base,
							SYSCTL) | SRD);
				while (OMAP_HSMMC_READ(host->base,
						SYSCTL) & SRD)
					;
				end_trans = 1;
			}
		}
