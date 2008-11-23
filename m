Return-Path: <linux-kernel-owner+w=401wt.eu-S1752404AbYKWVJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbYKWVJV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 16:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbYKWVJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 16:09:12 -0500
Received: from mail.gmx.net ([213.165.64.20]:53995 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751000AbYKWVJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 16:09:11 -0500
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX1/uIZMv46fu9WgF33YuQij+2qLpR86tKQkX78jCTr
	2xmKFTz1Ps4Ift
Message-ID: <4929C66F.1040206@gmx.net>
Date: Sun, 23 Nov 2008 22:09:03 +0100
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] PNPACPI: Enable Power Management
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Enable PNPACI Power Management

This patch sets the power of PnP ACPI devices to D0 when they
are activated and to D3 when they are disabled.  The latter is
in correspondence with the ACPI 3.0 specification, whereas the
former is added in order to be able to power up a device after
it has been previously disabled (or when booting up a system).
(As a consequence, the patch makes the PnP ACPI code more ACPI
compliant.)

The patch fixes the problem with some IBM ThinkPads (at least
the 600E and the 600X) where the serial ports have a dedicated
power source that needs to be brought up before the serial port
can be used.  Without this patch, the serial port is enabled
but has no power.

No regressions were observed on hardware that does not require
this patch.

The patch is applied against 2.6.27.7 (vanilla).


Signed-off-by: Witold Szczeponik <Witold.Szczeponik@gmx.net>


Index: linux/drivers/pnp/pnpacpi/core.c
===================================================================
--- linux.orig/drivers/pnp/pnpacpi/core.c
+++ linux/drivers/pnp/pnpacpi/core.c
@@ -98,18 +98,24 @@ static int pnpacpi_set_resources(struct
  	status = acpi_set_current_resources(handle, &buffer);
  	if (ACPI_FAILURE(status))
  		ret = -EINVAL;
+	else if (acpi_bus_power_manageable(handle))
+		ret = acpi_bus_set_power(handle, ACPI_STATE_D0);
  	kfree(buffer.pointer);
  	return ret;
  }

  static int pnpacpi_disable_resources(struct pnp_dev *dev)
  {
+	acpi_handle handle = dev->data;
+	int ret = 0;
  	acpi_status status;

-	/* acpi_unregister_gsi(pnp_irq(dev, 0)); */
-	status = acpi_evaluate_object((acpi_handle) dev->data,
-				      "_DIS", NULL, NULL);
-	return ACPI_FAILURE(status) ? -ENODEV : 0;
+	if (acpi_bus_power_manageable(handle))
+		ret = acpi_bus_set_power(handle, ACPI_STATE_D3);
+	status = acpi_evaluate_object(handle, "_DIS", NULL, NULL);
+	if (ACPI_FAILURE(status))
+		ret = -ENODEV;
+	return ret;
  }

  #ifdef CONFIG_ACPI_SLEEP
