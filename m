Return-Path: <linux-kernel-owner+w=401wt.eu-S1760262AbYJKGnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262AbYJKGnf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbYJKGhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:37:45 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:45163 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYJKGhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:38 -0400
Date: Sat, 11 Oct 2008 02:36:43 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 83/85] ACPI: Enable EC device immediately after ACPI full
 initialization
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Zhao Yakui <yakui.zhao@intel.com>, Len Brown <len.brown@intel.com>
Message-id: <455c8793d2c49eaecad038c8de83dade9fc3759f.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhao Yakui <yakui.zhao@intel.com>

when there is no ECDT table and no _INI object for EC device, it will be
enabled before scanning ACPI device. But it is too late after the following
the commit is merged.
    >commit 7752d5cfe3d11ca0bb9c673ec38bd78ba6578f8e
    > Author: Robert Hancock <hancockr@shaw.ca>
    > Date:   Fri Feb 15 01:27:20 2008 -0800
       >x86: validate against acpi motherboard resources

   After the above commit is merged, OS will check whether MCFG area is
reserved in ACPI motherboard resources by calling the function of
acpi_get_devices when there exists MCFG table. In the acpi_get_devices the _STA
object will be evaluated to check the status of the ACPI device. On some broken
BIOS the MYEC object of EC device is initialized as one, which indicates that
EC operation region is already accessible before enabling EC device.So on these
broken BIOS the EC operation region will be accessed in course of evaluating
the _STA object before enabling EC device, which causes that OS will print the
following warning messages:
    >ACPI Error (evregion-0315): No handler for Region [EC__] (ffff88007f8145e8)
[EmbeddedControl] [20080609]
    >ACPI Error (exfldio-0290): Region EmbeddedControl(3) has no handler [20080321]
    >ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.PCI0.SBRG.
         EC__.BAT1._STA] (Node ffff81013fc17a00), AE_NOT_EXIST
    >ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.SBRG.EC__.BAT1.
         _STA] (Node ffff81013fc17a00), AE_NOT_EXIST

Although the above warning message is harmless, it looks confusing.
So it is necessary to enable EC device as early as possible.Maybe it is
appropriate to enable it immediately after ACPI full initialization.

http://bugzilla.kernel.org/show_bug.cgi?id=11255
http://bugzilla.kernel.org/show_bug.cgi?id=11374
http://bugzilla.kernel.org/show_bug.cgi?id=11660

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/bus.c          |    6 ++++++
 drivers/acpi/scan.c         |    4 ----
 include/acpi/acpi_drivers.h |    1 +
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index ccae305..0e0bbc6 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -749,6 +749,12 @@ static int __init acpi_bus_init(void)
 		goto error1;
 	}
 
+	/*
+	 * Maybe EC region is required at bus_scan/acpi_get_devices. So it
+	 * is necessary to enable it as early as possible.
+	 */
+	acpi_boot_ec_enable();
+
 	printk(KERN_INFO PREFIX "Interpreter enabled\n");
 
 	/* Initialize sleep structures */
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index f6f52c1..2ae218f 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1545,7 +1545,6 @@ static int acpi_bus_scan_fixed(struct acpi_device *root)
 	return result;
 }
 
-int __init acpi_boot_ec_enable(void);
 
 static int __init acpi_scan_init(void)
 {
@@ -1579,9 +1578,6 @@ static int __init acpi_scan_init(void)
 	 */
 	result = acpi_bus_scan_fixed(acpi_root);
 
-	/* EC region might be needed at bus_scan, so enable it now */
-	acpi_boot_ec_enable();
-
 	if (!result)
 		result = acpi_bus_scan(acpi_root, &ops);
 
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index e5f38e5..ab926a7 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -100,6 +100,7 @@ int acpi_power_transition(struct acpi_device *device, int state);
    -------------------------------------------------------------------------- */
 #ifdef CONFIG_ACPI_EC
 int acpi_ec_ecdt_probe(void);
+int acpi_boot_ec_enable(void);
 #endif
 
 /* --------------------------------------------------------------------------
-- 
1.5.5.1

