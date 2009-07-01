Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309AbZGAXvC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbZGAXvC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 19:51:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZGAXuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 19:50:54 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:43646
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751678AbZGAXuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 19:50:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvMBAEKTS0p8qMex/2dsb2JhbAAI0EeEEQU
X-IronPort-AV: E=Sophos;i="4.42,328,1243785600"; 
   d="scan'208";a="471242434"
Subject: [PATCH] MMC Core: Drop initialization frequency floor to 50kHz
From: Ben Nizette <bn@niasdigital.com>
To: pierre@ossman.eu
Cc: s.hauer@pengutronix.de, linux-kernel <linux-kernel@vger.kernel.org>,
       kernel <kernel@avr32linux.org>, Ben Nizette <bn@niasdigital.com>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 09:49:56 +1000
Message-Id: <1246492196.2980.17.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch

commit 8dfd0374be84793360db7fff2e635d2cd3bbcb21
Author: Sascha Hauer <s.hauer@pengutronix.de>
Date:   Thu Apr 9 08:32:02 2009 +0200

    MMC core: limit minimum initialization frequency to 400kHz

Was recently merged.  This is too fast for at least one setup
permutation - the one on my desk which through trial and error won't
initialise at anything above ~350kHz (older Sandisk 256MB SD on
atmel-mci).

To avoid a string of "just found card X which requires clock
(current_clock - epsilon)" this patch drops the floor right down to
50kHz.  This is about the slowest rate before which the discovery
process takes a noticeable slowdown.

Signed-off-by: Ben Nizette <bn@niasdigital.com>
---
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index d84c880..6ee1931 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -708,12 +708,13 @@ static void mmc_power_up(struct mmc_host *host)
 	 */
 	mmc_delay(10);
 
-	if (host->f_min > 400000) {
-		pr_warning("%s: Minimum clock frequency too high for "
-				"identification mode\n", mmc_hostname(host));
-		host->ios.clock = host->f_min;
-	} else
-		host->ios.clock = 400000;
+	/*
+	 * Card discovery is typically done at the controller's minimum
+	 * allowable frequency but for some controllers this is minimum
+	 * is unreasonably slow.  In that case we limit slow clock rate
+	 * to 50KHz.
+	 */
+	host->ios.clock = max(host->f_min, 50000);
 
 	host->ios.power_mode = MMC_POWER_ON;
 	mmc_set_ios(host);


