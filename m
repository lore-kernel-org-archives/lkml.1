Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbZFDGAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbZFDGAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 02:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757004AbZFDF6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:58:51 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:28930 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756948AbZFDF6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:58:50 -0400
Subject: [PATCH v2 07/11] ACPI: acpi_pci_unbind should clean up properly after
	acpi_pci_bind
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Date: Wed, 03 Jun 2009 23:58:52 -0600
Message-ID: <20090604055852.18802.22743.stgit@bob.kio>
In-Reply-To: <20090604054504.18802.21690.stgit@bob.kio>
References: <20090604054504.18802.21690.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In acpi_pci_bind, we add _PRT information for non-bridge devices, but
we never delete that information in acpi_pci_unbind.

We also set device->ops.bind and device->ops.unbind, but never clear
them out.

Let's make acpi_pci_unbind clean up what we did in acpi_pci_bind.

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/pci_bind.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
index 62cb383..5fa1c5e 100644
--- a/drivers/acpi/pci_bind.c
+++ b/drivers/acpi/pci_bind.c
@@ -106,14 +106,21 @@ EXPORT_SYMBOL(acpi_get_pci_id);
 
 static int acpi_pci_unbind(struct acpi_device *device)
 {
+	struct pci_bus *bus;
 	struct pci_dev *dev;
 
 	dev = acpi_get_pci_dev(device->handle);
 	if (!dev)
 		return 0;
 
-	if (dev->subordinate)
-		acpi_pci_irq_del_prt(dev->subordinate);
+	if (dev->subordinate) {
+		bus = dev->subordinate;
+		device->ops.bind = NULL;
+		device->ops.unbind = NULL;
+	 } else
+		bus = dev->bus;
+
+	acpi_pci_irq_del_prt(bus);
 
 	pci_dev_put(dev);
 	return 0;

