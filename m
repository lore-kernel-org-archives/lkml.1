Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbZBMUTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbZBMUTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 15:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759858AbZBMUTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 15:19:01 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:19173 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbZBMUS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 15:18:59 -0500
From: Alex Chiang <achiang@hp.com>
Subject: [RFC PATCH v2 01/12] PCI: don't scan existing devices
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trent Piepho <xyzzy@speakeasy.org>, Alex Chiang <achiang@hp.com>
Date: Fri, 13 Feb 2009 13:18:58 -0700
Message-ID: <20090213201858.19262.67639.stgit@bob.kio>
In-Reply-To: <20090213201135.19262.67924.stgit@bob.kio>
References: <20090213201135.19262.67924.stgit@bob.kio>
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

