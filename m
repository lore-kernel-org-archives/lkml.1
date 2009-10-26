Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbZJZHkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbZJZHkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbZJZHkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:40:05 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:53799 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754892AbZJZHjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:39:04 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Frans Pop <elendil@planet.nl>,
       Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 5/6] thermal: Only set passive_delay for forced_passive cooling
Date: Mon, 26 Oct 2009 08:39:03 +0100
Message-Id: <1256542744-26569-6-git-send-email-elendil@planet.nl>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1256542744-26569-1-git-send-email-elendil@planet.nl>
References: <1256542744-26569-1-git-send-email-elendil@planet.nl>
X-OriginalArrivalTime: 26 Oct 2009 07:39:06.0127 (UTC) FILETIME=[658629F0:01CA560F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting polling_delay is useless as passive_delay has priority,
so the value shown in proc isn't the actual polling delay. It
also gives the impression to the user that he can change the
polling interval through proc, while in fact he can't.

Also, unset passive_delay when the forced passive trip point is
unbound to allow polling to be disabled.

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: Matthew Garrett <mjg@redhat.com>
Cc: Zhang Rui <rui.zhang@intel.com>
---
 drivers/thermal/thermal_sys.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 74d2eb5..fc5e92e 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -241,6 +241,8 @@ passive_store(struct device *dev, struct device_attribute *attr,
 								 cdev);
 		}
 		mutex_unlock(&thermal_list_lock);
+		if (!tz->passive_delay)
+			tz->passive_delay = 1000;
 	} else if (!state && tz->forced_passive) {
 		mutex_lock(&thermal_list_lock);
 		list_for_each_entry(cdev, &thermal_cdev_list, node) {
@@ -251,17 +253,12 @@ passive_store(struct device *dev, struct device_attribute *attr,
 								   cdev);
 		}
 		mutex_unlock(&thermal_list_lock);
+		tz->passive_delay = 0;
 	}
 
 	tz->tc1 = 1;
 	tz->tc2 = 1;
 
-	if (!tz->passive_delay)
-		tz->passive_delay = 1000;
-
-	if (!tz->polling_delay)
-		tz->polling_delay = 10000;
-
 	tz->forced_passive = state;
 
 	thermal_zone_device_update(tz);
-- 
1.5.6.5

