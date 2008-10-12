Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbYJLIkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbYJLIkt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 04:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbYJLIki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 04:40:38 -0400
Received: from vana.vc.cvut.cz ([147.32.240.58]:36018 "EHLO vana.vc.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbYJLIkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 04:40:37 -0400
X-Greylist: delayed 1602 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Oct 2008 04:40:36 EDT
Date: Sun, 12 Oct 2008 10:13:52 +0200
From: Petr Vandrovec <petr@vandrovec.name>
To: ivecera@redhat.com
Cc: romieu@fr.zoreil.com, davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix NULL pointer dereference on r8169 load
Message-ID: <20081012081352.GA29794@vana.vc.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petr Vandrovec <petr@vandrovec.name>

mmio_addr in r8169 needs to be initialized before use

Maybe that all tp-> initialization should be moved before rtl_init_mac_address call,
but this is enough to get rid of crash in rtl_rar_set due to mmio_addr being uninitialized.

Signed-off-by: Petr Vandrovec <petr@vandrovec.name>

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index bdae2c5..c821da2 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2154,6 +2154,8 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	spin_lock_init(&tp->lock);
 
+	tp->mmio_addr = ioaddr;
+
 	rtl_init_mac_address(tp, ioaddr);
 
 	/* Get MAC address */
@@ -2186,7 +2188,6 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 #endif
 
 	tp->intr_mask = 0xffff;
-	tp->mmio_addr = ioaddr;
 	tp->align = cfg->align;
 	tp->hw_start = cfg->hw_start;
 	tp->intr_event = cfg->intr_event;
