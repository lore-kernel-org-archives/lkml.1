Return-Path: <linux-kernel-owner+w=401wt.eu-S1755016AbYJ3BjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbYJ3BjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 21:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbYJ3Bi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 21:38:56 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:33114 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbYJ3Bi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 21:38:56 -0400
Subject: thinkpad_acpi: struct device - replace bus_id with dev_name(),
	dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 02:38:57 +0100
Message-Id: <1225330737.5970.96.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Subject: thinkpad_acpi: struct device - replace bus_id with dev_name(), dev_set_name()

CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
index 4db1cf9..46a06e1 100644
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -2376,7 +2376,7 @@ static void hotkey_notify(struct ibm_struct *ibm, u32 event)
 		/* forward it to userspace, maybe it knows how to handle it */
 		acpi_bus_generate_netlink_event(
 					ibm->acpi->device->pnp.device_class,
-					ibm->acpi->device->dev.bus_id,
+					dev_name(&ibm->acpi->device->dev),
 					event, 0);
 		return;
 	}
@@ -2506,7 +2506,7 @@ static void hotkey_notify(struct ibm_struct *ibm, u32 event)
 		if (!ignore_acpi_ev && send_acpi_ev) {
 			acpi_bus_generate_netlink_event(
 					ibm->acpi->device->pnp.device_class,
-					ibm->acpi->device->dev.bus_id,
+					dev_name(&ibm->acpi->device->dev),
 					event, hkey);
 		}
 	}
@@ -3725,7 +3725,7 @@ static void dock_notify(struct ibm_struct *ibm, u32 event)
 	}
 	acpi_bus_generate_proc_event(ibm->acpi->device, event, data);
 	acpi_bus_generate_netlink_event(ibm->acpi->device->pnp.device_class,
-					  ibm->acpi->device->dev.bus_id,
+					  dev_name(&ibm->acpi->device->dev),
 					  event, data);
 }
 
@@ -3827,7 +3827,7 @@ static void bay_notify(struct ibm_struct *ibm, u32 event)
 {
 	acpi_bus_generate_proc_event(ibm->acpi->device, event, 0);
 	acpi_bus_generate_netlink_event(ibm->acpi->device->pnp.device_class,
-					  ibm->acpi->device->dev.bus_id,
+					  dev_name(&ibm->acpi->device->dev),
 					  event, 0);
 }
 

