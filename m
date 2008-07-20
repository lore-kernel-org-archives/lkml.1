Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbYGTKl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbYGTKl5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 06:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbYGTKlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 06:41:50 -0400
Received: from smtp1.extricom.com ([212.235.24.249]:40388 "HELO
	smtp.extricom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1754556AbYGTKlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 06:41:49 -0400
Message-ID: <4883141A.4080209@extricom.com>
Date: Sun, 20 Jul 2008 13:31:54 +0300
From: Eran Liberty <liberty@extricom.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.24-rc4] PCI: refuse to re-add a device to a bus upon pci_scan_child_bus()
References: <48591941.4070408@extricom.com>
In-Reply-To: <48591941.4070408@extricom.com>
Content-Type: multipart/mixed;
 boundary="------------040900060106080901000207"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040900060106080901000207
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dear Penguins,

As  a follow up on my own post ( http://lkml.org/lkml/2008/6/18/195 ), I 
have  solved a small bug/misbehavior within the pci_scan_single_device().

The misbehavior manifest itself upon calling pci_scan_child_bus() with a 
bus which already contain some devices. After scanning is done devices 
that already existed will be present twice in the PCI bus devise list. 
Once with is_added indication and once without. Trying to add this bus 
will cause a resource conflict as the same device is already present and 
initialized.

This patch will simply prevent a device to be added to a bus list if it 
is already there.

Points to consider:
1. I am not a PCI Guru and might have over looked the bigger picture. Is 
it OK to prevent a device of being re-added?
2. I have decided that two devices are, in fact, the same instance if it 
has the same: vendor, device, and devfn. Is there a finer test for a 
device identity?

p.s. As per http://www.kernel.org/pub/linux/docs/lkml/#s1-10 it is 
preferred for Mozilla Firefox clients to attach the patch, hence my 
patch is attached.

Liberty

Signed-off-by: Eran Liberty <liberty@extrictom.org>
---

--------------040900060106080901000207
Content-Type: text/x-patch;
 name="refuse_readd_pci_device.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="refuse_readd_pci_device.patch"

Index: drivers/pci/probe.c
===================================================================
--- drivers/pci/probe.c	(revision 102)
+++ drivers/pci/probe.c	(revision 103)
@@ -996,11 +996,21 @@
 struct pci_dev *__ref pci_scan_single_device(struct pci_bus *bus, int devfn)
 {
 	struct pci_dev *dev;
+	struct list_head *ln;
 
 	dev = pci_scan_device(bus, devfn);
 	if (!dev)
 		return NULL;
 
+	/* refuse to re-add a device */
+	list_for_each(ln, &bus->devices) {
+		struct pci_dev *d = pci_dev_b(ln);
+		if ((d->vendor == dev->vendor) &&
+		    (d->device == dev->device) &&
+		    (d->devfn == dev->devfn))
+			return NULL;
+	}
+
 	pci_device_add(dev, bus);
 
 	return dev;

--------------040900060106080901000207--
