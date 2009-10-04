Return-Path: <linux-kernel-owner+w=401wt.eu-S1757171AbZJDPY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbZJDPY5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 11:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbZJDPY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 11:24:56 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:59786 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbZJDPYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 11:24:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=x9Bvxx56PRscgPdiFXzHl362aYO+jIhiMVDtWjn/P8Je2y8teHJSMJq7uTg3q3DUwT
         aCm6z/t7683+d0wIPf5OGMntCivpg02Tn2rn5YvhfdM46K9ron0q2l62zQgrK8Xk/494
         ySlwIfaJWo01CUYUik2jpNIahVCC7ZZT1zYZY=
Subject: [PATCH] battery: Fix charge_now returned by broken batteries
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: astarikovskiy@suse.de
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sun, 04 Oct 2009 17:24:13 +0200
Message-Id: <1254669853.26496.0.camel@carter>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some broken batteries like my DELL NR2227 or a friend's DELL GK4798 return
the design_capacity (charge_full_design) as capacity_now (charge_now)
when completely charged.

I noticed this when looking at a battery plugin that reported "127% charged".
Some of these plugins have already "fixed" this in userspace by coding
something like min(percentage, 100)).

Reading /sys/class/power_supply/BAT0/* my battery reported:

	charge_full = 5980000
	charge_full_design = 7650000

I let my battery discharge a little bit and then I started charging it.
At the same time, I read charge_now every second:

...
5850000 (charging)
5850000 (charging)
5850000 (charging)
...
5900000 (charging)
5900000 (charging)
5900000 (charging)
...
5950000 (charging)
5950000 (charging)
5950000 (charging)
7650000 (charged)
7650000 (charged)
7650000 (charged)
7650000 (charged)
...

So I discovered that the battery wrongly returns charge_full_design when
completely charged instead of charge_full.

This patch fixes this by returning min(capacity_now, full_charge_capacity)
on both procfs and sysfs.

Now the userspace plugins report the correct 100% and their userspace check
may not be needed (if this error is the only one producing >100% results).

Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
---
 drivers/acpi/battery.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- linux-2.6.31.1/drivers/acpi/battery.c.old	2009-10-04 15:50:37.743999621 +0200
+++ linux-2.6.31.1/drivers/acpi/battery.c	2009-10-04 16:33:47.843696066 +0200
@@ -210,7 +210,10 @@ static int acpi_battery_get_property(str
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_NOW:
 	case POWER_SUPPLY_PROP_ENERGY_NOW:
-		val->intval = battery->capacity_now * 1000;
+		/* broken batteries return the design_capacity
+		as capacity_now when completely charged */
+		val->intval = min(battery->capacity_now,
+				  battery->full_charge_capacity) * 1000;
 		break;
 	case POWER_SUPPLY_PROP_MODEL_NAME:
 		val->strval = battery->model_number;
@@ -617,8 +620,12 @@ static int acpi_battery_print_state(stru
 	if (battery->capacity_now == ACPI_BATTERY_VALUE_UNKNOWN)
 		seq_printf(seq, "remaining capacity:      unknown\n");
 	else
+		/* broken batteries return the design_capacity
+		as capacity_now when completely charged */
 		seq_printf(seq, "remaining capacity:      %d %sh\n",
-			   battery->capacity_now, acpi_battery_units(battery));
+			   min(battery->capacity_now,
+			       battery->full_charge_capacity),
+			   acpi_battery_units(battery));
 	if (battery->voltage_now == ACPI_BATTERY_VALUE_UNKNOWN)
 		seq_printf(seq, "present voltage:         unknown\n");
 	else


