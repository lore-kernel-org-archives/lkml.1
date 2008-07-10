Return-Path: <linux-kernel-owner+w=401wt.eu-S1755626AbYGJVO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbYGJVO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 17:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbYGJVOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 17:14:19 -0400
Received: from sullivan.realtime.net ([205.238.132.226]:3317 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbYGJVOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 17:14:18 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jul 2008 17:14:18 EDT
Date: Thu, 10 Jul 2008 16:12:11 -0500 (CDT)
From: Milton Miller <miltonm@bga.com>
To: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Cc: linuxppc-dev@ozlabs.org, Samuel Ortiz <samuel@sortiz.org>
Message-Id: <for-27-patch1-0@bga.com>
Subject: [RFC] (almost) booting allyesconfig -- please don't poke super-io without request_region
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the following patch to mark the isa region busy and applying a few
patches[1], I was able to kexec boot into an all-yes-config kernel from 
linux-next, with the following KCONFIG_ALLCONFIG file:

# CONFIG_KALLSYMS_EXTRA_PASS is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PPC_EARLY_DEBUG_RTAS_CONSOLE=y
# CONFIG_NSC_FIR is not set
# CONFIG_SMC_IRCC_FIR is not set
# CONFIG_ALI_FIR is not set
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set

While the first two might not be required, and the third is just
selecting the right platform, it would be nice to get the drivers
to play as well as the rest of the kernel.

The drivers all are for super-io chips, either irda/FIR drivers or hwmon,
and poke at isa ports without checking request_region.

It would be great if these 17 super-io drivers would check for resource
availability before poking at io ports.

[not that I expect this to merge as it, but maybe insert-resource or something]



[1] 3 section layout patches and the MTD DISKONCHIP patch,
see linuxppc-dev for full list


diff --git a/arch/powerpc/platforms/pseries/pci.c b/arch/powerpc/platforms/pseries/pci.c
index 2c6ded2..db54620 100644
--- a/arch/powerpc/platforms/pseries/pci.c
+++ b/arch/powerpc/platforms/pseries/pci.c
@@ -58,8 +58,10 @@ DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, pcibios_name_device);
 
 static void __init pSeries_request_regions(void)
 {
-	if (!isa_io_base)
+	if (!isa_io_base) {
+		request_region(0x0,0x400,"isa");
 		return;
+		}
 
 	request_region(0x20,0x20,"pic1");
 	request_region(0xa0,0x20,"pic2");
