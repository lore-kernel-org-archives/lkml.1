Return-Path: <linux-kernel-owner+w=401wt.eu-S1758843AbZCXOFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843AbZCXOFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757597AbZCXOCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:02:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48939 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757421AbZCXOC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:02:29 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 07/30] cpm_uart: fix non-console port startup bug
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       torvalds@linux-foundation.org
Date: Tue, 24 Mar 2009 14:02:51 +0000
Message-ID: <20090324140245.12735.29499.stgit@localhost.localdomain>
In-Reply-To: <20090324135930.12735.7827.stgit@localhost.localdomain>
References: <20090324135930.12735.7827.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaotian Feng <Xiaotian.Feng@windriver.com>

After UART interrupt handler is installed and rx is enabled, if an rx
interrupt comes before hardware init, rx->cur will be updated. Then the
hardware init will reset BD and make rx->cur out of sync, move the hardware
init code before request_irq.

Signed-off-by: Xiaotian Feng <xiaotian.feng@windriver.com>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/serial/cpm_uart/cpm_uart_core.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)


diff --git a/drivers/serial/cpm_uart/cpm_uart_core.c b/drivers/serial/cpm_uart/cpm_uart_core.c
index bde4b4b..5c6ef51 100644
--- a/drivers/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -406,6 +406,18 @@ static int cpm_uart_startup(struct uart_port *port)
 
 	pr_debug("CPM uart[%d]:startup\n", port->line);
 
+	/* If the port is not the console, make sure rx is disabled. */
+	if (!(pinfo->flags & FLAG_CONSOLE)) {
+		/* Disable UART rx */
+		if (IS_SMC(pinfo)) {
+			clrbits16(&pinfo->smcp->smc_smcmr, SMCMR_REN);
+			clrbits8(&pinfo->smcp->smc_smcm, SMCM_RX);
+		} else {
+			clrbits32(&pinfo->sccp->scc_gsmrl, SCC_GSMRL_ENR);
+			clrbits16(&pinfo->sccp->scc_sccm, UART_SCCM_RX);
+		}
+		cpm_line_cr_cmd(pinfo, CPM_CR_INIT_TRX);
+	}
 	/* Install interrupt handler. */
 	retval = request_irq(port->irq, cpm_uart_int, 0, "cpm_uart", port);
 	if (retval)
@@ -420,8 +432,6 @@ static int cpm_uart_startup(struct uart_port *port)
 		setbits32(&pinfo->sccp->scc_gsmrl, (SCC_GSMRL_ENR | SCC_GSMRL_ENT));
 	}
 
-	if (!(pinfo->flags & FLAG_CONSOLE))
-		cpm_line_cr_cmd(pinfo, CPM_CR_INIT_TRX);
 	return 0;
 }
 

