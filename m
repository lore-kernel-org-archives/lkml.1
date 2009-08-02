Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbZHBMG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbZHBMG4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 08:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZHBMG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 08:06:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:41911 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752444AbZHBMGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 08:06:55 -0400
X-Authenticated: #9008106
X-Provags-ID: V01U2FsdGVkX1//cW1iVaf/wbA1S9ViuUPf0deDQdRYoM+5Ag5NQf
	xEn7sQNdLInTiW
Date: Sun, 2 Aug 2009 14:06:52 +0200
From: Michael Brunner <mibru@gmx.de>
To: rui.zhang@intel.com, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] thermal_sys: check get_temp return value
Message-ID: <20090802140652.16effa08@mail.gmx.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of the get_temp function is not checked when doing a
thermal zone update. This may lead to a critical shutdown if get_temp
fails and the content of the temp variable is incorrectly set higher
than the critical trip point.
This has been observed on a system with incorrect ACPI implementation
where the corresponding methods were not serialized and therefore
sometimes triggered ACPI errors (AE_ALREADY_EXISTS). The following
critical shutdowns indicated a temperature of 2097 C, which was
obviously wrong.

The patch adds a return value check that jumps over all trip point
evaluations printing a warning if get_temp fails. The trip points are
evaluated again on the next polling interval with successful get_temp
execution.

Signed-off-by: Michael Brunner <mibru@gmx.de>

---

 drivers/thermal/thermal_sys.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 0a69672..4e83c29 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -953,7 +953,12 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
 
 	mutex_lock(&tz->lock);
 
-	tz->ops->get_temp(tz, &temp);
+	if (tz->ops->get_temp(tz, &temp)) {
+		/* get_temp failed - retry it later */
+		printk(KERN_WARNING PREFIX "failed to read out thermal zone "
+		       "%d\n", tz->id);
+		goto leave;
+	}
 
 	for (count = 0; count < tz->trips; count++) {
 		tz->ops->get_trip_type(tz, count, &trip_type);
@@ -1005,6 +1010,8 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
 					    THERMAL_TRIPS_NONE);
 
 	tz->last_temperature = temp;
+
+      leave:
 	if (tz->passive)
 		thermal_zone_device_set_polling(tz, tz->passive_delay);
 	else if (tz->polling_delay)
