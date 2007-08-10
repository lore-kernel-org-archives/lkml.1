Return-Path: <linux-kernel-owner+w=401wt.eu-S941647AbXHJTvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941647AbXHJTvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 15:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938121AbXHJTuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 15:50:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51856 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938330AbXHJTut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 15:50:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: resume from ram much slower
Date: Fri, 10 Aug 2007 22:00:10 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200708101848.37222.arekm@maven.pl>
In-Reply-To: <200708101848.37222.arekm@maven.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708102200.10840.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 10 August 2007 18:48, Arkadiusz Miskiewicz wrote:
> Hi,
> 
> Starting 1-2 weeks ago I have very long resume from
> ram times. It takes more than 1 min to resume. Does anyone see such behaviour?
> 
> Kernel from yesterday git, thinkpad z60m, suspend.sf.net tools 20070801
> 
> "ACPI handle has no context!" are interesting btw.

Let's try to find out something.

Please apply the patch below and see if anything changes.

Greetings,
Rafael


---
 drivers/pnp/pnpacpi/core.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

Index: linux-2.6.23-rc2/drivers/pnp/pnpacpi/core.c
===================================================================
--- linux-2.6.23-rc2.orig/drivers/pnp/pnpacpi/core.c
+++ linux-2.6.23-rc2/drivers/pnp/pnpacpi/core.c
@@ -130,11 +130,21 @@ static int pnpacpi_disable_resources(str
 #ifdef CONFIG_ACPI_SLEEP
 static int pnpacpi_suspend(struct pnp_dev *dev, pm_message_t state)
 {
-	return acpi_bus_set_power((acpi_handle) dev->data,
-				  acpi_pm_device_sleep_state(&dev->dev,
-							     device_may_wakeup
-							     (&dev->dev),
-							     NULL));
+	int power_state;
+
+	power_state = acpi_pm_device_sleep_state(&dev->dev,
+						device_may_wakeup(&dev->dev),
+						NULL);
+
+	if (power_state < 0) {
+		printk(KERN_ERR
+			"%s: Could not choose power state for device!\n",
+			dev->name);
+		power_state = (state.event == PM_EVENT_ON) ?
+				ACPI_STATE_D0 : ACPI_STATE_D3;
+	}
+
+	return acpi_bus_set_power((acpi_handle) dev->data, power_state);
 }
 
 static int pnpacpi_resume(struct pnp_dev *dev)


