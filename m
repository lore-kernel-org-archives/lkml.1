Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbYKGAj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbYKGAj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 19:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbYKGAju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 19:39:50 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:25932 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbYKGAju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 19:39:50 -0500
Subject: IA64: struct device - replace bus_id with dev_name(),
 dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 01:39:51 +0100
Message-Id: <1226018391.3189.10.camel@nga>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I did not compile or test it, please let me know, or help fixing
 it, if something is wrong with the conversion)

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: IA64: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: Tony Luck <tony.luck@intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 arch/ia64/kernel/pci-dma.c  |    2 +-
 arch/ia64/sn/kernel/tiocx.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/arch/ia64/kernel/pci-dma.c
+++ b/arch/ia64/kernel/pci-dma.c
@@ -40,7 +40,7 @@ int iommu_detected __read_mostly;
    be probably a smaller DMA mask, but this is bug-to-bug compatible
    to i386. */
 struct device fallback_dev = {
-	.bus_id = "fallback device",
+	.init_name = "fallback device",
 	.coherent_dma_mask = DMA_32BIT_MASK,
 	.dma_mask = &fallback_dev.coherent_dma_mask,
 };
--- a/arch/ia64/sn/kernel/tiocx.c
+++ b/arch/ia64/sn/kernel/tiocx.c
@@ -206,8 +206,7 @@ cx_device_register(nasid_t nasid, int pa
 	cx_dev->dev.parent = NULL;
 	cx_dev->dev.bus = &tiocx_bus_type;
 	cx_dev->dev.release = tiocx_bus_release;
-	snprintf(cx_dev->dev.bus_id, BUS_ID_SIZE, "%d",
-		 cx_dev->cx_id.nasid);
+	dev_set_name(&cx_dev->dev, "%d", cx_dev->cx_id.nasid);
 	device_register(&cx_dev->dev);
 	get_device(&cx_dev->dev);
 

