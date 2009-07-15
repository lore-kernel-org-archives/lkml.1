Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbZGOQVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbZGOQVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 12:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932160AbZGOQVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 12:21:16 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:43784 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbZGOQVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 12:21:02 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Daniel Mack <daniel@caiaq.de>,
       Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Matt Reimer <mreimer@vpop.net>, Anton Vorontsov <cbou@mail.ru>
Subject: [PATCH 4/4] ds2760: handle full_active_uAh == 0 case correctly
Date: Wed, 15 Jul 2009 18:20:41 +0200
Message-Id: <1247674841-9909-4-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1247674841-9909-3-git-send-email-daniel@caiaq.de>
References: <1247674841-9909-1-git-send-email-daniel@caiaq.de>
 <1247674841-9909-2-git-send-email-daniel@caiaq.de>
 <1247674841-9909-3-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In systems where the battery monitor is not part of the battery pack and
is hence not bootstrapped with sane values, the full_active_uAh is
likely to be zero.

Handle that case by defaulting to the rated_capacity information which
can be passed to the driver using the new module parameter.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
Cc: Matt Reimer <mreimer@vpop.net>
Cc: Anton Vorontsov <cbou@mail.ru>
---
 drivers/power/ds2760_battery.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index ed0ea5e..2d0e5ed 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -172,8 +172,13 @@ static int ds2760_battery_read_status(struct ds2760_device_info *di)
 	di->full_active_uAh = di->raw[DS2760_ACTIVE_FULL] << 8 |
 			      di->raw[DS2760_ACTIVE_FULL + 1];
 
-	scale[0] = di->raw[DS2760_ACTIVE_FULL] << 8 |
-		   di->raw[DS2760_ACTIVE_FULL + 1];
+	/* If the full_active_uAh value is not given, fall back to the rated
+	 * capacity. This is likely to happen when chips are not part of the
+	 * battery pack and is therefore not bootstrapped. */
+	if (di->full_active_uAh == 0)
+		di->full_active_uAh = di->rated_capacity / 1000L;
+
+	scale[0] = di->full_active_uAh;
 	for (i = 1; i < 5; i++)
 		scale[i] = scale[i - 1] + di->raw[DS2760_ACTIVE_FULL + 2 + i];
 
-- 
1.6.3.1

