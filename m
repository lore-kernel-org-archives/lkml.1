Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbYFYR5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbYFYR5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 13:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYFYR5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 13:57:42 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:48931 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbYFYR5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 13:57:41 -0400
Message-ID: <4862873C.3070507@keyaccess.nl>
Date: Wed, 25 Jun 2008 19:58:20 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] PNP: have quirk_system_pci_resources() include io resources.
Content-Type: multipart/mixed;
 boundary="------------090803080205080807040809"
X-Spam-Score: -0.5 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090803080205080807040809
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrew.

quirk_system_pci_resources() disables a PnP mem resource that overlaps a
PCI BAR so as to not keep the PCI driver from claiming the resource.
Have it do the same for io resources.

Here, ACPI claims ports that overlap with my soundcard causing the
soundcard driver to fail to load. It's unknown why my ACPI BIOS claims
those ports; it did not use to but this is not a (kernel) regression.
Some odd BIOS reconfig triggered by temporarily removing the card seems
to have brought this on.

This is not urgent -- I now all of a sudden need this on any kernel 
anyway. It applies on top of Bjorn's PNP patches you have in the tree. 
Strictly, Bjorn's ACK was on another version of this that rolled its own 
private pnp_resource_type_name(), an interface introduced by those new 
PNP patches. I took the liberty to consider that trivial enough of a 
change to keep it though.

Rene.

--------------090803080205080807040809
Content-Type: text/plain;
 name="0001-PNP-have-quirk_system_pci_resources-include-io-re.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-PNP-have-quirk_system_pci_resources-include-io-re.patch"

>From 4c6191498771b0e2b087db988f74e4b902b99d32 Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Wed, 25 Jun 2008 19:45:41 +0200
Subject: [PATCH] PNP: have quirk_system_pci_resources() include io resources.

quirk_system_pci_resources() disables a PnP mem resource that overlaps
a PCI BAR so as to not keep the PCI driver from claiming the resource.
Have it do the same for io resources.

Here, ACPI claims ports that overlap with my soundcard causing the
soundcard driver to fail to load.  It's unknown why my ACPI BIOS
claims those ports; it did not use to but this is not a (kernel)
regression. Some odd BIOS reconfig triggered by temporarily removing
the card seems to have brought this on.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 drivers/pnp/quirks.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 55f55ed..0bdf9b8 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -245,15 +245,17 @@ static void quirk_system_pci_resources(struct pnp_dev *dev)
 	 */
 	for_each_pci_dev(pdev) {
 		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
-			if (!(pci_resource_flags(pdev, i) & IORESOURCE_MEM) ||
-			    pci_resource_len(pdev, i) == 0)
+			unsigned int type;
+
+			type = pci_resource_flags(pdev, i) &
+					(IORESOURCE_IO | IORESOURCE_MEM);
+			if (!type || pci_resource_len(pdev, i) == 0)
 				continue;
 
 			pci_start = pci_resource_start(pdev, i);
 			pci_end = pci_resource_end(pdev, i);
 			for (j = 0;
-			     (res = pnp_get_resource(dev, IORESOURCE_MEM, j));
-			     j++) {
+			     (res = pnp_get_resource(dev, type, j)); j++) {
 				if (res->start == 0 && res->end == 0)
 					continue;
 
@@ -283,9 +285,10 @@ static void quirk_system_pci_resources(struct pnp_dev *dev)
 				 * the PCI region, and that might prevent a PCI
 				 * driver from requesting its resources.
 				 */
-				dev_warn(&dev->dev, "mem resource "
+				dev_warn(&dev->dev, "%s resource "
 					"(0x%llx-0x%llx) overlaps %s BAR %d "
 					"(0x%llx-0x%llx), disabling\n",
+					pnp_resource_type_name(res),
 					(unsigned long long) pnp_start,
 					(unsigned long long) pnp_end,
 					pci_name(pdev), i,
-- 
1.5.5


--------------090803080205080807040809--
