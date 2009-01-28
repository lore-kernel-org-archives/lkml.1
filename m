Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbZA1V7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbZA1V7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbZA1V7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:59:10 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:17630 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbZA1V7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:59:08 -0500
From: Alex Chiang <achiang@hp.com>
Subject: [RFC PATCH 01/10] PCI: don't scan existing devices
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alex Chiang <achiang@hp.com>
Date: Wed, 28 Jan 2009 14:59:07 -0700
Message-ID: <20090128215907.28003.43273.stgit@bob.kio>
In-Reply-To: <20090128213814.28003.34634.stgit@bob.kio>
References: <20090128213814.28003.34634.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_scan_slot is supposed to add newly discovered devices to
pci_bus->devices, but doesn't check to see if the device has
already been added. This can cause problems if we ever want
to use this interface to rescan the PCI bus.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/probe.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 55ec44a..a9e17e2 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1035,6 +1035,17 @@ int pci_scan_slot(struct pci_bus *bus, int devfn)
 	for (func = 0; func < 8; func++, devfn++) {
 		struct pci_dev *dev;
 
+		dev = pci_get_slot(bus, devfn);
+		if (dev) {
+			if (dev->multifunction) {
+				pci_dev_put(dev);
+				continue;
+			} else {
+				pci_dev_put(dev);
+				break;
+			}
+		}
+
 		dev = pci_scan_single_device(bus, devfn);
 		if (dev) {
 			nr++;

