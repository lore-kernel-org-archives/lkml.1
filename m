Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbXJJKGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbXJJKGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 06:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbXJJKFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 06:05:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4638 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbXJJKFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 06:05:53 -0400
From: Mark Brown <broonie@sirena.org.uk>
To: Jeff Garzik <jgarzik@pobox.com>, thockin@hockin.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@sirena.org.uk>
Date: Wed, 10 Oct 2007 11:05:44 +0100
Message-Id: <1192010744-12204-1-git-send-email-broonie@sirena.org.uk>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <470C210C.6030800@pobox.com>
References: <470C210C.6030800@pobox.com>
X-SA-Exim-Connect-IP: 212.50.174.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] natsemi: Use round_jiffies() for slow timers
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Unless we have failed to fill the RX ring the timer used by the natsemi
driver is not particularly urgent and can use round_jiffies() to allow
grouping with other timers.

Signed-off-by: Mark Brown <broonie@sirena.org.uk>
---
Rediffed against current netdev-2.6.git#upstream

 drivers/net/natsemi.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
index 527f9dc..b881786 100644
--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -1576,7 +1576,7 @@ static int netdev_open(struct net_device *dev)
 
 	/* Set the timer to check for link beat. */
 	init_timer(&np->timer);
-	np->timer.expires = jiffies + NATSEMI_TIMER_FREQ;
+	np->timer.expires = round_jiffies(jiffies + NATSEMI_TIMER_FREQ);
 	np->timer.data = (unsigned long)dev;
 	np->timer.function = &netdev_timer; /* timer handler */
 	add_timer(&np->timer);
@@ -1856,7 +1856,11 @@ static void netdev_timer(unsigned long data)
 			next_tick = 1;
 		}
 	}
-	mod_timer(&np->timer, jiffies + next_tick);
+
+	if (next_tick > 1)
+		mod_timer(&np->timer, round_jiffies(jiffies + next_tick));
+	else
+		mod_timer(&np->timer, jiffies + next_tick);
 }
 
 static void dump_ring(struct net_device *dev)
@@ -3331,7 +3335,7 @@ static int natsemi_resume (struct pci_dev *pdev)
 		spin_unlock_irq(&np->lock);
 		enable_irq(dev->irq);
 
-		mod_timer(&np->timer, jiffies + 1*HZ);
+		mod_timer(&np->timer, round_jiffies(jiffies + 1*HZ));
 	}
 	netif_device_attach(dev);
 out:
-- 
1.5.3.4

