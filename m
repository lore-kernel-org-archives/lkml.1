Return-Path: <linux-kernel-owner+w=401wt.eu-S1761015AbXKHQfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761015AbXKHQfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 11:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbXKHQfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 11:35:45 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:36874 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753417AbXKHQfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 11:35:44 -0500
Message-ID: <47333ACB.6070408@suse.de>
Date: Thu, 08 Nov 2007 19:35:23 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Johannes Weiner <hannes-kernel@saeurebad.de>,
       "Michael (rabenkind) Brandstetter" <listen@selfservix.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: 2.6.24-rc1: OOPS at  acpi_battery_update
References: <1193652664.22149.4.camel@localhost> <200711050118.34610.rjw@sisk.pl> <20071108155344.GA12231@cataract> <200711081717.00421.rjw@sisk.pl>
In-Reply-To: <200711081717.00421.rjw@sisk.pl>
Content-Type: multipart/mixed;
 boundary="------------070208020201070007060406"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070208020201070007060406
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Rafael J. Wysocki wrote:
> On Thursday, 8 of November 2007, Johannes Weiner wrote:
>> Hi,
>>
>> is there any reason, why acpi_battery_get_property() should call
>> acpi_battery_update() at all?
> 
> Alex?
Do you mean "why should it call _whole_ battery update?" ?
get_state should be sufficient in order to not get stale data.

Regards,
Alex.

--------------070208020201070007060406
Content-Type: text/x-patch;
 name="remove_cycle_at_battery_removal.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="remove_cycle_at_battery_removal.patch"

ACPI: Battery: remove cycle from battery removal.

From: Alexey Starikovskiy <astarikovskiy@suse.de>

get_property() should not call battery_update() on absent battery to
avoid cycle and oops.

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Tested-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---

 drivers/acpi/battery.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index c2ce0ad..192c244 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -132,7 +132,7 @@ static int acpi_battery_technology(struct acpi_battery *battery)
 	return POWER_SUPPLY_TECHNOLOGY_UNKNOWN;
 }
 
-static int acpi_battery_update(struct acpi_battery *battery);
+static int acpi_battery_get_state(struct acpi_battery *battery);
 
 static int acpi_battery_get_property(struct power_supply *psy,
 				     enum power_supply_property psp,
@@ -140,10 +140,11 @@ static int acpi_battery_get_property(struct power_supply *psy,
 {
 	struct acpi_battery *battery = to_acpi_battery(psy);
 
-	if ((!acpi_battery_present(battery)) &&
-	     psp != POWER_SUPPLY_PROP_PRESENT)
+	if (acpi_battery_present(battery)) {
+		/* run battery update only if it is present */
+		acpi_battery_get_state(battery);
+	} else if (psp != POWER_SUPPLY_PROP_PRESENT)
 		return -ENODEV;
-	acpi_battery_update(battery);
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
 		if (battery->state & 0x01)
@@ -457,6 +458,7 @@ static void sysfs_remove_battery(struct acpi_battery *battery)
 		return;
 	device_remove_file(battery->bat.dev, &alarm_attr);
 	power_supply_unregister(&battery->bat);
+	battery->bat.dev = NULL;
 }
 
 static int acpi_battery_update(struct acpi_battery *battery)

--------------070208020201070007060406--
