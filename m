Return-Path: <linux-kernel-owner+w=401wt.eu-S932369AbYD1HeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbYD1HeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 03:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763202AbYD1HeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 03:34:07 -0400
Received: from tur.go2.pl ([193.17.41.50]:45030 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763116AbYD1HeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 03:34:05 -0400
Subject: =?UTF-8?Q?Fwd:_[PATCH]_[MMC]_fix_clock_problem_in_PXA255/270?=
From: =?UTF-8?Q?Tadeusz_Gozdek?= <linux_fan@o2.pl>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?Q?Marcel_Holtmann?= <marcel@holtmann.org>,
       =?UTF-8?Q?Pierre_Ossman?= <drzeus-list@drzeus.cx>
Mime-Version: 1.0
Message-ID: <441f2104.26c7abf7.48157da1.e45c7@o2.pl>
Date: Mon, 28 Apr 2008 09:32:49 +0200
X-Originator: 62.225.75.172
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It solves the problems with clock in the PXA255/270 MMC/SD hardware.
This solution was testes with our devices and works good.
Kernel 2.6.24.4 (but should work with >=2.6.19)

Regards
Tadeusz Gozdek
 
diff -NuarBb /x/work/navi_os/mmc/host/pxamci.c mmc/host/pxamci.c
--- /x/work/navi_os/mmc/host/pxamci.c	2008-03-24 19:49:18.000000000 +0100
+++ mmc/host/pxamci.c	2008-04-25 12:14:00.000000000 +0200
@@ -26,6 +26,7 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/mmc/host.h>
+#include <linux/mmc/mmc.h>
 
 #include <asm/dma.h>
 #include <asm/io.h>
@@ -67,6 +68,8 @@
 	unsigned int		dma_dir;
 };
 
+static int local_cmd = -1;
+
 static void pxamci_stop_clock(struct pxamci_host *host)
 {
 	if (readl(host->base + MMC_STAT) & STAT_CLK_EN) {
@@ -84,6 +87,7 @@
 
 		if (v & STAT_CLK_EN)
 			dev_err(mmc_dev(host->mmc), "unable to stop clock\n");
+		local_cmd = -1;
 	}
 }
 
@@ -232,6 +235,14 @@
 		v = w2;
 	}
 
+	local_cmd = cmd->opcode;
+	if ((local_cmd == MMC_GO_IDLE_STATE) ||
+	    (local_cmd == MMC_GO_INACTIVE_STATE) ||
+	    (local_cmd == MMC_SEND_STATUS) ||
+	    (local_cmd == MMC_STOP_TRANSMISSION) ||
+	    (local_cmd == MMC_SET_BLOCKLEN)
+	    ) pxamci_stop_clock(host);
+
 	if (stat & STAT_TIME_OUT_RESPONSE) {
 		cmd->error = -ETIMEDOUT;
 	} else if (stat & STAT_RES_CRC_ERR && cmd->flags & MMC_RSP_CRC) {
@@ -290,7 +301,7 @@
 
 	host->data = NULL;
 	if (host->mrq->stop) {
-		pxamci_stop_clock(host);
+		//pxamci_stop_clock(host);
 		pxamci_start_cmd(host, host->mrq->stop, host->cmdat);
 	} else {
 		pxamci_finish_request(host, host->mrq);


