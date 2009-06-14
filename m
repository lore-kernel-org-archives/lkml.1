Return-Path: <linux-kernel-owner+w=401wt.eu-S1763389AbZFNTqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763389AbZFNTqo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 15:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758002AbZFNTqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 15:46:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37943 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbZFNTqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 15:46:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Jeffrey Kirsher" <jeffrey.t.kirsher@intel.com>
Subject: [PATCH] Net / e100: Fix suspend of devices that cannot be power managed
Date: Sun, 14 Jun 2009 21:46:46 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: andi@lisas.de, akpm@linux-foundation.org,
       e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20081229102515.GA17171@rhlx01.hs-esslingen.de> <200906141606.29754.rjw@sisk.pl> <20090614164604.GA19746@rhlx01.hs-esslingen.de>
In-Reply-To: <20090614164604.GA19746@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906142146.47639.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If the adapter is not power-manageable using either ACPI, or the
native PCI PM interface, __e100_power_off() returns error code, which
causes every attempt to suspend to fail, although it should return 0
in such a case.  Fix this problem by ignoring the return value of
pci_set_power_state() in __e100_power_off().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Andreas Mohr <andi@lisas.de>
---
 drivers/net/e100.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/net/e100.c
===================================================================
--- linux-2.6.orig/drivers/net/e100.c
+++ linux-2.6/drivers/net/e100.c
@@ -2759,12 +2759,13 @@ static void __e100_shutdown(struct pci_d
 
 static int __e100_power_off(struct pci_dev *pdev, bool wake)
 {
-	if (wake) {
+	if (wake)
 		return pci_prepare_to_sleep(pdev);
-	} else {
-		pci_wake_from_d3(pdev, false);
-		return pci_set_power_state(pdev, PCI_D3hot);
-	}
+
+	pci_wake_from_d3(pdev, false);
+	pci_set_power_state(pdev, PCI_D3hot);
+
+	return 0;
 }
 
 #ifdef CONFIG_PM
