Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbZEYT1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbZEYT1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 15:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbZEYT1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 15:27:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:55626 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbZEYT1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 15:27:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XGKZw8onDmd9UblM7hl13t7gZ9J/jLP9ugwik2vV54ldU7bgj8nBwrHD/H6kXiS5s+
         Mgwt61uG8Y5EsTkX6RmERQVv2s6n2v0Hn3pJUPOZmo+6kSCQqbL+Y2tCafBxmGMcPckO
         H+47GpmR6V0wtjIzWmheBamEMyU/iRktPqc3c=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Molton <spyro@f2s.com>
Subject: [PATCH 0/6] Preparations for ASIC3 support in the TMIO MMC driver
Date: Mon, 25 May 2009 21:27:56 +0200
Message-Id: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series is really only two parts preparation for ASIC3:
 [PATCH 1/5] MFD,mmc: tmio_mmc: make HCLK configurable
 [PATCH 2/5] mmc: tmio_mmc: add bus_shift support
and three parts cleanup:
 [PATCH 3/5] mmc: tmio_mmc: don't use set_irq_type
 [PATCH 4/5] mmc: tmio_mmc: correct probe return value for num_resources != 3
 [PATCH 5/5] mmc: tmio_mmc: move probe function into __init section

I have still a few remaining differences until tmio_mmc can support ASIC3,
but as patch 2/5 causes changes all over the place, I'd like to get feedback
on that before piling patches on top of it.

I also have a question about the clock divider settings. Currently,
tmio_mmc_set_clock returns the wrong divider setting for new_clock=f_min
(0x40 instead of 0x80). I tried to fix it like below:

+#define TMIO_CARD_CLOCK_ENABLE 0x0100
+#define TMIO_CARD_CLOCK_FOR_SD 0x8000
+
-static void tmio_mmc_set_clock(struct tmio_mmc_host *host, int new_clock)
+static void tmio_mmc_set_clock(struct tmio_mmc_host *host, int new_clock)
 {
        u32 clk = 0, clock;
 
        if (new_clock) {
                for (clock = host->mmc->f_min, clk = 0x100; new_clock >= (clock<<1); ) {
                        clock <<= 1;
                        clk >>= 1;
                }
-               if (clk & 0x1)
-                       clk = 0x20000;
+               /* For fastest speed we disable the divider. */
+               sd_config_write8(host, CNF_SD_CLK_MODE, (clk == 0) ? 0 : 1);
+               clk >>= 1;
 
-               clk >>= 2;
-               sd_config_write8(host, CNF_SD_CLK_MODE, (clk & 0x8000) ? 0 : 1);
-               clk |= 0x100;
+               clk |= host->clock_for_sd | TMIO_CARD_CLOCK_ENABLE;
        }
 
        sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, clk);

But the ASIC3 code was handling the 0x8000 bit (called FOR_SD in the ASIC3 headers)
of CTL_SD_CARD_CLK_CTL differently - there it was enabled/disabled based on 1-bit
or 4-bit MMC mode. I have no idea what it is good for - is there any TMIO documentation
available that includes this information?

regards
Philipp
