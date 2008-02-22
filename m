Return-Path: <linux-kernel-owner+w=401wt.eu-S934882AbYBVKCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934882AbYBVKCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 05:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbYBVKCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 05:02:24 -0500
Received: from mail.southpole.se ([193.12.106.18]:42115 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbYBVKCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 05:02:23 -0500
From: Jonas Bonn <jonas@southpole.se>
To: greg@kroah.com, linux-kernel@vger.kernel.org
Cc: jonas@southpole.se
Subject: [PATCH] Add DECLARE_PCI_DEVICE_TABLE macro
Date: Fri, 22 Feb 2008 11:02:21 +0100
Message-Id: <1203674541-22423-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <47BC5DBD.5090702@garzik.org>
References: <47BC5DBD.5090702@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The definitions of struct pci_device_id arrays should generally follow
the same pattern across the entire kernel.  This macro defines this
array as const and puts it into the __devinitconst section.

There are currently many definitions scattered about the kernel that
omit the __devinitdata modifier despite the documentation stating that
it should always be there.  These definitions really also should have
been const, which wasn't possible before but has become so with the
addition of the __devinitconst attribute.

Furthermore, there are definitions that use "const" and __devinitdata,
which is explicitly wrong but the compiler doesn't catch section
mismatches if there's only one such one case in the module (which is
often the case).

Adding the __devinitconst modifier where there was nothing before buys
us memory.  Adding the const modifier gives the compiler a chance to do
its thing.  Changing __devinitdata to __devinitconst where it was wrong
actually fixes some compiler errors in older (mid-release) kernels that
were patched over by "removing" the section attribute altogether (which
wastes memory).

This macro makes it pretty difficult to get this definition wrong in
the future...

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 Documentation/pci.txt |    6 ++++--
 include/linux/pci.h   |    9 +++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/Documentation/pci.txt b/Documentation/pci.txt
index 72b20c6..bb7bd27 100644
--- a/Documentation/pci.txt
+++ b/Documentation/pci.txt
@@ -123,7 +123,8 @@ initialization with a pointer to a structure describing the driver
 
 
 The ID table is an array of struct pci_device_id entries ending with an
-all-zero entry.  Each entry consists of:
+all-zero entry; use of the macro DECLARE_PCI_DEVICE_TABLE is the preferred
+method of declaring the table.  Each entry consists of:
 
 	vendor,device	Vendor and device ID to match (or PCI_ANY_ID)
 
@@ -191,7 +192,8 @@ Tips on when/where to use the above attributes:
 
 	o Do not mark the struct pci_driver.
 
-	o The ID table array should be marked __devinitdata.
+	o The ID table array should be marked __devinitconst; this is done
+	  automatically if the table is declared with DECLARE_PCI_DEVICE_TABLE().
 
 	o The probe() and remove() functions should be marked __devinit
 	  and __devexit respectively.  All initialization functions
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 87195b6..a41a484 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -389,6 +389,15 @@ struct pci_driver {
 #define	to_pci_driver(drv) container_of(drv, struct pci_driver, driver)
 
 /**
+ * DECLARE_PCI_DEVICE_TABLE - macro used to describe a pci device table
+ * @_table: device table name
+ *
+ * This macro is used to create a struct pci_device_id array (a device table) 
+ * in a generic manner.
+ */
+#define DECLARE_PCI_DEVICE_TABLE(_table) const struct pci_device_id _table[] __devinitconst
+
+/**
  * PCI_DEVICE - macro used to describe a specific pci device
  * @vend: the 16 bit PCI Vendor ID
  * @dev: the 16 bit PCI Device ID
-- 
1.5.3.8


