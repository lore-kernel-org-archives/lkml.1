Return-Path: <linux-kernel-owner+w=401wt.eu-S1763789AbZFLVoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763789AbZFLVoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 17:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757470AbZFLVob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 17:44:31 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:55790 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbZFLVoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 17:44:30 -0400
Message-ID: <4A32CC36.2070207@mnementh.co.uk>
Date: Fri, 12 Jun 2009 22:44:22 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Philipp Zabel <philipp.zabel@gmail.com>
CC: linux-kernel@vger.kernel.org, Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH 6/7] mmc: tmio_mmc: fix SDCLK divider setting
References: <1244139157-16404-1-git-send-email-philipp.zabel@gmail.com> <1244139157-16404-7-git-send-email-philipp.zabel@gmail.com>
In-Reply-To: <1244139157-16404-7-git-send-email-philipp.zabel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philipp Zabel wrote:
> Except for the SDCLK = HCLK (divider bypassed) case, the clock
> setting resulted in double the requested frequency.
> The smallest possible frequency (f_max/512) is configured with
> a divider setting 0x80, not 0x40.

I have (IMO) a better fix, which also removes some crap being written to 
CTL_SD_CARD_CLK_CTL.

Pierre, please replace patch 6/7 from Philips set with this one.

 From e69efa520b07a688643ce5f8e8d41bef753ff1ed Mon Sep 17 00:00:00 2001
From: Ian Molton <ian@mnementh.co.uk>
Date: Fri, 12 Jun 2009 21:53:05 +0100
Subject: [PATCH] MMC: fix clock setup in tmio_mmc

This patch fixes the clock setup in tmio_mmc.

  * Incorrect divider setting
  * Cruft written to the clock registers (seemingly harmless but Not 
Good (tm))

It also eliminates some unnecessary ifs and tidies the loop syntax.

Thanks to Philipp Zabel who discovered the divider issue, commenting

   "Except for the SDCLK = HCLK (divider bypassed) case, the clock
    setting resulted in double the requested frequency.
    The smallest possible frequency (f_max/512) is configured with
    a divider setting 0x80, not 0x40."

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
  drivers/mmc/host/tmio_mmc.c |   15 +++++----------
  1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index fe6d2b6..10951b7 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -37,22 +37,17 @@

  static void tmio_mmc_set_clock(struct tmio_mmc_host *host, int new_clock)
  {
-	u32 clk = 0, clock, f_min = host->mmc->f_min;
+	u32 clk = 0, clock;

  	if (new_clock) {
-		for (clock = f_min, clk = 0x100; new_clock >= (clock<<1); ) {
+		for (clock = host->mmc->f_min, clk = 0x80000080;
+			new_clock >= (clock<<1); clk >>= 1)
  			clock <<= 1;
-			clk >>= 1;
-		}
-		if (clk & 0x1)
-			clk = 0x20000;
-
-		clk >>= 2;
-		sd_config_write8(host, CNF_SD_CLK_MODE, (clk & 0x8000) ? 0 : 1);
  		clk |= 0x100;
  	}

-	sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, clk);
+	sd_config_write8(host, CNF_SD_CLK_MODE, clk >> 22);
+	sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, clk & 0x1ff);
  }

  static void tmio_mmc_clk_stop(struct tmio_mmc_host *host)
-- 
1.6.3.1
