Return-Path: <linux-kernel-owner+w=401wt.eu-S1423211AbXBBHzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423211AbXBBHzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 02:55:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423213AbXBBHzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 02:55:08 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:44141 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423211AbXBBHzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 02:55:06 -0500
Message-ID: <45C2EE52.4020103@drzeus.cx>
Date: Fri, 02 Feb 2007 08:54:58 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
MIME-Version: 1.0
To: linux@youmustbejoking.demon.co.uk, linux-kernel@vger.kernel.org,
       sdhci-devel@list.drzeus.cx
Subject: Re: [Sdhci-devel] [PATCH 2.6.20-rc2] Add a quirk to allow ENE PCI
 SD	card readers to work again
References: <4E9DA5E8EB%linux@youmustbejoking.demon.co.uk>	<4597A791.60007@drzeus.cx>	<4E9DE7C297%linux@youmustbejoking.demon.co.uk> <4E9DF295D4%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <4E9DF295D4%linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darren,

It has come to my attention that the current routine for setting power
is not compliant with the specification. As such, I'd like you to try
the following and see if removes the need for your patch:

diff --git a/drivers/mmc/sdhci.c b/drivers/mmc/sdhci.c
index dc1b04a..13ac2fe 100644
--- a/drivers/mmc/sdhci.c
+++ b/drivers/mmc/sdhci.c
@@ -685,23 +690,21 @@ static void sdhci_set_power(struct sdhci_host
*host, unsigned short power)
        if (power == (unsigned short)-1)
                goto out;

-       pwr = SDHCI_POWER_ON;
-
        switch (power) {
        case MMC_VDD_170:
        case MMC_VDD_180:
        case MMC_VDD_190:
-               pwr |= SDHCI_POWER_180;
+               pwr = SDHCI_POWER_180;
                break;
        case MMC_VDD_290:
        case MMC_VDD_300:
        case MMC_VDD_310:
-               pwr |= SDHCI_POWER_300;
+               pwr = SDHCI_POWER_300;
                break;
        case MMC_VDD_320:
        case MMC_VDD_330:
        case MMC_VDD_340:
-               pwr |= SDHCI_POWER_330;
+               pwr = SDHCI_POWER_330;
                break;
        default:
                BUG();
@@ -709,6 +712,10 @@ static void sdhci_set_power(struct sdhci_host
*host, unsigned short power)

        writeb(pwr, host->ioaddr + SDHCI_POWER_CONTROL);

+       pwr |= SDHCI_POWER_ON;
+
+       writeb(pwr, host->ioaddr + SDHCI_POWER_CONTROL);
+
 out:
        host->power = power;
 }


I'd appreciate if you could test this sooner rather than later as the
merge window is just around the corner.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
