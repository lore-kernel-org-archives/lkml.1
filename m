Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbYFXX6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbYFXX6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 19:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYFXX6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 19:58:35 -0400
Received: from webmail.chats.mrv.com ([66.43.110.3]:45369 "EHLO
	chmailsrv.int.mrv.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751724AbYFXX6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 19:58:35 -0400
Message-ID: <48618A18.3020607@mrv.com>
Date: Tue, 24 Jun 2008 16:58:16 -0700
From: Nye Liu <nyet@mrv.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] CPM1: Don't send break on TX_STOP, don't interrupt	RX/TX
 when adjusting termios parameters
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2008 00:00:09.0060 (UTC) FILETIME=[6E913240:01C8D656]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nye Liu <nyet@mrv.com>

Before setting STOP_TX, set _brkcr to 0 so the SMC does not send a break
character. The driver appears to properly re-initialize _brkcr when the SMC is
restarted.

Do not interrupt RX/TX when the termios is being adjusted; it results in
corrupted characters appearing on the line.

Signed-off-by: Nye Liu <nyet@mrv.com>

---

diff --git a/drivers/serial/cpm_uart/cpm_uart_core.c b/drivers/serial/cpm_uart/cpm_uart_core.c
index a19dc7e..babd06b 100644
--- a/drivers/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -476,10 +476,13 @@ static void cpm_uart_shutdown(struct uart_port *port)
 		}
 
 		/* Shut them really down and reinit buffer descriptors */
-		if (IS_SMC(pinfo))
+		if (IS_SMC(pinfo)) {
+			out_be16(&pinfo->smcup->smc_brkcr, 0);
 			cpm_line_cr_cmd(pinfo, CPM_CR_STOP_TX);
-		else
+		} else {
+			out_be16(&pinfo->sccup->scc_brkcr, 0);
 			cpm_line_cr_cmd(pinfo, CPM_CR_GRA_STOP_TX);
+		}
 
 		cpm_uart_initbd(pinfo);
 	}
@@ -590,9 +593,11 @@ static void cpm_uart_set_termios(struct uart_port *port,
 		 * enables, because we want to put them back if they were
 		 * present.
 		 */
-		prev_mode = in_be16(&smcp->smc_smcmr);
-		out_be16(&smcp->smc_smcmr, smcr_mk_clen(bits) | cval | SMCMR_SM_UART);
-		setbits16(&smcp->smc_smcmr, (prev_mode & (SMCMR_REN | SMCMR_TEN)));
+		prev_mode = in_be16(&smcp->smc_smcmr) & (SMCMR_REN | SMCMR_TEN);
+		/* Output in *one* operation, so we don't interrupt RX/TX if they
+		 * were already enabled. */
+		out_be16(&smcp->smc_smcmr, smcr_mk_clen(bits) | cval |
+		    SMCMR_SM_UART | prev_mode);
 	} else {
 		out_be16(&sccp->scc_psmr, (sbits << 12) | scval);
 	}
@@ -1324,12 +1329,14 @@ static int __init cpm_uart_console_setup(struct console *co, char *options)
 	udbg_putc = NULL;
 #endif
 
-	cpm_line_cr_cmd(pinfo, CPM_CR_STOP_TX);
-
 	if (IS_SMC(pinfo)) {
+		out_be16(&pinfo->smcup->smc_brkcr, 0);
+		cpm_line_cr_cmd(pinfo, CPM_CR_STOP_TX);
 		clrbits8(&pinfo->smcp->smc_smcm, SMCM_RX | SMCM_TX);
 		clrbits16(&pinfo->smcp->smc_smcmr, SMCMR_REN | SMCMR_TEN);
 	} else {
+		out_be16(&pinfo->sccup->scc_brkcr, 0);
+		cpm_line_cr_cmd(pinfo, CPM_CR_GRA_STOP_TX);
 		clrbits16(&pinfo->sccp->scc_sccm, UART_SCCM_TX | UART_SCCM_RX);
 		clrbits32(&pinfo->sccp->scc_gsmrl, SCC_GSMRL_ENR | SCC_GSMRL_ENT);
 	}

-- 
Nye Liu
nliu@mrv.com
(818) 772-6235x248
(818) 772-0576 fax

"Who would be stupid enough to quote a fictitious character?"
	-- Don Quixote
