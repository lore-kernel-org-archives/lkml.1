Return-Path: <linux-kernel-owner+w=401wt.eu-S933011AbXBMAxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011AbXBMAxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 19:53:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933028AbXBMAxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 19:53:04 -0500
Received: from rocky.osuosl.org ([140.211.166.230]:46021 "EHLO
	rocky.osuosl.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933011AbXBMAxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 19:53:01 -0500
X-Greylist: delayed 1556 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Feb 2007 19:53:01 EST
Date: Mon, 12 Feb 2007 16:27:04 -0800
From: Michael Clay <claym@osuosl.org>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: BusLogic check_region patch
Message-ID: <20070213002704.GD9534@ash.osuosl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is meant to remove the calls to check_region, a now
deprecated function in order to get rid of compilation warning.  This
was done by finding all calls to check_region and replacing them with
calls to request_region.  check_region essentially was a wrapper around
request_region, and was checking if the request_region returned a
pointer or null.  As a result, I simply inlined the process of checking
for null, eliminating the need to call the check_region wrapper.


--- drivers/scsi/BusLogic.c	2007-02-12 16:05:29.000000000 -0800
+++ /home/claym/sandbox/BusLogic.c	2007-02-12 16:11:23.000000000 -0800
@@ -579,17 +579,17 @@ static void __init BusLogic_InitializePr
 	/*
 	   Append the list of standard BusLogic MultiMaster ISA I/O Addresses.
 	 */
-	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe330 : check_region(0x330, BusLogic_MultiMasterAddressCount) == 0)
+	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe330 : request_region(0x330, BusLogic_MultiMasterAddressCount, "Buslogic") != NULL)
 		BusLogic_AppendProbeAddressISA(0x330);
-	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe334 : check_region(0x334, BusLogic_MultiMasterAddressCount) == 0)
+	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe334 : request_region(0x334, BusLogic_MultiMasterAddressCount, "BusLogic") != NULL)
 		BusLogic_AppendProbeAddressISA(0x334);
-	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe230 : check_region(0x230, BusLogic_MultiMasterAddressCount) == 0)
+	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe230 : request_region(0x230, BusLogic_MultiMasterAddressCount, "BusLogic") != NULL)
 		BusLogic_AppendProbeAddressISA(0x230);
-	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe234 : check_region(0x234, BusLogic_MultiMasterAddressCount) == 0)
+	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe234 : request_region(0x234, BusLogic_MultiMasterAddressCount, "BusLogic") != NULL)
 		BusLogic_AppendProbeAddressISA(0x234);
-	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe130 : check_region(0x130, BusLogic_MultiMasterAddressCount) == 0)
+	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe130 : request_region(0x130, BusLogic_MultiMasterAddressCount, "BusLogic") != NULL)
 		BusLogic_AppendProbeAddressISA(0x130);
-	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe134 : check_region(0x134, BusLogic_MultiMasterAddressCount) == 0)
+	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe134 : request_region(0x134, BusLogic_MultiMasterAddressCount, "BusLogic") != NULL)
 		BusLogic_AppendProbeAddressISA(0x134);
 }
 
@@ -795,7 +795,7 @@ static int __init BusLogic_InitializeMul
 	   host adapters are probed.
 	 */
 	if (!BusLogic_ProbeOptions.NoProbeISA)
-		if (PrimaryProbeInfo->IO_Address == 0 && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe330 : check_region(0x330, BusLogic_MultiMasterAddressCount) == 0)) {
+		if (PrimaryProbeInfo->IO_Address == 0 && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe330 : request_region(0x330, BusLogic_MultiMasterAddressCount,"BusLogic") != NULL)) {
 			PrimaryProbeInfo->HostAdapterType = BusLogic_MultiMaster;
 			PrimaryProbeInfo->HostAdapterBusType = BusLogic_ISA_Bus;
 			PrimaryProbeInfo->IO_Address = 0x330;
@@ -805,15 +805,15 @@ static int __init BusLogic_InitializeMul
 	   omitting the Primary I/O Address which has already been handled.
 	 */
 	if (!BusLogic_ProbeOptions.NoProbeISA) {
-		if (!StandardAddressSeen[1] && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe334 : check_region(0x334, BusLogic_MultiMasterAddressCount) == 0))
+		if (!StandardAddressSeen[1] && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe334 : request_region(0x334, BusLogic_MultiMasterAddressCount, "BusLogic") != NULL))
 			BusLogic_AppendProbeAddressISA(0x334);
-		if (!StandardAddressSeen[2] && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe230 : check_region(0x230, BusLogic_MultiMasterAddressCount) == 0))
+		if (!StandardAddressSeen[2] && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe230 : request_region(0x230, BusLogic_MultiMasterAddressCount, "BusLogic") != NULL))
 			BusLogic_AppendProbeAddressISA(0x230);
-		if (!StandardAddressSeen[3] && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe234 : check_region(0x234, BusLogic_MultiMasterAddressCount) == 0))
+		if (!StandardAddressSeen[3] && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe234 : request_region(0x234, BusLogic_MultiMasterAddressCount, "BusLogic") != NULL))
 			BusLogic_AppendProbeAddressISA(0x234);
-		if (!StandardAddressSeen[4] && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe130 : check_region(0x130, BusLogic_MultiMasterAddressCount) == 0))
+		if (!StandardAddressSeen[4] && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe130 : request_region(0x130, BusLogic_MultiMasterAddressCount, "BusLogic") != NULL))
 			BusLogic_AppendProbeAddressISA(0x130);
-		if (!StandardAddressSeen[5] && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe134 : check_region(0x134, BusLogic_MultiMasterAddressCount) == 0))
+		if (!StandardAddressSeen[5] && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe134 : request_region(0x134, BusLogic_MultiMasterAddressCount, "BusLogic") != NULL))
 			BusLogic_AppendProbeAddressISA(0x134);
 	}
 	/*

-- 
Michael Clay
RAIV Lead Developer
Open Source Lab - http://osuosl.org
claym@osuosl.org
