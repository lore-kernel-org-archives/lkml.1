Return-Path: <linux-kernel-owner+w=401wt.eu-S1758297AbYLKWPC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297AbYLKWPC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 17:15:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757139AbYLKWNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 17:13:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756918AbYLKWNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 17:13:49 -0500
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Adam Jackson <ajax@redhat.com>
Subject: [PATCH] PCI: Don't carp about BAR allocation failures in quiet boot
Date: Thu, 11 Dec 2008 17:13:45 -0500
Message-Id: <1229033625-30825-4-git-send-email-ajax@redhat.com>
In-Reply-To: <1229033625-30825-3-git-send-email-ajax@redhat.com>
References: <1229033625-30825-1-git-send-email-ajax@redhat.com>
 <1229033625-30825-2-git-send-email-ajax@redhat.com>
 <1229033625-30825-3-git-send-email-ajax@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are easy to trigger (more or less harmlessly) with multiple video
cards, since the ROM BAR will typically not be given any space by the
BIOS bridge setup.  No reason to punish quiet boot for this.

Signed-off-by: Adam Jackson <ajax@redhat.com>
---
 arch/x86/pci/i386.c     |    4 ++--
 drivers/pci/setup-res.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 844df0c..43d9783 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -129,7 +129,7 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
 				pr = pci_find_parent_resource(dev, r);
 				if (!r->start || !pr ||
 				    request_resource(pr, r) < 0) {
-					dev_err(&dev->dev, "BAR %d: can't allocate resource\n", idx);
+					dev_info(&dev->dev, "BAR %d: can't allocate resource\n", idx);
 					/*
 					 * Something is wrong with the region.
 					 * Invalidate the resource to prevent
@@ -170,7 +170,7 @@ static void __init pcibios_allocate_resources(int pass)
 					r->flags, disabled, pass);
 				pr = pci_find_parent_resource(dev, r);
 				if (!pr || request_resource(pr, r) < 0) {
-					dev_err(&dev->dev, "BAR %d: can't allocate resource\n", idx);
+					dev_info(&dev->dev, "BAR %d: can't allocate resource\n", idx);
 					/* We'll assign a new address later */
 					r->end -= r->start;
 					r->start = 0;
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 2dbd96c..4e37563 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -134,7 +134,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 
 	align = resource_alignment(res);
 	if (!align) {
-		dev_err(&dev->dev, "BAR %d: can't allocate resource (bogus "
+		dev_info(&dev->dev, "BAR %d: can't allocate resource (bogus "
 			"alignment) %pR flags %#lx\n",
 			resno, res, res->flags);
 		return -EINVAL;
@@ -157,7 +157,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 	}
 
 	if (ret) {
-		dev_err(&dev->dev, "BAR %d: can't allocate %s resource %pR\n",
+		dev_info(&dev->dev, "BAR %d: can't allocate %s resource %pR\n",
 			resno, res->flags & IORESOURCE_IO ? "I/O" : "mem", res);
 	} else {
 		res->flags &= ~IORESOURCE_STARTALIGN;
-- 
1.6.0.3

