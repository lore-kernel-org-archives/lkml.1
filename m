Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbYADVPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbYADVPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 16:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbYADVNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 16:13:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:38027 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbYADVNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 16:13:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=nPw/vflLvenHKk9c98xv90NGlEWVcuvkBqc+HUa1rOJZbgQaNRi6IZ8HYernH6tN5klJWp+g3rrtIJZan5W4fcqGd9EfrInxCTefp+ts8FzkwYidVeRh3r2+Qz0DoPr3Qd/D7hbYoM6Jnr4YhfAE1XAj/Snm0mwixMX0HkxG470=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 04 Jan 2008 22:25:15 +0100
Message-Id: <20080104212515.6978.60571.sendpatchset@localhost.localdomain>
In-Reply-To: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
References: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
Subject: [PATCH 7/15] ide: cleanup ide_system_bus_speed()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the facts that:

* When ide_init() is called 'system_bus_speed' always equals zero.

* system_bus_clock() is never called before ide_init().

and:

* Move printk() from ide_system_bus_speed() to ide_init().

* Don't assign 'system_bus_speed' in ide_system_bus_speed().

* Don't call ide_system_bus_speed() in system_bus_clock().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-39 bytes
 drivers/ide/ide.c |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -240,22 +240,12 @@ static int ide_system_bus_speed(void)
 #define pci_default 0
 #endif /* CONFIG_PCI */
 
-	if (!system_bus_speed) {
-		if (idebus_parameter) {
-			/* user supplied value */
-			system_bus_speed = idebus_parameter;
-		} else if (pci_dev_present(pci_default)) {
-			/* safe default value for PCI */
-			system_bus_speed = 33;
-		} else {
-			/* safe default value for VESA and PCI */
-			system_bus_speed = 50;
-		}
-		printk(KERN_INFO "ide: Assuming %dMHz system bus speed "
-			"for PIO modes%s\n", system_bus_speed,
-			idebus_parameter ? "" : "; override with idebus=xx");
-	}
-	return system_bus_speed;
+	/* user supplied value */
+	if (idebus_parameter)
+		return idebus_parameter;
+
+	/* safe default value for PCI or VESA and PCI*/
+	return pci_dev_present(pci_default) ? 33 : 50;
 }
 
 ide_hwif_t * ide_find_port(unsigned long base)
@@ -912,7 +902,7 @@ static int set_unmaskirq(ide_drive_t *dr
 
 int system_bus_clock (void)
 {
-	return((int) ((!system_bus_speed) ? ide_system_bus_speed() : system_bus_speed ));
+	return system_bus_speed;
 }
 
 EXPORT_SYMBOL(system_bus_clock);
@@ -1667,6 +1657,10 @@ static int __init ide_init(void)
 	printk(KERN_INFO "Uniform Multi-Platform E-IDE driver " REVISION "\n");
 	system_bus_speed = ide_system_bus_speed();
 
+	printk(KERN_INFO "ide: Assuming %dMHz system bus speed "
+			 "for PIO modes%s\n", system_bus_speed,
+			idebus_parameter ? "" : "; override with idebus=xx");
+
 	ret = bus_register(&ide_bus_type);
 	if (ret < 0) {
 		printk(KERN_WARNING "IDE: bus_register error: %d\n", ret);
