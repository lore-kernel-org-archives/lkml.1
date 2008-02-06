Return-Path: <linux-kernel-owner+w=401wt.eu-S1765404AbYBGAFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765404AbYBGAFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764770AbYBFX45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:56:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:60564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764769AbYBFX4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:56:55 -0500
Date: Wed, 6 Feb 2008 15:52:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Chas Williams <chas@cmf.nrl.navy.mil>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 24/73] ATM: delay irq setup until card is configured
Message-ID: <20080206235214.GY13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="atm-delay-irq-setup-until-card-is-configured.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Chas Williams <chas@cmf.nrl.navy.mil>

[ATM]: [nicstar] delay irq setup until card is configured

[ Upstream commit: 52961955aa180959158faeb9fd6b4f8a591450f5 ]

Signed-off-by: Chas Williams <chas@cmf.nrl.navy.mil>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/atm/nicstar.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -625,14 +625,6 @@ static int __devinit ns_init_card(int i,
    if (mac[i] == NULL)
       nicstar_init_eprom(card->membase);
 
-   if (request_irq(pcidev->irq, &ns_irq_handler, IRQF_DISABLED | IRQF_SHARED, "nicstar", card) != 0)
-   {
-      printk("nicstar%d: can't allocate IRQ %d.\n", i, pcidev->irq);
-      error = 9;
-      ns_init_card_error(card, error);
-      return error;
-   }
-
    /* Set the VPI/VCI MSb mask to zero so we can receive OAM cells */
    writel(0x00000000, card->membase + VPM);
       
@@ -858,8 +850,6 @@ static int __devinit ns_init_card(int i,
       card->iovpool.count++;
    }
 
-   card->intcnt = 0;
-
    /* Configure NICStAR */
    if (card->rct_size == 4096)
       ns_cfg_rctsize = NS_CFG_RCTSIZE_4096_ENTRIES;
@@ -868,6 +858,15 @@ static int __devinit ns_init_card(int i,
 
    card->efbie = 1;
 
+   card->intcnt = 0;
+   if (request_irq(pcidev->irq, &ns_irq_handler, IRQF_DISABLED | IRQF_SHARED, "nicstar", card) != 0)
+   {
+      printk("nicstar%d: can't allocate IRQ %d.\n", i, pcidev->irq);
+      error = 9;
+      ns_init_card_error(card, error);
+      return error;
+   }
+
    /* Register device */
    card->atmdev = atm_dev_register("nicstar", &atm_ops, -1, NULL);
    if (card->atmdev == NULL)

-- 
