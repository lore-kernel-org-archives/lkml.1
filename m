Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbYCMRZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbYCMRZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 13:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbYCMRZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 13:25:18 -0400
Received: from ns1.suse.de ([195.135.220.2]:42879 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbYCMRZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 13:25:17 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 1/1] PCI: fix issue with busses registering multiple times in sysfs
Date: Thu, 13 Mar 2008 10:25:13 -0700
Message-Id: <1205429113-17641-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20080313172410.GA17045@kroah.com>
References: <20080313172410.GA17045@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI busses can be registered multiple times, so we need to detect if we
have registered our bus structure in sysfs already.  If so, don't do it
again.

Thanks to Guennadi Liakhovetski <g.liakhovetski@gmx.de> for reporting
the problem, and to Linus for poking me to get me to believe that it was
a real problem.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/bus.c   |    6 +++++-
 include/linux/pci.h |    1 +
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 6a9403d..d708358 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -143,14 +143,18 @@ void pci_bus_add_devices(struct pci_bus *bus)
 			/* register the bus with sysfs as the parent is now
 			 * properly registered. */
 			child_bus = dev->subordinate;
+			if (child_bus->is_added)
+				continue;
 			child_bus->dev.parent = child_bus->bridge;
 			retval = device_register(&child_bus->dev);
 			if (retval)
 				dev_err(&dev->dev, "Error registering pci_bus,"
 					" continuing...\n");
-			else
+			else {
+				child_bus->is_added = 1;
 				retval = device_create_file(&child_bus->dev,
 							&dev_attr_cpuaffinity);
+			}
 			if (retval)
 				dev_err(&dev->dev, "Error creating cpuaffinity"
 					" file, continuing...\n");
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 38eff19..9010f54 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -278,6 +278,7 @@ struct pci_bus {
 	struct device		dev;
 	struct bin_attribute	*legacy_io; /* legacy I/O for this bus */
 	struct bin_attribute	*legacy_mem; /* legacy mem */
+	unsigned int		is_added:1;
 };
 
 #define pci_bus_b(n)	list_entry(n, struct pci_bus, node)
-- 
1.5.4.3

