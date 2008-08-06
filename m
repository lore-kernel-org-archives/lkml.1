Return-Path: <linux-kernel-owner+w=401wt.eu-S1030358AbYHFP4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030358AbYHFP4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756728AbYHFP4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:56:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746AbYHFP4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:56:04 -0400
Date: Wed, 6 Aug 2008 17:56:01 +0200
From: Holger Macht <hmacht@suse.de>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Len Brown <lenb@kernel.org>, ak@linux.intel.com
Subject: ACPI: Properly clear flags on false-positives and send uevent on
	sudden unplug
Message-ID: <20080806155601.GA4243@homac.suse.de>
Mail-Followup-To: linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
	Len Brown <lenb@kernel.org>, ak@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices emit a ACPI_NOTIFY_DEVICE_CHECK while physically unplugging
even if the software undock has already been done and dock_present() check
fails. However, the internal flags need to be cleared (complete_undock()).

Also, even notify userspace if the dock station suddently went away
without proper software undocking.

Signed-off-by: Holger Macht <hmacht@suse.de>
---

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index bb7c51f..7d2edf1 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -563,9 +563,6 @@ EXPORT_SYMBOL_GPL(unregister_hotplug_dock_device);
  */
 static int handle_eject_request(struct dock_station *ds, u32 event)
 {
-	if (!dock_present(ds))
-		return -ENODEV;
-
 	if (dock_in_progress(ds))
 		return -EBUSY;
 
@@ -573,8 +570,16 @@ static int handle_eject_request(struct dock_station *ds, u32 event)
 	 * here we need to generate the undock
 	 * event prior to actually doing the undock
 	 * so that the device struct still exists.
+	 * Also, even send the dock event if the
+	 * device is not present anymore
 	 */
 	dock_event(ds, event, UNDOCK_EVENT);
+
+	if (!dock_present(ds)) {
+		complete_undock(ds);
+		return -ENODEV;
+	}
+
 	hotplug_dock_devices(ds, ACPI_NOTIFY_EJECT_REQUEST);
 	undock(ds);
 	eject_dock(ds);
