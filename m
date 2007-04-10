Return-Path: <linux-kernel-owner+w=401wt.eu-S932081AbXDJALO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbXDJALO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 20:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932313AbXDJALN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 20:11:13 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:41907 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753682AbXDJAK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 20:10:57 -0400
Date: Mon, 9 Apr 2007 17:06:30 -0700
Message-Id: <200704100006.l3A06UlW020650@zach-dev.vmware.com>
Subject: [PATCH 10/10] Fix BusLogic to stop using check_region
From: Zachary Amsden <zach@vmware.com>
To: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
CC: "Lenoard N. Zubkoff" <lnz@dandelion.com>
CC: Michael Clay <claym@osuosl.org>
X-OriginalArrivalTime: 10 Apr 2007 00:10:06.0612 (UTC) FILETIME=[9826E540:01C77B04]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I got so sick of seing the check_region warnings from BusLogic.c I actually
fixed it properly.  Never use check region, reserve it before the probe
with request region instead and check the error result; free region if
setup fails.  Should be functionally identical to the original except for
fixing the potential race.

Subject: Fix BusLogic to stop using check_region
Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r 15645892b508 drivers/scsi/BusLogic.c
--- a/drivers/scsi/BusLogic.c	Mon Apr 09 13:43:06 2007 -0700
+++ b/drivers/scsi/BusLogic.c	Mon Apr 09 14:52:00 2007 -0700
@@ -579,17 +579,17 @@ static void __init BusLogic_InitializePr
 	/*
 	   Append the list of standard BusLogic MultiMaster ISA I/O Addresses.
 	 */
-	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe330 : check_region(0x330, BusLogic_MultiMasterAddressCount) == 0)
+	if (!BusLogic_ProbeOptions.LimitedProbeISA || BusLogic_ProbeOptions.Probe330)
 		BusLogic_AppendProbeAddressISA(0x330);
-	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe334 : check_region(0x334, BusLogic_MultiMasterAddressCount) == 0)
+	if (!BusLogic_ProbeOptions.LimitedProbeISA || BusLogic_ProbeOptions.Probe334)
 		BusLogic_AppendProbeAddressISA(0x334);
-	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe230 : check_region(0x230, BusLogic_MultiMasterAddressCount) == 0)
+	if (!BusLogic_ProbeOptions.LimitedProbeISA || BusLogic_ProbeOptions.Probe230)
 		BusLogic_AppendProbeAddressISA(0x230);
-	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe234 : check_region(0x234, BusLogic_MultiMasterAddressCount) == 0)
+	if (!BusLogic_ProbeOptions.LimitedProbeISA || BusLogic_ProbeOptions.Probe234)
 		BusLogic_AppendProbeAddressISA(0x234);
-	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe130 : check_region(0x130, BusLogic_MultiMasterAddressCount) == 0)
+	if (!BusLogic_ProbeOptions.LimitedProbeISA || BusLogic_ProbeOptions.Probe130)
 		BusLogic_AppendProbeAddressISA(0x130);
-	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe134 : check_region(0x134, BusLogic_MultiMasterAddressCount) == 0)
+	if (!BusLogic_ProbeOptions.LimitedProbeISA || BusLogic_ProbeOptions.Probe134)
 		BusLogic_AppendProbeAddressISA(0x134);
 }
 
@@ -795,7 +795,9 @@ static int __init BusLogic_InitializeMul
 	   host adapters are probed.
 	 */
 	if (!BusLogic_ProbeOptions.NoProbeISA)
-		if (PrimaryProbeInfo->IO_Address == 0 && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe330 : check_region(0x330, BusLogic_MultiMasterAddressCount) == 0)) {
+		if (PrimaryProbeInfo->IO_Address == 0 &&
+				(!BusLogic_ProbeOptions.LimitedProbeISA ||
+				 BusLogic_ProbeOptions.Probe330)) {
 			PrimaryProbeInfo->HostAdapterType = BusLogic_MultiMaster;
 			PrimaryProbeInfo->HostAdapterBusType = BusLogic_ISA_Bus;
 			PrimaryProbeInfo->IO_Address = 0x330;
@@ -805,15 +807,25 @@ static int __init BusLogic_InitializeMul
 	   omitting the Primary I/O Address which has already been handled.
 	 */
 	if (!BusLogic_ProbeOptions.NoProbeISA) {
-		if (!StandardAddressSeen[1] && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe334 : check_region(0x334, BusLogic_MultiMasterAddressCount) == 0))
+		if (!StandardAddressSeen[1] &&
+				(!BusLogic_ProbeOptions.LimitedProbeISA ||
+				 BusLogic_ProbeOptions.Probe334))
 			BusLogic_AppendProbeAddressISA(0x334);
-		if (!StandardAddressSeen[2] && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe230 : check_region(0x230, BusLogic_MultiMasterAddressCount) == 0))
+		if (!StandardAddressSeen[2] &&
+				(!BusLogic_ProbeOptions.LimitedProbeISA ||
+				 BusLogic_ProbeOptions.Probe230))
 			BusLogic_AppendProbeAddressISA(0x230);
-		if (!StandardAddressSeen[3] && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe234 : check_region(0x234, BusLogic_MultiMasterAddressCount) == 0))
+		if (!StandardAddressSeen[3] &&
+				(!BusLogic_ProbeOptions.LimitedProbeISA ||
+				 BusLogic_ProbeOptions.Probe234))
 			BusLogic_AppendProbeAddressISA(0x234);
-		if (!StandardAddressSeen[4] && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe130 : check_region(0x130, BusLogic_MultiMasterAddressCount) == 0))
+		if (!StandardAddressSeen[4] &&
+				(!BusLogic_ProbeOptions.LimitedProbeISA ||
+				 BusLogic_ProbeOptions.Probe130))
 			BusLogic_AppendProbeAddressISA(0x130);
-		if (!StandardAddressSeen[5] && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe134 : check_region(0x134, BusLogic_MultiMasterAddressCount) == 0))
+		if (!StandardAddressSeen[5] &&
+				(!BusLogic_ProbeOptions.LimitedProbeISA ||
+				 BusLogic_ProbeOptions.Probe134))
 			BusLogic_AppendProbeAddressISA(0x134);
 	}
 	/*
@@ -2220,22 +2232,35 @@ static int __init BusLogic_init(void)
 		HostAdapter->PCI_Device = ProbeInfo->PCI_Device;
 		HostAdapter->IRQ_Channel = ProbeInfo->IRQ_Channel;
 		HostAdapter->AddressCount = BusLogic_HostAdapterAddressCount[HostAdapter->HostAdapterType];
+
+		/*
+		   Make sure region is free prior to probing.
+		 */
+		if (!request_region(HostAdapter->IO_Address, HostAdapter->AddressCount,
+					"BusLogic"))
+			continue;
 		/*
 		   Probe the Host Adapter.  If unsuccessful, abort further initialization.
 		 */
-		if (!BusLogic_ProbeHostAdapter(HostAdapter))
+		if (!BusLogic_ProbeHostAdapter(HostAdapter)) {
+			release_region(HostAdapter->IO_Address, HostAdapter->AddressCount);
 			continue;
+		}
 		/*
 		   Hard Reset the Host Adapter.  If unsuccessful, abort further
 		   initialization.
 		 */
-		if (!BusLogic_HardwareResetHostAdapter(HostAdapter, true))
+		if (!BusLogic_HardwareResetHostAdapter(HostAdapter, true)) {
+			release_region(HostAdapter->IO_Address, HostAdapter->AddressCount);
 			continue;
+		}
 		/*
 		   Check the Host Adapter.  If unsuccessful, abort further initialization.
 		 */
-		if (!BusLogic_CheckHostAdapter(HostAdapter))
+		if (!BusLogic_CheckHostAdapter(HostAdapter)) {
+			release_region(HostAdapter->IO_Address, HostAdapter->AddressCount);
 			continue;
+		}
 		/*
 		   Initialize the Driver Options field if provided.
 		 */
@@ -2247,16 +2272,6 @@ static int __init BusLogic_init(void)
 		 */
 		BusLogic_AnnounceDriver(HostAdapter);
 		/*
-		   Register usage of the I/O Address range.  From this point onward, any
-		   failure will be assumed to be due to a problem with the Host Adapter,
-		   rather than due to having mistakenly identified this port as belonging
-		   to a BusLogic Host Adapter.  The I/O Address range will not be
-		   released, thereby preventing it from being incorrectly identified as
-		   any other type of Host Adapter.
-		 */
-		if (!request_region(HostAdapter->IO_Address, HostAdapter->AddressCount, "BusLogic"))
-			continue;
-		/*
 		   Register the SCSI Host structure.
 		 */
 
@@ -2280,6 +2295,12 @@ static int __init BusLogic_init(void)
 		   Acquire the System Resources necessary to use the Host Adapter, then
 		   Create the Initial CCBs, Initialize the Host Adapter, and finally
 		   perform Target Device Inquiry.
+
+		   From this point onward, any failure will be assumed to be due to a
+		   problem with the Host Adapter, rather than due to having mistakenly
+		   identified this port as belonging to a BusLogic Host Adapter.  The
+		   I/O Address range will not be released, thereby preventing it from
+		   being incorrectly identified as any other type of Host Adapter.
 		 */
 		if (BusLogic_ReadHostAdapterConfiguration(HostAdapter) &&
 		    BusLogic_ReportHostAdapterConfiguration(HostAdapter) &&
@@ -3598,6 +3619,7 @@ static void __exit BusLogic_exit(void)
 
 __setup("BusLogic=", BusLogic_Setup);
 
+#ifdef MODULE
 static struct pci_device_id BusLogic_pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
@@ -3607,6 +3629,7 @@ static struct pci_device_id BusLogic_pci
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ }
 };
+#endif
 MODULE_DEVICE_TABLE(pci, BusLogic_pci_tbl);
 
 module_init(BusLogic_init);
