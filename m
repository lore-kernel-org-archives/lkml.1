Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbYKGAoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbYKGAoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 19:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbYKGAn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 19:43:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:2036 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbYKGAn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 19:43:58 -0500
Subject: sparc: struct device - replace bus_id with dev_name(),
 dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: "David S. Miller" <davem@davemloft.net>,
       "William L. Irwin" <wli@holomorphy.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 01:43:59 +0100
Message-Id: <1226018639.3189.15.camel@nga>
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
Subject: sparc: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: David S. Miller <davem@davemloft.net>
Cc: William L. Irwin <wli@holomorphy.com>
Cc: sparclinux@vger.kernel.org
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 arch/sparc/kernel/of_device.c |    4 ++--
 arch/sparc64/kernel/vio.c     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/sparc/kernel/of_device.c
+++ b/arch/sparc/kernel/of_device.c
@@ -563,9 +563,9 @@ build_resources:
 	op->dev.parent = parent;
 	op->dev.bus = &of_platform_bus_type;
 	if (!parent)
-		strcpy(op->dev.bus_id, "root");
+		dev_set_name(&op->dev, "root");
 	else
-		sprintf(op->dev.bus_id, "%08x", dp->node);
+		dev_set_name(&op->dev, "%08x", dp->node);
 
 	if (of_device_register(op)) {
 		printk("%s: Could not register of device.\n",
--- a/arch/sparc64/kernel/vio.c
+++ b/arch/sparc64/kernel/vio.c
@@ -224,7 +224,7 @@ static struct vio_dev *vio_create_one(st
 	if (!strcmp(type, "domain-services-port"))
 		bus_id_name = "ds";
 
-	if (strlen(bus_id_name) >= BUS_ID_SIZE - 4) {
+	if (strlen(bus_id_name) >= 20 - 4) {
 		printk(KERN_ERR "VIO: bus_id_name [%s] is too long.\n",
 		       bus_id_name);
 		return NULL;


