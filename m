Return-Path: <linux-kernel-owner+w=401wt.eu-S940631AbXGSRXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940631AbXGSRXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938769AbXGSRXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:23:40 -0400
Received: from h146-az.mvista.com ([65.200.49.156]:64813 "EHLO
	zipcode.az.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934056AbXGSRXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:23:38 -0400
Date: Thu, 19 Jul 2007 10:26:17 -0700
From: "Mark A. Greer" <mgreer@mvista.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: carlos.sanchez@gecoinc.com, Andrew Morton <akpm@osdl.org>
Subject: [PATCH 1/4] serial: MPSC: Remove race between Rx stop & restart
Message-ID: <20070719172617.GA589@mag.az.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carlos Sanchez <carlos.sanchez@gecoinc.com>

The patch in commit ID f7232056bff5fe2d3bfeab35252a66ebaeb5bbde
stops (aborts) the MPSC's receive engine just before restarting it.
Unfortunately, it doesn't wait for the abort to complete before
restarting it which creates a race between the abort and the restart.
If the restart occurs first, the in-progress abort stops it again
and the rx engine remains stopped.

Instead, do the abort when the SDMA engine is being stopped.  Make
sure to wait for the abort to complete before continuing.

Signed-off-by: Carlos Sanchez <carlos.sanchez@gecoinc.com>
Signed-off-by: Mark A. Greer <mgreer@mvista.com>
---
 drivers/serial/mpsc.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/mpsc.c b/drivers/serial/mpsc.c
index 00924fe..567fa78 100644
--- a/drivers/serial/mpsc.c
+++ b/drivers/serial/mpsc.c
@@ -1363,8 +1363,6 @@ mpsc_start_rx(struct mpsc_port_info *pi)
 {
 	pr_debug("mpsc_start_rx[%d]: Starting...\n", pi->port.line);
 
-	/* Issue a Receive Abort to clear any receive errors */
-	writel(MPSC_CHR_2_RA, pi->mpsc_base + MPSC_CHR_2);
 	if (pi->rcv_data) {
 		mpsc_enter_hunt(pi);
 		mpsc_sdma_cmd(pi, SDMA_SDCM_ERD);
@@ -1379,6 +1377,20 @@ mpsc_stop_rx(struct uart_port *port)
 
 	pr_debug("mpsc_stop_rx[%d]: Stopping...\n", port->line);
 
+	if (pi->mirror_regs) {
+		writel(pi->MPSC_CHR_2_m | MPSC_CHR_2_RA,
+				pi->mpsc_base + MPSC_CHR_2);
+		/* Erratum prevents reading CHR_2 so just delay for a while */
+		udelay(100);
+	}
+	else {
+		writel(readl(pi->mpsc_base + MPSC_CHR_2) | MPSC_CHR_2_RA,
+			pi->mpsc_base + MPSC_CHR_2);
+
+		while (readl(pi->mpsc_base + MPSC_CHR_2) & MPSC_CHR_2_RA)
+			udelay(10);
+	}
+
 	mpsc_sdma_cmd(pi, SDMA_SDCM_AR);
 	return;
 }
