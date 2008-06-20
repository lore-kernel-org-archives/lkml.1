Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbYFTUCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbYFTUCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbYFTUCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:02:05 -0400
Received: from webmail.chats.mrv.com ([66.43.110.3]:51001 "EHLO
	chmailsrv.int.mrv.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753002AbYFTUCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:02:04 -0400
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jun 2008 16:02:04 EDT
Date: Fri, 20 Jun 2008 12:46:50 -0700
From: Nye Liu <nyet@mrv.com>
To: panto@intracom.gr
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] CPM1: Don't send break on TX_STOP, don't interrupt
	RX/TX when adjusting termios parameters
Message-ID: <20080620194650.GA30019@mrv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 20 Jun 2008 19:48:29.0924 (UTC) FILETIME=[9D20E240:01C8D30E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nye Liu <nyet@mrv.com>

Before setting STOP_TX, set _brkcr to 0 so the SMC does not send a break
character. The driver appears to properly re-initialize _brkcr when the SMC is
restarted.

Do not interrupt RX/TX when the termios is being adjusted; it results in
corrupted characters appearing on the line.

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
