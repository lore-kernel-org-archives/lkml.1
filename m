Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbZCRWk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbZCRWk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 18:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbZCRWjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 18:39:44 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:11922 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018AbZCRWjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:39:42 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v4 03/12] PCI: pci_scan_slot() returns newly found devices
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trent Piepho <xyzzy@speakeasy.org>, Alex Chiang <achiang@hp.com>
Date: Wed, 18 Mar 2009 16:39:41 -0600
Message-ID: <20090318223940.887.18125.stgit@bob.kio>
In-Reply-To: <20090318222426.887.1008.stgit@bob.kio>
References: <20090318222426.887.1008.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trent Piepho <xyzzy@speakeasy.org>

pci_scan_slot() has been rewritten to be less complex and will now
return the number of *new* devices found.

Existing callers need not worry because they already assume that
they can't call pci_scan_slot() on an already-scanned slot.

Thus, there is no semantic change for existing callers: returning
newly found devices (this patch) is exactly equal to returning all
found devices (before this patch).

This patch adds some more groundwork to allow us to rescan the
PCI bus during runtime to discover newly added devices.

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>
Reviewed-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/probe.c |   35 +++++++++++++----------------------
 1 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 66b5d1c..d392813 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1030,35 +1030,26 @@ EXPORT_SYMBOL(pci_scan_single_device);
  * Scan a PCI slot on the specified PCI bus for devices, adding
  * discovered devices to the @bus->devices list.  New devices
  * will not have is_added set.
+ *
+ * Returns the number of new devices found.
  */
 int pci_scan_slot(struct pci_bus *bus, int devfn)
 {
-	int func, nr = 0;
-	int scan_all_fns;
-
-	scan_all_fns = pcibios_scan_all_fns(bus, devfn);
-
-	for (func = 0; func < 8; func++, devfn++) {
-		struct pci_dev *dev;
+	int fn, nr = 0;
+	struct pci_dev *dev;
 
-		dev = pci_scan_single_device(bus, devfn);
-		if (dev) {
+	if ((dev = pci_scan_single_device(bus, devfn)))
+		if (!dev->is_added)	/* new device? */
 			nr++;
 
-			/*
-		 	 * If this is a single function device,
-		 	 * don't scan past the first function.
-		 	 */
-			if (!dev->multifunction) {
-				if (func > 0) {
-					dev->multifunction = 1;
-				} else {
- 					break;
-				}
+	if ((dev && dev->multifunction) ||
+	    (!dev && pcibios_scan_all_fns(bus, devfn))) {
+		for (fn = 1; fn < 8; fn++) {
+			if ((dev = pci_scan_single_device(bus, devfn + fn))) {
+				if (!dev->is_added)
+					nr++;
+				dev->multifunction = 1;
 			}
-		} else {
-			if (func == 0 && !scan_all_fns)
-				break;
 		}
 	}
 

