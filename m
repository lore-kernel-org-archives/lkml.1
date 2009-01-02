Return-Path: <linux-kernel-owner+w=401wt.eu-S1758508AbZABKpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508AbZABKpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757675AbZABKlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:41:53 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:37327 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747AbZABKli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:41:38 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Richard Hirst <richard@sleepie.demon.co.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] m68k: vme_scc - kill warn_unused_result warnings
Date: Fri,  2 Jan 2009 11:41:22 +0100
Message-Id: <1230892892-25751-10-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1230892892-25751-9-git-send-email-geert@linux-m68k.org>
References: <1230892892-25751-1-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-2-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-3-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-4-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-5-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-6-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-7-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-8-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-9-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: ignoring return value of 'request_irq', declared with attribute
warn_unused_result

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Hirst <richard@sleepie.demon.co.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/char/vme_scc.c |  166 +++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 136 insertions(+), 30 deletions(-)

diff --git a/drivers/char/vme_scc.c b/drivers/char/vme_scc.c
index 1718b3c..3b6c20e 100644
--- a/drivers/char/vme_scc.c
+++ b/drivers/char/vme_scc.c
@@ -193,6 +193,7 @@ static void scc_init_portstructs(void)
 static int mvme147_scc_init(void)
 {
 	struct scc_port *port;
+	int error;
 
 	printk(KERN_INFO "SCC: MVME147 Serial Driver\n");
 	/* Init channel A */
@@ -202,14 +203,23 @@ static int mvme147_scc_init(void)
 	port->datap = port->ctrlp + 1;
 	port->port_a = &scc_ports[0];
 	port->port_b = &scc_ports[1];
-	request_irq(MVME147_IRQ_SCCA_TX, scc_tx_int, IRQF_DISABLED,
+	error = request_irq(MVME147_IRQ_SCCA_TX, scc_tx_int, IRQF_DISABLED,
 		            "SCC-A TX", port);
-	request_irq(MVME147_IRQ_SCCA_STAT, scc_stat_int, IRQF_DISABLED,
+	if (error)
+		goto fail;
+	error = request_irq(MVME147_IRQ_SCCA_STAT, scc_stat_int, IRQF_DISABLED,
 		            "SCC-A status", port);
-	request_irq(MVME147_IRQ_SCCA_RX, scc_rx_int, IRQF_DISABLED,
+	if (error)
+		goto fail_free_a_tx;
+	error = request_irq(MVME147_IRQ_SCCA_RX, scc_rx_int, IRQF_DISABLED,
 		            "SCC-A RX", port);
-	request_irq(MVME147_IRQ_SCCA_SPCOND, scc_spcond_int, IRQF_DISABLED,
-		            "SCC-A special cond", port);
+	if (error)
+		goto fail_free_a_stat;
+	error = request_irq(MVME147_IRQ_SCCA_SPCOND, scc_spcond_int,
+			    IRQF_DISABLED, "SCC-A special cond", port);
+	if (error)
+		goto fail_free_a_rx;
+
 	{
 		SCC_ACCESS_INIT(port);
 
@@ -229,14 +239,23 @@ static int mvme147_scc_init(void)
 	port->datap = port->ctrlp + 1;
 	port->port_a = &scc_ports[0];
 	port->port_b = &scc_ports[1];
-	request_irq(MVME147_IRQ_SCCB_TX, scc_tx_int, IRQF_DISABLED,
+	error = request_irq(MVME147_IRQ_SCCB_TX, scc_tx_int, IRQF_DISABLED,
 		            "SCC-B TX", port);
-	request_irq(MVME147_IRQ_SCCB_STAT, scc_stat_int, IRQF_DISABLED,
+	if (error)
+		goto fail_free_a_spcond;
+	error = request_irq(MVME147_IRQ_SCCB_STAT, scc_stat_int, IRQF_DISABLED,
 		            "SCC-B status", port);
-	request_irq(MVME147_IRQ_SCCB_RX, scc_rx_int, IRQF_DISABLED,
+	if (error)
+		goto fail_free_b_tx;
+	error = request_irq(MVME147_IRQ_SCCB_RX, scc_rx_int, IRQF_DISABLED,
 		            "SCC-B RX", port);
-	request_irq(MVME147_IRQ_SCCB_SPCOND, scc_spcond_int, IRQF_DISABLED,
-		            "SCC-B special cond", port);
+	if (error)
+		goto fail_free_b_stat;
+	error = request_irq(MVME147_IRQ_SCCB_SPCOND, scc_spcond_int,
+			    IRQF_DISABLED, "SCC-B special cond", port);
+	if (error)
+		goto fail_free_b_rx;
+
 	{
 		SCC_ACCESS_INIT(port);
 
@@ -252,6 +271,23 @@ static int mvme147_scc_init(void)
 	scc_init_drivers();
 
 	return 0;
+
+fail_free_b_rx:
+	free_irq(MVME147_IRQ_SCCB_RX, port);
+fail_free_b_stat:
+	free_irq(MVME147_IRQ_SCCB_STAT, port);
+fail_free_b_tx:
+	free_irq(MVME147_IRQ_SCCB_TX, port);
+fail_free_a_spcond:
+	free_irq(MVME147_IRQ_SCCA_SPCOND, port);
+fail_free_a_rx:
+	free_irq(MVME147_IRQ_SCCA_RX, port);
+fail_free_a_stat:
+	free_irq(MVME147_IRQ_SCCA_STAT, port);
+fail_free_a_tx:
+	free_irq(MVME147_IRQ_SCCA_TX, port);
+fail:
+	return error;
 }
 #endif
 
@@ -260,6 +296,7 @@ static int mvme147_scc_init(void)
 static int mvme162_scc_init(void)
 {
 	struct scc_port *port;
+	int error;
 
 	if (!(mvme16x_config & MVME16x_CONFIG_GOT_SCCA))
 		return (-ENODEV);
@@ -272,14 +309,23 @@ static int mvme162_scc_init(void)
 	port->datap = port->ctrlp + 2;
 	port->port_a = &scc_ports[0];
 	port->port_b = &scc_ports[1];
-	request_irq(MVME162_IRQ_SCCA_TX, scc_tx_int, IRQF_DISABLED,
+	error = request_irq(MVME162_IRQ_SCCA_TX, scc_tx_int, IRQF_DISABLED,
 		            "SCC-A TX", port);
-	request_irq(MVME162_IRQ_SCCA_STAT, scc_stat_int, IRQF_DISABLED,
+	if (error)
+		goto fail;
+	error = request_irq(MVME162_IRQ_SCCA_STAT, scc_stat_int, IRQF_DISABLED,
 		            "SCC-A status", port);
-	request_irq(MVME162_IRQ_SCCA_RX, scc_rx_int, IRQF_DISABLED,
+	if (error)
+		goto fail_free_a_tx;
+	error = request_irq(MVME162_IRQ_SCCA_RX, scc_rx_int, IRQF_DISABLED,
 		            "SCC-A RX", port);
-	request_irq(MVME162_IRQ_SCCA_SPCOND, scc_spcond_int, IRQF_DISABLED,
-		            "SCC-A special cond", port);
+	if (error)
+		goto fail_free_a_stat;
+	error = request_irq(MVME162_IRQ_SCCA_SPCOND, scc_spcond_int,
+			    IRQF_DISABLED, "SCC-A special cond", port);
+	if (error)
+		goto fail_free_a_rx;
+
 	{
 		SCC_ACCESS_INIT(port);
 
@@ -299,14 +345,22 @@ static int mvme162_scc_init(void)
 	port->datap = port->ctrlp + 2;
 	port->port_a = &scc_ports[0];
 	port->port_b = &scc_ports[1];
-	request_irq(MVME162_IRQ_SCCB_TX, scc_tx_int, IRQF_DISABLED,
+	error = request_irq(MVME162_IRQ_SCCB_TX, scc_tx_int, IRQF_DISABLED,
 		            "SCC-B TX", port);
-	request_irq(MVME162_IRQ_SCCB_STAT, scc_stat_int, IRQF_DISABLED,
+	if (error)
+		goto fail_free_a_spcond;
+	error = request_irq(MVME162_IRQ_SCCB_STAT, scc_stat_int, IRQF_DISABLED,
 		            "SCC-B status", port);
-	request_irq(MVME162_IRQ_SCCB_RX, scc_rx_int, IRQF_DISABLED,
+	if (error)
+		goto fail_free_b_tx;
+	error = request_irq(MVME162_IRQ_SCCB_RX, scc_rx_int, IRQF_DISABLED,
 		            "SCC-B RX", port);
-	request_irq(MVME162_IRQ_SCCB_SPCOND, scc_spcond_int, IRQF_DISABLED,
-		            "SCC-B special cond", port);
+	if (error)
+		goto fail_free_b_stat;
+	error = request_irq(MVME162_IRQ_SCCB_SPCOND, scc_spcond_int,
+			    IRQF_DISABLED, "SCC-B special cond", port);
+	if (error)
+		goto fail_free_b_rx;
 
 	{
 		SCC_ACCESS_INIT(port);	/* Either channel will do */
@@ -323,6 +377,23 @@ static int mvme162_scc_init(void)
 	scc_init_drivers();
 
 	return 0;
+
+fail_free_b_rx:
+	free_irq(MVME162_IRQ_SCCB_RX, port);
+fail_free_b_stat:
+	free_irq(MVME162_IRQ_SCCB_STAT, port);
+fail_free_b_tx:
+	free_irq(MVME162_IRQ_SCCB_TX, port);
+fail_free_a_spcond:
+	free_irq(MVME162_IRQ_SCCA_SPCOND, port);
+fail_free_a_rx:
+	free_irq(MVME162_IRQ_SCCA_RX, port);
+fail_free_a_stat:
+	free_irq(MVME162_IRQ_SCCA_STAT, port);
+fail_free_a_tx:
+	free_irq(MVME162_IRQ_SCCA_TX, port);
+fail:
+	return error;
 }
 #endif
 
@@ -331,6 +402,7 @@ static int mvme162_scc_init(void)
 static int bvme6000_scc_init(void)
 {
 	struct scc_port *port;
+	int error;
 
 	printk(KERN_INFO "SCC: BVME6000 Serial Driver\n");
 	/* Init channel A */
@@ -340,14 +412,23 @@ static int bvme6000_scc_init(void)
 	port->datap = port->ctrlp + 4;
 	port->port_a = &scc_ports[0];
 	port->port_b = &scc_ports[1];
-	request_irq(BVME_IRQ_SCCA_TX, scc_tx_int, IRQF_DISABLED,
+	error = request_irq(BVME_IRQ_SCCA_TX, scc_tx_int, IRQF_DISABLED,
 		            "SCC-A TX", port);
-	request_irq(BVME_IRQ_SCCA_STAT, scc_stat_int, IRQF_DISABLED,
+	if (error)
+		goto fail;
+	error = request_irq(BVME_IRQ_SCCA_STAT, scc_stat_int, IRQF_DISABLED,
 		            "SCC-A status", port);
-	request_irq(BVME_IRQ_SCCA_RX, scc_rx_int, IRQF_DISABLED,
+	if (error)
+		goto fail_free_a_tx;
+	error = request_irq(BVME_IRQ_SCCA_RX, scc_rx_int, IRQF_DISABLED,
 		            "SCC-A RX", port);
-	request_irq(BVME_IRQ_SCCA_SPCOND, scc_spcond_int, IRQF_DISABLED,
-		            "SCC-A special cond", port);
+	if (error)
+		goto fail_free_a_stat;
+	error = request_irq(BVME_IRQ_SCCA_SPCOND, scc_spcond_int,
+			    IRQF_DISABLED, "SCC-A special cond", port);
+	if (error)
+		goto fail_free_a_rx;
+
 	{
 		SCC_ACCESS_INIT(port);
 
@@ -367,14 +448,22 @@ static int bvme6000_scc_init(void)
 	port->datap = port->ctrlp + 4;
 	port->port_a = &scc_ports[0];
 	port->port_b = &scc_ports[1];
-	request_irq(BVME_IRQ_SCCB_TX, scc_tx_int, IRQF_DISABLED,
+	error = request_irq(BVME_IRQ_SCCB_TX, scc_tx_int, IRQF_DISABLED,
 		            "SCC-B TX", port);
-	request_irq(BVME_IRQ_SCCB_STAT, scc_stat_int, IRQF_DISABLED,
+	if (error)
+		goto fail_free_a_spcond;
+	error = request_irq(BVME_IRQ_SCCB_STAT, scc_stat_int, IRQF_DISABLED,
 		            "SCC-B status", port);
-	request_irq(BVME_IRQ_SCCB_RX, scc_rx_int, IRQF_DISABLED,
+	if (error)
+		goto fail_free_b_tx;
+	error = request_irq(BVME_IRQ_SCCB_RX, scc_rx_int, IRQF_DISABLED,
 		            "SCC-B RX", port);
-	request_irq(BVME_IRQ_SCCB_SPCOND, scc_spcond_int, IRQF_DISABLED,
-		            "SCC-B special cond", port);
+	if (error)
+		goto fail_free_b_stat;
+	error = request_irq(BVME_IRQ_SCCB_SPCOND, scc_spcond_int,
+			    IRQF_DISABLED, "SCC-B special cond", port);
+	if (error)
+		goto fail_free_b_rx;
 
 	{
 		SCC_ACCESS_INIT(port);	/* Either channel will do */
@@ -388,6 +477,23 @@ static int bvme6000_scc_init(void)
 	scc_init_drivers();
 
 	return 0;
+
+fail:
+	free_irq(BVME_IRQ_SCCA_STAT, port);
+fail_free_a_tx:
+	free_irq(BVME_IRQ_SCCA_RX, port);
+fail_free_a_stat:
+	free_irq(BVME_IRQ_SCCA_SPCOND, port);
+fail_free_a_rx:
+	free_irq(BVME_IRQ_SCCB_TX, port);
+fail_free_a_spcond:
+	free_irq(BVME_IRQ_SCCB_STAT, port);
+fail_free_b_tx:
+	free_irq(BVME_IRQ_SCCB_RX, port);
+fail_free_b_stat:
+	free_irq(BVME_IRQ_SCCB_SPCOND, port);
+fail_free_b_rx:
+	return error;
 }
 #endif
 
-- 
1.5.6.5

