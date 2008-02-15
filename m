Return-Path: <linux-kernel-owner+w=401wt.eu-S935619AbYBOAqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935619AbYBOAqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934833AbYBOAms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:42:48 -0500
Received: from ns1.suse.de ([195.135.220.2]:38004 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934825AbYBOAmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:42:47 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/12] PCI: make no_pci_devices() use the pci_bus_type list
Date: Thu, 14 Feb 2008 16:40:07 -0800
Message-Id: <1203036010-27988-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080215003909.GA27981@kroah.com>
References: <20080215003909.GA27981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no_pci_devices() should use the driver core list of PCI devices, not our
"separate" one.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/probe.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 4d23b9f..5fd662e 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -22,16 +22,27 @@ EXPORT_SYMBOL(pci_root_buses);
 
 LIST_HEAD(pci_devices);
 
+
+static int find_anything(struct device *dev, void *data)
+{
+	return 1;
+}
+
 /*
  * Some device drivers need know if pci is initiated.
  * Basically, we think pci is not initiated when there
- * is no device in list of pci_devices.
+ * is no device to be found on the pci_bus_type.
  */
 int no_pci_devices(void)
 {
-	return list_empty(&pci_devices);
-}
+	struct device *dev;
+	int no_devices;
 
+	dev = bus_find_device(&pci_bus_type, NULL, NULL, find_anything);
+	no_devices = (dev == NULL);
+	put_device(dev);
+	return no_devices;
+}
 EXPORT_SYMBOL(no_pci_devices);
 
 #ifdef HAVE_PCI_LEGACY
-- 
1.5.4

