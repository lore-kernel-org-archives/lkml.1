Return-Path: <linux-kernel-owner+w=401wt.eu-S932587AbYBNMze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587AbYBNMze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 07:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbYBNMzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 07:55:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939AbYBNMzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 07:55:23 -0500
Date: Thu, 14 Feb 2008 13:56:15 +0100
From: Holger Macht <hmacht@suse.de>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] libata: Register for dock events when the drive is
	inside a dock station
Message-ID: <20080214125615.GD9708@homac.suse.de>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>
References: <20080214124048.GB9708@homac.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214124048.GB9708@homac.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 14. Feb - 13:40:48, Holger Macht wrote:
> If a device/bay is inside a docking station, we need to register for dock
> events additionally to bay events. If a dock event occurs, the dock driver
> will call the appropriate handler (ata_acpi_ap_notify() or
> ata_acpi_dev_notify()) for us.
> 
> Signed-off-by: Holger Macht <hmacht@suse.de>

Updated patch which only includes the dock specific function if the dock
driver is actually compiled.

Signed-off-by: Holger Macht <hmacht@suse.de>
---

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 9e8ec19..5f16055 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -191,20 +191,33 @@ void ata_acpi_associate(struct ata_host *host)
 		else
 			ata_acpi_associate_ide_port(ap);
 
-		if (ap->acpi_handle)
+		if (ap->acpi_handle) {
 			acpi_install_notify_handler (ap->acpi_handle,
 						     ACPI_SYSTEM_NOTIFY,
 						     ata_acpi_ap_notify,
 						     ap);
+#ifdef CONFIG_ACPI_DOCK
+			/* we might be on a docking station */
+			register_hotplug_dock_device(ap->acpi_handle,
+						     ata_acpi_ap_notify, ap);
+#endif
+		}
 
 		for (j = 0; j < ata_link_max_devices(&ap->link); j++) {
 			struct ata_device *dev = &ap->link.device[j];
 
-			if (dev->acpi_handle)
+			if (dev->acpi_handle) {
 				acpi_install_notify_handler (dev->acpi_handle,
 							     ACPI_SYSTEM_NOTIFY,
 							     ata_acpi_dev_notify,
 							     dev);
+#ifdef CONFIG_ACPI_DOCK
+				/* we might be on a docking station */
+				register_hotplug_dock_device(ap->acpi_handle,
+							     ata_acpi_dev_notify,
+							     ap);
+#endif
+			}
 		}
 	}
 }
