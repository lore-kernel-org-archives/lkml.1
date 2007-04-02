Return-Path: <linux-kernel-owner+w=401wt.eu-S965786AbXDBUJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965786AbXDBUJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 16:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965787AbXDBUJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 16:09:27 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40531 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965786AbXDBUJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 16:09:27 -0400
Date: Mon, 2 Apr 2007 15:09:24 -0500
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: [PATCH]: Suppress PCI bridge sysfs error messages.
Message-ID: <20070402200923.GG4922@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Greg, 

A non-urgent and somwhat ugly patch; please review, and if 
it seems correct, please apply.

--linas

While fiddling with PCI hotplugging, I noticed the messages

pci 0001:00:02.4: Error creating sysfs bridge symlink, continuing...
pci 0001:00:02.2: Error creating sysfs bridge symlink, continuing...
pci 0001:00:02.6: Error creating sysfs bridge symlink, continuing...
pci 0001:00:02.0: Error creating sysfs bridge symlink, continuing...

These are printed by pci_bus_add_devices(); the reason for the error 
is that these are all other bridges that are already in sysfs. 
For a while, I assumed that pci_bus_add_devices() was being called
with the wrong argument, but this seems not to be the case. Thus,
I simply added a flag to make these prints go quiet. 

This patch also cleans up some crazy whitespace indentation.

This patch seems inelegant, but I'm not sure what else to do.


Signed-off-by: Linas Vepstas <linas@austin.ibm.com>

----

 drivers/pci/bus.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

Index: linux-2.6.21-rc4-git4/drivers/pci/bus.c
===================================================================
--- linux-2.6.21-rc4-git4.orig/drivers/pci/bus.c	2007-04-02 14:34:46.000000000 -0500
+++ linux-2.6.21-rc4-git4/drivers/pci/bus.c	2007-04-02 14:40:52.000000000 -0500
@@ -131,18 +131,22 @@ void __devinit pci_bus_add_devices(struc
 		 * it and then scan for unattached PCI devices.
 		 */
 		if (dev->subordinate) {
-		       if (list_empty(&dev->subordinate->node)) {
-			       down_write(&pci_bus_sem);
-			       list_add_tail(&dev->subordinate->node,
+			int make_link = 0;
+			if (list_empty(&dev->subordinate->node)) {
+				make_link = 1;
+				down_write(&pci_bus_sem);
+				list_add_tail(&dev->subordinate->node,
 					       &dev->bus->children);
-			       up_write(&pci_bus_sem);
+				up_write(&pci_bus_sem);
 			}
 			pci_bus_add_devices(dev->subordinate);
-			retval = sysfs_create_link(&dev->subordinate->class_dev.kobj,
+			if (make_link) {
+				retval = sysfs_create_link(&dev->subordinate->class_dev.kobj,
 						   &dev->dev.kobj, "bridge");
-			if (retval)
-				dev_err(&dev->dev, "Error creating sysfs "
-					"bridge symlink, continuing...\n");
+				if (retval)
+					dev_err(&dev->dev, "Error creating sysfs "
+						"bridge symlink, continuing...\n");
+			}
 		}
 	}
 }
