Return-Path: <linux-kernel-owner+w=401wt.eu-S1752150AbXKMIff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbXKMIff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 03:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbXKMIfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 03:35:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:7522 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbXKMIfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 03:35:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=N/9VRiJqt5Q0JsGnHrGGggloqMzsX6nVumKStVTpS6I4uFto3anlDt54tIKplck9JoBWkPKU4jhexCXIJR3IPEesJO3EWfN7g7dn4lZXrQrk5Km5kGpcgZ3IiZd544e0w3Mj7z86C5291KXf2hsN9qw6kuAzanfv0AN6V0Nytzw=
Message-ID: <473961C6.4090407@gmail.com>
Date: Tue, 13 Nov 2007 11:35:18 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alexey Starikovskiy <astarikovskiy@suse.de>, rjw@sisk.pl,
       hannes-kernel@saeurebad.de, listen@selfservix.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.24-rc1: OOPS at  acpi_battery_update
References: <1193652664.22149.4.camel@localhost>	<200711050118.34610.rjw@sisk.pl>	<20071108155344.GA12231@cataract>	<200711081717.00421.rjw@sisk.pl>	<47333ACB.6070408@suse.de>	<20071108203451.1b7f28c0.akpm@linux-foundation.org>	<47342A2B.5020006@suse.de> <20071109014944.26adf4e0.akpm@linux-foundation.org>
In-Reply-To: <20071109014944.26adf4e0.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------090004060908070208070501"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090004060908070208070501
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andrew,

I can not contact with Len for several days, while the oops on battery 
seems quite important.
It also seem to behave well in -mm tree (as part of Len's acpi-test).
Will you send this patch to Linus without approval from Len or should I?

Thanks,
Alex.

Andrew Morton wrote:
> On Fri, 09 Nov 2007 12:36:43 +0300 Alexey Starikovskiy <astarikovskiy@suse.de> wrote:
>
>   
>> Andrew Morton wrote:
>>     
>>> A> On Thu, 08 Nov 2007 19:35:23 +0300 Alexey Starikovskiy <astarikovskiy@suse.de> wrote:
>>>       
>>>> [remove_cycle_at_battery_removal.patch  text/x-patch (1.7KB)]
>>>> ACPI: Battery: remove cycle from battery removal.
>>>>
>>>> From: Alexey Starikovskiy <astarikovskiy@suse.de>
>>>>
>>>> get_property() should not call battery_update() on absent battery to
>>>> avoid cycle and oops.
>>>>
>>>> Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
>>>> Tested-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
>>>>         
>>> A patch similar to this one but with an identical changelog was merged into
>>> Len's tree on November 2.
>>>
>>> If it had been promptly merged into mainline then quite a lot of people's
>>> time would not have been wasted.
>>>
>>>       
>> Andrew,
>> should I send such patches directly to you/Linus?
>>
>>     
>
> Well if Len doesn't object and you're confident in the changes, why not? 
> Any time we leave bugs unfixed we drive away testers and that impacts all
> parts of the kernel.
>
>   


--------------090004060908070208070501
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

--------------090004060908070208070501--
