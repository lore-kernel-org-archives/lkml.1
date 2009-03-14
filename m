Return-Path: <linux-kernel-owner+w=401wt.eu-S1761477AbZCNBvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761477AbZCNBvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbZCNBVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:38 -0400
Received: from kroah.org ([198.145.64.141]:35623 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754690AbZCNBVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:05 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:43 2009
Message-Id: <20090314011043.500507452@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ben Dooks <ben-linux@fluff.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: [patch 082/114] sdhci: Add quirk for controllers with no end-of-busy IRQ
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=sdhci-add-quirk-for-controllers-with-no-end-of-busy-irq.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Dooks <ben-linux@fluff.org>

commit f945405cdecd9e0ae3e58ff84cabd19b4522965e upstream.

The Samsung SDHCI (and FSL eSDHC) controller block seems to fail
to generate an INT_DATA_END after the transfer has completed and
the bus busy state finished.

Changes in e809517f6fa5803a5a1cd56026f0e2190fc13d5c to use the
new busy method are the cause of the behaviour change.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/sdhci.c |    5 ++++-
 drivers/mmc/host/sdhci.h |    2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1286,8 +1286,11 @@ static void sdhci_cmd_irq(struct sdhci_h
 		if (host->cmd->data)
 			DBG("Cannot wait for busy signal when also "
 				"doing a data transfer");
-		else
+		else if (!(host->quirks & SDHCI_QUIRK_NO_BUSY_IRQ))
 			return;
+
+		/* The controller does not support the end-of-busy IRQ,
+		 * fall through and take the SDHCI_INT_RESPONSE */
 	}
 
 	if (intmask & SDHCI_INT_RESPONSE)
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -210,6 +210,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_BROKEN_SMALL_PIO			(1<<13)
 /* Controller supports high speed but doesn't have the caps bit set */
 #define SDHCI_QUIRK_FORCE_HIGHSPEED			(1<<14)
+/* Controller does not provide transfer-complete interrupt when not busy */
+#define SDHCI_QUIRK_NO_BUSY_IRQ				(1<<15)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */


