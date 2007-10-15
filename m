Return-Path: <linux-kernel-owner+w=401wt.eu-S1765276AbXJOQa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765276AbXJOQa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760173AbXJOQaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:30:30 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:58393 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758334AbXJOQa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:30:28 -0400
Message-id: <30460624014748892@pripojeni.net>
In-reply-to: <25409162611123630013@pripojeni.net>
Subject: [PATCH 3/5] Char: rocket, remove pci_read_config_dword(CLASS_REVISION)
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Mon, 15 Oct 2007 12:30:28 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rocket, remove pci_read_config_dword(CLASS_REVISION)

We may use pdev->revision instead of reading pci config space directly, so
remove pci_read_config_dword invoking.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 2b2c0385d705ce1f4207595f8fda12c25ee39de3
tree 2c09638bcb6ee3f671dd3038c21efeb2b958e6dc
parent ad37fddef12ce908078883fdc27297216c6d122e
author Jiri Slaby <jirislaby@gmail.com> Mon, 15 Oct 2007 14:42:18 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 15 Oct 2007 14:42:18 +0200

 drivers/char/rocket.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 5fd1ed7..e4bcfa2 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -1869,8 +1869,6 @@ static __init int register_PCI(int i, struct pci_dev *dev)
 	int fast_clock = 0;
 	int altChanRingIndicator = 0;
 	int ports_per_aiop = 8;
-	int ret;
-	unsigned int class_rev;
 	WordIO_t ConfigIO = 0;
 	ByteIO_t UPCIRingInd = 0;
 
@@ -1878,12 +1876,6 @@ static __init int register_PCI(int i, struct pci_dev *dev)
 		return 0;
 
 	rcktpt_io_addr[i] = pci_resource_start(dev, 0);
-	ret = pci_read_config_dword(dev, PCI_CLASS_REVISION, &class_rev);
-
-	if (ret) {
-		printk(KERN_INFO "  Error during register_PCI(), unable to read config dword \n");
-		return 0;
-	}
 
 	rcktpt_type[i] = ROCKET_TYPE_NORMAL;
 	rocketModel[i].loadrm2 = 0;
@@ -2037,8 +2029,9 @@ static __init int register_PCI(int i, struct pci_dev *dev)
 		ports_per_aiop = 6;
 		str = "6-port";
 
-		/*  If class_rev is 1, the rocketmodem flash must be loaded.  If it is 2 it is a "socketed" version. */
-		if ((class_rev & 0xFF) == 1) {
+		/*  If revision is 1, the rocketmodem flash must be loaded.
+		 *  If it is 2 it is a "socketed" version. */
+		if (dev->revision == 1) {
 			rcktpt_type[i] = ROCKET_TYPE_MODEMII;
 			rocketModel[i].loadrm2 = 1;
 		} else {
@@ -2053,7 +2046,7 @@ static __init int register_PCI(int i, struct pci_dev *dev)
 		max_num_aiops = 1;
 		ports_per_aiop = 4;
 		str = "4-port";
-		if ((class_rev & 0xFF) == 1) {
+		if (dev->revision == 1) {
 			rcktpt_type[i] = ROCKET_TYPE_MODEMII;
 			rocketModel[i].loadrm2 = 1;
 		} else {
