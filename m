Return-Path: <linux-kernel-owner+w=401wt.eu-S934025AbYEUKnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934025AbYEUKnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 06:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757141AbYEUKnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 06:43:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:57036 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760819AbYEUKnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 06:43:10 -0400
Date: Wed, 21 May 2008 12:45:47 +0200
From: Holger Macht <hmacht@suse.de>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com,
       Len Brown <lenb@kernel.org>
Subject: [PATCH] bay: Exit if notify handler cannot be installed
Message-ID: <20080521104547.GA8097@homac>
Mail-Followup-To: linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com,
	Len Brown <lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If acpi_install_notify_handler() for a bay device fails, the bay driver is
superfluous. Most likely, another driver (like libata) is already caring
about this device anyway. Furthermore,
register_hotplug_dock_device(acpi_handle) from the dock driver must not be
called twice with the same handler. This would result in an endless loop
consuming 100% of CPU. So clean up and exit.

Signed-off-by: Holger Macht <hmacht@suse.de>
---

diff --git a/drivers/acpi/bay.c b/drivers/acpi/bay.c
index d2fc941..26038c2 100644
--- a/drivers/acpi/bay.c
+++ b/drivers/acpi/bay.c
@@ -301,16 +301,20 @@ static int bay_add(acpi_handle handle, int id)
 	 */
 	pdev->dev.uevent_suppress = 0;
 
-	if (acpi_bay_add_fs(new_bay)) {
-		platform_device_unregister(new_bay->pdev);
-		goto bay_add_err;
-	}
-
 	/* register for events on this device */
 	status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 			bay_notify, new_bay);
 	if (ACPI_FAILURE(status)) {
-		printk(KERN_ERR PREFIX "Error installing bay notify handler\n");
+		printk(KERN_INFO PREFIX "Error installing bay notify handler\n");
+		platform_device_unregister(new_bay->pdev);
+		goto bay_add_err;
+	}
+
+	if (acpi_bay_add_fs(new_bay)) {
+		acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+					   bay_notify);
+		platform_device_unregister(new_bay->pdev);
+		goto bay_add_err;
 	}
 
 	/* if we are on a dock station, we should register for dock

