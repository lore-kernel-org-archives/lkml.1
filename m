Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbZJEXaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbZJEXaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 19:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbZJEXaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 19:30:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49454 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807AbZJEXaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 19:30:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI / PCI: Fix NULL pointer dereference in acpi_get_pci_dev()
Date: Tue, 6 Oct 2009 01:30:43 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-rjw; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alex Chiang <achiang@hp.com>, Danny Feng <dfeng@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>, chepioq@gmail.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200910060130.43246.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

acpi_get_pci_dev() assumes that every handle it finds in the ACPI CA
name space, between given device handle and the PCI root bridge
handle, corresponds to a PCI-to-PCI bridge with an existing secondary
bus.  For this reason, when it finds a struct pci_dev object
corresponding to one of them, it doesn't check if its 'subordinate'
field is a valid pointer.

However, during resume from a sleep state, as well as at startup, we
may get a dock notification, via dock_acpi_notifier registered by
dock_init(), for a docking station device that is present in the ACPI
tables, but not physically accessible at the moment.  In that
situation, the device appears to be below a PCI bridge whose
'subordinate' field is NULL.  This, in turn, causes
acpi_get_pci_dev() to trigger a NULL pointer dereference.

To fix this issue make acpi_get_pci_dev() check if pdev->subordinate
is not NULL for every device it finds in the path between the root
bridge and the device it's supposed to get to and return NULL if the
"target" device is not really accessible.

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=14129, which is a
regression from 2.6.30.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Danny Feng <dfeng@redhat.com>
Tested-by: chepioq <chepioq@gmail.com>
---
 drivers/acpi/pci_root.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux-2.6/drivers/acpi/pci_root.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_root.c
+++ linux-2.6/drivers/acpi/pci_root.c
@@ -389,6 +389,18 @@ struct pci_dev *acpi_get_pci_dev(acpi_ha
 
 		pbus = pdev->subordinate;
 		pci_dev_put(pdev);
+
+		/*
+		 * During resume from a sleep state we can get a dock
+		 * notification for a device that is present in ACPI tables,
+		 * but not physically accessible at the moment, so tell the
+		 * caller it's not present in that case.
+		 */
+		if (!pbus) {
+			dev_info(&pdev->dev, "Secondary bus not present\n");
+			pdev = NULL;
+			break;
+		}
 	}
 out:
 	list_for_each_entry_safe(node, tmp, &device_list, node)
