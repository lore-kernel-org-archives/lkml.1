Return-Path: <linux-kernel-owner+w=401wt.eu-S1760315AbYFGOaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760315AbYFGOaz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 10:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbYFGOaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 10:30:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244AbYFGOaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 10:30:46 -0400
Message-ID: <484A9B26.8080409@redhat.com>
Date: Sat, 07 Jun 2008 10:28:54 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] MMC: wbsd: initialize tasklets before requesting interrupt
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MMC: wbsd: initialize tasklets before requesting interrupt

With CONFIG_DEBUG_SHIRQ set we will get an interrupt as soon as we
allocate one. Tasklets may be scheduled in the interrupt handler but
they will be initialized after the handler returns, causing a BUG()
in kernel/softirq.c when they run.

Should fix this Fedora bug report:
https://bugzilla.redhat.com/show_bug.cgi?id=449817

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

--- linux-2.6.25.noarch.orig/drivers/mmc/host/wbsd.c
+++ linux-2.6.25.noarch/drivers/mmc/host/wbsd.c
@@ -1457,17 +1457,7 @@ static int __devinit wbsd_request_irq(st
 	int ret;

 	/*
-	 * Allocate interrupt.
-	 */
-
-	ret = request_irq(irq, wbsd_irq, IRQF_SHARED, DRIVER_NAME, host);
-	if (ret)
-		return ret;
-
-	host->irq = irq;
-
-	/*
-	 * Set up tasklets.
+	 * Set up tasklets. Must be done before requesting interrupt.
 	 */
 	tasklet_init(&host->card_tasklet, wbsd_tasklet_card,
 			(unsigned long)host);
@@ -1480,6 +1470,15 @@ static int __devinit wbsd_request_irq(st
 	tasklet_init(&host->finish_tasklet, wbsd_tasklet_finish,
 			(unsigned long)host);

+	/*
+	 * Allocate interrupt.
+	 */
+	ret = request_irq(irq, wbsd_irq, IRQF_SHARED, DRIVER_NAME, host);
+	if (ret)
+		return ret;
+
+	host->irq = irq;
+
 	return 0;
 }

