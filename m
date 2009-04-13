Return-Path: <linux-kernel-owner+w=401wt.eu-S1752315AbZDMRoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbZDMRoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 13:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbZDMRnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 13:43:51 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2799 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbZDMRnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 13:43:49 -0400
Subject: Re: [BISECTED] 20 ACPI interrupts per second on EEEPC 4G
From: Joe Perches <joe@perches.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       yakui_zhao <yakui.zhao@intel.com>, Zhang Rui <rui.zhang@intel.com>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <20090413170531.GA13188@srcf.ucam.org>
References: <49DF6835.9040501@tuffmail.co.uk> <49DFE345.3010109@gmail.com>
	 <49E05F83.2090500@tuffmail.co.uk> <49E20EBA.2090708@tuffmail.co.uk>
	 <1239588248.5564.19.camel@localhost.localdomain>
	 <49E3085D.3060403@tuffmail.co.uk>  <20090413170531.GA13188@srcf.ucam.org>
Content-Type: text/plain
Date: Mon, 13 Apr 2009 10:43:31 -0700
Message-Id: <1239644611.32203.37.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-13 at 18:05 +0100, Matthew Garrett wrote:
> Ok, I think I've got it. Does this fix things? Ridiculous thinko...
> 
> diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
> index 9cd15e8..564ea14 100644
> --- a/drivers/acpi/thermal.c
> +++ b/drivers/acpi/thermal.c
> @@ -909,7 +909,7 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
>  			thermal_zone_device_register("acpitz", trips, tz,
>  						     &acpi_thermal_zone_ops,
>  						     0, 0, 0,
> -						     tz->polling_frequency);
> +						     tz->polling_frequency*100);
>  	if (IS_ERR(tz->thermal_zone))
>  		return -ENODEV;

Perhaps this is clearer?
It also makes cleans up a for loop with a naked ;

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 9cd15e8..e8a6490 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -883,6 +880,10 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
 	int result;
 	acpi_status status;
 	int i;
+	int tc1;
+	int tc2;
+	int passive_delay;
+	int polling_delay;
 
 	if (tz->trips.critical.flags.valid)
 		trips++;
@@ -894,22 +895,25 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
 		trips++;
 
 	for (i = 0; i < ACPI_THERMAL_MAX_ACTIVE &&
-			tz->trips.active[i].flags.valid; i++, trips++);
+		    tz->trips.active[i].flags.valid; i++)
+		trips++;
 
-	if (tz->trips.passive.flags.valid)
-		tz->thermal_zone =
-			thermal_zone_device_register("acpitz", trips, tz,
-						     &acpi_thermal_zone_ops,
-						     tz->trips.passive.tc1,
-						     tz->trips.passive.tc2,
-						     tz->trips.passive.tsp*100,
-						     tz->polling_frequency*100);
-	else
-		tz->thermal_zone =
-			thermal_zone_device_register("acpitz", trips, tz,
-						     &acpi_thermal_zone_ops,
-						     0, 0, 0,
-						     tz->polling_frequency);
+	if (tz->trips.passive.flags.valid) {
+		tc1 = tz->trips.passive.tc1;
+		tc2 = tz->trips.passive.tc2;
+		passive_delay = tz->trips.passive.tsp * 100;
+	} else {
+		tc1 = 0;
+		tc2 = 0;
+		passive_delay = 0;
+	}
+	polling_delay = tz->polling_frequency * 100;
+
+	tz->thermal_zone =
+		thermal_zone_device_register("acpitz", trips, tz,
+					     &acpi_thermal_zone_ops,
+					     tc1, tc2, passive_delay,
+					     polling_delay);
 	if (IS_ERR(tz->thermal_zone))
 		return -ENODEV;
 


