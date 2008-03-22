Return-Path: <linux-kernel-owner+w=401wt.eu-S1756359AbYCVIbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359AbYCVIbX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 04:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYCVIbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 04:31:10 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:33211 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbYCVIbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 04:31:09 -0400
Date: Sat, 22 Mar 2008 09:30:52 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Tomasz Koprowski <tomek@koprowski.org>
Subject: [PATCH] PCI: Revert SMBus unhide on HP Compaq nx6110
Message-ID: <20080322093052.2705ce63@hyperion.delvare>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 3c0a654e390d00fef9d8faed758f5e1e8078adb5 and
fixes kernel bug #10245.
http://bugzilla.kernel.org/show_bug.cgi?id=10245

The HP Compaq nc6120 has the same PCI sub-device ID as the nx6110, and the
SMBus is used by ACPI for thermal management on the nc6120, so Linux should
not attach a native driver to it. This means that this quirk is unsafe and
has to be removed.

I also added a comment to help developers realize that adding new IDs
to this SMBus unhiding quirk table should be done only with great care,
and in particular only after checking that ACPI is not making use of
the SMBus.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Tomasz Koprowski <tomek@koprowski.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
This 2.6.25 material.

 drivers/pci/quirks.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- linux-2.6.25-rc6.orig/drivers/pci/quirks.c	2008-03-05 16:44:21.000000000 +0100
+++ linux-2.6.25-rc6/drivers/pci/quirks.c	2008-03-21 10:08:46.000000000 +0100
@@ -951,6 +951,12 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
  * accesses to the SMBus registers, with potentially bad effects. Thus you
  * should be very careful when adding new entries: if SMM is accessing the
  * Intel SMBus, this is a very good reason to leave it hidden.
+ *
+ * Likewise, many recent laptops use ACPI for thermal management. If the
+ * ACPI DSDT code accesses the SMBus, then Linux should not access it
+ * natively, and keeping the SMBus hidden is the right thing to do. If you
+ * are about to add an entry in the table below, please first disassemble
+ * the DSDT and double-check that there is no code accessing the SMBus.
  */
 static int asus_hides_smbus;
 
@@ -1028,11 +1034,6 @@ static void __init asus_hides_smbus_host
 			case 0x12bf: /* HP xw4100 */
 				asus_hides_smbus = 1;
 			}
-		else if (dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB)
-			switch (dev->subsystem_device) {
-			case 0x099c: /* HP Compaq nx6110 */
-				asus_hides_smbus = 1;
-			}
        } else if (unlikely(dev->subsystem_vendor == PCI_VENDOR_ID_SAMSUNG)) {
                if (dev->device ==  PCI_DEVICE_ID_INTEL_82855PM_HB)
                        switch(dev->subsystem_device) {


-- 
Jean Delvare
