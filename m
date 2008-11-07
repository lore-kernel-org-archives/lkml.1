Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbYKGAmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbYKGAmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 19:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbYKGAmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 19:42:45 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:61254 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbYKGAmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 19:42:44 -0500
Subject: parisc: struct device - replace bus_id with dev_name(),
 dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Kyle McMartin <kyle@mcmartin.ca>, Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 01:42:46 +0100
Message-Id: <1226018566.3189.13.camel@nga>
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
Subject: parisc: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: linux-parisc@vger.kernel.org
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 arch/parisc/include/asm/parisc-device.h |    4 ++--
 arch/parisc/kernel/drivers.c            |    6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/arch/parisc/include/asm/parisc-device.h
+++ b/arch/parisc/include/asm/parisc-device.h
@@ -42,9 +42,9 @@ struct parisc_driver {
 #define to_parisc_driver(d)	container_of(d, struct parisc_driver, drv)
 #define parisc_parent(d)	to_parisc_device(d->dev.parent)
 
-static inline char *parisc_pathname(struct parisc_device *d)
+static inline const char *parisc_pathname(struct parisc_device *d)
 {
-	return d->dev.bus_id;
+	return dev_name(&d->dev);
 }
 
 static inline void
--- a/arch/parisc/kernel/drivers.c
+++ b/arch/parisc/kernel/drivers.c
@@ -43,7 +43,7 @@ struct hppa_dma_ops *hppa_dma_ops __read
 EXPORT_SYMBOL(hppa_dma_ops);
 
 static struct device root = {
-	.bus_id = "parisc",
+	.init_name = "parisc",
 };
 
 static inline int check_dev(struct device *dev)
@@ -393,7 +393,8 @@ EXPORT_SYMBOL(print_pci_hwpath);
 static void setup_bus_id(struct parisc_device *padev)
 {
 	struct hardware_path path;
-	char *output = padev->dev.bus_id;
+	char name[20];
+	char *output = name;
 	int i;
 
 	get_node_path(padev->dev.parent, &path);
@@ -404,6 +405,7 @@ static void setup_bus_id(struct parisc_d
 		output += sprintf(output, "%u:", (unsigned char) path.bc[i]);
 	}
 	sprintf(output, "%u", (unsigned char) padev->hw_path);
+	dev_set_name(&padev->dev, name);
 }
 
 struct parisc_device * create_tree_node(char id, struct device *parent)


