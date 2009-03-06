Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbZCFC7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbZCFC7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 21:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZCFC7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 21:59:34 -0500
Received: from mail.windriver.com ([147.11.1.11]:49639 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbZCFC7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 21:59:33 -0500
From: Xiaotian Feng <Xiaotian.Feng@windriver.com>
To: galak@kernel.crashing.org, panto@intracom.gr, linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] cpm_uart: fix non-console port startup bug
Date: Fri,  6 Mar 2009 11:01:23 +0800
Message-Id: <1236308483-20495-1-git-send-email-Xiaotian.Feng@windriver.com>
X-Mailer: git-send-email 1.5.5.1
X-OriginalArrivalTime: 06 Mar 2009 02:58:12.0177 (UTC) FILETIME=[631FFC10:01C99E07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  After UART interrupt handler is installed and rx is enabled, if an rx
interrupt comes before hardware init, rx->cur will be updated. Then the
hardware init will reset BD and make rx->cur out of sync, move the hardware
init code before request_irq.

  Signed-off-by: Xiaotian Feng <xiaotian.feng@windriver.com>
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
 
-- 
1.5.5.1

