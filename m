Return-Path: <linux-kernel-owner+w=401wt.eu-S934113AbZJNWrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934113AbZJNWrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762108AbZJNWrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:47:11 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:36499 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759008AbZJNWrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:47:08 -0400
Subject: [PATCH v2 4/6] ACPI: dock: dock_add - hoist up
	platform_device_register_simple()
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: shaohua.li@intel.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Date: Wed, 14 Oct 2009 16:46:31 -0600
Message-ID: <20091014224631.18044.16762.stgit@bob.kio>
In-Reply-To: <20091014224415.18044.88208.stgit@bob.kio>
References: <20091014224415.18044.88208.stgit@bob.kio>
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

 drivers/acpi/dock.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index e57be55..363be0a 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -935,11 +935,19 @@ static int dock_add(acpi_handle handle)
 	struct dock_station *dock_station;
 	struct platform_device *dock_device;
 
+	dock_device =
+		platform_device_register_simple("dock",
+			dock_station_count, NULL, 0);
+	ret = IS_ERR(dock_device) ? PTR_ERR(dock_device) : 0;
+	if (ret)
+		return ret;
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
@@ -948,14 +956,6 @@ static int dock_add(acpi_handle handle)
 	mutex_init(&dock_station->hp_lock);
 	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);
 
-	/* initialize platform device stuff */
-	dock_station->dock_device =
-		platform_device_register_simple("dock",
-			dock_station_count, NULL, 0);
-	dock_device = dock_station->dock_device;
-	ret = IS_ERR(dock_device) ? PTR_ERR(dock_device) : 0;
-	if (ret)
-		goto out;
 	platform_device_add_data(dock_device, &dock_station,
 		sizeof(struct dock_station *));
 

