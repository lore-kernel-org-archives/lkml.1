Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbZEYDKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbZEYDKH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 23:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZEYDJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 23:09:58 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:52866 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbZEYDJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 23:09:57 -0400
Date: Mon, 25 May 2009 11:09:42 +0800
From: Harald Welte <HaraldWelte@viatech.com>
To: JosephChan@via.com.tw
Cc: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org, arnd@arndb.de,
       ben-linux@fluff.org, Bruce Chang <BruceChang@via.com.tw>
Subject: Re: [Patch 1/1 v5] via-sdmmc: VIA MSP card reader driver support
Message-ID: <20090525030942.GC8702@prithivi.gnumonks.org>
References: <20090410203520.6e43acb2@mjolnir.ossman.eu> <C80EF34A3D2E494DBAF9AC29C7AE4EB8090CA2D4@exchtp03.taipei.via.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB8090CA2D4@exchtp03.taipei.via.com.tw>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Joseph, Pierre and others.

Since the driver has still not made any progress in recent days, I took the
liberty of "adopting" it.  It can now be found in my linux-2.6-via.git
repository under the via-vx855-sdmmc branch (gitweb at
http://git.gnumonks.org/cgi-bin/gitweb.cgi?p=linux-2.6-via.git;a=shortlog;h=refs/heads/via-vx855-sdmmc)

As you can see, there are five incremental patches compared to the last v5
release that Joseph posted in April.

On Wed, Apr 22, 2009 at 01:35:29AM +0800, JosephChan@via.com.tw wrote:

> >> +nodata:
> >> +	if (cmd->opcode == MMC_STOP_TRANSMISSION)
> >> +		cmdctrl |= VIA_CRDR_SDCTRL_STOP;
> > >+
> 
> >I didn't check this part properly the last time. I'm assuming you're telling
> >the hardware that this is a command that terminates a data transmission? If
> >so, you cannot check the opcode like that. There might be other stop
> >commands.
> >What you need to do is to either pass another parameter to your function
> >when you're calling it with data->stop, or simply have a test in there if
> >cmd == data->stop (or mrq->stop, whichever is most convenient).
> 
> OK, we will change to 
>        if(cmd == host->mrq->stop)
>              cmdctrl |= VIA_CRDR_SDCTRL_STOP;

done.

> >> +	else if (ios->clock >=  5000000)
> >> +		clock = PCI_CLK_8M;
> >>+	else
> >>+		clock = PCI_CLK_375K;
> >>+
> 
> > This looks a bit strange. Why are you not comparing with the clock
> > frequency you'll be setting?
> 
> Do you mean that we should check the current clock frequency before setting?
> But our engineer thinks that the following lines can do that work normally
> too: Any comment? 

Well, if the "PCI_CLK" line and the corresponding register actually 1:1
correspond to the actual SD card clock rate, then 

>               else if (ios->clock >=  5000000)
>                      clock = PCI_CLK_8M;

would mean we use 8MHz even at the time the MMC core stack asks us to only
use 5MHz, whcih is a bug!

I have fixed this in my git tree now.

> >> +	mmc->caps = MMC_CAP_4_BIT_DATA;
> 
> > You also need to set the bits stating if the controller supports the
> > high-speed SD and/or MMC mode, otherwise the core won't go over 25/20 MHz.
> 
> 
> OK, we will add the following line in the via_init_mmc_host function:
> 
>        mmc->caps |= MMC_CAP_MMC_HIGHSPEED |MMC_CAP_SD_HIGHSPEED;

Since I cannot see any indication from the VX800 / VX855 data sheet that HS-MMC
is actually supported, I only use SD_HIGHSPEED for now.

Joseph: Can you find out if the controller actually supports HS-MMC, not only
SD highspeed?

>        org_data = readl(addrbase + VIA_CRDR_SDEXTCTRL);
> 
>        if ((ios->timing == MMC_TIMING_SD_HS) || (ios->timing == MMC_TIMING_MMC_HS))
>               org_data |= VIA_CRDR_SDEXTCTRL_HISPD;
>        else
>               org_data &= ~VIA_CRDR_SDEXTCTRL_HISPD;
> 
>        writel(org_data, addrbase + VIA_CRDR_SDEXTCTRL);       

tried that, unfortunately this is buggy, since org_data refers to SDBUSMODE rather than SDEXTCTRL. I've fixed it in this patch:
http://git.gnumonks.org/cgi-bin/gitweb.cgi?p=linux-2.6-via.git;a=commitdiff;h=bb1f9f2d9d51bbf294ae036d02e2546f2d8b36c3

The resulting driver runs so far fine on my VX855ES based board, but I'll give
it some more testing before re-submitting the patch.

There is also one case in the code where due to a DMA controller bug, we force
the clock to 8MHz despite the MMC core requesting 375kHz.  I think the proper
fix here is to fall back on PIO (non-DMA) mode for 375kHz, rather than
overclocking the poor card by more than 21 times.

After that has been fixed, plus some more testing, I'll re-submit.

Regards,
-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Open Source Liaison
