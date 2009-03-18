Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbZCRWki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbZCRWki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 18:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756915AbZCRWjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 18:39:39 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:45542 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604AbZCRWjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:39:37 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v4 02/12] PCI: don't scan existing devices
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trent Piepho <xyzzy@speakeasy.org>, Alex Chiang <achiang@hp.com>
Date: Wed, 18 Mar 2009 16:39:35 -0600
Message-ID: <20090318223935.887.22661.stgit@bob.kio>
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

pci_scan_single_device is supposed to add newly discovered
devices to pci_bus->devices, but doesn't check to see if the
device has already been added. This can cause problems if we ever
want to use this interface to rescan the PCI bus.

If the device is already added, just return it.

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/probe.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 55ec44a..66b5d1c 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1006,6 +1006,12 @@ struct pci_dev *__ref pci_scan_single_device(struct pci_bus *bus, int devfn)
 {
 	struct pci_dev *dev;
 
+	dev = pci_get_slot(bus, devfn);
+	if (dev) {
+		pci_dev_put(dev);
+		return dev;
+	}
+
 	dev = pci_scan_device(bus, devfn);
 	if (!dev)
 		return NULL;

