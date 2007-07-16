Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbXGPSBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbXGPSBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758193AbXGPSBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:01:11 -0400
Received: from smtp-out.google.com ([216.239.45.13]:56680 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758056AbXGPSBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:01:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:user-agent;
	b=KEgpJuVwW9iRngJQRWD8AwfQVYIgRD1DEQ4EURJrqCe4mF2mTuyzd6zCb1d+wVAu8
	/nHCh8hc/SBiSis1rEt/g==
Date: Mon, 16 Jul 2007 11:00:19 -0700
From: Aaron Durbin <adurbin@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, len.brown@intel.com, ak@suse.de, akpm@osdl.org
Subject: [PATCH] ACPI: Add reboot mechanism
Message-ID: <20070716180019.GA5112@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add the ability to reset the machine using the RESET_REG in ACPI's FADT table.

Signed-off-by: Aaron Durbin <adurbin@google.com>
---

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index d4336f1..c9906a5 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -21,7 +21,7 @@ obj-$(CONFIG_X86)		+= blacklist.o
 #
 # ACPI Core Subsystem (Interpreter)
 #
-obj-y				+= osl.o utils.o \
+obj-y				+= osl.o utils.o reboot.o \
 				   dispatcher/ events/ executer/ hardware/ \
 				   namespace/ parser/ resources/ tables/ \
 				   utilities/
diff --git a/drivers/acpi/reboot.c b/drivers/acpi/reboot.c
new file mode 100644
index 0000000..4bb4d3e
--- /dev/null
+++ b/drivers/acpi/reboot.c
@@ -0,0 +1,45 @@
+
+#include <linux/pci.h>
+#include <acpi/acpi.h>
+
+void acpi_reboot(void)
+{
+	struct acpi_generic_address *rr;
+	struct pci_bus *bus0;
+	u8 reset_value;
+	unsigned int devfn;
+
+	rr = &acpi_gbl_FADT.reset_register;
+
+	/* Is the reset register supported? */
+	if (!(acpi_gbl_FADT.flags & ACPI_FADT_RESET_REGISTER) ||
+	    rr->bit_width != 8 || rr->bit_offset != 0)
+		return;
+
+	reset_value = acpi_gbl_FADT.reset_value;
+
+	/* The reset register can only exist in I/O, Memory or PCI config space
+	 * on a device on bus 0. */
+	switch (rr->space_id) {
+		case ACPI_ADR_SPACE_PCI_CONFIG:
+			/* The reset register can only live on bus 0. */
+			bus0 = pci_find_bus(0, 0);
+			if (!bus0)
+				return;
+			/* Form PCI device/function pair. */
+			devfn = PCI_DEVFN((rr->address >> 32) & 0xffff,
+					  (rr->address >> 16) & 0xffff);
+			printk(KERN_DEBUG "Resetting with ACPI PCI RESET_REG.");
+			/* Write the value that resets us. */
+			pci_bus_write_config_byte(bus0, devfn,
+					(rr->address & 0xffff), reset_value);
+			break;
+
+		case ACPI_ADR_SPACE_SYSTEM_MEMORY:
+		case ACPI_ADR_SPACE_SYSTEM_IO:
+			printk(KERN_DEBUG "ACPI MEMORY or I/O RESET_REG.");
+			acpi_hw_low_level_write(8, reset_value, rr);
+			break;
+	}
+}
+
diff --git a/include/acpi/reboot.h b/include/acpi/reboot.h
new file mode 100644
index 0000000..1d8da79
--- /dev/null
+++ b/include/acpi/reboot.h
@@ -0,0 +1,10 @@
+#ifndef __ACPI_REBOOT_H
+#define __ACPI_REBOOT_H
+
+#ifdef CONFIG_ACPI
+extern void acpi_reboot(void);
+#else
+#define acpi_reboot()
+#endif
+
+#endif
