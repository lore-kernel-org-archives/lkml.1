Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936513Ab0CMBcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:32:10 -0500
Received: from kroah.org ([198.145.64.141]:60621 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934767Ab0CMATs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:48 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:07 2010
Message-Id: <20100313001507.276320593@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Hank Janssen <hjanssen@microsoft.com>
Subject: [patch 024/123] Staging: hv: match on DMI values to know if we should run.
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit c22090facd354749cfe99a46e903449c7ac07788 upstream.

The HV core mucks around with specific irqs and other low-level stuff
and takes forever to determine that it really shouldn't be running on a
machine.  So instead, trigger off of the DMI system information and
error out much sooner.  This also allows the module loading tools to
recognize that this code should be loaded on this type of system.

Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/vmbus_drv.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -25,6 +25,7 @@
 #include <linux/interrupt.h>
 #include <linux/sysctl.h>
 #include <linux/pci.h>
+#include <linux/dmi.h>
 #include "osd.h"
 #include "logging.h"
 #include "vmbus.h"
@@ -947,6 +948,19 @@ static irqreturn_t vmbus_isr(int irq, vo
 	}
 }
 
+static struct dmi_system_id __initdata microsoft_hv_dmi_table[] = {
+	{
+		.ident = "Hyper-V",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
+			DMI_MATCH(DMI_BOARD_NAME, "Virtual Machine"),
+		},
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(dmi, microsoft_hv_dmi_table);
+
 static int __init vmbus_init(void)
 {
 	int ret = 0;
@@ -958,6 +972,9 @@ static int __init vmbus_init(void)
 		vmbus_loglevel, HIWORD(vmbus_loglevel), LOWORD(vmbus_loglevel));
 	/* Todo: it is used for loglevel, to be ported to new kernel. */
 
+	if (!dmi_check_system(microsoft_hv_dmi_table))
+		return -ENODEV;
+
 	ret = vmbus_bus_init(VmbusInitialize);
 
 	DPRINT_EXIT(VMBUS_DRV);
@@ -979,10 +996,6 @@ static void __exit vmbus_exit(void)
  * needed by distro tools to determine if the hyperv drivers should be
  * installed and/or configured.  We don't do anything else with the table, but
  * it needs to be present.
- *
- * We might consider triggering off of DMI table info as well, as that does
- * decribe the virtual machine being run on, but not all configuration tools
- * seem to be able to handle DMI device ids properly.
  */
 const static struct pci_device_id microsoft_hv_pci_table[] = {
 	{ PCI_DEVICE(0x1414, 0x5353) },	/* VGA compatible controller */


