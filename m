Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbXIWUS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbXIWUS0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 16:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbXIWURk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 16:17:40 -0400
Received: from mail0.scram.de ([78.47.204.202]:38655 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755974AbXIWURi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 16:17:38 -0400
X-Spam-Score: -4.287
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.1 AWL AWL: From: address is in the auto white-list
Message-ID: <46F6C9DC.90008@scram.de>
Date: Sun, 23 Sep 2007 22:17:32 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: linuxppc-embedded@ozlabs.org
CC: linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>
Subject: [PATCH4/4] [POWERPC] Fix cpm_uart driver
Content-Type: multipart/mixed;
 boundary="------------090404010006030000030102"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090404010006030000030102
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


In cpm_uart_core, functions cpm_uart_init_bd and cpm_uart_init_scc
an offset into DP RAM is calculated by substracting a physical
memory constant from an virtual address. This patch fixes the
problem by converting the virtual address into a physical
first.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 drivers/serial/cpm_uart/cpm_uart_core.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

--------------090404010006030000030102
Content-Type: text/x-patch;
 name="2c5cf6868e9aa6eadea285e524d88859cc5e54fb.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2c5cf6868e9aa6eadea285e524d88859cc5e54fb.diff"

diff --git a/drivers/serial/cpm_uart/cpm_uart_core.c b/drivers/serial/cpm_uart/cpm_uart_core.c
index cefde58..7f5db7c 100644
--- a/drivers/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -752,8 +752,10 @@ static void cpm_uart_init_scc(struct uart_cpm_port *pinfo)
 	sup = pinfo->sccup;
 
 	/* Store address */
-	pinfo->sccup->scc_genscc.scc_rbase = (unsigned char *)pinfo->rx_bd_base - DPRAM_BASE;
-	pinfo->sccup->scc_genscc.scc_tbase = (unsigned char *)pinfo->tx_bd_base - DPRAM_BASE;
+	pinfo->sccup->scc_genscc.scc_rbase = 
+		(u_char *)cpm_dpram_phys((u8 *)pinfo->rx_bd_base) - DPRAM_BASE;
+	pinfo->sccup->scc_genscc.scc_tbase = 
+		(u_char *)cpm_dpram_phys((u8 *)pinfo->tx_bd_base) - DPRAM_BASE;
 
 	/* Set up the uart parameters in the
 	 * parameter ram.
@@ -813,8 +815,10 @@ static void cpm_uart_init_smc(struct uart_cpm_port *pinfo)
 	up = pinfo->smcup;
 
 	/* Store address */
-	pinfo->smcup->smc_rbase = (u_char *)pinfo->rx_bd_base - DPRAM_BASE;
-	pinfo->smcup->smc_tbase = (u_char *)pinfo->tx_bd_base - DPRAM_BASE;
+	pinfo->smcup->smc_rbase = 
+		(u_char *)cpm_dpram_phys((u8 *)pinfo->rx_bd_base) - DPRAM_BASE;
+	pinfo->smcup->smc_tbase = 
+		(u_char *)cpm_dpram_phys((u8 *)pinfo->tx_bd_base) - DPRAM_BASE;
 
 /*
  *  In case SMC1 is being relocated...


--------------090404010006030000030102--
