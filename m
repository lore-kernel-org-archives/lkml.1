Return-Path: <linux-kernel-owner+w=401wt.eu-S939229AbZDJSff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939229AbZDJSff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 14:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937772AbZDJSfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 14:35:24 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:41897 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937293AbZDJSfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 14:35:24 -0400
Date: Fri, 10 Apr 2009 20:35:20 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: JosephChan@via.com.tw
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, ben-linux@fluff.org
Subject: Re: [Patch 1/1 v5] via-sdmmc: VIA MSP card reader driver support
Message-ID: <20090410203520.6e43acb2@mjolnir.ossman.eu>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB808EBD84A@exchtp03.taipei.via.com.tw>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB808EBD84A@exchtp03.taipei.via.com.tw>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Apr 2009 10:24:02 +0800
JosephChan@via.com.tw wrote:

> Hi all,
> 
> The following patch provides VIA MSP SD/MMC card reader driver support.
> This patch is based on 2.6.29 kernel.
> Thanks to Pierre's suggestions.
> Please feel free to contact me if any problem. Thanks in advanced.
> 
> In addition, the SPEC is available in VX800 Programming guide (Device 13 Function 0) on http://linux.via.com.tw
> 

Looking good. There's just a few minor things. See below.

> +
> +nodata:
> +	if (cmd->opcode == MMC_STOP_TRANSMISSION)
> +		cmdctrl |= VIA_CRDR_SDCTRL_STOP;
> +

I didn't check this part properly the last time. I'm assuming you're
telling the hardware that this is a command that terminates a data
transmission? If so, you cannot check the opcode like that. There might
be other stop commands.

What you need to do is to either pass another parameter to your
function when you're calling it with data->stop, or simply have a test
in there if cmd == data->stop (or mrq->stop, whichever is most
convenient).

> +
> +	if (ios->clock >= 40000000)
> +		clock = PCI_CLK_48M;
> +	else if (ios->clock >= 30000000)
> +		clock = PCI_CLK_33M;
> +	else if (ios->clock >= 20000000)
> +		clock = PCI_CLK_24M;
> +	else if (ios->clock >= 15000000)
> +		clock = PCI_CLK_16M;
> +	else if (ios->clock >= 10000000)
> +		clock = PCI_CLK_12M;
> +	else if (ios->clock >=  5000000)
> +		clock = PCI_CLK_8M;
> +	else
> +		clock = PCI_CLK_375K;
> +

This looks a bit strange. Why are you not comparing with the clock
frequency you'll be setting?

> +
> +	mmc->f_min = VIA_CRDR_MIN_CLOCK;
> +	mmc->f_max = VIA_CRDR_MAX_CLOCK;
> +	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34 | MMC_VDD_165_195;
> +	mmc->caps = MMC_CAP_4_BIT_DATA;

You also need to set the bits stating if the controller supports the
high-speed SD and/or MMC mode, otherwise the core won't go over 25/20
MHz.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
  TigerVNC, core developer          http://www.tigervnc.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
