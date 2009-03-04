Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbZCDCZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbZCDCZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 21:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbZCDCZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 21:25:15 -0500
Received: from mail.windriver.com ([147.11.1.11]:45034 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbZCDCZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 21:25:13 -0500
Message-ID: <49ADE738.2080108@windriver.com>
Date: Wed, 04 Mar 2009 10:28:08 +0800
From: Danny Feng <Xiaotian.Feng@windriver.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: galak@kernel.crashing.org, linuxppc-dev@ozlabs.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] [POWERPC] cpm_uart: fix non-console port startup bug
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Mar 2009 02:25:04.0064 (UTC) FILETIME=[6D4A8400:01C99C70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

after UART interrupt handler is installed and rx is enabled, if an rx
interrupt comes before hardware init, rx->cur will be updated. Then the
hardware init will reset BD and make rx->cur out of sync, move the hardware
init code before request_irq.

Signed-off-by: Xiaotian Feng <xiaotian.feng@windriver.com>
---
diff --git a/drivers/serial/cpm_uart/cpm_uart_core.c
b/drivers/serial/cpm_uart/cpm_uart_core.c
index bde4b4b..5c6ef51 100644
--- a/drivers/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -406,6 +406,18 @@ static int cpm_uart_startup(struct uart_port *port)

        pr_debug("CPM uart[%d]:startup\n", port->line);

+       /* If the port is not the console, make sure rx is disabled. */
+       if (!(pinfo->flags & FLAG_CONSOLE)) {
+               /* Disable UART rx */
+               if (IS_SMC(pinfo)) {
+                       clrbits16(&pinfo->smcp->smc_smcmr, SMCMR_REN);
+                       clrbits8(&pinfo->smcp->smc_smcm, SMCM_RX);
+               } else {
+                       clrbits32(&pinfo->sccp->scc_gsmrl, SCC_GSMRL_ENR);
+                       clrbits16(&pinfo->sccp->scc_sccm, UART_SCCM_RX);
+               }
+               cpm_line_cr_cmd(pinfo, CPM_CR_INIT_TRX);
+       }
        /* Install interrupt handler. */
        retval = request_irq(port->irq, cpm_uart_int, 0, "cpm_uart", port);
        if (retval)
@@ -420,8 +432,6 @@ static int cpm_uart_startup(struct uart_port *port)
                setbits32(&pinfo->sccp->scc_gsmrl, (SCC_GSMRL_ENR |
SCC_GSMRL_ENT));
        }

-       if (!(pinfo->flags & FLAG_CONSOLE))
-               cpm_line_cr_cmd(pinfo, CPM_CR_INIT_TRX);
        return 0;
 }



