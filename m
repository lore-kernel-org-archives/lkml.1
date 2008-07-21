Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbYGUTVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbYGUTVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbYGUTVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:21:34 -0400
Received: from smtp.extricom.com ([192.114.46.18]:57594 "HELO
	smtp.extricom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753560AbYGUTVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:21:33 -0400
Message-ID: <4884E0FB.9010909@extricom.com>
Date: Mon, 21 Jul 2008 22:18:19 +0300
From: Eran Liberty <liberty@extricom.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, eran.liberty@gmail.com
Subject: [PATCH 2.6.26] PCI: refuse to re-add a device to a bus upon pci_scan_child_bus()
References: <48591941.4070408@extricom.com>
In-Reply-To: <48591941.4070408@extricom.com>
Content-Type: multipart/mixed;
 boundary="------------010007000203040801020203"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010007000203040801020203
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dear Penguins,

As a follow up on my own post ( http://lkml.org/lkml/2008/6/18/195 ), I
have  solved a small bug/misbehavior within the pci_scan_single_device().

The misbehavior manifest itself upon calling pci_scan_child_bus() with a
bus which already contain some devices. After scanning is done devices
that already existed will be present twice in the PCI bus devise list.
Once with is_added indication and once without. Trying to add this bus
will cause a resource conflict as the same device is already present and
initialized.

This patch will simply prevent a device to be added to a pci bus list if 
it is already there.

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

Signed-off-by: Eran Liberty <liberty@extricom.org>
---


--------------010007000203040801020203
Content-Type: text/x-patch;
 name="refuse_readd_pci_device.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="refuse_readd_pci_device.patch"

 drivers/pci/probe.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index b1724cf..e3c3ee0 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1002,11 +1002,21 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
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

--------------010007000203040801020203--
