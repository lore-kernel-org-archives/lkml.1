Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbZJPVPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbZJPVPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 17:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZJPVPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 17:15:13 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:29125 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbZJPVPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 17:15:10 -0400
Subject: [PATCH v3 4/6] ACPI: dock: dock_add - hoist up
	platform_device_register_simple()
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: shaohua.li@intel.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Date: Fri, 16 Oct 2009 15:15:14 -0600
Message-ID: <20091016211514.12126.61664.stgit@bob.kio>
In-Reply-To: <20091016211323.12126.58457.stgit@bob.kio>
References: <20091016211323.12126.58457.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the call to platform_device_register_simple so that we do it
before allocating and initializing our struct dock_station.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/dock.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 766eccb..939babe 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -948,11 +948,18 @@ static int dock_add(acpi_handle handle)
 	struct dock_station *dock_station;
 	struct platform_device *dock_device;
 
+	dock_device =
+		platform_device_register_simple("dock",
+			dock_station_count, NULL, 0);
+	if (IS_ERR(dock_device))
+		return PTR_ERR(dock_device);
+
 	/* allocate & initialize the dock_station private data */
 	dock_station = kzalloc(sizeof(*dock_station), GFP_KERNEL);
 	if (!dock_station)
 		return -ENOMEM;
 	dock_station->handle = handle;
+	dock_station->dock_device = dock_device;
 	dock_station->last_dock_time = jiffies - HZ;
 	INIT_LIST_HEAD(&dock_station->dependent_devices);
 	INIT_LIST_HEAD(&dock_station->hotplug_devices);
@@ -961,15 +968,6 @@ static int dock_add(acpi_handle handle)
 	mutex_init(&dock_station->hp_lock);
 	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);
 
-	/* initialize platform device stuff */
-	dock_station->dock_device =
-		platform_device_register_simple("dock",
-			dock_station_count, NULL, 0);
-	dock_device = dock_station->dock_device;
-	if (IS_ERR(dock_device)) {
-		ret = PTR_ERR(dock_device);
-		goto out;
-	}
 	platform_device_add_data(dock_device, &dock_station,
 		sizeof(struct dock_station *));
 

