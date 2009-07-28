Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbZG1XGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbZG1XGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbZG1XEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:04:08 -0400
Received: from kroah.org ([198.145.64.141]:43034 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755763AbZG1XEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:04:06 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 15:59:44 2009
Message-Id: <20090728225944.805987676@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 15:58:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <len.brown@intel.com>
Subject: [patch 26/37] ACPI: suspend: dont let device _PS3 failure prevent suspend
References: <20090728225828.431071451@mini.kroah.org>
Content-Disposition: inline; filename=acpi-suspend-don-t-let-device-_ps3-failure-prevent-suspend.patch
In-Reply-To: <20090728230145.GA10486@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Len Brown <len.brown@intel.com>

commit 19bde778c1fd2574cc020a618d7d576f260271ca upstream.

6328a57401dc5f5cf9931738eb7268fcd8058c49
"Enable PNPACPI _PSx Support, v3"

added a call to acpi_bus_set_power(handle, ACPI_STATE_D3)
to pnpacpi_disable_resource() before the existing call
to evaluate _DIS on the device.

This caused suspend to fail on the system in
http://bugzilla.kernel.org/show_bug.cgi?id=13243
because the sanity check to verify we entered _PS3
failed on the serial port.

As a work-around, that sanity check can be disabled
system-wide with "acpi.power_nocheck=1"

Or perhaps we should just shrug off the _PS3 failure
and carry on with _DIS like we used to -- which is
what this patch does.

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pnp/pnpacpi/core.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -111,11 +111,9 @@ static int pnpacpi_disable_resources(str
 
 	/* acpi_unregister_gsi(pnp_irq(dev, 0)); */
 	ret = 0;
-	if (acpi_bus_power_manageable(handle)) {
-		ret = acpi_bus_set_power(handle, ACPI_STATE_D3);
-		if (ret)
-			return ret;
-	}
+	if (acpi_bus_power_manageable(handle))
+		acpi_bus_set_power(handle, ACPI_STATE_D3);
+		/* continue even if acpi_bus_set_power() fails */
 	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_DIS", NULL, NULL)))
 		ret = -ENODEV;
 	return ret;


