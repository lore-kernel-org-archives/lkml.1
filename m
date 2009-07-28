Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbZG1XHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbZG1XHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbZG1XEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:04:07 -0400
Received: from kroah.org ([198.145.64.141]:43027 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755931AbZG1XEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:04:05 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 15:59:44 2009
Message-Id: <20090728225944.650751617@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 15:58:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Witold Szczeponik <Witold.Szczeponik@gmx.net>,
       Zhao Yakui <yakui.zhao@intel.com>, Len Brown <len.brown@intel.com>
Subject: [patch 25/37] Enable PNPACPI _PSx Support, v3
References: <20090728225828.431071451@mini.kroah.org>
Content-Disposition: inline; filename=enable-pnpacpi-_psx-support-v3.patch
In-Reply-To: <20090728230145.GA10486@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Witold Szczeponik <Witold.Szczeponik@gmx.net>

commit 6328a57401dc5f5cf9931738eb7268fcd8058c49 upstream.

(This is an update to the patch presented earlier in
http://lkml.org/lkml/2008/12/8/284, with new error handling.)

This patch sets the power of PnP ACPI devices to D0 when they
are activated and to D3 when they are disabled.  The latter is
in correspondence with the ACPI 3.0 specification, whereas the
former is added in order to be able to power up a device after
it has been previously disabled (or when booting up a system).
(As a consequence, the patch makes the PnP ACPI code more ACPI
compliant.)

Section 6.2.2 of the ACPI Specification (at least versions 1.0b
and 3.0a) states: "Prior to running this control method [_DIS],
the OS[PM] will have already put the device in the D3 state."
Unfortunately, there is no clear statement as to when to put
a device in the D0 state. :-( Therefore, the patch executes the
method calls as _PS3/_DIS and _SRS/_PS0. What is clear: "If the
device is disabled, _SRS enables the device at the specified
resources." (From the ACPI 3.0a Specification.)

The patch fixes a problem with some IBM ThinkPads (at least the
600E and the 600X) where the serial ports have a dedicated
power source that needs to be brought up before the serial port
can be used.  Without this patch, the serial port is enabled
but has no power. (In the past, the tpctl utility had to be
utilized to turn on the power, but support for this feature
stopped with version 5.9 as it did not support the more recent
kernel versions.)

The error handlers that handle any errors that can occur during
the power up/power down phases return the error codes to the
caller directly.  Comments welcome! :-)

No regressions were observed on hardware that does not require
this patch.

The patch is applied against 2.6.27.x.

Signed-off-by: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Acked-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pnp/pnpacpi/core.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -84,7 +84,6 @@ static int pnpacpi_set_resources(struct 
 	acpi_handle handle = dev->data;
 	struct acpi_buffer buffer;
 	int ret;
-	acpi_status status;
 
 	dev_dbg(&dev->dev, "set resources\n");
 	ret = pnpacpi_build_resource_template(dev, &buffer);
@@ -95,21 +94,31 @@ static int pnpacpi_set_resources(struct 
 		kfree(buffer.pointer);
 		return ret;
 	}
-	status = acpi_set_current_resources(handle, &buffer);
-	if (ACPI_FAILURE(status))
+	if (ACPI_FAILURE(acpi_set_current_resources(handle, &buffer)))
 		ret = -EINVAL;
+	else if (acpi_bus_power_manageable(handle))
+		ret = acpi_bus_set_power(handle, ACPI_STATE_D0);
 	kfree(buffer.pointer);
 	return ret;
 }
 
 static int pnpacpi_disable_resources(struct pnp_dev *dev)
 {
-	acpi_status status;
+	acpi_handle handle = dev->data;
+	int ret;
+
+	dev_dbg(&dev->dev, "disable resources\n");
 
 	/* acpi_unregister_gsi(pnp_irq(dev, 0)); */
-	status = acpi_evaluate_object((acpi_handle) dev->data,
-				      "_DIS", NULL, NULL);
-	return ACPI_FAILURE(status) ? -ENODEV : 0;
+	ret = 0;
+	if (acpi_bus_power_manageable(handle)) {
+		ret = acpi_bus_set_power(handle, ACPI_STATE_D3);
+		if (ret)
+			return ret;
+	}
+	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_DIS", NULL, NULL)))
+		ret = -ENODEV;
+	return ret;
 }
 
 #ifdef CONFIG_ACPI_SLEEP


