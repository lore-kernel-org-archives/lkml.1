Return-Path: <linux-kernel-owner+w=401wt.eu-S1763911AbYFNAXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763911AbYFNAXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762123AbYFNAOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:14:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:34498 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762114AbYFNAOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:14:46 -0400
Date: Fri, 13 Jun 2008 17:11:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Pierre Ossman <drzeus@drzeus.cx>
Subject: [patch 34/47] mmc: wbsd: initialize tasklets before requesting
	interrupt
Message-ID: <20080614001152.GH24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mmc-wbsd-initialize-tasklets-before-requesting-interrupt.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Chuck Ebbert <cebbert@redhat.com>

commit cef33400d0349fb24b6f8b7dea79b66e3144fd8b upstream

With CONFIG_DEBUG_SHIRQ set we will get an interrupt as soon as we
allocate one.  Tasklets may be scheduled in the interrupt handler but they
will be initialized after the handler returns, causing a BUG() in
kernel/softirq.c when they run.

Should fix this Fedora bug report:
https://bugzilla.redhat.com/show_bug.cgi?id=449817

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Acked-by: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/wbsd.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
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
 

-- 
