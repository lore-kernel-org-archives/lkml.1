Return-Path: <linux-kernel-owner+w=401wt.eu-S1755130AbYIIDCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbYIIDCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 23:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYIIDCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 23:02:22 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:40093 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbYIIDCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 23:02:21 -0400
Date: Mon, 8 Sep 2008 22:01:14 -0500
From: David Fries <david@fries.net>
To: Paul Gortmaker <paul.gortmaker@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/2] ne.c Fix suspend and resume for ISA PnP cards.
Message-ID: <20080909030114.GC28469@spacedout.fries.net>
References: <20080904030212.GA23493@spacedout.fries.net> <7d1d9c250809050101v9ab3907l649781ee38a5a243@mail.gmail.com> <20080909025434.GB28469@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080909025434.GB28469@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 08 Sep 2008 22:01:15 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Fries <david@fries.net>

A call to pnp_stop_dev and pnp_start_dev now shuts down and
initializes plug and play devices for suspend and resume.

Signed-off-by: David Fries <david@fries.net>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
---
 drivers/net/ne.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ne.c b/drivers/net/ne.c
index 2bece66..cd31e77 100644
--- a/drivers/net/ne.c
+++ b/drivers/net/ne.c
@@ -876,8 +876,12 @@ static int ne_drv_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
 
-	if (netif_running(dev))
+	if (netif_running(dev)) {
+		struct pnp_dev *idev = (struct pnp_dev *)ei_status.priv;
 		netif_device_detach(dev);
+		if (idev)
+			pnp_stop_dev(idev);
+	}
 	return 0;
 }
 
@@ -886,6 +890,9 @@ static int ne_drv_resume(struct platform_device *pdev)
 	struct net_device *dev = platform_get_drvdata(pdev);
 
 	if (netif_running(dev)) {
+		struct pnp_dev *idev = (struct pnp_dev *)ei_status.priv;
+		if (idev)
+			pnp_start_dev(idev);
 		ne_reset_8390(dev);
 		NS8390p_init(dev, 1);
 		netif_device_attach(dev);
-- 
1.4.4.4
