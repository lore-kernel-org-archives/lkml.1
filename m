Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbYE3NXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbYE3NXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 09:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYE3NWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 09:22:52 -0400
Received: from mail.hevs.ch ([153.109.23.10]:37512 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbYE3NWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 09:22:51 -0400
X-Greylist: delayed 1513 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 May 2008 09:22:51 EDT
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH 1/7] mmc: at91_mci: support for block size not modulo 4
Date: Fri, 30 May 2008 14:57:33 +0200
User-Agent: KMail/1.9.9
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       "=?iso-8859-1?q?Hans-J=FCrgen?= "@rfoatmel.rfo.atmel.com,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <linux@maxim.org.za>, Eric BENARD <ebenard@free.fr>,
       "Ville =?iso-8859-1?q?Syrj=E4?="@rfoatmel.rfo.atmel.com
References: <483FE9E7.7020707@atmel.com> <483FED84.50100@atmel.com>
In-Reply-To: <483FED84.50100@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200805301457.34320.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m4UDNSHl029341

Hi Nicolas!
On Friday 30 May 2008, Nicolas Ferre wrote:> From: Marc Pignat <marc.pignat@hevs.ch>> > Implement transfer with size not modulo 4 for at91sam9*. Please note that the> at91rm9200 simply can't handle this.> > Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>> ---
I just want we don't forget that at91sam9260 errata, pointed by someone when Iposted this patch...
44.2.4.4 Data Write Operation and number of bytes                     The Data Write operation with a number of bytes less than 12 is impossible.                     Problem Fix/Workaround                     The PDC counters must always be equal to 12 bytes for data transfers lower than 12 bytes. The                     BLKLEN or BCNT field are used to specify the real count number.
We should probably fix that thing in the next release and verify if otherchips are affected!


>  drivers/mmc/host/at91_mci.c |   15 ++++++++++----->  1 files changed, 10 insertions(+), 5 deletions(-)> > diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c> index 8979ad3..543b64b 100644> --- a/drivers/mmc/host/at91_mci.c> +++ b/drivers/mmc/host/at91_mci.c> @@ -233,11 +233,11 @@ static void at91_mci_pre_dma_read(struct at91mci_host *host)>  >               if (i == 0) {>                       at91_mci_write(host, ATMEL_PDC_RPR, sg->dma_address);> -                     at91_mci_write(host, ATMEL_PDC_RCR, sg->length / 4);> +                     at91_mci_write(host, ATMEL_PDC_RCR, (data->blksz & 0x3) ? sg->length : sg->length / 4);>               }>               else {>                       at91_mci_write(host, ATMEL_PDC_RNPR, sg->dma_address);> -                     at91_mci_write(host, ATMEL_PDC_RNCR, sg->length / 4);> +                     at91_mci_write(host, ATMEL_PDC_RNCR, (data->blksz & 0x3) ? sg->length : sg->length / 4);>               }>       }>  > @@ -430,7 +430,7 @@ static void at91_mci_send_command(struct at91mci_host *host, struct mmc_command>  >       if (data) {>  > -             if ( data->blksz & 0x3 ) {> +             if ( cpu_is_at91rm9200() && (data->blksz & 0x3) ) {>                       pr_debug("Unsupported block size\n");>                       cmd->error = -EINVAL;>                       mmc_request_done(host->mmc, host->request);> @@ -482,7 +482,10 @@ static void at91_mci_send_command(struct at91mci_host *host, struct mmc_command>       } else {>               /* zero block length and PDC mode */>               mr = at91_mci_read(host, AT91_MCI_MR) & 0x7fff;> -             at91_mci_write(host, AT91_MCI_MR, mr | (block_length << 16) | AT91_MCI_PDCMODE);here, we should do something like{        /* blocks smaller than 16 will be rounded up to 16 at91sam9260, and 16 is modulo 4 :) */        if (!(cpu_is_at91sam9260() && size < 16))                mr |= (data->blksz & 0x3) ? AT91_MCI_PDCFBYTE : 0;}> +             mr |= (block_length << 16);> +             mr |= AT91_MCI_PDCMODE;> +             at91_mci_write(host, AT91_MCI_MR, mr);>  >               /*>                * Disable the PDC controller> @@ -517,7 +520,9 @@ static void at91_mci_send_command(struct at91mci_host *host, struct mmc_command>                               pr_debug("Transmitting %d bytes\n", host->total_length);>  >                               at91_mci_write(host, ATMEL_PDC_TPR, host->physical_address);> -                             at91_mci_write(host, ATMEL_PDC_TCR, host->total_length / 4);> +                             at91_mci_write(host, ATMEL_PDC_TCR, (data->blksz & 0x3) ?> +                                             host->total_length : host->total_length / 4);here, we should add something like{        unsigned long size = data->blksz;        if (cpu_is_at91sam9260() && size < 16 )                size = 16;        at91_mci_write(host, ATMEL_PDC_TCR, (size & 0x3) ? size : size / 4);}> +>                               ier = AT91_MCI_CMDRDY;>                       }>               }
Best regards
Marcÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
