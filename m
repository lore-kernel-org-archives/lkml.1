Return-Path: <linux-kernel-owner+w=401wt.eu-S1760427AbZKFWaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760427AbZKFWaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760391AbZKFWag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:30:36 -0500
Received: from kroah.org ([198.145.64.141]:57043 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932589AbZKFWXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:22 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:48 2009
Message-Id: <20091106221548.424594928@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
       Chuck Ebbert <cebbert@redhat.com>
Subject: [70/99] ACPI / PCI: Fix NULL pointer dereference in acpi_get_pci_dev() (rev. 2)
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=acpi-pci-fix-null-pointer-dereference-in-acpi_get_pci_dev-rev.-2.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Rafael J. Wysocki <rjw@sisk.pl>

commit 497fb54f578efd2b479727bc88d5ef942c0a1e2d upstream.

acpi_get_pci_dev() may be called for a non-PCI device, in which case
it should return NULL.  However, it assumes that every handle it
finds in the ACPI CA name space, between given device handle and the
PCI root bridge handle, corresponds to a PCI-to-PCI bridge with an
existing secondary bus.  For this reason, when it finds a struct
pci_dev object corresponding to one of them, it doesn't check if
its 'subordinate' field is a valid pointer.  This obviously leads to
a NULL pointer dereference if acpi_get_pci_dev() is called for a
non-PCI device with a PCI parent which is not a bridge.

To fix this issue make acpi_get_pci_dev() check if pdev->subordinate
is not NULL for every device it finds on the path between the root
bridge and the device it's supposed to get to and return NULL if the
"target" device cannot be found.

http://bugzilla.kernel.org/show_bug.cgi?id=14129
(worked in 2.6.30, regression in 2.6.31)

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Danny Feng <dfeng@redhat.com>
Reviewed-by: Alex Chiang <achiang@hp.com>
Tested-by: chepioq <chepioq@gmail.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/pci_root.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -400,6 +400,17 @@ struct pci_dev *acpi_get_pci_dev(acpi_ha
 
 		pbus = pdev->subordinate;
 		pci_dev_put(pdev);
+
+		/*
+		 * This function may be called for a non-PCI device that has a
+		 * PCI parent (eg. a disk under a PCI SATA controller).  In that
+		 * case pdev->subordinate will be NULL for the parent.
+		 */
+		if (!pbus) {
+			dev_dbg(&pdev->dev, "Not a PCI-to-PCI bridge\n");
+			pdev = NULL;
+			break;
+		}
 	}
 out:
 	list_for_each_entry_safe(node, tmp, &device_list, node)


