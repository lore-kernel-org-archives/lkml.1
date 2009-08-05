Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895AbZHEWKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbZHEWKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 18:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZHEWKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 18:10:11 -0400
Received: from brmea-mail-2.Sun.COM ([192.18.98.43]:40031 "EHLO
	brmea-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbZHEWKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 18:10:10 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Date: Wed, 05 Aug 2009 18:10:06 -0400
From: james puthukattukaran - Sun Microsystems - Burlington
	 United States <James.Puthukattukaran@Sun.COM>
Subject: [PATCH] ACPI: some issues managing the linked list in
 acpi_pci_register/unregister_driver
To: lenb@kernel.org, linux-kernel@vger.kernel.org
Message-id: <4A7A033E.2010508@sun.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090311)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I submitted an earlier patch on this to lkml with just a single line 
initializing the sub_driver variable to NULL. This was insufficient. 
This patch fixes some  link list management issues in adding a new 
acpi_pci_driver type to the sub_driver list. This is against  2.6.30

Signed-off-by: James Puthukattukaran <james.puthukattukaran@sun.com>

--- linux-2.6.30/drivers/acpi/pci_root.c.orig   2009-08-05 
12:56:01.000000000 -0400
+++ linux-2.6.30/drivers/acpi/pci_root.c        2009-08-05 
14:28:01.000000000 -0400
@@ -76,7 +76,7 @@ struct acpi_pci_root {

 static LIST_HEAD(acpi_pci_roots);

-static struct acpi_pci_driver *sub_driver;
+static struct acpi_pci_driver *sub_driver = NULL;
 static DEFINE_MUTEX(osc_lock);

 int acpi_pci_register_driver(struct acpi_pci_driver *driver)
@@ -84,10 +84,9 @@ int acpi_pci_register_driver(struct acpi
        int n = 0;
        struct list_head *entry;

-       struct acpi_pci_driver **pptr = &sub_driver;
-       while (*pptr)
-               pptr = &(*pptr)->next;
-       *pptr = driver;
+        /* Add to the head of the list */
+        driver->next = sub_driver;
+        sub_driver = driver;

        if (!driver->add)
                return 0;
@@ -107,15 +106,21 @@ EXPORT_SYMBOL(acpi_pci_register_driver);
 void acpi_pci_unregister_driver(struct acpi_pci_driver *driver)
 {
        struct list_head *entry;
+       struct acpi_pci_driver *pptr, *prev;

-       struct acpi_pci_driver **pptr = &sub_driver;
-       while (*pptr) {
-               if (*pptr == driver)
+       /* Remove driver from the sub_driver list */
+       for (prev = NULL, pptr = sub_driver; pptr;
+               prev = pptr, pptr=pptr->next)
+       {
+               if (pptr == driver) {
+                       if (!prev)
+                               sub_driver = driver->next;
+                       else
+                               prev->next = pptr->next;
                        break;
-               pptr = &(*pptr)->next;
+               }
        }
-       BUG_ON(!*pptr);
-       *pptr = (*pptr)->next;
+       BUG_ON(!pptr);

        if (!driver->remove)
                return;
--
