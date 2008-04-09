Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbYDIPmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbYDIPmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 11:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYDIPmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 11:42:38 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:13061 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbYDIPmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:42:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ByPf/o8CHu/VJDaQc7iK2QQ9H3u2ssKTjOKbgcspLxAo1LqXqs8DuMbtlBhZ5S0IqgJ3wrmYwIWaIOuKVw5reMkF1HXkqINCN0FxL9Z9vdwb7/tYy4XZQIFyrcZW0jQw+zKQvHCe+37TUqmFaEZ+kr5TjbcHXVOvuQCmPKbOhB8=
Message-ID: <f7430a760804090842s44ece7bh216d5d28e347955@mail.gmail.com>
Date: Wed, 9 Apr 2008 17:42:34 +0200
From: NoWhereMan <uncommonnonsense@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.25-rc7 001/001] ACPI: workaround for buggy BIOS to ignore error LINK CRS method
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From : Edoardo Vacchi <uncommonnonsense@gmail.com>

When acpi_pci_link_crs_ignore is passed at boot to the kernel,
ignores the error about the _CRS method of LINK device and selects
IRQ from possible IRQ list returned by _PRS method.

Signed-off-by: Edoardo Vacchi <uncommonnonsense@gmail.com>

---

This is nothing more than the patch on comment #127 on bug #8896
http://bugzilla.kernel.org/show_bug.cgi?id=8896#c127

originally by Zhao Yakui <yakui.zhao@intel.com>

ported to 2.6.25 and wrapped into an additional check for the kernel parameter
(plus of course the defintion of the kernel param itself)

The patch provides a workaround for some buggy BIOSes such as Insyde
in Packard Bell EasyNote r1938 (of which I'm an unfortunate owner),
while still keeping boot safe for people not suffering from this bug

---
diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
index 233c40c..ed54c63 100644
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -297,6 +297,16 @@ static int acpi_pci_link_get_current(struct
acpi_pci_link *link)
        return result;
 }

+
+/*
+ * this is set when acpi_pci_link_crs_ignore is passed on boot
+ * it will ignore the -ENODEV error on buggy BIOSes
+ *
+ * workaround for bug #8896
+ *
+ */
+static int acpi_pci_link_crs_ignore; /* 0 or 1*/
+
 static int acpi_pci_link_set(struct acpi_pci_link *link, int irq)
 {
        int result = 0;
@@ -385,9 +395,16 @@ static int acpi_pci_link_set(struct acpi_pci_link
*link, int irq)

        /* Query _CRS, set link->irq.active */
        result = acpi_pci_link_get_current(link);
-       if (result) {
-               goto end;
-       }
+       if (acpi_pci_link_crs_ignore && result == -ENODEV) {
+               /*
+                * Ignore the error about the _CRS method of Link device and
+                * select IRQ from the Possible IRQ list
+                * returned by _PRS method.
+                */
+                printk(KERN_WARNING "Ignore error LINK CRS method.\n");
+                link->irq.active = irq;
+                result = 0;
+        }

        /*
         * Is current setting not what we set?
@@ -412,7 +429,16 @@ static int acpi_pci_link_set(struct acpi_pci_link
*link, int irq)
        return result;
 }

-/* --------------------------------------------------------------------------
+int __init acpi_pci_link_crs_ignore_set(char *str)
+{
+       acpi_pci_link_crs_ignore = 1;
+       return 1;
+}
+
+__setup("acpi_pci_link_crs_ignore", acpi_pci_link_crs_ignore_set);
+
+
+ /* --------------------------------------------------------------------------
                             PCI Link IRQ Management
    --------------------------------------------------------------------------
*/
