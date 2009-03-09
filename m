Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZCIPxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZCIPxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 11:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbZCIPxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 11:53:38 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:45684 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbZCIPxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 11:53:37 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Matt Reimer <mreimer@vpop.net>, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] ds2760_battery.c: fix division by zero
Date: Mon,  9 Mar 2009 16:53:22 +0100
Message-Id: <1236614002-9102-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'battery remaining capacity' calculation in
drivers/power/ds2760_battery.c lacks a parameter check to a division
operation which causes the kernel to oops on my board.

[   21.233750] Division by zero in kernel.
[   21.237646] [<c002955c>] (__div0+0x0/0x20) from [<c012561c>] (Ldiv0+0x8/0x10)
[   21.244816] [<c01bef34>] (ds2760_battery_read_status+0x0/0x2a4) from [<c01bf3a4>] (ds2760_battery_get_property+0x30/0xdc)
[   21.255803]  r8:c03a22c0 r7:c7886100 r6:00000009 r5:c782fe7c r4:c7886084
[   21.262518] [<c01bf374>] (ds2760_battery_get_property+0x0/0xdc) from [<c01bde98>] (power_supply_show_property+0x48/0x114)
[   21.273480]  r6:c7996000 r5:00000009 r4:00000000
[   21.278111] [<c01bde50>] (power_supply_show_property+0x0/0x114) from [<c01be158>] (power_supply_uevent+0x188/0x280)
[   21.288537]  r8:00000001 r7:c7886100 r6:c7996000 r5:000000b4 r4:00000000
[   21.295222] [<c01bdfd0>] (power_supply_uevent+0x0/0x280) from [<c015c664>] (dev_uevent+0xd4/0x10c)
[   21.304199] [<c015c590>] (dev_uevent+0x0/0x10c) from [<c0128440>] (kobject_uevent_env+0x180/0x390)
[   21.313170]  r5:00000000 r4:c78860ac
[   21.316725] [<c01282c0>] (kobject_uevent_env+0x0/0x390) from [<c0128664>] (kobject_uevent+0x14/0x18)
[   21.325850] [<c0128650>] (kobject_uevent+0x0/0x18) from [<c01bdc34>] (power_supply_changed_work+0x5c/0x70)
[   21.335506] [<c01bdbd8>] (power_supply_changed_work+0x0/0x70) from [<c004d290>] (run_workqueue+0xbc/0x144)
[   21.345167]  r4:c7812040
[   21.347716] [<c004d1d4>] (run_workqueue+0x0/0x144) from [<c004d94c>] (worker_thread+0xa8/0xbc)
[   21.356296]  r7:c7812040 r6:c7820b00 r5:c782ffa4 r4:c7812048
[   21.361957] [<c004d8a4>] (worker_thread+0x0/0xbc) from [<c0051008>] (kthread+0x5c/0x94)
[   21.369971]  r7:00000000 r6:c004d8a4 r5:c7812040 r4:c782e000
[   21.375612] [<c0050fac>] (kthread+0x0/0x94) from [<c00403d0>] (do_exit+0x0/0x688)

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
Cc: Matt Reimer <mreimer@vpop.net>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/power/ds2760_battery.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index 1d76892..a52d4a1 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -180,10 +180,13 @@ static int ds2760_battery_read_status(struct ds2760_device_info *di)
 	di->empty_uAh = battery_interpolate(scale, di->temp_C / 10);
 	di->empty_uAh *= 1000; /* convert to µAh */
 
-	/* From Maxim Application Note 131: remaining capacity =
-	 * ((ICA - Empty Value) / (Full Value - Empty Value)) x 100% */
-	di->rem_capacity = ((di->accum_current_uAh - di->empty_uAh) * 100L) /
-			    (di->full_active_uAh - di->empty_uAh);
+	if (di->full_active_uAh == di->empty_uAh)
+		di->rem_capacity = 0;
+	else
+		/* From Maxim Application Note 131: remaining capacity =
+		 * ((ICA - Empty Value) / (Full Value - Empty Value)) x 100% */
+		di->rem_capacity = ((di->accum_current_uAh - di->empty_uAh) * 100L) /
+				    (di->full_active_uAh - di->empty_uAh);
 
 	if (di->rem_capacity < 0)
 		di->rem_capacity = 0;
-- 
1.6.1.3

