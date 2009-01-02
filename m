Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbZABKoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbZABKoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757534AbZABKlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:41:47 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:34104 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765AbZABKli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:41:38 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: [PATCH] m68k: atari_scc - kill warn_unused_result warnings
Date: Fri,  2 Jan 2009 11:41:21 +0100
Message-Id: <1230892892-25751-9-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1230892892-25751-8-git-send-email-geert@linux-m68k.org>
References: <1230892892-25751-1-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-2-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-3-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-4-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-5-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-6-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-7-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-8-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: ignoring return value of 'request_irq', declared with attribute
warn_unused_result

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
---
 drivers/char/atari_scc.c |  177 +++++++++++++++++++++++++++++++++-------------
 1 files changed, 128 insertions(+), 49 deletions(-)

diff --git a/drivers/char/atari_scc.c b/drivers/char/atari_scc.c
index e407aa8..5dc59ff 100644
--- a/drivers/char/atari_scc.c
+++ b/drivers/char/atari_scc.c
@@ -276,10 +276,99 @@ static void scc_init_portstructs(void)
 }
 
 
+static int atari_scc_a_request_irqs(struct scc_port *port)
+{
+	int error;
+
+	error = request_irq(IRQ_SCCA_TX, scc_tx_int, IRQ_TYPE_PRIO, "SCC-A TX",
+			    port);
+	if (error)
+		goto fail;
+
+	error = request_irq(IRQ_SCCA_STAT, scc_stat_int, IRQ_TYPE_PRIO,
+			    "SCC-A status", port);
+	if (error)
+		goto fail_free_a_tx;
+
+	error = request_irq(IRQ_SCCA_RX, scc_rx_int, IRQ_TYPE_PRIO, "SCC-A RX",
+			    port);
+	if (error)
+		goto fail_free_a_stat;
+
+	error = request_irq(IRQ_SCCA_SPCOND, scc_spcond_int, IRQ_TYPE_PRIO,
+			    "SCC-A special cond", port);
+	if (error)
+		goto fail_free_a_rx;
+
+	return 0;
+
+fail_free_a_rx:
+	free_irq(IRQ_SCCA_RX, port);
+fail_free_a_stat:
+	free_irq(IRQ_SCCA_STAT, port);
+fail_free_a_tx:
+	free_irq(IRQ_SCCA_TX, port);
+fail:
+	return error;
+}
+
+static void atari_scc_a_free_irqs(struct scc_port *port)
+{
+	free_irq(IRQ_SCCA_TX, port);
+	free_irq(IRQ_SCCA_STAT, port);
+	free_irq(IRQ_SCCA_RX, port);
+	free_irq(IRQ_SCCA_SPCOND, port);
+}
+
+static int atari_scc_b_request_irqs(struct scc_port *port)
+{
+	int error;
+
+	error = request_irq(IRQ_SCCB_TX, scc_tx_int, IRQ_TYPE_PRIO, "SCC-B TX",
+			    port);
+	if (error)
+		goto fail;
+
+	error = request_irq(IRQ_SCCB_STAT, scc_stat_int, IRQ_TYPE_PRIO,
+			    "SCC-B status", port);
+	if (error)
+		goto fail_free_b_tx;
+
+	error = request_irq(IRQ_SCCB_RX, scc_rx_int, IRQ_TYPE_PRIO, "SCC-B RX",
+			    port);
+	if (error)
+		goto fail_free_b_stat;
+
+	error = request_irq(IRQ_SCCB_SPCOND, scc_spcond_int, IRQ_TYPE_PRIO,
+			    "SCC-B special cond", port);
+	if (error)
+		goto fail_free_b_rx;
+
+	return 0;
+
+fail_free_b_rx:
+	free_irq(IRQ_SCCB_RX, port);
+fail_free_b_stat:
+	free_irq(IRQ_SCCB_STAT, port);
+fail_free_b_tx:
+	free_irq(IRQ_SCCB_TX, port);
+fail:
+	return error;
+}
+
+static void atari_scc_b_free_irqs(struct scc_port *port)
+{
+	free_irq(IRQ_SCCB_TX, port);
+	free_irq(IRQ_SCCB_STAT, port);
+	free_irq(IRQ_SCCB_RX, port);
+	free_irq(IRQ_SCCB_SPCOND, port);
+}
+
 #ifdef CONFIG_TT_SCC
 static int atari_tt_scc_init(void)
 {
 	struct scc_port *port;
+	int error;
 
 	pr_info("SCC: Atari TT Serial Driver\n");
 	/* FIXME channel A may be switchable between modem and LAN port */
@@ -294,12 +383,10 @@ static int atari_tt_scc_init(void)
 	port->port_a = &scc_ports[0];
 	port->port_b = &scc_ports[1];
 	pr_debug("SCC: request channel A irqs, port = %p\n", port);
-	request_irq(IRQ_SCCA_TX, scc_tx_int, IRQ_TYPE_PRIO, "SCC-A TX", port);
-	request_irq(IRQ_SCCA_STAT, scc_stat_int, IRQ_TYPE_PRIO,
-		    "SCC-A status", port);
-	request_irq(IRQ_SCCA_RX, scc_rx_int, IRQ_TYPE_PRIO, "SCC-A RX", port);
-	request_irq(IRQ_SCCA_SPCOND, scc_spcond_int, IRQ_TYPE_PRIO,
-		    "SCC-A special cond", port);
+	error = atari_scc_a_request_irqs(port);
+	if (error)
+		return error;
+
 	{
 		SCC_ACCESS_INIT(port);
 		pr_debug("SCC: read SCC status\n");
@@ -335,14 +422,12 @@ static int atari_tt_scc_init(void)
 		port->port_a = &scc_ports[0];
 		port->port_b = &scc_ports[1];
 		pr_debug("SCC: request channel B irqs, port = %p\n", port);
-		request_irq(IRQ_SCCB_TX, scc_tx_int, IRQ_TYPE_PRIO,
-			    "SCC-B TX", port);
-		request_irq(IRQ_SCCB_STAT, scc_stat_int, IRQ_TYPE_PRIO,
-			    "SCC-B status", port);
-		request_irq(IRQ_SCCB_RX, scc_rx_int, IRQ_TYPE_PRIO,
-			    "SCC-B RX", port);
-		request_irq(IRQ_SCCB_SPCOND, scc_spcond_int, IRQ_TYPE_PRIO,
-			    "SCC-B special cond", port);
+		error = atari_scc_b_request_irqs(port);
+		if (error) {
+			atari_scc_a_free_irqs(port);
+			return error;
+		}
+
 		{
 			SCC_ACCESS_INIT(port);
 
@@ -351,8 +436,13 @@ static int atari_tt_scc_init(void)
 		}
 /* not implemented yet */
 #if 0
-		request_irq(IRQ_TT_MFP_RI, scc_ri_int, IRQ_TYPE_SLOW,
-			    "TT-MFP ring indicator (modem 2)", port);
+		error = request_irq(IRQ_TT_MFP_RI, scc_ri_int, IRQ_TYPE_SLOW,
+				    "TT-MFP ring indicator (modem 2)", port);
+		if (error) {
+			atari_scc_b_free_irqs(port);
+			atari_scc_a_free_irqs(port);
+			return error;
+		}
 #endif
 
 	}
@@ -381,6 +471,7 @@ static int atari_tt_scc_init(void)
 static int atari_falcon_scc_init(void)
 {
 	struct scc_port *port;
+	int error;
 
 	pr_info("SCC: Atari Falcon Serial Driver\n");
 	if (atari_SCC_init_done)
@@ -393,12 +484,10 @@ static int atari_falcon_scc_init(void)
 	port->datap = port->ctrlp + 2;
 	port->port_a = &scc_ports[0];
 	port->port_b = &scc_ports[1];
-	request_irq(IRQ_SCCA_TX, scc_tx_int, IRQ_TYPE_PRIO, "SCC-A TX", port);
-	request_irq(IRQ_SCCA_STAT, scc_stat_int, IRQ_TYPE_PRIO,
-		    "SCC-A status", port);
-	request_irq(IRQ_SCCA_RX, scc_rx_int, IRQ_TYPE_PRIO, "SCC-A RX", port);
-	request_irq(IRQ_SCCA_SPCOND, scc_spcond_int, IRQ_TYPE_PRIO,
-		    "SCC-A special cond", port);
+	error = atari_scc_a_request_irqs(port);
+	if (error)
+		return error;
+
 	{
 		SCC_ACCESS_INIT(port);
 
@@ -429,12 +518,11 @@ static int atari_falcon_scc_init(void)
 	port->datap = port->ctrlp + 2;
 	port->port_a = &scc_ports[0];
 	port->port_b = &scc_ports[1];
-	request_irq(IRQ_SCCB_TX, scc_tx_int, IRQ_TYPE_PRIO, "SCC-B TX", port);
-	request_irq(IRQ_SCCB_STAT, scc_stat_int, IRQ_TYPE_PRIO,
-		    "SCC-B status", port);
-	request_irq(IRQ_SCCB_RX, scc_rx_int, IRQ_TYPE_PRIO, "SCC-B RX", port);
-	request_irq(IRQ_SCCB_SPCOND, scc_spcond_int, IRQ_TYPE_PRIO,
-		    "SCC-B special cond", port);
+	error = atari_scc_b_request_irqs(port);
+	if (error) {
+		atari_scc_a_free_irqs(port);
+		return error;
+	}
 
 	{
 		SCC_ACCESS_INIT(port);	/* Either channel will do */
@@ -461,6 +549,7 @@ static int atari_st_scc_init(void)
 {
 	struct scc_port *port;
 	int escc = ATARIHW_PRESENT(ST_ESCC);
+	int error;
 
 	pr_info("SCC: Atari MegaST/E Serial Driver\n");
 	/* FIXME: ports reversed logic */
@@ -472,12 +561,10 @@ static int atari_st_scc_init(void)
 	port->datap = port->ctrlp + 4;
 	port->port_a = &scc_ports[1];
 	port->port_b = &scc_ports[0];
-	request_irq(IRQ_SCCA_TX, scc_tx_int, IRQ_TYPE_PRIO, "SCC-A TX", port);
-	request_irq(IRQ_SCCA_STAT, scc_stat_int, IRQ_TYPE_PRIO,
-		    "SCC-A status", port);
-	request_irq(IRQ_SCCA_RX, scc_rx_int, IRQ_TYPE_PRIO, "SCC-A RX", port);
-	request_irq(IRQ_SCCA_SPCOND, scc_spcond_int, IRQ_TYPE_PRIO,
-		    "SCC-A special cond", port);
+	error = atari_scc_a_request_irqs(port);
+	if (error)
+		return error;
+
 	{
 		SCC_ACCESS_INIT(port);
 
@@ -508,12 +595,11 @@ static int atari_st_scc_init(void)
 	port->datap = port->ctrlp + 4;
 	port->port_a = &scc_ports[0];
 	port->port_b = &scc_ports[1];
-	request_irq(IRQ_SCCB_TX, scc_tx_int, IRQ_TYPE_PRIO, "SCC-B TX", port);
-	request_irq(IRQ_SCCB_STAT, scc_stat_int, IRQ_TYPE_PRIO,
-		    "SCC-B status", port);
-	request_irq(IRQ_SCCB_RX, scc_rx_int, IRQ_TYPE_PRIO, "SCC-B RX", port);
-	request_irq(IRQ_SCCB_SPCOND, scc_spcond_int, IRQ_TYPE_PRIO,
-		    "SCC-B special cond", port);
+	error = atari_scc_b_request_irqs(port);
+	if (error) {
+		atari_scc_a_free_irqs(port);
+		return error;
+	}
 
 	{
 		SCC_ACCESS_INIT(port);	/* Either channel will do */
@@ -571,18 +657,11 @@ void atari_scc_cleanup(void)
 	tty_unregister_driver(scc_driver);
 	port = &scc_ports[0];
 	pr_debug("SCC: free channel A irqs, port = %p\n", port);
-	free_irq(IRQ_SCCA_TX, port);
-	free_irq(IRQ_SCCA_STAT, port);
-	free_irq(IRQ_SCCA_RX, port);
-	free_irq(IRQ_SCCA_SPCOND, port);
+	atari_scc_a_free_irqs(port);
 
 	port = &scc_ports[1];
 	pr_debug("SCC: free channel A irqs, port = %p\n", port);
-	free_irq(IRQ_SCCB_TX, port);
-	free_irq(IRQ_SCCB_STAT, port);
-	free_irq(IRQ_SCCB_RX, port);
-	free_irq(IRQ_SCCB_SPCOND, port);
-
+	atari_scc_b_free_irqs(port);
 }
 
 module_init(atari_scc_init);
-- 
1.5.6.5

